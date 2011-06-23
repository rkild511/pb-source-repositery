; German forum: 
; Author: Bluespeed (updated for PB4.00 by blbltheworm)
; Date: 31. December 2002
; OS: Windows
; Demo: No


;----------------------||
; PB-Graphics effect   ||
; Scroller             ||
; by bluespeed         ||
;----------------------||

;---------------------
; Constants
;--------------------
#FONT_NORMAL    = %00000000
#FONT_BOLD      = %00000001
#FONT_ITALIC    = %00000010
#FONT_UNDERLINE = %00000100
#FONT_STRIKEOUT = %00001000

;---------------------
; Procedures
;--------------------
Procedure CreateFont(Name$,Size,Style)
   If (Style & #FONT_BOLD)      : bold = 700    : EndIf
   If (Style & #FONT_ITALIC)    : italic = 1    : EndIf
   If (Style & #FONT_UNDERLINE) : underline = 1 : EndIf
   If (Style & #FONT_STRIKEOUT) : strikeout = 1 : EndIf
   ProcedureReturn CreateFont_(Size,0,0,0,bold,italic,underline,strikeout,0,0,0,0,0,Name$)
EndProcedure

Procedure.f GSin(winkel.f)
   ; Eingabe: Winkel ( 0 - 360 )
   ; Ausgabe: Sinus vom Winkel
   ProcedureReturn Sin(winkel*(2*3.14159265/360))
EndProcedure

Procedure.f GCos(winkel.f)
   ; Eingabe: Winkel ( 0 - 360 )
   ; Ausgabe: Cosinus vom Winkel
   ProcedureReturn Cos(winkel*(2*3.14159265/360))
EndProcedure

;-----------------------
;  Init-Stuff   
;-----------------------
If InitSprite() = 0
   MessageRequester("Error","Can't find DX7 or higher",0) : End 
EndIf   

If InitKeyboard() = 0
   MessageRequester("Error","Can't find DX7 or higher",0) : End 
EndIf   

If OpenScreen(800,600,32,"Sinus-lines") = 0
   MessageRequester("Error","Can't open a Fullscreen",0)
Else
  ;-----------------------
  ; Structure-Stuff
  ;-----------------------       
  Structure ppoints
     point_x.l
     point_y.l
  EndStructure

  ;----------------------
  ; Allocation
  ;----------------------
  Global Dim points.ppoints(999)
  For p = 0 To 999
    points(p)\point_x= Random (800)
    points(p)\point_y= Random (400)
    Next 
  p = 0 

  Global Dim story.s(30)
  story(0)  = " _-| A STORY OF A HERO |-_"
  story(1)  = "Here is a small oldschool looking"
  story(2)  = "graphics effect. Why i've programmed it,"
  story(3)  = "you ask? I'll tell ya: It began in an "
  story(4)  = "awful night where a boy wanted to "
  story(5)  = "show the world, that PB isnt only "
  story(6)  = "for apps - and when PB 3.0 will"
  story(7)  = "be released, BlitzBasic will lose its  "
  story(8)  = "rang. Then there will exist a language"
  story(9)  = "called PureBasic, with the pure"
  story(10) = "power to make GAMES and PROGRAMS, and"
  story(11) = "everyone will use it. It will get a "
  story(12) = "name 'the New QuickBasic', i hope u "
  story(13) = "dont misunderstand it when i say PB "
  story(14) = "is Perfect and it will open a new BASIC"
  story(15) = "Area where the BASIC syntax and the Pure"
  story(16) = "speed will dominate. Who makes this cool "
  story(17) = "and easy language? His name is 'Fred' "
  story(18) = "and he is doing a big and good job."
  story(19) = "If u want to see this language, look at"
  story(20) = "www.purebasic.com and if you are a german"
  story(21) = "coder look at http://www.purebasic.de ."
  story(22) = "Hmm.....sorry folks, but thats the only way"
  story(23) = "to write a long text for this scroller . "
  story(24) = "If u want some german tutorials, look at: "
  story(25) = "www.purehilfe.de.vu - at the moment there "
  story(26) = "are 17 Tutorials. When i get the fullversion"
  story(27) = "of PB, i'll start to program a game in PB ! "
  story(28) = "Plz dont look at the mistakes in my text -"
  story(29) = "english isnt my favorite language  " 
  story(30) = "cya bluespeed"

  ;---------------------
  ; Font
  ;--------------------
  Font1 = CreateFont("Courier"       ,20,#FONT_BOLD)
  Font2 = CreateFont("Lucida Console",14,#FONT_BOLD)
  Font3 = CreateFont("Arial"         ,72,#FONT_BOLD)

  ;------------------------
  ; M A I N  L O O P
  ;------------------------ 
  SetFrameRate(30)
  PB_LOGO_Y = 700
  Logo$ = "PureBasic!"

  Repeat 
    FlipBuffers()
    ExamineKeyboard()       
   
    If IsScreenActive()
      If BoxWidth  < 800 : BoxWidth  + 4 : EndIf
      If PB_LOGO_Y > 520 : PB_LOGO_Y - 1 : EndIf
      ClearScreen(RGB(0,0,0))
     
      StartDrawing(ScreenOutput())
          Box(0,100,BoxWidth,400,$FFFFFF)
          DrawingMode(1)
          FrontColor(RGB($00,$00,$00))
            For p = 0 To 999
               points(p)\point_x + Random(3) ; 2
                If points(p)\point_x > 800
                   points(p)\point_x = 0
                EndIf
               points(p)\point_y+ Random(3) ; 2
                If points(p)\point_y > 400
                   points(p)\point_y = 0
                EndIf
              Plot(points(p)\point_x,points(p)\point_y+100)
            Next
             
        ; Draw Rasterlines
        Raster_y1=280+GSin(degree)*160
        Raster_y2=280+GSin(degree+180)*160
        If Raster_y1 = 280-160 And Raster_vorn = 1: Raster_vorn=0 : EndIf
        If Raster_y2 = 280-160 And Raster_vorn = 0: Raster_vorn=1 : EndIf
       
        If Raster_vorn
           Gosub Draw_Red_Raster_Bar
           Gosub Draw_Blue_Raster_Bar
        Else
           Gosub Draw_Blue_Raster_Bar
           Gosub Draw_Red_Raster_Bar
        EndIf
       

        FrontColor(RGB($00,$00,$00))
        If y1 => -1800
           DrawingFont(Font1)
             y = 600
             y1 - 1
           For s = 0 To 30
             DrawText(50,y+y1,story(s)) 
             y + 40
           Next
        ElseIf y1 <= -1800 And y1 => -2000
           Box(0,100,CloseEffect,400,0)
           Box(800-CloseEffect,100,CloseEffect,400,0)
           CloseEffect + 2
           y1 - 1
        ElseIf y1 <= -2000 And y1 => -2100
           Box(0,100,800,400,0)
           DrawingFont(Font3)
           FrontColor(RGB($FF,$FF,$FF))
           ; ONE
           If y1 < -2020
             DrawText(200-TextWidth("ONE")/2,182,"ONE")
           EndIf
           ; TWO
           If y1 < -2040
             DrawText(600-TextWidth("TWO")/2,182,"TWO")
           EndIf
           ; THREE
           If y1 < -2060
             DrawText(200-TextWidth("THREE")/2,382,"THREE")
           EndIf
           ; FOUR
           If y1 < -2080
             DrawText(600-TextWidth("FOUR")/2,382,"FOUR")
           EndIf

           y1 - 1
        ElseIf y1 <= -2100 And y1 => -2300
           Box(0,100,800,CloseEffect,0)
           Box(0,100,CloseEffect,400,0)
           Box(800-CloseEffect,100,400,400,0)
           CloseEffect - 2
           y1 - 1
        Else
           y1 = 0 : CloseEffect = 0
        EndIf
   
        ; Draw "Bluespeed"
        DrawingFont(Font2)
        FrontColor(RGB($FF,$FF,color))
        DrawText(BlueSpeedX,BlueSpeedY,"Bluespeed")
        ; Bluespeed Logo coordinates
        BlueSpeedX = 400-TextWidth("BlueSpeed")/2 + GSin(degree*2)*300
        BlueSpeedY = 43 + GCos(degree)*40
        degree + 1 : If degree = 360 : degree = 0 : EndIf

        ; draw Logo$
        DrawingFont(Font3)
        ; 520
        FrontColor(RGB(color,color,color))
        DrawText(400-TextWidth(Logo$)/2,PB_LOGO_Y,Logo$)
        ; Color change for "PureBasic"
        If colorflag = 0
           color + 5 : If color => 256  : color = 255 : colorflag = 1 : EndIf
        Else
           color - 5 :
           If color <= -1
              color  =  0 : colorflag = 0
              Select Logo$
                 Case "PureBasic!"   : Logo$ = "Pure Fun"
                 Case "Pure Fun"     : Logo$ = "Pure Power"
                 Case "Pure Power"   : Logo$ = "Pure Speed"
                 Case "Pure Speed"   : Logo$ = "Pure Control"
                 Case "Pure Control" : Logo$ = "PureBasic!"
              EndSelect
           EndIf
        EndIf

      StopDrawing()
    EndIf

  Until KeyboardPushed(#PB_Key_Escape)

  ; Delete Fonts
  DeleteObject_(Font1)
  DeleteObject_(Font2)
  DeleteObject_(Font3)

EndIf
End

Draw_Red_Raster_Bar:
   For tt = 0 To 25
     LineXY(0, Raster_y1+tt, BoxWidth, Raster_y1+tt,RGB(80+(tt*7),0,0))
     LineXY(0, (Raster_y1+25)+tt, BoxWidth, (Raster_y1+25)+tt,RGB(255-(tt*7),0,0))
   Next tt
Return

Draw_Blue_Raster_Bar:
   For tt = 0 To 25
     LineXY(0, Raster_y2+tt, BoxWidth, Raster_y2+tt,RGB(0,0,80+(tt*7)))
     LineXY(0, (Raster_y2+25)+tt, BoxWidth, (Raster_y2+25)+tt,RGB(0,0,255-(tt*7)))
   Next tt
Return 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger