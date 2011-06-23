; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=733&highlight=
; Author: Mischa (updated for PB4.00 by blbltheworm)
; Date: 23. April 2003
; OS: Windows
; Demo: No


;DrawTransparentImage (eine weitere Methode) 
;abgewandelte (Profan-)Vorlage (im Original von Andreas Miethe) 
;-------------------------------------------------------------- 
; 
;Zunächst sei gesagt: Nicht abschrecken lassen von diesem "Prozedur-Wurm", 
;Er ist durchaus effektiv. ;) (Mal auf die Zeit im Fenster-Titel achten!) 
; 
;Was tut die Funktion: 
;--------------------- 
;Ein Image auf ein anderes Image "transparent" zeichnen (vgl. DisplayTransparentSprite()) 
;Zusätzlich wird auf Wunsch die Größe verändert und ein Offset kann auch angegeben werden. 
; 
;Funktion: 
;--------- 
;DrawTransparentImage(TransImage,ZielImage,x,y,b,h,offx,offy,offb,offh,TransColor) 
; 
;Parameter: 
;---------- 
;TransImage   =   Image-Nummer des transparent darzustellenden Image 
; ZielImage   =   Image-Nummer des Image auf dem das transparente Image gezeichnet werden soll 
;         x   =   X-Position innerhalb des ZielImage 
;         y   =   Y-Position innerhalb des ZielImage 
;         b   =   Neue Breite 
;         h   =   Neue Höhe 
;      offx   =   X-Offset innerhalb des TransImage 
;      offy   =   Y-Offset innerhalb des TransImage 
;      offb   =   Offset-Breite innerhalb des TransImage 
;      offh   =   Offset-Höhe innerhalb des TransImage 
;TransColor   =   Transparent zu setzende Farbe in TransImage (RGB(r,g,b)) 
;                 (-1 bedeutet Pixel rechts/oben ist transparente Farbe) 


Procedure DrawTransparentImage(TransImage,ZielImage,x,y,b,h,offx,offy,offb,offh,TransColor) 
  hdc=StartDrawing(ImageOutput(TransImage)) 
    hzwischen=CreateCompatibleBitmap_(hdc,b,h) 
    HdcTemp=CreateCompatibleDC_(hdc) 
    obj=SelectObject_(HdcTemp,hzwischen) 
    HdcBack=CreateCompatibleDC_(hdc) 
    HdcObject=CreateCompatibleDC_(hdc) 
    HdcMem=CreateCompatibleDC_(hdc) 
    HdcSave=CreateCompatibleDC_(hdc) 
    BmPAndBack=CreateBitmap_(b,h,1,1,0) 
    BmPAndObject=CreateBitmap_(b,h,1,1,0) 
    BmPAndMem=CreateCompatibleBitmap_(hdc,b,h) 
    BmPSave=CreateCompatibleBitmap_(hdc,b,h) 
    SetMapMode_(HdcTemp,GetMapMode_(hdc)) 
    BmpBackOld=SelectObject_(HdcBack,BmPAndBack) 
    BmpObjectOld=SelectObject_(HdcObject,BmPAndObject) 
    BmpMemOld=SelectObject_(HdcMem,BmPAndMem) 
    BmpSaveOld=SelectObject_(HdcSave,BmPSave) 
    SetStretchBltMode_(HdcTemp,#COLORONCOLOR) 
    StretchBlt_(HdcTemp,0,0,b,h,hdc,offx,offy,offb,offh,13369376) 
    If TransColor=-1:TransColor= GetPixel_(HdcTemp,(b-1),0):EndIf 
    SetMapMode_(HdcTemp,GetMapMode_(hdc)) 
    BitBlt_(HdcSave,0,0,b,h,HdcTemp,0,0,#SRCCOPY) 
    CColor=SetBkColor_(HdcTemp,TransColor) 
    BitBlt_(HdcObject,0,0,b,h,HdcTemp,0,0,#SRCCOPY) 
    SetBkColor_(HdcTemp,RGB(255,255,255)) 
  StopDrawing() 
  target=StartDrawing(ImageOutput(ZielImage)) 
    BitBlt_(HdcBack,0,0,b,h,HdcObject,0,0,#NOTSRCCOPY) 
    BitBlt_(HdcMem,0,0,b,h,target,x,y,#SRCCOPY) 
    BitBlt_(HdcMem,0,0,b,h,HdcObject,0,0,#SRCAND) 
    BitBlt_(HdcTemp,0,0,b,h,HdcBack,0,0,#SRCAND) 
    BitBlt_(HdcMem,0,0,b,h,HdcTemp,0,0,#SRCPAINT) 
    BitBlt_(HdcTemp,0,0,b,h,HdcMem,0,0,#SRCCOPY) 
    BitBlt_(target,x,y,b,h,HdcTemp,0,0,#SRCCOPY) 
  StopDrawing() 
  DeleteObject_(obj):DeleteObject_(BmpBackOld) 
  DeleteObject_(BmpObjectOld):DeleteObject_(BmpMemOld) 
  DeleteObject_(BmpSaveOld):DeleteDC_(HdcMem) 
  DeleteDC_(HdcBack):DeleteDC_(HdcObject) 
  DeleteDC_(HdcSave):DeleteDC_(HdcTemp) 
  DeleteObject_(hzwischen):DeleteObject_(BmPAndBack) 
  DeleteObject_(BmPAndObject):DeleteObject_(BmPAndMem) 
  DeleteObject_(BmPSave) 
EndProcedure 



;Beispiel: 
;--------- 

LoadImage(0, "..\Gfx\PB2.bmp")       ;<-Pfad/Name anpassen 
ResizeImage(0,400,400) 

LoadImage(1, "..\Gfx\Geebee2.bmp") ;<-Pfad/Name anpassen 

timer.l = GetTickCount_() 
DrawTransparentImage(1,0,100,100,200,200,0,0,ImageWidth(1),ImageHeight(1),-1) 

text.s="Bild generiert in "+Str(GetTickCount_()-timer)+ "msek" 
OpenWindow(0,0,0,400,400,text,#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
CreateGadgetList(WindowID(0)) 
ImageGadget(0, 0, 0, 400, 400, ImageID(0)) 
Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
