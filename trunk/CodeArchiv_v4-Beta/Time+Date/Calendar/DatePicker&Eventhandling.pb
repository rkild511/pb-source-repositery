; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5389&highlight=
; Author: zomtex2003 (updated for PB 4.00 by Andre)
; Date: 15. August 2004
; OS: Windows
; Demo: No


; SysDateTimePick32 (Datumsauswähler) Eventhandling!!
; ---------------------------------------------------
; Der Code zeigt, wie das Eventhandling mit dem DatePicker funktioniert. 
; Man kann somit auf einen zusätzlichen Button verzichten, der das 
; ausgewählte Datum abfragt, man holt sich das Datum direkt über den 
; Event, wenn der DatePicker geschlossen wird.


; Eventabfrage DatumsPicker (SysDateTimePick32) 
; Forum : German 
; Author: zomtex2003 (Michael Eberhardt) 
; Date  : 18.08.2004 

#MCM_GETCURSEL         = $1001 

#DTN_DATETIMECHANGE   = #DTN_FIRST + 1 
#DTN_DROPDOWN          = #DTN_FIRST + 6 
#DTN_CLOSEUP           = #DTN_FIRST + 7 

#MYWINDOWSTYLE         = #PB_Window_SystemMenu | #PB_Window_ScreenCentered 
#PICKERSTYLE           = #WS_CHILD | #WS_VISIBLE | 12 

Declare MyWindowCallback(hwnd, msg, wParam, lParam) 

Global hMyDatePicker.l 

InitICC.INITCOMMONCONTROLSEX 
InitICC\dwSize  = SizeOf(INITCOMMONCONTROLSEX)  
InitICC\dwICC   = #ICC_DATE_CLASSES 
InitCommonControlsEx_(InitICC) 


If OpenWindow(0, 0, 0, 150, 25 , "DatePicker", #MYWINDOWSTYLE) 
  If CreateGadgetList(WindowID(0)) 
    hMyDatePicker = CreateWindowEx_(0, "SysDateTimePick32", "Date", #PICKERSTYLE, 0, 0, 100, 25, WindowID(0) ,0 ,GetModuleHandle_(0), 0) 
  EndIf 
  
  SetWindowCallback(@MyWindowCallback()) 
  Repeat 
    EventID.l = WaitWindowEvent() 
  Until EventID = #PB_Event_CloseWindow 
EndIf 
End 

Procedure MyWindowCallback(hwnd, msg, wParam, lParam) 
  Result = #PB_ProcessPureBasicEvents 
  Select(msg) 
    Case #WM_NOTIFY 
      *MySystemTime.SYSTEMTIME 
      *lpnmhdr.NMHDR 

      *lpnmhdr = lParam 
      If *lpnmhdr\hwndFrom = hMyDatePicker 
        Select(*lpnmhdr\code) 
          Case #DTN_DROPDOWN 
            Debug "DatePicker wurde geöffnet" 
          Case #DTN_CLOSEUP 
            SendMessage_(hMyDatePicker, #MCM_GETCURSEL, 0, @CurDate.SYSTEMTIME) 
            MessageRequester("Finish DatePicker", Str(CurDate\wDay) + "." + Str(CurDate\wMonth) + "." + Str(CurDate\wYear), #MB_ICONINFORMATION)          
            Debug "DatePicker wurde geschlossen" 
          Case #DTN_DATETIMECHANGE 
            *lpChange.NMDATETIMECHANGE  = lParam 
            *MySystemTime = *lpChange\st 
            Debug "ausgewähltes Datum:" + Str(*MySystemTime\wDay) + "." + Str(*MySystemTime\wMonth) + "." + Str(*MySystemTime\wYear) 
        EndSelect 
      EndIf 
  EndSelect 
  ProcedureReturn Result 
EndProcedure 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -