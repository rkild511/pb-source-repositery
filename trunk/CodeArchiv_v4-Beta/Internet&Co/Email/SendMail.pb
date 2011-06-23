; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=765&highlight=
; Author: stbi
; Date: 30. April 2003
; OS: Windows
; Demo: Yes

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
                send("--"+cr+"--"+cr+cr) 
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

;============================== 
;-Enter Appropriate Information 

mailserver.s="mail.gmx.de" 
mailto.s="userid@domain.de" 
mailfrom.s="userid@gmx.de" 
subject.s="Test Message" 

If sendmail(mailserver,mailto,mailfrom,subject,"This is a test message!"+cr+"What do you think?") 
  MessageRequester("Done","Mail Sent Successfully!",0) 
  Else 
  MessageRequester("Error","Error Sending Mail.",#MB_ICONERROR) 
EndIf 
End 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
