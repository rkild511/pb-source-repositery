; English forum: http://www.purebasic.fr/english/viewtopic.php?t=5904
; Author: Sebi (updated for PB4.00 by blbltheworm)
; Date: 18. April 2003
; OS: Windows
; Demo: Yes

Procedure.s SeekFile(directory.s , filename.s, extension.s , directoryid.l )
  If Right(directory,1)<>"\"
    directory+"\"
  EndIf
  
  ExamineDirectory(directoryid,directory,"*.*")
    While NextDirectoryEntry(directoryid)
      fType=FileSize(directory+DirectoryEntryName(directoryid))
      If fType>0
          File.s=DirectoryEntryName(directoryid)
          this_extension.s=LCase(GetExtensionPart(File))
          this_filename.s=LCase(Left(File,Len(File)-Len(this_extension)))
          If Len(this_extension)
            this_filename=Left(this_filename,Len(this_filename)-1)
          EndIf
          If this_extension=extension Or extension="*"
            If this_filename=filename Or filename="*"
              File.s=directory+DirectoryEntryName(directoryid)    
              ProcedureReturn File
            EndIf
          EndIf
        ElseIf fType=-2
          If DirectoryEntryName(directoryid)<>"." And DirectoryEntryName(directoryid)<>".."     
            File.s=SeekFile(directory+DirectoryEntryName(directoryid)+"\",filename,extension,directoryid+1)      
            If File<>""
              ProcedureReturn File
            EndIf
          EndIf
      EndIf
    Wend
  ProcedureReturn ""
EndProcedure

Debug "kernel32.dll is at"
Debug SeekFile("c:\","kernel32","dll",0)   ; the last parameter should be zero
Debug "---"

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
