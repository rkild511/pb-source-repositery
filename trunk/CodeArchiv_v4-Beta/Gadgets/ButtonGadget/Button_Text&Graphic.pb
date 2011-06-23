; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1556&start=10
; Author: Falko (updated for PB 4.00 by Andre)
; Date: 09. January 2004
; OS: Windows
; Demo: No


;Draw Image und Text im Button 
;written by Falko 2005 
; 
;http://www.iconarchive.com/icon/art/gortsiconsvol1_by_gort/Rojo.ico 
; 
;TextStructure 
Trect.RECT 
Trect\left   =38 ;X-linke obere Ecke 
Trect\top    =12 ;Y-linke obere Ecke 
Trect\right  =80 ;X-rechte untere Ecke 
Trect\bottom =25 ;Y-rechte untere Ecke 

If OpenWindow(0,100,100,400,200,"Button",#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0)) 
 Picture1 = LoadImage( 1,"..\..\Graphics\Gfx\Rojo.ico") ; Hier ein Grafik.ico 32x32 einfügen 
 dc=ButtonGadget(2, 10,10,100,40,"") 
 HDC=GetDC_(dc) 
 SetBkMode_(HDC,#TRANSPARENT) ; Hintergrund Transparent 
 SetTextColor_(HDC,$FF0000)   ; Textfarbe 
 Repeat 
    DrawText_(HDC,"FALKO",-1,Trect,#DT_SINGLELINE) ;Text zeichnen 
    DrawIcon_(HDC,3,3,Picture1)                               ;Icon zeichnen 
 Until WaitWindowEvent()=#PB_Event_CloseWindow 
 CloseWindow(0) 
EndIf
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -