; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: No

Repeat
  If GetAsyncKeyState_(#VK_LBUTTON)
    Beep_(1400,200)
    While GetAsyncKeyState_(#VK_LBUTTON) :Wend
  EndIf
  If GetAsyncKeyState_(#VK_RBUTTON)
    Beep_(1400,200)
    While GetAsyncKeyState_(#VK_RBUTTON) :Wend
  EndIf
  If GetAsyncKeyState_(#VK_MBUTTON)
    Beep_(1400,200)
    While GetAsyncKeyState_(#VK_MBUTTON) :Wend
  EndIf
  If GetAsyncKeyState_(#VK_ESCAPE)
    End
  EndIf
  Delay(1)
ForEver

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -