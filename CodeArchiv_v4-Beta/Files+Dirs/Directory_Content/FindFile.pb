; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1892&highlight=
; Author: dige (extended + updated for PB 4.00 by Andre)
; Date: 03. February 2005
; OS: Windows
; Demo: Yes

; FindFile: recursice file search

; FindFile : Rekursive Datei-Suche 
; by DiGe german forum 03/02/2005 

Procedure.s FindFile ( Directory.s, File.s ) 
  found = #False
  DirNr = ExamineDirectory( #PB_Any, Directory, "*.*" ) 
  If DirNr 
    Repeat 
      Ergebnis = NextDirectoryEntry(DirNr) 
      If Ergebnis = 1 
        If File = DirectoryEntryName(DirNr) 
          Debug "Gefunden in : " + Directory
          ProcedureReturn Directory 
          found = #True
        EndIf 
      ElseIf Ergebnis = 2 And DirectoryEntryName(DirNr) <> ".." And DirectoryEntryName(DirNr) <> "." 
        FindFile ( Directory + "\" + DirectoryEntryName(DirNr) , File.s ) 
      EndIf 
    Until Ergebnis = 0 
  EndIf 
  If found = #False
    ProcedureReturn "NOT FOUND"
  EndIf
EndProcedure 


Debug FindFile( "C:\Windows", "notepad.Exe" ) 

; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 34
; Folding = -