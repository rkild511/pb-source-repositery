; German forum: http://www.purebasic.fr/german/viewtopic.php?t=9574&highlight=
; Author: Criss
; Date: 25. August 2006
; OS: Windows
; Demo: Yes

; With this include you can easily program a Jump & Run game!
; The example shows how you can do this!

; Mit dieser Include ist es möglich schnell und einfach ein Jump & Run -Spiel 
; zu programmieren! Das Beispiel zeigt wie das ganze funktioniert! 


; ------------------------ 
; Jump & Run - Engine v1.1 
; ------------------------ 
; 
; Jumpingeyes (August 2006) 


; Globale Variablen 
Global Dim jnr_map.l(0, 0) 


; Struktur jnr 
Structure jnr 
  engine.s 
  copyright.s 
  x.l 
  y.l 
  cx1.l 
  cx2.l 
  cx3.l 
  cx4.l 
  cy1.l 
  cy2.l 
  cy3.l 
  cy4.l 
  mwidth.l 
  mheight.l 
  pwidth.l 
  pheight.l 
  twidth.l 
  theight.l 
  speed_x.l 
  speed_y.l 
  gravity.l 
  jump.l 
  jumpdelay.l 
  jumptimer.l 
  moving.l 
  offsety.l 
  offsetx.l 
EndStructure 
Global jnr.jnr 
jnr\engine    = "Jump & Run - Engine v1.1" 
jnr\copyright = "Jumpingeyes (August 2006)" 


; Deklarierungen 
Declare jnr_cloud() 


; Prozeduren 
Procedure jnr_getcorners(x.l, y.l) 
  ; Obenlinks 
  jnr\cx1 = (x - jnr\offsetx) / jnr\twidth 
  jnr\cy1 = (y - jnr\offsety) / jnr\theight 
  
  ; Obenrechts 
  jnr\cx2 = ((x - jnr\offsetx) + jnr\pwidth - 1) / jnr\twidth 
  jnr\cy2 = (y - jnr\offsety) / jnr\theight 
  
  ; Untenlinks 
  jnr\cx3 = (x - jnr\offsetx) / jnr\twidth 
  jnr\cy3 = ((y - jnr\offsety) + jnr\pheight - 1) / jnr\theight 
  
  ; Untenrechts 
  jnr\cx4 = ((x - jnr\offsetx) + jnr\pwidth - 1) / jnr\twidth 
  jnr\cy4 = ((y - jnr\offsety) + jnr\pheight - 1) / jnr\theight 
EndProcedure 


Procedure jnr_movechar(dirx.l, diry.l, jmpfal.l) 
  If jnr\moving = #False 
    ProcedureReturn #False 
  EndIf 
  If jmpfal = 1 
    act_speed = jnr\speed_y 
  Else 
    act_speed = jnr\speed_x 
  EndIf 
  
  
  jnr_getcorners(jnr\x, jnr\y + act_speed * diry) 
  If diry = -1 ; Nach oben 
    If jnr_map(jnr\cy1, jnr\cx1) And jnr_map(jnr\cy2, jnr\cx2); And jnr_map(jnr\cy1, jnr\cx1) <> 2 And jnr_map(jnr\cy2, jnr\cx2) <> 2 
      jnr\y + act_speed * diry 
      If jnr\y < jnr\offsety 
        jnr\y = jnr\offsety 
      EndIf 
    Else 
      jnr\jump = #False 
      jnr\speed_y = 0 
      jnr\y = jnr\offsety + (jnr\cy1 * jnr\theight) + jnr\pheight 
    EndIf 
  EndIf 
  If diry = 1 ; Nach unten 
    If jnr_map(jnr\cy3, jnr\cx3) And jnr_map(jnr\cy4, jnr\cx4) And jnr_map(jnr\cy3, jnr\cx3) <> 2 And jnr_map(jnr\cy4, jnr\cx4) <> 2 
      jnr\y + act_speed * diry 
      If jnr\y = jnr\offsety + (jnr\mheight * jnr\theight) - jnr\pheight 
        jnr\y = jnr\offsety + (jnr\mheight * jnr\theight) - jnr\pheight 
      EndIf 
    Else 
      jnr\jump = #False 
      jnr\speed_y = 0 
      jnr\y = jnr\offsety + (jnr\cy1 * jnr\theight) 
    EndIf 
  EndIf 


  jnr_getcorners(jnr\x + act_speed * dirx, jnr\y) 
  If dirx = -1 ; Nach links 
    If jnr_map(jnr\cy1, jnr\cx1) And jnr_map(jnr\cy3, jnr\cx3) 
      jnr\x + act_speed * dirx 
      If jnr\x < jnr\offsetx 
        jnr\x = jnr\offsetx 
      EndIf 
    EndIf 
  EndIf 
  If dirx = 1 ; Nach rechts 
    If jnr_map(jnr\cy2, jnr\cx2) And jnr_map(jnr\cy4, jnr\cx4) 
      jnr\x + act_speed * dirx 
      If jnr\x = jnr\offsetx + (jnr\mwidth * jnr\twidth) - jnr\pwidth 
        jnr\x = jnr\offsetx + (jnr\mwidth * jnr\twidth) - jnr\pwidth 
      EndIf 
    EndIf 
  EndIf 
  ProcedureReturn #True 
EndProcedure 


Procedure jnr_jump() 
  jnr\speed_y - jnr\gravity 
  If jnr\speed_y < 0 
    jnr\jump = #False 
    jnr\speed_y = 0 
  EndIf 
  jnr_movechar(0, -1, 1) 
