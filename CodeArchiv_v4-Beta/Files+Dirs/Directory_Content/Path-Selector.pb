; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3477&highlight=
; Author: freak (updated for PB4.00 by blbltheworm)
; Date: 18. January 2004
; OS: Windows
; Demo: No

#FileTree = 1 
#List = 2 
#Button = 3 

#TVS_CHECKBOXES = $100 

; rekursiver scan durch das explorertreegadget: 
Procedure ScanTree(hItem) 

  hItem = SendMessage_(GadgetID(#FileTree), #TVM_GETNEXTITEM, #TVGN_CHILD, hItem) 
  While hItem 
  
    ; daten über das item lesen 
    item.TV_ITEM\mask = #TVIF_CHILDREN|#TVIF_HANDLE|#TVIF_STATE 
    item\hItem = hItem 
    item\statemask = #TVIS_STATEIMAGEMASK 
    SendMessage_(GadgetID(#FileTree), #TVM_GETITEM, 0, @item) 
    
    ; ist die checkbox gesetzt?? 
    If ((item\state >> 12) -1) 
      
      ; item selektieren, um per GetGAdgetText(#FileTree) den pfad zu bekommen 
      SendMessage_(GadgetID(#FileTree), #TVM_SELECTITEM, #TVGN_CARET, hItem) 
      
      ; Pfad abspeichern 
      AddGadgetItem(#List, -1, GetGadgetText(#FileTree)) 
    EndIf 
    
    ; wenn das item childitems hat, suche dort fortsetzen: 
    If item\cChildren > 0 
      ScanTree(hItem) 
    EndIf 
    
    ; nextes item 
    hItem = SendMessage_(GadgetID(#FileTree), #TVM_GETNEXTITEM, #TVGN_NEXT, hItem) 
  Wend 

EndProcedure 


If OpenWindow(0, 0, 0, 300, 600, "Path Requester", #PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  If CreateGadgetList(WindowID(0)) 
  
    ExplorerTreeGadget(#FileTree, 5, 5, 290, 275, "", #PB_Explorer_NoFiles) 
    
    ; checkboxes aktivieren 
    styles = GetWindowLong_(GadgetID(#FileTree), #GWL_STYLE) 
    SetWindowLong_(GadgetID(#FileTree), #GWL_STYLE, styles | #TVS_CHECKBOXES) 
    
    ButtonGadget(#Button, 215, 285, 80, 20, "Ok") 
    ListViewGadget(#List, 5, 310, 290, 285) 
    
    Repeat 
      Event = WaitWindowEvent() 
      
      If Event = #PB_Event_Gadget And EventGadget() = #Button 
      
        ClearGadgetItemList(#List) 
        
        ; das selektierte item wird beim scan verändert -> abspeichern 
        selected = SendMessage_(GadgetID(#FileTree), #TVM_GETNEXTITEM, #TVGN_CARET, 0)                
        
        ; suche beim root item starten 
        root = SendMessage_(GadgetID(#FileTree), #TVM_GETNEXTITEM, #TVGN_ROOT, 0) 
        
        ; rekursiven scan durch alle items und childitems 
        ScanTree(root) 
        
        ; selektiertes item zurücksetzen 
        SendMessage_(GadgetID(#FileTree), #TVM_SELECTITEM, #TVGN_CARET, selected) 
        
      
      EndIf 
      
    Until Event = #PB_Event_CloseWindow 
    
  
  EndIf 
EndIf 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
