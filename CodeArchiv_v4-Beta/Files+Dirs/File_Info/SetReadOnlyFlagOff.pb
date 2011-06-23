; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=769&start=10
; Author: NicTheQuick (updated for PB v4 by Andre)
; Date: 13. December 2003
; OS: Windows
; Demo: No

;Wenn Rekursion < 0, wird nur vom angegebenen Verzeichnis der Schreibschutz entfernt 
;Wenn Rekursion >= 0, werden auch alle Unterverzeichnisse miteinbezogen. 
Procedure SetReadOnlyFlagOff(Dir.s, Rekursion.l) 
  Protected Typ.l, Modus.l, Name.s, flags.l 
  
  If Right(Dir, 1) <> "\" : Dir = Dir + "\" : EndIf 
  
  flags = GetFileAttributes_(Dir) 
  SetFileAttributes_(Dir, flags & ~#FILE_ATTRIBUTE_READONLY) 
  
  If Rekursion < 0 
    Modus = 1   ;Ohne Rekursion 
    Rekursion = 0 
  Else 
    Modus = 2   ;Mit Rekursion 
  EndIf 
  
  If ExamineDirectory(Rekursion, Dir, "") 
    Repeat 
      Typ = NextDirectoryEntry(Rekursion) 
      Name = DirectoryEntryName(Rekursion) 
      If Name <> ".." And Name <> "." 
        Name = Dir + Name 
        flags = GetFileAttributes_(Name) 
        SetFileAttributes_(Name, flags & ~#FILE_ATTRIBUTE_READONLY) 
        Select Typ 
          Case 2  ;Verzeichnis 
            If Modus = 2 
              SetReadOnlyFlagOff(Name + "\", Rekursion + 1) 
            EndIf 
        EndSelect 
      EndIf 
    Until Typ = 0 
  EndIf 
EndProcedure 

SetReadOnlyFlagOff("d:\lieder\cover", 0)   ; define here the path, for which the "ReadOnly" should be removed

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
