; www.purearea.net
; Author: Andre (updated for PB4.00 by blbltheworm)
; Date: 24. June 2003
; OS: Windows
; Demo: No

OpenWindow(0,100,150,300,120,"ToolBar - Show and Hide",#PB_Window_SystemMenu) 
hToolbar = CreateToolBar(1, WindowID(0)) 
ToolBarStandardButton(1, #PB_ToolBarIcon_New) 
ToolBarStandardButton(2, #PB_ToolBarIcon_Open) 
ToolBarStandardButton(3, #PB_ToolBarIcon_Save) 

If CreateGadgetList(WindowID(0))
  ButtonGadget(0,50,50,200,20,"Hide ToolBar") : Shown = 1
EndIf

Repeat
  ev.l = WaitWindowEvent()
  gad.l = EventGadget()
  If ev = #PB_Event_Gadget
    If gad = 0
      If Shown = 1
        ShowWindow_(hToolbar, #SW_HIDE) ; now hide toolbar 
        SetGadgetText(0,"Show ToolBar")
        Shown = 0
      Else
        ShowWindow_(hToolbar, #SW_SHOWNORMAL) ; now show toolbar
        SetGadgetText(0,"Hide ToolBar")
        Shown = 1
      EndIf
    EndIf
  EndIf
Until ev.l = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP