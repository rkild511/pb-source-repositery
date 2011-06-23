; English forum: http://www.purebasic.fr/english/viewtopic.php?t=28015#28015
; Author: Fred (addition by GPI & Andre)
; Date: 15. June 2003
; OS: Windows
; Demo: No

  Buffer$=Space(10000):BufferSize=Len(Buffer$)-1

  If GetVersion_() & $ff0000 ; Windows NT/XP 

    If RegOpenKeyEx_(#HKEY_CLASSES_ROOT, "Applications\PureBasic.exe\shell\open\command", 0, #KEY_ALL_ACCESS , @Key) = #ERROR_SUCCESS 
      If RegQueryValueEx_(Key, "", 0, @Type, @Buffer$, @BufferSize) = #ERROR_SUCCESS 
        OutputDirectory$ = GetPathPart(Mid(Buffer$, 2, Len(Buffer$)-7)) 
      EndIf 
    EndIf 
    
  Else  ; The same for Win9x 
  
    If RegOpenKeyEx_(#HKEY_LOCAL_MACHINE, "Software\Classes\PureBasic.exe\shell\open\command", 0, #KEY_ALL_ACCESS , @Key) = #ERROR_SUCCESS 
      If RegQueryValueEx_(Key, "", 0, @Type, @Buffer$, @BufferSize) = #ERROR_SUCCESS 
        OutputDirectory$ = GetPathPart(Mid(Buffer$, 2, Len(Buffer$)-7)) 
      EndIf 
    EndIf 
    
  EndIf 

  Debug OutputDirectory$
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
