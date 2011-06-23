; German forum: http://www.purebasic.fr/german/viewtopic.php?t=4956
; Author: Falko (updated for PB 4.00 by Andre)
; Date: 01. October 2005
; OS: Windows
; Demo: No

#FONT_SIZE=12 
If OpenWindow(0, 100, 200, 640,480,"PureBasic Window",#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_WindowCentered) 
  hdc = GetDC_(WindowID(0)) 
  NewFont.LOGFONT 
  FontName.s = "Arial"+Chr(0) 
  text.s = "Purebasic dreht durch..." 
  NewFont\lfFaceName=@FontName 
  For n =0 To 3600 Step 200 
    s.f=s.f +0.15 
    NewFont\lfEscapement = n 
    NewFont\lfHeight = (#FONT_SIZE*-s.f) 
    hFont = CreateFontIndirect_(NewFont) 
    oldFont = SelectObject_(hdc,hFont) 
    TextOut_(hdc,WindowWidth(0)/2-75,WindowHeight(0)/2-75,text.s,Len(text.s)) 
    retval = SelectObject_(hdc,oldFont) 
    retval=DeleteObject_(hFont) 
  Next n  
    
  Repeat 
    EventID.l = WaitWindowEvent() 
   If EventID = #PB_Event_CloseWindow  ; If the user has pressed on the close button 
      Quit = 1 
    EndIf 
   Until Quit = 1 
EndIf 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP