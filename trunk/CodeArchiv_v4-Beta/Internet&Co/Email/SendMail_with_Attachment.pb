; www.purearea.net (Sourcecode collection by cnesm)
; Author: PB (updated for PB 4.00 by Andre)
; Date: 22. November 2003
; OS: Windows
; Demo: No

;Modified code originally posted by Paul IIRC  :) 

;USAGE: 
;PBSendMail( 
;                        RecipientEmailAddress as String 
;                        SenderEmailAddress as String 
;                        MailServerHost as String 
;                        Subject as String 
;                        Message as String 
;                        AttachmentIncluded as Byte (Flag: 0/1) 
;                     ) 

;NOTES: 
;When the 'AttachmentIncluded' flag is set to '1', the mail procedure loops through a linked list 
;called 'Attachments()' then encodes or processes the attachments. So to send attachments 
;you must have a linked list called 'Attachments()'. 

;=============================================== 
;-GLOBAL FLAGS / VARIABLES / STRUCTURES / ARRAYS 
;=============================================== 

Global ConnectionID.l 
Global MailResponse.s 

;Example linked list 
Global NewList Attachments.s() 
InsertElement(Attachments()) 
Attachments() = "C:\Documents And Settings\User\Desktop\Image.jpg" 
;InsertElement(Attachments()) 
;Attachments() = "C:\Documents And Settings\User\Desktop\Archive.zip" 
;InsertElement(Attachments()) 
;Attachments() = "C:\Documents And Settings\User\Desktop\ObscureText.fff" 

;=============================================== 
;-PROCEDURES 
;=============================================== 

;Check to see if the file is binary 
Procedure IsBinary(File.s) 
    If ReadFile(0, File) 
        While Loc(0) <> Lof(0) 
            CurrentByte.b = ReadByte(0) 
            If CurrentByte <= 9 Or CurrentByte = 127 
                CloseFile(0) 
                ProcedureReturn 1 
            EndIf 
            If CurrentByte > 10 And CurrentByte < 13 
                CloseFile(0) 
                ProcedureReturn 1 
            EndIf 
            If CurrentByte > 13 And CurrentByte < 32 
                CloseFile(0) 
                ProcedureReturn 1 
            EndIf 
        Wend 
    EndIf 
EndProcedure 

;Find the MIME type for a given file extension 
Procedure.s GetMIMEType(Extension.s) 
    Extension = "." + Extension 
    hKey.l = 0 
    KeyValue.s = Space(255) 
    datasize.l = 255 
    If RegOpenKeyEx_(#HKEY_CLASSES_ROOT, Extension, 0, #KEY_READ, @hKey) 
        KeyValue = "application/octet-stream" 
    Else 
        If RegQueryValueEx_(hKey, "Content Type", 0, 0, @KeyValue, @datasize) 
            KeyValue = "application/octet-stream" 
        Else 
            KeyValue = Left(KeyValue, datasize-1) 
        EndIf 
        RegCloseKey_(hKey) 
    EndIf 
    ProcedureReturn KeyValue 
EndProcedure 

;Send a piece of mail data 
Procedure SendMailData(msg.s) 
    SendNetworkData(ConnectionID, @msg, Len(msg)) 
EndProcedure 

;Check the server responses 
Procedure.s MailResponse() 
    MailResponse=Space(9999) 
    ReceiveNetworkData(ConnectionID,@MailResponse,9999) 
    MailResponse=Left(MailResponse,3) 
    ProcedureReturn MailResponse 
EndProcedure 

;Send the mail 
Procedure PBSendMail(RecipientEmailAddress.s, SenderEmailAddress.s, MailServerHost.s, Subject.s, Message.s, AttachmentIncluded.b) 
    If InitNetwork() 
        ConnectionID = OpenNetworkConnection(MailServerHost, 25) 
        If ConnectionID <> 0 
            MailResponse() 
            If MailResponse = "220" 
                Index = FindString(MailServerHost, ".", 1) 
                MailServerDomain.s = Mid(MailServerHost, Index + 1, Len(MailServerHost)) 
                SendMailData("HELO "+MailServerDomain+Chr(13)+Chr(10)) 
                MailResponse() 
                If MailResponse="250" 
                    Sleep_(125) 
                    SendMailData("MAIL FROM: <"+SenderEmailAddress+">"+Chr(13)+Chr(10)) 
                    MailResponse() 
                    If MailResponse="250" 
                        SendMailData("RCPT TO: <"+RecipientEmailAddress+">"+Chr(13)+Chr(10)) 
                        MailResponse() 
                        If MailResponse="250" 
                            SendMailData("DATA"+Chr(13)+Chr(10)) 
                            MailResponse() 
                            If MailResponse="354" 
                                Sleep_(125) 
                                SendMailData("X-Mailer: PBSendMail v1.0" + Chr(13) + Chr(10)) 
                                SendMailData("To: " + RecipientEmailAddress + Chr(13) + Chr(10)) 
                                SendMailData("From: " + SenderEmailAddress + Chr(13) + Chr(10)) 
                                SendMailData("Reply-To:" + SenderEmailAddress + Chr(13) + Chr(10)) 
                                SendMailData("Date: " + FormatDate("%dd/%mm/%yyyy @ %hh:%ii:%ss", Date()) + Chr(13) + Chr(10)) 
                                SendMailData("Subject: " + Subject + Chr(13) + Chr(10)) 
                                SendMailData("MIME-Version: 1.0" + Chr(13) + Chr(10)) 
                                ;Handle any attachments 
                                If AttachmentIncluded 
                                    Debug "Processing 'multipart/mixed' Email..." 
                                    Boundry.s = "PBSendMailv1.0_Boundry_"+ FormatDate("%dd%mm%yyyy%hh%ii%ss", Date()) 
                                    SendMailData("Content-Type: multipart/mixed; boundary=" + Chr(34) + Boundry + Chr(13) + Chr(10) + Chr(34)) 
                                    SendMailData(Chr(13) + Chr(10)) 
                                    ;Main message 
                                    Debug "Processing Messsage..." 
                                    SendMailData("--" + Boundry + Chr(13) + Chr(10)) ; Boundry 
                                    SendMailData("Content-Type: text/plain; charset=" + Chr(34) + "iso-8859-1" + Chr(34) + Chr(13) + Chr(10)) 
                                    SendMailData("Content-Transfer-Encoding: 7bit" + Chr(13) + Chr(10)) 
                                    SendMailData(Chr(13) + Chr(10)) 
                                    Sleep_(125) 
                                    SendMailData(Message + Chr(13) + Chr(10)) 
                                    SendMailData(Chr(13) + Chr(10)) 
                                    Sleep_(125) 
                                    Debug "Processing Attachments..." 
                                    ResetList(Attachments()) 
                                    While(NextElement(Attachments())) 
                                        ;Attachment headers 
                                        SendMailData("--" + Boundry + Chr(13) + Chr(10)) ; Boundry 
                                        SendMailData("Content-Type: " + GetMIMEType(GetExtensionPart(Attachments())) + "; name=" + Chr(34) + GetFilePart(Attachments()) + Chr(34) + Chr(13) + Chr(10)) 
                                        If IsBinary(Attachments()) 
                                            SendMailData("Content-Transfer-Encoding: base64" + Chr(13) + Chr(10)) 
                                            SendMailData("Content-Disposition: Attachment; filename=" + Chr(34) + GetFilePart(Attachments()) + Chr(34) + Chr(13) + Chr(10)) 
                                            SendMailData(Chr(13) + Chr(10)) 
                                            Sleep_(125) 
                                            ;Encode the Attachments using Base64 
                                            If ReadFile(0, Attachments()) 
                                                InputBufferLength.l = Lof(0) 
                                                *memin = AllocateMemory(InputBufferLength) 
                                                If *mem
                                                    OutputBufferLength.l = InputBufferLength + InputBufferLength/3 + 2 
                                                    If OutputBufferLength < 64 : OutputBufferLength = 64 : EndIf 
                                                    *memout = AllocateMemory(OutputBufferLength) 
                                                    If *memout
                                                        ReadData(0, *memin, InputBufferLength) 
                                                        Base64Encoder(@memin, InputBufferLength, @memout, OutputBufferLength) 
                                                        SendMailData(PeekS(*memout, OutputBufferLength) + Chr(13) + Chr(10)) 
                                                        Debug GetFilePart(Attachments()) + " (base64) Encoded" 
                                                    Else 
                                                        Debug "ERROR: Unable to allocate memory for Bank 1 to process " + GetFilePart(Attachments()) 
                                                        ProcedureReturn 0 
                                                    EndIf 
                                                Else 
                                                    Debug "ERROR: Unable to allocate memory for Bank 0 to process " + GetFilePart(Attachments()) 
                                                    ProcedureReturn 0 
                                                EndIf 
                                            Else 
                                                Debug "ERROR: Unable to read file: " + GetFilePart(Attachments()) 
                                                ProcedureReturn 0 
                                            EndIf 
                                            CloseFile(0) : FreeMemory(*memin) : FreeMemory(*memout) 
                                        Else 
                                            SendMailData("Content-Transfer-Encoding: 7bit" + Chr(13) + Chr(10)) 
                                            SendMailData("Content-Disposition: Attachment; filename=" + Chr(34) + GetFilePart(Attachments()) + Chr(34) + Chr(13) + Chr(10)) 
                                            SendMailData(Chr(13) + Chr(10)) 
                                            Sleep_(125) 
                                            If ReadFile(0, Attachments()) 
                                                InputBufferLength.l = Lof(0) 
                                                *memin = AllocateMemory(InputBufferLength)
                                                If *memin
                                                    ReadData(0, *memin, InputBufferLength) 
                                                    SendMailData(PeekS(*memin, InputBufferLength) + Chr(13) + Chr(10)) 
                                                    Debug GetFilePart(Attachments()) + " (7bit) Processed" 
                                                Else 
                                                    Debug "ERROR: Unable to allocate memory for Bank 0 to process " + GetFilePart(Attachments()) 
                                                    ProcedureReturn 0 
                                                EndIf 
                                            Else 
                                                Debug "ERROR: Unable to read file: " + GetFilePart(Attachments()) 
                                                ProcedureReturn 0 
                                            EndIf 
                                        EndIf 

                                        Sleep_(125) 
                                        SendMailData(Chr(13) + Chr(10)) 
                                    Wend 
                                    SendMailData("--" + Boundry + "--" + Chr(13) + Chr(10)) ; End Boundry 
                                Else 
                                    Debug "Processing messsage..." 
                                    SendMailData("Content-Type: text/plain; charset=" + Chr(34) + "iso-8859-1" + Chr(34) + Chr(13) + Chr(10)) 
                                    SendMailData("Content-Transfer-Encoding: 7bit" + Chr(13) + Chr(10)) 
                                    SendMailData(Chr(13) + Chr(10)) 
                                    Sleep_(125) 
                                    SendMailData(Message + Chr(13) + Chr(10)) 
                                EndIf 
                                Sleep_(125) 
                                SendMailData(Chr(13)+Chr(10)) 
                                SendMailData("."+Chr(13)+Chr(10)) 
                                MailResponse() 
                                If MailResponse="250" 
                                    Sleep_(125) 
                                    SendMailData("QUIT"+Chr(13)+Chr(10)) 
                                    MailResponse() 
                                    Debug "Mail sent successfully." 
                                    ProcedureReturn 1 
                                EndIf 
                            EndIf 
                        EndIf 
                    EndIf 
                EndIf 
            EndIf 
            CloseNetworkConnection(ConnectionID) 
        EndIf 
    EndIf 
EndProcedure 

;Testing: 
PBSendMail("theirmail@server.com", "yourmail@server.com", "smtp.server.com", "Subject Line", "Lorem Ipsum Dolar Sit Amet...", 0) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -