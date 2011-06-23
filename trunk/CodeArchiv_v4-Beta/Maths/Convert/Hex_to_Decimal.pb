; English forum: 
; Author: Unknown
; Date: 21. January 2003
; OS: Windows
; Demo: Yes

Procedure.l Hex2Dec(h$)
  h$=UCase(h$)
  For r=1 To Len(h$)
    d<<4 : a$=Mid(h$,r,1)
    If Asc(a$)>60
      d+Asc(a$)-55
    Else
      d+Asc(a$)-48
    EndIf
  Next
  ProcedureReturn d
EndProcedure
;
Debug Hex2Dec("FF")
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; Executable = C:\GeoWorld\GeoWorld\Data\CityViewer.exe