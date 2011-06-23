; English forum: http://www.purebasic.fr/english/viewtopic.php?t=5172&highlight=
; Author: kanati (updated for PB4.00 by blbltheworm)
; Date: 18. October 2003
; OS: Windows
; Demo: No


; ------------------------------------------------ 
; Print sideways (Landscape mode) 
; Author unknown (Kanati??) - from the German forum 
; ------------------------------------------------ 


;What to print 

Printoutt.s = "Kanati is a nice guy and such a pleasure to talk to."
x.l = Len(Printoutt) 

;Standard printer information 
STDPrinterName$ = Space(260) 
GetPrivateProfileString_("WINDOWS","DEVICE","", @STDPrinterName$, 260, "Win.Ini") 
STDPrinterName$ = StringField(STDPrinterName$, 1,",") 

PrinterHandle.l = 0 
OpenPrinter_(STDPrinterName$,@PrinterHandle.l,0) 
;MessageRequester("",Str(PrinterHandle),0) 

Global Dim DevIn.DEVMODE(0) 
Global Dim DevOut.DEVMODE(0) 

DocumentProperties_(0,PrinterHandle,STDPrinterName$,DevIn(0),DevOut(0),#DM_OUT_BUFFER|#DM_IN_BUFFER) 
ClosePrinter_(PrinterHandle) 

If DevIn(0)\dmOrientation = 1 
  MessageRequester("Printer Orientation","Landscape Mode",0) 
ElseIf DevIn(0)\dmOrientation = 2 
  MessageRequester("Printer Orientation","Portrait Mode",0) 
EndIf 

DevIn(0)\dmOrientation = 2; Set to Landscape mode and print results 
PrinterDC.l = CreateDC_("WINSPOOL",STDPrinterName$,0,DevIn(0)) 

DocInf.DOCINFO 
DocInf\cbSize = SizeOf(DOCINFO) 
DocInf\lpszDocName = @"Mein Dok" 
DocInf\lpszOutput = #Null 

If StartDoc_(PrinterDC,@DocInf) > 0 
    If StartPage_(PrinterDC) > 0 
      TextOut_(PrinterDC,60,70,@Printoutt,x) 
      EndPage_(PrinterDC) 
      EndDoc_(PrinterDC) 
    EndIf 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
