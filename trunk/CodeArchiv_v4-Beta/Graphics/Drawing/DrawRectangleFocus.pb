; German forum: http://www.purebasic.fr/german/viewtopic.php?t.php?t=3357&highlight=
; Author: FGK (updated for PB 4.00 by Andre)
; Date: 16. May 2005
; OS: Windows
; Demo: No


; Draw a rectangle focus with DrawFocusRect_()
; Gestricheltes Rechteck mit DrawFocusRect_() zeichnen

If OpenWindow(0, 100, 200, 640,480, "PureBasic DrawFocusRect-Demo", #PB_Window_SystemMenu|#PB_Window_WindowCentered) 
  
  hdc = GetDC_(WindowID(0)) 
  SetRect_(R.RECT,20,20,620,440) 
  DrawFocusRect_(hdc,R) 
  Repeat 
    DrawFocusRect_(hdc,R) 
    Select Dir 
      Case 0 
        R\top+2 
        R\bottom-2 
        R\left+2 
        R\right-2 
        If R\top>220 
          Dir =1 
        EndIf  
      Case 1 
        R\top-2 
        R\bottom+2 
        R\left -2 
        R\right+2 
        If R\top<20 
          Dir =0 
        EndIf  
    EndSelect    
    DrawFocusRect_(hdc,R) 
    If WindowEvent() = #PB_Event_CloseWindow  ; If the user has pressed on the close button 
      Quit = 1 
    EndIf 
    Delay(10)  
  Until Quit = 1 
  
EndIf 
End 


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -