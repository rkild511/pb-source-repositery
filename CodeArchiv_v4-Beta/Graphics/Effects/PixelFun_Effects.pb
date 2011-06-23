; German forum: http://www.purebasic.fr/german/viewtopic.php?t=4757&highlight=
; Author: satzzeichen
; Date: 12. September 2005
; OS: Windows
; Demo: Yes

; For english users: Press keys 1, 2, 3, ... for the effects (several effects
; at the same time possible!), Esc for exit!

;-----INIT PART-----;
InitSprite()
InitKeyboard()
OpenScreen(640,480,16,"Graphic Games")
var_y.l = 0
var_x.f = 0
;-----SIMULATOR BEGINS-----;
Repeat
  ClearScreen(RGB(0,0,0))
  StartDrawing(ScreenOutput())
  FrontColor(RGB(255,0,0))

  DrawText(5, 0, "Die angezeigte Taste gedrückt halten um den Effekt zu sehen!(ESC zum beenden)")
  DrawText(5, 25, "1.Augenkrebs (langsam)")
  DrawText(5, 50, "2.Augenkrebs (klein)")
  DrawText(5, 75, "3.Augenkrebs (mittel) II")
  DrawText(5, 100, "4.Augenkrebs (groß) III")
  DrawText(5, 125, "5.Augenkrebs (sehr groß) IV")
  DrawText(5, 150, "6.Pfeil I")
  DrawText(5, 175, "7.Pfeil (getrennt) II")
  DrawText(5, 200, "8.Pentagramm I")
  DrawText(5, 225, "9.Pentagramm (leuchtend) II")
  DrawText(5, 250, "0.Pentagramm (besser) III")
  DrawText(5, 400, "Es können auch 2 Effekte übereinander gelegt werden...")

  LineXY(200,150,521,150)
  LineXY(200,351,521,351)
  LineXY(200,150,200,350)
  LineXY(521,150,521,350)

  ;Beispiel 1 und 2 sind identisch, allerdings soll Beispiel 2 verdeutlichen,
  ;wie man es nicht machen sollte :).

  ExamineKeyboard()

  If KeyboardPushed(#PB_Key_1)
    For y = 0 To 199
      For x = 0 To 319
        FrontColor(RGB(Random(255),Random(255),Random(255)))
        Plot(x+201,y+151)
      Next
    Next
  EndIf

  If KeyboardPushed(#PB_Key_2)
    For y = 0 To 199
      For x = 0 To 319
        Plot(x+201,y+151,RGB(Random(255),Random(255),Random(255)))
      Next
    Next
  EndIf

  If KeyboardPushed(#PB_Key_3)
    For y = 0 To 19
      For x = 0 To 31
        Box(x*10+201,y*10+151,10,10,RGB(Random(255),Random(255),Random(255)))
      Next
    Next
  EndIf

  If KeyboardPushed(#PB_Key_4)
    Box(201,151,160,100,RGB(Random(255),Random(255),Random(255)))
    Box(361,151,160,100,RGB(Random(255),Random(255),Random(255)))
    Box(201,251,160,100,RGB(Random(255),Random(255),Random(255)))
    Box(361,251,160,100,RGB(Random(255),Random(255),Random(255)))
  EndIf

  If KeyboardPushed(#PB_Key_5)
    Box(201,151,320,200,RGB(Random(255),Random(255),Random(255)))
  EndIf

  If KeyboardPushed(#PB_Key_6)
    For anzahl = 1 To 150
      var_y.l = 0
      For x = -20 To 20
        Plot(anzahl+x+291,var_y+201,RGB(Random(255),Random(255),Random(255)))
        var_y.l = var_y.l + 1
      Next

      var_y.l = 0
      For x = -20 To 20
        Plot(anzahl+x+291,var_y+281,RGB(Random(255),Random(255),Random(255)))
        var_y.l = var_y.l - 1
      Next
    Next
  EndIf

  If KeyboardPushed(#PB_Key_7)

    For anzahl = 1 To 15
      var_y.l = 0
      For x = -20 To 20
        Plot(anzahl*10+x+291,var_y+201,RGB(Random(255),Random(255),Random(255)))
        var_y.l = var_y.l + 1
      Next

      var_y.l = 0
      For x = -20 To 20
        Plot(anzahl*10+x+291,var_y+281,RGB(Random(255),Random(255),Random(255)))
        var_y.l = var_y.l - 1
      Next
    Next

  EndIf

  If KeyboardPushed(#PB_Key_8)
    FrontColor(RGB(255,255,255))
    LineXY(360,175,310,325)
    LineXY(360,175,410,325)
    LineXY(285,225,435,225)
    LineXY(285,225,410,325)
    LineXY(435,225,310,325)
  EndIf

  If KeyboardPushed(#PB_Key_9)
    LineXY(360,175,310,325,RGB(Random(255),Random(55),Random(55)))
    LineXY(360,175,410,325,RGB(Random(255),Random(55),Random(55)))
    LineXY(285,225,435,225,RGB(Random(255),Random(55),Random(55)))
    LineXY(285,225,410,325,RGB(Random(255),Random(55),Random(55)))
    LineXY(435,225,310,325,RGB(Random(255),Random(55),Random(55)))
  EndIf

  If KeyboardPushed(#PB_Key_0)
    For x = 1 To 150
      Plot(285+x,225,RGB(Random(255),Random(55),Random(55)))
    Next
    For x = 1 To 150
      Plot(360-(x*0.3391),175+x,RGB(Random(255),Random(55),Random(55)))
    Next
    For x = 1 To 150
      Plot(360+(x*0.3391),175+x,RGB(Random(255),Random(55),Random(55)))
    Next
    For x = 1 To 150
      Plot(285+(x*0.838),225+(x*0.675),RGB(Random(255),Random(55),Random(55)))
    Next
    For x = 1 To 150
      Plot(435-(x*0.838),225+(x*0.675),RGB(Random(255),Random(55),Random(55)))
    Next
  EndIf

  StopDrawing()
  FlipBuffers()
Until KeyboardPushed(#PB_Key_Escape)
;-----END-----;

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger