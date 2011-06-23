; German forum: http://www.purebasic.fr/german/viewtopic.php?t=3558&highlight=
; Author: Lebostein (updated for PB 4.00 by Andre)
; Date: 07. June 2005
; OS: Windows
; Demo: Yes

InitSprite()
InitKeyboard()
Dim sternp(1000,1)
Dim sternm(1000,1)

ExamineDesktops()
Screenwidth  = DesktopWidth(0)
Screenheight = DesktopHeight(0)

OpenScreen(Screenwidth,Screenheight,16,"sterne")

For a = 0 To 1000
  For b = 0 To 1
    sternm(a, b) = Random(20) - 10
  Next b
  sternp(a, 0) = Screenwidth / 2
  sternp(a, 1) = Screenheight / 2 
Next a

Repeat
  ExamineKeyboard()
  ClearScreen(RGB(0,0,0))
  
  StartDrawing(ScreenOutput())
  
  For a = 0 To 999
    If sternp(a, 0) < 0 Or sternp(a, 0) >= Screenwidth Or sternp(a, 1) < 0 Or sternp(a, 1) >= Screenheight
      sternp(a, 0) = Screenwidth / 2 : sternp(a, 1) = Screenheight / 2
      sternm(a,0) = Random(20) - 10
      If sternm(a,0) = 0
        sternm(a,0) = sternm(a,0) + Random(3)
      EndIf
      sternm(a,1) = Random(20) - 10
      If sternm(a,1) = 0
        sternm(a,1) = sternm(a,1) + Random(3)
      EndIf
      If sternm(a,1) = sternm(a,0)
        sternm(a,1) = sternm(a,1) + Random(3)
      EndIf
    EndIf
    Plot(sternp(a, 0), sternp(a, 1), RGB(255,255,255))
    sternp(a, 0) = sternp(a, 0) + sternm(a, 0)*2
    sternp(a, 1) = sternp(a, 1) + sternm(a, 1)*2
  Next a
  Plot(0,0,RGB(0,0,0))
  
  StopDrawing()
  
  FlipBuffers()
Until KeyboardPushed(#PB_Key_Escape)
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger