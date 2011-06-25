
;*****************************************************************************
;*
;* Name   : Littlest Magnifier - Mark 2
;* Author : rrpl (much help from Trond in shrinking the code)
;* Date   : 23 June 09
;* Notes  : Change magnification using up/down arrows
;*
;*****************************************************************************
w=600:h=150:OpenWindow(0,0,30,w,h,"Littlest Magnifier",#PB_Window_SystemMenu)
StickyWindow(0,1):M=3:ImageGadget(0,0,0,w,h,0):AddKeyboardShortcut(0,38,1)
AddKeyboardShortcut(0,40,2):While a<>16:a=WindowEvent():c.point
GetCursorPos_(c):Gosub S:n=ResizeImage(0,w,h):SetGadgetState(0,n)
If a=#PB_Event_Menu:b=EventMenu():If b=1 And M<10:M=M+1:ElseIf b=2 And M>2
M=M-1:EndIf:EndIf:Delay(50):Wend:End:S:CreateImage(0,w/M,h/M)
hd=StartDrawing(ImageOutput(0)):D=GetDC_(0)
BitBlt_(hd,0,0,w/M,h/M,D,c\x,c\y,#SRCCOPY):StopDrawing():ReleaseDC_(0,D)
Return

; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 18
; DisableDebugger