; German forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 10. January 2003
; OS: Windows
; Demo: Yes

objzahl = 50 

Structure ring 
  xpos.f 
  ypos.f 
  speed.w 
  transp.w 
  bewradius.w 
  winkel.w 
  nummer.w 
  farbe.w 
  farbnummer.w 
EndStructure 

farbe = 255 / objzahl; 

Global Dim typ.ring(objzahl) 
For t = 0 To objzahl - 1 
  typ(t)\speed = Random(10)+2 
  typ(t)\winkel = 1 
  typ(t)\bewradius = t + 10 
  typ(t)\transp = 10 + t 
  typ(t)\nummer = t 
  typ(t)\farbe = 255 - t * farbe 
  typ(t)\farbnummer = f 
  f = f + 1 
  If f = 3 
    f = 0 
  EndIf 
  
  
Next 

;kreistabelle 
Global Dim sinus.f(360) 
Global Dim cosinus.f(360) 
For t = 0 To 359 
  sinus(t)=Sin(t * (2 * 3.14159265 / 360)) 
  cosinus(t)=Cos(t * (2 * 3.14159265 / 360)) 
Next 
InitKeyboard() 
InitSprite() 
InitSprite3D() 
OpenScreen(1024,  768, 32, "bla") 


;ringsprites malen und in 3d sprites verwandeln 
texturesize = 512;texturgrösse 
ringfaktor = texturesize / 26 

For t = 0 To objzahl - 1 
  CreateSprite(t, texturesize, texturesize, #PB_Sprite_Texture) 
  StartDrawing(SpriteOutput(t)) 
  radius = texturesize / 2 
  
  For i = 1 To 7 
    If typ(t)\farbnummer = 0 
      FrontColor(RGB(typ(t)\farbe,0,0)) 
    EndIf 
    If typ(t)\farbnummer = 1 
      FrontColor(RGB(0,typ(t)\farbe,0)) 
    EndIf 
    If typ(t)\farbnummer = 2 
      FrontColor(RGB(0,0,typ(t)\farbe)) 
    EndIf 
    Circle (texturesize / 2 + v, texturesize / 2 + v, radius - v * ringfaktor) 
    v = v + 1 
    Circle (texturesize / 2 + v, texturesize / 2 + v, radius - v * ringfaktor, RGB(0, 0, 0)) 
    v = v + 1 
  Next 
  
  StopDrawing() 
  v = 0 
  zoom = 800 
  CreateSprite3D(t, t) 
  ZoomSprite3D(t, zoom, zoom) 
Next 

;hauptschleife 
Repeat 
  
  For t = 0 To objzahl - 1 
    
    ;3d sprites malen 
    Start3D() 
    DisplaySprite3D(typ(t)\nummer, typ(t)\xpos, typ(t)\ypos, typ(t)\transp) 
    Stop3D() 
    
    ;nächste x und y position berechnen 
    typ(t)\xpos = Cosinus(typ(t)\winkel)*typ(t)\bewradius / 2 
    typ(t)\ypos = -100 + Sinus(typ(t)\winkel)*typ(t)\bewradius / 2 
    
    ;nächster winkel für die kreisbewegung 
    If typ(t)\winkel > 359 - typ(t)\speed 
      typ(t)\winkel = 0 
    EndIf 
    typ(t)\winkel = typ(t)\winkel + typ(t)\speed 
    
  Next 
  
  FlipBuffers() 
  ClearScreen(RGB(0,0,0)) 
  ExamineKeyboard() 
Until KeyboardPushed(#PB_Key_All) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger