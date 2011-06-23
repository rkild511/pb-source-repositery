; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6668&highlight=
; Author: ricardo (updated for PB3.93 by ts-soft, updated for PB 4.00 by Leonhard)
; Date: 23. June 2003
; OS: Windows
; Demo: No

; Mine is a little complete app that checks my pop3 every 5 minutes and tell me if i have new mail,
; also let me delete unwanted mail.
; It can be improved a lot because was coded in a few hours just like an excercise.
; You need to have a "\Mail" folder in the same path.

; Just put your servername, username, and password in places where are required.

If InitNetwork() = 0
  MessageRequester("Error", "Can't initialize the network !", 0)
  End
EndIf

Global ServerName$ = ""
Global Port = 110 ;/ Meist 110
Global Username$ = ""
Global Password$ = ""


Global ConnectionID.l
Global Conectado.l
Global *Buffer.l
Global eol$
Global Dir$

Dir$ = Space(500)
GetCurrentDirectory_(500,@Dir$)
eol$ = Chr(13)+Chr(10)
*Buffer = AllocateMemory(10000)

Procedure CleanMails()
  If ExamineDirectory(0,Dir$ + "\Mail\" , "*.*")
    Repeat
      FileType = NextDirectoryEntry(0)
      If FileType
        FileName$ = DirectoryEntryName(0)
        If FileType = 1
          DeleteFile(Dir$ + "\Mail\" + FileName$)
        EndIf
      EndIf
    Until FileType = 0
  EndIf
EndProcedure

Procedure ComparaMails(Mail.s, Content.s)
  If ExamineDirectory(0,Dir$ + "\Mail\" , "*.*")
    Repeat
      FileType = NextDirectoryEntry(0)
      If FileType
        FileName$ = DirectoryEntryName(0)
        If FileType = 1
          If FileName$ = Mail
            If ReadFile(0,Dir$ + "\Mail\" + FileName$)
              Contenido$ = Space(Lof(0))
              ReadData(0, @Contenido$,Lof(0))
              CloseFile(0)
              If Contenido$ = Content
                ProcedureReturn 1
              EndIf
            EndIf
          EndIf
        EndIf
      EndIf
    Until FileType = 0
    ProcedureReturn 0
  EndIf
EndProcedure

Procedure ChecaMail()
  SysTrayIconToolTip(0, "Connecting...")
  KillTimer_(WindowID(0),0)
  ClearGadgetItemList(1)
  ConnectionID = OpenNetworkConnection(ServerName$, Port)
  If ConnectionID
    Debug "Verbindung hergestellt"
    Delay(5)
    Repeat
      Delay(10)
      Result = NetworkClientEvent(ConnectionID)
      Select Result
        Case #PB_NetworkEvent_Data
          Repeat
            Delay(10)
            RequestLength.l = ReceiveNetworkData(ConnectionID, *Buffer, 5000)
          Until RequestLength.l > 3
          Command$ = PeekS(*Buffer)
          Var$ = Space(RequestLength)
          PokeS(*Buffer,Var$)

          Debug "Empfang: "+Command$+" # "+Var$
          If FindString(Command$, "+OK GMX POP3", 0)
            ;If FindString(Command$, "+OK WEB.DE POP3-Server", 0)
            ;If FindString(Command$,"+OK hello from popgate",0)
            SendNetworkString(ConnectionID, "USER "+Username$+eol$)
            Debug "USER ..."
          ElseIf FindString(Command$,"+OK May I have your password, please?",0)
            ;ElseIf FindString(Command$,"+OK Bitte Kennwort eingeben",0)
            ;ElseIf FindString(Command$,"+OK password required",0)
            SendNetworkString(ConnectionID, "PASS "+Password$+eol$)
            Debug "PASS ..."
          ElseIf FindString(LCase(Command$),LCase("mailbox locked and ready"),0)
            SendNetworkString(ConnectionID, "LIST"+eol$)
          ElseIf FindString(Command$,"1 ",0)
            SendNetworkString(ConnectionID, "RETR 1"+eol$)
          ElseIf FindString(Command$,"+OK maildrop ready",0)
            Debug "MailRead"
            espacio = FindString(Command$," ",22) - 21
            Cuanto$ = Mid(Command$,21,espacio)
            Cuantos = Val(Cuanto$)
            If Cuantos > 0
              Cuanto = 1
              SendNetworkString(ConnectionID, "TOP 1 0"+eol$)
              Delay(150)
            Else
              SendNetworkString(ConnectionID, "QUIT"+eol$)
              SysTrayIconToolTip(0, "You dont have new emails")
              CloseNetworkConnection(ConnectionID)
              Final = 1
            EndIf
          ElseIf FindString(Command$,"octets",0) ;And FindString(Command$,"MIME-Version",0)
            Beep_(1000,1)
            from = FindString(Command$,"From:",0) + 6
            endfrom = FindString(Command$,eol$,from + 1) - from
            From$ = Mid(Command$,from,endfrom)
            subject = FindString(Command$,"Subject:",0) + 9
            endsubject = FindString(Command$,eol$,subject + 1) - subject
            Subject$ = Mid(Command$,subject,endsubject)
            AddGadgetItem(1, Cuanto - 1, From$ + Chr(10) + Subject$)
            File$ = From$
            For i = 1 To 47
              File$ = ReplaceString(File$,Chr(i),"",0)
            Next i
            For i = 58 To 64
              File$ = ReplaceString(File$,Chr(i),"",0)
            Next i
            For i = 122 To 255
              File$ = ReplaceString(File$,Chr(i),"",0)
            Next i
            If Len(File$) > 10
              ;File$ = Right(File$,10)
            EndIf
            File$ = File$ + ".txt"
            If Cuanto < Cuantos
              Cuanto = Cuanto + 1
              Delay(10)
              SetWindowText_(WindowID(0),Str(Cuanto))
              SysTrayIconToolTip(0, "Downloading " + Str(Cuanto) + " from " + Str(Cuantos))
              SendNetworkString(ConnectionID, "TOP " + Str(Cuanto) + " 0"+eol$)
              If ComparaMails(File$,Command$ ) = 0
                Nuevo = 1
                If OpenFile(0,Dir$ + "\Email\" + File$)
                  WriteString(0, Command$)
                  CloseFile(0)
                EndIf
              EndIf
            Else
              SendNetworkString(ConnectionID, "QUIT"+eol$)
              If ComparaMails(File$,Command$ ) = 0
                Nuevo = 1
                If OpenFile(1,Dir$ + "\Mail\" + File$)
                  WriteString(1, Command$)
                  CloseFile(1)
                Else
                  Beep_(1000,3)
                EndIf
              EndIf
              If Nuevo
                SysTrayIconToolTip(0, "You have " + Str(Cuantos) + " new emails")
                HideWindow(0, 0)
              Else
                SysTrayIconToolTip(0, "You dont have new emails")
              EndIf
              CloseNetworkConnection(ConnectionID)
              Final = 1
            EndIf
          EndIf
      EndSelect
    Until Final = 1
  EndIf
  SetTimer_(WindowID(0),0,300000,@ChecaMail());180000
  SysTrayIconToolTip(0, "Waiting...")
  Debug "ExitCheck"
EndProcedure

Procedure DeleteMail(Cual)
  ConnectionID = OpenNetworkConnection(ServerName$, Port)
  If ConnectionID
    Delay(5)
    Repeat
      Delay(10)
      Result = NetworkClientEvent(ConnectionID)
      Select Result
        Case 2
          Repeat
            Delay(10)
            RequestLength.l = ReceiveNetworkData(ConnectionID, *Buffer, 5000)
          Until RequestLength.l > 3
          Command$ = PeekS(*Buffer)
          Var$ = Space(RequestLength)
          PokeS(*Buffer,Var$)
          If FindString(Command$,"+OK hello from popgate",0)
            SendNetworkString(ConnectionID, "USER "+Username$+eol$)
          ElseIf FindString(Command$,"+OK password required",0)
            SendNetworkString(ConnectionID, "PASS "+Password$+eol$)
          ElseIf FindString(Command$,"marked deleted",0)
            SysTrayIconToolTip(0,Str(ii+1) + " e mail deleted")
            SendNetworkString(ConnectionID, "QUIT"+eol$)
          ElseIf FindString(Command$,"+OK maildrop ready",0)
            SendNetworkString(ConnectionID, "DELE " + Str(Cual) + " 0"+eol$)
          ElseIf FindString(Command$,"-ERR",0)
            SendNetworkString(ConnectionID, "QUIT"+eol$)
          ElseIf FindString(Command$,"+OK server signing off",0)
            CloseNetworkConnection(ConnectionID)
            Final = 1
          EndIf
      EndSelect
    Until Final = 1
    Beep_(1555,10)
    ProcedureReturn 1
  Else
    ProcedureReturn 2
  EndIf
EndProcedure

#List = 1
#Check = 4
Delete = 2
#Close = 3

If OpenWindow(0,100,150,450,230,"MailCheck",#PB_Window_SystemMenu|#PB_Window_Invisible)
  CreateGadgetList(WindowID(0))
  ListIconGadget(#List,10,10,430,180,"From",250,#PB_ListIcon_MultiSelect|#PB_ListIcon_AlwaysShowSelection)
  AddGadgetColumn(1, 1, "Subject", 150)
  ButtonGadget(#Check,190,200,50,25,"Check")
  ButtonGadget(Delete,290,200,50,25,"Delete")
  ButtonGadget(#Close,390,200,50,25,"Minimize",#PB_Button_Default)
  AddSysTrayIcon(0, WindowID(0), LoadImage(0,"..\..\graphics\gfx\mail.ico"))
  SysTrayIconToolTip(0, "PopUp Mail Checker" + Chr(13) + Chr(10) + "ok")
  CleanMails()
  SetTimer_(WindowID(0),0,1,@ChecaMail())
  Repeat
    EventID=WaitWindowEvent()
    Delay(10)
    Select EventID

      Case #PB_Event_Gadget
        Select EventGadget()
          Case #Check
            KillTimer_(WindowID(0),0)
            SetTimer_(WindowID(0),0,1,@ChecaMail())
            SysTrayIconToolTip(0, "Checking...")
          Case #Close
            HideWindow(0, 1)
          Case Delete
            KillTimer_(WindowID(0),0)
            SysTrayIconToolTip(0, "Deleting...")
            For i = 0 To CountGadgetItems(1)
              WindowEvent()
              ii = CountGadgetItems(1) - i
              WindowEvent()
              If GetGadgetItemState(1, ii) <> 0
                If DeleteMail(ii + 1) = 1
                  RemoveGadgetItem(1, ii)
                  WindowEvent()
                  Delay(100)
                EndIf
              EndIf
            Next i
            SetTimer_(WindowID(0),0,180000,@ChecaMail())
            WindowEvent()
            Beep_(1777,50)
        EndSelect
      Case #PB_Event_SysTray
        HideWindow(0, 0)
    EndSelect

  Until EventID=#PB_Event_CloseWindow
EndIf
RemoveSysTrayIcon(0)
If ConnectionID 
  CloseNetworkConnection(ConnectionID)
EndIf
KillTimer_(WindowID(0),0)
CleanMails()
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP