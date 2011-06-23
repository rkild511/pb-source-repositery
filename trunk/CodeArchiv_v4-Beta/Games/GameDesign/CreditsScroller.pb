; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5357&highlight=
; Author: Epyx (updated for PB 4.00 by Andre)
; Date: 13. August 2004
; OS: Windows
; Demo: Yes



X= InitSprite()   : If X=0 : MessageRequester("Test - DirectX Error"," - ",#MB_ICONERROR) : End : EndIf
X= InitSprite3D() : If X=0 : MessageRequester("Test - 3D Hardware Error"," - ",#MB_ICONERROR) : End : EndIf
X= InitKeyboard()

#Fullscreen= 0

If #Fullscreen=0
  hWnd=OpenWindow(0,0,0,640,480,"Credit Scroller",#PB_Window_SystemMenu|#PB_Window_WindowCentered)
  X=OpenWindowedScreen(hWnd,0,0,640,480,0,0,0)
Else

  X= OpenScreen(640, 480, 32, "Credit Scroller")

EndIf




; Text Sprite erstellen
If CreateSprite(1, 640, 480)
  If StartDrawing(SpriteOutput(1))
    DrawingMode(1)
    For t=0 To 24
      FrontColor(RGB(Random(255),Random(255),Random(255))) : DrawText(0, t*20, "Credits Line number "+Str(t)+" ----------------------------------Epyx Epyx Epyx Epyx ---------   Epyx Epyx Epyx")
    Next t
    StopDrawing()
  EndIf
EndIf


; Eine Zeile zum ein und Ausblenden erstellen
If CreateSprite(2, 640, 1,#PB_Sprite_Texture)
  If StartDrawing(SpriteOutput(2))
    Box(0, 0, 640, 1 , RGB(1,1,1)) ; Ein 0,0,0 bei der Farbe wirds komplett durchsichtig, ansonsten gehen aber auch  Farben
    StopDrawing()
  EndIf
  CreateSprite3D(2, 2)
EndIf






Repeat
  If #Fullscreen=0
    Event = WindowEvent()
    Select Event
      Case #PB_Event_CloseWindow
        End
    EndSelect
  EndIf



  ExamineKeyboard()
  If KeyboardPushed(#PB_Key_Escape) : Taste=1 : EndIf


  ClearScreen(RGB(0, 0,0))
  DisplaySprite(1,0,YY_pos) ; Text Darstellen


  ; Text bewegen
  YY_pos-1 : If YY_pos<-500 : YY_pos=480 : EndIf


  ; Ein und ausblenden des Textes
  Start3D()
  For t=0 To 256
    DisplaySprite3D(2, 0, (224+t), t)
    DisplaySprite3D(2, 0, t, (256-t))
  Next t
  Stop3D()

  FlipBuffers()
Until (Taste<>0)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -