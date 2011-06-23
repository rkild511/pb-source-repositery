; German forum: http://www.purebasic.fr/german/viewtopic.php?t=817&postdays=0&postorder=asc&start=10
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 15. November 2004
; OS: Windows
; Demo: No

; Popup menu with graphics
; Popup-Menü mit Grafik

; 
; Owner Drawn PopUp Menu 
; 
;   by Danilo, 10.11.2004 - german forum 
; 
;   - updated by Danilo, 15.11.2004: 
;     * corrected drawing of MenuBars 
;     * added disabled state (DisableMenuItem) 
;     * added checked  state (SetMenuItemState) 
; 
; 
#MIIM_FTYPE  = $100 
#MIIM_TYPE   = $10 
#MIIM_STRING = $40 

Global hMenu,hBmp,hBmpWidth,hBmpHeight,tempDC 


Procedure GetMenuHeight(hWnd,Menu) 
  mem = AllocateMemory(1024) 
  If mem 
    hDC     = GetDC_(hWnd) 
    GetTextExtentPoint32_(hDC,"X",1,size.SIZE); 
    ReleaseDC_(hWnd,hDC) 

    mii.MENUITEMINFO 
    mii\cbSize        = SizeOf(MENUITEMINFO) 
    mii\fMask         = #MIIM_STRING;|#MIIM_TYPE 
    ;mii\fType         = #MFT_STRING 
    mii\dwTypeData    = mem 
    mii\cch           = 1023 
  
    For i = 0 To GetMenuItemCount_(Menu)-1 
      mii\dwTypeData    = mem 
      mii\cch           = 1023 
      If GetMenuItemInfo_(Menu,i,#True,@mii) 
        If mii\dwTypeData 
          If PeekS(mii\dwTypeData) 
            sizeX + size\cy 
          Else 
            sizeX + 6 
          EndIf 
        Else 
          sizeX + 6 
        EndIf 
      EndIf 
    Next i 
  
    FreeMemory(mem) 
  EndIf 
  ProcedureReturn sizeX 
EndProcedure 


Procedure$ GetMenuIDName(itemID) 
  mii.MENUITEMINFO 
  mii\cbSize        = SizeOf(MENUITEMINFO) 
  mii\fMask         = #MIIM_STRING;|#MIIM_TYPE 
  ;mii\fType         = #MFT_STRING 
  mii\dwTypeData    = AllocateMemory(1024) 
  mii\cch           = 1023 
  If GetMenuItemInfo_(hMenu,itemID,0,mii) 
   ItemName$        = PeekS(mii\dwTypeData) 
  EndIf 
  FreeMemory(mii\dwTypeData) 
  ProcedureReturn ItemName$ 
EndProcedure 


Procedure WndProc(hWnd,Msg,wParam,lParam) 
  Select Msg 
    Case #WM_MEASUREITEM 
      *mis.MEASUREITEMSTRUCT = lParam 
      If *mis 
        hDC     = GetDC_(hWnd) 
        ItemName$ = GetMenuIDName(*mis\itemID) 
        If ItemName$ = "" 
          *mis\itemWidth  = hBmpWidth 
          *mis\itemHeight = 6 
        Else 
          GetTextExtentPoint32_(hDC,ItemName$,Len(ItemName$),size.SIZE); 
          *mis\itemWidth  = size\cx+hBmpWidth 
          *mis\itemHeight = size\cy 
        EndIf 
        ReleaseDC_(hWnd,hDC) 
        ProcedureReturn #True 
      EndIf 
    Case #WM_DRAWITEM 
      *dis.DRAWITEMSTRUCT = lParam 
      If *dis 
        If *dis\itemState & #ODS_SELECTED 
          colFill = #COLOR_HIGHLIGHT 
          colBack = SetBkColor_(  *dis\hDC,GetSysColor_(#COLOR_HIGHLIGHT)) 
          colText = SetTextColor_(*dis\hDC,GetSysColor_(#COLOR_HIGHLIGHTTEXT)) 
        Else 
          colFill = #COLOR_MENU 
          colBack = SetBkColor_(  *dis\hDC,GetSysColor_(#COLOR_MENU)) 
          colText = SetTextColor_(*dis\hDC,GetSysColor_(#COLOR_MENUTEXT)) 
        EndIf 

        SetBkMode_(*dis\hDC, #TRANSPARENT) 

        If *dis\itemState & #ODS_GRAYED 
          SetTextColor_(*dis\hDC,GetSysColor_(#COLOR_GRAYTEXT)) 
        EndIf 

        *dis\rcItem\left+ hBmpWidth 
        x = *dis\rcItem\left + GetSystemMetrics_(#SM_CXMENUCHECK)+2 
        y = *dis\rcItem\top 

        ItemName$ = GetMenuIDName(*dis\itemID) 
        If ItemName$ 
          brush = GetSysColorBrush_(colFill) 
           FillRect_(*dis\hDC,@*dis\rcItem,brush) 
          DeleteObject_(brush) 
          If *dis\itemState & #ODS_GRAYED 
             oldCol = SetTextColor_(*dis\hDC,GetSysColor_(#COLOR_HIGHLIGHTTEXT)) 
             TextOut_(*dis\hDC,x+1,y+2,ItemName$,Len(ItemName$)) 
             SetTextColor_(*dis\hDC,oldCol) 
           EndIf 
          TextOut_(*dis\hDC,x,y+1,ItemName$,Len(ItemName$)) 
        Else 
          rect.RECT 
          rect\top = *dis\rcItem\top+2 
          rect\bottom = *dis\rcItem\top+4 
          rect\right  = *dis\rcItem\right 
          rect\left   = hBmpWidth 
          DrawEdge_(*dis\hDC,@rect,#BDR_SUNKENOUTER,#BF_RECT) 
        EndIf 
        
        If *dis\itemState & #ODS_CHECKED 
          Bmp = LoadBitmap_(0,#OBM_CHECK) 
           old = SelectObject_(tempDC,Bmp) 
           If *dis\itemState & #ODS_SELECTED 
             SetTextColor_(*dis\hDC,GetSysColor_(#COLOR_HIGHLIGHTTEXT)) 
           EndIf 
           BitBlt_(*dis\hDC,*dis\rcItem\left+1,y+2,GetSystemMetrics_(#SM_CXMENUCHECK),GetSystemMetrics_(#SM_CYMENUCHECK),tempDC,0,0,#SRCCOPY) 
           SelectObject_(tempDC,old) 
          DeleteObject_(Bmp) 
        EndIf 
        
        BitBlt_(*dis\hDC,0,0,hBmpWidth,hBmpHeight,tempDC,0,0,#SRCCOPY) 

        SetTextColor_(*dis\hDC,colText) 
        SetBkColor_(  *dis\hDC,colBack) 
        ProcedureReturn #True 
      EndIf 
    Case #WM_INITMENU 
      If tempDC=0 
        hDC    = GetDC_(hWnd) 
        tempDC = CreateCompatibleDC_(hDC) 
        SelectObject_(tempDC,hBmp) 
        ReleaseDC_(hWnd,hDC) 
      EndIf 
  EndSelect 
  ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 

Procedure OwnerDrawnMenu(Menu) 
  mii.MENUITEMINFO 
  mii\cbSize = SizeOf(MENUITEMINFO) 
  mii\fMask  = #MIIM_FTYPE 
  mii\fType  = #MFT_OWNERDRAW 
  For i = 0 To GetMenuItemCount_(Menu)-1 
    SetMenuItemInfo_(Menu,i,#True,mii) 
  Next i 
EndProcedure 


;>--------------------------------------- 


hMenu = CreatePopupMenu(0) 
If hMenu 
  For i = 1 To 30 
    MenuItem(100+i,"Item "+Str(i)) 
  Next i 
  MenuBar() 
  OpenSubMenu("Sub") 
    MenuItem(1, "SubMenu 1") 
    MenuItem(2, "SubMenu 2") 
  CloseSubMenu() 
  MenuBar() 
  MenuItem(3, "Quit") 
Else 
  End 
EndIf 

SetMenuItemState(0,101,1) 
SetMenuItemState(0,103,1) 

SetMenuItemState(0,102,1) 
DisableMenuItem(0,102,1) 


If OpenWindow(0,200,200,300,300,"OwnerDrawn PopUp Menu",#PB_Window_SystemMenu) 
  SetWindowCallback(@WndProc()) 

  #barwidth  = 30 
  height     = GetMenuHeight(WindowID(0),hMenu) 
  hBmp       = CreateImage(0,#barwidth,height) 
  hBmpWidth  = #barwidth 
  hBmpHeight = height 

  StartDrawing(ImageOutput(0)) 
    stp.f = 255/height 
    For y = height To 0 Step -1 
      Line(0,y,#barwidth,0,RGB(0,0,b.f)) 
      b+stp 
    Next y 
    DrawingMode(1) 
    FrontColor(RGB($FF,$FF,$00))
    DrawText(3,height-20,"Yo!") 
  StopDrawing() 

  OwnerDrawnMenu(hMenu) 



  Repeat 
    Select WaitWindowEvent() 
      Case #WM_RBUTTONDOWN 
        DisplayPopupMenu(0,WindowID(0)) 
      ;Case #WM_LButtonDown 
      ;  DisplayPopupMenu(0,WindowID()) 
      Case #PB_Event_Menu 
        menu = EventMenu() 
        If menu = 3 
          Break 
        EndIf 
        MessageRequester("MENU","Menu Event: "+Str(menu),0) 
      Case #PB_Event_CloseWindow 
        Break 
    EndSelect 
  ForEver 
EndIf 

If tempDC 
  DeleteDC_(tempDC) 
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -