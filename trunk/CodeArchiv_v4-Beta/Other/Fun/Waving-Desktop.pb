; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3513&highlight=
; Author: KuschelTeddy82 (improved by Kristel, updated for PB 4.00 by Andre)
; Date: 21. January 2004
; OS: Windows
; Demo: No

If InitSprite()=0 : End : EndIf
If InitKeyboard()=0 : End : EndIf

Procedure MakeDesktopScreenshot(ImageNr,x,y,Width,Height)
  hImage = CreateImage(ImageNr,Width,Height)
  hDC    = StartDrawing(ImageOutput(ImageNr))
  DeskDC = GetDC_(GetDesktopWindow_())
  BitBlt_(hDC,0,0,Width,Height,DeskDC,x,y,#SRCCOPY)
  StopDrawing()
  ReleaseDC_(GetDesktopWindow_(),DeskDC)
  ProcedureReturn hImage
EndProcedure

; Ermitteln der Desktop-Auflösung
screenX  = GetSystemMetrics_(#SM_CXSCREEN)
screenY  = GetSystemMetrics_(#SM_CYSCREEN)
MakeDesktopScreenshot(0, 0, 0, screenX, screenY)


OpenScreen(screenX, screenY, 32, "Fake Desktop")

; ScreenShot auf das Sprite bringen
CreateSprite(0, screenX, screenY, 0)
StartDrawing(SpriteOutput(0))
DrawImage(ImageID(0), 0, 0)
StopDrawing()

; Wellenberechnung und Darstellung
i1=0 : i2=0 : wavesize.f=1
Repeat
  For y=0 To screenY Step 1
    wave1 = 0 - wavesize * Sin((i1+y)/32)
    posX = (0 - (wavesize/1.5) * Cos((i2+y+wave1)/70)) + wave1
    ClipSprite(0, 0, y, screenX, 1)
    DisplaySprite(0, posX, y)
  Next
  i1+2 : i2-5
  If wavesize<50 : wavesize+0.01 : EndIf

  FlipBuffers() : ClearScreen(RGB(0,0,0))
  ExamineKeyboard()
Until KeyboardReleased(#PB_Key_Escape)
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger