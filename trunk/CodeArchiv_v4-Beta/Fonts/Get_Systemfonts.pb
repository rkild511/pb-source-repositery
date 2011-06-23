; English forum: 
; Author: Unknown
; Date: 21. January 2003
; OS: Windows
; Demo: No

Procedure EnumFontFamProc(*lpelf.ENUMLOGFONT, *lpntm.NEWTEXTMETRIC, FontType, lParam) 
  Debug PeekS(@*lpelf\elfLogFont\lfFaceName[0]) 
  ProcedureReturn 1 
EndProcedure 

Procedure SysInfo_Fonts() 
  hWnd = GetDesktopWindow_() 
  hDC = GetDC_(hWnd) 
  EnumFontFamilies_(hDC, 0, @EnumFontFamProc(), 0) 
  ReleaseDC_ (hWnd, hDC) 
EndProcedure 

SysInfo_Fonts() 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -