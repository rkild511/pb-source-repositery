; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8932&highlight=
; Author: blueznl (updated for PB4.00 by blbltheworm)
; Date: 30. December 2003
; OS: Windows
; Demo: No


; purebasic survival guide 
; multi_monitor_2.pb - 30.12.2003 ejn (blueznl) 
; http://www.xs4all.nl/~bluez/datatalk/pure1.htm 
; 
; - how to detect multiple monitors and their relative position to each other 
; - EndumDisplayMonitors_() 
; - EnumDisplayDevices_() 
; - EnumDisplaySettings_() 
; - MonitorFromPoint_() 
; - GetMonitorInfo_() 
; 
; constants / structs for multi monitor handling 
; 
#SM_XVIRTUALSCREEN        = 76        ; x-coordinate of left upper corner of total display area 
#SM_YVIRTUALSCREEN        = 77        ; same for y 
#SM_CXVIRTUALSCREEN       = 78        ; width 
#SM_CYVIRTUALSCREEN       = 79        ; height 
#SM_CMONITORS             = 80        ; number of monitors 
#SM_SAMEDISPLAYFORMAT     = 81        ; identical sizing of all screens 
; 
#MONITOR_DEFAULTTONULL    = 0 
#MONITOR_DEFAULTTOPRIMARY = 1 
#MONITOR_DEFAULTTONEAREST = 2 
; 
#SM_XVIRTUALSCREEN        = 76        ; x-coordinate of left upper corner of total display area 
#SM_YVIRTUALSCREEN        = 77        ; same for y 
#SM_CXVIRTUALSCREEN       = 78        ; width 
#SM_CYVIRTUALSCREEN       = 79        ; height 
#SM_CMONITORS             = 80        ; number of monitors 
#SM_SAMEDISPLAYFORMAT     = 81        ; identical sizing of all screens 
; 
#DISPLAY_DEVICE_ATTACHED_TO_DESKTOP = $1 
#DISPLAY_DEVICE_MULTI_DRIVER        = $2 
#DISPLAY_DEVICE_PRIMARY_DEVICE      = $4 
#DISPLAY_DEVICE_MIRRORING_DRIVER    = $8 
#DISPLAY_DEVICE_VGA_COMPATIBLE      = $10 
#DISPLAY_DEVICE_REMOVABLE           = $20 
#DISPLAY_DEVICE_MODESPRUNED         = $8000000 
#DISPLAY_DEVICE_REMOTE              = $4000000 
#DISPLAY_DEVICE_DISCONNECT          = $2000000 
#DISPLAY_DEVICE_ACTIVE              = $1 
#DISPLAY_DEVICE_ATTACHED            = $2 
; 
#CCHDEVICENAME = 32 
#CCHFORMNAME = 32 
; 
#ENUM_CURRENT_SETTINGS = -1 
#ENUM_REGISTRY_SETTINGS = -2 
; 
#MONITOR_DEFAULTTONULL    = 0 
#MONITOR_DEFAULTTOPRIMARY = 1 
#MONITOR_DEFAULTTONEAREST = 2 
; 
Structure MONITORINFO                     ; used to retrieve monitor info 
  cb.l                                    ; size of structure (fill before using) 
  m_x1.l                                  ; rectangle, monitor coords x1/y1/x2/y2 
  m_y1.l 
  m_x2.l 
  m_y2.l 
  w_x1.l                                  ; rectangle, work area coords (?) 
  w_y1.l 
  w_x2.l 
  w_y2.l 
  flags.l 
EndStructure 
; 
Structure MONITORINFOEX                   ; superset of MONITORINFO with added  string for devicename 
  cb.l  
  m_x1.l 
  m_y1.l 
  m_x2.l 
  m_y2.l 
  w_x1.l 
  w_y1.l 
  w_x2.l 
  w_y2.l 
  flags.l 
  name.b[32]                              ; #CCHDEVICENAME = 32 
EndStructure 
; 
Structure x_monitorinfo                   ; used to store monitor info 
  n.l                                     ; sequential number 
  hnd.l                                   ; handle 
  x.l                                     ; x-position 
  y.l                                     ; y-position 
  w.l                                     ; width 
  h.l                                     ; height 
  d.l                                     ; colour depth (bits) 
  f.l                                     ; frequency  
  name.s                                  ; devicename (i want my fixed length strings!) 
  flags.l                                 ; status of the device 
EndStructure 
; 
Global x_retval.l, x_desktop.x_monitorinfo 
Global x_monitor_samedisplayformat.l 
Global x_monitor_n.l = 0                         ; number of monitors is... zero? :-) 

Global NewList x_monitor.x_monitorinfo()         ; info on monitors 
x_desktop.x_monitorinfo                   ; info on desktop 

Procedure x_monitor_monitorenumproc(WindowID, Message, wParam, lParam) 
  ; 
  ; store on each call the monitor handle in the x_monitor() list 
  ; called by windows in callback as set up in x_monitor_detect() by the api EnumDisplayMonitors_() 
  ; also known as MonitorEnumProc 
  ; 
  AddElement(x_monitor()) 
  x_monitor()\hnd = WindowID 
  ; 
  ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 

Procedure.l x_monitor_detect() 
  Protected info.MONITORINFOEX, device.DISPLAY_DEVICE, n.l 
  ; 
  ; *** detect number of screens and retrieve their properties 
  ; 
  ; in: 
  ; retval: 
  ; out:    x_monitor_n.l    - number of screens 
  ;         x_desktop_w.l    - desktop width 
  ;         x_desktop_h.l    - desktop height 
  ; 
  ; GetSystemMetrics_() 
  ; 
  ; provides quite a bit info on display adapters, screens etc. but does not provide info 
  ; per monitor / device on multi monitor setups 
  ; 
  ; x_monitor_n = GetSystemMetrics_(#SM_CMONITORS) 
  ; x_monitor_samedisplayformat.l = GetSystemMetrics_(#SM_SAMEDISPLAYFORMAT) 
  ; 
  x_desktop\w = GetSystemMetrics_(#SM_CXVIRTUALSCREEN) 
  x_desktop\h = GetSystemMetrics_(#SM_CYVIRTUALSCREEN) 
  ; 
  ; Debug "same display format on all screens (0 = no)" 
  ; Debug x_monitor_samedisplayformat 
  ; Debug "counted using getsystemmetrics" 
  ; Debug x_monitor_n 
  ; 
  ; EnumDisplayMonitors() 
  ; 
  ; returns monitors overlapping a given rectangle, including pseudo / mirror monitors! 
  ; after the call, for each monitor a handle will be stored in x_monitor()\hnd 
  ; this can be used to obtain more information using GetMonitorInfo_() 
  ; flags returned are different from EnumDisplayDevices() 
  ; 
  ; ClearList(x_monitor()) 
  ; EnumDisplayMonitors_(0,0,@x_monitor_monitorenumproc(),0)      ; call the function 
  ; info.MONITORINFOEX                                            ; create a struct for GetMonitorInfo_() 
  ; info\cb = SizeOf(info)                                        ; length of struct (important for MONITORINFO vs. MONITORINFOEX) 
  ; x_monitor_n = 0                                               ; nr. of monitors  
  ; ResetList(x_monitor())                                        ; reset and... 
  ; While NextElement(x_monitor())                                ; go through the list    
  ;   x_monitor_n = x_monitor_n+1 
  ;   x_monitor()\n = x_monitor_n                                 ; sequential number 
  ;   GetMonitorInfo_(x_monitor()\hnd,@info)                      ; get info on the monitor 
  ;   x_monitor()\x = info\m_x1 
  ;   x_monitor()\y = info\m_y1 
  ;   x_monitor()\w = info\m_x2 - info\m_x1 
  ;   x_monitor()\h = info\m_y2 - info\m_y1 
  ;   x_monitor()\name = PeekS(@info\name,32)                     ; i want my fixed length strings! 
  ; Wend  
  ; ; 
  ; Debug "counted using enumdisplaymonitors" 
  ; Debug x_monitor_n 
  ; 
  ; EnumDisplayDevices() 
  ; 
  ; walks through all available devices, retrieve names and flags 
  ; by using the returned flags all 'non-real' monitors can be filtered out 
  ; 
  device.DISPLAY_DEVICE                                         ; to store results from EnumDisplayDevices_() 
  device\cb = SizeOf(DISPLAY_DEVICE) 
  settings.DEVMODE                                              ; to store results from EnumDisplaySettings_() 
  settings\dmSize = SizeOf(settings)                            ; DEVMODE is declared in purebasic itself 
  settings\dmDriverExtra = 0 
  ; 
  ClearList(x_monitor()) 
  n.l = 0 
  x_monitor_n = 0        
  While EnumDisplayDevices_(0,n,@device,0) > 0      ; check all devices 
    n = n+1 
    ; 
    ; the StateFlags field in the filled struct contains information on the device / monitor 
    ; some values to check with (not all cards / drivers support all functions): 
    ; 
    ; #DISPLAY_DEVICE_ATTACHED_TO_DESKTOP - in use and part of the desktop 
    ; #DISPLAY_DEVICE_PRIMARY_DEVICE      - primary device 
    ; #DISPLAY_DEVICE_VGA_COMPATIBLE      - none reported 
    ; #DISPLAY_DEVICE_MULTI_DRIVER        
    ; #DISPLAY_DEVICE_ACTIVE              
    ; #DISPLAY_DEVICE_ATTACHED            
    ; 
    If device\StateFlags & #DISPLAY_DEVICE_ATTACHED_TO_DESKTOP      ; check if it's part of the desktop 
      ; 
      ; if a device is part of the desktop, additional information can be retrieved using 
      ; EnumDisplaySettings_() with the device name 
      ; 
      If EnumDisplaySettings_(@device\DeviceName,#ENUM_CURRENT_SETTINGS,@settings) > 0 
        ; 
        ; first store some info found via EnumDisplayDevices_() 
        ; 
        AddElement(x_monitor())                                    
        x_monitor_n = x_monitor_n+1 
        x_monitor()\n = x_monitor_n 
        x_monitor()\name = PeekS(@device\DeviceName,32)             ; i want my fixed length strings! 
        x_monitor()\flags = device\StateFlags 
        ; 
        ; and more stuff found via EnumDisplaySettings_() 
        ; 
        x_monitor()\f = settings\dmDisplayFrequency 
        x_monitor()\d = settings\dmBitsPerPel 
        x_monitor()\w = settings\dmPelsWidth 
        x_monitor()\h = settings\dmPelsHeight 
        x_monitor()\x = settings\dmOrientation+settings\dmPaperSize<<16       ; the default definition in purebasic didn't include the onion, well, this works as well 
        x_monitor()\y = settings\dmPaperLength+settings\dmPaperWidth<<16 
        ; 
        ; still, the handle is missing, so find that one using a point that is somewhere on the monitor 
        ; 
        x_monitor()\hnd = MonitorFromPoint_(x_monitor()\x,x_monitor()\y,#MONITOR_DEFAULTTONULL) 
        ;    
      EndIf 
    EndIf 
  Wend 
  ; 
  ; Debug "counted using enumdisplaydevices" 
  ; Debug x_monitor_n 
  ; 
  x_retval = x_monitor_n 
  ProcedureReturn x_retval 
EndProcedure 

x_monitor_detect() 

ResetList(x_monitor()) 
While NextElement(x_monitor()) 
  Debug "" 
  Debug "monitor  "+Str(x_monitor()\n) 
  If x_monitor()\flags & #DISPLAY_DEVICE_PRIMARY_DEVICE 
    Debug "primary display" 
  EndIf 
  Debug "name    "+x_monitor()\name 
  Debug "handle  "+Str(x_monitor()\hnd) 
  Debug "pos x   "+Str(x_monitor()\x) 
  Debug "pos y   "+Str(x_monitor()\y) 
  Debug "width   "+Str(x_monitor()\w) 
  Debug "height  "+Str(x_monitor()\h) 
  Debug "depth   "+Str(x_monitor()\d) 
  Debug "refresh "+Str(x_monitor()\f) 
Wend 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
