; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1415&highlight=
; Author: Christian (updated for PB 4.00 by Andre)
; Date: 29. December 2004
; OS: Windows
; Demo: Yes


#Plist = 0 
#Button = 1 

Procedure Randomize() 
  Protected CurrenID.l, GadgetItems.l 

  Gadgetitems = CountGadgetItems(#Plist) - 1 
  Dim GadgetItem.s(GadgetItems) 

  For i = 0 To Gadgetitems 
     GadgetItem(i) = GetGadgetItemText(#Plist, i, 0)+Chr(10)+GetGadgetItemText(#Plist, i, 1)+Chr(10)+GetGadgetItemText(#Plist, i, 2)+Chr(10)+GetGadgetItemText(#Plist, i, 3)+Chr(10)+GetGadgetItemText(#Plist, i, 4) 
  Next 
  ClearGadgetItemList(#Plist) 

  Repeat 
    CurrentID = Random(GadgetItems) 
    If GadgetItem(CurrentID) <> "" 
        AddGadgetItem(#Plist, -1, GadgetItem(CurrentID)) 
        GadgetItem(CurrentID) = "" 
    EndIf 
  Until CountGadgetItems(#Plist) = GadgetItems 
EndProcedure 

hwnd = OpenWindow(0, 0, 0, 500, 500, "Random List", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
If hwnd 
    If CreateGadgetList(hwnd) 
        ListIconGadget(#Plist, 0, 0, 500, 425, "Column 1", 125, #PB_ListIcon_FullRowSelect) 
         AddGadgetColumn(#Plist, 1, "Column 2", 125) 
         AddGadgetColumn(#Plist, 2, "Column 3", 125) 
         AddGadgetColumn(#Plist, 3, "Column 4", 121) 

        ButtonGadget(#Button, 200, 450, 100, 25, "Randomize") 
    EndIf 
    For a = 0 To 50 
      AddGadgetItem(#Plist, -1, "Eintrag "+Str(a)+Chr(10)+"Spalte 2; "+"Eintrag "+Str(a)+Chr(10)+"Spalte 3; "+"Eintrag "+Str(a)+Chr(10)+"Spalte 4; "+"Eintrag "+Str(a)) 
    Next a 

Repeat 
 Select WaitWindowEvent() 
  Case #PB_Event_Gadget 
   Select EventGadget() 
    Case #Button 
     Randomize() 

   EndSelect 

  Case #PB_Event_CloseWindow 
   Ende = 1 

 EndSelect 
Until Ende = 1 
End 
EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP