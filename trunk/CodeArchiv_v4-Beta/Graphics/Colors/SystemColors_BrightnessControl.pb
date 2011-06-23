; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2126&highlight= 
; Author: sverson (updated for PB 4.00 by Andre + Helle) 
; Date: 19. February 2005 
; OS: Windows 
; Demo: No 


; Brightness control for system colors 
; System- (oder auch andere Farben) noch heller oder dunkler machen 

;/ RGB farbhelligkeit korrigieren  PB 3.92 / ASM 
;/ Eine schnelle ASM-Routine zur "on the fly" Korrektur der RGB Farbhelligkeit 
;/ BrightnessRGB(RGB_Color.l, Delta.w) Delta -255...255 - andere Werte sind sinnlos 
;/ 02/2005 sverson 

Enumeration 
  #DemoWindow 
  #DemoImage 
  #DemoImageGeaget 
  #ColorTrackBar 
  #BrightnesTrackBar 
EndEnumeration 

Structure SYSCOLORS 
  ColorConst.s 
  ColorNumber.l 
EndStructure 
Global NewList ColorList.SYSCOLORS() 

Procedure InitColorList() ;/ Systemfarben 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_3DDKSHADOW" : ColorList()\ColorNumber = GetSysColor_(#COLOR_3DDKSHADOW) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_3DFACE = #COLOR_BTNFACE" : ColorList()\ColorNumber = GetSysColor_(#COLOR_3DFACE) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_3DHILIGHT = #COLOR_BTNHIGHLIGHT" : ColorList()\ColorNumber = GetSysColor_(#COLOR_3DHILIGHT) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_3DHIGHLIGHT = #COLOR_BTNHIGHLIGHT" : ColorList()\ColorNumber = GetSysColor_(#COLOR_3DHIGHLIGHT) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_3DLIGHT" : ColorList()\ColorNumber = GetSysColor_(#COLOR_3DLIGHT) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_3DSHADOW = #COLOR_BTNSHADOW" : ColorList()\ColorNumber = GetSysColor_(#COLOR_3DSHADOW) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_ACTIVEBORDER" : ColorList()\ColorNumber = GetSysColor_(#COLOR_ACTIVEBORDER) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_ACTIVECAPTION" : ColorList()\ColorNumber = GetSysColor_(#COLOR_ACTIVECAPTION) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_APPWORKSPACE" : ColorList()\ColorNumber = GetSysColor_(#COLOR_APPWORKSPACE) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_BACKGROUND" : ColorList()\ColorNumber = GetSysColor_(#COLOR_BACKGROUND) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_BTNFACE" : ColorList()\ColorNumber = GetSysColor_(#COLOR_BTNFACE) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_BTNHIGHLIGHT" : ColorList()\ColorNumber = GetSysColor_(#COLOR_BTNHIGHLIGHT) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_BTNHILIGHT = #COLOR_BTNHIGHLIGHT" : ColorList()\ColorNumber = GetSysColor_(#COLOR_BTNHILIGHT) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_BTNSHADOW" : ColorList()\ColorNumber = GetSysColor_(#COLOR_BTNSHADOW) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_BTNTEXT" : ColorList()\ColorNumber = GetSysColor_(#COLOR_BTNTEXT) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_CAPTIONTEXT" : ColorList()\ColorNumber = GetSysColor_(#COLOR_CAPTIONTEXT) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_DESKTOP = #COLOR_BACKGROUND" : ColorList()\ColorNumber = GetSysColor_(#COLOR_DESKTOP) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_GRAYTEXT" : ColorList()\ColorNumber = GetSysColor_(#COLOR_GRAYTEXT) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_HIGHLIGHT" : ColorList()\ColorNumber = GetSysColor_(#COLOR_HIGHLIGHT) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_HIGHLIGHTTEXT" : ColorList()\ColorNumber = GetSysColor_(#COLOR_HIGHLIGHTTEXT) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_INACTIVEBORDER" : ColorList()\ColorNumber = GetSysColor_(#COLOR_INACTIVEBORDER) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_INACTIVECAPTION" : ColorList()\ColorNumber = GetSysColor_(#COLOR_INACTIVECAPTION) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_INACTIVECAPTIONTEXT" : ColorList()\ColorNumber = GetSysColor_(#COLOR_INACTIVECAPTIONTEXT) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_INFOBK" : ColorList()\ColorNumber = GetSysColor_(#COLOR_INFOBK) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_INFOTEXT" : ColorList()\ColorNumber = GetSysColor_(#COLOR_INFOTEXT) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_MENU" : ColorList()\ColorNumber = GetSysColor_(#COLOR_MENU) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_MENUTEXT" : ColorList()\ColorNumber = GetSysColor_(#COLOR_MENUTEXT) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_SCROLLBAR" : ColorList()\ColorNumber = GetSysColor_(#COLOR_SCROLLBAR) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_WINDOW" : ColorList()\ColorNumber = GetSysColor_(#COLOR_WINDOW) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_WINDOWFRAME" : ColorList()\ColorNumber = GetSysColor_(#COLOR_WINDOWFRAME) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLOR_WINDOWTEXT" : ColorList()\ColorNumber = GetSysColor_(#COLOR_WINDOWTEXT) 
  AddElement(ColorList()) : ColorList()\ColorConst = "#COLORONCOLOR" : ColorList()\ColorNumber = GetSysColor_(#COLORONCOLOR) 
  ;/ + 3 Demofarben 
  AddElement(ColorList()) : ColorList()\ColorConst = "Demo Blue" : ColorList()\ColorNumber = RGB(0,0,128) 
  AddElement(ColorList()) : ColorList()\ColorConst = "Demo Green" : ColorList()\ColorNumber = RGB(0,128,0) 
  AddElement(ColorList()) : ColorList()\ColorConst = "Demo Red" : ColorList()\ColorNumber = RGB(128,0,0) 
EndProcedure 

Procedure BrightnessRGB(RGB_Color.l, Delta.w);- RGB farbhelligkeit korrigieren 
  !XOR Edx, Edx         ;/ EDX-Register löschen 
  !XOR Ebx, Ebx         ;/ EBX-Register löschen 
  !XOR Ecx, Ecx         ;/ ECX-Register löschen 
  !MOV BX, Word [p.v_Delta] ;/ Delta-Wert in BX einlesen 
  !MOV Eax, dWord [p.v_RGB_Color] ;/ RGB-Farbwert in EAX einlesen 
  !MOV DL, AL           ;/ R-Wert nach DL 
  !CALL .adddelta       ;/--> DELTA ZU DL (R) ADDIEREN ++ 
  !MOV CL, DL           ;/ R-Wert in CL zwischenspeichern 
  !MOV DL, AH           ;/ G-Wert nach DL 
  !CALL .adddelta       ;/--> DELTA ZU DL (G) ADDIEREN ++ 
  !MOV CH, DL           ;/ G-Wert in CH zwischenspeichern 
  !BSWAP Eax            ;/ B-Wert via BYTESWAP in AH zugänglich machen 
  !MOV DL, AH           ;/ G-Wert nach DL 
  !CALL .adddelta       ;/--> DELTA ZU DL (B) ADDIEREN ++ 
  !MOV AH, DL           ;/ G-Wert nach AH zurückschreiben 
  !BSWAP Eax            ;/ G-Wert via BYTESWAP wieder an richtige Position bringen 
  !MOV AX, CX           ;/ R und G Wert aus Zwischenspeicher CX wieder in AX schreiben 
  !JMP .ready           ;/==> FARBKORREKTUR BEENDET ++ 
  !.adddelta:           ;/ ++ DELTA ZU DL ADDIEREN ++ 
  !ADD DX, BX           ;/ Delta aus BX zu DX addieren 
  !BT DX, 15            ;/ auf Negativwert testen 
  !JC .negativ          ;/==> NEUER WERT KLEINER NULL ++ 
  !CMP DX, $FF          ;/ auf Maximalwert testen 
  !JBE .inrange         ;/==> NEUER ZWISCHEN 0 UND 255 ++ 
  !.bigger:             ;/ ++ NEUER WERT GRÖSSER 255 ++ 
  !MOV DX, $00FF        ;/ DX auf 255 begrenzen 
  !JMP .inrange         ;/==> WERT IN DEN GRENZEN ++ 
  !.negativ:            ;/ ++ NEUER WERT KLEINER NULL ++ 
  !XOR Edx, Edx         ;/ DX auf 0 begrenzen 
  !.inrange:            ;/ ++ WERT IN DEN GRENZEN ++ 
  !RET                  ;/ Rücksprung aus Makro 
  !.ready:              ;/ ++ FARBKORREKTUR BEENDET ++ 
  ProcedureReturn 
EndProcedure 

Procedure UpdateImage(ITitle$,IColor.l,iDelta.w);/ Image aktualisieren 
  StartDrawing(ImageOutput(#DemoImage)) 
  newColor = BrightnessRGB(IColor,iDelta) 
  Box(0,0,280,200,IColor) 
  Box(78,48,124,104,RGB(255,255,255)) 
  Box(79,49,122,102,RGB(0,0,0)) 
  Box(80,50,120,100,newColor) 
  DrawingMode(1) 
  FrontColor(RGB(255,255,255)) 
  DrawText(10, 10, ITitle$) 
  DrawText(90, 65, "R"+RSet(Str(Red(newColor)),3,"0")+"G"+RSet(Str(Green(newColor)),3,"0")+"b"+RSet(Str(Blue((newColor))),3,"0")) 
  DrawText(90, 80, "delta: "+Str(iDelta)) 
  FrontColor(RGB(0,0,0)) ; print the text to white ! 
  DrawText(90, 100, "delta: "+Str(iDelta)) 
  DrawText(90, 115, "R"+RSet(Str(Red(newColor)),3,"0")+"G"+RSet(Str(Green(newColor)),3,"0")+"b"+RSet(Str(Blue((newColor))),3,"0")) 
  DrawText(10, 175, ITitle$) 
  StopDrawing() 
EndProcedure 

If OpenWindow(#DemoWindow,0,0,320,240,"Helligkeitsregler",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(#DemoWindow)) 
  If CreateImage(#DemoImage, 280, 200) 
    InitColorList() 
    LastElement(ColorList()) 
    UpdateImage(ColorList()\ColorConst,ColorList()\ColorNumber,0) 
    ImageGadget(#DemoImageGeaget,5,5,280,200,ImageID(#DemoImage),#PB_Image_Border) 
    TrackBarGadget(#BrightnesTrackBar, 5, 215, 280, 20,0,510) 
    SetGadgetState(#BrightnesTrackBar,255) 
    TrackBarGadget(#ColorTrackBar, 295, 5, 20, 200,1,CountList(ColorList()),#PB_TrackBar_Vertical) 
    SetGadgetState(#ColorTrackBar,CountList(ColorList())) 
    Repeat : 
      WinEvent = WaitWindowEvent() 
      Select WinEvent 
        Case #PB_Event_Gadget 
          SelectElement(ColorList(),GetGadgetState(#ColorTrackBar)-1) 
          UpdateImage(ColorList()\ColorConst,ColorList()\ColorNumber,GetGadgetState(#BrightnesTrackBar)-255) 
          SetGadgetState(#DemoImageGeaget,ImageID(#DemoImage)) 
      EndSelect 
    Until WinEvent = #PB_Event_CloseWindow 
  EndIf 
EndIf 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP