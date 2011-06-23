; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=860&highlight=
; Author: Andreas (updated for PB4.00 by blbltheworm + Andre)
; Date: 04. May 2003
; OS: Windows
; Demo: No

Global PrinterDC,PrintersWidth.l, PrintersHeight.l 

Procedure  _Drawtext(x.l,y.l,w.l,h.l,s.s,LCR,Color.l,Font.s,FontHeight.l,FontPar) 
  ;###################################################### 
  ;Textausgabe 
  ;###################################################### 
  SetBkMode_(PrinterDC,#TRANSPARENT) 
  SetTextColor_(PrinterDC,Color) 
  FontID = LoadFont(0,Font,FontHeight,FontPar) 
  SelectObject_(PrinterDC,FontID(0)) 
  r.RECT 
  r\left = x 
  r\top = y 
  r\right = x + w 
  r\bottom = y + h 
  Printertext.s = s 
  DrawText_(PrinterDC,Printertext,Len(Printertext),r, LCR) 
  FreeFont(0) 
EndProcedure 

Procedure  _PrintBMP(Image.s,x.l,y.l) 
  ;###################################################### 
  ;ein Bild drucken 
  ;###################################################### 
  bm.BITMAP  
  SetBkMode_(PrinterDC,#OPAQUE) 
  Bild.l = LoadImage_(0,Image,0,0,0,$2050) 
  MemDC.l = CreateCompatibleDC_(PrinterDC) 
  SelectObject_(MemDC,Bild) 
  GetObject_(Bild,24,bm) 
  If  (w<1) Or (h<1) 
    StretchBlt_(PrinterDC,x,y,bm\bmWidth,bm\bmHeight,MemDC,0,0,bm\bmWidth,bm\bmHeight,$CC0020) 
  Else 
    StretchBlt_(PrinterDC,x,y,w,h,MemDC,0,0,bm\bmWidth,bm\bmHeight,$CC0020) 
  EndIf 
  DeleteDC_(MemDC) 
EndProcedure 


Structure Printers 
  Device.s 
  Driver.s 
  Port.s 
EndStructure 
Global NewList Printers.Printers() 

Procedure FillPrinterlist() 
  ;###################################################### 
  ;Druckerliste erstellen 
  ;###################################################### 
    *Buffer    = AllocateMemory(4096) 
    Buffersize = 4096 
    Buff$ = Space(1024) 
    GetProfileString_("devices",0,"error",*Buffer,Buffersize) 
    a$ = PeekS(*Buffer) 
    Length = Len(a$) 
    For I = 1 To 150 
      If a$ = "":I = 150:EndIf 
      If a$ <> "" 
        AddElement(Printers()) 
        Printers()\Device = a$ 
        GetPrivateProfileString_("devices",a$,"error",Buff$,1024,"Win.Ini") 
        ;liest alle Devices ein 
        ;jedes Device ist mit einem Nullbyte abgeschlossen 
        ;daher das etwas umstaendlich Auslesen 
        Printers()\Driver = StringField(Buff$,1,",") 
        Printers()\Port   = StringField(Buff$,2,",") 
      EndIf 
      a$ = PeekS(*Buffer+Length + 1) 
      Length = Length + Len(a$) + 1 
      a$ = PeekS(*Buffer+Length + 1) 
    Next 
    FreeMemory(*Buffer) 
EndProcedure 


FillPrinterlist() 

;##################### 
;alle Printer ausgeben 
;##################### 
ResetList(Printers()) 
For I = 0 To CountList(Printers())-1 
  NextElement(Printers()) 
  Debug Printers()\Device 
Next I 
Debug CountList(Printers()) 
;##################### 



;################################################################ 
;den dritten Treiber aus der Liste zum Ausdrucken wählen 
;hier wird davon ausgegangen, dass der Drucker auch vorhanden ist 
;################################################################ 
SelectElement(Printers(),2) 

;####################################################### 
;Printer-Device-Context anlegen 
;####################################################### 
PrinterDC.l = CreateDC_("WINSPOOL",Printers()\Device,0,0) 
PrintersWidth=GetDeviceCaps_(PrinterDC,8);Blattbreite in Pixel 
PrintersHeight=GetDeviceCaps_(PrinterDC,10);Blatthöhe in Pixel 

;####################################################### 
;Ausdruck starten 
;####################################################### 
Procedure  StartPrint(Dokname.s) 
    mDI.DOCINFO 
    mDI\cbSize = 12 
    mDI\lpszDocName = @Name 
    mDI\lpszOutput = 0 
    StartDoc_(PrinterDC,mDI) 
EndProcedure 



StartPrint("Ausdruck");startet den Ausdruck 
StartPage_(PrinterDC);neue Seite anlegen 
_PrintBMP("C:\Windows\setup.bmp",10,10) 
EndPage_(PrinterDC);Seite abschliessen 
StartPage_(PrinterDC);neue Seite anlegen 
_Drawtext(0,0,PrintersWidth,PrintersHeight,"eine neue Seite",#DT_CENTER,RGB(0,0,255),"Arial",48,#PB_Font_Underline|#PB_Font_Italic) 
EndPage_(PrinterDC);Seite abschliessen 
EndDoc_(PrinterDC);Ausdruckl beenden 
DeleteDC_(PrinterDC);Device-Context freigeben

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -