; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1361&highlight=
; Author: NicTheQuick (updated for PB4.00 by blbltheworm)
; Date: 16. June 2003
; OS: Windows
; Demo: No

Zahl.l = Val(InputRequester("Primfaktoren / Teiler suchen...", "Bitte Zahl eingeben:", "")) 
If Zahl < 0 
  MessageRequester("ERROR", "Falscher Zahlenwert", 0) 
EndIf 

Global NewList PFs.l() 
Procedure Primfaktoren(Zahl.l) 
  Protected Tmp.l, StartTime.l, a.l, OK.l 
  StartTime.l = GetTickCount_() 
  Tmp.l = Zahl 
  Repeat 
    a.l = 2 
    OK.l = #False 
    Repeat 
      If Tmp - Tmp / a * a = 0 
        OK = AddElement(PFs()) 
        PFs() = a 
        Tmp = Tmp / a 
      EndIf 
      a + 1 
    Until OK 
  Until Tmp = 1 
  ProcedureReturn GetTickCount_() - StartTime 
EndProcedure 

PFZeit.l = Primfaktoren(Zahl) 

Global NewList Ts.l() 
Procedure.l Teiler() 
  StartTime.l = GetTickCount_()         ;Zeit 
  
  Structure PFa                        ;Structure 
    PF.l 
    Bit.l 
  EndStructure 
  
  MaxPFs.l = CountList(PFs())           ;Array 
  If MaxPFs = 0 : ProcedureReturn : EndIf 
  Global Dim PFa.PFa(MaxPFs - 1) 
  
  ResetList(PFs())                      ;Array füllen 
  c = 0 
  While NextElement(Pfs()) 
    PFa(c)\PF = PFs() 
    c + 1 
  Wend 
  
  Quit.l = #False                       ;ausrechnen 
  d.l 
  Repeat 
    PFa(0)\Bit + 1              ;Bitweisen addieren 
    s.s = "" 
    For a.l = 0 To MaxPFs - 1 
      If PFa(a)\Bit = 2 
        If a = MaxPFs - 1 
          Quit = #True 
        Else 
          PFa(a)\Bit = 0 
          PFa(a + 1)\Bit + 1 
        EndIf 
      EndIf 
    Next 
    
    If Quit = #False            ;Multiplizeren 
      Erg.l = 1 
      For a.l = 0 To MaxPFs - 1 
        If PFa(a)\Bit : Erg = Erg * PFa(a)\PF : EndIf 
      Next 
      
      OK.l = #True 
      ResetList(Ts()) 
      While NextElement(Ts()) And OK 
        If Ts() = Erg : OK = #False : EndIf 
      Wend 
      If OK 
        LastElement(Ts()) 
        AddElement(Ts()) 
        Ts() = Erg 
      EndIf 
    EndIf 
    d + 1 
  Until Quit 
  
  ProcedureReturn GetTickCount_() - StartTime 
EndProcedure 

TZeit.l = Teiler() 


PFStr.s = "1" 
ResetList(PFs()) 
While NextElement(PFs()) 
  PFStr = PFStr + ", " + Str(PFs()) 
Wend 

TStr.s = "1" 
ResetList(Ts()) 
While NextElement(Ts()) 
  TStr = TStr + ", " + Str(Ts()) 
Wend 

LF.s = Chr(13) + Chr(10) 
MessageRequester("Primfaktoren / Teiler", "Primfaktoren (" + Str(PFZeit) + " ms)" + LF + PFStr + LF + LF + "Teiler (" + Str(TZeit) + " ms)" + LF + TStr, 0) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
