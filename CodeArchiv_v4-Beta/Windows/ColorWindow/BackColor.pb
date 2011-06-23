; English forum:
; Author: Unknown (updated for PB 4.00 by Andre)
; Date: 21. January 2003
; OS: Windows
; Demo: No


; Need the SkinWin UserLib from Danilo's PureTools (now integrated in the PBOSL lib package),
; get it at www.PureArea.net !

hWnd = OpenWindow(0, (GetSystemMetrics_(#SM_CXSCREEN)-640)/2,(GetSystemMetrics_(#SM_CYSCREEN)-480)/2, 640, 480, "PB - WinSkin Example", #WS_POPUP)
If hWnd
  SetWinBackgroundColor(hWnd, RGB(255,255,0))
  SetForegroundWindow_(hWnd)
  
  
  If CreateGadgetList(hWnd)
    ButtonGadget(0, 580, 455, 60, 25, "EXIT")
  EndIf
  
  Repeat
    
    EventID.l=WaitWindowEvent()
    ; IF LeftMouseButton pressed...
    If EventID = #WM_LBUTTONDOWN
      ReleaseCapture_()
      SendMessage_(hWnd,#WM_NCLBUTTONDOWN, #HTCAPTION,0)
    EndIf
    ; Check Buttons...
    If EventID = #PB_Event_Gadget
      Select EventGadget()
      Case 0 ; EXIT
        Quit = 1
      EndSelect
    EndIf
    ; pressed ALT+F4 ??
    If EventID = #PB_Event_CloseWindow
      Quit = 1
    EndIf
  Until Quit = 1
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableAsm
; Executable = BackColor.exe
; DisableDebugger