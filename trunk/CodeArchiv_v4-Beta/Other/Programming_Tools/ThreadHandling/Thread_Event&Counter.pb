; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2259&highlight=
; Author: jear (updated for PB 4.00 by Andre)
; Date: 28. Februar 2005
; OS: Windows
; Demo: No


; Thread-Test 
Global HVar.l 

Procedure.l Thread() 
  Repeat 
    While HVar < 1000 : Delay(1) : HVar + 1 : Wend 
    HVar = 0 
  ForEver 
EndProcedure  

If OpenWindow(0, 300, 300, 150, 150, "Thread-Test", #PB_Window_SystemMenu) 
  If CreateGadgetList(WindowID(0)) 
    TextGadget(1, 20, 20, 50, 12, "WinEvent") 
    TextGadget(2, 20, 60, 50, 12, "ThreadVar") 
    TextGadget(3, 80, 20, 50, 12, "0",#PB_Text_Right) 
    TextGadget(4, 80, 60, 50, 12, "0",#PB_Text_Right) 
    ButtonGadget(5, 40, 100, 70, 20, "reset") 
    ;CloseGadgetList() 
  EndIf  
  CreateThread(@Thread(), 0) 
  SetTimer_(WindowID(0),1,10,0) 
  Repeat 
    EventID.l = WaitWindowEvent() 
    SetGadgetText(3, Str(EventID)) 
    If EventID = #WM_TIMER 
      SetGadgetText(4, Str(HVar)) 
      SetTimer_(WindowID(0),1,10,0) 
    ElseIf EventID = #PB_Event_Gadget 
      If EventGadget() = 5 
        HVar = 0 
      EndIf  
    ElseIf EventID = #PB_Event_CloseWindow 
      Quit = 1 
    EndIf  
  Until Quit = 1  
EndIf 
KillTimer_(WindowID(0),1) 
End 
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP