; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2838&highlight=
; Author: NicTheQuick
; Date: 15. November 2003
; OS: Windows
; Demo: Yes

; Using the "InpOut32,dll" (search at Google...) for using the Printer port.
; Benötigt die "InpOut32.dll" (siehe Google...).
; Damit steuere ich bei mir erfolgreich den LPT-Port an. Du musst nur die
; Adresse deines COM-Ports wissen, dann kannst du dorthin schon Daten übermitteln. 

Global InpOut32Aktiv.l 
Procedure OpenInpOut32() 
  Protected Result.l 
  Result = OpenLibrary(0, "InpOut32.dll") 
  If Result = #False 
    InpOut32Aktiv = #False 
    MessageRequester("ERROR", "InpOut32.dll wurde nicht gefunden oder ist korrupt.", #MB_ICONERROR) 
    End 
  Else 
    InpOut32Aktiv = #True 
  EndIf 
  ProcedureReturn Result 
EndProcedure 

Procedure CloseInpOut32() 
  CloseLibrary(0) 
  InpOut32Aktiv = #False 
EndProcedure 

Procedure Inp32(Address.l) 
  Protected Value.l 
  Value = CallFunction(0, "Inp32", Address) 
  ProcedureReturn Value 
EndProcedure 

Procedure Out32(Address.l, Value.l) 
  CallFunction(0, "Out32", Address, Value) 
EndProcedure 

Procedure CheckInpOut32Functions() 
  Protected FunctionName.s 
  If InpOut32Aktiv 
    Restore CheckInpOut32FunctionsData 
    For a.l = 1 To 2 
      Read FunctionName 
      If GetFunction(0, FunctionName) = #False 
        MessageRequester("ERROR", "Die Funktion " + Chr(34) + FunctionName + Chr(34) +" wurde nicht gefunden", #MB_ICONERROR) 
        ProcedureReturn #False 
      EndIf 
    Next 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
  
  DataSection 
    CheckInpOut32FunctionsData: 
    Data.s "Inp32", "Out32" 
  EndDataSection 
EndProcedure 

OpenInpOut32() 
CheckInpOut32Functions() 

Out32($3F8, 1) 
Out32($3F8, 0) 
Out32($3F8, 3) 

CloseInpOut32() 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
