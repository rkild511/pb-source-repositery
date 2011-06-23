; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9202&highlight=
; Author: Num3 (updated for PB4.00 by blbltheworm)
; Date: 17. January 2004
; OS: Windows
; Demo: No

; Many thanks to Danilo for the base code 
;My contribution is getting the background color 
;so the text background always "looks" transparent! 

Global TextGadgetBackground, TextGadgetForeground 

color= GetSysColor_(#COLOR_3DFACE) ; get color of the background 
TextGadgetBackground = CreateSolidBrush_(color) 
TextGadgetForeground = RGB($FF,$FF,$00) 

Procedure WinProc(hWnd,Msg,wParam,lParam) 
  If Msg = #WM_CTLCOLORSTATIC And lParam = GadgetID(0) 
    SetBkMode_(wParam,#TRANSPARENT) 
    SetTextColor_(wParam,TextGadgetForeground) 
    ProcedureReturn TextGadgetBackground 
  Else 
    ProcedureReturn #PB_ProcessPureBasicEvents 
  EndIf 
EndProcedure 

OpenWindow(0,0,0,200,25,"TextGadget Color",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
SetWindowCallback(@WinProc()) 
CreateGadgetList(WindowID(0)) 
TextGadget(0,5,5,190,15,"This text is colored") 
Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow 

DeleteObject_(TextGadgetBackground) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
