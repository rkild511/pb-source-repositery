; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1505&highlight=
; Author: [DS]DarkDragon (updated for PB4.00 by blbltheworm)
; Date: 28. June 2003
; OS: Windows
; Demo: Yes


OpenWindow(0, 0, 0, 500, 500, "Spirale", #PB_Window_TitleBar | #PB_Window_SystemMenu) 

BOX = CreateImage(0, WindowWidth(0), WindowHeight(0)) 

PI2.f = ATan(1)*8;Aus dem Beispiel ist auch ein wenig geklaut, bitte nicht böse sein 
PI1.f = ATan(1)*4 

xm = WindowWidth(0)/2 
ym = WindowHeight(0)/2 
radius = WindowWidth(0)/2-5 
steps = 2050 

StartDrawing(ImageOutput(0)) 
Box(0, 0, ImageWidth(0), ImageHeight(0), RGB(255, 255, 255)) 
a.f = PI2 
While a >= 0 
   x = Sin(a+PI1)*radius+xm 
   y = Cos(a+PI1)*radius+ym 
   Plot(x, y, RGB(255, 0, 0)) 
   a-PI2/steps 
Wend 
rad2.f = 0 
a.f = PI2 
b = -1 
While a >= -53.5 
   x = Sin(a+PI1)*rad2+xm 
   y = Cos(a+PI1)*rad2+ym 
   Plot(x, y, RGB(0, 0, 255)) 
   rad2 + 0.0125 
   a-PI2/steps 
Wend 
rad2.f = 0 
a.f = PI2 
b = -1 
While a >= -53.5 
   x = Sin(a+PI1)*(rad2*-1)+xm 
   y = Cos(a+PI1)*(rad2*-1)+ym 
   Plot(x, y, RGB(0, 255, 255)) 
   rad2 + 0.0125 
   a-PI2/steps 
Wend 
StopDrawing() 

StartDrawing(WindowOutput(0)) 
DrawImage(BOX, 0, 0) 
StopDrawing() 

If CreatePopupMenu(0) 
   MenuItem(0, "Copy") 
EndIf 

Repeat 
  Event = WaitWindowEvent() 
  Select Event 
   Case #WM_RBUTTONDOWN 
    DisplayPopupMenu(0, WindowID(0)) 
   Case #PB_Event_Repaint 
    StartDrawing(WindowOutput(0)) 
    DrawImage(BOX, 0, 0) 
    StopDrawing() 
   Case #PB_Event_Menu 
    Select EventMenu() 
     Case 0 
      SetClipboardImage( ImageID(0)) 
    EndSelect 
  EndSelect 
Until Event = #PB_Event_CloseWindow 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
