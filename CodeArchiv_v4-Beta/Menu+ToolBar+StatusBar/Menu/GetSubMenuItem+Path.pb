; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1834&highlight=
; Author: VoSs2o0o (updated for PB 4.00 by Andre)
; Date: 28. January 2005
; OS: Windows
; Demo: No


; Get menu item (of sub-menu) with path
; Menüpunkt samt Pfad zum Untermenü ermitteln
; -------------------------------------------

; Open with debugger enabled and put the mouse cursor about any menu item
; of running program (e.g. the PB IDE). Kill with debugger!


; Weil mich dieses Stück Code eine ganze Menge Nerven gekostet hat poste ich es mal hier:
;
; - es wird der Menüpunkt unter der Maus ermittelt
; - es wird der Handle zur Menüstruktur ermittelt
; - anschliessend wird vom Handle zur Menüstruktur aus rekursiv gesucht,
; bis der Menüpunkt samt Pfad ermittelt wurde
;
; Nach dem starten des Programms muss natürlich die Maus über einen
; Menüpunkt gefahren werden (z.B. einfach das Menü vom Editor öffnen)
;
lpPoint.Point
#MN_GETHMENU = $1E1

Global NewList lstSearchSubmenu.s()

Procedure SearchSubmenu(hmenu, hcurrmenu.l)
  count = GetMenuItemCount_(hmenu)
  For mnucount=0 To count -1
    hsubmenu = GetSubMenu_(hmenu, mnucount)
    If hsubmenu <> 0
      If hsubmenu = hcurrmenu.l
        mnuString.s = Space(255)
        GetMenuString_(hmenu, mnucount, @mnuString, Len(mnuString), #MF_BYPOSITION)
        InsertElement(lstSearchSubmenu.s())
        lstSearchSubmenu.s() = mnuString
        ProcedureReturn #True
      Else
        erg = SearchSubmenu(hsubmenu, hcurrmenu.l)
        If erg = #True
          mnuString.s = Space(255)
          GetMenuString_(hmenu, mnucount, @mnuString, Len(mnuString), #MF_BYPOSITION)
          InsertElement(lstSearchSubmenu.s())
          lstSearchSubmenu.s() = mnuString
          ProcedureReturn erg
        EndIf
      EndIf
    EndIf
  Next
EndProcedure

While 1=1
  GetCursorPos_(lpPoint)
  hwnd = WindowFromPoint_(lpPoint\X, lpPoint\Y)
  Submenucount = 0
  phwnd = GetParent_(hwnd)  ;Fenster-Handle
  hmenu = GetMenu_(phwnd)
  hcurrmenu.l = SendMessage_(hwnd, #MN_GETHMENU, 0,0)
  menuPos = MenuItemFromPoint_(hwnd, hcurrmenu.l, lpPoint\X, lpPoint\Y)
  If oldmenuPos <> menuPos
    SearchSubmenu(hmenu, hcurrmenu.l)
    mnuString.s = Space(255)
    GetMenuString_(hcurrmenu.l, menuPos, @mnuString, Len(mnuString), #MF_BYPOSITION)
    LastElement(lstSearchSubmenu.s())
    AddElement(lstSearchSubmenu.s())
    lstSearchSubmenu.s() = mnuString
    Debug "------------"
    ForEach lstSearchSubmenu.s()
     Debug lstSearchSubmenu.s()
    Next
    ClearList(lstSearchSubmenu.s())
    oldmenuPos = menuPos
  EndIf
  Submenucount = 0
Wend 



; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -