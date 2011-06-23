; www.purearea.net
; Author: Rings (updated for PB4.00 by blbltheworm)
; Date: 06. June 2002
; OS: Windows
; Demo: No

;DDE Server and Client in PureBasic
;(c)2002 by S.Rings (-CodeGuru-)
;
;Compile as exe and start twice or more  :)

Global WhoIAM.s
Global DDEServerName.s
DDEServerName = "TestServer"
Global DDETopicName.s
DDETopicName = "PUREBASIC_DDE_TOPIC"
Global idInst.l
Global isRun.l

#XCLASS_BOOL = $1000
#XCLASS_NOTIFICATION = $8000
#XTYPF_NOBLOCK = $2
#XTYP_CONNECT = $60 | #XCLASS_BOOL | #XTYPF_NOBLOCK
#XTYP_DISCONNECT = $C0 | #XCLASS_NOTIFICATION | #XTYPF_NOBLOCK

#CP_WINANSI = 1004 ;' Default codepage For windows & old DDE convs.
#SW_RESTORE = 9
#DDE_FACK = $8000
#XCLASS_FLAGS = $4000
#XTYP_EXECUTE = $50 | #XCLASS_FLAGS
#DNS_REGISTER = $1
#DNS_UNREGISTER = $2
#CF_TEXT            =  1
#XTYP_POKE = $90 | #XCLASS_FLAGS

Procedure.s MySpace(Count.l)
  Dummy.s="":For I=1 To Count:  Dummy.s=Dummy.s + " ":Next I:ProcedureReturn Dummy
EndProcedure

Procedure.l DDECallback(uType,uFmt, hConv , hszTopic, hszItem, hData,dwData1, dwData2)
  Shared DDETopicName
  Shared DDEServerName
  Shared idInst
  Shared WhoIAM
  ;StartDrawing(WindowOutput())
  ;Locate (10,90)
  ;dummy.s=Str(uType)+":"+Str(uFmt)+":"+Str(hConv)+":"
  ;DrawText (dummy)
  ; StopDrawing()
  ReturnValue=0;#DDE_FACK
  Select uType
  Case #XTYP_CONNECT
    
    iCount = DdeQueryString_(idInst, hszTopic, 0, 0, #CP_WINANSI);First Count Length of String
    Buffers.s = MySpace(iCount)
    DdeQueryString_( idInst, hszTopic, Buffers, iCount + 1, #CP_WINANSI)
    If Buffers = DDETopicName
      StartDrawing(WindowOutput(0))
      DrawText (10,10,Str(uFmt) +"..the client successfully connected..")
      StopDrawing()
      ReturnValue = #DDE_FACK
    EndIf
    
  Case #XTYP_DISCONNECT
    StartDrawing(WindowOutput(0))
    DrawText (10,70,"disconnected..")
    StopDrawing()
    ReturnValue = #DDE_FACK
  Case #XTYP_EXECUTE
    ReturnValue=0
  Case #XTYP_POKE
    iCount = DdeQueryString_(idInst, hszTopic, 0, 0, #CP_WINANSI);First Count Length of String
    Buffers.s = MySpace(iCount)
    DdeQueryString_( idInst, hszTopic, Buffers, iCount + 1, #CP_WINANSI)
    Dummy.s= "Topic:" + Buffers
    StartDrawing(WindowOutput(0))
    DrawText (10,30,Dummy)
    StopDrawing()
    
    iCount = DdeQueryString_(idInst, hszItem, 0, 0, #CP_WINANSI);First Count Length of String
    Buffers.s = MySpace(iCount)
    DdeQueryString_( idInst, hszItem, Buffers, iCount + 1, #CP_WINANSI)
    Dummy="  Data::" + Buffers
    
    ReturnValue = #DDE_FACK
    StartDrawing(WindowOutput(0))
    DrawText (10,50,Dummy)
    StopDrawing()
    
  EndSelect
  ProcedureReturn ReturnValue
EndProcedure


;-Attention Callbacks are  only working with Procedure for >3.1
MyCallBackAdress=@DDECallback();
If DdeInitialize_(@idInst, MyCallBackAdress, 0, 0)
  MessageRequester("Info","Failed:"+Str(idInst),0)
EndIf
hszServer = DdeCreateStringHandle_(idInst, DDEServerName, #CP_WINANSI)
If hszServer<>0
  hszTopic = DdeCreateStringHandle_(idInst, DDETopicName, #CP_WINANSI)
  If hszTopic<>0
    ;try To find the first instance, connect
    hconvServer = DdeConnect_(idInst, hszServer, hszTopic,  0)
    If hconvServer
      WhoIAM="Client"
      MessageRequester( WhoIAM,"Server already started...",0)
    Else
      WhoIAM="Server":MessageRequester (WhoIAM,"attempt To start Server",0)
      Result=DdeNameService_( idInst, hszServer, 0,#DNS_REGISTER)
      If Result=1 : isRun=1: EndIf
      MessageRequester(WhoIAM,"Server started:"+Str(Result),0)
    EndIf
  Else
  EndIf
Else
EndIf

If OpenWindow(0, 200, 200, 300, 200, WhoIAM, #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  If   WhoIAM="Client"
    If CreateGadgetList(WindowID(0))
      ButtonGadget(0, 10, 10,  72, 20, "Send")
    EndIf
  EndIf
  Repeat
    EventID.l = WaitWindowEvent()
    If EventID = #PB_Event_CloseWindow  : Quit = 1: EndIf
    If EventID = #PB_Event_Gadget
      Select EventGadget()
      Case 0
        Message.s="-CodeGuru- was there"
        hItemMessage = DdeCreateStringHandle_(idInst, Message, #CP_WINANSI )
        If hItemMessage = 0 :  MessageRequester (WHOIAM,"Failed",0):  EndIf
        myresult=0
        Result = DdeClientTransaction_(Message, Len(Message), hconvServer, hItemMessage, #CF_TEXT, #XTYP_POKE, 3000, @myresult )
        MessageRequester(WHOIAM,"Transaction:" +Str(Result)+":"+Str(myresult),0)
        If Result <>0:  DdeFreeDataHandle_(Result ):  EndIf
        Result=DdeFreeStringHandle_( idInst, hItemMessage)
      EndSelect
    EndIf
  Until Quit = 1
EndIf


Result=DdeFreeStringHandle_( idInst, hszServer)
Result=DdeFreeStringHandle_( idInst, hszTopic)

;only unregister the DDE server For first instance
If isRun
  Result=DdeNameService_(idInst, hszServer, 0, #DNS_UNREGISTER)
  MessageRequester( WHOIAM,"in ServiceUnRegister:"+Str(result), 0)
EndIf
Result=DdeUninitialize_( idInst)
MessageRequester(WHOIAM,"Ending:"+Str(Result),0)
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -