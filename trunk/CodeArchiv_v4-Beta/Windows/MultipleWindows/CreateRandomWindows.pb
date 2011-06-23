; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8747&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 15. December 2003
; OS: Windows
; Demo: No

w = GetSystemMetrics_(#SM_CXSCREEN) 
h = GetSystemMetrics_(#SM_CYSCREEN) 

For a = 1 To 100 
  OpenWindow(a,Random(w-200),Random(h-200),200,200,"Sprite "+Str(a),#PB_Window_SystemMenu) 
Next a 

Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
