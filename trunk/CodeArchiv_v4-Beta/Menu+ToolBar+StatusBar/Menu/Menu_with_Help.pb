; German forum: http://www.purebasic.fr/german/viewtopic.php?t=12222
; Author: Kai
; Date: 06. March 2007
; OS: Windows
; Demo: No

If OpenWindow(0, 0, 0, 640, 480, "Menu mit Hilfe", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  If CreateMenu(0, WindowID(0))
    MenuTitle("Datei")
    MenuItem(0, "Neu")
    MenuItem(1, "Öffnen")
    MenuItem(2, "Speichern")
    MenuItem(3, "Schließen")
    OpenSubMenu("Letzte Dateien")
    MenuItem(0, "1" + Chr(9) + "-")
    MenuItem(1, "2" + Chr(9) + "-")
    CloseSubMenu()
    MenuTitle("Bearbeiten")
    MenuItem(0, "Ausschneiden")
    MenuItem(1, "Kopieren")
    MenuItem(2, "Einfügen")
  EndIf

  Global SMnul = GetSubMenu_(MenuID(0), 0)        ;Menu Datei
  Global SMnu2 = GetSubMenu_(SMnul, 4)            ;SubMenu Letzte Dateien
  Global SMnu3 = GetSubMenu_(MenuID(0), 1)        ;Menu Bearbeiten

  If CreateStatusBar(0, WindowID(0))
    AddStatusBarField(WindowWidth(0))
  EndIf
EndIf

Procedure WindowCallback(hWnd, Msg, wParam, lParam)
  Protected Result.l = #PB_ProcessPureBasicEvents
  If hWnd = WindowID(0)
    If Msg = #WM_UNINITMENUPOPUP
      StatusBarText(0, 0, "")
    EndIf
    If Msg = #WM_MENUSELECT
      Select lParam
        Case SMnul
          Select wParam & $FFFF
            Case 0: StatusBarText(0, 0, "Neu")
            Case 1: StatusBarText(0, 0, "Öffnen")
            Case 2: StatusBarText(0, 0, "Speichern")
            Case 3: StatusBarText(0, 0, "Schließen")
            Case 4: StatusBarText(0, 0, "Letzte Dateien")
          EndSelect
        Case SMnu2
          Select wParam & $FFFF
            Case 0: StatusBarText(0, 0, "Letzte Datei 1")
            Case 1: StatusBarText(0, 0, "Letzte Datei 2")
          EndSelect
        Case SMnu3
          Select wParam & $FFFF
            Case 0: StatusBarText(0, 0, "Ausschneiden")
            Case 1: StatusBarText(0, 0, "Kopieren")
            Case 2: StatusBarText(0, 0, "Einfügen")
          EndSelect
      EndSelect
    EndIf
  EndIf
  ProcedureReturn Result
EndProcedure
SetWindowCallback(@WindowCallback())

While WaitWindowEvent() <> #PB_Event_CloseWindow: Wend

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP