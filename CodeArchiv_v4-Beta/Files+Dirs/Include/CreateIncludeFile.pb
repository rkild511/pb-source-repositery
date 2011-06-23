; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: Yes

#IncludeFile = 1 

Procedure CreateIncludeFile(Name.s, *StartFile, *EndFile) 
  If CreateFile(#IncludeFile, Name) 
    WriteData(#IncludeFile,*StartFile, *EndFile - *StartFile) 
    CloseFile(#IncludeFile) 
    ProcedureReturn #True 
  EndIf 
  ProcedureReturn #False 
EndProcedure 

CreateIncludeFile("test.txt2", ?StartFile_frunlog, ?EndFile_frunlog) 

DataSection 
  StartFile_frunlog: 
    IncludeBinary "test.txt" 
  EndFile_frunlog: 
EndDataSection

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -