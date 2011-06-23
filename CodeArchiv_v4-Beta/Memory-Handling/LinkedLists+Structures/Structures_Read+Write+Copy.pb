; German forum: http://www.purebasic.fr/german/viewtopic.php?t=11492&highlight=
; Author: NicTheQuick
; Date: 05. January 2007
; OS: Windows
; Demo: Yes

Structure Strukt 
  Byte.b 
  word.w 
  Long.l 
  Quad.q 
  String1.s 
  Float.f 
  String2.s 
  Double.d 
EndStructure 
Global Struc_Strukt.s 
Struc_Strukt = "bwlqsfsd" ; Die Struktur selbst in einem String 

Structure AllTypes 
  StructureUnion 
    b.b 
    c.c 
    w.w 
    l.l 
    f.f 
    d.d 
    q.q 
    s.s 
  EndStructureUnion 
EndStructure 
Procedure WriteStructure(FileId, *Var.AllTypes, *Struc.Character) 
  Protected length.l 
  
  While *Struc\c 
    Select *Struc\c 
      Case 'b' 
        WriteData(FileId, *Var, SizeOf(Byte)) : *Var + SizeOf(Byte) 
      Case 'c' 
        WriteData(FileId, *Var, SizeOf(Character)) : *Var + SizeOf(Character) 
      Case 'w' 
        WriteData(FileId, *Var, SizeOf(Word)) : *Var + SizeOf(Word) 
      Case 'l' 
        WriteData(FileId, *Var, SizeOf(Long)) : *Var + SizeOf(Long) 
      Case 'f' 
        WriteData(FileId, *Var, SizeOf(Float)) : *Var + SizeOf(Float) 
      Case 'd' 
        WriteData(FileId, *Var, SizeOf(Double)) : *Var + SizeOf(Double) 
      Case 'q' 
        WriteData(FileId, *Var, SizeOf(Quad)) : *Var + SizeOf(Quad) 
      Case 's' 
        length = Len(*Var\s) 
        WriteLong(FileId, length) 
        If length 
          WriteData(FileId, *Var\l, length) 
        EndIf 
        *Var + SizeOf(String) 
    EndSelect 
    *Struc + SizeOf(Character) 
  Wend 
EndProcedure 
Procedure ReadStructure(FileId, *Var.AllTypes, *Struc.Character) 
  Protected length.l 
  
  While *Struc\c 
    Select *Struc\c 
      Case 'b' 
        ReadData(FileId, *Var, SizeOf(Byte)) : *Var + SizeOf(Byte) 
      Case 'c' 
        ReadData(FileId, *Var, SizeOf(Character)) : *Var + SizeOf(Character) 
      Case 'w' 
        ReadData(FileId, *Var, SizeOf(Word)) : *Var + SizeOf(Word) 
      Case 'l' 
        ReadData(FileId, *Var, SizeOf(Long)) : *Var + SizeOf(Long) 
      Case 'f' 
        ReadData(FileId, *Var, SizeOf(Float)) : *Var + SizeOf(Float) 
      Case 'd' 
        ReadData(FileId, *Var, SizeOf(Double)) : *Var + SizeOf(Double) 
      Case 'q' 
        ReadData(FileId, *Var, SizeOf(Quad)) : *Var + SizeOf(Quad) 
      Case 's' 
        length = ReadLong(FileId) 
        *Var\s = Space(length) 
        ReadData(FileId, @*Var\s, length) 
        *Var + SizeOf(String) 
    EndSelect 
    *Struc + SizeOf(Character) 
  Wend 
EndProcedure 
Procedure CopyStructure(*Var1.AllTypes, *Var2.AllTypes, *Struc.Character) 
  While *Struc\c 
    Select *Struc\c 
      Case 'b' : *Var2\b = *Var1\b : *Var1 + SizeOf(Byte) : *Var2 + SizeOf(Byte) 
      Case 'c' : *Var2\c = *Var1\c : *Var1 + SizeOf(Character) : *Var2 + SizeOf(Character) 
      Case 'w' : *Var2\w = *Var1\w : *Var1 + SizeOf(Word) : *Var2 + SizeOf(Word) 
      Case 'l' : *Var2\l = *Var1\l : *Var1 + SizeOf(Long) : *Var2 + SizeOf(Long) 
      Case 'f' : *Var2\f = *Var1\f : *Var1 + SizeOf(Float) : *Var2 + SizeOf(Float) 
      Case 'd' : *Var2\d = *Var1\d : *Var1 + SizeOf(Double) : *Var2 + SizeOf(Double) 
      Case 'q' : *Var2\q = *Var1\q : *Var1 + SizeOf(Quad) : *Var2 + SizeOf(Quad) 
      Case 's' : *Var2\s = *Var1\s : *Var1 + SizeOf(String) : *Var2 + SizeOf(String) 
    EndSelect 
    *Struc + SizeOf(Character) 
  Wend 
EndProcedure 

Var1.Strukt 
Var1\Byte = 123 
Var1\word = 23432 
Var1\Long = 13579123 
Var1\Quad = 2468012343344533 
Var1\String1 = "Hallo du!" 
Var1\Float = 1234.1234 
Var1\String2 = "Ich bin NTQ!" 
Var1\Double = 123456789.123456789 

Var2.Strukt 
CopyStructure(@Var1, @Var2, @Struc_Strukt) 

MessageRequester("Kopierte Struktur", "Byte: " + Str(Var2\Byte) + Chr(13) + "Word: " + Str(Var2\word) + Chr(13) + "Long: " + Str(Var2\Long) + Chr(13) + "Quad: " + StrQ(Var2\Quad) + Chr(13) + "String1: " + Var2\String1 + Chr(13) + "Float: " + Str(Var2\Float) + Chr(13) + "String2: " + Var2\String2 + Chr(13) + "Double: " + StrD(Var2\Double)) 

If CreateFile(0, "c:\test_structure.txt") 
  WriteStructure(0, @Var1, @Struc_Strukt) 
  CloseFile(0) 
  RunProgram("c:\test_structure.txt", "", "", #PB_Program_Wait) 
EndIf 

If ReadFile(0, "c:\test_structure.txt") 
  Var3.Strukt 
  ReadStructure(0, @Var3, @Struc_Strukt) 
  CloseFile(0) 
  MessageRequester("Ausgelesene Struktur", "Byte: " + Str(Var3\Byte) + Chr(13) + "Word: " + Str(Var3\word) + Chr(13) + "Long: " + Str(Var3\Long) + Chr(13) + "Quad: " + StrQ(Var3\Quad) + Chr(13) + "String1: " + Var3\String1 + Chr(13) + "Float: " + Str(Var3\Float) + Chr(13) + "String2: " + Var3\String2 + Chr(13) + "Double: " + StrD(Var3\Double)) 
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP