; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2521&postdays=0&postorder=asc&start=10
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 10. October 2003
; OS: Windows
; Demo: No

  #TVM_SETBKCOLOR = $111D 
  #TVM_SETTEXTCOLOR = (#TV_FIRST + 30) 
  #ExplorerTree = 0 
  #ExplorerList = 1 
  
  Global WaitCursor.l,IL,IL1,SysImageList.l 
  WaitCursor = LoadCursor_(0,#IDC_WAIT) 
  SysImageList = SHGetFileInfo_("",0,fi.SHFILEINFO,SizeOf(SHFILEINFO),#SHGFI_ICON|#SHGFI_SYSICONINDEX|#SHGFI_SMALLICON) 
  
  Procedure SetExplorerTreeBkColor(Gadget,Color,Color1) 
    IL = ImageList_Duplicate_(SysImageList) 
    SendMessage_(GadgetID(Gadget),#TVM_SETIMAGELIST,#TVSIL_NORMAL,IL) 
    ImageList_SetBkColor_(IL,Color) 
    SendMessage_(GadgetID(Gadget),#TVM_SETTEXTCOLOR,0,Color1) 
    SendMessage_(GadgetID(Gadget),#TVM_SETBKCOLOR,0,Color) 
  EndProcedure  
  
  Procedure SetExplorerListBkColor(Gadget,Color,Color1) 
    IL1 = ImageList_Duplicate_(SysImageList) 
    SendMessage_(GadgetID(Gadget),#LVM_SETIMAGELIST,#TVSIL_NORMAL,IL1) 
    ImageList_SetBkColor_(IL1,Color) 
    SendMessage_(GadgetID(Gadget),#LVM_SETTEXTCOLOR,0,Color1) 
    SendMessage_(GadgetID(Gadget),#LVM_SETTEXTBKCOLOR,0,Color) 
    SendMessage_(GadgetID(Gadget),#LVM_SETBKCOLOR,0,Color) 
  EndProcedure  
  
  If OpenWindow(0,0,0,600,400,"ExplorerTreeGadget",#PB_Window_Invisible|#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
    ExplorerTreeGadget(#ExplorerTree, 10, 10, 200, 340, "*.*") 
    ExplorerListGadget(#ExplorerList, 220, 10, 370, 340, "*.*",#PB_Explorer_NoFolders|#PB_Explorer_NoParentFolder) 
    ChangeListIconGadgetDisplay(#ExplorerList,2) 
    SetExplorerTreeBkColor(#ExplorerTree,RGB(0,0,128),RGB(255,255,0)) 
    SetExplorerListBkColor(#ExplorerList,RGB(0,0,128),RGB(255,255,0)) 
    ShowWindow_(WindowID(0),#SW_SHOW) 
    Repeat 
      EventID.l = WaitWindowEvent() 
      If EventID = #PB_Event_CloseWindow 
        ImageList_Destroy_(IL) 
        ImageList_Destroy_(IL1) 
        DeleteObject_(WaitCursor) 
        Quit = 1 
      EndIf 
      If EventID = #PB_Event_Gadget 
        Select EventGadget() 
          Case #ExplorerTree 
            SetCursor_(WaitCursor) 
            SetExplorerTreeBkColor(#ExplorerTree,RGB(0,0,128),RGB(255,255,0)) 
            SetExplorerListBkColor(#ExplorerList,RGB(0,0,128),RGB(255,255,0)) 
            If EventType() = #PB_EventType_Change 
              SetCursor_(WaitCursor) 
              LockWindowUpdate_(GadgetID(#ExplorerList)) 
              SetGadgetText(1,GetGadgetText(0))      
              LockWindowUpdate_(0) 
            EndIf 
          Case #ExplorerList 
            If EventType() = #PB_EventType_LeftDoubleClick 
              ShellExecute_(0,"open",GetGadgetText(1)+GetGadgetItemText(1, GetGadgetState(1) ,0),0,0,1) 
            EndIf 
        EndSelect 
      EndIf 
    Until Quit = 1 
  EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