EndProcedure 


Procedure jnr_fall() 
  jnr\speed_y + jnr\gravity 
  If jnr\speed_y > jnr\theight 
    jnr\speed_y = jnr\theight 
  EndIf 
  jnr_movechar(0, 1, 1) 
EndProcedure 


Procedure jnr_cloud() 
  jnr_getcorners(jnr\x, jnr\y + 1) 
  If jnr_map(jnr\cy3, jnr\cx3) = 2 Or jnr_map(jnr\cy4, jnr\cx4) = 2 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 




; -------------------------------------------------------------------------------- 
; Von hier an beginnen die verwendbaren Befehle 
; -------------------------------------------------------------------------------- 


; Die Engine initialisieren 
Procedure jnr_init(mwidth.l, mheight.l, pwidth.l, pheight.l, twidth.l, theight.l, gravity.l, speed.l, offsetx.l = 0, offsety.l = 0) 
  ; mwidth  = Kartenbreite in Tiles 
  ; mheight = Kartenhöhe in Tiles 
  ; pwidth  = Spielerbreite in Pixel 
  ; pheight = Spielerhöhe in Pixel 
  ; twidth  = Tilebreite in Pixel 
  ; theight = Tilehöhe in Pixel 
  ; gravity = Schwerkraft 
  ; speed   = Geschwindigkeit des Spielers 
  ; offsetx = Abstand in Pixel vom linken Rand zur dargestellten Karte 
  ; offsety = Abstand in Pixel vom oberen Rand zur dargestellten Karte 
  Dim jnr_map(mwidth + 1, mheight + 1) 
  Restore jnr_data 
  For z1 = 0 To mheight 
    For z2 = 0 To mwidth 
      Read jnr_map(z1, z2) 
    Next z2 
  Next z1 
  If gravity < 0 
    ProcedureReturn #False 
  EndIf 
  If speed < 0 
    ProcedureReturn #False 
  EndIf 
  jnr\mwidth    = mwidth 
  jnr\mheight   = mheight 
  jnr\pwidth    = pwidth 
  jnr\pheight   = pheight 
  jnr\twidth    = twidth 
  jnr\theight   = theight 
  jnr\gravity   = gravity 
  jnr\speed_x   = speed 
  
  jnr\speed_y   = 0 
  jnr\x         = 0 
  jnr\y         = 0 
  jnr\jump      = #False 
  jnr\jumpdelay = 0 
  jnr\jumptimer = ElapsedMilliseconds() 
  jnr\moving    = #True 
  jnr\cx1       = 0 
  jnr\cx2       = 0 
  jnr\cx3       = 0 
  jnr\cx4       = 0 
  jnr\cy1       = 0 
  jnr\cy2       = 0 
  jnr\cy3       = 0 
  jnr\cy4       = 0 
  
  jnr\offsetx   = offsetx 
  jnr\offsety   = offsety 
  ProcedureReturn #True 
EndProcedure 


; Dieser Befehl kommt in die Spielehauptschleife! 
Procedure.l jnr_loop() 
  If jnr\jump = #True 
    jnr_jump() 
  Else 
    jnr_fall() 
  EndIf 
EndProcedure 


; Springt die gewünschte Höhe an! 
Procedure jnr_jumping(height.l, delay.l) 
  If jnr\jump = #True Or height < 0 Or height > jnr\theight Or ElapsedMilliseconds() - jnr\jumptimer < jnr\jumpdelay 
    ProcedureReturn #False 
  EndIf 
  jnr_getcorners(jnr\x, jnr\y + 1) 
  If jnr_map(jnr\cy3, jnr\cx3) And jnr_map(jnr\cy4, jnr\cx4) And jnr_cloud() = #False 
    ProcedureReturn #False 
  Else 
    jnr\jump      = #True 
    jnr\speed_y   = height 
    jnr\jumpdelay = delay 
    jnr\jumptimer = ElapsedMilliseconds() 
    ProcedureReturn #True 
  EndIf 
EndProcedure 
  

; Nach oben laufen (Eher nicht zu gebrauchen bei einem Jump&Run!) 
Procedure jnr_up() 
  ProcedureReturn jnr_movechar(0, -1, 0) 
EndProcedure 


; Nach unten laufen (Eher nicht zu gebrauchen bei einem Jump&Run!) 
Procedure jnr_down() 
  ProcedureReturn jnr_movechar(0, 1, 0) 
EndProcedure 


; Nach rechts laufen 
Procedure jnr_right() 
  ProcedureReturn jnr_movechar(1, 0, 0) 
EndProcedure 


; Nach links laufen 
Procedure jnr_left() 
  ProcedureReturn jnr_movechar(-1, 0, 0) 
EndProcedure 


; Bewegungen blockieren 
Procedure jnr_stopmoving() 
  jnr\moving = #False 
  ProcedureReturn #True 
EndProcedure 


; Schwerkraft ändern 
Procedure jnr_setgravity(gravity.l) 
  jnr\gravity = gravity 
ProcedureReturn #True 
EndProcedure 


; Geschwindigkeit ändern 
Procedure jnr_setspeed(speed_x.l) 
  jnr\speed_x = speed_x 
  ProcedureReturn #True 
EndProcedure 


; Was für ein Tile befindet sich unter dem Spieler 
Procedure jnr_gettile(x.l, y.l) 
  ProcedureReturn jnr_map(((y - jnr\offsety) + jnr\pheight / 2) / jnr\theight, ((x - jnr\offsetx) + jnr\pwidth / 2) / jnr\twidth) 
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ---
; EnableXP