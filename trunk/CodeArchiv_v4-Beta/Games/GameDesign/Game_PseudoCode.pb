; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=971&highlight=
; Author: Danilo (updated for PB4.00 by Andre)
; Date: 11. May 2003
; OS: Windows
; Demo: Yes


; Pseudo-Code for a game (will not run directly!!)
; Pseudo-Code für ein Spiel (läuft nicht unmittelbar!!)

Global CurrentActiveScreen 
#SCREEN_MENU = 0 
#SCREEN_GAME = 1 
#SCREEN_HOF  = 2 
#SCREEN_END  = 3 


Procedure DoMenu() 
  ZeichneLOGO() 
  DrawSprite(Button1) ; Start Game 
  DrawSprite(Button2) ; End   Game 
  DrawSprite(Button3) ; HighScore 

  If MouseButton(1) 
    x = MouseX() : y = MouseY() 
    If     (x => Button1_X And x <= Button1_X+Button1_Width) And (y => Button1_Y And y <= Button1_Y+Button1_Height) 
      CurrentActiveScreen = #SCREEN_GAME 
    ElseIf (x => Button2_X And x <= Button2_X+Button2_Width) And (y => Button2_Y And y <= Button2_Y+Button2_Height) 
      CurrentActiveScreen = #SCREEN_END 
    ElseIf (x => Button3_X And x <= Button3_X+Button3_Width) And (y => Button3_Y And y <= Button3_Y+Button3_Height) 
      CurrentActiveScreen = #SCREEN_HOF 
    EndIf
  EndIf 
EndProcedure 


Procedure DoGame() 
  ZeichneGameScreen() 
  ZeichnePlayer() 
  CollisionCheck() 
  If Leben = 0 
    CurrentActiveScreen = #SCREEN_MENU ; Wenn Leben 0, dann zurück zum Hauptmenu (Spiel beendet) 
  EndIf 
EndProcedure 


Procedure DoHOF() 
  ; Hall of Fame - logo zeichnen 
  ; Tabelle mit High-Scores anzeigen 
  If KeyboardPushed(#PB_Key_Escape) 
    CurrentActiveScreen = #SCREEN_MENU ; bei Escape zurück zum Menu... 
  EndIf 
EndProcedure 


Procedure DoEnd() 
  ; Abspann zeigen 
  ; und dann beenden 
  End 
EndProcedure 


; 
; START GAME 
; 

If InitSprite() = 0 Or InitKeyboard() = 0 Or InitMouse() = 0 
  Error, End 
EndIf 

If OpenScreen(x,y,d,title)=0 
  Error, End 
EndIf 

LoadSpritesFromDiskToMemory() 
LoadSprites() ; erzeugt aus den gepackten Bildern im Hauptspeicher 
              ; Sprites im VideoSpeicher -> CatchSprite.. 

Repeat 
  FlipBuffers() 
  ExamineKeyboard() 
  ExamineMouse() 
  ; Screen ganz normal aktiv 
  If IsScreenActive() And ScreenSwitched = 0 
    Select CurrentActiveScreen 
      Case #SCREEN_MENU: DoMenu() ; Menu-Schleife 
      Case #SCREEN_GAME: DoGame() ; Game-Schleife 
      Case #SCREEN_HOF : DoHOF()  ; Hall of Fame 
      Case #SCREEN_END : DoEnd()  ; Ending-Screen, Abspann und Game-Ende 
    EndSelect 
  ; Screen wieder aktiv, nach ALT+TAB -> Sprites neu laden 
  ElseIf IsScreenActive() And ScreenSwitched = 1 
    LoadSprites() ; erneutes laden der Sprites ausm Speicher 
    ScreenSwitched = 0 
  ; Screen nicht aktiv -> ALT+TAB 
  Else 
    Delay(10) 
    ScreenSwitched = 1 
  EndIf 
ForEver

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
