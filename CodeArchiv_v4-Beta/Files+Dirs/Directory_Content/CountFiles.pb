; German forum: http://www.purebasic.fr/german/viewtopic.php?t=3626&highlight= 
; Author: benny (updated for PB 4.00 by HeX0R) 
; Date: 09. June 2005 
; OS: Windows 
; Demo: Yes 


; Count all files in a directory (incl. sub-dirs) 
; Alle Dateien in einem Verzeichnis (inkl. Unterverzeichnissen) zählen 

Procedure.l CountFiles(Dir.s) 
   Protected ID.l, files.l 

   If Right(Dir, 1) <> "\" 
      Dir + "\" 
   EndIf 

   ID = ExamineDirectory(#PB_Any, Dir, "") 
   If ID 
      While NextDirectoryEntry(ID) 
         Select DirectoryEntryType(ID) 
            Case 0 
               Break 
            Case #PB_DirectoryEntry_File 
               files + 1 
            Case #PB_DirectoryEntry_Directory 
               If DirectoryEntryName(ID) <> "." And DirectoryEntryName(ID) <> ".." 
                  files + CountFiles(Dir + DirectoryEntryName(ID)) 
               EndIf 
         EndSelect 
      Wend 
   EndIf 

   ProcedureReturn files 
EndProcedure 

Dir.s = PathRequester("Pfad auswählen...", "C:\") 

If Dir 
   files.l = CountFiles(Dir) 
   MessageRequester(Dir, "Das Verzeichnis enthält " + Str(files) + " Dateien und Verzeichnisse.") 
EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger