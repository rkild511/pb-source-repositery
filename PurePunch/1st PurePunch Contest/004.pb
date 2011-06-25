;*****************************************************************************
;* PurePunch Contest 
;* http://www.purebasic.fr/english/viewtopic.php?p=256341#256341
;*
;* Author : Derek
;* Date : Tue Aug 26, 2008
;* Link : http://www.purebasic.fr/english/viewtopic.php?p=256579#256579
;*
;*****************************************************************************
ExamineDesktops():w=DesktopWidth(0):h=DesktopHeight(0)
i=CreateImage(0,w,h) :hDC=StartDrawing(ImageOutput(0))
Ddc=GetDC_(GetDesktopWindow_()):BitBlt_(hDC,0,0,w,h,DDC,0,0,#SRCCOPY)
StopDrawing() :ReleaseDC_(GetDesktopWindow_(),DDC)
OpenWindow(0,0,0,w,h,"",#PB_Window_BorderLess):CreateGadgetList(WindowID(0))
ImageGadget(0,0,0,w,h,ImageID(0)):Dim x(w-1):For n=0 To w-1 
x(n)=-1:Next:f=0:Repeat:For n=1 To w:r=Random(w-1)
If x(r)<h:StartDrawing(ImageOutput(0)):x(r)=x(r)+1
Circle(r,x(r),7,255):StopDrawing():EndIf:If x(r)=h
f=1:EndIf:Next:SetGadgetState(0,ImageID(0))
WindowEvent():Until GetAsyncKeyState_(#VK_ESCAPE)Or f=1
