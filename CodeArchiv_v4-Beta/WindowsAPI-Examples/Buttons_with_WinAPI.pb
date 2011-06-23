; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=951&highlight=
; Author: FreeDimension (updated for PB4.00 by blbltheworm)
; Date: 09. May 2003
; OS: Windows
; Demo: No

OpenWindow(1, 10, 150, 150, 80, "Button OwnerDraw", #PB_Window_TitleBar | #PB_Window_SystemMenu) 

CreateGadgetList(WindowID(1)) 

a.l = ButtonGadget(1, 5, 5, 78, 20, "Hallo", #BS_OWNERDRAW) 
b.l = ButtonGadget(2, 5, 30, 78, 20, "Hallo", #BS_OWNERDRAW) 

Global hBrButton1.l, hBrButton2.l, hBrButton3.l, hBrButton4.l 

normal        = LoadImage(1, "..\Graphics\Gfx\Buttons\btnNormal.bmp") 
normal_focus  = LoadImage(2, "..\Graphics\Gfx\Buttons\btnNormalFocus.bmp") 
pressed       = LoadImage(3, "..\Graphics\Gfx\Buttons\btnPressed.bmp") 
pressed_focus = LoadImage(4, "..\Graphics\Gfx\Buttons\btnPressedFocus.bmp") 

Procedure mcb(WindowID, Message, wParam, lParam) 
  Result = #PB_ProcessPureBasicEvents 
  If Message = #WM_DRAWITEM 
    *dis.DRAWITEMSTRUCT 
    *dis = lParam 
    If *dis\itemState & #ODS_SELECTED 
      If *dis\itemState & #ODS_FOCUS 
        FillRect_(*dis\hDC, *dis\rcItem, hBrButton4) 
      Else 
        FillRect_(*dis\hDC, *dis\rcItem, hBrButton2) 
      EndIf 
    Else 
      If *dis\itemState & #ODS_FOCUS 
        FillRect_(*dis\hDC, *dis\rcItem, hBrButton3) 
      Else 
        FillRect_(*dis\hDC, *dis\rcItem, hBrButton1) 
      EndIf 
    EndIf 
  EndIf 
  ProcedureReturn Result 
EndProcedure 

hBrButton1 = CreatePatternBrush_(normal) 
hBrButton2 = CreatePatternBrush_(normal_focus) 
hBrButton3 = CreatePatternBrush_(pressed) 
hBrButton4 = CreatePatternBrush_(pressed_focus) 

SetWindowCallback(@mcb()) 

Repeat 
  event = WaitWindowEvent() 
Until event = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
