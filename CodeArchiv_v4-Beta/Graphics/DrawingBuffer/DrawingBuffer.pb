; English forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 11. October 2003
; OS: Windows
; Demo: No

Global FPS, Timer, NewTime, frames, Text.s 

Procedure CreateArray(source) 
  Global Dim PixelArray.l(128,128) 
  sid=SpriteOutput(1) 
  workdc=StartDrawing(sid) 
      *Adresse.BYTE = DrawingBuffer() 
      diff = DrawingBufferPitch()-512 
      For y=0 To 127 
        For x=0 To 127 
          b=*Adresse\b:*Adresse+1 
          g=*Adresse\b:*Adresse+1 
          r=*Adresse\b:*Adresse+2 
          PixelArray(x,y)=RGB(r,g,b) 
        Next x 
        *Adresse+diff 
      Next y 
      Plot(0,0,PixelArray(0,0)) 
      TransparentSpriteColor(2,RGB(Red(Point(0,0)),Green(Point(0,0)),Blue(Point(0,0)))) 
  StopDrawing() 
EndProcedure 

Procedure RotatebyArray(angle.f) 
  s.f=Sin(6.28318531/3600*angle):c.f=Cos(6.28318531/3600*angle) 
  mx=64:my=64:mx2=90:my2=90 
  max=181:may=181 
  sid=SpriteOutput(2) 
  workdc=StartDrawing(sid) 
    Box(0, 0, 181, 181, Fcolor) 
    For y=0 To 127 
      For x=0 To 127 
        RotateX.f = ((x - mx) * c - (y - my) * s) + mx2 
        RotateY.f = ((x - mx) * s + (y - my) * c) + my2 
        If RotateX>0 And Int(RotateX)<max-1 And RotateY>0 And Int(RotateY)<may-1
          Plot(RotateX,RotateY,PixelArray(x,y)) 
          If angle<>0 And angle<>900 And angle<>1800 And angle<>2700 And angle<>3600
            Plot(Int(RotateX)+1,Int(RotateY),PixelArray(x,y)) 
            Plot(Int(RotateX),Int(RotateY)+1,PixelArray(x,y)) 
          EndIf 
        EndIf 
      Next x 
    Next y 
  StopDrawing() 
EndProcedure 

Procedure InfoText() 
  frames+1 
  NewTime=GetTickCount_() 
  If NewTime-Timer > 1000 
    FPS=frames:frames=0:Timer=NewTime 
  EndIf 
  StartDrawing(ScreenOutput()) 
    DrawingMode(1):FrontColor(RGB(255,0,0)) 
    DrawText(10, 05,"FPS: "+Str(FPS)) 
    DrawText(10, 20,"Info: "+Text) 
  StopDrawing() 
EndProcedure 

InitSprite():InitKeyboard():InitMouse():OpenScreen(640,480,32,"") 

;LoadSprite(1,"Geebee2.bmp",0) 
;Bitte Pfad anpassen. Zu finden unter: 
;C:\..\PureBasic\Examples\Sources\Data\Geebee2.bmp 
LoadSprite(1,"..\Gfx\Geebee2.bmp",0)

CreateSprite(2,181,181,0) 

time=GetTickCount_() 
CreateArray(1) 
time=GetTickCount_()-time 

Text="Array erstellt in "+Str(time)+" msek   (ESC = Ende)" 
Timer=GetTickCount_() 
Repeat 
    ExamineMouse():ExamineKeyboard():ClearScreen(RGB(0,0,0)) 
    zfx.f=170*Sin(6.28318531-((count+900)*6.28318531/3600)) 
    zfy.f=170*Cos(6.28318531-((count+900)*6.28318531/3600)) 
    RotatebyArray(count) 
    count+20:If count=3620:count=0:EndIf 
    DisplayTransparentSprite(2,230+zfx,150+zfy) 
    InfoText() 
    FlipBuffers() 
Until KeyboardPushed(#PB_Key_Escape) 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -