; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2027&highlight=
; Author: PWS32 (based on older code snippets, updated for PB4.00 by blbltheworm)
; Date: 19. August 2003
; OS: Windows
; Demo: No

#FontSelWin       = 2001
#FontSelGadGet    = 2002
Global FontText$, ListPOS.l, ListhWnd.l
;{ *** FontList Procedures  ***
Procedure CreateListFontWindow()
  hWnd = OpenWindow(#FontSelWin,0,0,270,140,"",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  ListhWnd = hWnd ;hWnd is lost by exit the Procedure ?? this trick help !!
  If CreateGadgetList(WindowID(#FontSelWin))
    ListViewGadget(#FontSelGadGet,10,10,250,120)
  EndIf
  AddKeyboardShortcut(#FontSelWin,#PB_Shortcut_Return,1)    ; Return Button
  AddKeyboardShortcut(#FontSelWin,#PB_Shortcut_Down,2)      ; Cursor Down Button
  AddKeyboardShortcut(#FontSelWin,#PB_Shortcut_Up,3)          ; Cursor Up Button
  SetActiveGadget(#FontSelGadGet)
EndProcedure
Procedure EnumFontFamProc(*lpelf.ENUMLOGFONT, *lpntm.NEWTEXTMETRIC, FontType, lParam) ; GetFonts and trans. to List
  ;Debug PeekS(@*lpelf\elfLogFont\lfFaceName[0])
  AddGadgetItem (#FontSelGadGet,-1,PeekS(@*lpelf\elfLogFont\lfFaceName[0]))
     ; more informations can be get from the LOGFONT structure, for example adding following code:
     ; +", Height: "+Str(PeekL(@*lpelf\elfLogFont\lfHeight))+", Width: "+Str(PeekL(@*lpelf\elfLogFont\lfWidth)))
  SetGadgetState(#FontSelGadGet,0)
  FontText$= GetGadgetText(#FontSelGadGet)
  SetWindowText_(hWnd, FontText$)
  ProcedureReturn 1
EndProcedure
Procedure SysInfo_Fonts()
  hWnd = GetDesktopWindow_()
  hDC = GetDC_(hWnd)
  EnumFontFamilies_(hDC, 0, @EnumFontFamProc(), 0)
  ReleaseDC_ (hWnd, hDC)
EndProcedure
Procedure FontListEvent()
  Repeat
    
    EventID.l = WaitWindowEvent()
    FontText$= GetGadgetText(#FontSelGadGet)
    SetWindowText_(ListhWnd, FontText$)
    Select EventID
    Case #PB_Event_Menu
      If EventMenu()=1 ;  Return Button
        FontText$= GetGadgetText(#FontSelGadGet)
        ListPOS=GetGadgetState(#FontSelGadGet)
        MessageRequester("FontInformation", FontText$, 0)
        SetGadgetState(#FontSelGadGet,ListPOS)
      EndIf
      If EventMenu()=2 ; Cursor Down Button
        FontText$= GetGadgetText(#FontSelGadGet)
        ListPOS=GetGadgetState(#FontSelGadGet)
        SetGadgetState(#FontSelGadGet,ListPOS+1)
      EndIf
      If EventMenu()=3 ; Cursor Up Button
        FontText$= GetGadgetText(#FontSelGadGet)
        ListPOS=GetGadgetState(#FontSelGadGet)
        SetGadgetState(#FontSelGadGet,ListPOS-1)
        If ListPOS =< 0
          SetGadgetState(#FontSelGadGet,0)
        EndIf
      EndIf
      
    Case #PB_Event_CloseWindow ; If the user has pressed on the close button
      Quit = 1
    Case #PB_Event_Gadget
      Select EventGadget()
      Case #FontSelGadGet
        Select EventType()
        Case #PB_EventType_LeftDoubleClick
          FontText$= GetGadgetText(#FontSelGadGet)
          MessageRequester("FontInformation", FontText$, 0)
        EndSelect
      EndSelect
    EndSelect
  Until Quit = 1
  CloseWindow(#FontSelWin)
EndProcedure
;}

CreateListFontWindow()
SysInfo_Fonts()
FontListEvent()
MessageRequester("FontList", "Programm Exit", 0)


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
