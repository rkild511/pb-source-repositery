; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3273&highlight=
; Author: Maddin (updated for PB4.00 by blbltheworm)
; Date: 29. December 2003
; OS: Windows
; Demo: No


; Follow the physical characteristics of the printer...

; Beachtung der physikalischen Eigenschaften eines Druckers:
; Ich habe da mal kürzlich was gebaut. 
; Es gibt da eine Struktur, die physikalische Daten aufnimmt 
; und eine Druckfunktion für zu druckende Elemente. 

; Hier wird die Auflösung in x- und y- Richtung getrennt 
; behandelt, da die ja selten gleich sind. Außerdem werden 
; die pysikalischen Ränder berücksichtigt. 

; Die Berechnungen geschehen in mm, was ich persönlich 
; wesentlich praktischer finde. 


Enumeration (1) 
    #Image 
    #Box 
    #Circle 
    #Text 
    #Ellipse 
    #Line 
EndEnumeration 

Structure PrinterPys 
    pgx.l   ;physik. Breite gesamt deviceunits 
    pgy.l   ;physik. Höhe 
    width.f ;druckbarer Bereich in mm 
    height.f 
    dpmmx.f ;horz. Auflösung dots per mm 
    dpmmy.f ;vert. Auflösung dots per mm 
    nulx.f  ;druckbar links in mm 
    nuly.f  ;druckbar oben 
    endx.f  ;druckbar recht. Rand in mm 
    endy.f  ;druckbar unter. Rand 
EndStructure 

Structure PrinterPage 
    Printer.PrinterPys 
    ;alle in mm 
    rnulx.l ;Nullpos mit Rand links 
    rnuly.l ;Nullpos mit Rand links 
    rpax.l  ;mit Rand Breite 
    rpay.l  ;mit Rand Höhe 
EndStructure 


Global Page.PrinterPage 


Procedure.b Init_Printer(job.s) 
    
    hDC.l 
    
    HorRes.l 
    VerRes.l 
    pysLeft.l 
    pysTop.l 
    
    If PrintRequester() = 0 
        ProcedureReturn #False 
    EndIf 
    
    StartPrinting(job) 
    
    
    
    hDC = StartDrawing(PrinterOutput()) 
      
      
    ;linke obere Ecke vom Blattrand 
    pysLeft = GetDeviceCaps_(hDC,#PHYSICALOFFSETX) 
    pysTop = GetDeviceCaps_(hDC,#PHYSICALOFFSETY) 
    
    
    ;device units ganze Breite 
    Page\Printer\pgx = GetDeviceCaps_(hDC,#PHYSICALWIDTH) 
    Page\Printer\pgy = GetDeviceCaps_(hDC,#PHYSICALHEIGHT) 
    
    ;Auflösung in dpi 
    HorRes = GetDeviceCaps_(hDC,#HORZRES) 
    VerRes = GetDeviceCaps_(hDC,#VERTRES) 
      
    ;Druckbarer Bereich in mm 
    Page\Printer\width = GetDeviceCaps_(hDC,#HORZSIZE) 
    Page\Printer\height = GetDeviceCaps_(hDC,#VERTSIZE) 
    
    ;Auflösung in mm 
    Page\Printer\dpmmx = HorRes / Page\Printer\width 
    Page\Printer\dpmmy = VerRes / Page\Printer\height 
    
    ;pysk Rand berechnen und in mm umrechnen 
    Page\Printer\endx = Page\Printer\pgx - HorRes - pysLeft 
    Page\Printer\endy = Page\Printer\pgy - VerRes - pysTop 
    
    Page\Printer\nulx = pysLeft / Page\Printer\dpmmx 
    Page\Printer\nuly = pysTop / Page\Printer\dpmmy 
    Page\Printer\endx / Page\Printer\dpmmx 
    Page\Printer\endy / Page\Printer\dpmmy 
    ProcedureReturn #True 

EndProcedure 

;mm-Breite aus Auflösung 
Procedure.l xmm(x.f) 
    ProcedureReturn = x * Page\Printer\dpmmx 
EndProcedure 

;mm-Länge aus Auflösung 
Procedure.l ymm(y.f) 
    ProcedureReturn = y * Page\Printer\dpmmy 
EndProcedure    

;Rechnet die Größenangabe des Font aus 
;Faktor 3.8 durch Vergleich mit anderen Ausdrucken 
;aus Windows heraus ermittelt 
Procedure.l Fontpointsize(p) 
    ProcedureReturn Int(p * Page\Printer\dpmmy / 3.8) 
EndProcedure 

Procedure Deinit_printer() 
    StopDrawing(): StopPrinting() 
EndProcedure 


Procedure Drucke_Element(Obj.l,ObjID.l,xa.f,ya.f,xe.f,ye.f,width.f,col.l,s.s) 
    
    n1.f 
    n2.f 
    
    If Abs(width) > 0 
        n1 = 0 
        n2 = Abs(width) * Page\Printer\dpmmx 
    Else 
        n1 = 0 
        n2 = 1 
    EndIf 
    
    If col <> 0 
        FrontColor(RGB(Red(col),Green(col),Blue(col))) 
    EndIf 
    
    ;Koordinaten / Größen in mm * Pixel = Gesamtpixel umrechnen 
    xa = xmm(xa) 
    xe = xmm(xe) ;Auch Radien von Kreis und Ellipse 
    ya = xmm(ya) 
    ye = xmm(ye) ;             " 
    
    
    Select Obj 
        Case #Image 
            DrawImage(ImageID(ObjID),xa,ya,xe,ye) 
        Case #Box 
            While (n1 < n2):Box(xa+n1,ya+n1,xe-n1-n1,ye-n1-n1):n1 + 1:Wend 
        Case #Circle 
            While (n1 < n2):Circle(xa,ya,xe-n1):n1 + 1:Wend 
        Case #Text 
            DrawText(xa,ya,s) 
        Case #Ellipse 
            While (n1 < n2):Ellipse(xa,ya,xe-n1,ye-n1):n1 + 1:Wend 
        Case #Line 
            While (n1 < n2) 
                If width > 0 ;Dicke Größer 0 -> in x-Richtung Linien zeichnen 
                    LineXY(xa+n1,ya,xe+n1,ye):n1 + 1 
                Else ; in y-Richtung Linien zeichnen 
                    LineXY(xa,ya+n1,xe,ye+n1):n1 + 1 
                EndIf 
                ;Horizontal- und Vertikallinien besser mit Box() und Drawmode(<>4) zeichnen 
            Wend 
    EndSelect 

    FrontColor(RGB(0,0,0)) 
EndProcedure 

;Hier ggF. denPfad zum Bild eintragen 
;LoadImage(100,"") 
LoadFont(0, "Arial", Fontpointsize(12))
If Init_Printer("test") = #True 
    n.l 
    
    DrawingMode(4) 
    
    ;Parameter z. B. Linie / ID(nur Bilder) / Start x,y / Ende x,y / Dicke / Farbe / Text (nur Text) 
    
    Drucke_Element(#Line,0,30,10,100,100,2,RGB(100,120,30),"") 
    Drucke_Element(#Line,0,10,10,100,100,-4,RGB(100,20,30),"") 
    Drucke_Element(#Circle,0,50,50,20,0,5,RGB(100,120,130),"") 
    DrawingFont(FontID(0)) ;Schriftgröße muss berechnet werden 
    Drucke_Element(#Text,0,20,100,0,0,0,0,"Text") 
    Drucke_Element(#Box,0,40,60,10,10,2.5,RGB(100,70,90),"") 
    Drucke_Element(#Ellipse,0,50,50,30,40,10,RGB(100,20,30),"") 

;    DrawImage(UseImage(100),100,100,20,20) 
;    Drucke_Element(#Image,100,40,60,30,30,0,0,"") 
;    Drucke_Element(#Image,100,140,60,30,50,0,0,"") 
    Deinit_printer() 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; DisableDebugger
