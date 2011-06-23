; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6539&highlight=
; Author: FangBeast (corrected by Fred, updated for PB3.92+ by Andre, updated for PB4.00 by blbltheworm)
; Date: 13. June 2003
; OS: Windows
; Demo: No

; Splitters aren't as easy to understand than other gadgets, but once you get it, it seems obvious.
; First you have to define your layout, so, how will react your app. A splitter can only have 2 childs,
; so you have to create severals if you want several splitters in splitters. In your case, the ListIcon
; and the Web are the childs of other splitter (Tree + Splitter which contains the 2 gadgets). 
; It results to the following examples which should be ok: 

#TV_FIRST             = $1100 
#TVM_SETBKCOLOR       = #TV_FIRST + 29 
#TVM_SETTEXTCOLOR     = #TV_FIRST + 30 

Enumeration
  #Form
EndEnumeration

Enumeration
  #MenuBar
EndEnumeration

Enumeration
  #Tree
  #ListIcon
  #Web
  #ComboBox8
  #ComboBox9
  #String1

  #Splitter1
  #Splitter2
EndEnumeration

Enumeration
  #StatusBar       
  #StatusBar_Field1 
  #StatusBar_Field2
  #StatusBar_Field3
  #StatusBar_Field4
EndEnumeration

Procedure.l Form() 
  If OpenWindow(#Form,175,0,640,480,"Work Form1",#PB_Window_SystemMenu|#PB_Window_Invisible) 
    CreateMenu(#MenuBar,WindowID(#Form)) 
      MenuTitle("Files") 
    If CreateGadgetList(WindowID(#Form)) 
      TreeGadget(#Tree,#Null,#Null,#Null,#Null,#PB_Tree_AlwaysShowSelection) 
        SendMessage_(GadgetID(#Tree),#TVM_SETBKCOLOR,0,16744448) 
        AddGadgetItem(#Tree, -1, "Empty Tree") 
      ListIconGadget(#ListIcon,#Null,#Null,#Null,#Null,"ListIcon",100,#PB_ListIcon_MultiSelect|#PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection) 
        SendMessage_(GadgetID(#ListIcon),#LVM_SETBKCOLOR,0,16744448) 
        SendMessage_(GadgetID(#ListIcon),#LVM_SETTEXTBKCOLOR,0,16744448) 
        AddGadgetItem(#ListIcon, -1, "List Icon Gadget") 
      WebGadget(#Web,#Null,#Null,#Null,#Null,"Web5") 
      ComboBoxGadget(#ComboBox8,0,420,120,200) 
      ComboBoxGadget(#ComboBox9,125,420,120,200) 
      StringGadget(#String1,245,420,395,20,"") 
      
      SplitterGadget(#Splitter2, 126,0,514,414, #ListIcon,#Web, #PB_Splitter_Separator) 
      SetGadgetState(#Splitter2, 120) 
      
      SplitterGadget(#Splitter1, 0,0,640,415, #Tree, #Splitter2, #PB_Splitter_Vertical|#PB_Splitter_Separator) 
      SetGadgetState(#Splitter1, 120) 

      CreateStatusBar(#StatusBar,WindowID(#Form)) 
        AddStatusBarField(100) 
        AddStatusBarField(100) 
        AddStatusBarField(100) 
        AddStatusBarField(100) 
      HideWindow(#Form,0) 
      ProcedureReturn WindowID(#Form) 
    EndIf 
  EndIf 
EndProcedure 

If Form() 
  Repeat 
    EventID = WaitWindowEvent() 
  Until EventID = #PB_Event_CloseWindow And EventWindow() = #Form 
  CloseWindow(#Form) 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
