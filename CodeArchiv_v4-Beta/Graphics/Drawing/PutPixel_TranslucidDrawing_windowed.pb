; German forum: http://www.purebasic.fr/german/viewtopic.php?t=788&highlight=
; Author: GPI (based on original code of Kekskiller, updated for PB 4.00 by Andre)
; Date: 07. November 2004
; OS: Windows
; Demo: Yes

;Putpixel - plots a translucid pixel  
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
;Ich weiss nicht genau, wie PutPixel  
;in höheren Farbtiefen läuft, müsste  
;aber im Prinzip relativ fehlerfrei  
;laufen. Benutzung auf eigene Gefahr ;] 
;                    
;best viewed in jaPBe          

Global mx,my,z 


Declare PutPixel(x,y, ired,igre,iblu, t) 

#ScreenWidth=640 
#ScreenHeight=480 

Dim rect(20,4) 
For z=1 To 20 
  rect(z,0)=Random(#ScreenWidth-50) 
  rect(z,1)=Random(#ScreenHeight-50) 
  rect(z,2)=Random(100)+155 
  rect(z,3)=Random(100)+155 
  rect(z,4)=Random(100)+155 
Next 

InitSprite() 
OpenWindow(0,0,0,700,500,"Test",#PB_Window_SystemMenu) 
OpenWindowedScreen(WindowID(0),0,0,640,480, #False,0,0) 
InitMouse() 
  
Repeat 
  ExamineMouse() 
  ClearScreen(RGB(255,255,255))
  StartDrawing(ScreenOutput()) 
  DrawingMode(0) 
  For z=1 To 20 
    Box(rect(z,0),rect(z,1), 50,50, RGB(rect(z,2),rect(z,3),rect(z,4))) 
  Next 
  mx=MouseX() 
  my=MouseY() 
  DrawingMode(4) 
  Box(mx-1,my-1, 42,42, 0) 
  For zx=0 To 39 
    For zy=0 To 39 
      DrawText(0, 0,  Str(mx)+" "+Str(my)+"|") 
      PutPixel(mx+zx,my+zy, 100,255,155, 50) 
      ;Plot(mx+zx,my+zy,$7F7F7F) 
    Next 
  Next 
  StopDrawing() 
  FlipBuffers() 
Until MouseButton(1) 

End

Procedure PutPixel(x,y, ired,igre,iblu, t) 
  If x>=0 And y>=0 And x<#ScreenWidth And y<#ScreenHeight 
    ocol = Point(x,y) 
    ored = Red(ocol) 
    ogre = Green(ocol) 
    oblu = Blue(ocol) 
    
    fred= ored- (ored-ired)*t/100 
    fgre= ogre- (ogre-igre)*t/100 
    fblu= oblu- (oblu-iblu)*t/100 
      
    FrontColor(RGB(fred,fgre,fblu))
    Plot(x, y);, RGB(fred,fgre,fblu)) 
  EndIf 
EndProcedure
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -