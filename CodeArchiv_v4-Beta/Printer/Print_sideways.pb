; German forum:
; Author: Andreas
; Date: 04. December 2002
; OS: Windows
; Demo: No


;Standardrucker-Namen ermitteln
STDPrinterName$ = Space(260)
GetPrivateProfileString_("WINDOWS","DEVICE","", @STDPrintername$, 260, "Win.Ini")
STDPrintername$ = StringField(STDPrintername$, 1,",")

PrinterHandle.l = 0
OpenPrinter_(StdPrintername$,@PrinterHandle.l,0)
;MessageRequester("",Str(PrinterHandle),0)

Dim DevIn.DEVMODE(0)
Dim DevOut.DEVMODE(0)
DocumentProperties_(0,Printerhandle,StdPrintername$,DevIn(0),DevOut(0),#DM_OUT_BUFFER|#DM_IN_BUFFER)
ClosePrinter_(PrinterHandle)

If DevIn(0)\dmOrientation = 1
  MessageRequester("aktuelle Einstellung","Hochformat",0)
ElseIf DevIn(0)\dmOrientation = 2
  MessageRequester("aktuelle Einstellung","Querformat",0)
EndIf

DevIn(0)\dmOrientation = 2;auf Querdruck setzen
PrinterDC.l = CreateDC_("WINSPOOL",StdPrintername$,0,DevIn(0))

DocInf.DOCINFO
DocInf\cbSize = SizeOf(DOCINFO)
DocInf\lpszDocName = @"Mein Dok"
DocInf\lpszOutput = #Null

If StartDoc_(PrinterDC,@DocInf) > 0
  If StartPage_(PrinterDC) > 0
    TextOut_(PrinterDC,60,70,"Querdruck",9)
    EndPage_(PrinterDC)
    EndDoc_(PrinterDC)
  EndIf
EndIf
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; Executable = A:\Examples.exe