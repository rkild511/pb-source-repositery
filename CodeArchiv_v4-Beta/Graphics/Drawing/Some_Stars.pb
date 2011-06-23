; English forum: 
; Author: benny (updated for PB3.93 by ts-soft, updated for PB4.00 by blbltheworm)
; Date: 10. November 2002
; OS: Windows
; Demo: No


; some stars
; benny! 2oo2

#scrw = 640
#scrh = 480

#centerofscrw = #scrw/2
#centerofscrh = #scrh/2

#scrd = 16

SSum.w = 1000 ; Amount of Stars


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
  
  Gosub DoStarField
  
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

x.f ; X-Coordinate
y.f ; Y-Coordinate
z.f ; Z-Coordinate
zv.f ; Z-Velocity

EndStructure

; Init Starfield ...

Global Dim Stars._3DStar(SSum)

For dummy = 0 To SSum

Stars(dummy)\x = Random(1000)-500
Stars(dummy)\y = Random(1000)-500
Stars(dummy)\z = 100 + Random(900)
Stars(dummy)\zv = 0.5 + Random (45)/10

Next dummy


Return


; #### DoStarField ####

DoStarField:


For dummy = 0 To SSum

Stars(dummy)\z = Stars(dummy)\z - Stars(dummy)\zv ; Star comes closer ....


SX = Stars(dummy)\x / Stars(dummy)\z * 100 + #centerofscrw
SY = Stars(dummy)\y / Stars(dummy)\z * 100 + #centerofscrh

If SX < 0 Or SY < 0 Or SX >= #scrw Or SY >= #scrh Or Stars(dummy)\z < 1

Stars(dummy)\x = Random(1000)-500
Stars(dummy)\y = Random(1000)-500
Stars(dummy)\z = 100 + Random(900)
Stars(dummy)\zv = 0.5 + ( Random(45) / 10 ) 

Else

b = 255-(Stars(dummy)\z *(255./1000.)) ; Calc the color of star

Plot ( SX, SY, RGB ( b,b,b ) )

EndIf 

Next dummy

Return

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger