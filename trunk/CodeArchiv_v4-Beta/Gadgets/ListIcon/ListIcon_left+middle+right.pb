; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=100&highlight=
; Author: ChaosKid (updated for PB4.00 by blbltheworm)
; Date: 13. June 2003
; OS: Windows
; Demo: No


#Gadget_ListView = 0 

ListViewSpalte.LV_COLUMN 
ListViewSpalte\mask = #LVCF_FMT 

If OpenWindow(0,0,0,300,100, "",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  If CreateGadgetList(WindowID(0)) 
    ListViewHandle = ListIconGadget(#Gadget_ListView,0,0,300,100, "", 100) 
    AddGadgetColumn(#Gadget_ListView, 1, "", 80) 
    AddGadgetColumn(#Gadget_ListView, 1, "", 80) 
  EndIf 
  
  Spalte = 1 ; Spalte festlegen 
  ListViewSpalte\fmt = #LVCFMT_RIGHT ; Ausrichtung festlegen 
  SendMessage_(ListViewHandle, #LVM_SETCOLUMN, Spalte, @ListViewSpalte) ; Message senden 
  
  Spalte = 2  ; Spalte festlegen 
  ListViewSpalte\fmt = #LVCFMT_CENTER  ; Ausrichtung festlegen 
  SendMessage_(ListViewHandle, #LVM_SETCOLUMN, Spalte, @ListViewSpalte) ; Message senden 
  
  AddGadgetItem(#Gadget_ListView,0,"Links (standart)" + Chr(10) + "Rechts" + Chr(10) + "Mitte") 
  
  Repeat ; 
    EventID=WaitWindowEvent() 
  Until EventID=#PB_Event_CloseWindow 
EndIf 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
