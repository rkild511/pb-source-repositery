; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14510&highlight=
; Author: Sparkie (updated for PB 4.00 by Andre)
; Date: 23. March 2005
; OS: Windows
; Demo: No


; Following code will notify you which Gadget was clicked...
; Der folgende Code informiert, auf welches Gadget geklickt wurde...

Enumeration
  #Window_0
EndEnumeration
Enumeration 1
  #Frame3D_0
  #Button_0
  #String_0
  #Text_0
  #Radio_0
  #CheckBox_0
  #Image_0
EndEnumeration
If OpenWindow(#Window_0, 0, 0, 600, 200,  "Catch Gadget Click", #PB_Window_ScreenCentered | #PB_Window_SystemMenu) And CreateGadgetList(WindowID(#Window_0))
  TextGadget(#Text_0, 50, 80, 80, 20, "TextGadget")
  Frame3DGadget(#Frame3D_0, 15, 10, 220, 160, "Frame3DGadget")
  ButtonGadget(#Button_0, 50, 50, 125, 25, "ButtonGadget")
  StringGadget(#String_0, 250, 55, 100, 20, "StringGadget")
  OptionGadget(#Radio_0, 250, 120, 130, 15, "OptionGadget")
  CheckBoxGadget(#CheckBox_0, 250, 150, 130, 20, "CheckBoxGadget")
  ImageGadget(#Image_0, 395, 15, 190, 150, 0, #PB_Image_Border)
  CreateStatusBar(0, WindowID(#Window_0))
  AddStatusBarField(100)
  AddStatusBarField(100)
  AddStatusBarField(400)
  Repeat
    event = WaitWindowEvent()
    ;--> If left mousebutton is down
    If GetAsyncKeyState_(#VK_LBUTTON) <> 0
      ;--> get the current position
      GetCursorPos_(@cursor_pos.POINT)
      ScreenToClient_(WindowID(0),@cursor_pos)
      ;--> Get the handle of the underlying gadget
      hChild = RealChildWindowFromPoint_(WindowID(0), cursor_pos\x,cursor_pos\y)
      ;--> Get the Gadget#
      idChild = GetDlgCtrlID_(hChild)
      ;--> If mouse was clicked on a Gadget
      If idChild > -1
        ;--> Get Gadget text lenght and add 1 for ending null character
        winTextLen = GetWindowTextLength_(GadgetID(idChild)) + 1
        ;--> If text is found, fill WinText$
        If winTextLen > 1
          winText$ = Space(winTextLen)
          GetWindowText_(GadgetID(idChild), @winText$, winTextLen)
        Else
          ;--> If no text found, it's the ImageGadget
          winText$ = "Image Gadget"
        EndIf
        ;--> Display results in the Statusbar
        StatusBarText(0, 0, winText$)
        StatusBarText(0, 1, "id = " + Str(idChild))
        StatusBarText(0, 2, "handle = " + Str(hChild))
      EndIf
    EndIf
  Until event = #PB_Event_CloseWindow
EndIf
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger