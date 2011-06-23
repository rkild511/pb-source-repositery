; English forum:
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 31. December 2002
; OS: Windows
; Demo: No

; Need Danilo's PureBasic userlib "SkinWin", get it from Ressource site or as part of his PureTools
; Note: SkinWin is now part of the PBOSL package - grab it from www.PureArea.net

hWnd = OpenWindow(0, (GetSystemMetrics_(#SM_CXSCREEN)),(GetSystemMetrics_(#SM_CYSCREEN)), 455, 335, "PB - WinSkin Example", #WS_POPUP)
If hWnd
  SetWinBackgroundColor(hWnd, GetSysColor_(#COLOR_BTNFACE))
  SkinWin(hWnd, LoadImage(0,"..\..\Graphics\Gfx\PB_Skin.bmp"))
  ResizeWindow(0,(GetSystemMetrics_(#SM_CXSCREEN)-445)/2,(GetSystemMetrics_(#SM_CYSCREEN)-335)/2,#PB_Ignore,#PB_Ignore)
  SetForegroundWindow_(hWnd)
  
  
  If CreateGadgetList(hWnd)
    ProgressBarGadget(0,70,150,293,15,0,100)
    ButtonGadget(1, 300, 240, 60, 25, "EXIT")
  EndIf
  
  Repeat
    
    SetGadgetState(0,Random(100))
    
    EventID.l=WaitWindowEvent()
    ; IF LeftMouseButton pressed...
    If EventID = #WM_LBUTTONDOWN
      ReleaseCapture_()
      SendMessage_(hWnd,#WM_NCLBUTTONDOWN, #HTCAPTION,0)
    EndIf
    ; Check Buttons...
    If EventID = #PB_Event_Gadget
      Select EventGadget()
      Case 1 ; EXIT
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
; EnableXP
; Executable = PB.exe
; DisableDebugger