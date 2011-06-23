; http://freak.coolfreepages.com/code/TreeViewStuff.html
; Author: Freak (updated for PB4.00 and improved by Progi1984)
; Date: 17. May 2003
; OS: Windows
; Demo: No


; Several functions around the TreeGadget() of PureBasic,
; please be aware that you can build almost all functions with native
; PB commands now.


; These Structures are needed for: TVAddItem(), TVGetItemName() and TVSetItemName()
; *****************************************
;
  Structure TVITEM
    mask.l
    hItem.l
    state.l
    stateMask.l
    pszText.l
    cchTextMax.l
    iImage.l
    iSelectedImage.l
    cChildren.l
    lParam.l
  EndStructure

  Structure TVINSERTSTRUCT
    hParent.l
    hInsertAfter.l
    item.TVITEM
  EndStructure
;
;
;
;
Procedure TVAddItem(gadget.l, position.l, text.s, hImg.l, openflag.l)
  ;
  ; Insert a Item in a TreeView Gadget.
  ; not like AddGadgetItem(), this one supports the position parameter.
  ;
  ; Usage:
  ;***********
  ; gadget.l   = PB Gadget Number
  ; position.l = Item to insert the new one after (starting with 0)
  ; text.s     = Item Text
  ; hImg.l     = ImageID if Image to display
  ; openflag.l = If #TRUE, a new TreeViewNode is created at 'position.l' and the new Item
  ;              is added as it's Child, if #FALSE, the new one is just inserted after the 'position.l'
  ;              Item.
  ;
  ; Note: The hImg.l parameter is only supported, if there are allready some Items with Images.
  ;
  hwndTV.l = GadgetID(gadget)
  hRoot.l = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_ROOT, 0)
  hItem = hRoot: hParent.l = 0
  For i.l = 0 To position-1
    hItem2.l = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_CHILD, hItem)
    Repeat
      If hItem2 = #Null: hItem2 = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_NEXT, hItem): EndIf
      If hItem2 = #Null: hItem2 = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_PARENT, hItem): EndIf
    Until hItem2 <> #Null
    hItem = hItem2
  Next i
  lpis.TVINSERTSTRUCT
  If openflag = #True
    pitem.TVITEM
    pitem\mask = #TVIF_CHILDREN | #TVIF_HANDLE
    pitem\hItem = hItem
    pitem\cChildren = 1
    SendMessage_(hwndTV, #TVM_SETITEM, 0, @pitem)
    lpis\hParent = hItem
    lpis\hInsertAfter = hItem
  Else
    lpis\hParent = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_PARENT, hItem)
    lpis\hInsertAfter = hItem
  EndIf
  lpis\item\mask = #TVIF_TEXT
  If hImg <> 0
    himl.l = SendMessage_(hwndTV, #TVM_GETIMAGELIST, #TVSIL_NORMAL ,0)
    If himl <> #Null
      lpis\item\mask | #TVIF_IMAGE
      iImage.l = ImageList_AddIcon_(himl, hImg)
      lpis\item\iImage = iImage
      lpis\item\iSelectedImage = iImage
    EndIf
  EndIf
  lpis\item\cchTextMax = Len(text)
  lpis\item\pszText = @text
  SendMessage_(hwndTV, #TVM_INSERTITEM, 0, @lpis)
EndProcedure
;
;
;
;
Procedure TVDeleteItem(gadget.l, item.l)
  ;
  ; Deletes a TreeViewItem.
  ;
  ;Usage:
  ;**************
  ; gadget.l  = PB Gadget Number
  ; item.l    = Item to delete (starting with 0)
  ;
  hwndTV.l = GadgetID(gadget)
  hItem.l = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_ROOT, 0)
  For i.l = 0 To item-1
    hItem2.l = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_CHILD, hItem)
    Repeat
      If hItem2 = #Null: hItem2 = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_NEXT, hItem): EndIf
      If hItem2 = #Null: hItem2 = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_PARENT, hItem): EndIf
    Until hItem2 <> #Null
    hItem = hItem2
  Next i
  SendMessage_(hwndTV, #TVM_DELETEITEM, 0, hItem)   
EndProcedure
;
;
;
;
Procedure TVShowItem(gadget.l, item.l)
  ;
  ; Makes sure, an Item is visible. If necessary, the List is expanded and scrolled, so
  ; the User can see the Item
  ;
  ;Usage:
  ;************
  ; gadget.l  = PB Gadget Number
  ; item.l    = Item to make visible.
  ;
  hwndTV.l = GadgetID(gadget)
  hItem.l = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_ROOT, 0)
  For i.l = 0 To item-1
    hItem2.l = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_CHILD, hItem)
    Repeat
      If hItem2 = #Null: hItem2 = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_NEXT, hItem): EndIf
      If hItem2 = #Null: hItem2 = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_PARENT, hItem): EndIf
    Until hItem2 <> #Null
    hItem = hItem2
  Next i
  SendMessage_(hwndTV, #TVM_ENSUREVISIBLE, 0, hItem)
EndProcedure
;
;
;
;
;
Procedure.s TVGetItemName(gadget.l, item.l)
  ;
  ; Get the Name of a TreeViewItem. (I couldn't get GetGadgetItemText() to work, so i use this one)
  ;
  ;Usage:
  ;*************
  ; gadget.l = PB Gadget Number
  ; item.l   = Item to get the Text of (starting with 0)
  ;
  hwndTV.l = GadgetID(gadget)
  hItem.l = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_ROOT, 0)
  For i.l = 0 To item-1
    hItem2.l = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_CHILD, hItem)
    Repeat
      If hItem2 = #Null: hItem2 = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_NEXT, hItem): EndIf
      If hItem2 = #Null: hItem2 = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_PARENT, hItem): EndIf
    Until hItem2 <> #Null
    hItem = hItem2
  Next i
  text.s = Space(999)
  pitem.TVITEM
  pitem\mask = #TVIF_TEXT
  pitem\hItem = hItem
  pitem\pszText = @text
  pitem\cchTextMax = 999
  SendMessage_(hwndTV, #TVM_GETITEM, 0, @pitem)
  ProcedureReturn PeekS(pitem\pszText)
EndProcedure
;
;
;
;
Procedure TVSetItemName(gadget.l, item.l, text.s)
  ;
  ; Set the Text of a TreeViewItem. (I couldn't get SetGadgetItemText() to work, so i use this one)
  ;
  ;Usage:
  ;*************
  ; gadget.l = PB Gadget Number
  ; item.l   = Item to set the Text of (starting with 0)
  ;
  hwndTV.l = GadgetID(gadget)
  hItem.l = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_ROOT, 0)
  For i.l = 0 To item-1
    hItem2.l = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_CHILD, hItem)
    Repeat
      If hItem2 = #Null: hItem2 = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_NEXT, hItem): EndIf
      If hItem2 = #Null: hItem2 = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_PARENT, hItem): EndIf
    Until hItem2 <> #Null
    hItem = hItem2
  Next i
  pitem.TVITEM
  pitem\mask = #TVIF_TEXT
  pitem\hItem = hItem
  pitem\pszText = @text
  pitem\cchTextMax = Len(text)
  SendMessage_(hwndTV, #TVM_SETITEM, 0, @pitem)
EndProcedure
;
;
;
;
Procedure TVExpandNode(gadget.l, item.l, flag.l)
  ;
  ; Expands, or collapses a TreeViewNode.
  ;
  ;Usage:
  ;*************
  ; gadget.l  = PB Gadget Number
  ; item.l    = Item to expand/collapse
  ; flag.l    = If 0: the Node collapses
  ;             If 1: the Node is expanded
  ;             If 2: the Node is expanded, if it was collapsed, and it's collapsed, if it was expanded
  ;
  hwndTV.l = GadgetID(gadget)
  hItem.l = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_ROOT, 0)
  For i.l = 0 To item-1
    hItem2.l = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_CHILD, hItem)
    Repeat
      If hItem2 = #Null: hItem2 = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_NEXT, hItem): EndIf
      If hItem2 = #Null: hItem2 = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_PARENT, hItem): EndIf
    Until hItem2 <> #Null
    hItem = hItem2
  Next i
  If flag = 1
    SendMessage_(hwndTV, #TVM_EXPAND, #TVE_EXPAND, hItem)
  ElseIf flag=2
    SendMessage_(hwndTV, #TVM_EXPAND, #TVE_TOGGLE, hItem)
  Else
    SendMessage_(hwndTV, #TVM_EXPAND, #TVE_COLLAPSE, hItem)
  EndIf
EndProcedure
;
;
;
;
Procedure TVExpandAll(gadget.l)
  ;
  ; Expands the whole TreeView, good for using, after it was created, to show the whole tree.
  ;
  ; Usage:
  ;************
  ; gadget.l = PB GAdget Number
  ;
  hwndTV.l = GadgetID(gadget)
  hRoot.l = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_ROOT, 0)
  hItem.l = hRoot
  Repeat
    SendMessage_(hwndTV, #TVM_EXPAND, #TVE_EXPAND, hItem)
    hItem = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_NEXTVISIBLE , hItem)
  Until hItem = #Null
  SendMessage_(hwndTV, #TVM_ENSUREVISIBLE, 0, hRoot)
EndProcedure
;
;
;
;
Procedure TVSortNode(gadget.l, item.l, flag.l)
  ;
  ; Sorts all child Items of a TreeViewNode.
  ;
  ;Usage:
  ;***********
  ; gadget.l  = PB Gadget Number
  ; item.l    = Item where the Node Starts (the one with the '+')
  ; flag.l    = If #TRUE, all SubNodes are Sorted, too.
  ;           = If #FALSE, only the direct child Items of this Node are sorted.
  ;
  hwndTV.l = GadgetID(gadget)
  hItem.l = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_ROOT, 0)
  For i.l = 0 To item-1
    hItem2.l = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_CHILD, hItem)
    Repeat
      If hItem2 = #Null: hItem2 = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_NEXT, hItem): EndIf
      If hItem2 = #Null: hItem2 = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_PARENT, hItem): EndIf
    Until hItem2 <> #Null
    hItem = hItem2
  Next i
  SendMessage_(hwndTV, #TVM_SORTCHILDREN, flag, hItem)
EndProcedure
;
;
;
;
Procedure TVSortAll(gadget.l)
  ;
  ; Sorts the whole TreeView. This can also be done by 'TVSortNode(gadget.l, 0, #TRUE)', but
  ; this one is much less code :-)
  ;
  ;Usage:
  ;***********;
  ; gadget.l  = PB Gadget Number
  ;
  hwndTV.l = GadgetID(gadget)
  hRoot.l = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_ROOT, 0)
  SendMessage_(hwndTV, #TVM_SORTCHILDREN, #True, hRoot)
EndProcedure



;- Example
If OpenWindow(0, 0, 0, 355, 200, "TreeGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
  TreeGadget(0, 10, 10, 160, 160)
   For a = 0 To 10
      AddGadgetItem (0, -1, "Elément normal "+Str(a), 0, 0)
      AddGadgetItem (0, -1, "Noeud "+Str(a), 0, 0)
      AddGadgetItem (0, -1, "Sous-élément 1", 0, 1)
      AddGadgetItem (0, -1, "Sous-élément 2", 0, 1)
      AddGadgetItem (0, -1, "Sous-élément 3", 0, 1)
      AddGadgetItem (0, -1, "Sous-élément 4", 0, 1)
      AddGadgetItem (0, -1, "Fichier "+Str(a), 0, 0)
    Next
    ButtonGadget(1, 170,000,90,40,"TVAddItem")
    ButtonGadget(2, 170,040,90,40,"TVDeleteItem")
    ButtonGadget(3, 170,080,90,40,"TVShowItem")
    ButtonGadget(4, 170,120,90,40,"TVGetItemName")
    ButtonGadget(5, 170,160,90,40,"TVSetItemName")
    ButtonGadget(6, 260,000,90,40,"TVExpandNode")
    ButtonGadget(7, 260,040,90,40,"TVExpandAll")
    ButtonGadget(8, 260,080,90,40,"TVSortNode")
    ButtonGadget(9, 260,120,90,40,"TVSortAll")
  Repeat
    Event = WaitWindowEvent()
    If Event=#PB_Event_Gadget
      Select EventGadget()
        Case 1
          TVAddItem(0,0,"My Text By Button 1",0, #False)
          ; #true for OpenFlag add a child at the position's item
        Case 2
          TVDeleteItem(0,0)
        Case 3
          TVShowItem(0,2)
        Case 4
          Debug TVGetItemName(0,1)
        Case 5
          TVSetItemName(0,0,"My Text By Button 5")
        Case 6
          TVExpandNode(0,1,#True)
          ; #false retract the node
        Case 7
          TVExpandAll(0)
        Case 8
          TVSortNode(0,0,#True)
        Case 9
          TVSortAll(0)
      EndSelect
    EndIf
  Until Event = #PB_Event_CloseWindow
EndIf 

; IDE Options = PureBasic v4.01 (Windows - x86)
; Folding = --
; EnableXP