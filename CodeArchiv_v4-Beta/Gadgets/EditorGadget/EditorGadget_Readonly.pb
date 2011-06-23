; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1370&highlight=
; Author: CS2001 (updated for PB4.00 by blbltheworm)
; Date: 15. June 2003
; OS: Windows
; Demo: Yes

#window=0 
#frame=1 
#List=2 
#close=3 

OpenWindow(#window, 455, 283, 320, 240, "editor",  #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered ) 
CreateGadgetList(WindowID(#window)) 
Frame3DGadget(#frame, 10, 10, 300, 190, "eTrust version information") 
EditorGadget(#List, 20, 30, 280, 160) 
ButtonGadget(#close, 180, 210, 120, 20, "close",#PB_Button_Default   ) 

SendMessage_(GadgetID(#List), #EM_SETOPTIONS, #ECOOP_OR, #ECO_READONLY) 

;ClearGadgetItemList(#list) 
For a=0 To 5 
  AddGadgetItem(#List,a,"test") 
Next 

Repeat 
  Event = WaitWindowEvent() 
  If Event = #PB_Event_Gadget 
    GadgetID = EventGadget() 
    If GadgetID = #close 
      Event=#PB_Event_CloseWindow 
    EndIf 
  EndIf 
Until Event = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
