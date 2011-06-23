; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8143&highlight=
; Author: pupil (updated for PB4.00 by blbltheworm)
; Date: 31. October 2003
; OS: Windows
; Demo: No

Procedure.l MyCallBack(hWnd.l, uMsg.l, wParam.l, lParam.l) 
  result.l = #PB_ProcessPureBasicEvents 
  Select uMsg 
    Case #WM_LBUTTONDBLCLK 
      If hWnd = WindowID(0) 
        Debug "Client Area Left DBLCLICK!" 
        result = 0 
      EndIf 
  EndSelect 
  ProcedureReturn result 
EndProcedure 

If OpenWindow(0, 100, 100, 100, 100, "Test", #PB_Window_SystemMenu) 
  SetClassLong_(WindowID(0), #GCL_STYLE, GetClassLong_(WindowID(0), #GCL_STYLE)|#CS_DBLCLKS) 
  SetWindowCallback(@MyCallBack()) 
  
  While WaitWindowEvent()<>#PB_Event_CloseWindow
  Wend 
EndIf 
End 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
