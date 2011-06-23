; www.purearea.net (Sourcecode collection by cnesm)
; Author: Danilo  (updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: No

#IMAGE = 1

Procedure WindowProc(hWnd,Msg,wParam,lParam)
  Shared WindowProc_ImageInMove

  Select Msg
    Case #WM_LBUTTONDOWN
      WindowProc_ImageInMove = 1
    Case #WM_LBUTTONUP
      WindowProc_ImageInMove = 0
    Case #WM_MOUSEMOVE
      If ChildWindowFromPoint_(hWnd,lParam & $FFFF,(lParam>>16) & $FFFF) = GadgetID(#IMAGE) And wParam&#MK_LBUTTON And WindowProc_ImageInMove
        ResizeGadget(#IMAGE,(lParam & $FFFF)-GadgetWidth(#IMAGE)/2,((lParam>>16)&$FFFF)-GadgetHeight(#IMAGE)/2,#PB_Ignore,#PB_Ignore)
        UpdateWindow_(hWnd) ; Win9x fix
      Else
        WindowProc_ImageInMove = 0
      EndIf
  EndSelect
  ProcedureReturn #PB_ProcessPureBasicEvents
EndProcedure

OpenWindow(0,0,0,400,400,"image",#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_Invisible)
SetWindowCallback(@WindowProc())
CreateGadgetList(WindowID(0))

If CreateImage(#IMAGE,100,100)=0
  MessageRequester("ERROR","Cant create image",#MB_ICONERROR)
  End
EndIf

StartDrawing(ImageOutput(#IMAGE))
f.f = $FF / ImageHeight(#IMAGE)
For a = 0 To ImageHeight(#IMAGE)
  Line(0,a,ImageWidth(#IMAGE),0,RGB($FF,f*a,$00))
Next a
StopDrawing()

ImageGadget(#IMAGE,0,0,0,0,ImageID(#IMAGE))
DisableGadget(#IMAGE,1)    ; added by Andre for PB3.93 compatibility

HideWindow(0,0)

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      End
  EndSelect
ForEver


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger