; German forum: http://www.purebasic.fr/german/viewtopic.php?t=10149
; Author: AND51
; Date: 3. October 2006
; OS: Windows
; Demo: Yes

; Older code by freak removed and new PB v4 compatible code added

Procedure.q GetDirectorySize(path.s, size.q=0) 
   Protected dir.l=ExamineDirectory(#PB_Any, path, "") 
   If dir 
      While NextDirectoryEntry(dir) 
         If DirectoryEntryType(dir) = #PB_DirectoryEntry_File 
            size+DirectoryEntrySize(dir) 
         ElseIf Not DirectoryEntryName(dir) = "." And  Not DirectoryEntryName(dir) = ".." 
            GetDirectorySize(path+DirectoryEntryName(dir)+"\", size) 
         EndIf 
      Wend 
      FinishDirectory(dir) 
   EndIf 
   ProcedureReturn size 
EndProcedure 

; If you call this procedure, leave out the second parameter! 
; Returning value will be a quad; this value is the size of the directory and its subdirectories in bytes. 
Debug GetDirectorySize("C:\Windows\")

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -