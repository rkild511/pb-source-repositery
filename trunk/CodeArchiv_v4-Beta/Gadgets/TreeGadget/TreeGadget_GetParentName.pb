; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13555&highlight=
; Author: GreenGiant (updated for PB 4.00 by Andre)
; Date: 01. January 2005
; OS: Windows
; Demo: No


; Get the parent node text when a child node is selected in a Tree Gadget
; Namen des übergeordneten Knotens ermitteln, wenn ein dazugehöriger Knoten angeklickt wurde

; Note by the author: when I look at the helpfile I maybe could have replaced
; some of the commands with native PB ones, like getting the handle of the
; selected item. But you get the idea.

Declare.s ParentItemText(gadgethandle)

If OpenWindow(0,0,0,355,180,"TreeGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
  TreeGadget(0, 10,10,160,160)                                       ; TreeGadget standard
  TreeGadget(1,180,10,160,160,#PB_Tree_CheckBoxes|#PB_Tree_NoLines)  ; TreeGadget with Checkboxes + NoLines
  For ID=0 To 1
    For a=0 To 10
      AddGadgetItem (ID, -1, "Normal Item "+Str(a), 0, 0) ; if you want to add an image, use
      AddGadgetItem (ID, -1, "Node "+Str(a), 0, 0)        ; ImageID(x) as 4th parameter
      AddGadgetItem(ID, -1, "Sub-Item 1", 0, 1)
      AddGadgetItem(ID, -1, "Sub-Item 2", 0, 1)
      AddGadgetItem(ID, -1, "Sub-Item 3", 0, 1)
      AddGadgetItem(ID, -1, "Sub-Item 4", 0, 1)
      AddGadgetItem (ID, -1, "File "+Str(a), 0, 0)
    Next
  Next
  Repeat
    ev=WaitWindowEvent()
    If ev=#PB_Event_Gadget
      gad=GadgetID(EventGadget())
      text$=ParentItemText(gad)
      If text$
        Debug text$
      Else
        Debug "No parent exists/error"
      EndIf
    EndIf
  Until ev=#PB_Event_CloseWindow
EndIf


Procedure.s ParentItemText(gadgethandle)
  current=SendMessage_(gadgethandle,#TVM_GETNEXTITEM,#TVGN_CARET,0)
  parent=SendMessage_(gadgethandle,#TVM_GETNEXTITEM,#TVGN_PARENT,current)
  If parent
    parenttext$=Space(260)
    text.TV_ITEM
    text\mask=#TVIF_TEXT
    text\hItem=parent
    text\pszText=@parenttext$
    text\cchTextMax=260
    SendMessage_(gadgethandle,#TVM_GETITEM,0,@text)
    ProcedureReturn parenttext$
  Else
    ProcedureReturn ""
  EndIf
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP