; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown
; Date: 11. December 2003
; OS: Windows
; Demo: No

Procedure RefreshDesktopIcons()
  #SHCNF_IDLIST = $0 
  #SHCNE_ASSOCCHANGED = $8000000 
  SHChangeNotify_ (#SHCNE_ASSOCCHANGED, #SHCNF_IDLIST, #Null, #Null) 
EndProcedure

RefreshDesktopIcons()

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -