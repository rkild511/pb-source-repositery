; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8181&highlight=
; Author: Berikco (updated for PB 4.00 by Andre)
; Date: 07. March 2005
; OS: Windows
; Demo: No


; Updated by Fred for use with PB 3.93

OpenWindow(0,100,150,400,400,"TEST",#PB_Window_SystemMenu) 

Global Yellow, Green, blauw 
Yellow = CreateSolidBrush_($66E8FB) 
Green = CreateSolidBrush_($7BDF84) 
blauw = CreateSolidBrush_($E5B91A) 

Procedure myCallback(WindowID, Message, wParam, lParam) 
  Result = #PB_ProcessPureBasicEvents 
  Select Message 
  Case #WM_CTLCOLORSTATIC 
    If IsGadget(1) And lparam = GadgetID(1) 
      SetBkMode_(wParam,#TRANSPARENT) 
      SetTextColor_(wParam, $FFFFFF) 
      Result = Yellow 
    ElseIf IsGadget(4) And lparam = GadgetID(4) 
      SetBkMode_(wParam,#TRANSPARENT) 
      SetTextColor_(wParam, $FFFFFF) 
      Result = blauw 
    EndIf 
  Case #WM_CTLCOLOREDIT 
    If IsGadget(1) And lparam = GadgetID(3) 
      SetBkColor_(wParam, $7BDF84) 
      SetTextColor_(wParam, $FFFFFF) 
      Result = green 
    EndIf 
  EndSelect 
  ProcedureReturn Result 
EndProcedure 

SetWindowCallback(@myCallback()) 
CreateGadgetList(WindowID(0)) 
TextGadget(1,10,10,100,15,"Hoegaarden",#PB_Text_Center) 
TextGadget(2,120,10,100,15,"Jupiler",#PB_Text_Center) 
StringGadget(3, 10, 40, 200, 40, "Goedendag allemaal, voor mij een pintje" , #ES_MULTILINE) 
CheckBoxGadget(4, 10, 90,100, 20, "Beer Here") 

Repeat 
Until WaitWindowEvent() = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger