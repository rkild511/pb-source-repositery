; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1032&highlight=
; Author: FloHimself (updated for PB4.00 by blbltheworm)
; Date: 16. May 2003
; OS: Windows
; Demo: No

#Window_0 = 0 

#Gadget_0 = 0 
#Gadget_1 = 1 
#Gadget_2 = 2 

Procedure FindStringLIG(searchString.s) 

  SendMessage_(GadgetID(#Gadget_0), #LVM_FIRST + $54, $8, 1) 

  fItem.LV_FINDINFO 
  fItem\flags   = #LVFI_STRING 
  fItem\psz     = @searchString 

  itemNumber = SendMessage_(GadgetID(#Gadget_0), #LVM_FINDITEM, -1, fItem) ; find Item 
  
  If itemNumber > -1 
    Goto SCROLL_AND_SELECT 
  Else 
    For i = 0 To CountGadgetItems(#Gadget_0) - 1 
      If searchString = GetGadgetItemText(#Gadget_0, i, 1) 
        itemNumber = i 
        Goto SCROLL_AND_SELECT 
      EndIf 
    Next 
  EndIf 
  
  Goto PROC_ERROR 

  SCROLL_AND_SELECT: 
    pItem.POINT 

    SendMessage_(GadgetID(#Gadget_0), #LVM_GETITEMPOSITION, itemNumber , pItem) ; get item position 
    SendMessage_(GadgetID(#Gadget_0), #LVM_SCROLL, pItem\x, pItem\y - 150)     ; scroll to item position 

    sItem.LV_ITEM 
    sItem\mask      = #LVIF_STATE 
    sItem\state     = #LVIS_SELECTED 
    sItem\stateMask = #LVIS_SELECTED 

    SendMessage_(GadgetID(#Gadget_0), #LVM_SETITEMSTATE, itemNumber , sItem)    ; set item state as selected      
    ;SetActiveGadget(#Gadget_0)
    Goto PROC_END 
  
  PROC_ERROR: 
    MessageRequester("Fehler", "Eintrag '" + searchString + "' nicht gefunden :(", #MB_ICONEXCLAMATION | #MB_OK)  

  PROC_END: 
EndProcedure 

Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 283, 124, 532, 314, "Suche in ListViewGadget",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
    If CreateGadgetList(WindowID(#Window_0)) 
      ListIconGadget(#Gadget_0, 0, 0, 530, 270, "Spalte 1", 100, #PB_ListIcon_AlwaysShowSelection | #PB_ListIcon_FullRowSelect) 
        AddGadgetColumn(#Gadget_0, 1, "Spalte 2", 100) 

        For i = 0 To 200 
          AddGadgetItem(#Gadget_0, -1, "foo " + Str(i) + Chr(10) + "bar " + Str(i)) 
        Next 
        
      ButtonGadget(#Gadget_1, 300, 280, 150, 20, "Suche") 
      StringGadget(#Gadget_2, 100, 280, 150, 20, "") 
    EndIf 
  EndIf 
EndProcedure 

Open_Window_0() 

Repeat 
  event = WaitWindowEvent() 

  If event = #PB_Event_Gadget 
    Select EventGadget() 
      Case #Gadget_1 
        FindStringLIG(GetGadgetText(#Gadget_2)) 

    EndSelect 
  EndIf 
  
Until event = #PB_Event_CloseWindow 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
