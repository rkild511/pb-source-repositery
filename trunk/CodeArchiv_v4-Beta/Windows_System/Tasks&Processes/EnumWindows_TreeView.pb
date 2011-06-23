; English forum: http://www.purebasic.fr/english/viewtopic.php?t=4478&highlight= 
; Author: FWeil (updated for PB 4.00 by Andre + edel) 
; Date: 28. August 2002 
; OS: Windows 
; Demo: No 

;================================================================ 
; 
; EnumWindows TreeView 
; F.Weil 20020828 
; 
; Two linked lists are used for both parent windows and children objects 
; 
; Each list is updated using a callback Enum procedure 
; 
; The Tree gadget is build when opening the program's main window 
; then you have just to click the items / nodes and surf. 
; 
; This program has a resizing feature linking the tree gadget size to the main window. 
; 
; I choosed to put all handle, text and class name information in a single label in the 
; tree gadget for each item, so that no more action is necessary except looking labels. 
; 
; I also tried a List icon gadget version of this program but this tree gadget version is 
; really simple and convenient for any further feature to add later. 
; 
; Feel free to modify update this code sample for any use in the PureBasic community. 
; 

Structure FindWindowData 
  hFW.l ; variable to store a handle 
  sFW.s ; variable to store a Window name 
  cFW.s ; variable to store a window class name 
EndStructure 

Global NewList FindWindow.FindWindowData() 
Global NewList FindChild.FindWindowData() 

Procedure.l EnumChildProc(hChild, lParam) 
  ChildName.s = Space(255) 
  ChildClass.s = Space(255) 
  If GetWindowText_(hChild, @ChildName, 255) 
  Else 
    SendMessage_(hChild, #WM_GETTEXT, 255, ChildName) 
  EndIf 
  If GetClassName_(hChild, @ChildClass, 255) 
    AddElement(FindChild()) 
    FindChild()\hFW = hChild 
    FindChild()\sFW = ChildName 
    FindChild()\cFW = ChildClass 
  EndIf 
  ProcedureReturn 1 
EndProcedure 

Procedure.l EnumWindowsProc(hFind, lParam) 
  WindowName.s = Space(255) 
  WindowClass.s = Space(255) 
  If GetWindowText_(hFind, WindowName, 255) 
    Result = GetClassName_(hFind, WindowClass, 255) 
    AddElement(FindWindow()) 
    FindWindow()\hFW = hFind 
    FindWindow()\sFW = WindowName 
    FindWindow()\cFW = WindowClass 
  EndIf 
  ProcedureReturn 1 
EndProcedure 

; 
; Main starts here 
; 

WEvent.l 
WindowXSize.l 
WindowYSize.l 
Quit.l 

Quit = #False 
WindowXSize = 320 
WindowYSize = 240 

If OpenWindow(0, 200, 200, WindowXSize, WindowYSize, "MyWindow", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_TitleBar) 
  CreateGadgetList(WindowID(0)) 
  TreeGadget(100, 0, 0, WindowXSize, WindowYSize, #PB_Tree_AlwaysShowSelection) 
  If EnumWindows_(@EnumWindowsProc(), 0) 
    ResetList(FindWindow()) 
    While NextElement(FindWindow()) 
      AddGadgetItem(100, -1, FindWindow()\sFW + " - " + FindWindow()\cFW + " - " + Str(FindWindow()\hFW), 0, 0) 
      ClearList(FindChild()) 
      If EnumChildWindows_(FindWindow()\hFW, @EnumChildProc(), 0) 
        ;OpenTreeGadgetNode(100) 
        ResetList(FindChild()) 
        While NextElement(FindChild()) 
          ;AddGadgetItem(100, -1, FindChild()\sFW + " - " + FindChild()\cFW + " - " + Str(FindChild()\hFW)) 
          AddGadgetItem(100, -1, FindChild()\sFW + " - " + FindChild()\cFW + " - " + Str(FindChild()\hFW), 0, 1) 
        Wend 
        ;CloseTreeGadgetNode(100) 
      EndIf 
    Wend 
  EndIf 
  
  Repeat 
    WEvent = WaitWindowEvent() 
    Select WEvent 
      Case #PB_Event_CloseWindow 
        Quit = #True 
      Default 
    EndSelect 
    
    If WindowXSize <> WindowWidth(0) Or WindowYSize <> WindowHeight(0) 
      WindowXSize = WindowWidth(0) 
      WindowYSize = WindowHeight(0) 
      ResizeGadget(100, 0, 0, WindowXSize, WindowYSize) 
    EndIf 
    
  Until Quit 
  
EndIf 

End 
;================================================================ 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger