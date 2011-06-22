; German forum: http://robsite.de/php/pureboard/viewtopic.php?t=3405&highlight=
; Author: NicTheQuick
; Date: 11. January 2004


; Example for byte-wise asynchron encryption using the sinus function
; Beispiel zur byteweisen asynchronen Verschlüsselung mittels der Sinusfunktion
Procedure DeCodeFile(File.s) 
  If ReadFile(0, File) 
    Length.l = Lof() 
    *Address = AllocateMemory(0, Length) 
    Keybyte.b = %10101010    ;Startwert (Schlüssel) 
    ReadData(*Address, Length) 
    CloseFile(0) 
    For a.l = 0 To Length - 1 
      Byte.b = PeekB(*Address + a) 
      c.b = Sin(a) * 255 
      PByte.b = Byte ! Keybyte ! c 
      Keybyte = Byte 
      PokeB(*Address + a, PByte) 
    Next 
    If CreateFile(0, File + ".orig") 
      WriteData(*Address, Length) 
      CloseFile(0) 
      ProcedureReturn #True 
    EndIf 
    FreeMemory(0) 
  EndIf 
EndProcedure 

Procedure EnCodeFile(File.s) 
  If ReadFile(0, File) 
    Length.l = Lof() 
    *Address = AllocateMemory(0, Length) 
    Keybyte.b = %10101010   ;Startwert (Schlüssel) 
    ReadData(*Address, Length) 
    CloseFile(0) 
    For a.l = 0 To Length - 1 
      Byte.b = PeekB(*Address + a) 
      c.b = Sin(a) * 255 
      Keybyte = Byte ! Keybyte ! c 
      PokeB(*Address + a, Keybyte) 
    Next 
    If CreateFile(0, File + ".cod") 
      WriteData(*Address, Length) 
      CloseFile(0) 
      FreeMemory(0) 
      ProcedureReturn #True 
    EndIf 
    FreeMemory(0) 
  EndIf 
EndProcedure
; ExecutableFormat=Windows
; FirstLine=1
; EOF