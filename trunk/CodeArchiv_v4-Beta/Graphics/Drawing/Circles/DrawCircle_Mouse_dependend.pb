; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2161&highlight=
; Author: Franky (updated for PB4.00 by blbltheworm)
; Date: 01. September 2003
; OS: Windows
; Demo: No


; Paint a circle, automatically resizing depending on the mouse position...

If OpenWindow(0,100,100,400,400,"Autokreis",#PB_Window_SystemMenu)
  OpenWindow(1,0,0,400,400,"",#PB_Window_BorderLess)
  SetParent_(WindowID(1),WindowID(0))
  startx=200
  starty=200
  Repeat
    If startx<WindowMouseX(1)
      arealang=WindowMouseX(1)-startx+1
    Else
      arealang=startx-WindowMouseX(1)-1
    EndIf
    If starty<WindowMouseY(1)
      areahoch=WindowMouseY(1)-starty+1
    Else
      areahoch=starty-WindowMouseY(1)-1
    EndIf
    arealang=Pow(arealang,2)
    areahoch=Pow(areahoch,2)
    radius=Sqr(areahoch+arealang)
    StartDrawing(WindowOutput(1))
    Box(0,0,400,400)
    FrontColor(RGB(255,0,0))
    Circle(startx,starty,radius)
    StopDrawing()
    event=WaitWindowEvent()
  Until event=#WM_CLOSE
EndIf

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
