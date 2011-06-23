; German forum: http://www.purebasic.fr/german/viewtopic.php?t=10516&highlight=
; Author: legion
; Date: 26. October 2006
; OS: Windows
; Demo: No

;-----------------------------------------------------------------------------------------------------------
; Popup-Menu im Office-Xp Style
; Code getestet under Windows XP und ME
; Eine Submenütiefe möglich
; Sonstige Fehler: Bitte um Info !
;-----------------------------------------------------------------------------------------------------------
Global *MIS.MEASUREITEMSTRUCT
Global *DIS.DRAWITEMSTRUCT
Global MII.MENUITEMINFO
Global hMenu,MenuFont,FrameColor,SideBarWidth,HBmpWidth,HBmpHeight,TempDC,HBmp,MenuHigh
Global Rect.RECT
Global TextRect.SIZE
SideBarWidth = 30
;-----------------------------------------------------------------------------------------------------------
Procedure GetMenuHigh(hWnd,MyMenuHandle)
  MEM = AllocateMemory(1024)
  HDC = GetDC_(hWnd)
  OrgFont = SelectObject_(HDC, MenuFont)
  GetTextExtentPoint32_(HDC,"X",1,Size.SIZE)
  size\cy + 2
  SelectObject_(HDC,OrgFont)
  ReleaseDC_(hWnd,HDC)

  MII\cbSize      = SizeOf(MENUITEMINFO)
  MII\fMask       = #MIIM_STRING;|#MIIM_TYPE
  MII\dwTypeData  = MEM
  MII\cch         = 1023

  For i = 0 To GetMenuItemCount_(MyMenuHandle)-1
    MII\dwTypeData = mem
    MII\cch = 1023
    GetMenuItemInfo_(MyMenuHandle,i,#True,@MII)
    If PeekS(mii\dwTypeData)= ""
      sizeX + 6
    Else
      sizeX + size\cy + 6
    EndIf
  Next i
  FreeMemory(mem)
  ProcedureReturn sizeX
EndProcedure
;-----------------------------------------------------------------------------------------------------------
;Inhalt (Items) des Menü einlesen
Procedure$ GetMenuIDName(itemID)
MII\cbSize        = SizeOf(MENUITEMINFO)
MII\fMask         = #MIIM_STRING;|#MIIM_TYPE
MII\fType         = #MFT_STRING
MII\dwTypeData    = AllocateMemory(1024)
MII\cch           = 1023
If GetMenuItemInfo_(hMenu,itemID,0,MII)
  ItemName$        = PeekS(MII\dwTypeData)
EndIf
FreeMemory(MII\dwTypeData)
ProcedureReturn ItemName$
EndProcedure
;-----------------------------------------------------------------------------------------------------------
;Menü in den OwnerDrawnModus schalten
Procedure SetMenuOwnerDrawn(MyMenuHandle)
MII\cbSize = SizeOf(MENUITEMINFO)
MII\fMask  = #MIIM_TYPE
MII\fType  = #MFT_OWNERDRAW
For i = 0 To GetMenuItemCount_(MyMenuHandle)-1
  SetMenuItemInfo_(MyMenuHandle,i,#True,MII)
Next i
EndProcedure
;-----------------------------------------------------------------------------------------------------------
Procedure DrawSimpleSidebar(BarWidth)
Height     = GetMenuHigh(WindowID(0),hMenu)
HBmp       = CreateImage(0,BarWidth,Height)
HBmpWidth  = BarWidth
HBmpHeight = Height
StartDrawing(ImageOutput(0))
Box(0,0,BarWidth,Height,$00DEEDEF)
StopDrawing()
EndProcedure
;-----------------------------------------------------------------------------------------------------------
Procedure DrawSelected()
ColFill    = $00EED2C1
FrameColor = $00C56A31
SetTextColor_(*DIS\HDC,$82121A)

If *DIS\itemState & #ODS_GRAYED
  SetTextColor_(*DIS\HDC,GetSysColor_(#COLOR_GRAYTEXT))
EndIf

x = *DIS\rcItem\left + GetSystemMetrics_(#SM_CXMENUCHECK)+2
y = *DIS\rcItem\top

ItemName$ = GetMenuIDName(*DIS\itemID)

If ItemName$
  BitBlt_(*DIS\HDC,0,0,HBmpWidth,HBmpHeight,TempDC,0,0,#SRCAND)
  brush = CreateSolidBrush_(ColFill)
  FillRect_(*DIS\HDC,*DIS\rcItem,brush)
  FrameBrush  = CreateSolidBrush_(FrameColor)
  FrameRect_(*DIS\HDC,*DIS\rcItem,FrameBrush)
  DeleteObject_(brush)
  DeleteObject_(FrameBrush)
  SelectObject_(*DIS\HDC,MenuFont); Den Font umstellen

  *DIS\rcItem\left = *DIS\rcItem\left + SideBarWidth + 4
  DrawText_(*DIS\HDC,@ItemName$,Len(ItemName$),*DIS\rcItem,#DT_SINGLELINE|#DT_VCENTER|#DT_LEFT)
  ;-----------------------------------------------------------------------------------------------------------
Else ;Seperator zeichnen
  rect\top    = *DIS\rcItem\top+2
  rect\bottom = *DIS\rcItem\top+4
  rect\right  = *DIS\rcItem\right
  rect\left   = *DIS\rcItem\left + SideBarWidth +2
  DrawEdge_(*DIS\hDC,@rect,#BDR_SUNKENOUTER,#BF_RECT)
EndIf

If *DIS\itemState & #ODS_CHECKED
  Bmp = LoadBitmap_(0,#OBM_CHECK)
  old = SelectObject_(tempDC,Bmp)
  BitBlt_(*DIS\hDC,*DIS\rcItem\left-25,y+4,GetSystemMetrics_(#SM_CXMENUCHECK),GetSystemMetrics_(#SM_CYMENUCHECK),tempDC,0,0,#SRCAND)
  SelectObject_(tempDC,old)
  DeleteObject_(Bmp)
EndIf
EndProcedure
;-----------------------------------------------------------------------------------------------------------
Procedure DrawNorm()
ColFill    = $FFFFFF
FrameColor = $FFFFFF
If *DIS\itemState & #ODS_GRAYED
  SetTextColor_(*DIS\HDC,GetSysColor_(#COLOR_GRAYTEXT))
EndIf

x = *DIS\rcItem\left + GetSystemMetrics_(#SM_CXMENUCHECK)+2
y = *DIS\rcItem\top

ItemName$ = GetMenuIDName(*DIS\itemID)
If ItemName$
  brush = CreateSolidBrush_(ColFill)
  FillRect_(*DIS\HDC,*DIS\rcItem,brush)
  FrameBrush  = CreateSolidBrush_(FrameColor)
  FrameRect_(*DIS\HDC,*DIS\rcItem,FrameBrush)
  DeleteObject_(brush)
  DeleteObject_(FrameBrush)

  SelectObject_(*DIS\HDC,MenuFont); Den Font umstellen

  *DIS\rcItem\left = *DIS\rcItem\left + SideBarWidth + 4
  DrawText_(*DIS\HDC,@ItemName$,Len(ItemName$),*DIS\rcItem,#DT_SINGLELINE|#DT_VCENTER|#DT_LEFT)
  ;-----------------------------------------------------------------------------------------------------------
Else ;Seperator zeichnen
  rect\top    = *DIS\rcItem\top+2
  rect\bottom = *DIS\rcItem\top+4
  rect\right  = *DIS\rcItem\right
  rect\left   = *DIS\rcItem\left + SideBarWidth +2
  DrawEdge_(*DIS\hDC,@rect,#BDR_SUNKENOUTER,#BF_RECT)
EndIf

If *DIS\itemState & #ODS_CHECKED
  Bmp = LoadBitmap_(0,#OBM_CHECK)
  old = SelectObject_(TempDC,Bmp)
  BitBlt_(*DIS\hDC,*DIS\rcItem\left-25,y+4,GetSystemMetrics_(#SM_CXMENUCHECK),GetSystemMetrics_(#SM_CYMENUCHECK),tempDC,0,0,#SRCCOPY)
  SelectObject_(TempDC,old)
  DeleteObject_(Bmp)
EndIf

BitBlt_(*DIS\HDC,0,0,HBmpWidth,HBmpHeight,TempDC,0,0,#SRCAND)

EndProcedure
;-----------------------------------------------------------------------------------------------------------
Procedure WndProc(hWnd,Msg,wParam,lParam)
Result = #PB_ProcessPureBasicEvents
Select Msg
  ;-----------------------------------------------------------------------------------------------------------
  Case #WM_INITMENU
    If TempDC = 0
      HDC = GetDC_(hWnd)
      TempDC = CreateCompatibleDC_(HDC)
      SelectObject_(TempDC,HBmp)
      ReleaseDC_(hWnd,HDC)
    EndIf
    ;-----------------------------------------------------------------------------------------------------------
  Case #WM_MEASUREITEM
    *MIS.MEASUREITEMSTRUCT = lParam
    HDC = GetDC_(hWnd)
    ItemName$ = GetMenuIDName(*MIS\itemID)
    If ItemName$ = ""
      *MIS\itemWidth  = SideBarWidth
      *MIS\itemHeight = 6
    Else
      OrgFont = SelectObject_(HDC, MenuFont)
      GetTextExtentPoint32_(HDC,ItemName$,Len(ItemName$),TextRect.SIZE)
      *MIS\itemWidth  = TextRect\cx + SideBarWidth +2
      *MIS\itemHeight = TextRect\cy +6
      SelectObject_(HDC,OrgFont)
      ReleaseDC_(hWnd,HDC)
    EndIf
    ;-----------------------------------------------------------------------------------------------------------
  Case #WM_DRAWITEM
    *DIS.DRAWITEMSTRUCT = lParam
    SetBkMode_(*DIS\HDC, #TRANSPARENT)
    If *DIS\itemState & #ODS_SELECTED
      DrawSelected()
    Else
      DrawNorm()
    EndIf
    ;-----------------------------------------------------------------------------------------------------------
EndSelect
ProcedureReturn Result
EndProcedure

;Popup-Menü erzeugen
hMenu = CreatePopupMenu(0)
If hMenu
For i = 1 To 10
  MenuItem(100+i,"Ein Menüeintrag "+Str(i))
Next i
MenuBar()
OpenSubMenu("Öffne Untermenü")
MenuItem(1, "Untermenü 1")
MenuBar()
MenuItem(2, "Untermenü 2")
MenuItem(3, "Untermenü 3")
MenuItem(4, "Untermenü 4")
CloseSubMenu()
MenuBar()
MenuItem(5, "Beenden")
EndIf

SetMenuItemState(0,104,1)
SetMenuItemState(0,105,1)
DisableMenuItem(0,105,1)
SetMenuItemState(0,3,1)
SetMenuItemState(0,2,1)
DisableMenuItem(0,2,1)
;-----------------------------------------------------------------------------------------------------------
;Neues Fenster öffen
If OpenWindow(0,200,200,600,400,"Office Xp Popup-Menü",#PB_Window_SystemMenu)
MenuFont = LoadFont(0,"MS Sans Serif",10)
DrawSimpleSidebar(SideBarWidth)
SetMenuOwnerDrawn(hMenu);Menü in den OwnerDrawnModus schalten
For i = 0 To GetMenuItemCount_(hMenu)-1
  SubHWND = GetSubMenu_(hMenu,i)
  If SubHWND <> 0
    SetMenuOwnerDrawn(SubHWND)
  EndIf
Next i

SetWindowCallback(@WndProc())
;-----------------------------------------------------------------------------------------------------------
Repeat
  Select WaitWindowEvent()
    Case #WM_RBUTTONDOWN
      DisplayPopupMenu(0,WindowID(0))
    Case #PB_Event_Menu
      Menu = EventMenu()
      If menu = 5
        Break
      EndIf
    Case #PB_Event_CloseWindow
      Break
  EndSelect
ForEver

EndIf
;-----------------------------------------------------------------------------------------------------------
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP