; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6002&highlight=
; Author: gnozal (updated for PB4.00 by blbltheworm + Andre)
; Date: 29. April 2003
; OS: Windows
; Demo: No

; --------------------------- 
; LIST ALL INSTALLED PRINTERS 
;  AND SET DEFAULT PRINTER 
; --------------------------- 
; 
; Adapted from VB source ... 
; http://www.freevbcode.com/ShowCode.Asp?ID=641 
; 
; Printer list structure & list 
Structure Printers 
  P.s 
EndStructure 
Global NewList Printers.Printers() 
; ------------ 
; Get installed printers 
Procedure GetPrinterList() 
  
  ClearList(Printers()) 
  
  Buffersize.l  = 8102 
  *Buffer       = AllocateMemory(Buffersize) 
  TempPrinter.s = Space(1024) 
  
  If GetProfileString_("devices",0,"",*Buffer,Buffersize) 
    TempString.s = PeekS(*Buffer) 
    Length = Len(TempString) 
    While TempString <> "" 
     GetPrivateProfileString_("devices",TempString,"",TempPrinter,1024,"Win.Ini") 
     AddElement(Printers()) 
     Printers()\P = TempString+","+StringField(TempPrinter,1,",")+","+StringField(TempPrinter,2,",") 
     TempString = PeekS(*Buffer+Length + 1) 
     Length = Length + Len(TempString) + 1 
     TempString = PeekS(*Buffer+Length + 1) 
    Wend 
  Else 
    MessageRequester("Error","No printer installed",64) 
  EndIf 
  
  FreeMemory(*Buffer) 

EndProcedure 
; ------------ 
; Set default printer (should work for all windows versions) 
Procedure Setdefaultprinter_(DeviceLine.s) 
  
  ;DeviceLine=PrinterName,DriverName,PrinterPort 
  ;Store the new printer information in the 
  ;[WINDOWS] section of the WIN.INI file for 
  ;the DEVICE= item 
  WriteProfileString_("windows", "Device", DeviceLine) 
    
  ;Cause all applications To reload the INI file 
  SendMessage_(#HWND_BROADCAST, #WM_WININICHANGE, 0, "windows") 

EndProcedure 
; ------------ 
; MAIN 

; Get installed printers 
GetPrinterList() 
; List the printers 
ResetList(Printers()) 
Debug "Printers list :" 
While NextElement(Printers()) 
  Debug Printers()\P  
Wend 
Debug "---------------" 
Debug "Make n°5 as default Printer" 
SelectElement(Printers(), 4) 
Debug "This is "+Printers()\P 
Setdefaultprinter_(Printers()\P) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -