; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1356
; Author: Clipper (updated for PB 4.00 by Andre)
; Date: 24. December 2004
; OS: Windows
; Demo: No

; This Code works for me, also with large Attachments. 
; You can send your mail with SMTP-Auth or - if you leave the Username 
; blank- regular. 
; To implement POP before SMTP as another Login-Mechanism would be easy. 
; Ok, a timeout would be nice. 

; Mit dem folgenden Code kann ich per SMTP-Auth oder auch ganz normal 
; ohne Login Mails auch mit längeren Attachments versenden. 
; (normal=Username leer). 
; Etwas eigenartig musste ich die Proc SendFiles() schreiben. Ich hätte 
; gerne die Schleife 
;   For i=0 To OutputBufferLength/60 
; geschrieben. Leider fehlt dann in der Ausgabe die erste Zeile. Das 
; erste Byte ist dann 0!? 
; PeekS(*memout+1,60) liefert ein korrektes Ergebnis allerdings mit 
; fehlendem ersten Zeichen. 
; 
; Vielleicht weiss hier ja jemand wie man die ganze Geschichte weiter 
; optimieren kann. Ein Timeout währe ja auch nicht schlecht oder sogar 
; Status-Events. Leider bin ich nicht ganz so fit in diesen Dingen. 
; 
; Teile werdet Ihr bestimmt wiedererkennen, sie sind aus den Foren bzw.
; dem Code-Archiv. 


Global ConnectionID.l 
Global CrLf.s 
CrLf.s=Chr(13)+Chr(10) 

Enumeration 
#eHlo 
#RequestAuthentication 
#Username 
#Password 
#MailFrom 
#RcptTo 
#Data 
#Quit 
#Complete 
EndEnumeration 

Global NewList Attachments.s() 
InsertElement(Attachments()) 
Attachments() = "c:\afile.htm" 
;InsertElement(Attachments()) 
;Attachments() = "c:\another.jpg" 

Declare.s Base64Encode(strText.s) 
Declare SendFiles() 
Declare.s GetMIMEType(Extension.s) 
Declare Send(msg.s) 
Declare SendESMTPMail(name.s,sender.s,recipient.s,username.s,password.s,smtpserver.s,subject.s,body.s) 



;Sending Mail with SMTP-AUTH 
sendesmtpmail("Clipper","my@email.com","your@email.com","username","password","auth.smtp.mailserver.com","Hallo","This is the body") 


; Don´t fill the Username if you want to sent regular 
;sendesmtpmail("Clipper","my@email.com","your@email.com","","","smtp.mailserver.com","Hallo","This is the body") 

Procedure SendESMTPMail(name.s,sender.s,recipient.s,username.s,password.s,smtpserver.s,subject.s,body.s) 
    If InitNetwork() 
       ConnectionID = OpenNetworkConnection(smtpserver, 25) 
       If ConnectionID 
          loop250.l=0 
          Repeat    
             If NetworkClientEvent(ConnectionID) 
                ReceivedData.s=Space(256) 
                ct=ReceiveNetworkData(ConnectionID ,@ReceivedData,256) 
                If ct 
                   cmdID.s=Left(ReceivedData,3) 
                   cmdText.s=Mid(ReceivedData,5,ct-6) 
                   Debug "<" + cmdID + " " + cmdText 
                   Select cmdID 
                      Case "220" 
                         If Len(username)>0 
                            Send("Ehlo " + Hostname()) 
                            state=#eHlo 
                         Else 
                            send("HELO " + Hostname()) 
                            state=#MailFrom 
                         EndIf    
                      Case "221" 
                         send("[connection closed]") 
                         state=#Complete 
                         quit=1      
                      Case "235" 
                         Send("MAIL FROM: <" + sender + ">") 
                         state=#RcptTo 
                        
                      Case "334" 
                         If state=#RequestAuthentication 
                            Send(Base64Encode(username)) 
                            state=#Username 
                         EndIf 
                         If state=#Username 
                            Send(Base64Encode(password)) 
                            state=#Password 
                         EndIf 
    
                      Case "250" 
                         Select state 
                            Case #eHlo 
                               send("AUTH LOGIN") 
                               state=#RequestAuthentication      
                            Case #MailFrom    
                               Send("MAIL FROM: <" + sender + ">") 
                               state=#RcptTo 
                            Case #RcptTo 
                               Send("RCPT TO: <" + recipient + ">") 
                               state=#Data 
                            Case #Data 
                               Send("DATA") 
                               state=#QUIT 
                            Case #QUIT 
                               Send("QUIT") 
                         EndSelect 
                  
                      Case "251" 
                            Send("DATA") 
                            state=#Data 
                      Case "354" 
                         send("X-Mailer: eSMTP 1.0") 
                         send("To: " + recipient) 
                         send("From: " + name + " <" + sender + ">") 
                         send("Reply-To: "+sender) 
                         send("Date:" + FormatDate("%dd/%mm/%yyyy @ %hh:%ii:%ss", Date()) ) 
                         send("Subject: " + Subject) 
                         send("MIME-Version: 1.0") 
                         send("Content-Type: multipart/mixed; boundary="+Chr(34)+"MyBoundary"+Chr(34)) 
                         Send("") 
                         send("--MyBoundary") 
                         Send("Content-Type: text/plain; charset=us-ascii") 
                         Send("Content-Transfer-Encoding: 7bit") 
                         send("")                      
                         Send(body.s) 
                         SendFiles() 
                         send("--MyBoundary--") 
                         Send(".") 
                  
                      Case "550" 
                            
                         quit=1      
                   EndSelect 
                EndIf 
             EndIf 
              
          Until Quit = 1 
          CloseNetworkConnection(ConnectionID) 
          MessageRequester("","Ende") 
       EndIf 
    EndIf          
EndProcedure 

Procedure Send(msg.s) 
    ;Delay(10) 
    Debug "> " + msg 
    msg+crlf.s 
    SendNetworkData(ConnectionID, @msg, Len(msg)) 
EndProcedure 


Procedure SendFiles() 
    ResetList(Attachments()) 
    While(NextElement(Attachments())) 
    file.s=Attachments() 
    Send("") 
    If ReadFile(0,file.s) 
       Debug file 
       InputBufferLength.l = Lof(0) 
       OutputBufferLength.l = InputBufferLength * 1.4 
       *memin=AllocateMemory(InputBufferLength) 
       If *memin 
          *memout=AllocateMemory(OutputBufferLength) 
          If *memout 
             Boundry.s = "--MyBoundary" 
             Send(Boundry) 
             Send("Content-Type: "+GetMIMEType(GetExtensionPart(file.s)) + "; name=" + Chr(34) + GetFilePart(file.s) + Chr(34)) 
             send("Content-Transfer-Encoding: base64") 
             send("Content-Disposition: Attachment; filename=" + Chr(34) + GetFilePart(file) + Chr(34)) 
             send("") 
             ReadData(0, *memin,InputBufferLength) 
             Base64Encoder(*memin,60,*memout,OutputBufferLength) 
             send(PeekS(*memout,60)) ; this must be done because For i=0 To OutputBufferLength/60 doesn´t work 
             Base64Encoder(*memin,InputBufferLength,*memout,OutputBufferLength)                
             For i=1 To OutputBufferLength/60 
                 temp.s=Trim(PeekS(*memout+i*60,60)) 
                 If Len(temp)>0 
                  send(temp) 
                 EndIf 
             Next 
          EndIf 
       EndIf 
       FreeMemory(-1) 
       CloseFile(0) 
    EndIf 
    Wend 
    ProcedureReturn 
EndProcedure 


Procedure.s Base64Encode(strText.s) 
    Define.s Result 
    *B64EncodeBufferA = AllocateMemory(Len(strText)+1) 
    *B64EncodeBufferB = AllocateMemory((Len(strText)*3)+1) 
    PokeS(*B64EncodeBufferA, strText) 
    Base64Encoder(*B64EncodeBufferA, Len(strText), *B64EncodeBufferB, Len(strText)*3) 
    Result = PeekS(*B64EncodeBufferB) 
    FreeMemory(-1) 
    ProcedureReturn Result 
EndProcedure 


Procedure.s GetMIMEType(Extension.s) 
    Extension = "." + Extension 
    hKey.l = 0 
    KeyValue.s = Space(255) 
    DataSize.l = 255 
    If RegOpenKeyEx_(#HKEY_CLASSES_ROOT, Extension, 0, #KEY_READ, @hKey) 
        KeyValue = "application/octet-stream" 
    Else 
        If RegQueryValueEx_(hKey, "Content Type", 0, 0, @KeyValue, @DataSize) 
            KeyValue = "application/octet-stream" 
        Else 
            KeyValue = Left(KeyValue, DataSize-1) 
        EndIf 
        RegCloseKey_(hKey) 
    EndIf 
    ProcedureReturn KeyValue 
EndProcedure 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -