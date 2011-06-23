; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1361&highlight=
; Author: NicTheQuick (updated for PB4.00 by blbltheworm)
; Date: 16. June 2003
; OS: Windows
; Demo: Yes

#Breite = 200 
#Hoehe = 300 
If OpenWindow(0, 0, 0, #Breite, #Hoehe, "Primzahlen", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) = #False 
  End 
EndIf 

If CreateGadgetList(WindowID(0)) 
  ListViewGadget(0, 0, 0, #Breite, #Hoehe) 
Else 
  End 
EndIf 

Global NewList PrimZahl.l() 

;Startzahl n�tzt nur bei Methode 1. Methode 2 beginnt immer bei 1! 

StartZahl.s = InputRequester("Startzahl...", "Bitte geben sie den Startwert an oder nichts um von Anfang zu starten:", "") 


Tmp = 0             ;<-- Startzahl 
Tmp = Val(StartZahl) 

;Methode 2 sollte schneller sein als Methode 1. Wegen den sprunghaften Zugriffen auf die 
;verlinkten Ketten kann ein Geschwindigkeitsverlust allerdings wieder entstehen. 

If Tmp > 2 
  Gosub Methode1 
Else 
  Gosub Methode2 
EndIf 


End 

Methode1: 
  If Tmp = 0 
    AddElement(PrimZahl()) 
    PrimZahl() = 2 
    AddElement(PrimZahl()) 
    AddGadgetItem(0, -1, "2") 
    PrimZahl() = 3 
    AddGadgetItem(0, -1, "3") 
  EndIf 
  Divisor = 1   ;Zahl, durch die dividiert wird 
  TmpStop = 1   ;Wenn der Divisor gleich TmpStop ist, wird zur n�chsten ungeraden Zahl gesprungen 
  OK = 1        ;Wenn OK = 0 ist, ist die �berpr�fte Zahl teilbar und somit keine Primzahl 
  Tmp | 1       ;Nur dazu da, um die Startzahl ungerade zu "machen" 
  Repeat 
    If Tmp / Divisor * Divisor = Tmp : OK = 0 : EndIf 
    If OK = 0   ;Ist die zu �berpr�fende Zahl teilbar?... 
      Tmp + 2   ;Springe zur n�chsten ungeraden Zahl 
      TmpStop = Sqr(Tmp)   ;setzte die n�chste Grenze fest 
      TmpStop | 1 
      Divisor = 1   ;Beginnt wieder bei 1 mit dem dividieren 
      OK = 1    ;Setzte OK wieder auf wahr 
    ElseIf Divisor = TmpStop    ;...oder ist die Grenze errreicht? 
      AddElement(Primzahl())    ;Speichere die Primzahl im Speicher... 
      Primzahl() = Tmp 
      AddGadgetItem(0, -1, Str(Tmp))    ;...und im ListViewGadget 
      Divisor = 1   ;Setzte Divisor zur�ck 
      Tmp + 2   ;Springe zur n�chsten ungeraden Zahl zum weiteren �berpr�fen 
      TmpStop = Sqr(Tmp)   ;Setzte die n�chste Grenze fest 
      TmpStop | 1 
    EndIf 
    Divisor + 2 ;Springe zum n�chsten ungeraden Divisor 
  Until WindowEvent() = #WM_CLOSE 
Return 

Methode2: 
  If Tmp = 0 
    AddElement(PrimZahl()) 
    PrimZahl() = 2 
    AddElement(PrimZahl()) 
    AddGadgetItem(0, -1, "2") 
    PrimZahl() = 3 
    AddGadgetItem(0, -1, "3") 
  EndIf 
  Tmp = 1 
  Divisor = 1 
  TmpStop = 1 
  OK = 1  
  Repeat 
    If Tmp / Divisor * Divisor = Tmp : OK = 0 : EndIf 
    If OK = 0 
      Tmp + 2 
      TmpStop = Sqr(Tmp) 
      TmpStop | 1 
      ResetList(Primzahl()) 
      OK = 1 
    ElseIf Divisor >= TmpStop 
      LastElement(Primzahl()) 
      AddElement(Primzahl()) 
      Primzahl() = Tmp 
      AddGadgetItem(0, -1, Str(Tmp)) 
      ResetList(Primzahl()) 
      Tmp + 2 
      TmpStop = Sqr(Tmp) 
      TmpStop | 1 
    EndIf 
    NextElement(Primzahl()) 
    Divisor = Primzahl() 
  Until WindowEvent() = #WM_CLOSE 
Return

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
