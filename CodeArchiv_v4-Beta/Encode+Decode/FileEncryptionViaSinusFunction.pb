; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3405&highlight=
; Author: NicTheQuick (updated for PB3.92+ by Lars, updated for PB 4.00 by Andre)
; Date: 11. January 2004
; OS: Windows
; Demo: Yes


; Example for byte-wise asynchron encryption using the sinus function
; Beispiel zur byteweisen asynchronen Verschlüsselung mittels der Sinusfunktion
Procedure DeCodeFile(File.s) 
  If ReadFile(0, File) 
    Length.l = Lof(0) 
    *Address = AllocateMemory(Length) 
    Keybyte.b = %10101010    ;Startwert (Schlüssel) 
    ReadData(0, *Address, Length) 
    CloseFile(0) 
    For a.l = 0 To Length - 1 
      Byte.b = PeekB(*Address + a) 
      c.b = Sin(a) * 255 
      PByte.b = Byte ! Keybyte ! c 
      Keybyte = Byte 
      PokeB(*Address + a, PByte) 
    Next 
    If CreateFile(0, File + ".orig") 
      WriteData(0, *Address, Length) 
      CloseFile(0) 
      FreeMemory(*Address) 
      ProcedureReturn #True 
    EndIf 
    FreeMemory(*Address) 
  EndIf 
EndProcedure 

Procedure EnCodeFile(File.s) 
  If ReadFile(0, File) 
    Length.l = Lof(0) 
    *Address = AllocateMemory(Length) 
    Keybyte.b = %10101010   ;Startwert (Schlüssel) 
    ReadData(0, *Address, Length) 
    CloseFile(0) 
    For a.l = 0 To Length - 1 
      Byte.b = PeekB(*Address + a) 
      c.b = Sin(a) * 255 
      Keybyte = Byte ! Keybyte ! c 
      PokeB(*Address + a, Keybyte) 
    Next 
    If CreateFile(0, File + ".cod") 
      WriteData(0, *Address, Length) 
      CloseFile(0) 
      FreeMemory(*Address) 
      ProcedureReturn #True 
    EndIf 
    FreeMemory(*Address) 
  EndIf 
EndProcedure

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
