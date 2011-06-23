; English forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 08. November 2003
; OS: Windows
; Demo: Yes

;Timer with ElapsedMilliseconds() added by blbltheworm

;- Window Constants
;
#Window_0 = 0

;- Gadget Constants
;
#Gadget_0 = 5

;- Image Globals
#image1=10

LoadFont(2,"Arial",10)
Global texttoscroll.s
texttoscroll="This is line 1"

Global TextPos.l, sTimer.l

Procedure typetext(startpos)
  CreateImage(#image1, 300,200)
  StartDrawing(ImageOutput(#image1))
  DrawingMode(1)
  FrontColor(RGB(255,255,255))
  Box(0, 0, 300, 200)
  FrontColor(RGB(53,80,125))
  DrawingFont(FontID(2))

  DrawText(15,startpos,texttoscroll)

  StopDrawing()
EndProcedure

Procedure Timer()
  ; display text
  typetext(TextPos)
  SetGadgetState(#Gadget_0, ImageID(#image1))
  ; move up
  TextPos - 1
  ; stop when text reaches top
  If TextPos < 0
    ;reset Timer
    sTimer=0
  EndIf
EndProcedure

If OpenWindow(#Window_0, 216, 0, 450, 300, "New window ( 0 )", #PB_Window_SystemMenu)
  If CreateGadgetList(WindowID(#Window_0))
    TextPos = 200
    typetext(TextPos)
    ImageGadget(#Gadget_0, 70, 35,300,200, ImageID(#image1),#PB_Image_Border)

    ; Set StartTime
    sTimer=ElapsedMilliseconds()

    Repeat
      evnt=WindowEvent()
      If ElapsedMilliseconds()-sTimer > 15 And sTimer<>0
        Timer()
      EndIf
      If evnt=#WM_CLOSE
        quit=1
      EndIf
      Delay(1)
    Until quit=1
  EndIf
EndIf
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -