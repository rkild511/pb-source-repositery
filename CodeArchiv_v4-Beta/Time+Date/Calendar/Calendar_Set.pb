; English forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 21. June 2003
; OS: Windows
; Demo: No

; ------- Calendar Setup ------ 
#MCM_GETCURSEL=$1001 
#MCM_SETDAY=4098 
MyCal.INITCOMMONCONTROLSEX 
MyCal\dwSize=8 
MyCal\dwICC=$100 
InitCommonControlsEx_(@MyCal) 
; ----------------------------- 
; 
OpenWindow(0,100,200,400,200,"Date Pick Example",#PB_Window_SystemMenu|#PB_Window_SizeGadget) 
; 
datepick=CreateWindowEx_(0,"SysDateTimePick32","DateTime",#WS_CHILD|#WS_VISIBLE|4,10,10,200,25,WindowID(0),0,GetModuleHandle_(0),0) 
; 
Repeat 
  EventID=WaitWindowEvent() 
  newdate$=Space(255) : GetWindowText_(datepick,newdate$,255) 
  If newdate$<>prevdate$ 
    prevdate$=newdate$ 
    Debug "" : Debug "String = "+newdate$ 
    SendMessage_(datepick,#MCM_GETCURSEL,0,@time.SYSTEMTIME) 
    CalD=time\wDay : CalM=time\wMonth : CalY=time\wYear 
    time\wDay=1:time\wMonth=5:time\wYear =2004 
    SendMessage_(datepick,#MCM_SETDAY,0,time) 
    Debug "D, M, Y = "+Str(CalD)+", "+Str(CalM)+", "+Str(CalY) 
  EndIf 
Until EventID=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP