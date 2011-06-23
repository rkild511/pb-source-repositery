; www.purearea.net
; Author: Andre Beer (updated for PB4.00 by blbltheworm)
; Date: 29. June 2003
; OS: Windows
; Demo: No


;Example for disabling menu item with WinAPI
If OpenWindow(0,100,150,300,120,"Menu - Enable and Disable",#PB_Window_SystemMenu) 
  If CreateMenu(0, WindowID(0)) 
   MenuTitle("Project") 
    MenuItem(1, "Open") 
    MenuItem(2, "Close") 
  EndIf
  menu=GetMenu_(WindowID(0)) 
  EnableMenuItem_(menu,0,#MF_BYPOSITION|#MF_GRAYED) : Shown = 0
  DrawMenuBar_(WindowID(0)) 
  If CreateGadgetList(WindowID(0))
    ButtonGadget(0,50,50,200,20,"Enable Menu")
  EndIf

  Repeat
    ev.l = WaitWindowEvent()
    gad.l = EventGadget()
    If ev = #PB_Event_Gadget
      If gad = 0
        If Shown = 1
          EnableMenuItem_(menu,0,#MF_BYPOSITION|#MF_GRAYED)     ; now disable menu
          DrawMenuBar_(WindowID(0)) 
          SetGadgetText(0,"Enable Menu")
          Shown = 0
        Else
          EnableMenuItem_(menu,0,#MF_BYPOSITION|#MF_ENABLED)    ; now enable menu
          DrawMenuBar_(WindowID(0)) 
          SetGadgetText(0,"Disable Menu")
          Shown = 1
        EndIf
      EndIf
    EndIf
  Until ev.l = #PB_Event_CloseWindow 
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP