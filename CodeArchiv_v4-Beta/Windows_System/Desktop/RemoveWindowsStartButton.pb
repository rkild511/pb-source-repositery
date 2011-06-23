; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown
; Date: 09. December 2003
; OS: Windows
; Demo: No

handle=FindWindow_("Shell_TrayWnd",0) 
If handle 
  handle=GetWindow_(handle,#GW_CHILD) 
  If handle 
    class$=Space(1024): 
    GetClassName_(handle,@class$,Len(class$)) 
    If Left(class$,Len(class$))="Button" 
      PostMessage_(handle,#WM_CLOSE,0,0) 
    EndIf 
  EndIf 
EndIf 

;TrayNotifyWnd
;ReBarWindow32
;MSTaskSwClass
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -