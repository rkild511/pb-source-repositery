; English forum: 
; Author: PB (updated for PB4.00 by blbltheworm)
; Date: 21. January 2003
; OS: Windows
; Demo: No


; Resolution-independent window example.
; By PB -- feel free to use in any way you wish.
; Callback modification provided by Benny Sels.
;
; Fixed main loop (there were two WaitWindowEvent()!!) by Andre Beer  09 June 2003

Form1_W=312 ; Form's client width.
Form1_H=213 ; Form's client height.
Form1_X=(GetSystemMetrics_(#SM_CXSCREEN)-Form1_W)/2 ; Centered horizontally.
Form1_Y=(GetSystemMetrics_(#SM_CYSCREEN)-Form1_H)/2 ; Centered vertically.
;
Global Form1_hWnd,Form1_OrigW,Form1_OrigH
;
#Form1_Flags=#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget|#PB_Window_SizeGadget|#PB_Window_SystemMenu
Form1_hWnd=OpenWindow(0,Form1_X,Form1_Y,Form1_W,Form1_H,"Form1",#Form1_Flags)
If Form1_hWnd=0 Or CreateGadgetList(Form1_hWnd)=0 : End : EndIf
;
Form1_OrigW=WindowWidth(0)  ; Original non-client width.
Form1_OrigH=WindowHeight(0) ; Original non-client height.
;
#Form1_Command1=1 : Form1_Command1_hWnd=ButtonGadget(#Form1_Command1,8,8,81,33,"Command1")
#Form1_Command2=2 : Form1_Command2_hWnd=ButtonGadget(#Form1_Command2,224,8,81,33,"Command2")
#Form1_Command3=3 : Form1_Command3_hWnd=ButtonGadget(#Form1_Command3,120,88,81,33,"Command3")
#Form1_Command4=4 : Form1_Command4_hWnd=ButtonGadget(#Form1_Command4,8,176,81,33,"Command4")
#Form1_Command5=5 : Form1_Command5_hWnd=ButtonGadget(#Form1_Command5,224,176,81,33,"Command5")
;
Procedure MyWindowCallback(WindowId, Message, wParam, lParam) 
  Result = #PB_ProcessPureBasicEvents 
    Select Message
    Case #WM_SIZE ; Form's size has changed.
      ;
      Form1_RatioW.f=WindowWidth(0)/Form1_OrigW ; Get horizontal difference.
      Form1_RatioH.f=WindowHeight(0)/Form1_OrigH ; Get vertical difference.
      ;
      ResizeGadget(#Form1_Command1,8*Form1_RatioW,8*Form1_RatioH,81*Form1_RatioW,33*Form1_RatioH)
      ResizeGadget(#Form1_Command2,224*Form1_RatioW,8*Form1_RatioH,81*Form1_RatioW,33*Form1_RatioH)
      ResizeGadget(#Form1_Command3,120*Form1_RatioW,88*Form1_RatioH,81*Form1_RatioW,33*Form1_RatioH)
      ResizeGadget(#Form1_Command4,8*Form1_RatioW,176*Form1_RatioH,81*Form1_RatioW,33*Form1_RatioH)
      ResizeGadget(#Form1_Command5,224*Form1_RatioW,176*Form1_RatioH,81*Form1_RatioW,33*Form1_RatioH)
      ;
    EndSelect
  ProcedureReturn Result 
EndProcedure 
;
SetWindowCallback(@MyWindowCallback())
Repeat
  ev.l=WaitWindowEvent()
Until ev=#PB_Event_CloseWindow
;
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP