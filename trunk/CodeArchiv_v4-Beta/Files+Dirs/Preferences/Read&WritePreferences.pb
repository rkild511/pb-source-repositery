; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14531&highlight=
; Author: dracflamloc (updated for PB 4.00 by Andre)
; Date: 24. March 2005
; OS: Windows, Linux
; Demo: Yes


; LinuxINI - Functions similar to Win32 GetPrivateProfileString
; These aren't the most efficient and they could be optimized a lot but 
; they work, and you don't have to read in every key and rewrite them 
; like you do with the builtin Preferences library.

;INI PROCEDURES 
Procedure Pref_WriteString(Section.s,Key.s,Value.s,FileName.s) 
  ;Equivalent of WritePrivateProfileString_ (Section, Key, Value,FileName) Win32 API 
  fid=ReadFile(#PB_Any,FileName) 
  fileout.s="" 
  If IsFile(fid) 
    While Eof(fid)=0 
      fileout.s=fileout.s+ReadString(fid)+Chr(13)+Chr(10) 
    Wend 
    CloseFile(fid) 
  EndIf 
  
  secpos=FindString(fileout,"["+Section+"]",1) 
  sec2pos=FindString(fileout,"[",secpos+Len(Section)) 
  If sec2pos=0 
    sec2pos=Len(fileout)+1 
  EndIf 
  If secpos>0 
    varpos=FindString(fileout,Chr(10)+Key,secpos) 
    If varpos=0 
      varpos=FindString(fileout,Chr(13)+Key,secpos) 
    EndIf 
  
    If varpos>0 And varpos<sec2pos 
      leftstr.s=Left(fileout,varpos+1+Len(Key)) 
      nlpos=FindString(fileout,Chr(13),varpos+1) 
      If nlpos=0 
        nlpos=Len(fileout) 
      EndIf 
      rightstr.s=Right(fileout,Len(fileout)-nlpos) 
      ;recombine 
      fileout=leftstr+value+rightstr 
    Else 
      leftstr.s=Left(fileout,secpos+2+Len(Section)) 
      rightstr.s=Right(fileout,Len(fileout)-secpos-Len(Section)-2) 
      If Left(rightstr,1)<>Chr(13) And Left(rightstr,1)<>Chr(10) 
        fileout=leftstr+Key+"="+Value+Chr(13)+Chr(10)+rightstr 
      Else 
        fileout=leftstr+Key+"="+Value+rightstr 
      EndIf 
    EndIf 
  Else 
    fileout=fileout+Chr(13)+Chr(10)+"["+Section+"]"+Chr(13)+Chr(10) 
    fileout=fileout+Key+"="+Value 
  EndIf 
  
  fid=CreateFile(#PB_Any,FileName) 
  If fid>0 
    While Right(fileout,1)=Chr(13) Or Right(fileout,1)=Chr(10) 
      fileout=Left(fileout,Len(fileout)-1) 
    Wend 
    WriteString(fid, Trim(fileout)) 
    CloseFile(fid) 
  EndIf 
    
EndProcedure 

Procedure.s Pref_ReadString(Section.s,Key.s,FileName.s) 
  Value.s = "" 
  ;Equivalent of GetPrivateProfileString_ (Section, Key, "", Value, Len(Value), FileName) Win32 API 
  fid=ReadFile(#PB_Any,FileName) 
  If IsFile(fid) 
    While Eof(fid)=0 
      mystr.s=ReadString(fid) 
      If FindString(mystr,"["+Section+"]",1)>0 
        While Eof(fid)=0 
          mystr=ReadString(fid) 
          If Left(mystr,1)="[" 
            Break 2 
          EndIf 
          If Left(mystr,Len(Key))=Key 
            Value.s=Right(mystr,Len(mystr)-Len(Key)-1) 
            Break 2 
          EndIf 
        Wend 
      EndIf 
    Wend 
  EndIf 
  
  ProcedureReturn Value.s 
EndProcedure 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -