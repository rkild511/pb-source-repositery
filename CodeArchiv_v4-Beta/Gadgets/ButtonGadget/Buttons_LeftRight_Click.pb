; German forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 21. June 2003
; OS: Windows
; Demo: No

Global RKlick,Pressed,Mousevent,CursorPosition.POINT 

Procedure info(text.s) 
  MessageRequester("Ergebnis",text,0) 
EndProcedure 

Procedure RButtonControl() 
  If Pressed=0 And GetAsyncKeyState_(RKlick)<>0 And GetActiveWindow_()=WindowID(0) 
    Pressed=1:mouse_event_(#MOUSEEVENTF_LEFTDOWN,0,0,0,0) 
  ElseIf Pressed=1 And GetAsyncKeyState_(RKlick)=0    
    Pressed=0:Mousevent=1:mouse_event_(#MOUSEEVENTF_LEFTUP,0,0,0,0) 
    GetCursorPos_(CursorPosition) 
    ID=WindowFromPoint_(CursorPosition\x,CursorPosition\y) 
    Select ID 
      Case GadgetID(1):info("Button-1 Rechtsklick") 
      Case GadgetID(2):info("Button-2 Rechtsklick") 
    EndSelect 
  EndIf 
EndProcedure 

OpenWindow(0, 100, 100, 400, 300,"Rechtsklick-Test",#PB_Window_SystemMenu) 

CreateGadgetList(WindowID(0)) 
ButtonGadget(1, 160, 90,  80, 20, "Button-1") 
ButtonGadget(2, 160, 190,  80, 20, "Button-2") 

If GetSystemMetrics_(#SM_SWAPBUTTON)=0 
  RKlick=#VK_RBUTTON ;Linkshänder 
Else 
  RKlick=#VK_LBUTTON ;Rechtshänder 
EndIf 

Repeat 
  EventID = WaitWindowEvent() 
  If Mousevent=0 
    If EventID = #PB_Event_Gadget 
      Select EventGadget() 
        Case 1:info("Button-1 Linksklick") 
        Case 2:info("Button-2 Linksklick") 
      EndSelect 
    EndIf 
  Else 
    Mousevent=0 
  EndIf 
  RButtonControl() 
Until EventID = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP