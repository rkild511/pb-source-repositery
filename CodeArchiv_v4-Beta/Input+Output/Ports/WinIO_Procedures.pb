; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2817&highlight=
; Author: NicTheQuick (updated for PB 4.00 by Andre)
; Date: 06. April 2005
; OS: Windows
; Demo: Yes


; Some example procedures for using the WinIO.dll
; Einige Beispiele für die WinIO.dll

Global WinIOAktiv.l 
Procedure OpenWinIO() 
  Result.l = OpenLibrary(0, "WinIo.dll") 
  If Result = #False 
    WinIOAktiv = #False 
    MessageRequester("ERROR", "WinIO.dll wurde nicht gefunden oder ist korrupt.", #MB_ICONERROR) 
    End 
  Else 
    If CallFunction(0, "InstallWinIoDriver", "WinIo.vxd", #False) 
      WinIOAktiv = #True 
    Else 
      MessageRequester("ERROR", "WinIO.sys konnte nicht installiert werden." + Chr(13) + "Bitte melden sie sich mich Administratorrechten an und versuchen sie es erneut.", #MB_ICONERROR) 
      End 
    EndIf 

    If CallFunction(0, "InitializeWinIO") 
      WinIOAktiv = #True 
    Else 
      MessageRequester("ERROR", "WinIO konnte nicht initialisiert werden.", #MB_ICONERROR) 
      End 
    EndIf 
  EndIf 
  ProcedureReturn Result.l 
EndProcedure 

Procedure CloseWinIO() 
  CallFunction(0, "ShutDownWinIo") 
  CallFunction(0, "RemoveWinIoDriver") 
  CloseLibrary(0) 
  WinIOAktiv = #False 
EndProcedure 

Procedure SetBits(Value.l) 
  Address.l = 956 
  Result1.l = CallFunction(0, "SetPortVal", Address, Value) 
  If Result1.l = #False : Debug "SetBits - ERROR" : EndIf 
  ProcedureReturn Result1 
EndProcedure 

Procedure GetBits(Address.l) 
  Value.l 
  Result.l = CallFunction(0, "GetPortVal", Address, @Value, 4) 
  If Result = #False : Debug "GetBits - ERROR" : EndIf 
  ProcedureReturn Value 
EndProcedure 

Procedure GetPVal(Address.l, Length.l) 
  Value.l 
  Result.l = CallFunction(0, "GetPortVal", Address, @Value, Length) 
  If Result = #False : Debug "GetPVal - ERROR" : EndIf 
  ProcedureReturn Value 
EndProcedure 

Procedure SetPVal(Address.l, Value.l, Length.l) 
  Result.l = CallFunction(0, "SetPortVal", Address, Value, Length) 
  If Result = #False : Debug "SetPVal - ERROR" : EndIf 
  ProcedureReturn Result 
EndProcedure 

Procedure CheckWinIOFunctions() 
  If WinIOAktiv 
    Restore CheckWinIOFunctionsData 
    For a.l = 1 To 10 
      Read FunctionName.s 
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
    CheckWinIOFunctionsData: 
    Data.s "InitializeWinIo", "ShutdownWinIo", "InstallWinIoDriver", "RemoveWinIoDriver" 
    Data.s "GetPortVal", "SetPortVal", "GetPhysLong", "SetPhysLong" 
    Data.s "MapPhysToLin", "UnmapPhysicalMemory" 
  EndDataSection 
EndProcedure 

Procedure.b ReadCMOSByte(Offset.b) 
  InpB.b 
  CallFunction(0, "SetPortVal", $70, Offset, 1) 
  CallFunction(0, "GetPortVal", $71, @InpB, 1) 
  ProcedureReturn InpB 
EndProcedure 

OpenWinIO() 
CheckWinIOFunctions() 
SetBits(1) 
CloseWinIO()

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --