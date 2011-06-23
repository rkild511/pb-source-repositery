; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2437&highlight=
; Author: zomtex2003
; Date: 02. October 2003
; OS: Windows
; Demo: Yes

; Checks, if the given date (first parameter) lies between StartDate and EndDate
Procedure.l IsDateInSpace(*CheckDate.Byte, *StartDate.Byte, *EndDate.Byte) 
  Protected lCheckDate.l, lStartDate.l, lEndDate.l 
  If MemoryStringLength(*CheckDate) = 6 And MemoryStringLength(*StartDate) = 6 And MemoryStringLength(*EndDate) = 6 
    lCheckDate = Val(Right(PeekS(*CheckDate), 2) + Mid(PeekS(*CheckDate), 3, 2) + Left(PeekS(*CheckDate), 2)) 
    lStartDate = Val(Right(PeekS(*StartDate), 2) + Mid(PeekS(*StartDate), 3, 2) + Left(PeekS(*StartDate), 2)) 
    lEndDate   = Val(Right(PeekS(*EndDate), 2)   + Mid(PeekS(*EndDate), 3, 2)   + Left(PeekS(*EndDate), 2)) 
    If lCheckDate <= lEndDate And lCheckDate >= lStartDate 
      ProcedureReturn 1 
    EndIf 
  Else 
    ProcedureReturn -1 
  EndIf 
  ProcedureReturn 0 
EndProcedure 

Debug IsDateInSpace(@"140903", @"010903", @"011003") ; Gibt 1 zurück, weil der 14.09.03 zwischen dem 01.09.03 und dem 01.10.03 liegt 

Debug IsDateInSpace(@"021003", @"010903", @"011003") ; Gibt 0 zurück, weil der 02.10.03 nicht zwischen dem 01.09.03 und 01.10.03 liegt 

Debug IsDateInSpace(@"11003", @"010903", @"011003") ; Gibt -1 zurück, weil 11003 kein gültiges Datumsformat ist 

; Hinweis: es wird nicht erkannt ob es das Datum gibt, oder ob es überhaupt ein Datum ist! Das muß extra geprüft werden! 



; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
