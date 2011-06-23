; English forum:
; Author: Rui Carvalho (updated for PB4.00 by blbltheworm)
; Date: 01. March 2003
; OS: Windows
; Demo: Yes

;***************************
;Super Printer - DPI indepent print
;by Rui Carvalho - 2003
;
;Part of GIA - Lift Management Software
;Freeware
;***************************

;rui-carvalho@bigfoot.com

Declare ycm(x.f)
Declare xcm(x.f)


;
;Original printer code by Fred
;

If PrintRequester()

  If StartPrinting("PureBasic Test")
    LoadFont(0, "Arial", ycm(0.4))
    LoadFont(1, "Arial", ycm(1))
  
    If StartDrawing(PrinterOutput())
  
      DrawingFont(FontID(0));4mm font size
      
      ; locate at 15cm by 5,5cm
      DrawText(xcm(15), xcm(5.5),"PureBasic Printer Test")
      
      DrawingFont(FontID(1)); 1 cm font size
      
      DrawText(xcm(10), ycm(20),"PureBasic Printer Test 2")
      
      If LoadImage(0, "..\Graphics\Gfx\PB.bmp"); The logo bitmap is bigger
        ResizeImage(0, xcm(6), ycm(2)) ; resize image for 6cm by 2cm
        DrawImage(ImageID(0), xcm(1), ycm(1)); draw image at 1cm by 1cm
      Else
        MessageRequester("", "2", 0)
      EndIf
      
      FrontColor(RGB(100,100,100))
      Box(xcm(2), ycm(6), xcm(6), ycm(10)); draw a 4cm by 4cm square
      
      StopDrawing()
    EndIf
  
    StopPrinting()
  EndIf
EndIf



;**** the trick !!!! ****

Procedure xcm(x.f)

result = x * (PrinterPageWidth()/21) ; 21cm A4
ProcedureReturn result

EndProcedure


Procedure ycm(x.f)

result = x * (PrinterPageWidth()/29.7) ; 29,7cm A4
ProcedureReturn result

EndProcedure


;Tested with fineprintpdf in multiple DPI's
;and on Xerox DC440 laser printer


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -