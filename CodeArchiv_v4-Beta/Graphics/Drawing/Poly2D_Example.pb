; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3248&highlight=
; Author: Christian (updated for PB4.00 by blbltheworm)
; Date: 27. December 2003
; OS: Windows
; Demo: Yes

; Example for the Poly2D.pbi include file, providing several 2D polygon drawing procedures
XIncludeFile "..\..\Includes+Macros\Includes\2D\Poly2D.pbi" 

#SCREEN_Width = 500 
#SCREEN_Height = 500 

If InitSprite() = 0 Or InitKeyboard() = 0 Or InitMouse() = 0 
   MessageRequester("ERROR","Cant init DirectX",0) 
   End 
EndIf 

MainWnd.l = OpenWindow(0, 0, 0, #SCREEN_Width, #SCREEN_Height, "Polygon Beispiel", #PB_Window_ScreenCentered) 
If OpenWindowedScreen(MainWnd.l, 0, 0, #SCREEN_Width, #SCREEN_Height, 1, 0, 0) 

If InitPolygonDrawing() 
; -- Cursor 
  SetPolygonPoint(0, 0,   5,   5) 
  SetPolygonPoint(0, 1,  30,  20) 
  SetPolygonPoint(0, 2,  17,  17) 
  SetPolygonPoint(0, 3,  20,  30) 

  CreatePolygon(0, 50, 50, RGB(0,0,255)) 
  SetPolygonColor(0, 10, 10, RGB(0,0,255), RGB(0,0,255)) 

; -- Fünfeck 
  SetPolygonPoint(1, 0,   0,   0) 
  SetPolygonPoint(1, 1, 150,   0) 
  SetPolygonPoint(1, 2, 175,  75) 
  SetPolygonPoint(1, 3, 150, 200) 
  SetPolygonPoint(1, 4,  50, 125) 

  CreatePolygon(1, 176, 201, RGB(255,255,255)) 
  SetPolygonColor(1, 10, 10, RGB(255,255,255), RGB(255,0,0)) 

; -- Dreieck 
  SetPolygonPoint(2, 0,   0,  25) 
  SetPolygonPoint(2, 1, 150,   0) 
  SetPolygonPoint(2, 2, 175,  75) 

  CreatePolygon(2, 176, 76, RGB(255,0,255)) 

; -- Achteck 
  SetPolygonPoint(3, 0,  50,  50) 
  SetPolygonPoint(3, 1, 100,  25) 
  SetPolygonPoint(3, 2, 150,  50) 
  SetPolygonPoint(3, 3, 175, 100) 
  SetPolygonPoint(3, 4, 150, 150) 
  SetPolygonPoint(3, 5, 100, 175) 
  SetPolygonPoint(3, 6,  50, 150) 
  SetPolygonPoint(3, 7,  25, 100) 

  CreatePolygon(3, 176, 176, RGB(255,255,0)) 
  SetPolygonColor(3, 51, 51, RGB(255,255,0), RGB(255,255,0)) 
EndIf 

EndIf 

a.l = -1 
b.l = -1 

Repeat 
  While WindowEvent() : Wend 
  ExamineKeyboard() 
  ExamineMouse() 
  
  DisplayPolygon(1, 250, 200)                               ; Fünfeck 
  DisplayTransparentPolygon(2, 20, 20, 0, 0, 0)             ; Dreieck     -> Schwarz als transparente Farbe 
  DisplayTransparentPolygon(3, 20, 250, 0, 0, 0)            ; Achteck     -> Schwarz als transparente Farbe 
  DisplayTransparentPolygon(0, MouseX(), MouseY(), 0, 0, 0) ; Mousecursor -> Schwarz als transparente Farbe 
  
  
  FlipBuffers() 
  ClearScreen(RGB(0,0,0)) 
Until KeyboardPushed(#PB_Key_Escape) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger