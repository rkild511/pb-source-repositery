; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9561
; Author. techjunkie (updated for PB 4.00 by Andre)
; Date: 19. February 2004
; OS: Windows
; Demo: Yes


; I just had to convert a cool "homing example" by Jeppe Nielsen from BlitzBasic To PureBasic. 
; It isn't perfect in any way! I did a fast conversion and it can improved in a 1000 ways. 

; It is an example of homing physics that allow "enemies" to chase player, with velocity and
; acceleration. 
; Can be used in games for example.
; _____________________________________________________________

; Homing example, by Jeppe Nielsen 2003 
; 
; Original code from BlitzBasic Community 
; http://www.blitzbasic.com 
; 
; Converted from BlitzBasic to PureBasic by Techjunkie 2004 

Global playerx.l 
Global playery.l 
Global distance.f 
Global fcolor.l 

distance = 100 

Structure enemy 
  x.l 
  y.l 
  vx.f 
  vy.f 
  ax.f 
  ay.f 
  vmax.f 
  amax.f 
EndStructure 

Global e.enemy 
Global Dim e.enemy(1000) 

Global enemy_count.l 
enemy_count = 0 

Procedure enemynew(x.f, y.f, vmax.f, amax.f) 

  e(enemy_count)\x = x 
  e(enemy_count)\y = y 

  e(enemy_count)\vmax = vmax 
  e(enemy_count)\amax = amax 

  enemy_count + 1 
  
EndProcedure 

Procedure enemyupdate() 

  For i = 0 To enemy_count 

    dx.f = (playerx - e(i)\x) 
    dy.f = (playery - e(i)\y) 

    l.f = Sqr(dx.f * dx.f + dy.f * dy.f) 

    dx.f =( dx.f / l.f) * e(i)\amax 
    dy.f = (dy.f / l.f) * e(i)\amax 

;if close enough escape target 
    If l.f <= distance.f 
      dx.f = -dx.f 
      dy.f = -dy.f 
    EndIf 

;check against all other enemies, to avoid them 
    dxx.f = 0 
    dyy.f = 0 
    co = 0 

    For j = 0 To enemy_count 
      If j <> i  
        dex.f = (e(i)\x - e(j)\x) 
        dey.f = (e(i)\y - e(j)\y) 
  
        l.f = Sqr(dex.f * dex.f + dey.f * dey.f) 
  
        dxx.f = dxx.f + (dex.f / l.f) * e(i)\amax 
        dyy.f = dyy.f + (dey.f / l.f) * e(i)\amax 
  
        co + 1 
      EndIf 
    Next 

    dxx.f = dxx.f / co 
    dyy.f = dyy.f / co 

    dx.f = (dx.f + dxx.f) / 2.0 
    dy.f = (dy.f + dyy.f) / 2.0 

    e(i)\ax = e(i)\ax + dx.f 
    e(i)\ay = e(i)\ay + dy.f 

    acc.f = Sqr(e(i)\ax * e(i)\ax + e(i)\ay * e(i)\ay) 

;Check if current acceleration is more than allowed 
    If acc.f > e(i)\amax 
      e(i)\ax = (e(i)\ax / acc.f) * e(i)\amax 
      e(i)\ay = (e(i)\ay / acc.f) * e(i)\amax 
    EndIf 

    e(i)\vx = e(i)\vx + e(i)\ax 
    e(i)\vy = e(i)\vy + e(i)\ay 

    vel.f = Sqr(e(i)\vx * e(i)\vx + e(i)\vy * e(i)\vy) 

;Check if current velocity is more than allowed 
    If vel.f > e(i)\vmax 
      e(i)\vx = (e(i)\vx / vel.f) * e(i)\vmax 
      e(i)\vy = (e(i)\vy / vel.f) * e(i)\vmax 
    EndIf 

; add velocity to position 
    e(i)\x = e(i)\x + e(i)\vx 
    e(i)\y = e(i)\y + e(i)\vy 

  Next 
EndProcedure 

If InitMouse() = 0 Or InitSprite() = 0 Or InitKeyboard() = 0 
  MessageRequester("Error", "Can't open DirectX", 0) 
  End 
EndIf 

ExamineDesktops()
If (OpenScreen(DesktopWidth(0), DesktopHeight(0), 16, "Homing Example") = 0) 
  MessageRequester("Error", "Impossible to open a 800*600 16 bit screen",0) 
  End 
EndIf 

;create ten enemies at random locations 
For i = 1 To 10    
  enemynew(Random(800.0), Random(600.0), (4.0*Random(1000)/1000) + 0.5, (0.08*Random(1000)/1000) + 0.02) 
Next 

BackColor(RGB(0, 0, 0))
click = 0 
fcolor = RGB(255,255,255) 

Repeat 
  FlipBuffers() 
  ClearScreen(RGB(0,0,0))
  
  ExamineKeyboard() 
  ExamineMouse()      
  
  StartDrawing(ScreenOutput()) 
    DrawingMode(2|4) 
    text.s = "Enemies = " + Str(enemy_count) 
    DrawText(10, 10, text) 
    DrawText(10, 30, "Move player with mouse") 
    DrawText(10, 50, "LMB - Resize allowed distance to player") 
    DrawText(10, 70, "RMB - Add enemies") 
    DrawText(10, 90, "ESC - Quit") 
  StopDrawing() 

  If click = 0 
    playerx = MouseX() 
    playery = MouseY() 
  EndIf 

  If (MouseButton(1) And click = 0) 
    click = 1 
    clickx = MouseX() 
    clicky = MouseY() 
  EndIf 

  If (MouseButton(1) And click = 1) 
    dx = (MouseX() - clickx) 
    dy = (MouseY() - clicky) 

    distance = Sqr(dx * dx + dy * dy) 
  EndIf 

  If (MouseButton(1) = 0 And click = 1) 
    click = 0 
  EndIf 

  If (MouseButton(2)) 
    If (enemy_count < 1000) 
      enemynew(Random(800.0), Random(600.0), 2.5, (0.08 * Random(1000)/1000) + 0.02) 
    EndIf 
  EndIf 

  enemyupdate() 
  
  StartDrawing(ScreenOutput()) 
    DrawingMode(2|4) 
    For i = 0 To enemy_count 
      Box(e(i)\x - 3, e(i)\y - 3, 6, 6, fcolor) 
    Next 
    Box(playerx - distance, playery - distance, 10, 10, fcolor) 
    Circle(playerx - distance , playery - distance, distance * 2, fcolor)  
  StopDrawing() 

Until KeyboardPushed(#PB_Key_Escape) 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger