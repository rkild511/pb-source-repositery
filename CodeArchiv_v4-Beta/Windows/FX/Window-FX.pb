; English forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 21. January 2003
; OS: Windows
; Demo: No


#AW_HOR_POSITIVE = $1 ;Animates the window from left To right. This flag can be used with roll Or slide animation.
#AW_HOR_NEGATIVE = $2 ;Animates the window from right To left. This flag can be used with roll Or slide animation.
#AW_VER_POSITIVE = $4 ;Animates the window from top To bottom. This flag can be used with roll Or slide animation.
#AW_VER_NEGATIVE = $8 ;Animates the window from bottom To top. This flag can be used with roll Or slide animation.
#AW_CENTER = $10      ;Makes the window appear To collapse inward If AW_HIDE is used Or expand outward If the AW_HIDE is not used.
#AW_HIDE = $10000     ;Hides the window. By default, the window is shown.
#AW_ACTIVATE = $20000 ;Activates the window.
#AW_SLIDE = $40000    ;Uses slide animation. By default, roll animation is used.
#AW_BLEND = $80000    ;Uses a fade effect. This flag can be used only If hwnd is a top-level window.


 
   
If OpenWindow(0,(GetSystemMetrics_(#SM_CXSCREEN)-318)/2,(GetSystemMetrics_(#SM_CYSCREEN)-220)/2, 318, 220,"Window FX", #PB_Window_SystemMenu|#WS_VISIBLE)
AnimateWindow_(WindowID(0),200,#AW_HOR_POSITIVE|#AW_VER_POSITIVE)

  Repeat 
    EventID.l = WaitWindowEvent()   

  Until EventID = #PB_Event_CloseWindow
  AnimateWindow_(WindowID(0),200,#AW_BLEND | #AW_HIDE)
EndIf

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -