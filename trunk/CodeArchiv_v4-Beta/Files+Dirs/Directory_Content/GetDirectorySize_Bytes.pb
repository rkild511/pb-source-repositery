; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7015&highlight=
; Author: Freak
; Date: 27. July 2003
; OS: Windows
; Demo: 

Structure d 
  lowLONG.l 
  hiLONG.l 
EndStructure 

Procedure.s StrD(*value.d) 
  Protected buffer1.s, buffer2.s, buffer3.s, pos1.l, pos2.l, pos3.l, calc1.l, calc2.l 
  buffer3 = StrU(*value\lowLONG,#LONG) 
  For pos1 = Len(StrU(*value\hiLONG,#LONG)) To 1 Step -1 
    For pos2 = Len(StrU(-1,#LONG)) To 1 Step -1 
      calc1 = Val(Mid(StrU(*value\hiLONG,#LONG),pos1,1)) * Val(Mid(StrU(-1,#LONG),pos2,1)) 
      calc2 = (Len(StrU(*value\hiLONG,#LONG))-pos1)+(Len(StrU(-1,#LONG))-pos2) 
      buffer1 = Str(calc1) + Left("00000000000000000000",calc2) 
      buffer2 = buffer3 
      buffer3 = "" 
      calc1 = 0 
      If Len(buffer1) > Len(buffer2) 
        buffer2 = Right("00000000000000000000"+buffer2,Len(buffer1)) 
      Else 
        buffer1 = Right("00000000000000000000"+buffer1,Len(buffer2)) 
      EndIf 
      For pos3 = Len(buffer1) To 1 Step -1 
        calc1 + Val(Mid(buffer1,pos3,1)) + Val(Mid(buffer2,pos3,1)) 
        buffer3 = Right(Str(calc1),1)+buffer3 
        calc1/10 
      Next pos3 
      If calc1 > 0: buffer3 = Str(calc1)+buffer3: EndIf 
    Next pos2 
  Next pos1 
  While Left(buffer3,1)="0" 
    buffer3 = Right(buffer3, Len(buffer3)-1) 
  Wend 
  ProcedureReturn buffer3 
EndProcedure 

Procedure AddD(*dest, *source1, *source2) 
  !mov eax, [esp+4] 
  !mov ebx, [eax] 
  !mov edx, [eax+4] 
  !mov eax, [esp+8] 
  !add ebx, [eax] 
  !adc edx, [eax+4] 
  !mov eax, [esp+0] 
  !mov [eax], ebx 
  !mov [eax+4], edx  
EndProcedure 

Procedure DirectorySize(DirectoryID.l, DirectoryName.s, *size.d) 
  If ExamineDirectory(DirectoryID, DirectoryName, "*.*") 
    Repeat 
      Entry.l = NextDirectoryEntry() 
      Name.s = DirectoryEntryName() 
      If Entry = 1 
        newsize.d 
        hFile.l = ReadFile(0, DirectoryName + Name) 
        If hFile 
          newsize\lowLONG = GetFileSize_(hFile, @newsize\hiLONG) 
          AddD(*size, *size, newsize) 
          CloseFile(0) 
        EndIf 
      ElseIf Entry = 2 
        If Name <> "." And Name <> ".." 
          DirectorySize(DirectoryID + 1, DirectoryName + Name + "\", *size) 
          UseDirectory(DirectoryID) 
        EndIf 
      EndIf 
    Until Entry = 0 
  EndIf 
EndProcedure 

; DirectorySize(0, "C:\WINNT\", size.d) 
DirectorySize(0, "C:\Windows\", size.d) 
Debug StrD(size) 
End 

; ExecutableFormat=Windows
; FirstLine=1
; EOF
