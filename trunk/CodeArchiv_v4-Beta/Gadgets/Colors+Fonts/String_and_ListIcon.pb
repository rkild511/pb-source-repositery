; English forum:
; Author: Fweil (updated for PB4.00 by blbltheworm)
; Date: 13. September 2002
; OS: Windows
; Demo: No


; Autor: Fweil, 13. Sep 02
; Updated for PB3.70+ by Andre Beer, 09 June 2003

#Background_ListView = $502828
#Foreground_ListView = $B4FFFF
#Background_Edit1 = $0000FF
#Foreground_Edit1 = $B4FFFF
#Background_Edit2 = $FF0000
#Foreground_Edit2 = $00FF00
#StringGadget1 = 100
#ListIconGadget = 101
#StringGadget2 = 102

Global ColorBrush_Edit1.l, ColorBrush_Edit2.l
Global hStringGadget1.l, hStringGadget2.l

Procedure MyWindowCallBack(WindowID.l, Message.l, wParam.l, lParam.l)
    Result.l
    Result = #PB_ProcessPureBasicEvents
    Select Message
      Case #WM_CTLCOLOREDIT
        Select lParam
          Case hStringGadget1
            SetTextColor_(wParam, #Foreground_Edit1)
            SetBkMode_(wParam, #TRANSPARENT)
            Result = ColorBrush_Edit1
          Case hStringGadget2
            SetTextColor_(wParam, #Foreground_Edit2)
            SetBkMode_(wParam, #TRANSPARENT)
            Result = ColorBrush_Edit2
          Default
        EndSelect
      Case #WM_SIZE
        ResizeGadget(#StringGadget1, 0, 0, WindowWidth(WindowID), 100)
        ResizeGadget(#StringGadget2, 0, 240, WindowWidth(WindowID), 80)
      Default
      EndSelect
ProcedureReturn Result
EndProcedure


hWnd.l
Quit.l

Quit = 0

ColorBrush_Edit1 = CreateSolidBrush_(#Background_Edit1)
ColorBrush_Edit2 = CreateSolidBrush_(#Background_Edit2)

hWnd = OpenWindow(0, 200, 200, 320, 320, "MyWindow", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_TitleBar)
If hWnd
  AddKeyboardShortcut(0, #PB_Shortcut_Escape, 99)
  If CreateGadgetList(WindowID(0))
    LoadFont(0, "Arial Black", 8)
    SetGadgetFont(#PB_Default,FontID(0))
    hStringGadget1 = StringGadget(#StringGadget1, 0, 0, 320, 100, "The quick brown fox jumps over the lazy dog ..." , #PB_String_ReadOnly);#PB_String_Multiline | #ES_AUTOVSCROLL | #WS_VSCROLL | #WS_HSCROLL)
    hListIconGadget = ListIconGadget(#ListIconGadget, 0, 105, 320, 130, "Title", 120, 0)
    hStringGadget2 = StringGadget(#StringGadget2, 0, 240, 320, 80, "The quick brown fox jumps over the lazy dog ..." , #ES_AUTOVSCROLL | #WS_VSCROLL | #WS_HSCROLL)
    AddGadgetColumn(#ListIconGadget, 1, "Column2", 120)
    AddGadgetColumn(#ListIconGadget, 2, "Column3", 120)
  EndIf

SetWindowCallback(@MyWindowCallBack())

For i = 0 To 1000
  Number.s = Str(i)
  While Len(Number) < 4
    Number = "0" + Number
  Wend
  AddGadgetItem(#ListIconGadget, -1, "Item" + Number + Chr(10) + "String1" + Chr(10) + "String2")
Next

SendMessage_(hListIconGadget, #LVM_SETTEXTBKCOLOR, 0, #Background_ListView)
SendMessage_(hListIconGadget, #LVM_SETTEXTCOLOR, 0, #Foreground_ListView)
SendMessage_(hListIconGadget, #LVM_SETBKCOLOR, 0, #Background_ListView)
SendMessage_(hListIconGadget, #LVM_SETCOLUMNWIDTH, 0, #LVSCW_AUTOSIZE)
SendMessage_(hListIconGadget, #LVM_SETCOLUMNWIDTH, 1, #LVSCW_AUTOSIZE)
SendMessage_(hListIconGadget, #LVM_SETCOLUMNWIDTH, 2, #LVSCW_AUTOSIZE)

Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
    Quit = 1
    Case #PB_Event_Menu
    Select EventMenu()
      Case 99
    Quit = 1
    EndSelect
  EndSelect
Until Quit
EndIf
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP