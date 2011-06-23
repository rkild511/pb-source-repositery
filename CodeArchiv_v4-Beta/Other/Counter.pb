; German forum:
; Author: Unknown (updated for PB 4.00 by Andre)
; Date: 21. January 2003
; OS: Windows
; Demo: No


; Need the Timer userlib from PBOSL package!

; ------------------------------------------------------------ 
; 
; PureBasic - Freilaufender Zähler 
; 
; ------------------------------------------------------------ 
; 
Global counter 

counter=0 

LoadFont (1, "Arial", 50) 



Procedure addTimer() 
  
  counter=counter+1 
  
  
  If StartDrawing(WindowOutput(0)) 
    DrawingMode(0) 
    
    ; von Pos 1,1 den Farbwert bestimmen 
    Farbe = Point(1, 1) 
    ; Hintergrundfarbe für ZeichenOperationen festlegen 
    BackColor(Farbe) 
    
    DrawingFont(FontID(1)) 
    FrontColor(RGB(185, 55, 55))
    
    DrawText (200, 70, Str(counter)) 
    
    StopDrawing() 
  EndIf 
  
EndProcedure 



#WindowWidth = 450 
#WindowHeight = 315 

If OpenWindow(0, 150, 150, #WindowWidth, #WindowHeight, "PureBasic - Buttons mit Prozedur Beispiel", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget) 

StartTimer( 1,500, @addTimer() ) 


Repeat 

EventID = WaitWindowEvent() 


Until EventID = #PB_Event_CloseWindow 

EndIf 

EndTimer(1) 

End 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -