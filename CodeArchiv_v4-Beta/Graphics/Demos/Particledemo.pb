; English forum: 
; Author: Rings (updated for PB4.00 by blbltheworm)
; Date: 31. December 2002
; OS: Windows
; Demo: No

;----------------------------------------------
; ParticleDemo Effect in PureBasic
; by S.Rings(-CodeGuru-) in 2002
;----------------------------------------------
    
#scrw = 640;800
#scrh = 480;600
#scrd = 16

Structure Particle
 X.f
 Y.f
 velocity.f
 speed.f
 xoff.f
 color.l
 heat.f
EndStructure

Num=1000;count of particles
Global Dim Part.Particle(Num)

Gravity.f=0.65
strength.f=2

For i = 1 To Num
 Gosub ParticleInit
Next i
;-------- Init all needed Stuff --------
If InitSprite() = 0 Or InitKeyboard() = 0 Or InitMouse() = 0
  MessageBox_ (0,"Can't open DirectX 7 or later", "-Codeguru-", #MB_ICONINFORMATION|#MB_OK)
  End
EndIf
If OpenScreen(#scrw,#scrh,#scrd,"ParticleDemo by -CodeGuru-") = 0  
  MessageBox_ (0,"Could not open  screen", "ParticleDemo by -CodeGuru-", #MB_ICONINFORMATION|#MB_OK) 
  End                                                                                     
EndIf

SetFrameRate(60)      
   
;-------- MainLoop --------
Repeat
  ClearScreen(RGB(0,0,0))

  ExamineMouse()
  musx = MouseX()
  musy = MouseY()
  
  StartDrawing(ScreenOutput())
    Gosub ParticleMove
    For i = 1 To Num
     Plot (Int(Part(i)\X) ,Int(Part(i)\Y), Part(i)\color)
    Next i
   
    DrawingMode(1)
    FrontColor(RGB(100,100,255))
    DrawText(#scrw/2-100,#scrh/2,"ParticleDemo by -CodeGuru-")

  StopDrawing()  
  FlipBuffers()
  ExamineKeyboard()
Until KeyboardPushed(#PB_Key_Escape) 
End

ParticleInit:
   Part(i)\Y = musy;#scrh/2
   Part(i)\X = musx;#scrw/2
   Part(i)\xoff = Random(100)/100 * -strength + Random(100)/100 * strength
   Part(i)\velocity = 0.5
   Part(i)\speed = Random(100)/100 * 15
   t=Random(55)
   Part(i)\color = RGB(200+t,200+t,200+t)
Return

ParticleMove:
For i = 1 To Num
  Part(i)\speed = (Part(i)\speed + Part(i)\velocity) - Gravity
  Part(i)\Y = (Part(i)\Y - Part(i)\speed)
  Part(i)\X = Part(i)\X + Part(i)\xoff
  Part(i)\heat = Part(i)\heat + 3
  If Int(Part(i)\Y) >= #scrh Or Int(Part(i)\Y) <= 0 Or Int(Part(i)\X) <= 0 Or Int(Part(i)\X) >= #scrw 
   Gosub ParticleInit:
  EndIf
Next i
Return

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -