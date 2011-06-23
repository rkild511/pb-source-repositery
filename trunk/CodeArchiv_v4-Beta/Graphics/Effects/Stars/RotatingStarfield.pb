; English forum: http://www.purebasic.fr/english/viewtopic.php?t=3723&highlight=
; Author: Pupil (updated for PB4.00 by blbltheworm)
; Date: 18. April 2002
; OS: Windows
; Demo: Yes

;-----------------------------------------
;---------- STARFIELD DEMO----------------
;-----------------------------------------
;-------- Blitz to purebasic--------------
;-----------------------------------------


#width=800
#height=600



Global MAX_STAR=4000, STAR_SPEED=3, star_x, star_y, start_z

Global Dim star_x.l(MAX_STAR)
Global Dim star_y.l(MAX_STAR)
Global Dim star_z.l(MAX_STAR)

If InitSprite() = 0
  MessageRequester("Error", "Can't open DirectX 7 Or later", 0)
  End
EndIf

If InitKeyboard() = 0
  MessageRequester("Error","Can't open DirectX 7 Or later",0)
  End
EndIf

If OpenScreen( #width,#height, 32, "Sprite")
  Goto StartGame
Else
  MessageRequester("Error", "Can't open screen !", 0)
EndIf
End

Procedure rnd(min.w,max.w)
  a.w = max - Random (max-min)
  ProcedureReturn a
EndProcedure

Procedure setup_stars()
  For c.w=0 To MAX_STAR
    star_x(c)= Rnd(-#width/2,#width/2) << 6
    star_y(c)= Rnd(-#height/2,#height/2) << 6
    star_z(c)=Rnd(2,255)
  Next
  StartDrawing(ScreenOutput())
  For i = 0 To 255
    FrontColor(RGB(i,i,i))
    Box(i*3, 0, 3, 3)
  Next
  StopDrawing()
  For i = 0 To 255
    GrabSprite(i, i*3, 0, 3, 3)
  Next
  ProcedureReturn value
EndProcedure

Procedure UpdateStar()
  cos.f = Cos(0.01) : sin.f = Sin(0.01)
  For c = 0 To MAX_STAR
    star_z(c)=star_z(c) - STAR_SPEED
    x.l = star_x(c)
    y.l = star_y(c)
    star_y(c) = (y * cos - x * sin)
    star_x(c) = (x * cos + y * sin)
    If star_z(c)<=2
      star_z(c)=255
    EndIf
    s_x.w=(star_x(c)/star_z(c))+(#width/2)
    s_y.w=(star_y(c)/star_z(c))+(#height/2)
    col.w=255-star_z(c)
    DisplaySprite(col,s_x, s_y)
  Next
  ProcedureReturn value
EndProcedure


;-------------------------
; Game-LOOP
;-------------------------
StartGame:
setup_stars()

Repeat
  
  FlipBuffers()
  ClearScreen(RGB(0,0,0))
  
  updatestar()
  
  ExamineKeyboard()
  If KeyboardPushed(#PB_Key_Escape) ; If ESCAPE is pressed: END
    End
  EndIf
  
ForEver

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
