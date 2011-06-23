; http://www.purearea.net
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 16. August 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,0,0,240,180,"ListIcon Image",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
  ListIconGadget(0,10,10,220,160,"Column 1",150,#PB_ListIcon_GridLines)
  If LoadImage(0,"..\..\Graphics\Gfx\map2.bmp")     ; load your own 32x32 pixel image
    ResizeImage(0,16,16)         ; resize it to the standard 16x16 icon size
  EndIf
  For a=1 To 10
      AddGadgetItem (0, -1, "Image Item "+Str(a),ImageID(0))  ; add 10 items with additional image
    Next
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP