; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7132&highlight=
; Author: oldefoxx (updated for PB v4 by Andre)
; Date: 06. August 2003
; OS: Windows
; Demo: Yes

;DO-DIR1             by Donald R. Darden 
;My second PureBASIC Program 

;List all drives from C: to Z: that can be accessed 
;from within PureBASIC and follow every directory 
;tree encountered, listing the files as well. 

;Array f() retains each subdirectory, IDX1 tracks 
;each added subdirectorym and IDX2 tracks each 
;explored subdirectory.  B$ hold the current 
;directory being explored, and D$ catches each new 
;file or directory name found in the current 
;directory as it is explored. 

;Note:  Code is included to show how IDX1 and IDX2 
;can be reset for each new drive.  This limits the 
;expansion of f().  You could also use just one IDX 
;so that it increases for each new subdirectory, 
;and then decreases for each explored subdirectory. 
;if you do this, then IDX will be zero after each 
;drive is processed, and you could safely redim f() 
;as its contents will effectively have been rendered 
;moot, even though string data will still reside 
;within the array elements. 

#Dir = 0
Dim f.s(20000)    ;Better safe than too small 
OpenConsole() 
drive=Asc("C")     ;start with first hard drive 
CreateFile(1,"tempdir.txt")  ;write output to file 
While drive<=Asc("Z")  ;this is last drive letter 
  b$=Chr(drive)+":\" 
  PrintN(b$)       ;Allows you to view each drive 
  ;CallDebugger    ;start if Debugger is enabled 
;  You have the option to set idx1=0 and 
;  idx2=0 if you want to index each drive 
;  separately 
next1: 
  If Right(b$,1)<>"\"   ;separatore before filename 
    b$=b$+"\" 
  EndIf  
  PrintN("")             ;line feed before directory 
  PrintN(b$)             ;show directory name 
  WriteStringN(1, b$)       ;write to file as well 
  If ExamineDirectory(#Dir,b$,"*.*")  ;access directory 
    Repeat 
      c=NextDirectoryEntry(#Dir)      ;'point to next 
      d$=DirectoryEntryName(#Dir)      ;get the name 
      ds$=Str(DirectoryEntrySize(#Dir)) ;get the size 
      da=DirectoryEntryAttributes(#Dir) ;get the attributes 
      If c=1                     ;this is a file 
        o$="    "+d$ 
        PrintN(o$)               ;print the file name 
        WriteStringN(1,o$) 
      ElseIf c=2                ;this is a directory 
        If d$<>"." And d$<>".." ;ignore same & partent 
          idx1=idx1+1            ;update f() index 
          f(idx1)=b$+d$          ;retain directory 
        EndIf 
      EndIf 
    Until c=0                    ;finished direcory 
    FinishDirectory(#Dir)
  EndIf
  If idx2<idx1                  ;get next directory 
    idx2=idx2+1                 ;in sequence found 
    b$=f(idx2) 
    Goto next1 
  EndIf 
  drive=drive+1                 ;next drive letter 
Wend 
CloseFile(1)                    ;close output file 
Print("Press any key")
Input()
CloseConsole()                  ;close conxole 
End                             ;terminate program 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
