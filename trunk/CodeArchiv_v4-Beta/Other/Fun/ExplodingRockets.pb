; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3391&highlight=
; Author: Lars (updated for PB 4.00 by Andre)
; Date: 09. February 2004
; OS: Windows
; Demo: No


; Ich habe ein (sehr) kleines Partikel System geschrieben, das mehr
; zufällig entstand, indem ich erst einen Ball, dann eine Unmenge von Bällen
; und dann eine Rakete mit Rückstoß simuliert habe. Jetzt haben wir einen
; ganz nett anzusehenden Effekt.

Details = 10 ; 1 Schlechteste, 10 beste Qualität, Theoretisch nach oben offen. . .

Procedure InitGameTimer()
   Shared _GT_DevCaps.TIMECAPS
   SetPriorityClass_(GetCurrentProcess_(),#HIGH_PRIORITY_CLASS)
   timeGetDevCaps_(_GT_DevCaps,SizeOf(TIMECAPS))
   timeBeginPeriod_(_GT_DevCaps\wPeriodMin)
EndProcedure
Procedure StopGameTimer()
   Shared _GT_DevCaps.TIMECAPS
   timeEndPeriod_(_GT_DevCaps\wPeriodMin)
EndProcedure

Structure Vector2D
   x.f
   y.f
EndStructure
Structure ball
   XPos.f
   YPos.f
   Geschw.Vector2D
   StartLife.l
   color.l
   StartColor.l
   LifeTime.l
EndStructure
Structure rocket
   XPos.f
   YPos.f
   Geschw.Vector2D
   Thrust.Vector2D
   State.l ;0 = normal; 1 = XPloded
   StartLife.l
   LifeTime.l
EndStructure

Enumeration  ;Window-Konstanten
   #Window_0
   #Window_1
EndEnumeration

Enumeration  ;Gadget-Konstanten
   #Text_0
   #Text_2
   #Text_3
   #String_0
   #String_1
   #Button_1
   #Button_2
   #TrackBar_0
EndEnumeration

If InitSprite() = 0
   MessageRequester("Fehler", "Konnte kein DirectX finden!", #MB_ICONERROR)
   End
EndIf
Gravity.Vector2D
Gravity\x = 0.0000000
Gravity\y = 9.81

Raketenbeschleunigung.f = 20


;{ Details Window Aufbau
If OpenWindow(#Window_0, 367, 237, 146, 316, "Details", #PB_Window_TitleBar | #PB_Window_ScreenCentered)
   If CreateGadgetList(WindowID(#Window_0))
     TrackBarGadget(#TrackBar_0, 5, 5, 30, 305, 1, 10, #PB_TrackBar_Ticks | #PB_TrackBar_Vertical)
     SetGadgetState(#TrackBar_0, 10 - Details)
     TextGadget(#Text_0, 45, 5, 90, 30, "Schlechteste, aber Schnellste Option")
     TextGadget(#Text_2, 40, 285, 95, 30, "Beste, aber Langsamste Option")
     ButtonGadget(#Button_1, 40, 100, 95, 20, "Ok")
     ButtonGadget(#Button_2, 40, 165, 95, 20, "Abbrechen")
     TextGadget(#Text_3, 40, 135, 100, 15, "Mittelere Optionen")

     AddKeyboardShortcut(#Window_0, #PB_Shortcut_Return, 1)
   Else
     MessageRequester("Fehler", "Konnte kein Fenster erstellen!", #MB_ICONERROR)
     End
   EndIf
Else
   MessageRequester("Fehler", "Konnte kein Fenster erstellen!", #MB_ICONERROR)
   End
EndIf
BringWindowToTop_(WindowID(#Window_0))
;}
;{ Details Window Events
Repeat
   Event = WaitWindowEvent()
   If Event = #PB_Event_Gadget
     GadgetID = EventGadget()
     If GadgetID = #TrackBar_0
       Details = 11 - GetGadgetState(#TrackBar_0)
     ElseIf GadgetID = #Button_1
       Break
     ElseIf GadgetID = #Button_2
       End
     EndIf
   ElseIf Event = #PB_Event_Menu
     If EventMenu() = 1
       Break
     EndIf
   EndIf
ForEver
;}

;{ Schwerkraft Window Aufbau
If OpenWindow(#Window_0, 358, 276, 240, 318, "Schwerkraft", #PB_Window_TitleBar | #PB_Window_ScreenCentered)
   If OpenWindowedScreen(WindowID(#Window_0), 5, 5, 230, 220, 0, 0, 0) = 0
     MessageRequester("Fehler", "Konnte keinen Windowed-Screen öffnen!", #MB_ICONERROR)
     End
   EndIf
   If CreateGadgetList(WindowID(#Window_0))
     TextGadget(#Text_0, 10, 235, 150, 20, "X-Wert der Schwerkraft (m/s ²)")
     TextGadget(#Text_2, 10, 260, 150, 20, "Y-Wert der Schwerkraft (m/s ²)")
     StringGadget(#String_0, 180, 235, 55, 20, StrF(Gravity\x), #PB_String_Numeric | #PB_Text_Right)
     StringGadget(#String_1, 180, 260, 55, 20, StrF(Gravity\y), #PB_String_Numeric | #PB_Text_Right)
     ButtonGadget(#Button_1, 5, 295, 110, 20, "Ok")
     ButtonGadget(#Button_2, 125, 295, 110, 20, "Abbrechen")

     AddKeyboardShortcut(#Window_0, #PB_Shortcut_Return, 1)
   Else
     MessageRequester("Fehler", "Konnte kein Fenster erstellen!", #MB_ICONERROR)
     End
   EndIf
Else
   MessageRequester("Fehler", "Konnte kein Fenster erstellen!", #MB_ICONERROR)
   End
EndIf
BringWindowToTop_(WindowID(#Window_0))
;}
;{ Schwerkraft Window Events
Repeat
   Event = WaitWindowEvent()
   ClearScreen(RGB(0, 0, 0))
   StartDrawing(ScreenOutput())
   Line(115, 110, Gravity\x * 5, Gravity\y * 5, $0000FF)
   StopDrawing()
   FlipBuffers()

   If Event = #PB_Event_Gadget
     GadgetID = EventGadget()
     If GadgetID = #String_0
       Gravity\x = ValF(GetGadgetText(#String_0))
     ElseIf GadgetID = #String_1
       Gravity\y = ValF(GetGadgetText(#String_1))
     ElseIf GadgetID = #Button_1
       Break
     ElseIf GadgetID = #Button_2
       End
     EndIf
   ElseIf Event = #PB_Event_Menu
     If EventMenu() = 1
       Break
     EndIf
   EndIf
ForEver
;}
CloseScreen()
CloseWindow(#Window_0)

;{ Raketen Window Aufbau
If OpenWindow(#Window_0, 358, 276, 240, 298, "Rakete", #PB_Window_TitleBar | #PB_Window_ScreenCentered)
   If OpenWindowedScreen(WindowID(#Window_0), 5, 5, 230, 220, 0, 0, 0) = 0
     MessageRequester("Fehler", "Konnte keinen Windowed-Screen öffnen!", #MB_ICONERROR)
     End
   EndIf
   If CreateGadgetList(WindowID(#Window_0))
     TextGadget(#Text_0, 10, 235, 120, 40, "Beschleunigung der Rakete (m/s ²)")
     StringGadget(#String_0, 160, 240, 55, 20, StrF(Raketenbeschleunigung), #PB_String_Numeric | #PB_Text_Right)
     ButtonGadget(#Button_1, 5, 275, 110, 20, "Ok")
     ButtonGadget(#Button_2, 125, 275, 110, 20, "Abbrechen")

     AddKeyboardShortcut(#Window_0, #PB_Shortcut_Return, 1)
   Else
     MessageRequester("Fehler", "Konnte kein Fenster erstellen!", #MB_ICONERROR)
     End
   EndIf
Else
   MessageRequester("Fehler", "Konnte kein Fenster erstellen!", #MB_ICONERROR)
   End
EndIf
BringWindowToTop_(WindowID(#Window_0))
;}
;{ Raketen Window Events
Repeat
   Event = WaitWindowEvent()
   ClearScreen(RGB(0, 0, 0))
   StartDrawing(ScreenOutput())
   Line(115, 110, 0, -Raketenbeschleunigung * 4, $0000FF)
   StopDrawing()
   FlipBuffers()

   If Event = #PB_Event_Gadget
     GadgetID = EventGadget()
     If GadgetID = #String_0
       Raketenbeschleunigung = Abs(ValF(GetGadgetText(#String_0)))
     ElseIf GadgetID = #Button_1
       Break
     ElseIf GadgetID = #Button_2
       End
     EndIf
   ElseIf Event = #PB_Event_Menu
     If EventMenu() = 1
       Break
     EndIf
   EndIf
ForEver
;}
CloseScreen()
CloseWindow(#Window_0)

;{ MainWindow Aufbau
If OpenWindow(#Window_1, 136, 218, 990, 700, "Rakete", #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered)
   If OpenWindowedScreen(WindowID(#Window_1), 0, 0, 990, 700, 1, 1, 1) = 0
     MessageRequester("Fehler", "Konnte keinen Windowed-Screen öffnen!", #MB_ICONERROR)
     End
   EndIf
Else
   MessageRequester("Fehler", "Konnte kein Fenster erstellen!", #MB_ICONERROR)
   End
EndIf
BringWindowToTop_(WindowID(#Window_1))
;}

Gravity\x / 100 / 1000
Gravity\y / 100 / 1000

NewList Balls.ball()

NewList Rocket.rocket()
For i = 1 To 3
   AddElement(Rocket())
   Rocket()\XPos = Random(638) + 31
   Rocket()\YPos = 669
   Rocket()\Thrust\x =  Raketenbeschleunigung * Cos((Random(90) + 45) * 0.01745329) / 100 / 1000
   Rocket()\Thrust\y = -Raketenbeschleunigung * Sin((Random(90) + 45) * 0.01745329) / 100 / 1000

   Rocket()\StartLife = timeGetTime_()
   Rocket()\LifeTime = 3000
Next i

InitGameTimer()
OldMainLoop = timeGetTime_()
Repeat
   TimeMainLoop = timeGetTime_() - OldMainLoop
   OldMainLoop = timeGetTime_()
   If TimeMainLoop <= 0: TimeMainLoop = 1: EndIf

   Event = WindowEvent()

   ClearScreen(RGB(0, 0, 0))
   StartDrawing(ScreenOutput())
   ForEach Balls()
     radius.l = 6 - (Details / 2)
     If radius < 1: radius = 1: EndIf
     Circle(Balls()\XPos, Balls()\YPos, radius, Balls()\color)
     Balls()\XPos + (Balls()\Geschw\x * TimeMainLoop)
     Balls()\YPos + (Balls()\Geschw\y * TimeMainLoop)
     If Balls()\YPos >= 700 Or Balls()\YPos <= 0
       Balls()\Geschw\y * -1
     EndIf
     If Balls()\XPos >= 990 Or Balls()\XPos <= 0
       Balls()\Geschw\x * -1
     EndIf
     TimeLeft.l = Balls()\LifeTime - (timeGetTime_() - Balls()\StartLife)
     red.l = Red(Balls()\color) * TimeLeft / Balls()\LifeTime
     green.l = Green(Balls()\color) * TimeLeft / Balls()\LifeTime
     blue.l = Blue(Balls()\color) * TimeLeft / Balls()\LifeTime
     Balls()\color = RGB(red, green, blue)
     If Balls()\color < 0: Balls()\color = 0: EndIf

     Balls()\Geschw\x + (Gravity\x * TimeMainLoop)
     Balls()\Geschw\y + (Gravity\y * TimeMainLoop)
     If timeGetTime_() - Balls()\StartLife > Balls()\LifeTime
       DeleteElement(Balls())
     EndIf
   Next
   ForEach Rocket()
     If Rocket()\State = 0
       Line(Rocket()\XPos, Rocket()\YPos, 50000 * (Rocket()\Thrust\x + Gravity\x), 50000 * (Rocket()\Thrust\y + Gravity\y), $00FF00)
       For i = 1 To Details * 3
         AddElement(Balls())
         Balls()\XPos = Rocket()\XPos
         Balls()\YPos = Rocket()\YPos
         Balls()\Geschw\x = (Random(10000) - Random(10000)) / 100 / 1000
         Balls()\Geschw\y = (Random(10000) - Random(10000)) / 100 / 1000
         Balls()\StartLife = timeGetTime_()
         temp.l = Random(100) + 155
         Balls()\color = Random(155) + 100 ;RGB(temp, temp, 0)
         Balls()\StartColor = Balls()\color
         Balls()\LifeTime = Details * 60
       Next i
       If timeGetTime_() - Rocket()\StartLife > Rocket()\LifeTime
         Rocket()\State = 1
       EndIf

       Rocket()\Geschw\x + (Gravity\x * TimeMainLoop) + (Rocket()\Thrust\x * TimeMainLoop)
       Rocket()\Geschw\y + (Gravity\y * TimeMainLoop) + (Rocket()\Thrust\y * TimeMainLoop)
     Else
       For i = 1 To Details * 50
         AddElement(Balls())
         Balls()\XPos = Rocket()\XPos
         Balls()\YPos = Rocket()\YPos
         Balls()\Geschw\x = (Random(13000) - Random(13000)) / 100 / 1000
         Balls()\Geschw\y = (Random(13000) - Random(13000)) / 100 / 1000
         Balls()\StartLife = TimeGetTime_()
         Balls()\color = 300 + Random($00FF00)
         Balls()\StartColor = Balls()\color
         Balls()\LifeTime = Details * Random(400) + 200
       Next i
       DeleteElement(Rocket())

       For i = 1 To 1
         AddElement(Rocket())
         Rocket()\XPos = Random(638) + 31
         Rocket()\YPos = 669
         Rocket()\Thrust\x =  Raketenbeschleunigung * Cos((Random(120) + 30) * 0.01745329) / 100 / 1000
         Rocket()\Thrust\y = -Raketenbeschleunigung * Sin((Random(120) + 30) * 0.01745329) / 100 / 1000

         Rocket()\StartLife = TimeGetTime_()
         Rocket()\LifeTime = 3000
       Next i
     EndIf
     Rocket()\XPos + (Rocket()\Geschw\x * TimeMainLoop)
     Rocket()\YPos + (Rocket()\Geschw\y * TimeMainLoop)

     If Rocket()\XPos < 30 Or Rocket()\XPos > 870 Or Rocket()\YPos < 30 Or Rocket()\YPos > 670
       Rocket()\State = 1
     EndIf
   Next
   StopDrawing()
   FlipBuffers()
   Delay(20)
Until Event = #PB_Event_CloseWindow
StopGameTimer()
End
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; EnableXP
; DisableDebugger
