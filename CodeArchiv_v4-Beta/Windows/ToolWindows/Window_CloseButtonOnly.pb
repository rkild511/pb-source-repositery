; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8479&highlight=
; Author: Kale (updated for PB4.00 by blbltheworm)
; Date: 28. November 2003
; OS: Windows
; Demo: No

;=========================================================================== 
;-PROCEDURES 
;=========================================================================== 

;Window callback 
Procedure WindowCallback(hwnd, Message, wParam, lParam) 
    Select Message 
        Case #WM_CLOSE 
            UnregisterClass_("WindowClass", GetModuleHandle_(#Null)) 
            DestroyWindow_(hwnd) 
            ProcedureReturn 0 
        Case #WM_DESTROY 
            UnregisterClass_("WindowClass", GetModuleHandle_(#Null)) 
            PostQuitMessage_(0) 
            ProcedureReturn 0 
    EndSelect 
    Result = DefWindowProc_(hwnd, Message, wParam, lParam) 
    ProcedureReturn Result 
EndProcedure 

;Window class 
WindowClass.WNDCLASS 
Classname.s = "WindowClass" 
WindowClass\style = #CS_HREDRAW | #CS_VREDRAW 
WindowClass\lpfnWndProc = @WindowCallback() 
WindowClass\cbClsExtra = 0 
WindowClass\cbWndExtra = 0 
WindowClass\hInstance = GetModuleHandle_(#Null) 
WindowClass\hIcon = LoadIcon_(#Null, #IDI_APPLICATION) 
WindowClass\hCursor = LoadCursor_(#Null, #IDC_ARROW) 
WindowClass\hbrBackground = GetStockObject_(#WHITE_BRUSH) 
WindowClass\lpszMenuName = #Null 
WindowClass\lpszClassName = @Classname 
RegisterClass_(WindowClass) 

;=========================================================================== 
;-GEOMETRY 
;=========================================================================== 

;Calculate the window position to display it centrally 
ScreenWidth.l = GetSystemMetrics_(#SM_CXSCREEN) 
ScreenHeight.l = GetSystemMetrics_(#SM_CYSCREEN) 
WindowWidth.l = 406 
WindowHeight.l = 322 
WindowXPosition.l = (ScreenWidth / 2) - (WindowWidth / 2) 
WindowYPosition.l = (ScreenHeight/ 2) - (WindowHeight/ 2) 

hwnd.l = CreateWindowEx_(#WS_EX_TOOLWINDOW, "WindowClass", "Text Window...", #WS_VISIBLE | #WS_OVERLAPPEDWINDOW | #WS_SIZEBOX , WindowXPosition, WindowYPosition, WindowWidth, WindowHeight, 0, 0, GetModuleHandle_(#Null), 0) 

CreateGadgetList(hwnd) 
    StringGadget(1, 10, 10, 380, 280, "", #ES_MULTILINE | #PB_String_ReadOnly | #ES_AUTOVSCROLL | #WS_VSCROLL | #ESB_DISABLE_LEFT | #ESB_DISABLE_RIGHT) 
    SetGadgetText(1, "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin vestibulum consequat felis. Pellentesque wisi sem, mattis ut, sagittis et, gravida id, wisi. Donec nulla.") 

;=========================================================================== 
;-MAIN LOOP 
;=========================================================================== 

If hwnd 
    While GetMessage_(Message.MSG, 0, 0, 0) 
        TranslateMessage_(Message) 
        DispatchMessage_(Message) 
    Wend 
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
