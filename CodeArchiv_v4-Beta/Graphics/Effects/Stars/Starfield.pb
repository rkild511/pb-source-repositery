; German forum: 
; Author: benny
; Date: 10. November 2002
; OS: Windows
; Demo: No


;More stars

; Hier Bildschirmauflösung einstellen
#scrw = 1024
#scrh = 768

#centerofscrw = #scrw/2
#centerofscrh = #scrh/2

#scrd = 16

SSum.w = 8000 ; Amount of Stars


Cspeed.f=1
CameraZ.f=0

Gosub InitStarField

;-------- Init all needed Stuff --------
If InitSprite() = 0 Or InitKeyboard() = 0 Or InitMouse() = 0
  MessageBox_ (0,"Can't open DirectX 7 or later", "blahhhh", #MB_ICONINFORMATION|#MB_OK)
  End
EndIf

If OpenScreen(#scrw,#scrh,#scrd,"benny's code") = 0 
  MessageBox_ (0,"Could not open screen", "blahhh blaa", #MB_ICONINFORMATION|#MB_OK) 
  End 
EndIf

SetFrameRate(90) 


;-------- MainLoop --------
Repeat
  ClearScreen(RGB(0,0,0))
  StartDrawing(ScreenOutput())
    DrawingMode(1)
    Gosub DrawStarField
    Gosub MoveCamera
  StopDrawing() 
  FlipBuffers()
  ExamineKeyboard()
Until KeyboardPushed(#PB_Key_Escape) 
End


;--------- Procs / Subs -------------


; #### INITSTARFIELD ####
InitStarField:
; Structure of a star ...
Structure _3DStar
  X.f ; X-Coordinate
  Y.f ; Y-Coordinate
  z.f ; Z-Coordinate
EndStructure

; Init Starfield ...
Global Dim Stars._3DStar(SSum)
For dummy = 0 To SSum
  Stars(dummy)\X = Random(10000)-5000
  Stars(dummy)\Y = Random(10000)-5000
  Stars(dummy)\z = 100 + Random(1000)
Next dummy
Return


; ### Move Camera ###
MoveCamera:
  If CameraZ>1000
    Direction=-1
  ElseIf CameraZ<-1000
    Direction=1
  EndIf
  If Direction=1 And Cspeed<10
    Cspeed=Cspeed+0.01
  ElseIf Direction=-1 And Cspeed>-10
    Cspeed=Cspeed-0.01
  EndIf
  CameraZ=CameraZ+Cspeed
Return



; #### Draw StarField ####
DrawStarField:
For dummy = 0 To SSum
  If Stars(dummy)\z<CameraZ
    Stars(dummy)\z=CameraZ+1000
  ElseIf Stars(dummy)\z>(CameraZ+1000)
    Stars(dummy)\z=CameraZ
  EndIf
  
  SX = Stars(dummy)\X / (Stars(dummy)\z-CameraZ)*100+#centerofscrw
  SY = Stars(dummy)\Y / (Stars(dummy)\z-CameraZ)*100+#centerofscrh
  
  If SX<#scrw And SY<#scrh And SX>0 And SY>0 
    b.f = 255-(((Stars(dummy)\z)-CameraZ)*(255./1000.))
    c=Int(b)
    Plot ( SX, SY, RGB(c,c,c))
  EndIf 
  
Next dummy
Return

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -