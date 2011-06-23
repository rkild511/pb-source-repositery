; German forum: http://www.purebasic.fr/german/viewtopic.php?t=305&highlight=
; Author: NicTheQuick (updated for PB 4.00 by Andre)
; Date: 02. October 2004
; OS: Windows
; Demo: No


; Hier nochmal meine etwas abgeänderten Blobs, die man im alten Forum 
; hier (http://www.robsite.de/php/pureboard-archiv/viewtopic.php?t=5485)
; findet. 

; In der Konstante #BlobTypes kann man definieren, ob es eine, zwei oder 
; drei Arten von Teilchen gibt. 

Procedure OnErrorMessage() 
  Protected Fehler.s 
  Fehler = "Fehler in Modul '" + GetErrorModuleName() + "' an Adresse " + RSet(Hex(GetErrorAddress()), 4, "0") + " in Zeile " + Str(GetErrorLineNR()) + ":" + Chr(13) + GetErrorDescription() 
  MessageRequester("Fehler Nr. " + Str(GetErrorNumber()), Fehler) 
  SetClipboardText("Fehler Nr. " + Str(GetErrorNumber()) + Chr(13) + Fehler) 
  End 
EndProcedure 
OnErrorGosub(@OnErrorMessage()) 

Reibung.f = 0.10          ; in Prozent / 100 
Wirkung.f = 30            ; Gibt an, ab welcher Entfernung die Anziehungs- bzw. Abstoßungskraft wirkt 
Gravity.f = 1.0           ; Gibt die Beschleunigung bei Abstand Null zweier Mittelpunkte an 
Abstossung.l = #True      ; Kollisionart: #True = Abstoßung, #False = Wegschiebung 

#MaxGravRad = 15          ; Wenn der Radius eines Blobs #MaxGravRad ist, ist die Anziehungskraft Gravity (alles proportional) 
#MaxRad = 15              ; Maximaler Radius für die Blobs 
#MinRad = 5               ; Minimaler Radius für die Blobs 
#MinColor = 127           ; Mindesthelligkeit der Blobs (0 - 255) 

Variant.l = #False        ; Anziehung: #False=pos/neg, #True=gleiche (Switch mit Leertaste) 
#ShowVariantTime = 1000   ; Anzeigezeit der Variationsanzeige (gleich / ungleich) 
FPSShow.l = #False        ; FPS anzeigen (Switch mit F) 
ShowHelp.l = #False       ; Status anzeigen 
#AddDelShowTime = 1000    ; Anzeigezeit bei + und - 
#AddDelTime = 200         ; Verzögerung nach erstem Tastendruck von + oder - 

RandDist.l = 50 
#RandSpd = 10 

Blobs.l = 200             ; Anzahl an Blobs zu Programmbeginn 
#BlobTypes = 3            ; Verschiedene Typen an Blobs (1 - 3) 

#Width = 640              ; Auflösung 
#Height = 480 

#Depth = 32               ; Farbtiefe 
#FPSAkt = 1000            ; FPS-Aktualisierung 

EllipseLines.l = 50       ; Anzahl der Ellipsen 
EllipseMove.f = 4 
EllipseVol.l = #False     ; Soll die Ellipse ausgefüllt sein, oder nicht 

; Sonstiges 
AddDelNow.l = 0 
AddDelShowNow.l = 0 
ShowVariantNow.l = 0 
NewBlobs.l = Blobs 
HalfDia.f = Sqr(#Width * #Width / 4 + #Height * #Height / 4) 
CaptureMouse.l = -1 
EllipseValue.l = 0 
MenuHeight.l = 0 
#TextWidth = 120 

Dim WinMouseButton(2) 
Dim WinKeyboardPushed(255) 
Dim WinKeyboardReleased(255) 

Structure Blobs 
  X.f 
  Y.f 
  xspd.f 
  yspd.f 
  r.f 
  c.l 
  c2.l 
  Typ.l ; 0 = negativ, 1 = postiv 
EndStructure 

;{- Procedures 

Procedure CreateBlobs(typ1.l, typ2.l, typ3.l) 
  Protected a.l 
  Shared Blobs 
  
  If typ1 >= 0 And typ2 >= 0 
    Blobs = typ1 + typ2 + typ3 
  EndIf 
  
  Global Dim Blobs.Blobs(Blobs - 1) 
  For a.l = 0 To Blobs - 1 
    Blobs(a)\r = Random(#MaxRad - #MinRad) + #MinRad 
    
    If typ1 = -1 And typ2 = -1 And typ3 = -1 
      Blobs(a)\Typ = a % #BlobTypes 
    Else 
      If typ1 
        Blobs(a)\Typ = 0 
        typ1 - 1 
      Else 
        If typ2 
          Blobs(a)\Typ = 1 
          typ2 - 1 
        Else 
          Blobs(a)\Typ = 2 
        EndIf 
      EndIf 
    EndIf 
    f.l = #MinColor + (255 - #MinColor) * Blobs(a)\r / #MaxRad 
    Select Blobs(a)\Typ 
      Case 0 
        Blobs(a)\c = RGB(0, 0, f) 
      Case 1 
        Blobs(a)\c = RGB(f, 0, 0) 
      Case 2 
        Blobs(a)\c = RGB(0, f, 0) 
    EndSelect 
    
    Blobs(a)\X = Random(#Width - Blobs(a)\r * 2) + Blobs(a)\r 
    Blobs(a)\Y = Random(#Height - Blobs(a)\r * 2) + Blobs(a)\r 
    Blobs(a)\xspd = 0 
    Blobs(a)\yspd = 0 
  Next 
EndProcedure 

Procedure.f Distance(X1.f, Y1.f, X2.f, Y2.f) ; Gibt den Abstand zweier Punkte zurück 
  Protected a.f, b.f 
  a = x2 - x1 
  b = y2 - y1 
  
  ProcedureReturn Sqr(a * a + b * b) 
EndProcedure 

Procedure.f GetAngle(X1.f, Y1.f, X2.f, Y2.f) ; Gibt den Winkel zwischen zwei Punkten im Bogenmaß zurück 
  Protected w.f 
  w = ATan((y2 - y1) / (x2 - x1)) 
  If x2 < x1 
    w = w + #PI 
  EndIf 
  If w < 0 : w + 2 * #PI : EndIf 
  If w > 2 * #PI : w - 2 * #PI : EndIf 
  
  ProcedureReturn w 
EndProcedure 

Procedure.f Pan(Pos1.f, Pos2.f, a1.l, a2.l) ; a1 = 0 -> Pos1, a1 = a2 -> Pos2 
  Protected Result.f 
  Result = Pos1 * (a2 - a1) / a2 + Pos2 * a1 / a2 
  ProcedureReturn Result 
EndProcedure 

Procedure.l Error(a.l, Text.s) 
  If a = 0 
    MessageRequester("Blobs", Text, #MB_ICONERROR) 
    End 
  EndIf 
  ProcedureReturn a 
EndProcedure 

;} 

If Error(OpenWindow(0, 0, 0, 120, 40, "Blobs", #PB_Window_ScreenCentered | #PB_Window_SystemMenu), "Konnte Fenster nicht öffnen") ;{ 
  If Error(CreateGadgetList(WindowID(0)), "Konnte keine Gadgetliste erstellen") 
    ButtonGadget(0, 0, 0, 120, 20, "Vollbild") 
    ButtonGadget(1, 0, 20, 120, 20, "Fenstermodus", #PB_Button_Default) 
    Repeat 
      Select WaitWindowEvent() 
        Case #PB_Event_CloseWindow : End 
        Case #PB_Event_Gadget 
          Select EventGadget() 
            Case 0 : Windowed = #False : Break 
            Case 1 : Windowed = #True  : Break 
          EndSelect 
        Case #WM_KEYDOWN 
          If EventwParam() = #VK_RETURN 
            Windowed = #True  : Break 
          EndIf 
      EndSelect 
    ForEver 
  EndIf 
  CloseWindow(0) 
EndIf;} 


;{- Init Sprite, Keyboard, Mouse 
Error(InitSprite(), "InitSprite() ist fehlgeschlagen.") 
If Windowed = #False 
  Error(InitKeyboard(), "InitKeyboard() ist fehlegschlagen.") 
  Error(InitMouse(), "InitMouse() ist fehlgeschlafen.") 
EndIf 
;} 



If Windowed ;{ Hauptfenster erstellen 
  If Error(OpenWindow(0, 0, 0, 1, 1, "Blobs", #PB_Window_SystemMenu), "Konnte Fenster nicht öffnen.") 
    HideWindow(0, 1) 
    If Error(CreateGadgetList(WindowID(0)), "Konnte Gadgetlist nicht erstellen.") 
      MenuWidth.l = 110 
      MenuHeight.l = 80 
      
      ; Menü oben 
      Y.l = 0 
      Gad_E1 = TrackBarGadget(#PB_Any, MenuWidth + 5, Y, #Width - #TextWidth, 20, 0, 1000) 
      Gad_T1 = TextGadget(#PB_Any, MenuWidth + 5 + #Width - #TextWidth, Y, #TextWidth, 20, "Wirkradius: " + StrF(Wirkung, 0), #PB_Text_Border) 
      SetGadgetState(Gad_E1, Wirkung) 
      Y + 20 
      
      Gad_E2 = TrackBarGadget(#PB_Any, MenuWidth + 5, Y, #Width - #TextWidth, 20, 0, 200) 
      Gad_T2 = TextGadget(#PB_Any, MenuWidth + 5 + #Width - #TextWidth, Y, #TextWidth, 20, "Anziehung: " + StrF(Gravity, 2), #PB_Text_Border) 
      SetGadgetState(Gad_E2, Gravity * 100) 
      Y + 20 
      
      Gad_E3 = TrackBarGadget(#PB_Any, MenuWidth + 5, Y, #Width - #TextWidth, 20, 0, 100) 
      Gad_T3 = TextGadget(#PB_Any, MenuWidth + 5 + #Width - #TextWidth, Y, #TextWidth, 20, "Reibung: " + Str(Reibung * 100) + "%", #PB_Text_Border) 
      SetGadgetState(Gad_E3, Reibung * 100) 
      Y + 20 
      
      Gad_E7 = TrackBarGadget(#PB_Any, MenuWidth + 5, Y, #Width - #TextWidth, 20, 1, #Height / 2) 
      Gad_T7 = TextGadget(#PB_Any, MenuWidth + 5 + #Width - #TextWidth, Y, #TextWidth, 20, "Randstärke: " + Str(RandDist) + " Px", #PB_Text_Border) 
      SetGadgetState(Gad_E7, RandDist) 
      
      ;Menü links 
      Y = MenuHeight 
      Frame3DGadget(#PB_Any, 0, Y, MenuWidth, 60, "Kollisionsart") 
      Gad_E4a = OptionGadget(#PB_Any, 5, MenuHeight + 15,  MenuWidth - 10, 20, "Abstoßung") 
      Gad_E4b = OptionGadget(#PB_Any, 5, MenuHeight + 35, MenuWidth - 10, 20, "Wegschiebung") 
      If Abstossung : SetGadgetState(Gad_E4a, #True) : Else : SetGadgetState(Gad_E4b, #True) : EndIf 
      Y + 65 
      
      Frame3DGadget(#PB_Any, 0, Y, MenuWidth, 60, "Ellipsen") 
      Gad_T5 = TextGadget(#PB_Any, 5, Y + 17, 40, 16, "Anzahl:") 
      Gad_E5 = SpinGadget(#PB_Any, 45, Y + 15, MenuWidth - 50, 20, 0, 200) 
      Gad_E6 = CheckBoxGadget(#PB_Any, 5, Y + 40, MenuWidth - 10, 16, "Ausgefüllt") 
      SetGadgetState(Gad_E5, EllipseLines) 
      SetGadgetText(Gad_E5, Str(EllipseLines)) 
      SetGadgetState(Gad_E6, EllipseVol) 
      Y + 61 
      
      If #BlobTypes >= 0 And #BlobTypes <= 3 
        Frame3DGadget(#PB_Any, 0, Y, MenuWidth, 45 + (#BlobTypes * 20), "Neue Blobs") 
      Else 
        Frame3DGadget(#PB_Any, 0, Y, MenuWidth, 105, "Neue Blobs") 
      EndIf 
      TextGadget(#PB_Any, 5, Y + 17, 30, 16, "Blau:") 
      Gad_E8a = StringGadget(#PB_Any, 35, Y + 15, MenuWidth - 40, 20, "0", #PB_String_Numeric) 
      Y + 20 
      If #BlobTypes >= 2 
        TextGadget(#PB_Any, 5, Y + 17, 30, 16, "Rot:") 
        Gad_E8b = StringGadget(#PB_Any, 35, Y + 15, MenuWidth - 40, 20, "0", #PB_String_Numeric) 
        Y + 20 
      EndIf 
      If #BlobTypes >= 3 
        TextGadget(#PB_Any, 5, Y + 17, 30, 16, "Grün:") 
        Gad_E8c = StringGadget(#PB_Any, 35, Y + 15, MenuWidth - 40, 20, "0", #PB_String_Numeric) 
        Y + 20 
      EndIf 
      Gad_E8d = ButtonGadget(#PB_Any, 5, Y + 20, MenuWidth - 10, 20, "Neu", #PB_Button_Default) 
      
    EndIf 
    winwidth = #Width + MenuWidth + 5
    winheight = #Height + MenuHeight + 5
    ResizeWindow(0, (GetSystemMetrics_(#SM_CXSCREEN) - winwidth) / 2, (GetSystemMetrics_(#SM_CYSCREEN) - winheight) / 2, winwidth, winheight)
    Error(OpenWindowedScreen(WindowID(0), MenuWidth + 5, MenuHeight + 5, #Width, #Height, 0, 0, 0), "Konnte Screen nicht erstellen") 
    HideWindow(0, 0) 
  EndIf 
Else 
  Error(OpenScreen(#Width, #Height, #Depth, "Blobs"), "Konnte Screen nicht erstellen") 
EndIf ;} 

CreateBlobs(-1, -1, -1) 

Repeat 
  ;{- Tastatureingabe 
  If Windowed = #False 
    ExamineKeyboard() 
    WinKeyboardPushed(#PB_Key_Escape) = KeyboardPushed(#PB_Key_Escape) 
    WinKeyboardReleased(#PB_Key_Space) = KeyboardReleased(#PB_Key_Space) 
    WinKeyboardReleased(#PB_Key_F) = KeyboardReleased(#PB_Key_F) 
    WinKeyboardReleased(#PB_Key_F5) = KeyboardReleased(#PB_Key_F5) 
    WinKeyboardPushed(#PB_Key_F1) = KeyboardPushed(#PB_Key_F1) 
    WinKeyboardPushed(#PB_Key_Add) = KeyboardPushed(#PB_Key_Add) 
    WinKeyboardPushed(#PB_Key_Subtract) = KeyboardPushed(#PB_Key_Subtract) 
  EndIf 
  
  If WinKeyboardPushed(#PB_Key_Escape) : Break : EndIf 
  If WinKeyboardReleased(#PB_Key_Space) 
    ShowVariantNow = ElapsedMilliseconds() + #ShowVariantTime 
    Variant ! 1 
  EndIf 
  If WinKeyboardReleased(#PB_Key_F) : FPSShow ! 1 : EndIf 
  If WinKeyboardReleased(#PB_Key_F5) : Blobs = NewBlobs : CreateBlobs(-1, -1, -1) : EndIf 
  If WinKeyboardPushed(#PB_Key_F1) : ShowHelp = #True : Else : ShowHelp = #False : EndIf 
  
  If WinKeyboardPushed(#PB_Key_Add) 
    If AddDelNow = 0 
      AddDelNow = ElapsedMilliseconds() + #AddDelTime 
      NewBlobs + 1 
    ElseIf ElapsedMilliseconds() > AddDelNow 
      NewBlobs + 1 
    EndIf 
    AddDelShowNow = ElapsedMilliseconds() + #AddDelShowTime 
    
  ElseIf WinKeyboardPushed(#PB_Key_Subtract) 
    If AddDelNow = 0 
      AddDelNow = ElapsedMilliseconds() + #AddDelTime 
      If NewBlobs > 0 : NewBlobs - 1 : EndIf 
    ElseIf ElapsedMilliseconds() > AddDelNow 
      If NewBlobs > 0 : NewBlobs - 1 : EndIf 
    EndIf 
    AddDelShowNow = ElapsedMilliseconds() + #AddDelShowTime 
    
  Else 
    AddDelNow = 0 
  EndIf 
  ;} 
  
  ;{- Maus 
  If Windowed 
    MouseX.l = WindowMouseX(0) - MenuWidth - 5 
    MouseY.l = WindowMouseY(0) - MenuHeight - 5 
  Else 
    ExamineMouse() 
    MouseX.l = MouseX() 
    MouseY.l = MouseY() 
    WinMouseButton(1) = MouseButton(1) 
    WinMouseButton(2) = MouseButton(2) 
  EndIf 
    
  If MouseX = -1 : MouseX = 0 : EndIf 
  If MouseY = -1 : MouseY = 0 : EndIf 
  
  If CaptureMouse >= 0 
    If CaptureMouse > Blobs : CaptureMouse = 0 : EndIf 
    MouseX = Blobs(CaptureMouse)\x 
    MouseY = Blobs(CaptureMouse)\y 
    If WinMouseButton(2) 
      MouseLocate(MouseX, MouseY) 
      CaptureMouse = -1 
    EndIf 
  Else 
    If WinMouseButton(1) 
      For a.l = 0 To Blobs - 1 
        If Distance(MouseX, MouseY, Blobs(a)\x, Blobs(a)\y) < Blobs(a)\r 
          CaptureMouse = a 
          Break 
        EndIf 
      Next 
    EndIf 
  EndIf 
  ;} 
  
  ;{ FPS zählen 
  If FPSTime < ElapsedMilliseconds() 
    FPS.f = FPSCount * 1000 / #FPSAkt 
    FPSTime.l = ElapsedMilliseconds() + #FPSAkt 
    FPSCount = 0 
  Else 
    FPSCount + 1 
  EndIf 
  ;} 
  
  
  ; Bildschirm löschen 
  ClearScreen(RGB(0, 0, 0))
  
  
  ;{- Zeichne Blobs und Hilfetexte 
  StartDrawing(ScreenOutput()) 
    
    EllipseValue + EllipseMove 
    If EllipseValue > 360 : EllipseValue - 360 : EndIf 
    
    If EllipseVol 
      DrawingMode(0) 
    Else 
      DrawingMode(4) 
    EndIf 
    FrontColor(RGB(255, 255, 255))
    If EllipseLines 
      For a = EllipseLines To 1 Step - 1 
        r.f = Pow(a / EllipseLines, 1 + (Sin(EllipseValue.l * #PI / 180) + 1)) 
        
        rx.f = #Width * 1.4142 * r / 2 
        ry.f = #Height * 1.4142 * r / 2 
        f.l = a * 255 / EllipseLines 
        Ellipse(Pan(MouseX, #Width / 2, a, EllipseLines), Pan(MouseY, #Height / 2, a, EllipseLines), rx, ry, RGB(255 - f, 0, f)) 
      Next 
    EndIf 
    
    DrawingMode(0) 
    For a = 0 To Blobs - 1 
      Circle(Blobs(a)\x, Blobs(a)\y, Blobs(a)\r, Blobs(a)\c | RGB(0, Blobs(a)\c2 / 2, 0)) 
    Next 
    
    If CaptureMouse = -1 
      Line(MouseX - 5, MouseY, 10, 0, $FFFFFF) 
      Line(MouseX, MouseY - 5, 0, 10, $FFFFFF) 
    EndIf 
    
    ; Hilfetexte 
    
    DrawingMode(1) 
    y.l = 5 
    If FPSShow 
      FrontColor(RGB(255, 255, 255))
      DrawText(5, y, "FPS: " + StrF(FPS)) : y + 16 
    EndIf 
    
    If ShowVariantNow Or ShowHelp 
      If ElapsedMilliseconds() > ShowVariantNow : ShowVariantNow = 0 : EndIf 
      FrontColor(RGB(255, 255, 255))
      Select Variant 
        Case 0 : DrawText(5, y, "Anziehung: ungleiche") 
        Case 1 : DrawText(5, y, "Anziehung: gleiche") 
      EndSelect 
      y + 16 
    EndIf 
    If ShowHelp 
      FrontColor(RGB(255, 255, 255))
      DrawText(5, y, "Kollisionen: " + Str(Collisions))  : y + 16 
      DrawText(5, y, "Blobs: " + Str(Blobs))  : y + 16 
      FrontColor(RGB(0, 255, 0))
      DrawText(5, y, "Esc   = Programm beenden")  : y + 16 
      DrawText(5, y, "Space = Anziehungskraft wechseln")  : y + 16 
      DrawText(5, y, "F     = FPS-Anzeige")  : y + 16 
      DrawText(5, y, "+/-   = Blobs-Anzahl ")  : y + 16 
      DrawText(5, y, "F5    = Blobs neu erstellen")  : y + 16 
      DrawText(5, y, "Linke Maustaste  = Blob auswählen -> Hintergrund fängt ihn")  : y + 16 
      DrawText(5, y, "Rechte Maustaste = Fang wieder ausschalten")  : y + 16 
    EndIf 
    
    If AddDelShowNow 
      FrontColor(RGB(255, 0, 0))
      If ElapsedMilliseconds() > AddDelShowNow : AddDelShowNow = 0 : EndIf 
      DrawText(5, y, "Neue Blobs: " + Str(NewBlobs)) : y + 16 
    EndIf 
  StopDrawing() 
  ;} 
  
  ;{- Berechne Blobs 
  For a = 0 To Blobs - 1 
    d.f = 0 
    If Blobs(a)\X < RandDist 
      d = RandDist - Blobs(a)\X 
    ElseIf Blobs(a)\X > #Width - RandDist 
      d = (#Width - RandDist) - Blobs(a)\X 
    Else 
      d = 0 
    EndIf 
    Blobs(a)\xspd + (#RandSpd * d / RandDist) 
    
    If Blobs(a)\Y < RandDist 
      d = RandDist - Blobs(a)\Y 
    ElseIf Blobs(a)\Y > #Height - RandDist 
      d = (#Height - RandDist) - Blobs(a)\Y 
    Else 
      d = 0 
    EndIf 
    Blobs(a)\yspd + (#RandSpd * d / RandDist) 
    
    Blobs(a)\c2 = Distance(Blobs(a)\X, Blobs(a)\Y, #Width / 2, #Height / 2) * 255 / HalfDia 
    
    For b.l = 0 To Blobs - 1 
      If a <> b 
        ; Abstände zwischen allen Blobs berechnen 
        Distance.f = Distance(Blobs(a)\X, Blobs(a)\Y, Blobs(b)\X, Blobs(b)\Y) 
        MinDistance.f = Blobs(a)\r + Blobs(b)\r 
        Difference.f = Distance - MinDistance 
        
        ; Wenn Wirkungsabstand erreicht... 
        If Distance <= Wirkung 
          ; Errechne Beschleunigung 
          Grav.f = (Wirkung - Distance) * Gravity / Wirkung 
          Grav = Grav * Pow(MinDistance / #MaxGravRad, 2) 
          
          ; If Difference < 0 
            ; Grav = - Grav 
            ; ; Blobs(a)\xspd * 0.4 
            ; ; Blobs(a)\yspd * 0.4 
          ; EndIf 
          
          ; Rechne Beschleunigung in x- und y-Beschleunigung um 
          Angle.f = GetAngle(Blobs(a)\X, Blobs(a)\Y, Blobs(b)\X, Blobs(b)\Y) 
          xspd.f = Cos(Angle) * Grav 
          yspd.f = Sin(Angle) * Grav 
          
          ; Unterscheide zwischen abstoßen... 
          If (Variant = #False And Blobs(a)\Typ = Blobs(b)\Typ) Or (Variant = #True And Blobs(a)\Typ <> Blobs(b)\Typ) 
            Blobs(a)\xspd - xspd 
            Blobs(a)\yspd - yspd 
          ; ...und anziehen 
          Else 
            Blobs(a)\xspd + xspd 
            Blobs(a)\yspd + yspd 
          EndIf 
          
        EndIf 
        
      EndIf 
    Next 
    
    ; Berechne Reibung 
    Blobs(a)\xspd - (Blobs(a)\xspd * Reibung) 
    Blobs(a)\yspd - (Blobs(a)\yspd * Reibung) 
    
    ; Bewege Blob entsprechend der Beschleunigung 
    Blobs(a)\X + Blobs(a)\xspd 
    Blobs(a)\Y + Blobs(a)\yspd 
    
    ; ; Lass Blobs an der Wand abprallen 
    ; If Blobs(a)\x <= Blobs(a)\r : Blobs(a)\x = 2 * Blobs(a)\r - Blobs(a)\x : Blobs(a)\xspd = - Blobs(a)\xspd : EndIf 
    ; If Blobs(a)\y <= Blobs(a)\r : Blobs(a)\y = 2 * Blobs(a)\r - Blobs(a)\y : Blobs(a)\yspd = - Blobs(a)\yspd : EndIf 
    ; If Blobs(a)\x >= #Width  - Blobs(a)\r : Blobs(a)\x = 2 * (#Width - Blobs(a)\r)  - Blobs(a)\x : Blobs(a)\xspd = - Blobs(a)\xspd : EndIf 
    ; If Blobs(a)\y >= #Height - Blobs(a)\r : Blobs(a)\y = 2 * (#Height - Blobs(a)\r) - Blobs(a)\y : Blobs(a)\yspd = - Blobs(a)\yspd : EndIf 
  Next 
  
  ;} 
  
  ;{- Berechen Kollisionen 
  Collisions = 0 
  For a.l = 0 To Blobs - 1 
    For b.l = 0 To Blobs - 1 
      If a <> b 
        Distance = Distance(Blobs(a)\x, Blobs(a)\y, Blobs(b)\x, Blobs(b)\y) 
        MinDistance = Blobs(a)\r + Blobs(b)\r 
        
        If Distance < MinDistance 
          Collisions + 1 
          Difference = (MinDistance - Distance) * Blobs(a)\r / (2 * (Blobs(a)\r + Blobs(b)\r)) 
          
          Angle.f = GetAngle(Blobs(a)\x, Blobs(a)\y, Blobs(b)\x, Blobs(b)\y) 
          If Abstossung ; Blobs(a)\typ <> Blobs(b)\typ 
            Difference = (MinDistance - Distance) * Blobs(a)\r / (2 * (Blobs(a)\r + Blobs(b)\r)) 
            Blobs(a)\xspd - Cos(Angle) * Difference 
            Blobs(a)\yspd - Sin(Angle) * Difference 
          Else 
            Difference = MinDistance - Distance 
            Blobs(a)\x - Cos(Angle) * Difference 
            Blobs(a)\y - Sin(Angle) * Difference 
            Blobs(a)\xspd = 0 
            Blobs(a)\yspd = 0 
          EndIf 
        EndIf 
      EndIf 
    Next 
  Next 
  ;} 
  
  FlipBuffers() 
  
  If IsScreenActive() = 0 ;{ 
    ReleaseMouse(1) 
    While IsScreenActive() = 0 
      If Windowed 
        Repeat 
          Select WindowEvent() 
            Case #PB_Event_CloseWindow : Break 3 
            Case 0 : Break 
          EndSelect 
        ForEver 
      EndIf 
      Delay(1) 
    Wend 
    ReleaseMouse(0) 
  EndIf 
  ;} 
  
  If Windowed ;{ 
    For a.l = 0 To 255 
      WinKeyboardPushed(a) = #False 
      WinKeyboardReleased(a) = #False 
    Next 
    WinMouseButton(1) = #False 
    WinMouseButton(2) = #False 
    Repeat 
      Select WindowEvent() 
        Case #PB_Event_CloseWindow : Break 2 
        
        Case #PB_Event_Gadget 
          Select EventGadget() 
            Case Gad_E1   ; Wirkradius 
              Wirkung = GetGadgetState(Gad_E1) 
              SetGadgetText(Gad_T1, "Wirkradius: " + StrF(Wirkung, 0)) 
            Case Gad_E2   ; Anziehung 
              Gravity = GetGadgetState(Gad_E2) / 100 
              SetGadgetText(Gad_T2, "Anziehung: " + StrF(Gravity, 2)) 
            Case Gad_E3   ; Reibung 
              Reibung = GetGadgetState(Gad_E3) / 100 
              SetGadgetText(Gad_T3, "Reibung: " + Str(Reibung * 100) + "%") 
            Case Gad_E4a  ; Abstossung 
              If GetGadgetState(Gad_E4a) : Abstossung = #True : Else : Abstossung = #False : EndIf 
            Case Gad_E4b  ; Wegschiebung 
              If GetGadgetState(Gad_E4a) : Abstossung = #True : Else : Abstossung = #False : EndIf 
            Case Gad_E5   ; Ellipsenanzahl 
              EllipseLines = GetGadgetState(Gad_E5) 
              SetGadgetText(Gad_E5, Str(EllipseLines)) 
            Case Gad_E6   ; Ellipse ausgefüllt 
              EllipseVol = GetGadgetState(Gad_E6) 
            Case Gad_E7 
              RandDist = GetGadgetState(Gad_E7) 
              SetGadgetText(Gad_T7, "Randstärke: " + Str(RandDist) + " Px") 
            Case Gad_E8d 
              CreateBlobs(Val(GetGadgetText(Gad_E8a)), Val(GetGadgetText(Gad_E8b)), Val(GetGadgetText(Gad_E8c))) 
          EndSelect 
        
        Case #WM_LBUTTONDOWN : WinMouseButton(1) = #True 
        Case #WM_RBUTTONDOWN : WinMouseButton(2) = #True 
        
        Case #WM_KEYDOWN 
          Select EventwParam() 
            Case #VK_RETURN 
              Select GetFocus_() 
                Case GadgetID(Gad_E8a) : SetActiveGadget(Gad_E8b) 
                Case GadgetID(Gad_E8b) : CreateBlobs(Val(GetGadgetText(Gad_E8a)), Val(GetGadgetText(Gad_E8b)), Val(GetGadgetText(Gad_E8c))) 
                Case GadgetID(Gad_E8c) : CreateBlobs(Val(GetGadgetText(Gad_E8a)), Val(GetGadgetText(Gad_E8b)), Val(GetGadgetText(Gad_E8c))) 
              EndSelect 
            
            Case #VK_ESCAPE   : WinKeyboardPushed(#PB_Key_Escape)   = #True 
            Case #VK_F1       : WinKeyboardPushed(#PB_Key_F1)       = #True 
            Case #VK_ADD      : WinKeyboardPushed(#PB_Key_Add)      = #True 
            Case #VK_SUBTRACT : WinKeyboardPushed(#PB_Key_Subtract) = #True 
            Case #VK_SPACE    : WinKeyboardReleased(#PB_Key_Space)    = #True 
          EndSelect 
        Case #WM_KEYUP 
          Select EventwParam() 
            Case #VK_F        : WinKeyboardReleased(#PB_Key_F)        = #True 
            Case #VK_F5       : WinKeyboardReleased(#PB_Key_F5)       = #True 
          EndSelect 
        Case 0 : Break 
      EndSelect 
    ForEver 
  EndIf ;} 
ForEver
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ----
; EnableXP
; DisableDebugger