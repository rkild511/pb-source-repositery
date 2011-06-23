; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7238&highlight=
; Author: oldefoxx (updated for PB v4 by Andre)
; Date: 16. August 2003
; OS: Windows
; Demo: No


; PATHFIND 
;by Donald R. Darden 
;takes a given file name, which can include wild 
;card characters,, and searches for the first 
;occurance of a file by that name, using first any 
;given path, then the current path, and finally, the 
;"PATH=" environmental variable.  Once at least one 
;file is found of the given type, the entries are 
;sorted into sequential order, and then printed 
;on the screen.  If the sought type had a * as the 
;extension, which might result in finding a matching 
;BAT, COM, or EXE file, the sort order reflects the 
;order that the operating system would execute them 
;in -- the BAT file (if found), the COM file (if the 
;BAT file is not found), or the EXE file (if neither 
;of the other two was found first., 

;The PATHFIND program actually goes the extra mile 
;as well.  If the above steps failed to find a 
;matching file, it will then start over again at the 
;parent directory and search each branch for any 
;possible matches.  This could be very useful in 
;case you forgot what subdirectory any INCLUDE file 
;were placed in, or in case you downloaded and did an 
;extract on an archive, but the internal code used 
;by programs in the archive expected a different 
;subdirectory structure than the one found on the 
;target machine. 

filename.s="windows.res"  ;set this to desired file name 

OpenConsole() 
Dim files.s(10000) 
fname.s=filename 
a.l=FindString(fname,":",1) 
Repeat 
  b.l=FindString(fname,"\",a+1) 
  If b 
    a=b 
  EndIf 
Until b=0 
fdir.s=Left(fname,a) 
fname=Mid(fname,a+1,Len(fname)) 
If fdir="" 
  fdir="." 
EndIf 
If ExamineDirectory(1,fdir,fname) 
  index.l=0 
  Repeat 
    a=NextDirectoryEntry(1) 
    If a=1 
      index=index+1 
      files(index)=DirectoryEntryName(1) 
    EndIf 
  Until a=0 
EndIf
If index=0 
  path.s=Space(2048) 
  a=GetEnvironmentVariable_("PATH",path,2048) 
  If a 
    path=Trim(path) 
    If Right(path,1)<>";" 
      path=path+";" 
    EndIf 
newpath: 
    a=0 
    Repeat 
      b=FindString(path,";",a+1) 
      If b 
        fdir=Mid(path,a+1,b-a-1) 
        a=b 
        If fdir>"" 
          b=ExamineDirectory(1,fdir,fname) 
          If b 
            index=0 
            Repeat 
              b=NextDirectoryEntry(1) 
              If b=1 
                index=index+1 
                files(index)=DirectoryEntryName(1) 
              EndIf 
            Until b=0 
            If index 
              Goto found 
            EndIf 
          EndIf 
        EndIf 
      EndIf 
    Until a>=Len(path) 
  EndIf 
EndIf    
index1.l=0 
index2.l=0 
fdir.s=".."  ;Change to "." for current directory 
Repeat      ;or "..\.." to begin with grandparent  
  If ExamineDirectory(1,fdir,fname) 
    Repeat 
      a=NextDirectoryEntry(1) 
      If a=1 
        index=index+1 
        files(index)=DirectoryEntryName(1) 
      EndIf 
    Until a=0 
    If index 
      Goto found 
    EndIf 
  EndIf 
  If ExamineDirectory(1,fdir,"*.*") 
    Repeat 
      a=NextDirectoryEntry(1) 
      If a=2 
        index2=index2+1 
        files(index2)=DirectoryEntryName(1) 
        Select files(index2) 
        Case "." 
          index2=index2-1 
        Case ".." 
          index2=index2-1 
        Default 
          files(index2)=fdir+"\"+files(index2) 
        EndSelect 
      EndIf 
    Until a=0 
  EndIf 
  If index1<index2 
    index1=index1+1 
    fdir=files(index1) 
  EndIf 
Until index1>=index2 
If index 
found: 
  SortArray(files(),0,1,index) 
  If Right(fdir,1)<>"\" 
    fdir=fdir+"\" 
  EndIf 
  For a=1 To index 
    PrintN(fdir+files(a)) 
  Next 
Else 
  PrintN("Unable to find file "+fname) 
EndIf 
terminate: 
Repeat 
Until Inkey()>"" 
CloseConsole() 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
