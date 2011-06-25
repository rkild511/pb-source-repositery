;*****************************************************************************
;*
;* Name   : Pure Punch 2 Validator
;* Author : rrpl
;* Date   : 23 June 09
;* Notes  : Paste Code into Pure Punch 2 Validator, click on Check
;*
;*****************************************************************************
l=10:w=500:h=400:OpenWindow(0,0,30,w,h,"PP Validator",#PB_Window_SystemMenu)
c=80:EditorGadget(0,0,0,w,h-35):SetGadgetText(0,";Paste Code Here"):r.s=#CRLF$
ButtonGadget(1,25,h-30,100,25,"Check"):u.s=r+";Total Lines =":While a<>16:
a=WindowEvent():If a=#PB_Event_Gadget:If EventGadget()=1:Gosub v:EndIf:EndIf
Delay(9):Wend:End:v:For i=0 To CountGadgetItems(0)-1:s.s=GetGadgetItemText(0,i)
s=Trim(s):If s<>"":If Left(s,1)<>";":n=n+1:If Len(s)<81:Else:t.s=t+Str(n)+";"
EndIf:EndIf:EndIf:Next:If n<11 And t="":m.s=";":For j=1 To 77:m=m+"*":Next
m=m+r:o.s="Valid for Pure Punch 2":m=m+";PP2 Validator : Above code is "
AddGadgetItem(0,-1,m+o+u+Str(n)):Else:If t<>"":q.s="; Check Line/s ":EndIf
AddGadgetItem(0,-1,m+"NOT "+o+u+Str(n)+q+t):EndIf:n=0:t="":Return

; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 11
; DisableDebugger