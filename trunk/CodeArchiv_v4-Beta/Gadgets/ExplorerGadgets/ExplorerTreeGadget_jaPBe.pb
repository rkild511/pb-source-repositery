; www.purearea.net (Sourcecode collection by cnesm)
; Author: GPI (updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: No

#winMain=1

Declare ResizeFileSystem(w,h) 
Procedure callback(WindowID, Message, wParam, lParam) 
  Result = #PB_ProcessPureBasicEvents 
  If WindowID=WindowID(#winMain) 
    Select Message 
      Case #WM_SIZING:ResizeFileSystem(WindowWidth(#winMain),WindowHeight(#winMain)) 
    EndSelect 
    Debug WindowID
  EndIf 
  
  ProcedureReturn Result 
EndProcedure 
  
#gadget_explorer_tree=1 
#gadget_explorer_List=2 
#gadget_explorer_split=3 
#gadget_explorer_CjaPBe=4 
#gadget_explorer_CAll=5 
#gadget_explorer_CCostum=6 
#gadget_explorer_Costum=7 

Procedure ResizeFileSystem(w,h) 
  SendMessage_(WindowID(#winMain),#WM_SETREDRAW,#False,0) 
  ResizeGadget(#gadget_explorer_split   ,#PB_Ignore,#PB_Ignore,     w,h-22) 
  ResizeGadget(#gadget_explorer_CAll    ,   0,h-20,    50,20) 
  ResizeGadget(#gadget_explorer_CjaPBe  ,  52,h-20,    50,20) 
  ResizeGadget(#gadget_explorer_CCostum , 104,h-20,    16,20) 
  ResizeGadget(#gadget_explorer_Costum  , 120,h-20, w-120,20) 
  
  w-GetSystemMetrics_(#SM_CXVSCROLL)-GetSystemMetrics_(#SM_CXEDGE)*2 
  SendMessage_(GadgetID(2),#LVM_SETCOLUMNWIDTH,0,w) 
  SendMessage_(GadgetID(2),#LVM_SETCOLUMNWIDTH,1,0) 
  SendMessage_(GadgetID(2),#LVM_SETCOLUMNWIDTH,2,0) 
  SendMessage_(GadgetID(2),#LVM_SETCOLUMNWIDTH,3,0) 
  SendMessage_(WindowID(#winMain),#WM_SETREDRAW,#True,0) 
  RedrawWindow_(WindowID(#winMain), 0, 0,#RDW_INTERNALPAINT|#RDW_INVALIDATE|#RDW_ALLCHILDREN|#RDW_ERASE) 
EndProcedure 

OpenWindow(#winMain,0,200,200,400,"Test",#PB_Window_SystemMenu|#PB_Window_SizeGadget) 
CreateGadgetList(WindowID(#winMain)) 
SetWindowCallback(@callback()) 

;#LVS_NOCOLUMNHEADER = $4000 
ExplorerTreeGadget(1, 0,  0,400,100,"f:\*.*"              ,#PB_Explorer_NoFiles|#PB_Explorer_AutoSort) 
ExplorerListGadget(2, 0,100,400,100,"f:\*.PB;*.pbi;*.pbfl",#PB_Explorer_FullRowSelect|#PB_Explorer_NoFolders|#PB_Explorer_NoDirectoryChange|#PB_Explorer_NoParentFolder|#PB_Explorer_AutoSort) 
SplitterGadget(3,0,0,200,400,1,2) 
OptionGadget(#gadget_explorer_CAll,0,0,10,10,"All") 
OptionGadget(#gadget_explorer_CjaPBe,0,0,10,10,"jaPBe") 
OptionGadget(#gadget_explorer_CCostum,0,0,10,10,"") 
StringGadget(#gadget_explorer_Costum,0,0,10,10,"*.ico;*.bmp") 

i=GetWindowLong_(GadgetID(2),#GWL_STYLE) 
SetWindowLong_(GadgetID(2),#GWL_STYLE,i|#LVS_NOCOLUMNHEADER) 
SetGadgetState(#gadget_explorer_CjaPBe,#True) 

ResizeFileSystem(200,400) 

Repeat 
  EventID=WaitWindowEvent() 
  Select EventID 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case #gadget_explorer_tree 
          If EventType()=#PB_EventType_LeftClick 
            x$=GetGadgetText(#gadget_explorer_tree) 
            If GetGadgetText(#gadget_explorer_List)<>x$ 
              SetGadgetText(#gadget_explorer_List,x$) 
            EndIf 
          EndIf 
        Case #gadget_explorer_List 
          If EventType()=#PB_EventType_LeftDoubleClick 
            Debug GetGadgetText(#gadget_explorer_List)+GetGadgetItemText(#gadget_explorer_List,GetGadgetState(#gadget_explorer_List),0) 
          EndIf 
        Case #gadget_explorer_Costum 
          SetGadgetState(#gadget_explorer_CCostum,#True) 
          SetGadgetState(#gadget_explorer_CAll,#False) 
          SetGadgetState(#gadget_explorer_CjaPBe,#False) 
          x$=GetGadgetText(#gadget_explorer_tree) 
          SetGadgetText(#gadget_explorer_List,x$+GetGadgetText(#gadget_explorer_Costum)) 
        Case #gadget_explorer_CCostum 
          x$=GetGadgetText(#gadget_explorer_tree) 
          SetGadgetText(#gadget_explorer_List,x$+GetGadgetText(#gadget_explorer_Costum)) 
          SetActiveGadget(#gadget_explorer_Costum) 
        Case #gadget_explorer_CAll 
          x$=GetGadgetText(#gadget_explorer_tree) 
          SetGadgetText(#gadget_explorer_List,x$+"*.*") 
        Case #gadget_explorer_CjaPBe 
          x$=GetGadgetText(#gadget_explorer_tree) 
          SetGadgetText(#gadget_explorer_List,x$+"*.pb;*.pbi;*.pbfl") 
      EndSelect 
        
  EndSelect 
Until EventID=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP