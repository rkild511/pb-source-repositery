; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8180&highlight=
; Author: Danilo
; Date: 05. November 2003
; OS: Windows
; Demo: No

#TBDDRET_DEFAULT      = 0 ; The drop-down was handled. 
#TBDDRET_NODEFAULT    = 1 ; The drop-down was not handled. 
#TBDDRET_TREATPRESSED = 2 ; The drop-down was handled, but treat the button like a regular button. 
#TBN_DROPDOWN         = #TBN_FIRST - 10 

Procedure WindowProc(hWnd,Msg,wParam,lParam) 
  WindowProc = #PB_ProcessPureBasicEvents 
  Select Msg 
    Case #WM_SIZE 
      UpdateTB(0) 
    Case #WM_NOTIFY 
      *nmTB.NMTOOLBAR = lParam 
      Select *nmTB\hdr\code 
        Case #TBN_DROPDOWN 
          ;Beep_(800,10) 
          GetTBbuttonRect(*nmTB\iItem,rect.RECT) 
          DisplayPopupMenu(1,hWnd,rect\left,rect\bottom) 
          WindowProc = #TBDDRET_DEFAULT 
      EndSelect 
  EndSelect 

  ;UpdateTB(0) 
  ProcedureReturn WindowProc 
EndProcedure 

If CreatePopupMenu(1) 
  MenuItem(1, "Aliases...") 
  MenuItem(2, "Popups...") 
  MenuItem(3, "Remote...") 
  MenuBar() 
  MenuItem(4, "Addresses...") 
  MenuBar() 
  MenuItem(5, "Finger...") 
  MenuItem(6, "Timer...") 
  MenuBar() 
  MenuItem(7, "Colors...") 
  MenuItem(8, "Font...") 
EndIf 

hWnd = OpenWindow(0,0,0,200,200,"DropDown",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  CreateTB(0,hWnd,24,24,#TBpro_TRANSPARENT|#TBpro_FLAT) 
    SetTBimage(0,0,#TBpro_NORMAL) 
    SetTBimage(0,0,#TBpro_HOT) 
    SetTBimage(0,0,#TBpro_DISABLED) 
    AddTBsysIcons() 

  SetWindowCallback(@WindowProc()) 

  For a = 1 To 32 
      AddTBbutton(599+a,#TBpro_CUT+a-1,#TBpro_DropdownBUTTON) 
      If a % 10 = 0 : AddTBbreak() 
      Else          : AddTBseparator() : EndIf 
      SetTBbuttonTooltip(599+a,"DropDown Button "+Str(a)) 
  Next a 

  ResizeWindow(0,#PB_Ignore,#PB_Ignore,TBwidth(),TBheight()) 
  UpdateTB() 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow : End 
    Case #PB_Event_Gadget 
      GadgetID = EventGadget() 
      If GadgetID >= 600 And GadgetID <= 631 
        MessageRequester("INFO","You pressed the Toolbar button "+Chr(13)+"with the ID: "+Str(GadgetID),#MB_ICONINFORMATION) 
      EndIf 
    Case #PB_Event_Menu 
      MessageRequester("INFO","MenuID: "+Str(EventMenu()),#MB_ICONINFORMATION) 
  EndSelect 
ForEver

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
