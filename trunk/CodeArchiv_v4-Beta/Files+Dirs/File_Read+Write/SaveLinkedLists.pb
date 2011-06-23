; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2479&highlight=
; Author: NicTheQuick (updated for PB4.00 by blbltheworm)
; Date: 06. October 2003
; OS: Windows
; Demo: Yes

; Save linked list in a file...

; LinkedList in Datei speichern:
; Liste, die ich durch eine Structur definiert wurde.
; Diese wird hier in eine Datei gespeichert und wieder ausgelesen. 


Structure ValueStructure 
  Long.l 
  Word.l 
  Byte.l 
  Float.f 
EndStructure 

Structure StringStructure 
  String1.s 
  String2.s 
  String3.s 
EndStructure 

Global NewList ValueLinkedList.ValueStructure() 
Global NewList StringLinkedList.StringStructure() 

Enumeration 
  #SaveFile 
EndEnumeration 

Procedure SaveLinkedList_Value(*FirstElement, StructureSize.l, File.s) 
  Protected *PosLL 
  If CreateFile(#SaveFile, File) 
    *PosLL = *FirstElement 
    Repeat 
      WriteData(#SaveFile,*PosLL, StructureSize) 
      *PosLL = PeekL(*PosLL - 8) + 8 
    Until *PosLL = 8 
    CloseFile(#SaveFile) 
  EndIf 
EndProcedure 
Procedure LoadLinkedList_Value(StructureSize.l, File.s) 
  If ReadFile(#SaveFile, File) 
    ClearList(ValueLinkedList()) 
    While Eof(#SaveFile) = 0 
      AddElement(ValueLinkedList()) 
      ReadData(#SaveFile,@ValueLinkedList(), StructureSize) 
    Wend 
    CloseFile(#SaveFile) 
  EndIf 
EndProcedure 

Procedure SaveLinkedList_String(*FirstElement, StructureSize.l, File.s) 
  Protected *PosLL, StringPos.l, StringLength.l, StringAddress.l 
  If CreateFile(#SaveFile, File) 
    *PosLL = *FirstElement 
    Repeat 
      For StringPos = 0 To StructureSize - 1 Step 4 
        StringAddress = PeekL(*PosLL + StringPos) 
        StringLength = Len(PeekS(StringAddress)) 
        WriteLong(#SaveFile,StringLength) 
        WriteData(#SaveFile,StringAddress, StringLength) 
      Next 
      *PosLL = PeekL(*PosLL - 8) + 8 
    Until *PosLL = 8 
    CloseFile(#SaveFile) 
  EndIf 
EndProcedure 
Procedure LoadLinkedList_String(File.s) 
  Protected StringPos.l, StringLength.l 
  If ReadFile(#SaveFile, File) 
    ClearList(StringLinkedList()) 
    While Eof(#SaveFile) = 0 
      AddElement(StringLinkedList()) 
      For StringPos = 1 To 3 
        StringLength = ReadLong(#SaveFile) 
        Select StringPos 
          Case 1 
            StringLinkedList()\String1 = Space(StringLength) 
            ReadData(#SaveFile,@StringLinkedList()\String1, StringLength) 
          Case 2 
            StringLinkedList()\String2 = Space(StringLength) 
            ReadData(#SaveFile,@StringLinkedList()\String2, StringLength) 
          Case 3 
            StringLinkedList()\String3 = Space(StringLength) 
            ReadData(#SaveFile,@StringLinkedList()\String3, StringLength) 
        EndSelect 
      Next 
    Wend 
    CloseFile(#SaveFile) 
  EndIf 
EndProcedure 

;- Values 
For a.l = 0 To 200 Step 4 
  AddElement(ValueLinkedList()) 
  ValueLinkedList()\Long = a 
  ValueLinkedList()\Word = a + 1 
  ValueLinkedList()\Byte = a + 2 
  ValueLinkedList()\Float = a / 10 
Next 
FirstElement(ValueLinkedList()) 
SaveLinkedList_Value(@ValueLinkedList(), SizeOf(ValueStructure), "tempvalues.dat") 

LoadLinkedList_Value(SizeOf(ValueStructure), "tempvalues.dat") 

ResetList(ValueLinkedList()) 
ForEach ValueLinkedList() 
  Debug ValueLinkedList()\Float 
Next 

;- Strings 

For a.l = 0 To 200 Step 3 
  AddElement(StringLinkedList()) 
  StringLinkedList()\String1 = "abc: " + Str(a) 
  StringLinkedList()\String2 = Str(a + 1) + "abcdefghijklmnopqrstuvwxyz" 
  StringLinkedList()\String3 = "Diese Strings wurden alle gespeichert" 
Next 
FirstElement(StringLinkedList()) 
SaveLinkedList_String(@StringLinkedList(), SizeOf(StringStructure), "tempstrings.dat") 

ClearList(StringLinkedList()) 
LoadLinkedList_String("tempstrings.dat") 

ResetList(StringLinkedList()) 
ForEach StringLinkedList() 
  Debug StringLinkedList()\String2 
Next

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
