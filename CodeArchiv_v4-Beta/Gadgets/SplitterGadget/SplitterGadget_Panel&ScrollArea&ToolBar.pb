; German forum: http://www.purebasic.fr/german/viewtopic.php?t=93&highlight=
; Author: Hellboy (corrected by Franky, updated for PB 4.00 by Andre)
; Date: 13. September 2004
; OS: Windows
; Demo: Yes

#WindowWidth  = 800
#WindowHeight = 600

If OpenWindow(0, 0, 0, #WindowWidth, #WindowHeight, "PureBasic - Menu", #PB_Window_SystemMenu)

  If CreateMenu(0, WindowID(0))
    MenuTitle("Datei")
    MenuItem( 1, "Öffnen...")
    MenuItem( 2, "Speichern")
    MenuItem( 3, "Speichern unter...")
    MenuItem( 4, "Beenden")
  EndIf

  If CreateToolBar(0, WindowID(0))
    ToolBarStandardButton(0, #PB_ToolBarIcon_New)
    ToolBarStandardButton(1, #PB_ToolBarIcon_Open)
    ToolBarStandardButton(2, #PB_ToolBarIcon_Save)

    ToolBarSeparator()

    ToolBarStandardButton(4, #PB_ToolBarIcon_Find)
    ToolBarToolTip(0, 4, "Titel Suchen")

    ToolBarSeparator()
  EndIf

  ;************************************************************************
  If CreateGadgetList(WindowID(0))
    ScrollAreaGadget(0, 0, 0, 400, 400, 1000, 1000, 1)
    CloseGadgetList()

    PanelGadget(1, 0, 0, 400, 400)
    For k=0 To 3
      AddGadgetItem(1, -1, "Line "+Str(k))
      ButtonGadget(12+k, 10, 10, 100, 20, "Test"+Str(k))
    Next
    CloseGadgetList()
    SplitterGadget(5, 0, 25, #WindowWidth, #WindowHeight-25, 0, 1, #PB_Splitter_Vertical)
    SetGadgetState(5, 500)
  EndIf
  ;***************************************************************************

  Repeat

    EventID.l = WaitWindowEvent()

    If EventID.l = #WM_CLOSE
      quit = 1
    EndIf

  Until quit = 1

EndIf

End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP