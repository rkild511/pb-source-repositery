; English forum:
; Author: Franco (updated for PB4.00 by blbltheworm)
; Date: 31. December 2001
; OS: Windows
; Demo: Yes

; (c) 2001 - Franco's template - absolutely freeware
; use the about box of windows for your application...
; you can use your own icon, change the path and file name...
; the only thing is I can't set the position of these about box

; If you have WinXP -> all images are resized to a fixed square!


; IncludeFile "AboutImageRequester.pbi"    ; you can use the include file, instead of the following procedure
Procedure AboutImageRequester(WindowID.l,Title$,Text1$,Text2$,Image$)
  LoadImage(1, Image$) : Image.l=ImageID(1) : ShellAbout_(WindowID, Title$+" # "+Text1$, Text2$, Image)
EndProcedure

If OpenWindow (0,200,200, 420, 380, "About", #PB_Window_SystemMenu) 
  AboutImageRequester(WindowID(0),"Whatever","Operating System", "What you want...","pb_big.ico")
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger