; English forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 22. January 2004
; OS: Windows
; Demo: Yes

#ScreenWidth  = 800 ;1600
#ScreenHeight = 600 ;1200

If InitSprite() = 0 Or InitKeyboard() = 0
  MessageRequester("ERROR","Cant init DirectX",0)
EndIf

Procedure.f GSin(Angle.f)
  ProcedureReturn Sin(Angle*(2*3.14159265/360))
EndProcedure

Procedure.f GCos(Angle.f)
  ProcedureReturn Cos(Angle*(2*3.14159265/360))
EndProcedure

Structure myPoint
  x.l
  y.l
EndStructure

Global Dim Quadrat.myPoint(8)
Radius       = 100
Depth        = Radius/2
speed.f      = 1.5
degree.f     = 30.0
#MiddleX     = #ScreenWidth  / 2
#MiddleY     = #ScreenHeight / 2

If OpenScreen(#ScreenWidth,#ScreenHeight,32,"Line-Test") = 0 : CloseScreen() 
  If OpenScreen(#ScreenWidth,#ScreenHeight,24,"Line-Test") = 0 : CloseScreen() 
    If OpenScreen(#ScreenWidth,#ScreenHeight,16,"Line-Test") = 0 : CloseScreen() 
       If OpenScreen(#ScreenWidth,#ScreenHeight,8,"Line-Test") = 0 : CloseScreen() 
          MessageRequester("ERROR", "Cant open "+Str(#ScreenWidth)+"x"+Str(#ScreenHeight)+" DirectX Screen",0): End 
       EndIf
    EndIf
  EndIf
EndIf 
    
  Repeat 
    FlipBuffers() 
    If IsScreenActive() 
      ClearScreen(RGB(0,0,0)) 
      
      Offset = Depth/2 
      Quadrat(1)\x = #MiddleX-Offset + GSin(degree)*Radius 
      Quadrat(1)\y = #MiddleY+Offset + GCos(degree)*Radius 
      Quadrat(2)\x = #MiddleX-Offset + GSin(degree+90)*Radius 
      Quadrat(2)\y = #MiddleY+Offset + GCos(degree+90)*Radius 
      Quadrat(3)\x = #MiddleX-Offset - GSin(degree)*Radius 
      Quadrat(3)\y = #MiddleY+Offset - GCos(degree)*Radius 
      Quadrat(4)\x = #MiddleX-Offset - GSin(degree+90)*Radius 
      Quadrat(4)\y = #MiddleY+Offset - GCos(degree+90)*Radius 
      
      Quadrat(5)\x = Quadrat(1)\x + Depth 
      Quadrat(5)\y = Quadrat(1)\y - Depth 
      Quadrat(6)\x = Quadrat(2)\x + Depth 
      Quadrat(6)\y = Quadrat(2)\y - Depth 
      Quadrat(7)\x = Quadrat(3)\x + Depth 
      Quadrat(7)\y = Quadrat(3)\y - Depth 
      Quadrat(8)\x = Quadrat(4)\x + Depth 
      Quadrat(8)\y = Quadrat(4)\y - Depth 
      
      
      StartDrawing(ScreenOutput()) 
         DrawingMode(1) 
          
         For a = 1 To 50 
             c = Random(255) 
             Box(Random(#ScreenWidth),Random(#ScreenHeight),Random(4),Random(4),RGB(c,c,c)) 
         Next a 
          
         FrontColor(RGB(color,color,0)) 
         If colorflag = 0 
            color + 2 : If color = 254 : colorflag = 1 : EndIf 
         Else 
            color - 2 : If color =   0 : colorflag = 0 : EndIf 
         EndIf 
         DrawText(100,10,"Use CursorKeys to control speed and z00m") 
          
          
         FrontColor(RGB($FF,$FF,$00)) 
          
         ;DrawText("Degree: "+Using("000",Abs(degree-360))) 
         DrawText(#MiddleX-Radius-100,#MiddleY-Radius,"degree: "+StrF(Abs(degree-360),2)) 
          
         DrawText(#MiddleX-Radius-100,#MiddleY-Radius-15,"Speed: "+StrF(speed,2)) 
          
         DrawText(#MiddleX-Radius-100,#MiddleY-Radius+15,"z00m: "+StrF(Radius/10,1)) 
          
         ; Background Quadrat 
         LineXY(Quadrat(5)\x,Quadrat(5)\y, Quadrat(6)\x, Quadrat(6)\y, $0000FF) 
         LineXY(Quadrat(6)\x,Quadrat(6)\y, Quadrat(7)\x, Quadrat(7)\y, $FF0000) 
         LineXY(Quadrat(7)\x,Quadrat(7)\y, Quadrat(8)\x, Quadrat(8)\y, $FF00FF) 
         LineXY(Quadrat(8)\x,Quadrat(8)\y, Quadrat(5)\x, Quadrat(5)\y, $FF38AA) 
          
         ; connections between the Quadrats 
         LineXY(Quadrat(1)\x,Quadrat(1)\y, Quadrat(5)\x, Quadrat(5)\y, $555555) 
         LineXY(Quadrat(2)\x,Quadrat(2)\y, Quadrat(6)\x, Quadrat(6)\y, $777777) 
         LineXY(Quadrat(3)\x,Quadrat(3)\y, Quadrat(7)\x, Quadrat(7)\y, $999999) 
         LineXY(Quadrat(4)\x,Quadrat(4)\y, Quadrat(8)\x, Quadrat(8)\y, $BBBBBB) 
          
          
         ; Foreground Quadrat 
         LineXY(Quadrat(1)\x,Quadrat(1)\y, Quadrat(2)\x, Quadrat(2)\y, $00FFFF) 
         LineXY(Quadrat(2)\x,Quadrat(2)\y, Quadrat(3)\x, Quadrat(3)\y, $00FF00) 
         LineXY(Quadrat(3)\x,Quadrat(3)\y, Quadrat(4)\x, Quadrat(4)\y, $FFFF00) 
         LineXY(Quadrat(4)\x,Quadrat(4)\y, Quadrat(1)\x, Quadrat(1)\y, $5115F5) 
          
      StopDrawing() 
      degree - speed.f 
      If degree <=   0.0 : degree = 360.0 + degree    : EndIf 
      If degree => 360.0 : degree =   0.0 + degree-360: EndIf 
      
      ExamineKeyboard() 
      If KeyboardPushed(#PB_Key_Right): speed  + 0.01 : EndIf 
      If KeyboardPushed(#PB_Key_Left ): speed  - 0.01 : EndIf 
      If KeyboardPushed(#PB_Key_Up   ): Radius + 1    : EndIf 
      If KeyboardPushed(#PB_Key_Down ): Radius - 1    : EndIf 
      
      If Radius < 10              : Radius = 10              : EndIf 
      If Radius > #MiddleY-Offset : Radius = #MiddleY-Offset : EndIf 
      Depth = Radius/2 

      Delay(1) 
    Else 
      Delay(200) 
    EndIf 
  Until KeyboardPushed(#PB_Key_Escape) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -