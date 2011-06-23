; German forum: http://www.purebasic.fr/german/viewtopic.php?t=10149&postdays=0&postorder=asc&start=100
; Author: edel
; Date: 05. February 2007
; OS: Windows
; Demo: Yes


;- MDI Example 4.02

Enumeration
  #MAIN_WINDOW
EndEnumeration

Enumeration
  #MDI_MAIN
EndEnumeration

Enumeration
  #MAIN_MENU
EndEnumeration

Enumeration
  #MENU_NEW
  #MENU_OPEN
  #MENU_SAVE
  #MENU_SAVEAS
  #MENU_CLOSE
  #MENU_CLOSEALL
  #MENU_EXIT

  #MENU_CASCADE
  #MENU_TILEH
  #MENU_TILEV
  #MENU_ARRANGE
  #MENU_NEXT
  #MENU_PREV
  #MENU_NORMAL
  #MENU_NORMALALL
  #MENU_MAXIMIZE
  #MENU_MAXIMIZEALL
  #MENU_MINIMIZE
  #MENU_MINIMIZEALL

  #MENU_RESIZE_DEMO

  #MENU_WINDOW_POS
EndEnumeration

Define.l hwnd,event,window
NewList MDI_WINDOW_LIST.l()

;-

Procedure NewMdiChild()
  Shared MDI_WINDOW_LIST.l()

  AddElement(MDI_WINDOW_LIST())
  MDI_WINDOW_LIST() = AddGadgetItem(#MDI_MAIN,#PB_Any,"MDI - Childwindow")

  ProcedureReturn MDI_WINDOW_LIST()
EndProcedure

Procedure CloseMdiChild(Child=-1)
  Shared MDI_WINDOW_LIST.l()

  If Child = -1 ; alle schliessen

    ForEach MDI_WINDOW_LIST()
      Child = MDI_WINDOW_LIST()
      CloseWindow(Child)
    Next

    ClearList(MDI_WINDOW_LIST())

  Else

    ForEach MDI_WINDOW_LIST()
      If Child = MDI_WINDOW_LIST()
        CloseWindow(Child)
        DeleteElement(MDI_WINDOW_LIST())
        Break
      EndIf
    Next

  EndIf

EndProcedure

;-

hwnd = OpenWindow(#MAIN_WINDOW,#PB_Ignore,#PB_Ignore,640,480,"MDI-Test")

If CreateMenu(#MAIN_MENU,hwnd)

  MenuTitle("File")
  MenuItem(#MENU_NEW        , "New"       +Chr(9)+"Ctrl+N")
  MenuItem(#MENU_OPEN       , "Open"      +Chr(9)+"Ctrl+O")
  MenuItem(#MENU_SAVE       , "Save"      +Chr(9)+"Ctrl+S")
  MenuItem(#MENU_SAVEAS     , "Save as"                   )
  MenuBar()
  MenuItem(#MENU_CLOSE      , "Close"     +Chr(9)+"Ctrl+W")
  MenuItem(#MENU_CLOSEALL   , "Close all"                 )
  MenuBar()
  MenuItem(#MENU_EXIT       , "Exit"      +Chr(9)+"Alt+F4")

  MenuTitle("Windows")
  MenuItem(#MENU_CASCADE    , "Cascade")
  MenuItem(#MENU_TILEH      , "Tile horizontally")
  MenuItem(#MENU_TILEV      , "Tile vertically")
  MenuItem(#MENU_ARRANGE    , "Arrange")
  MenuBar()
  MenuItem(#MENU_NEXT       , "Next")
  MenuItem(#MENU_PREV       , "Previous")
  MenuBar()
  MenuItem(#MENU_NORMAL     , "Restore")
  MenuItem(#MENU_NORMALALL  , "Restore all")
  MenuItem(#MENU_MAXIMIZE   , "Maximize")
  MenuItem(#MENU_MAXIMIZEALL, "Maximize all")
  MenuItem(#MENU_MINIMIZE   , "Minimize")
  MenuItem(#MENU_MINIMIZEALL, "Minimize all")
  MenuBar()
  MenuItem(#MENU_RESIZE_DEMO, "Resize Demo")

  AddKeyboardShortcut(#MAIN_WINDOW,#PB_Shortcut_Control|#PB_Shortcut_N,#MENU_NEW)
  AddKeyboardShortcut(#MAIN_WINDOW,#PB_Shortcut_Control|#PB_Shortcut_O,#MENU_OPEN)
  AddKeyboardShortcut(#MAIN_WINDOW,#PB_Shortcut_Control|#PB_Shortcut_S,#MENU_SAVE)
  AddKeyboardShortcut(#MAIN_WINDOW,#PB_Shortcut_Control|#PB_Shortcut_W,#MENU_CLOSE)

EndIf

CreateGadgetList(hwnd)
MDIGadget(#MDI_MAIN,#PB_Ignore,#PB_Ignore,640,480-MenuHeight(),1,#MENU_WINDOW_POS)

NewMdiChild()

;-

Repeat
  event  = WaitWindowEvent()
  window = EventWindow()

  If window = #MAIN_WINDOW ; events fuer das Hauptfenster

    If event = #PB_Event_CloseWindow
      End
    EndIf

    If event = #PB_Event_Menu

      Select EventMenu()
        Case #MENU_NEW
          NewMdiChild()
        Case #MENU_OPEN
          Debug "not implemented"
        Case #MENU_SAVE
          Debug "not implemented"
        Case #MENU_SAVEAS
          Debug "not implemented"
        Case #MENU_CLOSE
          window = GetGadgetState(#MDI_MAIN)
          CloseMdiChild(window)
        Case #MENU_CLOSEALL
          CloseMdiChild(-1)
        Case #MENU_EXIT
          End
        Case #MENU_CASCADE
          SetGadgetState(#MDI_MAIN,#PB_MDI_Cascade)
        Case #MENU_TILEH
          SetGadgetState(#MDI_MAIN,#PB_MDI_TileHorizontally)
        Case #MENU_TILEV
          SetGadgetState(#MDI_MAIN,#PB_MDI_TileVertically)
        Case #MENU_ARRANGE
          SetGadgetState(#MDI_MAIN,#PB_MDI_Arrange)
        Case #MENU_NEXT
          SetGadgetState(#MDI_MAIN,#PB_MDI_Next)
        Case #MENU_PREV
          SetGadgetState(#MDI_MAIN,#PB_MDI_Previous)
        Case #MENU_NORMAL
          window = GetGadgetState(#MDI_MAIN)
          SetWindowState(window,#PB_Window_Normal)
        Case #MENU_NORMALALL
          ForEach MDI_WINDOW_LIST()
            window = MDI_WINDOW_LIST()
            SetWindowState(window,#PB_Window_Normal)
          Next
        Case #MENU_MAXIMIZE
          window = GetGadgetState(#MDI_MAIN)
          SetWindowState(window,#PB_Window_Maximize)
        Case #MENU_MAXIMIZEALL
          ForEach MDI_WINDOW_LIST()
            window = MDI_WINDOW_LIST()
            SetWindowState(window,#PB_Window_Maximize)
          Next
        Case #MENU_MINIMIZE
          window = GetGadgetState(#MDI_MAIN)
          SetWindowState(window,#PB_Window_Minimize)
        Case #MENU_MINIMIZEALL
          ForEach MDI_WINDOW_LIST()
            window = MDI_WINDOW_LIST()
            SetWindowState(window,#PB_Window_Minimize)
          Next
        Case #MENU_RESIZE_DEMO
          window = GetGadgetState(#MDI_MAIN)
          If IsWindow(window)
            ResizeWindow(window,#PB_Ignore,#PB_Ignore,Random(400)+100,Random(400)+100)
          EndIf
      EndSelect

    EndIf

  Else ; andere Fenster

    Select event
      Case #WM_SYSCOMMAND ; wenn das fenster ueber das eigene Menu geschlossen wird.
        If EventwParam() = #SC_CLOSE
          CloseMdiChild(window)
        EndIf
      Case #PB_Event_CloseWindow
        CloseMdiChild(window)
    EndSelect

  EndIf


ForEver

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP