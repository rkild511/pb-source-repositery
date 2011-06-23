; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1367&highlight=
; Author: OnkelD, additions by Andre (updated for PB4.00 by blbltheworm)
; Date: 15. June 2003
; OS: Windows
; Demo: Yes

Procedure Outline(text$,ox,oy) 
  StartDrawing(WindowOutput(0)) 
    FrontColor(RGB(255,000,000)) 
    DrawingMode(3) 
    DrawText(ox,oy,text$) ; normal 
    DrawText(ox-1,oy,text$) ; normal links 
    DrawText(ox+1,oy,text$) ; normal rechts 
    DrawText(ox,oy-1,text$) ; oben 
    DrawText(ox,oy+1,text$) ; unten 
    DrawText(ox-1,oy-1,text$) ; links oben 
    DrawText(ox+1,oy-1,text$) ; rechts oben 
    DrawText(ox-1,oy+1,text$) ; links unten 
    DrawText(ox+1,oy+1,text$) ; rechts unten 
    FrontColor(RGB(255,255,255)) 
    DrawText(ox,oy,text$) 
  StopDrawing() 
EndProcedure

If OpenWindow(0, 100, 200, 195, 260, "Outline Text", #PB_Window_SystemMenu) 
  Outline("Outline-Text",20,20)
  Repeat 
    EventID.l = WaitWindowEvent() 
    If EventID = #PB_Event_CloseWindow 
      Quit = 1 
    EndIf 
  Until Quit = 1 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
