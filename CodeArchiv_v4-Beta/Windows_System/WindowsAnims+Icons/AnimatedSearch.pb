; English forum: 
; Author: Justin (updated for PB4.00 by blbltheworm)
; Date: 21. September 2002
; OS: Windows
; Demo: No


;Avi Animation
;http://msdn.microsoft.com/library/en-us/shellcc/platform/commctls/animation/animation.asp

sysdir$=Space(255)
GetSystemDirectory_(@sysdir$,255)
If Right(sysdir$,1)<>"\" : sysdir$=sysdir$+"\" : EndIf

hshell=LoadLibrary_(sysdir$ + "shell32.dll")

hwnd=OpenWindow(1,100,100,300,300,"Avi Animation",#PB_Window_SystemMenu)
CreateGadgetList(hwnd)

hanim=CreateWindowEx_(0,"SysAnimate32","",#ACS_CENTER|#ACS_TRANSPARENT|#WS_CHILD|#WS_VISIBLE,10,10,70,70,hwnd,0,GetModuleHandle_(0),0)

SendMessage_(hanim,#ACM_OPEN,hshell,150) 

ButtonGadget(2,10,250,80,20,"Start") 
ButtonGadget(3,200,250,80,20,"Stop") 

DisableGadget(3,1)

Repeat
event=WaitWindowEvent()
If event=#PB_Event_Gadget
Select EventGadget()
Case 2 ;Start
SendMessage_(hanim,#ACM_PLAY,-1,0|-1)
DisableGadget(2,1)
DisableGadget(3,0)

Case 3 ;Stop
SendMessage_(hanim,#ACM_STOP,0,0)
DisableGadget(2,0)
DisableGadget(3,1)

EndSelect
EndIf
Until event=#PB_Event_CloseWindow

FreeLibrary_(hshell)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP