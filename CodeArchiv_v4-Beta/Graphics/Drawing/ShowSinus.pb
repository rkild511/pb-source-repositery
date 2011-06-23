; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5144&start=10
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 26. July 2004
; OS: Windows
; Demo: Yes

; Sinus anzeigen:
; ---------------
; Die Prozeduren GSin() und GCos() sind hier dazu da um den 
; Sinus/CoSinus eines Winkels in Grad zu bekommen. 
; Man gibt also eine Grad-Zahl zwischen 0 und 360 an, da man 
; damit meist besser rechnen kann als mit PI. 
; Die Prozeduren sind mit Absicht so gelassen, so daß man sieht 
; welche Einzelschritte unternommen werden. Den Teil mit 
; "2 * 3.14159265 / 360" kann man ja normal zusammenfassen. 

Procedure.f GSin(winkel.f) 
   ProcedureReturn Sin(winkel*(2*3.14159265/360)) 
EndProcedure 

Procedure.f GCos(winkel.f) 
   ProcedureReturn Cos(winkel*(2*3.14159265/360)) 
EndProcedure 

;----- 

#sw = 800 
#sh = 600 
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
      Grad.f + 0.1 
      If Grad >= 360 : Grad-360 : EndIf 
      
      gSin.f = GSin(Grad) 

      DisplayTransparentSprite(1,#sw/2,#sh/2+gSin*(#sh/2-50)) 

      If StartDrawing(ScreenOutput()) 
        FrontColor(RGB(255,255,255)) 
        DrawingMode(1) 
        DrawText(50,30,"Grad: " + StrF(Grad,2)) 
        DrawText(50,50,"GSin: " + StrF(gSin,2)) 
        StopDrawing() 
      EndIf 
    EndIf 
Until KeyboardPushed(#PB_Key_Escape)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -