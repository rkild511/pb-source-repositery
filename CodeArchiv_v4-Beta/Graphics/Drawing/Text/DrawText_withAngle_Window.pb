; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1354&highlight=
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 14. June 2003
; OS: Windows
; Demo: No

Procedure DrawRText(DC.l,x,y,Text.s,fFont.s,fangle.l,fHeight) 
  Font = CreateFont_(fHeight,0,fangle*10,0,0,0,0,0,0,0,0,0,0,fFont) 
  GetWindowRect_(WindowID(0),r.RECT) 
  OldFont = SelectObject_(DC,Font) 
  SetTextAlign_(DC,#TA_BASELINE) 
  SetBkMode_(DC,#TRANSPARENT) 
  ExtTextOut_(DC, x,y,0 ,r,Text,Len(Text),0 ) 
  SelectObject_(DC,OldFont) 
  DeleteObject_(Font) 
EndProcedure 

If OpenWindow(0, 100, 200, 195, 260, "Fonts", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
  
  DC = StartDrawing(WindowOutput(0)) 
  FrontColor(RGB(255,0,0)) 
  DrawRText(DC,10,100,"Testtext","Arial",30,40) 
  ;Parameter 
  ;1 = DeviceContext 
  ;2 = StartX 
  ;3 = StartY 
  ;4 = Text$ 
  ;5 = Font$ 
  ;6 = Angle 
  ;7 = FontHeight 
  StopDrawing() 
  
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
