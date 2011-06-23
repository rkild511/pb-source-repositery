; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=610&start=0&postdays=0&postorder=asc&highlight=
; Author: Froggerprogger
; Date: 14. April 2003
; OS: Windows
; Demo: Yes

Datum.s = "2003-04/14:17LLL45TRENN24" 
a = ParseDate("%yyyy-%mm/%dd:%hhLLL%iiTRENN%ss", Datum) 
Debug a 
b.s = FormatDate("%hh:%ii:%ss am %dd.%mm im Jahr %yyyy", a) 
Debug b
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
