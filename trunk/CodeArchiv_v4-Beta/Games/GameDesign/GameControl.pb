; German forum: http://www.purebasic.fr/german/viewtopic.php?t=3133&start=60
; Author: ZeHa (updated for PB 4.00 by Andre)
; Date: 05. May 2005
; OS: Windows, Linux
; Demo: Yes

; ... Deine Figur wird um die Ecken einen "Bogen" machen (so wie bei Pacman), 
; damit Du nicht direkt vor dem Loch stehen mußt, um reinzugehen. 
; Dies wird mit den Variablen schlecht1 und schlecht2 gemacht. Also wenn Du 
; nun genau auf zwei Blöcke zuläufst, und der linke ist belegt, dann ist der 
; "schlecht". Wenn der rechte frei ist, wird die Richtung umgelenkt auf 
; "rechts", und da Du ja auf der Taste draufbleibst, geht die Figur 
; automatisch in die gewünschte Richtung, sobald sie am Hindernis vorbei ist... 

Global Dim MapDaten(10, 10) 
#hoch = 1 
#runter = 2 
#links = 3 
#rechts = 4 

Global PlayerX.l, PlayerY.l, PX.f, PY.f 


PlayerX = 96 
PlayerY = 48 


InitSprite() 
InitKeyboard() 


Procedure Leveleinlesen() 
  For ArrayY = 1 To 10 
    For ArrayX = 1 To 10 
      Read MapDaten(ArrayY, ArrayX) 
    Next 
  Next 
EndProcedure 

    
Procedure Levelausgeben() 
  ClearScreen(RGB(0, 0, 0))
  StartDrawing(ScreenOutput()) 
  For ArrayY = 1 To 10 
    For ArrayX = 1 To 10 
      If MapDaten(ArrayY, ArrayX) = 1 
        Box(ArrayX * 16, ArrayY * 16, 16, 16, RGB(64, 0, 0)) 
        DrawingMode(4) 
        Box(ArrayX * 16, ArrayY * 16, 16, 16, RGB(112, 0, 0)) 
        DrawingMode(0) 
      Else 
        Box(ArrayX * 16, ArrayY * 16, 16, 16, RGB(128, 128, 128)) 
        DrawingMode(4) 
        Box(ArrayX * 16, ArrayY * 16, 16, 16, RGB(160, 160, 160)) 
        DrawingMode(0) 
      EndIf 
    Next 
  Next 
  ; Spielfigur ausgeben 
  Box(PlayerX+1, PlayerY+1, 14, 14, RGB(64, 255, 64)) 
  StopDrawing() 
EndProcedure 


Leveleinlesen() 


If OpenWindow(0, 0, 0, 192, 192, "jetzt funktionierts :)", 0) 
  If OpenWindowedScreen(WindowID(0), 0, 0, 192, 192, 0, 0, 0) 
  EndIf 
EndIf 


Levelausgeben() 


Procedure ExamineControls() 
  ExamineKeyboard() 
  
  If KeyboardPushed(#PB_Key_Up) 
   Richtung=#hoch 
  EndIf 
  If KeyboardPushed(#PB_Key_Down) 
    Richtung=#runter 
  EndIf 
  If KeyboardPushed(#PB_Key_Left) 
    Richtung=#links 
  EndIf 
  If KeyboardPushed(#PB_Key_Right) 
    Richtung=#rechts 
  EndIf 
  
  ProcedureReturn Richtung 
EndProcedure 


Repeat 
  Delay(1) 
  FlipBuffers() 
  
  Richtung = ExamineControls() 
  
  PY = PlayerY / 16 
  schlecht1=0 
  schlecht2=0 
  
  nx1 = Int(PlayerX / 16) 
  nx2 = Int((PlayerX + 15) / 16) 
  ny1 = Int(PlayerY / 16) 
  ny2 = Int((PlayerY + 15) / 16) 
  
  Select Richtung 
    Case #hoch 
      If MapDaten(ny2 - 1, nx1)<>1 
        schlecht1=1 
      EndIf 
      If MapDaten(ny2 - 1, nx2)<>1 
        schlecht2=1 
      EndIf 
      
      If schlecht1=1 And schlecht2=0 
        Richtung=#rechts 
      EndIf 
      If schlecht1=0 And schlecht2=1 
        Richtung=#links 
      EndIf 
      If schlecht1=1 And schlecht2=1 
        Richtung=0 
      EndIf 
  
  
    Case #runter 
      If MapDaten(ny1 + 1, nx1)<>1 
        schlecht1=1 
      EndIf 
      If MapDaten(ny1 + 1, nx2)<>1 
        schlecht2=1 
      EndIf 
      
      If schlecht1=1 And schlecht2=0 
        Richtung=#rechts 
      EndIf 
      If schlecht1=0 And schlecht2=1 
        Richtung=#links 
      EndIf 
      If schlecht1=1 And schlecht2=1 
        Richtung=0 
      EndIf 

  
    Case #links 
      If MapDaten(ny1, nx2 - 1)<>1 
        schlecht1=1 
      EndIf 
      If MapDaten(ny2, nx2 - 1)<>1 
        schlecht2=1 
      EndIf 
      
      If schlecht1=1 And schlecht2=0 
        Richtung=#runter 
      EndIf 
      If schlecht1=0 And schlecht2=1 
        Richtung=#hoch 
      EndIf 
      If schlecht1=1 And schlecht2=1 
        Richtung=0 
      EndIf 
  
  
    Case #rechts 
      If MapDaten(ny1, nx1 + 1)<>1 
        schlecht1=1 
      EndIf 
      If MapDaten(ny2, nx1 + 1)<>1 
        schlecht2=1 
      EndIf 
      
      If schlecht1=1 And schlecht2=0 
        Richtung=#runter 
      EndIf 
      If schlecht1=0 And schlecht2=1 
        Richtung=#hoch 
      EndIf 
      If schlecht1=1 And schlecht2=1 
        Richtung=0 
      EndIf 
      
  EndSelect 
  
  
  Select Richtung 
    Case #hoch: PlayerY - 1 
    Case #runter: PlayerY + 1 
    Case #links: PlayerX - 1 
    Case #rechts: PlayerX + 1 
  EndSelect 
    
  
  Levelausgeben() 
  
  
  ; FPS ------------------------------------- 
  If fpsstart = 0 
    fpsstart = ElapsedMilliseconds() 
  EndIf 
  fpszaehler + 1 
  If ElapsedMilliseconds() - fpsstart >= 1000 
    fps = fpszaehler 
    fpszaehler = 0 
    fpsstart = ElapsedMilliseconds() 
  EndIf 
  StartDrawing(ScreenOutput()) 
  FrontColor(RGB(255, 255, 255))
  DrawingMode(3) 
  DrawText(0, 0, "    FPS:" + Str(fps) + "  Y:" + Str(PlayerY / 16) + "," + Mid(StrF(PY), 1, 4) + "  x:" + Str(PlayerX / 16)) 
  StopDrawing() 
  ; ----------------------------------------- 
  
  
  
  
Until KeyboardPushed(#PB_Key_Escape) 
End 






DataSection 
Data.l 0,0,0,0,0,0,0,0,0,0 
Data.l 0,1,1,0,1,1,1,1,1,0 
Data.l 0,0,1,0,1,1,1,0,1,0 
Data.l 0,0,1,1,1,1,1,0,1,0 
Data.l 0,0,0,0,1,0,0,0,1,0 
Data.l 0,0,0,0,1,1,1,1,1,0 
Data.l 0,1,1,0,0,0,1,1,1,0 
Data.l 0,1,1,1,1,1,1,1,1,0 
Data.l 0,1,1,0,0,0,1,1,1,0 
Data.l 0,0,0,0,0,0,0,0,0,0 
EndDataSection 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -