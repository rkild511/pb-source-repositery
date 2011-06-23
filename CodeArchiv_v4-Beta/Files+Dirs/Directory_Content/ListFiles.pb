; English forum: http://www.purebasic.fr/english/viewtopic.php?t=5904
; Author: Sebi (updated for PB4.00 by blbltheworm & Andre)
; Date: 18. April 2003
; OS: Windows
; Demo: Yes

Procedure.s ListFiles(directory.s , filename.s, extension.s , directoryid.l )
  If Right(directory,1)<>"\"
    directory+"\"
  EndIf
  If ExamineDirectory(directoryid,directory,"*.*")
    dirid=NextDirectoryEntry(directoryid)
    While dirid
      dirtype = DirectoryEntryType(directoryid)
      Select dirtype
        Case #PB_DirectoryEntry_File
          file.s=DirectoryEntryName(directoryid)
          this_extension.s=LCase(GetExtensionPart(file))
          this_filename.s=LCase(Left(file,Len(file)-Len(this_extension)))
          If Len(this_extension)
            this_filename=Left(this_filename,Len(this_filename)-1)
          EndIf
          If this_extension=extension Or extension="*"
            If this_filename=filename Or filename="*"
              file.s=directory+DirectoryEntryName(directoryid)
              
              ;file contains the full path and filename
              ;you must insert here what to do with the file
              Debug file
                  
            EndIf
          EndIf
        Case #PB_DirectoryEntry_Directory
          If DirectoryEntryName(directoryid)<>"." And DirectoryEntryName(directoryid)<>".."     
            ListFiles(directory+DirectoryEntryName(directoryid)+"\",filename,extension,directoryid+1)      
          EndIf
      EndSelect
      dirid=NextDirectoryEntry(directoryid)
    Wend
  EndIf
  ProcedureReturn ""
EndProcedure

Debug "all txt-files in c:\windows\"
ListFiles("c:\windows","*","txt",0)      ; the last parameter should be zero
Debug ""

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
