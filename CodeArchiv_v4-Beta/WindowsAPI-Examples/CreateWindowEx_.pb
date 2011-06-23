; English forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 31. March 2003
; OS: Windows
; Demo: No

Procedure WindowCallback(Window, Message, wParam, lParam) 
  Select Message 
    Case #WM_CLOSE 
      If MessageBox_(Window, "Wirklich beenden?", "EXIT", #MB_YESNO) = #IDYES 
        DestroyWindow_(Window) 
      Else 
        Result  = 0 
      EndIf 
    Case #WM_DESTROY 
      PostQuitMessage_(0) 
      Result  = 0 
    Default 
      Result  = DefWindowProc_(Window, Message, wParam, lParam) 
  EndSelect 
  ProcedureReturn Result 
EndProcedure 

#Style  = #WS_VISIBLE | #WS_BORDER | #WS_SYSMENU 
#StyleEx  = #WS_EX_TOOLWINDOW ;| #WS_EX_OVERLAPPEDWINDOW 

WindowClass.s  = "MeinFenster" 
wc.WNDCLASSEX 
wc\cbsize  = SizeOf(WNDCLASSEX) 
wc\lpfnWndProc  = @WindowCallback() 
wc\hCursor  = LoadCursor_(0, #IDC_CROSS); #IDC_ARROW   = Arrow 
; #IDC_SIZEALL = Size Arrow 
; #IDC_CROSS   = Cross 
wc\hbrBackground  = #COLOR_WINDOW + 1;CreateSolidBrush_(RGB($8F,$8F,$8F)) 
wc\lpszClassName  = @WindowClass 
RegisterClassEx_(@wc) 

hWndMain  = CreateWindowEx_(#StyleEx, WindowClass, "Test-Window", #Style, 10, 10, 200, 200, 0, 0, 0, 0) 
CreateWindowEx_(0, "Static", "", #WS_CHILD | #WS_VISIBLE | $12, 9, 9, 102, 22, hWndMain, 0, 0, 0) 
CreateWindowEx_(0, "Button", "Button 1", #WS_CHILD | #WS_VISIBLE, 10, 10, 100, 20, hWndMain, 0, 0, 0) 

ShowWindow_(hWndMain,  #SW_SHOWDEFAULT) 
UpdateWindow_(hWndMain); 

While GetMessage_(msg.MSG, #Null, 0, 0 ) 
  TranslateMessage_(msg) 
  DispatchMessage_(msg) 
Wend


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -