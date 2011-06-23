; German forum: http://www.purebasic.fr/german/viewtopic.php?t=365&highlight=
; Author: bobobo (updated for PB 4.00 by Andre)
; Date: 07. October 2004
; OS: Windows, Linux
; Demo: Yes


Enumeration 
#Window_0 
#ListIcon_0 
#ListIcon_1 
#Button_0 
#Button_1 
EndEnumeration 

If OpenWindow(#Window_0,216,0,600,300,"oi fenschdr", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar) 
  If CreateGadgetList(WindowID(#Window_0)) 
    ListIconGadget(#ListIcon_0,180,60,110,130,"Column1",100,#PB_ListIcon_CheckBoxes) 
    ListIconGadget(#ListIcon_1,310,60,130,130,"Column1",100) 
    ButtonGadget(#Button_0,180,210,110,30,"Übernahme") 
    ButtonGadget(#Button_1,310,210,130,30,"Löschen") 
  EndIf 
EndIf 


AddGadgetItem(#ListIcon_0,-1,"Erwin") 
AddGadgetItem(#ListIcon_0,-1,"Paul") 
AddGadgetItem(#ListIcon_0,-1,"Fred") 
AddGadgetItem(#ListIcon_0,-1,"Hans") 
AddGadgetItem(#ListIcon_0,-1,"SirCus") 

Repeat 
  Event = WaitWindowEvent() 
  If Event = #PB_Event_Gadget 
    GadgetID = EventGadget() 
    If GadgetID = #ListIcon_0 
    ElseIf GadgetID = #ListIcon_1 
    ElseIf GadgetID = #Button_0 
      For I=0 To CountGadgetItems(#ListIcon_0)-1 
        Debug Str(GetGadgetItemState(#ListIcon_0,I))+"  "+GetGadgetItemText(#ListIcon_0,I,0) 
        If GetGadgetItemState(#ListIcon_0,I)=#PB_ListIcon_Checked Or GetGadgetItemState(#ListIcon_0,I)=#PB_ListIcon_Checked|#PB_ListIcon_Selected 
          AddGadgetItem(#ListIcon_1,-1,GetGadgetItemText(#ListIcon_0,I,0)) 
        EndIf 
      Next I 
    ElseIf GadgetID = #Button_1 
      ClearGadgetItemList(#ListIcon_1) 
    EndIf 
    
  EndIf 
Until Event = #PB_Event_CloseWindow 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP