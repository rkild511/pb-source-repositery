; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1317&highlight=
; Author: NicTheQuick (updated for PB4.00 by blbltheworm)
; Date: 11. June 2003
; OS: Windows
; Demo: No


; Lists all windows and child windows (gadgets) 

Structure Window 
  Childs.l 
  Rekursion.l 
  
  ;Window 
  Handle.l 
  Process.l 
  Name.s 
  Class.s 
EndStructure 

#BufferSize = 2048 
;#PROCESS_ALL_ACCESS = $FFF 

Global LF.s 
Global curSubLevel.l ;Current Sublevle of the TreeGadget
LF = Chr(13) + Chr(10) 

Declare RefreshList(Modus.l) 
Declare AddWindow(*Tmp.Window) 
Declare EnumAllWindows() 
Declare EnumAllSubChilds(Handle.l, lParam.l) 
Declare EnumProc(Handle.l, lParam.l) 
Declare.s GetTitle(Handle) 
Declare.s GetClassName(Handle.l) 

Global NewList Window.Window() 
  
;- 

Procedure.s GetClassName(Handle.l) 
  Class.s = Space(#BufferSize) 
  GetClassName_(Handle, @Class, Len(Class)) 
  ProcedureReturn Left(Class, Len(Class)) 
EndProcedure 

Procedure.s GetTitle(Handle) 
  Name.s = Space(#BufferSize) 
  GetWindowText_(Handle, @Name, Len(Name)) 
  ProcedureReturn Left(Name, Len(Name)) 
EndProcedure 

Procedure EnumProc(Handle.l, lParam.l) 
  AddElement(Window()) 
  
  Window()\Handle = Handle 
  Window()\Process = 0 
  GetWindowThreadProcessId_(Handle, @Window()\Process) 
  Window()\Name = GetTitle(Handle) 
  Window()\Class = GetClassName(Handle) 
  
  If lParam 
    *Tmp.Window = lParam 
    *Tmp\Childs + 1 
    Window()\Rekursion = *Tmp\Rekursion + 1 
  Else 
    Window()\Rekursion = 0 
  EndIf 
  
  EnumChildWindows_(Handle, @EnumProc(), @Window()) 
  
  ProcedureReturn #True 
EndProcedure 

Procedure EnumAllWindows() 
  Protected TmpL.l 
  ClearList(Window()) 
  TmpL = EnumWindows_(@EnumProc(), 0) 
EndProcedure 

;- 

Procedure AddWindow(*Tmp.Window) 
  Handle.l = *Tmp\Handle 
  ClassName.s = *Tmp\Class 
  ProcessID.l = *Tmp\Process 
  Name.s = *Tmp\Name 
  Childs.l = *Tmp\Childs 
  ;AddGadgetItem(0, -1, "Handle: " + Str(Handle) + ", Process ID: " + Str(ProcessID) + ", Name: " + Chr(34) + Name + Chr(34) + ", Class Name: " + Chr(34) + ClassName + Chr(34)) 
  AddGadgetItem(0, -1, Name + " (" + ClassName + ") [" + Right("0000000" + Hex(Handle), 8) + ", " + Right("0000000" + Hex(ProcessID), 8) + "] + <" + Str(Childs) + ">",0,curSubLevel) 
EndProcedure 

Procedure AddNodeToList() 
  AddWindow(@Window()) 
  If Window()\Childs 
    ;OpenTreeGadgetNode(0) 
    curSubLevel+1
    Childs = Window()\Childs 
    For a.l = 1 To Childs 
      NextElement(Window()) 
      AddNodeToList() 
    Next 
    curSubLevel-1
    ;CloseTreeGadgetNode(0) 
  EndIf 
EndProcedure 

Procedure RefreshList(Modus.l) 
  curSubLevel=0
  If Modus & 1 
    ClearGadgetItemList(0) 
    ResetList(Window()) 
    While NextElement(Window()) 
      AddNodeToList() 
    Wend 
  EndIf 
  
  If Modus & 2 
    State.l = GetGadgetState(0) 
    ResetList(Window()) 
    c.l = 0 
    While NextElement(Window()) 
      If Window()\Childs > 0 
        SetGadgetItemState(0, c, #PB_Tree_Expanded) 
      EndIf 
      c + 1 
    Wend 
    SetGadgetState(0, State) 
  EndIf 
  
  If Modus & 8 
    State.l = GetGadgetState(0) 
    If State >= 0 
      SelectElement(Window(), State) 
      Rek.l = Window()\Rekursion 
      c.l = State 
      Repeat 
        If Window()\Childs > 0 
          SetGadgetItemState(0, c, #PB_Tree_Expanded) 
        EndIf 
        c + 1 
      Until NextElement(Window()) = 0 Or (Window()\Rekursion = Rek And c > State) 
      SetGadgetState(0, State) 
    EndIf 
  EndIf 

EndProcedure 

Procedure DelProcInList(Process.l) 
  ResetList(Window()) 
  While NextElement(Window()) 
    If Window()\Process = Process 
      DeleteElement(Window()) 
    EndIf 
  Wend 
EndProcedure 

Procedure.s rgState(DWord.l) 
  #STATE_SYSTEM_FOCUSABLE = $00100000 
  #STATE_SYSTEM_INVISIBLE = $8000 
  #STATE_SYSTEM_OFFSCREEN = $10000 
  #STATE_SYSTEM_UNAVAILABLE = $1 
  #STATE_SYSTEM_PRESSED = $08 
  
  Text.s = "" 
  If DWord & #STATE_SYSTEM_FOCUSABLE 
    Text = Text + "can accept the focus, " 
  EndIf 
  If DWord & #STATE_SYSTEM_INVISIBLE 
    Text = Text + "invisible, " 
  EndIf 
  If DWord & #STATE_SYSTEM_OFFSCREEN 
    Text = Text + "no visible representation, " 
  EndIf 
  If DWord & #STATE_SYSTEM_UNAVAILABLE 
    Text = Text + "unavailable, " 
  EndIf 
  If DWord & #STATE_SYSTEM_PRESSED 
    Text = Text + "pressed, " 
  EndIf 
  
  If Text 
    Text = Left(Text, Len(Text) - 2) 
  Else 
    Text = "n/a" 
  EndIf 
  ProcedureReturn Text 
EndProcedure 

Procedure.s dwStyle(DWord.l) 
  Text.s = "" 
  If DWord & #WS_BORDER 
    Text = Text + "thin-line border, " 
  EndIf 
  If DWord & #WS_CAPTION 
    Text = Text + "title bar, " 
  EndIf 
  If DWord & #WS_CHILD 
    Text = Text + "child, " 
  EndIf 
  If DWord & #WS_CHILDWINDOW 
    Text = Text + "child, " 
  EndIf 
  If DWord & #WS_CLIPCHILDREN 
    Text = Text + "#WS_CLIPCHILDREN, " 
  EndIf 
  If DWord & #WS_CLIPSIBLINGS 
    Text = Text + "#WS_CLIPSIBLINGS, " 
  EndIf 
  If DWord & #WS_DISABLED 
    Text = Text + "disabled, " 
  EndIf 
  If DWord & #WS_DLGFRAME 
    Text = Text + "#WS_DLGFRAME, " 
  EndIf 
  If DWord & #WS_GROUP 
    Text = Text + "first group control, " 
  EndIf 
  If DWord & #WS_HSCROLL 
    Text = Text + "horizontal scroll bar, " 
  EndIf 
  If DWord & #WS_ICONIC 
    Text = Text + "minimized, " 
  EndIf 
  If DWord & #WS_MAXIMIZE 
    Text = Text + "maximized, " 
  EndIf 
  If DWord & #WS_MAXIMIZEBOX 
    Text = Text + "maximize button, " 
  EndIf 
  If DWord & #WS_OVERLAPPED 
    Text = Text + "overlapped, " 
  EndIf 
  If DWord & #WS_OVERLAPPEDWINDOW 
    Text = Text + "overlapped, " 
  EndIf 
  If DWord & #WS_POPUP 
    Text = Text + "pop-up, " 
  EndIf 
  If DWord & #WS_POPUPWINDOW 
    Text = Text + "pop-up, " 
  EndIf 
  If DWord & #WS_SIZEBOX 
    Text = Text + "sizing border, " 
  EndIf 
  If DWord & #WS_SYSMENU 
    Text = Text + "system menu, " 
  EndIf 
  If DWord & #WS_TABSTOP 
    Text = Text + "TAB navigation, " 
  EndIf 
  If DWord & #WS_THICKFRAME 
    Text = Text + "sizing border, " 
  EndIf 
  If DWord & #WS_TILED 
    Text = Text + "overlapped, " 
  EndIf 
  If DWord & #WS_TILEDWINDOW 
    Text = Text + "overlapped, " 
  EndIf 
  If DWord & #WS_VISIBLE 
    Text = Text + "visible, " 
  EndIf 
  If DWord & #WS_VSCROLL 
    Text = Text + "vertical scroll bar, " 
  EndIf 
  
  If Text 
    Text = Left(Text, Len(Text) - 2) 
  Else 
    Text = "n/a" 
  EndIf 
  ProcedureReturn Text 
EndProcedure 

Procedure.s dwExStyle(DWord.l) 
  #WS_EX_COMPOSITED = $02000000 
  #WS_EX_LAYERED = $80000 
  #WS_EX_LAYOUTRTL = $400000 
  #WS_EX_NOACTIVATE = $8000000 
  #WS_EX_NOINHERITLAYOUT = $100000 
  
  Text.s = "" 
  If DWord & #WS_EX_ACCEPTFILES 
    Text = Text + "accept drag-drop files, " 
  EndIf 
  If DWord & #WS_EX_APPWINDOW 
    Text = Text + "taskbar window, " 
  EndIf 
  If DWord & #WS_EX_CLIENTEDGE 
    Text = Text + "sunken edge border, " 
  EndIf 
  If DWord & #WS_EX_COMPOSITED 
    Text = Text + "#WS_EX_COMPOSITED, " 
  EndIf 
  If DWord & #WS_EX_CONTEXTHELP 
    Text = Text + "question mark button, " 
  EndIf 
  If DWord & #WS_EX_CONTROLPARENT 
    Text = Text + "#WS_EX_CONTROLPARENT, " 
  EndIf 
  If DWord & #WS_EX_DLGMODALFRAME 
    Text = Text + "double border, " 
  EndIf 
  If DWord & #WS_EX_LAYERED 
    Text = Text + "layred, " 
  EndIf 
  If DWord & #WS_EX_LAYOUTRTL 
    Text = Text + "Arabic/Hebrew, " 
  EndIf 
  If DWord & #WS_EX_LEFT 
    Text = Text + "left-aligned, " 
  EndIf 
  If DWord & #WS_EX_LEFTSCROLLBAR 
    Text = Text + "left scroll bar, " 
  EndIf 
  If DWord & #WS_EX_LTRREADING 
    Text = Text + "left-to-right reading, " 
  EndIf 
  If DWord & #WS_EX_MDICHILD 
    Text = Text + "MDI child, " 
  EndIf 
  If DWord & #WS_EX_NOACTIVATE 
    Text = Text + "#WS_EX_NOACTIVATE, " 
  EndIf 
  If DWord & #WS_EX_NOINHERITLAYOUT 
    Text = Text + "#WS_EX_NOINHERITLAYOUT, " 
  EndIf 
  If DWord & #WS_EX_NOPARENTNOTIFY 
    Text = Text + "no #WS_PARENTNOTIFY message, " 
  EndIf 
  If DWord & #WS_EX_OVERLAPPEDWINDOW 
    Text = Text + "" 
  EndIf 
  If DWord & #WS_EX_PALETTEWINDOW 
    Text = Text + "" 
  EndIf 
  If DWord & #WS_EX_RIGHT 
    Text = Text + "right-aligned, " 
  EndIf 
  If DWord & #WS_EX_RIGHTSCROLLBAR 
    Text = Text + "right scroll bar, " 
  EndIf 
  If DWord & #WS_EX_RTLREADING 
    Text = Text + "right-to-left reading, " 
  EndIf 
  If DWord & #WS_EX_STATICEDGE 
    Text = Text + "3D border, " 
  EndIf 
  If DWord & #WS_EX_TOOLWINDOW 
    Text = Text + "tool window, " 
  EndIf 
  If DWord & #WS_EX_TOPMOST 
    Text = Text + "topmost, " 
  EndIf 
  If DWord & #WS_EX_TRANSPARENT 
    Text = Text + "transparent, " 
  EndIf 
  If DWord & #WS_EX_WINDOWEDGE 
    Text = Text + "raised edge, " 
  EndIf 
  
  If Text 
    Text = Left(Text, Len(Text) - 2) 
  Else 
    Text = "n/a" 
  EndIf 
  ProcedureReturn Text 
EndProcedure 

Procedure.s Placement_flags(DWord.l) 
  #WPF_ASYNCWINDOWPLACEMENT = $4 
  #WPF_RESTORETOMAXIMIZED = $2 
  #WPF_SETMINPOSITION = $1 
  
  Text.s = "" 
  If DWord & #WPF_ASYNCWINDOWPLACEMENT 
    Text = Text + "#WPF_ASYNCWINDOWPLACEMENT, " 
  EndIf 
  If DWord & #WPF_RESTORETOMAXIMIZED 
    Text = Text + "#WPF_RESTORETOMAXIMIZED, " 
  EndIf 
  If DWord & #WPF_SETMINPOSITION 
    Text = Text + "#WPF_SETMINPOSITION, " 
  EndIf 
  
  If Text 
    Text = Left(Text, Len(Text) - 2) 
  Else 
    Text = "n/a" 
  EndIf 
  ProcedureReturn Text 
EndProcedure 

Procedure.s Placement_showCmd(DWord.l) 
  Text.s = "" 
  If DWord & #SW_HIDE 
    Text = Text + "hide, " 
  EndIf 
  If DWord & #SW_MAXIMIZE 
    Text = Text + "maximize, " 
  EndIf 
  If DWord & #SW_MINIMIZE 
    Text = Text + "minimize, " 
  EndIf 
  If DWord & #SW_RESTORE 
    Text = Text + "restore, " 
  EndIf 
  If DWord & #SW_SHOW 
    Text = Text + "show, " 
  EndIf 
  If DWord & #SW_SHOWMAXIMIZED 
    Text = Text + "show maxmized, " 
  EndIf 
  If DWord & #SW_SHOWMINIMIZED 
    Text = Text + "show minimized, " 
  EndIf 
  If DWord & #SW_SHOWMINNOACTIVE 
    Text = Text + "show no active, " 
  EndIf 
  If DWord & #SW_SHOWNA 
    Text = Text + "show (na), " 
  EndIf 
  If DWord & #SW_SHOWNOACTIVATE 
    Text = Text + "show no activate, " 
  EndIf 
  If DWord & #SW_SHOWNORMAL 
    Text = Text + "show normal, " 
  EndIf 

  If Text 
    Text = Left(Text, Len(Text) - 2) 
  Else 
    Text = "n/a" 
  EndIf 
  ProcedureReturn Text 
EndProcedure 



Procedure.s GetWindowInfo(Handle.l) 
  Text.s = "Info about " + Hex(Handle) + ":" + LF + LF 
  If Handle 
    ;Width and height 
     If GetClientRect_(Handle, @Size.Rect) 
       Text = Text + "GetClientRect_:" + LF 
       Text = Text + "W" + Str(Size\Right) + "x" + Str(Size\Bottom) + LF + LF 
     EndIf 
    
    ;GetTitleBarInfo_() 
     Structure TITLEBARINFO 
       cbsize.l 
       rcTitleBar.Rect 
       rgState.l[6] 
     EndStructure 
      
     TitleBar.TITLEBARINFO 
     TitleBar\cbsize = SizeOf(TITLEBARINFO) 
     If GetTitleBarInfo_(Handle, @TitleBar) 
       Text = Text + "GetTitleBarInfo_:" + LF 
       Text = Text + "Rect: L" + Str(TitleBar\rcTitleBar\Left) + ", T" + Str(TitleBar\rcTitleBar\Top) 
       Text = Text + ", R" + Str(TitleBar\rcTitleBar\Right) + ", B" + Str(TitleBar\rcTitleBar\Bottom) + LF 
       Text = Text + "Elements:" + LF 
       Text = Text + "Title bar itself: " + rgState(TitleBar\rgState[0]) + LF 
       Text = Text + "Minimize Button: " + rgState(TitleBar\rgState[2]) + LF 
       Text = Text + "Maximize Button: " + rgState(TitleBar\rgState[3]) + LF 
       Text = Text + "Help Button: " + rgState(TitleBar\rgState[4]) + LF 
       Text = Text + "Close Button: " + rgState(TitleBar\rgState[5]) + LF + LF 
     EndIf 
      
    ;GetWindowInfo_ 
     #WS_ACTIVECAPTION = $1 
      
     WindowInfo.WINDOWINFO 
     WindowInfo\cbsize = SizeOf(WINDOWINFO) 
     If GetWindowInfo_(Handle, @WindowInfo) 
       Text = Text + "GetWindowInfo_:" + LF 
       Text = Text + "Window Rect: L" + Str(WindowInfo\rcWindow\Left) + ", T" + Str(WindowInfo\rcWindow\Top) 
       Text = Text + ", R" + Str(WindowInfo\rcWindow\Right) + ", B" + Str(WindowInfo\rcWindow\Bottom) + LF 
       Text = Text + "Client Rect: L" + Str(WindowInfo\rcClient\Left) + ", T" + Str(WindowInfo\rcClient\Top) 
       Text = Text + ", R" + Str(WindowInfo\rcClient\Right) + ", B" + Str(WindowInfo\rcClient\Bottom) + LF 
       Text = Text + "Style: " + dwStyle(WindowInfo\dwStyle) + LF 
       Text = Text + "Ex Style: " + dwExStyle(WindowInfo\dwExStyle) + LF 
       Text = Text + "Status: " 
       If WindowInfo\dwWindowStatus & #WS_ACTIVECAPTION 
         Text = Text + "activated" + LF 
       Else 
         Text = Text + "deactivated" + LF 
       EndIf 
       Text = Text + "Border width: " + Str(WindowInfo\cxWindowBorders) + LF 
       Text = Text + "Border height: " + Str(WindowInfo\cyWindowBorders) + LF 
       Text = Text + "Windows version: " + Str(WindowInfo\wCreatorVersion) + LF + LF 
     EndIf 
      
    ;GetModuleFileName_ 
     ModuleName.s = Space(1024) 
     If GetModuleFileName_(Handle, ModuleName, 1024) 
       Text = Text + "GetModuleFileName_:" + LF 
       Text = Text + ModuleName + LF + LF 
     EndIf 
      
    ;GetWindowPlacement_ 
     Placement.WINDOWPLACEMENT 
     Placement\length = SizeOf(WINDOWPLACEMENT) 
     If GetWindowPlacement_(Handle, @Placement) 
       Text = Text + "GetWindowPlacement_:" + LF 
       Text = Text + "Flags: " + Placement_flags(Placement\flags) + LF 
       Text = Text + "Show state: " + Placement_showCmd(Placement\showCmd) + LF 
       Text = Text + "Min Position: " + Str(Placement\ptMinPosition\x) + "x" + Str(Placement\ptMinPosition\y) + LF 
       Text = Text + "Max Position: " + Str(Placement\ptMaxPosition\x) + "x" + Str(Placement\ptMaxPosition\y) + LF 
       Text = Text + "Normal Position: L" + Str(Placement\rcNormalPosition\Left) + ", T" + Str(Placement\rcNormalPosition\Top) 
       Text = Text + ", R" + Str(Placement\rcNormalPosition\Right) + ", B" + Str(Placement\rcNormalPosition\Bottom) + LF + LF 
     EndIf 
      
    ;IsWindowUnicode_ 
     Text = Text + "IsWindowUnicode_: " 
     If IsWindowUnicode_(Handle) 
       Text = Text + "yes" 
     Else 
       Text = Text + "no" 
     EndIf 
     ;Text = Text + LF + LF 
  Else 
    Text.s = "No info available" 
  EndIf 
  ProcedureReturn Text 
EndProcedure 

;- 

Procedure SetGadgetStateLI(Gadget.l, State.l) 
  Protected a.l 
  For a = 0 To CountGadgetItems(Gadget) - 1 
    If a = State 
      SetGadgetItemState(Gadget, a, #PB_ListIcon_Selected) 
    Else 
      SetGadgetItemState(Gadget, a, 0) 
    EndIf 
  Next 
  SendMessage_(GadgetID(Gadget), #LVM_ENSUREVISIBLE, State, 1) 
EndProcedure 

Procedure SetCursorOnHandle(Handle.l) 
  ResetList(Window()) 
  While NextElement(Window()) 
    If Window()\Handle = Handle 
      
      If Window()\Rekursion 
        Rek.l = Window()\Rekursion 
        While PreviousElement(Window()) And Window()\Rekursion 
          If Window()\Rekursion < Rek 
            SetGadgetItemState(0, ListIndex(Window()) - 1, #PB_Tree_Expanded) 
            Rek = Window()\Rekursion 
          EndIf 
        Wend 
        SetGadgetItemState(0, ListIndex(Window()) - 1, #PB_Tree_Expanded) 
      EndIf 
      SetGadgetState(0, ListIndex(Window()) - 1) 
      ProcedureReturn #True 
    EndIf 
  Wend 
  ProcedureReturn #False 
EndProcedure 

Procedure AddLog(Text.s) 
  State.l = CountGadgetItems(2) 
  Zeit.s = FormatDate("%hh:%ii:%ss", Date()) 
  AddGadgetItem(2, State, Zeit) 
  SetGadgetItemText(2, State, Text, 1) 
  SetGadgetStateLI(2, State) 
EndProcedure 

Width.l = 800 
Height.l = 600 

If OpenWindow(0, 0, 0, Width, Height, "AllWindows and Childs", #PB_Window_SizeGadget | #PB_Window_ScreenCentered | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget) 
  If CreateGadgetList(WindowID(0)) 
    #T1Width = 140 
    #TextHeight = 16 
    #ButtonHeight = 18 
    #StrHeight = 200 
    #Abs = 5 
    #PanelHeight = 200 

    TreeGadget(0, 0, 0, Width - #T1Width - 5, Height - #PanelHeight - 5, #PB_Tree_AlwaysShowSelection | #PB_Tree_NoLines)    
    
    PanelGadget(5, 0, Height - #PanelHeight, Width - #T1Width - 5, #PanelHeight) 
    AddGadgetItem(5, 0, "Log") 
      ListIconGadget(2, 0, 0, Width - #T1Width - 52, #PanelHeight - 25, "Zeit", 100, #PB_ListIcon_AlwaysShowSelection | #PB_ListIcon_FullRowSelect) 
      AddGadgetColumn(2, 1, "Log", 1000) 
      ButtonGadget(3, Width - #T1Width - 50, 0, 40, #PanelHeight - 25, "Clear") 
    AddGadgetItem(5, 1, "Window Info") 
      StringGadget(4, 0, 0, Width - #T1Width - 10, #PanelHeight - 25, "", #ES_MULTILINE | #WS_VSCROLL | #WS_HSCROLL) 
    CloseGadgetList() 
    
    ButtonGadget(10, Width - #T1Width, 0 * #ButtonHeight + 0 * #Abs, #T1Width, #ButtonHeight, "Refresh Memory") 
    ButtonGadget(11, Width - #T1Width, 1 * #ButtonHeight + 0 * #Abs, #T1Width, #ButtonHeight, "Refresh List") 
    
    ButtonGadget(12, Width - #T1Width, 2 * #ButtonHeight + 1 * #Abs, #T1Width, #ButtonHeight, "Open All Nodes") 
    ButtonGadget(14, Width - #T1Width, 3 * #ButtonHeight + 1 * #Abs, #T1Width, #ButtonHeight, "Open Whole Node") 
    
    
    ButtonGadget(16, Width - #T1Width, 4 * #ButtonHeight + 3 * #Abs, #T1Width, #ButtonHeight, "Post Quit") 
    ButtonGadget(17, Width - #T1Width, 5 * #ButtonHeight + 3 * #Abs, #T1Width, #ButtonHeight, "Post Close") 
    
    ButtonGadget(18, Width - #T1Width, 6 * #ButtonHeight + 4 * #Abs, #T1Width, #ButtonHeight, "Terminate Process") 
    
    ButtonGadget(20, Width - #T1Width, 7 * #ButtonHeight + 6 * #Abs, #T1Width, #ButtonHeight, "CloseWindow_") 
    ButtonGadget(21, Width - #T1Width, 8 * #ButtonHeight + 6 * #Abs, #T1Width, #ButtonHeight, "DestroyWindow_") 
    ButtonGadget(22, Width - #T1Width, 9 * #ButtonHeight + 6 * #Abs, #T1Width, #ButtonHeight, "Window Info") 
    ButtonGadget(23, Width - #T1Width, 10 * #ButtonHeight + 6 * #Abs, #T1Width, #ButtonHeight, "GetDesktopWindow_") 
    ButtonGadget(24, Width - #T1Width, 11 * #ButtonHeight + 6 * #Abs, #T1Width, #ButtonHeight, "GetForegroundWindow_") 
    ButtonGadget(25, Width - #T1Width, 12 * #ButtonHeight + 6 * #Abs, #T1Width, #ButtonHeight, "GetNextWindow_") 
    ButtonGadget(26, Width - #T1Width, 13 * #ButtonHeight + 6 * #Abs, #T1Width, #ButtonHeight, "GetPrevWindow_") 
    
    Width - 1 
    Repeat 
      If Width <> WindowWidth(0) Or Height <> WindowHeight(0) 
        Width = WindowWidth(0) 
        Height = WindowHeight(0) 
        ResizeGadget(0,#PB_Ignore,#PB_Ignore, Width - #T1Width - 5, Height - #PanelHeight - 5) 
        ResizeGadget(2,#PB_Ignore,#PB_Ignore, Width - #T1Width - 52,#PB_Ignore) 
        ResizeGadget(3, Width - #T1Width - 50,#PB_Ignore,#PB_Ignore,#PB_Ignore) 
        ResizeGadget(4,#PB_Ignore,#PB_Ignore, Width - #T1Width - 10,#PB_Ignore) 
        ResizeGadget(5,#PB_Ignore, Height - #PanelHeight, Width - #T1Width - 5,#PB_Ignore) 
        For a.l = 10 To 26 
          If IsGadget(a) And GadgetID(a) 
            ResizeGadget(a, Width - #T1Width,#PB_Ignore,#PB_Ignore,#PB_Ignore) 
          EndIf 
        Next 
      EndIf 
      
      If CountList(Window()) 
        DisableGadget(11, 0) 
      Else 
        DisableGadget(11, 1) 
      EndIf 
      
      If CountGadgetItems(0) 
        DisableGadget(12, 0) 
        DisableGadget(23, 0) 
        DisableGadget(24, 0) 
      Else 
        DisableGadget(12, 1) 
        DisableGadget(23, 1) 
        DisableGadget(24, 1) 
      EndIf 
      
      State.l = GetGadgetState(0) 
      
      If State >= 0 
        SelectElement(Window(), State) 
        If Window()\Childs 
          DisableGadget(14, 0) 
        Else 
          DisableGadget(14, 1) 
        EndIf 
        DisableGadget(16, 0) 
        DisableGadget(17, 0) 
        
        Result.l = OpenProcess_(#PROCESS_ALL_ACCESS, #True, Window()\Process) 
        If Result 
          DisableGadget(18, 0) 
          CloseHandle_(Result) 
        Else 
          DisableGadget(18, 0)        
        EndIf 
        
        For a.l = 19 To 21 
          If IsGadget(a) And GadgetID(a) : DisableGadget(a, 0) : EndIf 
        Next 
        
        If IsWindow_(Window()\Handle) 
          DisableGadget(22, 0) 
        Else 
          DisableGadget(22, 1) 
        EndIf 
        
        DisableGadget(25, 0) 
        DisableGadget(26, 0) 
      Else 
        For a.l = 14 To 22 
          If IsGadget(a) And GadgetID(a) : DisableGadget(a, 1) : EndIf 
        Next 
        For a.l = 25 To 26 
          If IsGadget(a) And GadgetID(a) : DisableGadget(a, 1) : EndIf 
        Next 
      EndIf 
      
      If CountGadgetItems(2) 
        DisableGadget(3, 0) 
        DisableGadget(2, 0) 
      Else 
        DisableGadget(3, 1) 
        DisableGadget(2, 1) 
      EndIf 
      
      If Trim(GetGadgetText(4)) = "" 
        DisableGadget(4, 1) 
      Else 
        DisableGadget(4, 0) 
      EndIf 

      EventID.l = WaitWindowEvent() 
      Select EventID 
        Case #PB_Event_CloseWindow 
          End 
        
        Case #PB_Event_Gadget 
          Select EventGadget() 
            Case 3  ;Clear Log 
              ClearGadgetItemList(2) 
              
            Case 10 ;Refresh Memory 
              Time.l = GetTickCount_() 
              EnumAllWindows() 
              Time.l = GetTickCount_() - Time 
              AddLog("Enum windows in " + Str(Time) + " ms.") 
              AddLog(Str(CountList(Window())) + " windows found") 
            
            Case 11 ;Refresh List 
              Time.l = GetTickCount_() 
              RefreshList(1) 
              Time.l = GetTickCount_() - Time 
              AddLog("Refresh list in " + Str(Time) + " ms.") 
            
            Case 12 ;Open All Nodes 
              Time.l = GetTickCount_() 
              RefreshList(2) 
              Time.l = GetTickCount_() - Time 
              AddLog("Opened all nodes in " + Str(Time) + " ms.") 
            
            Case 14 ;Open Whole Node 
              Time.l = GetTickCount_() 
              RefreshList(8) 
              Time.l = GetTickCount_() - Time 
              AddLog("Opened whole node in " + Str(Time) + " ms.") 
            
            Case 16 ;Post Quit 
              PostMessage_(Window()\handle, #WM_QUIT, 0, 0) 
            Case 17 ;Post Close 
              PostMessage_(Window()\handle, #WM_CLOSE, 0, 0) 
            
            Case 18 ;Terminate Process 
              Result.l = OpenProcess_(#PROCESS_ALL_ACCESS, #True, Window()\Process) 
              If Result 
                If TerminateProcess_(Result, 0) 
                  AddLog("The process with the ID " + Str(Window()\Process) + " was successfully terminated.") 
                  DelProcInList(Window()\Process) 
                  AddLog("List refresh needed") 
                EndIf 
                CloseHandle_(Result) 
              EndIf 
            
            Case 20 ;CloseWindow_ 
              CloseWindow_(Window()\Handle) 
            
            Case 21 ;DestroyWindow_ 
              DestroyWindow_(Window()\Handle) 
            
            Case 22 ;Window Info 
              Text.s = GetWindowInfo(Window()\Handle) 
              SetGadgetText(4, Text) 
              SetGadgetState(5, 1) 
              
            Case 23 ;GetDesktopWindow_ 
              Result.l = GetDesktopWindow_() 
              If Result 
                SetCursorOnHandle(Result) 
              EndIf 
              
            Case 24 ;GetForegroundWindow_ 
              Result.l = GetForegroundWindow_() 
              If Result 
                SetCursorOnHandle(Result) 
              EndIf 
            
            Case 25 ;GetNextWindow_ 
              Result.l = GetWindow_(Window()\Handle, #GW_HWNDNEXT) 
              If Result 
                SetCursorOnHandle(Result) 
                AddLog("Handle: " + Str(Result)) 
              Else 
                AddLog("No next Window") 
              EndIf 
            
            Case 26 ;GetPrevWindow_ 
              Result.l = GetWindow_(Window()\Handle, #GW_HWNDPREV) 
              If Result 
                SetCursorOnHandle(Result) 
                AddLog("Handle: " + Str(Result)) 
              Else 
                AddLog("No previous Window") 
              EndIf 
          EndSelect 
      EndSelect 
    ForEver 
  EndIf 
EndIf 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ---
; EnableXP
; DisableDebugger
