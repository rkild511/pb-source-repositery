; English forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 21. June 2003
; OS: Windows
; Demo: No

#GADGET_TABS = 1
Global PanelWidth:  PanelWidth=150 ;change this variable
Global PanelHeight: PanelHeight=21 ;height of one row

Procedure SetMultiRowsTabs()
  NewStyle.l = GetWindowLong_(GadgetID(#GADGET_TABS), #GWL_STYLE)
  NewStyle = NewStyle | #TCS_MULTILINE      ; enable multi rows
  NewStyle = NewStyle | #TCS_RIGHTJUSTIFY   ; optimize the width of each tabs
  NewStyle = NewStyle ! #TCS_SINGLELINE 
  SetWindowLong_(GadgetID(#GADGET_TABS), #GWL_STYLE, NewStyle)
EndProcedure 

Procedure CorrectTabsHeight()
  rows = SendMessage_(GadgetID(#GADGET_TABS),#TCM_GETROWCOUNT,0,0) 
  MessageBox_(WindowID(0),"Rows Count ="+Str(rows),"",#MB_OK)
  MoveWindow_(GadgetID(#GADGET_TABS),0,0,PanelWidth,PanelHeight * rows, 1)  ; better than ResizeGadget method
EndProcedure 

hwin=OpenWindow(0,50,50,500,250,"Test")
CreateGadgetList(hwin)

PanelGadget(#GADGET_TABS,0,0,PanelWidth,PanelHeight)
        AddGadgetItem(#GADGET_TABS,0,"Functions")
        AddGadgetItem(#GADGET_TABS,0,"Types")
        AddGadgetItem(#GADGET_TABS,0,"Labels")
        AddGadgetItem(#GADGET_TABS,0,"Globals")
        AddGadgetItem(#GADGET_TABS,0,"Arrays")
        AddGadgetItem(#GADGET_TABS,0,"Constants")
        AddGadgetItem(#GADGET_TABS,0,"Includes")  
CloseGadgetList()

SetMultiRowsTabs() 
CorrectTabsHeight()

Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -