; German forum:
; Author: GPI (updated for PB4.00 by blbltheworm)
; Date: 31. May 2003
; OS: Windows
; Demo: No


; Get the "real" height of an used font (in this example Arial/16 will have a real height of 24)

;see the example, how to get the hdc 
Procedure GetTextHeight(hdc) 
  tm.textmetric 
  PrevMapMode=SetMapMode_(hdc,#MM_TEXT) 
  GetTextMetrics_(hdc,tm) 
  If PrevMapMode 
    SetMapMode_(hdc,PrevMapMode) 
  EndIf 
  ProcedureReturn tm\tmHeight 
EndProcedure 


LoadFont(0,"Arial",16) 

CreateImage(0,100,100) 

hdc=StartDrawing(ImageOutput(0)) ; start drawing and get the HDC 

DrawingFont(FontID(0)) ; Use the own font 

Height=GetTextHeight(hdc) ; how big it is 

;draw a text with a pixel-line between the text 
DrawText(1,1,"XYZ") 
DrawText(1,1+Height+1,"abc") 

StopDrawing() 

FreeFont(0) 


;display it 

OpenWindow(0,0,0,100,100,"TEST",#PB_Window_ScreenCentered|#PB_Window_SystemMenu) 
CreateGadgetList(WindowID(0)) 
ImageGadget(0,0,0,100,100,ImageID(0)) 
Repeat 
Until WaitWindowEvent()=#PB_Event_CloseWindow 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -