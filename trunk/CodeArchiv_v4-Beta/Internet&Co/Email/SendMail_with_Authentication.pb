; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=983&highlight=
; Author: stbi
; Date: 12. May 2003
; OS: Windows
; Demo: Yes


; * Problem: Server kontaktieren, die auch eine Authentifizierung benötigen (wie GMX), d.h. man 
; muss erst Post holen, um Post versenden zu können. 
; * Ziel: Auch bei diesen Servern Post versenden OHNE vorher Post holen zu müssen. 
; * Lösung: Der SendMail Code wurde um die Funktion popbeforesmtp erweitert. Die Parameter wurden
; logischerweise um das Passwort erweitert, außerdem noch um den Namen des POP3-Servers, da
; dieser nicht immer gleich heißt wie der SMTP-Server (bei GMX isses aber gleich). Frohes Mailen! 


Global res.s, cr.s, ConnID.l 
cr.s=Chr(13)+Chr(10) 


Procedure send(msg.s) 
  SendNetworkData(ConnID,@msg,Len(msg)) 
  Debug "send: "+msg 
EndProcedure 

Procedure.s wait() 
  res="" 
  For tmp=1 To 4999 
    res+" " 
  Next 
  ReceiveNetworkData(ConnID,@res,4999) 
  Debug "received: "+res 
  res=Left(res,3) 
  ProcedureReturn res 
EndProcedure 

Procedure.l sendmail(mailserver.s,mailto.s,mailfrom.s,subject.s,msgbody.s) 
  If InitNetwork() 
    ConnID = OpenNetworkConnection(mailserver,25) 
    If ConnID 
      wait() 
      error=0 
      If res="220" 
        send("HELO CGIapp"+cr) 
        wait()    
        If res="250" 
          Delay(100) 
          send("MAIL FROM: <"+mailfrom+">"+cr) 
          wait() 
          If res="250" 
            send("RCPT TO: <"+mailto+">"+cr) 
            wait() 
            If res="250" 
              send("DATA"+cr) 
              wait() 
              If res="354" 
                Delay(100) 
                send("Date: "+cr) 
                send("From: <"+mailfrom+">"+cr) 
                send("To: <"+mailto+">"+cr) 
                send("Subject: "+subject+cr) 
                send("X-Mailer: PBMailer"+cr) 
                Delay(100) 
;                send("--"+cr+"--"+cr+cr) 
                send(msgbody) 
                Delay(100) 
                send(""+cr) 
                send("."+cr) 
                wait() 
                If res="250" 
                  Delay(100) 
                  send("QUIT"+cr) 
                  wait() 
                  ProcedureReturn 1 
                EndIf 
              EndIf 
            EndIf 
          EndIf 
        EndIf 
      EndIf 
      CloseNetworkConnection(ConnID) 
    EndIf 
  EndIf  
EndProcedure 


Procedure.l popbeforesmtp(pop3server.s,mailuser.s,mailpass.s) 
  If InitNetwork() 
    ConnID = OpenNetworkConnection(pop3server,110) 
    If ConnID 
      wait() 
      error=0 
      If res="+OK" 
        send("user "+mailuser+cr) 
        wait()    
        If res="+OK" 
          Delay(100) 
          send("pass "+mailpass+cr) 
          wait() 
          If res="+OK" 
            Delay(100) 
            send("QUIT"+cr) 
            wait() 
            ProcedureReturn 1 
          EndIf 
        EndIf 
      EndIf 
      CloseNetworkConnection(ConnID) 
    EndIf 
  EndIf  
EndProcedure 

;============================== 
;-Enter Appropriate Information 

mailserver.s="mail.gmx.de" 
pop3server.s="mail.gmx.de" 
mailto.s="empfaenger@domain.de" 
mailfrom.s="absender@gmx.de" 
mailpass.s="geheim" 
subject.s="nur ein Test" 

If popbeforesmtp(pop3server,mailfrom,mailpass) 
  MessageRequester("Done","Pop-Before-SMTP Successfully!",0) 
  Else 
  MessageRequester("Error","Error Pop-Before-SMTP.",#MB_ICONERROR) 
EndIf 

If sendmail(mailserver,mailto,mailfrom,subject,"This is a test message!"+cr+"What do you think?") 
  MessageRequester("Done","Mail Sent Successfully!",0) 
  Else 
  MessageRequester("Error","Error Sending Mail.",#MB_ICONERROR) 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
