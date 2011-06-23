; German forum: http://www.purebasic.fr/german/viewtopic.php?t=550&highlight=
; Author: Falko (updated for PB 4.00 by Andre)
; Date: 22. October 2004
; OS: Windows
; Demo: No


; Changes the font color of the TextGadget when the mouse if over the button

Enumeration
  #container
  #btn_test
  #tx_test
EndEnumeration

Enumeration
  #wnd_main
EndEnumeration
Global tb_power.l
Global TB_Static_Color.l
Global stc_bk_color.l

TB_Static_Color = CreateSolidBrush_(RGB(140,140,140))
stc_bk_color = CreateSolidBrush_(RGB(255,255,213))

Procedure WinCallback(hWnd,Msg,wParam,lParam)
  Result=#PB_ProcessPureBasicEvents
  Select Msg
    Case #WM_CTLCOLORSTATIC

      If lParam = GadgetID(#tx_test)
        SetBkMode_(wParam,#TRANSPARENT)
        If tb_power = 1
          SetTextColor_(wParam,RGB(0,0,150))
          Result=TB_Static_Color
        ElseIf tb_power = 0
          SetTextColor_(wParam,RGB(0,200,0))
          Result=TB_Static_Color
        EndIf
      EndIf ;}
  EndSelect
  ProcedureReturn Result
EndProcedure

Procedure IsMouseOverGadget(gadget)
  GetWindowRect_(GadgetID(gadget),GadgetRect.RECT)
  GetCursorPos_(mouse.POINT)
  If mouse\x>=GadgetRect\Left And mouse\x<=GadgetRect\right And mouse\y>=GadgetRect\Top And mouse\y<=GadgetRect\bottom
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

Procedure Open_wnd_main()
  tb_img_btn_customer = LoadImage(#PB_Any,"rotate.bmp")
  If OpenWindow(#wnd_main,0,0,100,(GetSystemMetrics_(#SM_CYMAXIMIZED)/2),"",#PB_Window_SystemMenu)
    CreateGadgetList(WindowID(#wnd_main))
    tool_con = ContainerGadget(#container,0,0,WindowWidth(#wnd_main),WindowHeight(#wnd_main),#PB_Container_Single)
    ButtonGadget(#btn_test,WindowWidth(#wnd_main) / 2 - 16,10,32,32,"test")
    TextGadget(#tx_test,WindowWidth(#wnd_main) / 2 - 12,100,30,15,"test")
    SetWinBackgroundColor(tool_con,RGB($8C,$8C,$8C))
  EndIf
EndProcedure

Open_wnd_main()
SetWindowCallback(@WinCallback())

Repeat
  Event = WaitWindowEvent()
  If IsMouseOverGadget(#btn_test)
    If tb_power=0
      tb_power = 1
      InvalidateRect_(GadgetID(#tx_test),0,1)
      UpdateWindow_(GadgetID(#tx_test))
    EndIf
  Else
    If tb_power=1
      tb_power = 0
      InvalidateRect_(GadgetID(#tx_test),0,1)
      UpdateWindow_(GadgetID(#tx_test))
    EndIf
  EndIf

Until Event = #PB_Event_CloseWindow

DeleteObject_(TB_Static_Color)
DeleteObject_(stc_bk_color)

End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP