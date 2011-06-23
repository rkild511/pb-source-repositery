; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 11. May 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,0,0,245,105,"ImageGadget",#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0))
  If LoadImage(0, "..\..\Graphics\Gfx\map.bmp")    ; change 2nd parameter to the path/filename of your image
    ImageGadget(0, 10,10,100,83,ImageID(0))                      ; imagegadget standard
    ImageGadget(1,130,10,100,83,ImageID(0),#PB_Image_Border)     ; imagegadget with border
  EndIf
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger