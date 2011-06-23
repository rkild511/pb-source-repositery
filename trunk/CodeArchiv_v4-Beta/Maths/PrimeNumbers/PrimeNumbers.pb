; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3148&highlight=
; Author: NicTheQuick (updated for PB4.00 by blbltheworm)
; Date: 15. December 2003
; OS: Windows
; Demo: No

; (Original example posted on 16-June-2003 at
;  http://robsite.de/php/pureboard/viewtopic.php?t=1361&highlight=
;  is now included as PrimeNumbers_old.pb in the CodeArchive)

Global NewList PrimZahl.l() 

;Startzahl nützt nur bei Methode 1. Methode 2 beginnt immer bei 1! 

StartZahl.s = InputRequester("Startzahl...", "Geben sie den Startwert an oder nichts um von Anfang zu starten:", "") 
EndZahl.l   = Val(InputRequester("Endzahl...", "Geben sie die Endwert ein oder Null um selbst zu stoppen:", "")) 


Tmp = 0             ;<-- Startzahl 
Tmp = Val(StartZahl) 

;Methode 2 sollte schneller sein als Methode 1. Wegen den sprunghaften Zugriffen auf die 
;verlinkten Ketten kann ein Geschwindigkeitsverlust allerdings wieder entstehen. 

If EndZahl = 0 
  If OpenWindow(0, 0, 0, 95, 20, "Primzahlenberechnung läuft", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
    If CreateGadgetList(WindowID(0)) 
      ButtonGadget(0, 0, 0, 100, 20, "Stopp") 
      While WindowEvent() : Wend 
    EndIf 
  EndIf 
EndIf 

Zeit = GetTickCount_() 
If Tmp > 2 
  Gosub Methode1 
Else 
  Gosub Methode2 
EndIf 
Zeit = GetTickCount_() - Zeit 

If EndZahl = 0 
  ResizeWindow(0,#PB_Ignore,#PB_Ignore,95, 200) 
Else 
  If OpenWindow(0, 0, 0, 95, 200, "Primzahlenberechnung läuft", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
    If CreateGadgetList(WindowID(0)) 
      ButtonGadget(0, 0, 0, 100, 20, "") 
      While WindowEvent() : Wend 
    EndIf 
  EndIf 
EndIf 

SetGadgetText(0, "Zeit: " + Str(Zeit) + " ms") 
DisableGadget(0, 1) 
HideGadget(0, 1) 

ListViewGadget(1, 0, 20, 100, 180) 

Max.l = CountList(PrimZahl()) 
ProgressBarGadget(2, 0, 0, 100, 20, 0, 100, #PB_ProgressBar_Smooth) 
Pos.l = 0 
ForEach PrimZahl() 
  Pos + 1 
  AddGadgetItem(1, -1, Str(PrimZahl())) 
  SetGadgetState(2, Pos * 100 / Max) 
Next 
FreeGadget(2) 
HideGadget(0, 0) 

Repeat : Until WindowEvent() = #PB_Event_CloseWindow 

End 

Methode1: 
  Divisor = 1   ;Zahl, durch die dividiert wird 
  TmpStop = 1   ;Wenn der Divisor gleich TmpStop ist, wird zur nächsten ungeraden Zahl gesprungen 
  OK = 1        ;Wenn OK = 0 ist, ist die überprüfte Zahl teilbar und somit keine Primzahl 
  Tmp | 1       ;Nur dazu da, um die Startzahl ungerade zu "machen" 
  Repeat 
    If Tmp / Divisor * Divisor = Tmp : OK = 0 : EndIf 
    
    If OK = 0   ;Ist die zu überprüfende Zahl teilbar?... 
      Tmp + 2   ;Springe zur nächsten ungeraden Zahl 
      TmpStop = Sqr(Tmp)   ;setzte die nächste Grenze fest 
      TmpStop | 1 
      Divisor = 1   ;Beginnt wieder bei 1 mit dem dividieren 
      OK = 1    ;Setzte OK wieder auf wahr 
    ElseIf Divisor = TmpStop    ;...oder ist die Grenze errreicht? 
      AddElement(PrimZahl()) 
      PrimZahl() = Tmp 
      
      Divisor = 1   ;Setzte Divisor zurück 
      Tmp + 2   ;Springe zur nächsten ungeraden Zahl zum weiteren Überprüfen 
      TmpStop = Sqr(Tmp)   ;Setzte die nächste Grenze fest 
      TmpStop | 1 
    EndIf 
    Divisor + 2 ;Springe zum nächsten ungeraden Divisor 
    
    If EndZahl 
      If Tmp > EndZahl : Break : EndIf 
    Else 
      If WindowEvent() = #PB_Event_Gadget 
        If EventGadget() = 0 
          Break 
        EndIf 
      EndIf 
    EndIf 
  ForEver 
Return 

Methode2: 
  If Tmp = 0 
    AddElement(PrimZahl()) 
    PrimZahl() = 2 
    AddElement(PrimZahl()) 
    PrimZahl() = 3 
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
      ResetList(PrimZahl()) 
      OK = 1 
    ElseIf Divisor >= TmpStop 
      LastElement(PrimZahl()) 
      AddElement(PrimZahl()) 
      PrimZahl() = Tmp 
      ResetList(PrimZahl()) 
      Tmp + 2 
      TmpStop = Sqr(Tmp) 
      TmpStop | 1 
    EndIf 
    NextElement(PrimZahl()) 
    Divisor = PrimZahl() 
    
    If EndZahl 
      If Tmp > EndZahl : Break : EndIf 
    Else 
      If WindowEvent() = #PB_Event_Gadget 
        If EventGadget() = 0 
          Break 
        EndIf 
      EndIf 
    EndIf 
  ForEver 
Return

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
