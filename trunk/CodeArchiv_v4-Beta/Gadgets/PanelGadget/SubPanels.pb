; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9096&highlight=
; Author: talun (updated for PB 4.00 by Andre)
; Date: 09. January 2004
; OS: Windows
; Demo: Yes

;------------------ gadget identifiers ------------------ 
Enumeration 
  #ParentPanel 
  #ChildPanel 
  #Button1 
  #Button2 
EndEnumeration 

; ----------- Gadget items identifiers ------------ 
Enumeration 
  #Panel_1 
  #Panel_2 
EndEnumeration 

Enumeration 
  #SubPanel_1 
  #SubPanel_2 
  #SubPanel_3 
EndEnumeration 
; ---------------------------------------------------- 

If OpenWindow(0,0,0,322,220,"PanelGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
  PanelGadget(#ParentPanel,8,8,306,203) 
    AddGadgetItem (#ParentPanel,-1,"Panel 1") 
      PanelGadget (#ChildPanel,5,5,290,166) 
        AddGadgetItem(#ChildPanel,-1,"Sub-Panel 1") 
        AddGadgetItem(#ChildPanel,-1,"Sub-Panel 2") 
        AddGadgetItem(#ChildPanel,-1,"Sub-Panel 3") 
      CloseGadgetList() 
    AddGadgetItem (#ParentPanel,-1,"Panel 2") 
      ButtonGadget(#Button1, 10, 15, 80, 24,"Button 1") 
      ButtonGadget(#Button2, 95, 15, 80, 24,"Button 2") 
  CloseGadgetList() 

  Repeat 
   event.l = WaitWindowEvent() 

     Select event 
       Case #PB_Event_CloseWindow 
        halt = 1 
      Case #PB_Event_Gadget 
        GadgetNum.l = EventGadget() 
        a$ = "" 
        If GadgetNum =#ParentPanel 
          a$ = "Gadget: Main panel / " 
          Item.l = GetGadgetState(#ParentPanel) 
          If Item.l = #Panel_1 : a$ = a$ + "Panel 1" : EndIf 
          If Item.l = #Panel_2 : a$ = a$ + "Panel 2" : EndIf 
        ElseIf GadgetNum =#ChildPanel 
          a$ = "Gadget: Child panel / " 
          Item.l = GetGadgetState(#ChildPanel) 
          If Item.l = #SubPanel_1 : a$ = a$ + "Sub-Panel 1" : EndIf 
          If Item.l = #SubPanel_2 : a$ = a$ + "Sub-Panel 2" : EndIf 
          If Item.l = #SubPanel_3 : a$ = a$ + "Sub-Panel 3" : EndIf 
        ElseIf GadgetNum =#Button1 
          a$ = "Gadget: Button 1" 
        ElseIf GadgetNum =#Button2 
          a$ = "Gadget: Button 2" 
        EndIf            
        MessageRequester("Gadget info", a$,0) 
     EndSelect 
  Until halt = 1 
EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger