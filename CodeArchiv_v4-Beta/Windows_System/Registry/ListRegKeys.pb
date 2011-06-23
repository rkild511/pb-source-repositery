; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13880&highlight=
; Author: GedB
; Date: 01. February 2005
; OS: Windows
; Demo: No

idx = 0 
NetBTKeyName.s = "SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces\" 
NetBTKeyHandle.l = 0 
Debug RegOpenKeyEx_(#HKEY_LOCAL_MACHINE, @NetBTKeyName, 0, #KEY_READ, @NetBTKeyHandle) 

Debug NetBTKeyHandle 
keyLength = 255 
keyname.s = Space(keyLength) 
idx = 0 
While RegEnumKeyEx_(NetBTKeyHandle, idx, @keyname, @keyLength, 0, 0, 0, 0) = 0 
  Debug keyname 
  idx + 1 
  keyLength = 255 
Wend 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -