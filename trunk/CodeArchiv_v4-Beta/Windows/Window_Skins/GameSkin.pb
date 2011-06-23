; English forum:
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 31. December 2002
; OS: Windows
; Demo: No

; Need Danilo's PureBasic userlib "SkinWin", get it from Ressource site or as part of his PureTools
; Note: SkinWin is now part of the PBOSL package - grab it from www.PureArea.net

hwnd = OpenWindow(0, (GetSystemMetrics_(#SM_CXSCREEN)),(GetSystemMetrics_(#SM_CYSCREEN)), 455, 533, "PB - WinSkin Example", #WS_POPUP)
If hwnd
  SetWinBackgroundColor(hwnd, GetSysColor_(#COLOR_BTNFACE))
  SkinWin(hwnd, LoadImage(0,"..\..\Graphics\Gfx\Game.bmp"))
  ResizeWindow(0,(GetSystemMetrics_(#SM_CXSCREEN)-445)/2,(GetSystemMetrics_(#SM_CYSCREEN)-533)/2,#PB_Ignore,#PB_Ignore)
  SetForegroundWindow_(hwnd)
  
  
  If CreateGadgetList(hwnd)
    ButtonGadget(0, 370, 492, 66, 35, "EXIT")
  EndIf
  
  If InitSprite()
    If OpenWindowedScreen(hwnd,16,125,419,354,0,0,0)
      
      Repeat
        
        FlipBuffers()
        ClearScreen(RGB(0,0,0))
        StartDrawing(ScreenOutput())
        ;160)
        DrawingMode(1)
        FrontColor(RGB(255,255,0))
        DrawText(140,Random(330),"Your Game here...")
        StopDrawing()
        
        EventID.l=WaitWindowEvent()
        ; IF LeftMouseButton pressed...
        If EventID = #WM_LBUTTONDOWN
          ReleaseCapture_()
          SendMessage_(hwnd,#WM_NCLBUTTONDOWN, #HTCAPTION,0)
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
  EndIf
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableAsm
; EnableXP
; Executable = GAME.exe