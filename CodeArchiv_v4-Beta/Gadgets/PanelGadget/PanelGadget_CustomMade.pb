; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13337&highlight=
; Author: Sparkie (updated for PB 4.00 by Andre)
; Date: 10. December 2004
; OS: Windows
; Demo: No

; Be aware that PanelGadget's with tabs on the sides or bottom are not supported 
; with XP skins enabled. msdn info here: 
; http://msdn.microsoft.com/library/default.asp?url=/library/en-us/shellcc/platform/commctls/tab/styles.asp
; 
; I've had some success with the native PanelGadget but for now it seems easier 
; to use Win32 API to create your own. This is what I've come up with so far. 
; This code creates a TabControl (PanelGadget) with tabs on the left side. 
; 
; Not sure how efficient this would be in a real project, but here it is none the less. 

#TCS_TABS = 0 
#TCS_BOTTOM = 2       ; Place tabs on bottom 
#TCS_RIGHT = 2        ; Place tabs on right 
#TCS_FLATBUTTONS = 8 
#TCS_VERTICAL = $80   ; Place tabs on left 
#TCS_BUTTONS = $100 
#TCS_MULTILINE = $200 ; Required if using #TCS_VERTICAL 
#Panel_0 = 100 
Enumeration 
  #Container_0 
  #Container_1 
  #Button_0 
  #Button_1 
  #ExplorerList_0 
  #ExplorerTree_0 
EndEnumeration 

Procedure myWindowCallback(hwnd, msg, wparam, lparam) 
  Shared tabToHideID 
  result = #PB_ProcessPureBasicEvents 
  Select msg 
    Case #WM_NOTIFY 
      *pnmhdr.NMHDR = lparam 
      If *pnmhdr\code = #TCN_SELCHANGING 
        *ptcnmhdr.NMHDR = lparam 
        ; --> Get Tab that is losing focus (this ID = #Container_0 or #Container_1) 
        tabToHideID = SendMessage_(*ptcnmhdr\hwndFrom, #TCM_GETCURSEL, 0, 0) 
      EndIf 
      If *pnmhdr\code = #TCN_SELCHANGE 
        *ptcnmhdr.NMHDR = lparam 
        ; --> Get Tab that is gaining focus (this ID = #Container_0 or #Container_1) 
        tabToShowID = SendMessage_(*ptcnmhdr\hwndFrom, #TCM_GETCURSEL, 0, 0) 
        If *ptcnmhdr\idFrom = #Panel_0 
          ; --> Show / hide tab contents 
          HideGadget(tabToShowID, 0) 
          HideGadget(tabToHideID, 1) 
        EndIf 
      EndIf 
  EndSelect 
  ProcedureReturn result 
EndProcedure 

If OpenWindow(0, 0, 0, 400, 200,"Sparkies Custom PanelGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
  SetWindowCallback(@myWindowCallback()) 
  panelX = 10 
  panelY = 10 
  panelW = WindowWidth(0) - 20 
  panelH = WindowHeight(0) - 20 
  ; --> Define style and create PanelGadget() 
  ; --> To use standard tabs 
  tcStyle = #TCS_TABS | #TCS_MULTILINE | #TCS_VERTICAL 
  ; --> To use buttons 
  ;tcStyle = #TCS_BUTTONS | #TCS_MULTILINE | #TCS_VERTICAL 
  ; --> To use flat buttons 
  ;tcStyle = #TCS_FLATBUTTONS | #TCS_BUTTONS | #TCS_MULTILINE | #TCS_VERTICAL 
  hPanel = CreateWindowEx_(#WS_EX_LEFT | #WS_EX_LTRREADING | #WS_EX_RIGHTSCROLLBAR, "SysTabControl32", "PanelGadget1", #WS_OVERLAPPED | #WS_CHILD | #WS_VISIBLE | #WS_CLIPSIBLINGS | #WS_GROUP | #WS_TABSTOP | tcStyle, panelX, panelY, panelW, panelH, WindowID(0), #Panel_0, GetModuleHandle_(0) , 0) 
  ; --> Load and set font to use for tabs (optional) 
  tabFont = LoadFont(0, "Arial", 10, #PB_Font_Bold) 
  SendMessage_(hPanel, #WM_SETFONT, tabFont, 1) 
  pgadItem.TC_ITEM 
  ; --> init Tab #1 
  tabText1$ = "Tab #1" 
  pgadItem\mask = #TCIF_TEXT 
  pgadItem\pszText = @tabText1$ 
  pgadItem\cchTextMax = Len(tabText1$) 
  ; --> Insert tab #1 
  SendMessage_(hPanel, #TCM_INSERTITEM, #Container_0, pgadItem) 
  ; Get rect for tab for placement of our ContainerGadgets to follow 
  SendMessage_(hPanel, #TCM_GETITEMRECT, #Container_0, @tcRect.RECT) 
  ; --> Need to work on a better placement formula, but this seems to work for now 
  ContainerGadget(#Container_0, panelX+(tcRect\right-tcRect\left)+3, panelY+tcRect\top, panelW-(tcRect\right-tcRect\left)-6, panelH-6) 
  ; --> Add some gadgets to Tab #1 (#Conatiner_0 is parent) 
  ButtonGadget(#Button_0, 100, 10, 120, 20, "Hello, we are in Tab #1") 
  ExplorerListGadget(#ExplorerList_0, 10, 35, 330, 120, "c:\") 
  CloseGadgetList() 
  ; --> init Tab #2 
  tabText2$ = "Tab #2" 
  pgadItem\mask = #TCIF_TEXT 
  pgadItem\pszText = @tabText2$ 
  pgadItem\cchTextMax = Len(tabText2$) 
  SendMessage_(hPanel, #TCM_INSERTITEM, #Container_1, pgadItem) 
  ; --> Need to work on a better placement formula, but this seems to work for now 
  ContainerGadget(#Container_1, panelX+(tcRect\right-tcRect\left)+3, panelY+tcRect\top, panelW-(tcRect\right-tcRect\left)-6, panelH-6) 
  ; --> Add some gadgets to Tab #1 (#Conatiner_1 is parent) 
  ButtonGadget(#Button_1, 100, 10, 120, 20, "Hello, we are in Tab #2") 
  ExplorerTreeGadget(#ExplorerTree_0, 10, 35, 330, 120, "c:\") 
  CloseGadgetList() 
  ; --> We start off in Tab #1 so we hide Tab #2 contents (#Container_1) 
  HideGadget(#Container_1, 1) 
  
  Repeat 
    event = WaitWindowEvent() 
  Until event = #PB_Event_CloseWindow 
EndIf 
End
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -