
Macro SUBLANGID(lgid)
  ((lgid)>>10)
EndMacro

Macro PRIMARYLANGID(lgid)
  ((lgid)&$3FF)
EndMacro

Macro MAKELANGID(primary, sublang)
  (((sublang)<<10)|(primary))
EndMacro

Macro MAKELONG(loWord, hiWord)
  ( hiWord << 16 | loWord )
EndMacro

Macro MAKELPARAM(loWord, hiWord)
  MAKELONG(loWord, hiWord)
EndMacro

Macro MAKEWPARAM(loWord, hiWord)
  MAKELONG(loWord, hiWord)
EndMacro

Macro MAKELRESULT(loWord, hiWord)
  MAKELONG(loWord, hiWord)
EndMacro

Macro MAKEINTRESOURCE(int)
  "#" + Str(int)
EndMacro

Macro LOWORD(value)
  (value & $FFFF)
EndMacro

Macro HIWORD(value)
  ((value >> 16) & $FFFF)
EndMacro

Macro MAX(value1, value2)
  (((value1 > value2) * value1) + ((value2 > value1) * value2))
EndMacro

Macro MIN(value1, value2)
  (((value1 < value2) * value1) + ((value2 < value1) * value2))
EndMacro

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ---
; EnableXP
; HideErrorLog