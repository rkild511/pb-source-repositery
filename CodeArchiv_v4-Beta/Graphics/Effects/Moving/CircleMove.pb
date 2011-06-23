; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5144&start=10
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 26. July 2004
; OS: Windows
; Demo: Yes

; Kreisbahn mit GSin und GCos:
; ----------------------------
; Die Kreisbahn wird hier nur mit diesen 2 Zeilen beschrieben: 
; 
; x = #sw/2 + gSin * 200 
; y = #sh/2 + gCos * 200 
; 
; Der erste Teil (#sw/2 und #sh/2) ergibt jeweils den Mittelpunkt 
; des Bildschirms, abhängig von der Auflösung. 
; Danach kommt vom Mittelpunkt aus GSin() und GCos() dazu. 
; Da GCos() und GSin() immer nur Werte zwischen 0 und 1 
; zurückliefern, multipliziert man diese Werte mit der Entfernung 
; vom Mittelpunkt, also dem Radius der Kreisbahn (hier 200). 



Procedure.f GSin(winkel.f) 
   ProcedureReturn Sin(winkel*(2*3.14159265/360)) 
EndProcedure 

Procedure.f GCos(winkel.f) 
   ProcedureReturn Cos(winkel*(2*3.14159265/360)) 
EndProcedure 

;----- 

#sw = 1024 
#sh = 768
#sn = "Sinus" 

If InitSprite()=0 Or InitKeyboard()=0 
  MessageRequester("ERROR","Cant init game engine !"):End 
EndIf 

If OpenScreen(#sw,#sh,32,#sn)=0 
  If OpenScreen(#sw,#sh,24,#sn)=0 
    If OpenScreen(#sw,#sh,16,#sn)=0 
      If OpenScreen(#sw,#sh,08,#sn)=0 
        MessageRequester("ERROR","Cant open screen !"):End 
EndIf:EndIf:EndIf:EndIf 


If CreateSprite(1,16,16)=0 
  CloseScreen() 
  MessageRequester("ERROR","Cant create sprite !"):End 
Else 
  If StartDrawing(SpriteOutput(1)) 
    Circle(8,8,8,$FFFFFF) 
    StopDrawing() 
  EndIf 
EndIf 


Repeat 
    ExamineKeyboard() 
    FlipBuffers() 
    ClearScreen (RGB(0,0,0)) 
    If IsScreenActive() 
      Grad.f - 0.5 
      If Grad >= 360 : Grad-360 : EndIf 
      
      gSin.f = GSin(Grad) 
      gCos.f = GCos(Grad) 

      x = #sw/2 + gSin * 200 
      y = #sh/2 + gCos * 200 
      DisplayTransparentSprite(1,x,y) 

      If StartDrawing(ScreenOutput()) 
        FrontColor(RGB(255,255,255)) 
        DrawingMode(1) 
        DrawText(50,30,"Grad: " + StrF(Grad,2)) 
        DrawText(50,50,"GSin: " + StrF(gSin,2)) 
        DrawText(50,70,"GCos: " + StrF(gCos,2)) 
        StopDrawing() 
      EndIf 
    EndIf 
Until KeyboardPushed(#PB_Key_Escape)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -