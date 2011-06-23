; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7316
; Author: Psychophanta (updated for PB4.00 by blbltheworm)
; Date: 25. August 2003
; OS: Windows
; Demo: No

If CreatePopupMenu(0) 
  MenuItem(1,"LeftClick") 
  MenuBar() 
  MenuItem(2,"select this item") 
  MenuItem(3,"opt2...") 
EndIf 

If CreatePopupMenu(1) 
  MenuItem(1,"RightClick") 
  MenuBar() 
  MenuItem(2,"select this item") 
  MenuItem(3,"opt2...") 
EndIf 

If CreatePopupMenu(2) 
  MenuItem(1,"LeftDoubleClick") 
  MenuBar() 
  MenuItem(2,"select this item") 
  MenuItem(3,"opt2...") 
EndIf 

If CreatePopupMenu(3) 
  MenuItem(1,"RightDoubleClick") 
  MenuBar() 
  MenuItem(2,"select this item") 
  MenuItem(3,"opt2...") 
EndIf 

hWnd.l=OpenWindow(0,200,200,150,420,"Title",#PB_Window_SizeGadget|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget) 

CreateGadgetList(hWnd) 

TreeGadget(1,0,0,150,420) 
For t=1 To 15 
  AddGadgetItem(1,-1,"item"+Hex(t)) 
Next 


Repeat 
  EventID.l=WaitWindowEvent() 
  Select EventID 
  Case #PB_Event_Gadget 
    Select EventGadget() 
    Case 1 
      MB.l=EventType() ;<--- for checking if was pushed RMB or LMB, ... 
      GetCursorPos_(@var.TV_HITTESTINFO\pt) ;get mousepointer position screen coordenates 
      ScreenToClient_(GadgetID(1),@var.TV_HITTESTINFO\pt) ;convert that coordenates to the Gadget 1 (TreeView Gadget) referenced by 
      SendMessage_(GadgetID(1),#TVM_HITTEST,0,var) ;this is to know what is the item i am pointing. 
      SendMessage_(GadgetID(1),#TVM_SELECTITEM,#TVGN_CARET,var\hItem);<-- and this selects the pointed item 
      itemsel=GetGadgetState(1) ;save selected item 
      Select MB 
      ;--------------- 
      ;Case #PB_EventType_LeftClick 
      ;  DisplayPopupMenu(0,hWnd) 
      Case #PB_EventType_RightClick 
        DisplayPopupMenu(1,hWnd) 
      Case #PB_EventType_LeftDoubleClick ;<---this doesn't work if single LeftClick is checked (logical, because this is captured at once) 
        DisplayPopupMenu(2,hWnd) 
      ;Case #PB_EventType_RightDoubleClick  ;<-- this never work !?! 
      ;  DisplayPopupMenu(3,hWnd) 
      ;--------------------- 
      EndSelect 
    EndSelect 
  Case #PB_Event_Menu 
    Select EventMenu() 
    Case 2 
      SetGadgetItemText(1,itemsel,"selected",0) 
    EndSelect 
  EndSelect 
Until EventID=#PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
