; English forum:
; Author: PB
; Date: 21. January 2003
; OS: Windows
; Demo: No

;GetKey() routine by PB -- do what you want with it. :)
; Obviously it can be expanded to handle more keys...
; Function: Waits for a keypress and returns ASCII code of the key.
; Usage: c=GetKey() ; c = ASCII value of pressed key.
;
For k=8 To 13 : GetAsyncKeyState_(k) : Next ; Clear backspace, tab, enter buffers.
For k=48 To 57 : GetAsyncKeyState_(k) : Next ; Clear number key buffers.
For k=65 To 90 : GetAsyncKeyState_(k) : Next ; Clear letter key buffers.
; Clear key buffers of other keys.
GetAsyncKeyState_(#VK_SPACE)
GetAsyncKeyState_(#VK_ESCAPE)
;
Procedure GetKey()
  Repeat
    Sleep_(1) ; To stop 100% CPU usage.
    For k=8 To 13 ; Check backspace, tab, enter keys.
      If GetAsyncKeyState_(k)=-32767 : r=k : EndIf ; Pressed!
    Next 
    For k=48 To 57 ; Check number keys.
      If GetAsyncKeyState_(k)=-32767 : r=k : EndIf ; Pressed!
    Next 
    For k=65 To 90 ; Check letter keys.
      If GetAsyncKeyState_(k)=-32767 : r=k : EndIf ; Pressed!
    Next
    ; Check other keys (add more here if you like).
    If GetAsyncKeyState_(#VK_SPACE)=-32767 : r=32 : EndIf ; Space pressed.
    If GetAsyncKeyState_(#VK_ESCAPE)=-32767 : r=27 : EndIf ; Escape pressed.
    Until r<>0
  ProcedureReturn r
EndProcedure
;
Debug "Type something!"
;
Repeat
  c=GetKey() ; Pause app until a key has been pressed.
  Debug Str(c)+" "+Chr(c) ; Display ASCII code of pressed key.
Until c=27 ; Quit due to Escape being pressed.
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -