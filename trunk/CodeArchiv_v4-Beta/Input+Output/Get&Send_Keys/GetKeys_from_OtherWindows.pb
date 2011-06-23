; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8366&highlight=
; Author: PB
; Date: 16. November 2003
; OS: Windows
; Demo: No

; Note: Kill the exe with the Debugger!

; Question: I am trying to record key strokes from another window (which has the
;           focus) in a PureBasic program i have running in the background. 
; Answer:   This is kind of messy (because it may miss some keystrokes) but seems 
;           okay for general use. It's a short example that shows how to check if
;           the 'A' key was pressed in another app. #VK_A is the code for the A key. 
;           All other key codes are listed at the following URL: 
;           http://www.bsdg.org/swag/DELPHI/0234.PAS.html 

For r=0 To 255 : GetAsyncKeyState_(r) : Next ; Prepare all key buffers for capture. 
Repeat 
  Sleep_(1) 
  If GetAsyncKeyState_(#VK_A)=-32767 ; Check if 'A' was pressed. 
    Debug "'A' was pressed" 
  EndIf 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
