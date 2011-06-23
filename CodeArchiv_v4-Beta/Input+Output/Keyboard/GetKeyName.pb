; English forum: 
; Author: PB 
; Date: 21. January 2003 
; OS: Windows 
; Demo: No 


; GetKeyName() procedure by PB -- do what you want with it. :)
; Returns the name of a key, given its ASCII value, for the current locale.
; Usage: name$=GetKeyName(ascii) ; ascii = Ascii code of desired key.
;
Procedure.s GetKeyName(ascii)
  name$=Space(255) ; Prepare string to hold name of the desired key.
  GetKeyNameText_(MapVirtualKey_(ascii,0)*$10000,name$,255) ; Get key name.
  ProcedureReturn name$
EndProcedure
;
Debug GetKeyName(#VK_END)
Debug GetKeyName(#VK_HOME)
Debug GetKeyName(#VK_SHIFT)
Debug GetKeyName(#VK_ESCAPE)
Debug GetKeyName(9) ; 9 = Tab key.
Debug GetKeyName(13) ; 13 = Enter key.
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -