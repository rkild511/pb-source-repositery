; German forum: http://www.purebasic.fr/german/viewtopic.php?t=471&highlight=
; Author: Andreas (slightly changed by DarkDragon, updated for PB 4.00 by Andre)
; Date: 16. October 2004
; OS: Windows
; Demo: No


; Mittels des Win-API-Befehls DrawCaption() eine Titelleiste 
; mitten in das PB-Fenster (oder auf ein Image) zeichnen.

#DC_ACTIVE = $1 
#DC_SMALLCAP = $2 
#DC_ICON = $4 
#DC_TEXT = $8 
#DC_INBUTTON = $10 
#DC_GRADIENT = $20 


If OpenWindow(0, 100, 200, 195, 260, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
hDC = GetDC_(WindowID(0)) 
r.Rect 
r\left = 0 
r\top = 40 
r\right = 200 
r\bottom = r\top + GetSystemMetrics_(#SM_CYCAPTION) 
DrawCaption_(WindowID(0),hDC,r,#DC_GRADIENT|#DC_TEXT|#DC_ACTIVE|#DC_ICON) 
Repeat 
    EventID.l = WaitWindowEvent() 
    If EventID = #PB_Event_CloseWindow 
      Quit = 1 
    EndIf 
  Until Quit = 1 
EndIf 
ReleaseDC_(WindowID(0), hDC) 
End 
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -