; German forum: http://www.purebasic.fr/german/viewtopic.php?t=11325&highlight=
; Author: Sparkie (posted by nco2k)
; Date: 28. December 2006
; OS: Windows
; Demo: No

Procedure RemoveTreeRootBoxes(treeview, bool)
  ;...This removes ALL +/- boxes at the tree root
  If bool
    result = SetWindowLong_(GadgetID(treeview), #GWL_STYLE, GetWindowLong_(GadgetID(treeview), #GWL_STYLE) & (~#TVS_LINESATROOT))
  Else
    result = SetWindowLong_(GadgetID(treeview), #GWL_STYLE, GetWindowLong_(GadgetID(treeview), #GWL_STYLE) | #TVS_LINESATROOT)
  EndIf
  ProcedureReturn result
EndProcedure

If OpenWindow(0, 0, 0, 180, 200, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
  CreateMenu(0, WindowID(0))
  MenuTitle("Settings")
  MenuItem(0, "Disable Root Boxes")
  TreeGadget(0, 10, 10, 160, 160)

  ;...Remove +/- boxes at tree root
  RemoveTreeRootBoxes(0, 1)
  SetMenuItemState(0, 0, 1)

  AddGadgetItem(0, -1, "A", 0, 0)
  AddGadgetItem(0, -1, "B", 0, 1)
  AddGadgetItem(0, -1, "C", 0, 2)
  AddGadgetItem(0, -1, "D", 0, 2)
  AddGadgetItem(0, -1, "E", 0, 1)
  AddGadgetItem(0, -1, "F", 0, 2)
  AddGadgetItem(0, -1, "G", 0, 2)
  SetGadgetItemState(0, 0, #PB_Tree_Expanded)
  SetGadgetItemState(0, 1, #PB_Tree_Expanded)
  SetGadgetItemState(0, 4, #PB_Tree_Expanded)
  Repeat
    Event = WaitWindowEvent()
    Select Event
      Case #PB_Event_Menu
        If EventMenu() = 0
          result = GetMenuItemState(0, 0)
          Select result
            Case 0
              SetMenuItemState(0, 0, 1)
              on_off = 1
            Default
              SetMenuItemState(0, 0, 0)
              on_off = 0
          EndSelect
          RemoveTreeRootBoxes(0, on_off)
        EndIf
    EndSelect
  Until Event = #PB_Event_CloseWindow
EndIf
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP