; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=19138#19138
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 10. October 2003
; OS: Windows
; Demo: No

#TVM_SETBKCOLOR = $111D 
#TVM_SETTEXTCOLOR = (#TV_FIRST + 30) 

Procedure SetExplorerTreeBkColor(Gadget,Color,TextColor.l=0) ;TextColor-Parameter added by blbltheworm
    IL = ImageList_Duplicate_(SendMessage_(GadgetID(Gadget),#TVM_GETIMAGELIST,#TVSIL_NORMAL,0)) 
    SendMessage_(GadgetID(Gadget),#TVM_SETIMAGELIST,#TVSIL_NORMAL,IL) 
    ImageList_SetBkColor_(IL,Color) 
    SendMessage_(GadgetID(Gadget),#TVM_SETBKCOLOR,0,Color) 
    SendMessage_(GadgetID(Gadget),#TVM_SETTEXTCOLOR,0,TextColor) 
  EndProcedure  
  
 
  
  If OpenWindow(0,0,0,400,400,"ExplorerTreeGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
    ExplorerTreeGadget(0, 10, 40, 380, 340, "*.*") 
    SetExplorerTreeBkColor(0,RGB(0,255,255)) 
    
    Repeat 
      event.l= WaitWindowEvent()
      If event=#PB_Event_Gadget
        If EventGadget()=0 
          SetExplorerTreeBkColor(0,RGB(0,255,255)) ;added by blbltheworm to refresh the Colors
        EndIf
      EndIf
    Until event=#PB_Event_CloseWindow 
  EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
