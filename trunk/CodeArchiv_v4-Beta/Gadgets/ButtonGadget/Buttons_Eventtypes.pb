; English forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 21. June 2003
; OS: Windows
; Demo: No

Structure event 
  id.l 
  oldid.l 
  pressed.l 
  left.l 
  right.l 
  changed.l 
  key.l 
EndStructure 
Global EventData.event,CursorPosition.POINT 

If GetSystemMetrics_(#SM_SWAPBUTTON)=0 
  EventData\right=#VK_RBUTTON 
  EventData\left=#VK_LBUTTON 
Else 
  EventData\right=#VK_LBUTTON 
  EventData\left=#VK_RBUTTON 
EndIf 


Procedure info(text.s) 
  StatusBarText(1, 0, text, 4) 
EndProcedure 

Procedure RightKlickEvent() 
  If GetActiveWindow_()=WindowID(0) 
    GetCursorPos_(CursorPosition) 
    id=WindowFromPoint_(CursorPosition\x,CursorPosition\y) 
    If EventData\pressed=0 And GetAsyncKeyState_(EventData\right)<>0 
      EventData\oldid=id 
      EventData\pressed=2:mouse_event_(#MOUSEEVENTF_LEFTDOWN,0,0,0,0) 
      result=1 
    ElseIf EventData\pressed=2 And GetAsyncKeyState_(EventData\right)=0 
      If id=EventData\oldid    
        result=1 
      EndIf 
      mouse_event_(#MOUSEEVENTF_LEFTUP,0,0,0,0) 
      EventData\key=2 
      EventData\pressed=0 
    EndIf 
  EndIf 
  ProcedureReturn result 
EndProcedure 

Procedure LeftKlickEvent() 
  If GetActiveWindow_()=WindowID(0) 
    GetCursorPos_(CursorPosition) 
    id=WindowFromPoint_(CursorPosition\x,CursorPosition\y) 
    If id<>EventData\id 
      EventData\id=id 
      EventData\changed=1 
    EndIf 
    If EventData\pressed=0 And GetAsyncKeyState_(EventData\left)<>0 
      EventData\oldid=id 
      EventData\pressed=1 
      result=1 
    ElseIf EventData\pressed=1 And GetAsyncKeyState_(EventData\left)=0 
      If id=EventData\oldid    
        result=1 
      EndIf 
      EventData\pressed=0 
    EndIf 
  EndIf 
  If EventData\key>0:result=0:EventData\key-1:EndIf 
  ProcedureReturn result 
EndProcedure 

Procedure ButtonState() 
  ProcedureReturn EventData\pressed 
EndProcedure 
Procedure KlickID() 
  ProcedureReturn EventData\oldid 
EndProcedure 
Procedure MouseOverGadget() 
  result=EventData\changed 
  EventData\changed=0 
  ProcedureReturn result 
EndProcedure 
Procedure MouseOverID() 
  ProcedureReturn EventData\id 
EndProcedure 

OpenWindow(0, 100, 100, 400, 300,"Events",#PB_Window_SystemMenu) 
CreateStatusBar(1,WindowID(0)) 

CreateGadgetList(WindowID(0)) 
ButtonGadget(1, 160, 90,  80, 20, "Button-1") 
ButtonGadget(2, 160, 190,  80, 20, "Button-2") 

Repeat 
  EventID = WaitWindowEvent() 
  If RightKlickEvent() 
    If ButtonState() 
      Select KlickID() 
        Case GadgetID(1):info("Button-1 Right-Down") 
        Case GadgetID(2):info("Button-2 Right-Down") 
        Default:info("---") 
      EndSelect 
    Else 
      Select KlickID() 
        Case GadgetID(1):info("Button-1 Right-Up") 
        Case GadgetID(2):info("Button-2 Right-Up") 
        Default:info("---") 
      EndSelect 
    EndIf 
  ElseIf LeftKlickEvent() 
    If ButtonState() 
      Select KlickID() 
        Case GadgetID(1):info("Button-1 Left-Down") 
        Case GadgetID(2):info("Button-2 Left-Down") 
        Default:info("---") 
      EndSelect 
    Else 
      Select KlickID() 
        Case GadgetID(1):info("Button-1 Left-Up") 
        Case GadgetID(2):info("Button-2 Left-Up") 
        Default:info("---") 
      EndSelect 
    EndIf 
  ElseIf MouseOverGadget() 
      Select MouseOverID() 
        Case GadgetID(1):info("Button-1 Mouseover") 
        Case GadgetID(2):info("Button-2 Mouseover") 
        Default:info("---") 
      EndSelect 
  EndIf 
Until EventID = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; EnableXP
; DisableDebugger