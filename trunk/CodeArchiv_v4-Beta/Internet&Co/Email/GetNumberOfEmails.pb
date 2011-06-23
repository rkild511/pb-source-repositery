; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8533&highlight=
; Author: Kale
; Date: 28. November 2003
; OS: Windows
; Demo: Yes

;=========================================================================== 
;-GLOBAL FLAGS / VARIABLES / STRUCTURES / ARRAYS 
;=========================================================================== 

Global CRLF.s 
CRLF = Chr(13) + Chr(10) 

Structure ACOUNTDETAILS 
    POP3Server .s 
    UserName.s 
    Password.s 
EndStructure 

;=========================================================================== 
;-PROCEDURES 
;=========================================================================== 

;Send a piece of mail data using a string 
Procedure SendMailData(ConnectionID, Message.s) 
    Protected BytesSent.l 
    BytesSent = SendNetworkData(ConnectionID, @Message, Len(Message)) 
    If BytesSent >= Len(Message) 
        Debug "SENT: [" + Str(BytesSent) + " bytes] : " + Left(Message, 100) 
        ProcedureReturn 1 
    Else 
        Debug "ERROR: Problem sending data, only " + Str(BytesSent) + " bytes sent" 
        ProcedureReturn 0 
    EndIf 
EndProcedure 

;Check the server responses 
Procedure.s POP3Response(ConnectionID.l) 
    Protected POP3Response.s 
    Protected BytesRecieved.l 
    POP3Response = Space(9999) 
    BytesRecieved = ReceiveNetworkData(ConnectionID, @POP3Response, Len(POP3Response)) 
    If BytesRecieved >= 3 
        Debug "RECV: [" + Str(BytesRecieved) + " bytes] : " + POP3Response 
    Else 
        Debug "ERROR: Problem receiving data, " + Str(BytesSent) + " bytes received" 
    EndIf 
    ProcedureReturn POP3Response 
EndProcedure 

;Get amount of mails pending 
Procedure GetNumberOfEmails(*AccountDetails.ACOUNTDETAILS) 
    Protected ConnectionID.l 
    Protected RawServerMessage.s 
    Protected NumberOfEmails.l 
    Protected MailBoxStatus.s 
    If InitNetwork() 
        ConnectionID = OpenNetworkConnection(*AccountDetails\POP3Server, 110) 
        If ConnectionID <> 0 
            If Left(POP3Response(ConnectionID), 3) = "+OK" 
                SendMailData(ConnectionID, "USER " + *AccountDetails\UserName + CRLF) 
                If Left(POP3Response(ConnectionID), 3) = "+OK" 
                    SendMailData(ConnectionID, "PASS " + *AccountDetails\Password + CRLF) 
                    If Left(POP3Response(ConnectionID), 3) = "+OK" 
                        SendMailData(ConnectionID, "STAT" + CRLF) 
                        MailBoxStatus = POP3Response(ConnectionID) 
                        NumberOfEmails = Val(Mid(MailBoxStatus, 4, FindString(MailBoxStatus, " ", 4))) 
                        Debug "Number of mails waiting to be downloaded: " + Str(NumberOfEmails) 
                        Debug "" 
                        If NumberOfEmails > 0 
                            ;list email sizes 
                            For x = 1 To NumberOfEmails 
                                SendMailData(ConnectionID, "LIST " + Str(x) + CRLF) 
                                POP3Response(ConnectionID) 
                                Debug "" 
                            Next x 
                        EndIf 
                        ProcedureReturn NumberOfEmails 
                    Else 
                        ProcedureReturn 0 
                    EndIf 
                Else 
                    ProcedureReturn 0 
                EndIf 
            Else 
                ProcedureReturn 0 
            EndIf 
        Else 
            MessageRequester("Error", "Connection could not be established with " + *AccountDetails\POP3Server, #PB_MessageRequester_Ok) 
            ProcedureReturn 0 
        EndIf 
    Else 
        MessageRequester("Error", "Network can not be initialised, check your Dial-up Networking settings", #PB_MessageRequester_Ok) 
        ProcedureReturn 0 
    EndIf 
EndProcedure 

;=========================================================================== 
;-TESTING 
;=========================================================================== 

AccountDetails.ACOUNTDETAILS 

AccountDetails\POP3Server = "your.pop3server.com" 
AccountDetails\UserName = "YourUsername" 
AccountDetails\Password = "YourPassword" 

;Returns the number of emails in your pop3 account mailbox 
Debug GetNumberOfEmails(@AccountDetails) 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
