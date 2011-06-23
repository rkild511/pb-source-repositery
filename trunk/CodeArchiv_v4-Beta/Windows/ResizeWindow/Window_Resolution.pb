; English forum:
; Author: PB (updated for PB4.00 by blbltheworm)
; Date: 21. January 2003
; OS: Windows
; Demo: No

; Resolution-independent window example (with PanelGadget support!).
; By PB -- feel free to use in any way you wish.
;
WinW=320 ; Window width.
WinH=200 ; Window height.
WinX=(GetSystemMetrics_(#SM_CXSCREEN)-WinW)/2 ; Window centered horizontally.
WinY=(GetSystemMetrics_(#SM_CYSCREEN)-WinH)/2 ; Window centered vertically.
OldW=WinW ; Needed in case of window resize.
OldH=WinH ; Needed in case of window resize.
;
Form1_hWnd=OpenWindow(0,WinX,WinY,WinW,WinH,"Form1",#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget|#PB_Window_SizeGadget|#PB_Window_SystemMenu)
If Form1_hWnd=0 Or CreateGadgetList(Form1_hWnd)=0 : End : EndIf
;
Global OffW.f : OffW=1
Global OffH.f : OffH=1
;
Procedure DrawGadgets()
  For r=1 To 4 : FreeGadget(r) : Next
  PanelGadget(1,8*OffW,8*OffH,100*OffW,100*OffH)
    AddGadgetItem(1,1,"Tab1")
    ButtonGadget(2,10*OffW,10*OffH,81*OffW,33*OffH,"Command1")
    AddGadgetItem(1,2,"Tab2")
    StringGadget(3,10*OffW,10*OffH,81*OffW,33*OffH,"Text1")
  CloseGadgetList()
  ButtonGadget(4,140*OffW,100*OffH,140*OffW,30*OffH,"Outside PanelGadget")
EndProcedure
;
DrawGadgets() ; Initial positions/size.
;
Repeat
  EventID=WaitWindowEvent()
  ;
  ; Resize gadgets if window size changes.
  NewW=WindowWidth(0) : NewH=WindowHeight(0)
  If NewW<>OldW Or NewH<>OldH
    OldW=NewW : OldH=NewH ; Store new sizes.
    OffW=NewW/WinW : OffH=NewH/WinH ; Offsets.
    DrawGadgets() ; New resized positions.
  EndIf
;
Until EventID=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger