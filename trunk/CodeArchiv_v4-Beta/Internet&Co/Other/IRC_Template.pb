; German forum: http://www.purebasic.fr/german/viewtopic.php?t=683&highlight=
; Author: DarkDragon (updated for PB 4.00 by Andre)
; Date: 06. November 2004
; OS: Windows
; Demo: Yes

InitNetwork() 

Global ConnectionID.l 
Global NewList RecText.s() 

Procedure IRCConnect(Server.s, Port.l) 
  Connection = OpenNetworkConnection(Server, Port) 
  If Connection <> 0 
    ConnectionID = Connection 
  EndIf 
  ProcedureReturn Connection 
EndProcedure 

Procedure IRCUseConnection(Connection) 
  ConnectionID = Connection 
EndProcedure 

Procedure IRCLogin(Server.s, Name.s, Pass.s) 
  SendNetworkString(ConnectionID,"USER "+ReplaceString(Name, " ", "_")+" localhost "+Server+" http://www.bradan.net/"+Chr(13)+Chr(10)) 
  SendNetworkString(ConnectionID,"NICK "+ReplaceString(Name, " ", "_")+Chr(13)+Chr(10)) 
  If Pass <> "" 
    SendNetworkString(ConnectionID,"PRIVMSG NickServ :IDENTIFY "+Pass+Chr(13)+Chr(10)) 
  EndIf 
EndProcedure 

Procedure IRCChangeNick(Name.s) 
  SendNetworkString(ConnectionID,"NICK "+ReplaceString(Name, " ", "_")+Chr(13)+Chr(10)) 
EndProcedure 

Procedure IRCJoin(Channel.s, Server.s) 
  SendNetworkString(ConnectionID,"JOIN "+Channel+Chr(13)+Chr(10)) 
EndProcedure 

Procedure IRCLeave(Channel.s) 
  SendNetworkString(ConnectionID,"PART "+Channel+Chr(13)+Chr(10)) 
EndProcedure 

Procedure IRCSendText(Channel.s, Text.s) 
  SendNetworkString(ConnectionID,"PRIVMSG "+Channel+" :"+Text+Chr(13)+Chr(10)) 
EndProcedure 

Procedure IRCSend(Text.s) 
  SendNetworkString(ConnectionID,Text+Chr(13)+Chr(10)) 
EndProcedure 

Procedure.s IRCGetFrom(Str.s) 
  Start = FindString(Str.s, ":", 0)+1 
  Stop = FindString(Str.s, "!~", Start) 
  ProcedureReturn Mid(Str.s, Start, Stop-Start) 
EndProcedure 

Procedure.s IRCGetTo(Str.s) 
  Start = FindString(Str.s, "PRIVMSG", 2)+Len("PRIVMSG")+1 
  Stop = FindString(Str.s, ":", Start)-1 
  ProcedureReturn Mid(Str.s, Start, Stop-Start) 
EndProcedure 

Procedure.s IRCGetPingMsg(Str.s) 
  Start = FindString(Str.s, ":", 0)+1 
  Stop = Len(Str.s)+1 
  ProcedureReturn Mid(Str.s, Start, Stop-Start) 
EndProcedure 

Procedure.s IRCGetLine() 
  If NetworkClientEvent(ConnectionID) = 2 
    LastElement(RecText()) 
    *Buffer = AllocateMemory(1024) 
    ReceiveNetworkData(ConnectionID, *Buffer, 1024) 
    txt.s = PeekS(*Buffer) 
    FreeMemory(*Buffer) 
    ReplaceString(txt, Chr(13), Chr(10)) 
    ReplaceString(txt, Chr(10)+Chr(10), Chr(10)) 
    For k=1 To CountString(txt, Chr(10)) 
      Line.s = RemoveString(RemoveString(StringField(txt, k, Chr(10)), Chr(10)), Chr(13)) 
      If Line <> "" 
        If FindString(UCase(Line), "PING", 0) Or FindString(UCase(Line), "VERSION", 0) 
          SendNetworkString(ConnectionID,ReplaceString(Line,"PING :", "PONG :",0)+Chr(13)+Chr(10)) 
        Else 
          AddElement(RecText()) 
          RecText() = Line.s 
        EndIf 
      EndIf 
    Next 
  EndIf 
  If CountList(RecText()) > 0 
  FirstElement(RecText()) 
  txt.s = RecText() 
  DeleteElement(RecText()) 
  ProcedureReturn txt 
  EndIf 
EndProcedure 

Procedure.s IRCGetText(Str.s) 
  Start = FindString(Str.s, ":", FindString(Str.s, "PRIVMSG", 2)+Len("PRIVMSG")) 
  ProcedureReturn Right(Str, Len(Str)-Start) 
EndProcedure 

Procedure.f IRCPing(Server.s, Timeout) 
  *Buffer = AllocateMemory(1024) 
  SendNetworkString(ConnectionID,"PING "+Server+Chr(13)+Chr(10)) 
  Time = ElapsedMilliseconds() 
  While NetworkClientEvent(ConnectionID) <> 2 : Delay(1) : If ElapsedMilliseconds()-Time > Timeout : Break : EndIf : Wend 
  If ElapsedMilliseconds()-Time <= Timeout 
    T = ElapsedMilliseconds()-Time 
    ReceiveNetworkData(ConnectionID, *Buffer, 1024) 
    FreeMemory(*Buffer) 
    ProcedureReturn T/1000 
  Else 
    ProcedureReturn -1 
  EndIf 
EndProcedure 

Procedure IRCDisconnect(Msg.s) ;Closes the current connection 
  SendNetworkString(ConnectionID,"QUIT "+Msg.s+Chr(13)+Chr(10)) 
  CloseNetworkConnection(ConnectionID) 
EndProcedure 

Procedure.s IRCEnumNames(Channel.s) ;Enumerates all names in the channel 
  SendNetworkString(ConnectionID,"NAMES "+Channel+Chr(13)+Chr(10)) 
  *Buffer = AllocateMemory(1024) 
  While NetworkClientEvent(ConnectionID) <> 2 : Delay(1) : Wend 
  ReceiveNetworkData(ConnectionID, *Buffer, 1024) 
  txt.s = PeekS(*Buffer) 
  FreeMemory(*Buffer) 
  Start = FindString(txt, Channel.s, 0)+Len(Channel.s)+2 
  Stop = FindString(txt, Chr(10), 0) 
  
  ProcedureReturn Mid(txt.s, Start, Stop-Start) 
EndProcedure 

;Example 
Procedure ResizeWin() 
  ResizeGadget(1, 10, WindowHeight(0)-30, WindowWidth(0)-20, 20) 
  ResizeGadget(0, 10, 10, WindowWidth(0)-170, WindowHeight(0)-50) 
  ResizeGadget(2, WindowWidth(0)-160, 10, 150, WindowHeight(0)-50) 
EndProcedure 

Channel.s = "#PureBasic" 
Server.s = "irc.freenode.net" 
Nick.s = InputRequester("Nickname", "Give me your Nickname:", "IRC Example") 

;Create the GUI 
If OpenWindow(0, 216, 0, 450, 300, "IRC Example "+Channel, #PB_Window_MinimizeGadget | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SystemMenu | #PB_Window_TitleBar) 
  If CreateGadgetList(WindowID(0)) 
      StringGadget(1, 10, 270, 430, 20, "", #ES_MULTILINE) ;The Input 
      ListViewGadget(0, 10, 10, 280, 250) ;Messages 
      ListViewGadget(2, 290, 10, 150, 250) ;Names 
  EndIf 
EndIf 

IRCConnect(Server.s, 6667) 
IRCLogin(Server.s, Nick.s, "") 
IRCJoin(Channel.s, Server.s) 

Repeat 
  Line.s = IRCGetLine() ;Get a messageline 
  If Line <> "" 
    If IRCGetFrom(Line) <> "" 
    
    ClearGadgetItemList(2) 
    Names.s = IRCEnumNames(Channel.s) 
    Login = 1 
    
    For k=1 To CountString(Names, " ") ;List the Names 
      Cur.s = StringField(Names, k, " ") 
      If Len(Cur) > 1 
        AddGadgetItem(2, -1, Cur) 
      EndIf 
    Next 
    
    If UCase(IRCGetTo(Line)) <> UCase(Channel.s) 
    AddGadgetItem(0, -1, "<"+IRCGetFrom(Line)+" To "+IRCGetTo(Line)+"> "+IRCGetText(Line)) 
    Else 
    AddGadgetItem(0, -1, "<"+IRCGetFrom(Line)+"> "+IRCGetText(Line)) 
    EndIf 
    
    Else 
    
    AddGadgetItem(0, -1, Line) 
    EndIf 
    
    SetGadgetState(0, CountGadgetItems(0)-1) 
    
  Else 
    
    If Login = 1 And ElapsedMilliseconds()-LastPing > 15000 
      Ping.f = IRCPing(Server.s, 5000) 
      SetWindowTitle(0, "IRC Example "+Channel+"  Ping: "+StrF(Ping, 2)) 
      LastPing = ElapsedMilliseconds() 
    EndIf 
    
  EndIf 
  
  
  Event = WindowEvent() 
  Select Event 
    Case 0 
      Delay(20) 
    Case #PB_Event_SizeWindow 
      ResizeWin() 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case 2 
          If EventType() = #PB_EventType_LeftDoubleClick 
            Msg.s = GetGadgetItemText(2, GetGadgetState(2), 0) 
            If Left(Msg, 1) = "@" 
              Msg = Right(Msg, Len(Msg)-1) 
            EndIf 
            SetGadgetText(1, GetGadgetText(1)+"/msg "+Msg+" ") 
            SetActiveGadget(1) 
          EndIf 
        Case 1 
          If EventType() = #PB_EventType_ReturnKey And GetGadgetText(1) <> "" 
            If Left(GetGadgetText(1), 1) = "/" 
            AllParams.s = Right(GetGadgetText(1), Len(GetGadgetText(1))-FindString(GetGadgetText(1), " ", 0)) 
            Param1.s = StringField(GetGadgetText(1), 2, " ") 
            Param2.s = Right(AllParams.s, Len(AllParams.s)-FindString(AllParams.s, " ", 1)) 
            Select LCase(StringField(GetGadgetText(1), 1, " ")) 
              Case "/msg" 
                IRCSendText(Param1, Param2) 
                AddGadgetItem(0, -1, "<"+Nick+" To "+Param1+"> "+Param2) 
              Case "/join" 
                IRCJoin(Param1, Server) 
              Default 
                IRCSend(Right(GetGadgetText(1), Len(GetGadgetText(1))-1)) 
                AddGadgetItem(0, -1, "<"+Nick+"> "+AllParams.s) 
            EndSelect 
            Else 
            IRCSendText(Channel.s, GetGadgetText(1)) 
            AddGadgetItem(0, -1, "<"+Nick+"> "+GetGadgetText(1)) 
            EndIf 
            SetGadgetText(1, "") 
            SetGadgetState(0, CountGadgetItems(0)-1) 
          EndIf 
      EndSelect 
  EndSelect 
Until Event = #PB_Event_CloseWindow 
IRCDisconnect("Bye") 
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ---