; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=722
; Author: Torakas (updated for PB 4.00 by Andre)
; Date: 13. March 2005
; OS: Windows
; Demo: Yes

; 
; by Torakas, 13.03.2005 
; 

; Another routine for creating gray images from loaded pictures
; Ein weitere Routine für das Erstellen grauer Bilder von geladenen Bildern
Procedure GrayImage(Number) 
  If StartDrawing(ImageOutput(Number))
    For y1 = 1 To ImageHeight(Number)
      For x1 = 1 To ImageWidth(Number)
        Farbwert.l = Point(x1, y1)
        ; Umrechnungmethode von http://www.swissdelphicenter.ch/torry/printcode.php?id=1154
        NeuerFarbwert.l = Round(Red(Farbwert) * 0.56 + Green(Farbwert.l) * 0.33 + Blue(Farbwert) * 0.11, 0)
        Plot(x1, y1, RGB(NeuerFarbwert.l, NeuerFarbwert.l, NeuerFarbwert.l))
      Next x1
    Next y1
    StopDrawing()
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
EndProcedure 

UseJPEGImageDecoder() 
UsePNGImageDecoder() 
UseTIFFImageDecoder() 
UseTGAImageDecoder() 

;FileName$ = OpenFileRequester("SELECT IMAGE","","BMP|*.bmp",0) 
FileName$ = OpenFileRequester("SELECT IMAGE","","Image Files|*.bmp;*.jpg;*.jpeg;*.png;*.tiff;*.tga|All Files|*.*",0) 
;Filename$ = "Test.bmp" 

If FileName$ 
  If LoadImage(1,FileName$) 
    GrayImage(1) 
   
    OpenWindow(0,0,0,ImageWidth(1),ImageHeight(1),"Image",#PB_Window_ScreenCentered|#PB_Window_SystemMenu) 
    CreateGadgetList(WindowID(0)) 
    ImageGadget(0,0,0,ImageWidth(1),ImageHeight(1),ImageID(1)) 
    HideWindow(0,0):StickyWindow(0,1)  ;SetForegroundWindow_(WindowID(0)) 
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow 
  Else 
    MessageRequester("ERROR","Cant load image!",#MB_ICONERROR) 
  EndIf 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
