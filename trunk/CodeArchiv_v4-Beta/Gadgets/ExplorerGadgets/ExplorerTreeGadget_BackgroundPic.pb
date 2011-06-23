; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2521&start=10
; Author: Andreas (updated to PB4 by ste123)
; Date: 11. October 2003
; OS: Windows
; Demo: No

; This new example can show a background picture in ExplorerListGadget
; Das neue Beispiel kann jetzt auch ein Hintergrundbild im ExplorerListGadget anzeigen. 

  UseJPEGImageDecoder()

  #TVM_SETBKCOLOR = $111D 
  #TVM_SETTEXTCOLOR = (#TV_FIRST + 30) 
  #LVM_SETBKIMAGE = (#LVM_FIRST + 68) 
  
  #LVBKIF_SOURCE_URL = $02 
  #LVBKIF_STYLE_TILE = $10 
  
  #ExplorerTree = 0 
  #ExplorerList = 1 
  #Image = 100 
  
  Structure LVBKIMAGE 
    ulFlags.l 
    hbm.l 
    pszImage.l 
    cchImageMax.l 
    xOffsetPercent.l 
    yOffsetPercent.l 
  EndStructure  
  
  Global WaitCursor.l,IL,IL1,SysImageList.l,Image.s 
  WaitCursor = LoadCursor_(0,#IDC_WAIT) 
  SysImageList = SHGetFileInfo_("",0,fi.SHFILEINFO,SizeOf(SHFILEINFO),#SHGFI_ICON|#SHGFI_SYSICONINDEX|#SHGFI_SMALLICON) 
  
  Procedure SetExplorerTreeBkColor(Gadget,Color,Color1) 
    If IL <> 0 : ImageList_Destroy_(IL) : EndIf 
    IL = ImageList_Duplicate_(SysImageList) 
    SendMessage_(GadgetID(Gadget),#TVM_SETIMAGELIST,#TVSIL_NORMAL,IL) 
    ImageList_SetBkColor_(IL,Color) 
    SendMessage_(GadgetID(Gadget),#TVM_SETTEXTCOLOR,0,Color1) 
    SendMessage_(GadgetID(Gadget),#TVM_SETBKCOLOR,0,Color) 
  EndProcedure  
  
  Procedure SetExplorerListBkColor(Gadget,Color,Color1) 
    If IL1 <> 0 : ImageList_Destroy_(IL1) : EndIf 
    IL1 = ImageList_Duplicate_(SysImageList) 
    SendMessage_(GadgetID(Gadget),#LVM_SETIMAGELIST,#TVSIL_NORMAL,IL1) 
    ImageList_SetBkColor_(IL1,Color) 
    SendMessage_(GadgetID(Gadget),#LVM_SETTEXTCOLOR,0,Color1) 
    SendMessage_(GadgetID(Gadget),#LVM_SETTEXTBKCOLOR,0,Color) 
    SendMessage_(GadgetID(Gadget),#LVM_SETBKCOLOR,0,Color) 
  EndProcedure  
  
  Procedure SetExplorerListBkImage(Gadget,ImageId,Color) 
    Global Buffer.s 
    If IL1 <> 0 : ImageList_Destroy_(IL1) : EndIf 
    IL1 = ImageList_Duplicate_(SysImageList) 
    SendMessage_(GadgetID(Gadget),#LVM_SETIMAGELIST,#TVSIL_NORMAL,IL1) 
    ImageList_SetBkColor_(IL1,#CLR_NONE) 
    SendMessage_(GadgetID(Gadget),#LVM_SETTEXTCOLOR,0,Color) 
    SendMessage_(GadgetID(Gadget),#LVM_SETTEXTBKCOLOR,0,#CLR_NONE) 
    Buffer = Space(255) 
    GetTempPath_(255,Buffer) 
    Image = Buffer + "PBTemp.bmp"    
    ;Das Bitmap muss zwischengespeichert werden 
    SaveImage(#Image,Image,#PB_ImagePlugin_BMP) 
    LvImage.LVBKIMAGE 
    LvImage\ulFlags = #LVBKIF_SOURCE_URL| #LVBKIF_STYLE_TILE 
    LvImage\pszImage = @Image 
    LvImage\cchImageMax = 255 
    LvImage\xOffsetPercent = 0 
    LvImage\yOffsetPercent = 0 
    SendMessage_(GadgetID(Gadget),#LVM_SETBKIMAGE,0,LvImage) 
  EndProcedure  
  
  Procedure DeleteExplorerListBkImage(Gadget) 
    LvImage.LVBKIMAGE 
    SendMessage_(GadgetID(Gadget),#LVM_SETBKIMAGE,0,LvImage) 
    DeleteFile(Image) 
  EndProcedure  
  
  If OpenWindow(0,0,0,600,400,"ExplorerTreeGadget",#PB_Window_Invisible|#PB_Window_SystemMenu|#PB_Window_ScreenCentered ) And CreateGadgetList(WindowID(0)) 
    ExplorerTreeGadget(#ExplorerTree, 10, 10, 200, 340, "*.*",#PB_Explorer_NoFiles) 
    ExplorerListGadget(#ExplorerList, 220, 10, 370, 340, "*.*",#PB_Explorer_NoFolders|#PB_Explorer_NoParentFolder) 
    ChangeListIconGadgetDisplay(#ExplorerList,2) 
    SetExplorerTreeBkColor(#ExplorerTree,RGB(0,0,128),RGB(255,255,0)) 
    ;SetExplorerListBkColor(#ExplorerList,RGB(0,0,128),RGB(255,255,0)) 
    CatchImage(#Image,?Bild) 
    SetExplorerListBkImage(#ExplorerList,#Image,RGB(0,0,128)) 
    ShowWindow_(WindowID(0),#SW_SHOW) 
    
    Repeat 
      EventID.l = WaitWindowEvent() 
      If EventID = #PB_Event_CloseWindow 
        ImageList_Destroy_(IL) 
        ImageList_Destroy_(IL1) 
        DeleteObject_(WaitCursor) 
        DeleteExplorerListBkImage(#ExplorerList) 
        Quit = 1 
      EndIf 
      If EventID = #PB_Event_Gadget 
        Select EventGadget() 
          Case #ExplorerTree 
            If IsWindowEnabled_(GadgetID(#ExplorerTree)) = #False 
              EnableWindow_(GadgetID(#ExplorerTree),#True) 
            EndIf 
            SetCursor_(WaitCursor) 
            SetExplorerTreeBkColor(#ExplorerTree,RGB(0,0,128),RGB(255,255,0)) 
            ;SetExplorerListBkColor(#ExplorerList,RGB(0,0,128),RGB(255,255,0)) 
            SetExplorerListBkImage(#ExplorerList,#Image,RGB(0,0,128)) 
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
  
  
  DataSection 
  Bild : IncludeBinary "../../xGfx/purearea4.jpg"  ; Change path / Pfad anpassen 
  EndDataSection 
  
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
