; merendo@lycos.de
; Author: merendo (updated for PB4.00 by blbltheworm)
; Date: 12. August 2003
; OS: Windows
; Demo: Yes

; Move mouse to create gfx effect, press left button to quit
If InitSprite() And InitSprite3D() And InitMouse() And InitKeyboard() And OpenScreen(640,480,16,"") And CreateSprite(0,640,480,#PB_Sprite_Texture) And CreateSprite3D(0,0)
  para$=ProgramParameter()
  If Str(Val(para$))=para$ And Val(para$)>7 And Val(para$)<31
    trans=Val(para$)
  Else
    trans=8
  EndIf
  TransparentSpriteColor(0,RGB(255,255,255))
  r=128
  g=128
  b=128
  Repeat
    ExamineMouse()
    ExamineKeyboard()
    mx+MouseDeltaX()
    my+MouseDeltaY()
    If mx>640:mx=640:EndIf
    If my>480:my=480:EndIf
    If mx<0:mx=0:EndIf
    If my<0:my=0:EndIf
    StartDrawing(ScreenOutput())
    rr=Random(10)-5
    gg=Random(10)-5
    bb=Random(10)-5
    If r+rr>255:rr=0:EndIf
    If g+gg>255:gg=0:EndIf
    If b+bb>255:bb=0:EndIf
    If r+rr<50:rr=0:EndIf
    If g+gg<50:gg=0:EndIf
    If b+bb<50:bb=0:EndIf
    r+rr
    g+gg
    b+bb
    FrontColor(RGB(r,g,b))
    LineXY(mx,my,640-mx,480-my)
    LineXY(mx,480-my,640-mx,my)
    StopDrawing()
    Start3D()
    DisplaySprite3D(0,0,0,trans)
    Stop3D()
    FlipBuffers()
  Until MouseButton(1)
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; Executable = C:\Eigene Dateien\PB_Projects\fadecross.exe
; DisableDebugger