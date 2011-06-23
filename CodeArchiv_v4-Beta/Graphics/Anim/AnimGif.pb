; English forum:
; Author: PB (updated for PB4.00 by blbltheworm)
; Date: 21. January 2003
; OS: Windows
; Demo: No

; Updated by Andre / 16-May-2005 to work with relative paths


; Example of an AnimGIF inside a window.
; By PB -- do whatever you want with it.
;
; IMPORTANT: Read PureBasic's requirements for WebGadgets!
;

FileName$="..\gfx\anim_surprize.gif" 
; with this routine we can get the needed full path for the WebGadget
Buffer$=Space(512) 
GetFullPathName_(FileName$,Len(Buffer$),@Buffer$,@FilePart) 
animgif$ = PeekS(@Buffer$) 

If OpenWindow(0,200,200,450,200,"Test",#PB_Window_SystemMenu)
  CreateGadgetList(WindowID(0))
  ; animgif$="..\gfx\anim_surprize.gif" ; You *must* specify the full path to the animgif for this to work!
  
  url$="about:<html><body scroll='no' leftmargin='0' topmargin='0'><img src='"+animgif$+"'></img></body></html>"
  WebGadget(0,50,20,100,150,url$)
  Repeat
    ev=WaitWindowEvent()
  Until ev=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -