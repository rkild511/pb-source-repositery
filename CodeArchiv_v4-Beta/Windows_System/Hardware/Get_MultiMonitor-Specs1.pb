; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8273&highlight=
; Author: blueznl
; Date: 10. November 2003
; OS: Windows
; Demo: No

#SM_XVIRTUALSCREEN        = 76        ; x-coordinate of left upper corner of total display area 
#SM_YVIRTUALSCREEN        = 77        ; same for y 
#SM_CXVIRTUALSCREEN       = 78        ; width 
#SM_CYVIRTUALSCREEN       = 79        ; height 
#SM_CMONITORS             = 80        ; number of monitors 
#SM_SAMEDISPLAYFORMAT     = 81        ; identical sizing of all screens 

#MONITOR_DEFAULTTONULL    = 0 
#MONITOR_DEFAULTTOPRIMARY = 1 
#MONITOR_DEFAULTTONEAREST = 2 
                
Debug "nr of screens:" 
Debug GetSystemMetrics_(#SM_CMONITORS) 
Debug "same format or not:" 
Debug GetSystemMetrics_(#SM_SAMEDISPLAYFORMAT) 
Debug "desktop size" 
Debug GetSystemMetrics_(#SM_CXVIRTUALSCREEN) 
Debug GetSystemMetrics_(#SM_CYVIRTUALSCREEN) 
Global NewList monitor_hnd.l() 

Procedure cb_test(WindowID, Message, wParam, lParam) 
  Result = #PB_ProcessPureBasicEvents 
  ; 
  AddElement(monitor_hnd()) 
  monitor_hnd() = WindowID 
  ; 
  ProcedureReturn Result 
EndProcedure 

Debug "enum" 
Debug EnumDisplayMonitors_(0,0,@cb_test(),0) 

Debug "handle of primary monitor:" 
primary_hnd.l = MonitorFromPoint_(0,0,#MONITOR_DEFAULTTOPRIMARY) 
Debug primary_hnd 

Structure MONITORINFO 
  Size.l 
  m_x1.l 
  m_y1.l 
  m_x2.l 
  m_y2.l 
  w_x1.l 
  w_y1.l 
  w_x2.l 
  w_y2.l 
  flags.l 
EndStructure 

info.MONITORINFO 

info\Size = SizeOf(MONITORINFO) 
info\flags = 0 

n.l = 0 
ResetList(monitor_hnd()) 
While NextElement(monitor_hnd()) 
  INC n 
  Debug "monitor, handle, origin and size:" 
  Debug n 
  Debug monitor_hnd() 
  GetMonitorInfo_(monitor_hnd(),@info) 
  Debug info\m_x1 
  Debug info\m_y1 
  Debug info\m_x2 - info\m_x1 
  Debug info\m_y2 - info\m_y1 
Wend  

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableAsm
