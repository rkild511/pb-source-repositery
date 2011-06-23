; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3223&start=40&postdays=0&postorder=asc&highlight=
; Author: NicTheQuick (updated for PB4.00 by blbltheworm)
; Date: 28. December 2003
; OS: Windows
; Demo: No


; Mit den Pfeiltasten kann man das Rechteck bewegen. Oben links in der Ecke sieht
; man die eingestellte FPS-Rate der Keyboardroutine. 

; Mit + und - auf dem Numblock kann man die Refreshrate des Keyboardthreads ändern.
; Man merkt auch dann beim Bewegen, dass es schneller bzw. langsamer wird. 

; Ich habe den Code so gehalten, dass er leicht überall einsetzbar ist. Man kann
; eine Procedure festlegen, die alle Tastatureingaben verwalten soll und sie auch
; zur Laufzeit wechseln. Dazu kann man noch Fehlerwerte abfragen, die Tastaturroutine
; pausieren und ganz abbrechen. 

; Sicherlich wäre es noch angebracht die automatische FPS-Begrenzung des
; Keyboardthreads genauer zu gestalten. Ich mache es hier mit TimeGetTime_() und
; weil ich vorher noch nie so etwas genaues gebraucht habe, habe ich jetzt auch
; keine Lust gehabt etwas derartiges einzubauen...  


;{- Alle Control-Thread-Procedures 
Global Control_Flag.l, Control_Handle.l, Control_Hz.l, Control_Callback.l 
Enumeration 1 
  #Control_Normal 
  #Control_Quit 
  #Control_Pause 
  #Control_ChangeHz 
  
  #Control_PtrIsNull 
  #Control_CBIsFalse 
  #Control_FlagError 
EndEnumeration 

;Control-Thread 
Procedure Control(Callback.l) 
  Protected time_Delay.l, time_End.l 
  Control_Hz = 100 
  Control_Callback = Callback 
  
  time_Delay = 1000 / Control_Hz 
  time_End = timeGetTime_() + time_Delay 
  Repeat 
    Select Control_Flag 
      
      Case #Control_Quit      ;Procedure beenden 
        ProcedureReturn #True 
      
      Case #Control_ChangeHz  ;Refreshrate ändern 
        time_Delay = 1000 / Control_Hz 
        Control_Flag = #Control_Normal 
      
      Case #Control_Pause     ;Alle Eingaben ignorieren 
        While Control_Flag = #Control_Pause 
          ExamineKeyboard() 
          ExamineMouse() 
          Delay(1) 
        Wend 
      
      Case #Control_Normal    ;Eingabe verarbeiten 
        ExamineKeyboard() 
        ExamineMouse() 
        If Control_Callback 
          If CallFunctionFast(Control_Callback) = 0 
            Control_Flag = #Control_CBIsFalse 
            ProcedureReturn #False 
          EndIf 
        Else 
          Control_Flag = #Control_PtrIsNull 
          ProcedureReturn #False 
        EndIf 
        
      Default                 ;Fehler 
        Control_Flag = #Control_FlagError 
        ProcedureReturn #False 
    EndSelect 
    
    ;Pause 
    While timeGetTime_() < time_End : Delay(1) : Wend 
    time_End = timeGetTime_() + time_Delay 
    
  ForEver 
EndProcedure 

Procedure Control_Start(*Callback) 
  Control_Flag = #Control_Normal 
  Control_Handle.l = CreateThread(@Control(), *Callback) 
  ThreadPriority(Control_Handle, 17)    ;Priorität um eins höher als das Hauptprogramm 
  ProcedureReturn Control_Handle 
EndProcedure 

Procedure Control_Pause()             ;Alle Eingabe werden ignoiert 
  Control_Flag = #Control_Pause 
EndProcedure 
Procedure Control_Resume()            ;Rücksetzen der Pause 
  Control_Flag = #Control_Normal 
EndProcedure 
Procedure Control_Quit()              ;Control-Thread beenden 
  Control_Flag = #Control_Quit 
EndProcedure 
Procedure Control_GetHz()             ;Aktualisierungsrate des Threads ändern 
  ProcedureReturn Control_Hz 
EndProcedure 
Procedure Control_SetHz(Hertz.l) 
  Control_Hz = Hertz.l 
  Control_Flag = #Control_ChangeHz 
EndProcedure 
Procedure Control_ChangeCB(*Callback) ;Control-Callback ändern 
  Control_Callback = *Callback 
EndProcedure 

; Mögliche Rückgabewerte: 
; - #Control_Normal     : Thread läuft normal 
; - #Control_Quit       : Thread wurde normal beendet 
; - #Control_Pause      : Thread ist pausiert 
;    
; - #Control_PtrIsNull  : Fehler! Aufzurufender Callback-Pointer ist Null -> Beendet 
; - #Control_CBIsFalse  : Fehler! Rückgabewert der Callback-Procedure ist Null -> Beendet 
; - #Control_FlagError  : Fehler! Falsches Flag gesendet -> Beendet 
Procedure Control_GetStatus() 
  ProcedureReturn Control_Flag 
EndProcedure 
;} 

;{- Init 
If InitSprite() = 0 
  MessageRequester("Error", "InitSprite()-Fehler.") 
  End 
EndIf 

If InitKeyboard() = 0 
  MessageRequester("Error", "InitKeyboard()-Fehler.") 
  End 
EndIf 

If InitMouse() = 0 
  MessageRequester("Error", "InitMouse()-Fehler.") 
  End 
EndIf 
;} 

;- Game 

Global Game_Quit.l 
Global PlayerX.l, PlayerY.l 
Global ScreenWidth.l, ScreenHeight.l 

;Aufzurufender Callback mit Eingabenverarbeitung 
Procedure Controls() 
  Protected ControlHz.l 
  
  If KeyboardReleased(#PB_Key_Escape) 
    Game_Quit = #True 
  EndIf 
  If KeyboardPushed(#PB_Key_Left) And PlayerX > 0 
    PlayerX - 1 
  EndIf 
  If KeyboardPushed(#PB_Key_Right) And PlayerX < ScreenWidth 
    PlayerX + 1 
  EndIf 
  If KeyboardPushed(#PB_Key_Up) And PlayerY > 0 
    PlayerY - 1 
  EndIf 
  If KeyboardPushed(#PB_Key_Down) And PlayerY < ScreenHeight 
    PlayerY + 1 
  EndIf 
  
  ControlHz = Control_GetHz() 
  If KeyboardReleased(#PB_Key_Add) 
    Control_SetHz(ControlHz + 10) 
  EndIf 
  If KeyboardReleased(#PB_Key_Subtract) And ControlHz > 10 
    Control_SetHz(ControlHz - 10) 
  EndIf 

  ProcedureReturn #True 
EndProcedure 

ScreenHeight = 768 
ScreenWidth = 1024 

If OpenScreen(ScreenWidth, ScreenHeight, 32, "Control-Thread Test") 
  Control_Start(@Controls()) 
  PlayerX = ScreenWidth / 2 
  PlayerY = ScreenHeight / 2 
  
  ;Mainloop 
  Repeat 
    ClearScreen(RGB(0,0,0)) 
    StartDrawing(ScreenOutput()) 
      FrontColor(RGB(255,255,255)) 
      Box(PlayerX - 10, PlayerY - 10, 20, 20) 
      DrawingMode(1) 
      DrawText(0, 0,Str(Control_GetHz())) 
    StopDrawing() 
    FlipBuffers() 
  Until Game_Quit 
  
  Control_Quit() 
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ---
; DisableDebugger
