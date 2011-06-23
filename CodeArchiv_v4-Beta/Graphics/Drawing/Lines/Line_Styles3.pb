; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2439&postdays=0&postorder=asc&start=20
; Author: GPI (updated for PB4.00 by blbltheworm)
; Date: 05. October 2003
; OS: Windows
; Demo: No

; Note:    Don't use a PB function between AutoPen() and EndPen()
; Hinweis: Wichtig ist eigentlich nur, daﬂ zwischen AutoPen() und EndPen() auf keinen Fall eine
;          PB-Funktion aufgerufen wird, die die Farbe etc. ‰ndert.

Global _AutoPen_OldPen_ 
Global _AutoPen_NewPen_ 
Procedure AutoPen(hDC,Style,width,color) 
  If _AutoPen_OldPen_=0 
    _AutoPen_OldPen_=GetCurrentObject_(hDC,#OBJ_PEN) 
  EndIf 
  If _AutoPen_NewPen_ 
    DeleteObject_(_AutoPen_NewPen_) 
  EndIf 
  _AutoPen_NewPen_=CreatePen_(Style,width,color) 
  SelectObject_(hDC,_AutoPen_NewPen_) 
EndProcedure 
Procedure EndPen(hDC) 
  If _AutoPen_NewPen_ 
    DeleteObject_(_AutoPen_NewPen_) 
  EndIf 
  SelectObject_(hDC,_AutoPen_OldPen_) 
  _AutoPen_OldPen_=0 
EndProcedure 
    
  
If CreateImage(0,400,400) 
  hDC=StartDrawing(ImageOutput(0)) 
  Box(0,0,400,400,RGB(255,255,255)) 
  
  AutoPen(hDC, #PS_SOLID, 15 ,RGB(0,0,0)) 
    
  LineXY( 10, 10, 100, 100 ) 
  AutoPen(hDC, #PS_SOLID, 3 ,RGB(255,0,0)) 
  LineXY( 100, 100, 100, 200 ) 
  AutoPen(hDC, #PS_SOLID, 10 ,RGB(0, 255, 0) ) 
  LineXY ( 100, 200, 10, 100 ) 
  AutoPen(hDC,#PS_DASH,1,RGB(255, 0, 100) ) 
  LineXY ( 10, 230, 150, 230 ) 
  AutoPen(hDC,#PS_DASHDOTDOT, 1 ,RGB(255,0,100)) 
  LineXY (10, 240, 150, 240 ) 
  AutoPen(hDC,#PS_DOT, 1 ,RGB(255,0,100)) 
  LineXY (10, 250, 150, 250) 
  EndPen(hDC) 
  StopDrawing() 
  
  If OpenWindow(1,0,0,400,400,"Pen-Test",#PB_Window_ScreenCentered|#PB_Window_SystemMenu) 
    If CreateGadgetList(WindowID(1)) 
      ImageGadget(0,0,0,400,400,ImageID(0)) 
      While WaitWindowEvent()<>#PB_Event_CloseWindow:Wend 
      CloseWindow(1) 
    EndIf 
  EndIf 
  FreeImage(0) 
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
