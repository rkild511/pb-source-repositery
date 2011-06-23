; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=718&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 22. April 2003
; OS: Windows
; Demo: No


Declare LoadTransparentImage(Number,FileName$,TransColor,NewColor) 

;Lädt ein Bild mit einer transparenten Hintergrundfarbe, 
;so dass man es quasi transparent in einem ImageGadget() 
;darstellen kann. 

;Erklärung/Anwendung: 
;--------------------
; Anwendung 1: 
  ; lade Bild 1 aus der Datei "name.bmp", 
  ; nimm die Farbe des ersten Pixels des 
  ; Bildes (links,oben) als Transparenz-Farbe 
  ; und ersetze diese mit der Farbe die PB 
  ; auch für Gadgets als Hintergrund nimmt: 

;image1 = LoadTransparentImage(1,"name.bmp",-1,-1) 


; Anwendung 2: 
  ; lade Bild 2 aus der Datei "name.bmp", 
  ; nimm die Farbe des ersten Pixels des 
  ; Bildes (links,oben) als Transparenz-Farbe 
  ; und ersetze diese mit der Farbe die mit 
  ; RGB(rot,grün,blau) bestimmt wurde (gelb): 

;image2 = LoadTransparentImage(2,"name.bmp",-1,RGB($FF,$FF,$00)) 


; Anwendung 3: 
  ; lade Bild 3 aus der Datei "name.bmp", 
  ; nimm die Farbe RGB($00,$FF,$00), also grün 
  ; als Transparenz-Farbe  und ersetze diese 
  ; mit der Farbe die PB auch für Gadgets als 
  ; Hintergrund nimmt: 

;image3 = LoadTransparentImage(3,"name.bmp",RGB($00,$FF,$00),-1) 


; Anwendung 4: 
  ; lade Bild 4 aus der Datei "name.bmp", 
  ; nimm die Farbe RGB($00,$00,$FF), also blau 
  ; als Transparenz-Farbe  und ersetze diese 
  ; mit der Farbe RGB($00,$00,$00), also schwarz: 

;image4 = LoadTransparentImage(4,"name.bmp",RGB($00,$00,$FF),RGB($00,$00,$00)) 



; LoadTransparentImage(Nummer,DateiName$,TransparenzFarbe,NeueFarbe)
; ------------------------------------------------------------------
; by Danilo, 22.04.2003 - german forum 
; 
Procedure LoadTransparentImage(Number,FileName$,TransColor,NewColor) 
  ;> 
  ;> Number     = ImageNumber 
  ;> FileName$  = File Name 
  ;> TransColor = RGB: Transparent Color,        -1 = First Color in Picture 
  ;> NewColor   = RGB: New Color for TransColor, -1 = System Window Background 
  ;> 
  Structure _LTI_BITMAPINFO 
    bmiHeader.BITMAPINFOHEADER 
    bmiColors.RGBQUAD[1] 
  EndStructure 

  Structure _LTI_LONG 
   l.l 
  EndStructure 

  hBmp = LoadImage(Number,FileName$) 
  If hBmp 
    hDC  = StartDrawing(ImageOutput(Number)) 
    If hDC 
      ImageWidth  = ImageWidth(Number) : ImageHeight = ImageHeight(Number) 
      mem = GlobalAlloc_(#GMEM_FIXED|#GMEM_ZEROINIT,ImageWidth*ImageHeight*4) 
      If mem 
        bmi._LTI_BITMAPINFO 
        bmi\bmiHeader\biSize   = SizeOf(BITMAPINFOHEADER) 
        bmi\bmiHeader\biWidth  = ImageWidth 
        bmi\bmiHeader\biHeight = ImageHeight 
        bmi\bmiHeader\biPlanes = 1 
        bmi\bmiHeader\biBitCount = 32 
        bmi\bmiHeader\biCompression = #BI_RGB 
        If GetDIBits_(hDC,hBmp,0,ImageHeight(Number),mem,bmi,#DIB_RGB_COLORS) <> 0 
          If TransColor = -1 
            *pixels._LTI_LONG = mem+((ImageHeight-1)*ImageWidth*4) 
            TransColor = *pixels\l 
          Else 
            TransColor = RGB(Blue(TransColor),Green(TransColor),Red(TransColor)) 
          EndIf 

          If NewColor = -1 
            NewColor = GetSysColor_(#COLOR_BTNFACE) ; #COLOR_WINDOW 
          EndIf 
          NewColor = RGB(Blue(NewColor),Green(NewColor),Red(NewColor)) 

          *pixels._LTI_LONG = mem 
          For a = 1 To ImageWidth*ImageHeight 
            If *pixels\l = TransColor 
              *pixels\l = NewColor 
            EndIf 
            *pixels + 4 
          Next a 

          If SetDIBits_(hDC,hBmp,0,ImageHeight(Number),mem,bmi,#DIB_RGB_COLORS) <> 0 
            Result = hBmp 
          EndIf 
        EndIf 
        GlobalFree_(mem) 
      EndIf 
    EndIf 
    StopDrawing() 
  EndIf 
  ProcedureReturn Result 
EndProcedure 

image1 = LoadTransparentImage(1,"..\Gfx\Map.bmp",-1,-1) 
If image1 
  OpenWindow(0,0,0,ImageWidth(1),ImageHeight(1),"Image",#PB_Window_ScreenCentered|#PB_Window_SystemMenu) 
    CreateGadgetList(WindowID(0)) 
    ImageGadget(0,0,0,ImageWidth(1),ImageHeight(1),image1) 
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow 
Else 
  MessageRequester("ERROR","Cant load image!",#MB_ICONERROR) 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
