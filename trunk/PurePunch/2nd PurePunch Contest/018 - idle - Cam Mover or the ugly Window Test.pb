 ;*****************************************************************************
;*
;* Name   :Cam Mover or the ugly Window Test:
;* Author :idle - andrew ferguson
;* Date   :24/06/2009
;* Notes  :windows 32bit only
;*        :hit esc To quit
;*        :If the webcam isn't set at 320 x 240 remove the comment on line 9
;*        :Don't set it less than 320 x 240 
;*        ;If your system can't find avicap32.dll add this string to the openlibary command 
;*        :system drive "C:\Windows\system32\avicap32.dll" 
;*****************************************************************************
OpenLibrary(1,"avicap32.dll"):*p=GetFunction(1,"capCreateCaptureWindowW")
ExamineDesktops():Global q=DesktopWidth(0),z=DesktopHeight(0),w=320,h=240,t,n,e
Macro sm(b,c,d):SendMessage_(n,b,c,d):EndMacro:Global lx.f,ly.f,dx,dy,f=z/2-h/2
Procedure FC(j,*v.long):*r.long=*v\l+3:sx.f:sy.f:a.f:While d<230400:y=d%w:x=d/w
c=*r\l:sx+x*c:sy+y*c:a+c:d+3:*r+3:Wend:If t>20:dx=(sx/a)-lx:dy=(sy/a)-ly:Else
lx=(sx/a):ly=(sy/a):t+1:EndIf:e+dx:f+dy:If e<0:e=0:ElseIf e>q-w:e=q-w:EndIf
If f<0:f=0:ElseIf f>z-h:f=z-h:EndIf:ResizeWindow(0,e,f,w,h):EndProcedure:s.s 
u=OpenWindow(0,0,0,w,h,s,$CA0001):n=CallFunctionFast(*p,s,1<<28*5,0,0,w,h,u,0)
e=q/2-w/2:Sm(1034,0,0):sm(1076,60,0):sm(1074,1,0):sm(1029,0,@FC());sm(1065,0,0)
Repeat:Until WaitWindowEvent()=16 Or GetAsyncKeyState_(#VK_ESCAPE)&$1

; IDE Options = PureBasic 4.31 (Windows - x86)
; Folding = -
; DisableDebugger