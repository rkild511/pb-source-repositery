; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2109&highlight=
; Author: Stefan Moebius (updated for PB4.00 by blbltheworm)
; Date: 28. August 2003
; OS: Windows
; Demo: No


; Use Windows system color as background color for EditorGadget...

; Problemstellung: Wie kann ich die Farbe eines Editorgadget's ändern, damit das Gadget
;                  und das Fenster die gleiche Farbe haben?





OpenWindow(1,0,0,400,300,"Fenster",1|#WS_SYSMENU) 

CreateGadgetList(WindowID(1)) 
Editor=EditorGadget(1,0,0,WindowWidth(1)/2,WindowHeight(1)/2) 

SendMessage_(Editor,#EM_SETBKGNDCOLOR,0,GetSysColor_(GetClassLong_(WindowID(1),#GCL_HBRBACKGROUND)-1)) 

Repeat:Until WaitWindowEvent()=#WM_CLOSE 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
