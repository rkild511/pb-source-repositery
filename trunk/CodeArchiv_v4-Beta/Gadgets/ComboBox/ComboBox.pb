; English forum:
; Author: El_Choni (updated for PB3.92+ by Andre, updated for PB4.00 by blbltheworm)
; Date: 19. February 2002
; OS: Windows
; Demo: No


#MainWndFlags = #PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget
#WindowWidth = 512
#ComboBoxGadget = 0
#AddGadget = 1
#TextGadget = 2
#Null=0
Global CB_hWnd.l, lpch.l
Procedure Error(errorstring.s)
  MessageRequester("Error", errorstring, #MB_ICONERROR)
  End
EndProcedure
Procedure SelectCallback(hWnd, uMsg, wParam, lParam)
  result = #PB_ProcessPureBasicEvents
  Select uMsg
  Case #WM_CONTEXTMENU
    If wParam=CB_hWnd
      MessageRequester("You right-clicked", "in the ComboBox gadget.", 0)
    EndIf
  Case #WM_COMMAND
    wNotifyCode = wParam>>16
    wID = wParam & $FFFF
    If wNotifyCode=#CBN_SELCHANGE And lParam=CB_hWnd And wID=#ComboBoxGadget
      result = MessageRequester("Selection changed to:", GetGadgetText(#ComboBoxGadget), 0)
    EndIf
  EndSelect
  ProcedureReturn result
EndProcedure
hInstance = GetModuleHandle_(#Null)
Main_hWnd = OpenWindow(0, #CW_USEDEFAULT, #CW_USEDEFAULT, #WindowWidth, 80, "Editable ComboBox item selection event catching example:", #MainWndFlags)
If Main_hWnd
  If CreateGadgetList(Main_hWnd)
    CB_hWnd = ComboBoxGadget(#ComboBoxGadget, 5, 5, #WindowWidth-10, 100) ; #PB_ComboBox_Editable: with this flag, right click defaults to edit context menu
    If CB_hWnd
      cchTextMax = 256
      lpch = AllocateMemory(cchTextMax)
      Global Dim item.s(7)
      item(0) = "Spaghetti"
      item(1) = "Great sole"
      item(2) = "Potato omelette"
      item(3) = "Fondue chinoise"
      item(4) = "Tapioca soup"
      item(5) = "Duck liver"
      item(6) = "Kebap"
      For i = 0 To 6
        AddGadgetItem(#ComboBoxGadget, -1, item(i))
      Next i
      ButtonGadget(#AddGadget, 5, 40, (#WindowWidth/2)-15, 32, "Add")
      TextGadget(#TextGadget, (#WindowWidth/2)+5, 40, (#WindowWidth/2)-15, 32, "Capturing the item-selected event")
      SetWindowCallback(@SelectCallback())
      Repeat
        EventID = WaitWindowEvent()
        Select EventID
        Case #PB_Event_Gadget
          If EventGadget()=#AddGadget
            SendMessage_(CB_hWnd, #WM_GETTEXT, cchTextMax, lpch)
            AddGadgetItem(#ComboBoxGadget, -1, PeekS(lpch))
          EndIf
        Case #PB_Event_CloseWindow
          Quit = 1
        EndSelect
      Until Quit
    Else
      Error("Could not create ComboBox gadget.")
    EndIf
  Else
    Error("Could not create gadget list.")
  EndIf
Else
  Error("Could not open main window.")
EndIf
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger