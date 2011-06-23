; German forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 04. February 2003
; OS: Windows
; Demo: No

Global HWND1.l,HWND2.l 
Procedure CallBack(WND,Message,lParam,wParam) 
    Result = #PB_ProcessPureBasicEvents 
    Select WND 
        
    Case HWND1 
        Select Message 
        Case #WM_PAINT 
            StartDrawing(WindowOutput(0)) 
            DrawText(0,0,"Hallo!")
            StopDrawing() 
        Case #WM_CLOSE 
            End 
        EndSelect 
        
    Case HWND2 
        Select Message 
        Case #WM_PAINT 
            StartDrawing(WindowOutput(1)) 
            DrawText(0,0,"Hallo2!")
            StopDrawing() 
        Case #WM_CLOSE 
            DestroyWindow_(WND) 
        EndSelect 
        
    EndSelect 
    ProcedureReturn Result 
EndProcedure 
HWND1 = OpenWindow(0, 100, 100, 195, 260, "Fenster1", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
HWND2 = OpenWindow(1, 400, 100, 195, 260, "Fenster2", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
SetWindowCallback(@CallBack()) 
Repeat 
    EventID.l = WaitWindowEvent() 
Until Quit = 1 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -