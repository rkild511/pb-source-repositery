; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown
; Date: 22. November 2003
; OS: Windows
; Demo: No

If RegCreateKeyEx_(#HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion\Run", 0, 0, #REG_OPTION_NON_VOLATILE, #KEY_ALL_ACCESS, 0, @NewKey, @KeyInfo) = #ERROR_SUCCESS 
  StringBuffer$ = Path     ; change Path to a string with the full path to your program!!!
  RegSetValueEx_(NewKey, "Programname", 0, #REG_SZ,  StringBuffer$, Len(StringBuffer$)+1)   ; change "Programname" to your individual name
  RegCloseKey_(NewKey) 
EndIf
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -