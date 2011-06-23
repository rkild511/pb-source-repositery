; www.PureArea.net
; Author: Suat Cirikliel (updated for PB 4.00 by Andre)
; Date: 30. March 2003
; OS: Windows
; Demo: Yes

;********************** 
; 

DataSection 
Leiste: 
;IncludeBinary "Leiste1.bmp" 
EndDataSection 
;CatchImage(1,?Leiste) 
CreateImage(1,20,20)
;---------------------------------------- 
DataSection 
Lines: 
;IncludeBinary "Lines.bmp" 
EndDataSection 
;CatchImage(2,?Lines) 
CreateImage(2,20,20)
;________________________________________________________________________________________________________ 
LoadFont (1, "Times New Roman", 14) 
LoadFont (2, "Times New Roman", 12) 
; 
Global AR.f, ZR.f, BR.f, ER.f, PR.f, KLV.f, RLV.f, RB.l, VERM.f, HIBR.f, WR.f, INF.f 
;________________________________________________________________________________________________________ 
; 
;Fenster öffnen 
If OpenWindow(0, 100, 100, 530, 400, " Wieviel Geld stehen Ihnen im Alter, monatlich zur Verfügung", #PB_Window_WindowCentered) 

; Eingabe - Maske aufbauen 
If CreateGadgetList(WindowID(0)) 
  
  StringGadget(4, 140, 70, 50, 20, "") 
  StringGadget(6, 140, 100, 50, 20, "") 
  StringGadget(8, 140, 130, 50, 20, "") 
  StringGadget(10, 140, 160, 50, 20, "") 
  ; 
  StringGadget(12, 470, 70, 50, 20, "") 
  StringGadget(14, 470, 100, 50, 20, "") 
  StringGadget(18, 470, 130, 50, 20, "") 
  StringGadget(50, 470, 160, 50, 20, "") 
  StringGadget(51, 470, 190, 50, 20, "") 
  StringGadget(52, 470, 220, 50, 20, "") 
  ; 
  StringGadget(20, 140, 330, 50, 20, "") 
  StringGadget(22, 140, 360, 30, 20, "") 
  
  ;___________________________________________________________________________________________________ 
  ; Buttons 
  ButtonGadget(23, 250, 350, 60, 25, "Berechnen") ;hier werden Buttons platziert 
  ;ButtonImageGadget(23, 250, 350, 60, 25,1) 
  ButtonGadget(24, 350,350, 60, 25, "Info") 
  ButtonGadget(25, 450,350, 60, 25, "Ende") 
  ;___________________________________________________________________________________________________ 
EndIf 

If StartDrawing(WindowOutput(0)) 
  
  DrawImage(ImageID(2),0,0) 
  
  DrawingMode(1) 
  
  FrontColor(RGB(255,255,0)) 
  DrawText (15,70,"Altersrente :") 
  FrontColor(RGB(0,0,0))
  DrawText (14,69,"Altersrente :") 
  ; 
  FrontColor(RGB(255,255,0))
  DrawText (15,100,"Zusatzrente :") 
  FrontColor(RGB(0,0,0))
  DrawText (14,99,"Zusatzrente :") 
  ; 
  FrontColor(RGB(255,255,0))
  DrawText (15,130,"Betriebsrente :") 
  FrontColor(RGB(0,0,0))
  DrawText (14,129,"Betriebsrente :") 
  ; 
  FrontColor(RGB(255,255,0))
  DrawText (15,160,"Ersparnisse :") 
  FrontColor(RGB(0,0,0))
  DrawText (14,159,"Ersparnisse :") 
  ; 
  ;--- Text gegenüberliegend 
  FrontColor(RGB(255,255,0))
  DrawText (260,70,"Private Rentenversicherung :") 
  FrontColor(RGB(0,0,0))
  DrawText (259,69,"Private Rentenversicherung :") 
  ; 
  FrontColor(RGB(255,255,0))
  DrawText (260,100,"Kapital Lebensversicherung :") 
  FrontColor(RGB(0,0,0))
  DrawText (259,99,"Kapital Lebensversicherung :") 
  ; 
  FrontColor(RGB(255,255,0))
  DrawText (260,130,"Rentenbeginn in (Jahren) :") 
  FrontColor(RGB(0,0,0))
  DrawText (259,129,"Rentenbeginn in (Jahren) :") 
  ; 
  FrontColor(RGB(0,255,255))
  DrawText (260,160,"Hinterbliebenenrente :") 
  FrontColor(RGB(0,0,0))
  DrawText (259,159,"Hinterbliebenenrente :") 
  ; 
  FrontColor(RGB(0,255,255))
  DrawText (260,190,"Vermögen im Todesfall :") 
  FrontColor(RGB(0,0,0))
  DrawText (259,189,"Vermögen im Todesfall :") 
  ; 
  FrontColor(RGB(0,255,255))
  DrawText (260,220,"Risiko Lebensversicherung :") 
  FrontColor(RGB(0,0,0))
  DrawText (259,219,"Risiko Lebensversicherung :") 
  ;--- Text im unteren Bereich 
  FrontColor(RGB(255,255,0))
  DrawText (15,330,"Wunschrente :") 
  FrontColor(RGB(0,0,0))
  DrawText (14,329,"Wunschrente :") 
  ; 
  FrontColor(RGB(255,255,0))
  DrawText (15,360,"Inflationsrate :") 
  FrontColor(RGB(0,0,0))
  DrawText (14,359,"Inflationsrate :") 
  
EndIf 


Repeat 
  EventID.l = WaitWindowEvent() 
  Select EventID 
    Case #PB_Event_CloseWindow 
      Quit = 1 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        ; hier werden die Buttons abgefragt. 11 = Berechnen 12 = Info 13 = Ende 
        Case 23 
          ; Berechnen (springe zum Unterprogramm Berechnen) 
        Gosub Berechnen 
          Case 24 
          ; Info 
          MessageRequester("Info", "(C) Copyright by Suat Cirikliel 2003", #PB_MessageRequester_Ok ) 
        Case 25 
          ; Ende, wenn der Button Ende gedrückt wird. 
          Quit = 1 
      EndSelect 
  EndSelect 
  
Until Quit = 1 

EndIf 

End 

Berechnen: 

; GetGadgetText gibt einen String zurück. 
; Also muß mit VALF() der Text in die Floatvariablen (k, p) gesetzt werden. 
; n ist eine ganze Zahl, also reicht hier das einfache VAL() 
;Kgesamt.f 
Luecke.f 
Realbedarf.f 
; Variable für das Ergebnis 
; Auslesen der Eingabefelder (StringGadgets) 
; hier kann man, wenn man will, noch Eingabefehler abfangen 
; AR=Altersrente - ZR=Zusatzrente - BR=Betriebsrente - ER=Ersparnisse - PR=PrivateRentenvers - 
; KLV=KaoitalLebensVers - RLV=RisikoLebensVers - RBeginn=RentenBeginn - WR=WunschRente - INF=Inflationsrate 
; INFL=Inflationslücke 

AR = ValF(GetGadgetText(4)) 
ZR = ValF(GetGadgetText(6)) 
BR = ValF(GetGadgetText(8))
ER = ValF(GetGadgetText(10)) 
PR = ValF(GetGadgetText(12)) 
KLV = ValF(GetGadgetText(14)) 
RB = ValF(GetGadgetText(18)) 
WR = ValF(GetGadgetText(20)) 
INF = ValF(GetGadgetText(22)) 
HIBR = ValF(GetGadgetText(50)) 
VERM = ValF(GetGadgetText(51)) 
RLV = ValF(GetGadgetText(52)) 

; Berechnung 
Kapital.f = (KLV + ER) / 200 + (AR + ZR + BR + PR) 
Luecke.f = (WR - Kapital) 
INF2.f = (100 - INF) / 100 

INFL.f=Pow(INF2, RB)*Luecke 
Bedarf.f = Luecke - INFL 
Realbedarf.f = Luecke + Bedarf 

;If Realbedarf.f < Luecke.f ging nicht warum weis ich nicht 

;If Realbedarf > 0 

If Realbedarf.f < Luecke.f
  DrawImage(ImageID(1), 40,250) ; lädt das Bmp-Bild mit dem Image(1) 
  DrawingMode(1) 
  DrawingFont(FontID(1)) 
  FrontColor(RGB(155,0,0))
  DrawText(70,250,"Für Ihre Wunschrente im Alter fehlen Ihnen " + Str(Luecke) + " EUR.") 
  DrawText(70,272,"inflationsbereinigt sind es monatlich sogar nur " + Str(Realbedarf) + "EUR.") 
Else 
  DrawImage(ImageID(1), 40,250) ; lädt das Bmp-Bild mit dem Image(1) 
  DrawingMode(1) 
  DrawingFont(FontID(2)) 
  FrontColor(RGB(0,0,155)) 
  DrawText(60,250,"Sie gehören zu den wenigen, beneidenswerten Menschen, die im Alter") 
  DrawText(60,272,"wahrscheinlich auch die gewünschte Rente zur Verfügung haben werden.") 
EndIf 


Return 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -