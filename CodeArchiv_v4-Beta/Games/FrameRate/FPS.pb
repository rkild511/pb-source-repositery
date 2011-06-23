; German forum:
; Author: CyberRun8 (updated for PB4.00 by blbltheworm)
; Date: 08. December 2002
; OS: Windows
; Demo: Yes


; Routine zur Messung der Frames per Second (FPS) für den Einbau in eigene Programme

If InitSprite()=0                                                                                   
  MessageRequester("Fehler Sprite","Ihre DirectX-Version ist nicht aktuell oder fehlt!",0)
  End
EndIf
If InitKeyboard()=0                                                                                 
  MessageRequester("Fehler Tastatur","Ihre DirectX-Version ist nicht aktuell oder fehlt!",0)
  End
EndIf
If OpenScreen(800,600,16,"")=0                                                                     
  MessageRequester("Fehler Bildschirm","Ihre DirectX-Version ist nicht aktuell oder fehlt!",0)
  End
EndIf


Repeat
  ClearScreen(RGB(0,0,0))
  ExamineKeyboard()

  Gosub FPS

  FlipBuffers()
Until KeyboardPushed(#PB_Key_Escape)
End


;Hier werden die FPS berechnet und angezeigt
FPS:
  If Val(FormatDate("%ss", Date()))=sek
    FPS+1
  Else
    FPS$=Str(FPS)
    FPS=0
  EndIf
  sek=Val(FormatDate("%ss", Date()))
 
  StartDrawing(ScreenOutput()) 
    DrawingMode(1)
    FrontColor(RGB(255,255,255))
    DrawText(1,1,"FPS: "+FPS$)
  StopDrawing()
Return 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger