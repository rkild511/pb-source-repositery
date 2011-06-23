; German forum: http://www.purebasic.fr/german/viewtopic.php?t=10516&highlight=
; Author: legion
; Date: 03. November 2006
; OS: Windows
; Demo: No


; Gradient-Sidebar, Gradient-Selector, Seitentext und Checkstate
; Sub-Menüs wegen Seitentext nicht möglich.

;-----------------------------------------------------------------------------------------------------------
; *****L-E-G-I-O-N-*-M-E-N-U*****
; Popup-Menu mit Gradient-Sidebar,Gradient-Selector,Seitentext und CheckStatus
; Code getestet under Windows XP
; wegen Seitentext keine Submenüs möglich
;-----------------------------------------------------------------------------------------------------------
#vert = 0
#horz = 1

Structure POINTAPI
  x.l
  y.l
EndStructure

Structure LPMENU
  MenuFont.l
  MenuColor.l
  FrameColor.l
  SideBarWidth.l
  GradStartColor.l
  GradEndColor.l
  SelGradStartColor.l
  SelGradEndColor.l
  SideText.s
  SideText1Color.l
  SideText2Color.l
  CheckColorEnable.l
  CheckColorDisable.l
  SelectorFrameColor.l
  SelectorTextColor.l
  ImageWidth.l
  ImageHeight.l
EndStructure

Global Dim PtList.POINTAPI(2)
Global *MIS.MEASUREITEMSTRUCT
Global *DIS.DRAWITEMSTRUCT
Global MII.MENUITEMINFO
Global LPM.LPMENU
Global FTM.TEXTMETRIC
Global HDC,TempDC,GradTextDC,SelectorDC,HCheck,hMenu,SelHeight,SelWidht
Global Rect.RECT
Global TextRect.SIZE

Global CheckPos = LPM\SideBarWidth/2+24 ;Ausrichtung des Checkstate-Symbol
Global LPM\SideBarWidth         = 30
Global LPM\GradStartColor       = $00F7FAFB
Global LPM\GradEndColor         = $00D9EAED
Global LPM\SelGradStartColor    = $00FFFFFF
Global LPM\SelGradEndColor      = $0094E6FA
Global LPM\SideText1Color       = $00FFFFFF
Global LPM\SideText2Color       = $000E558D
Global LPM\CheckColorEnable     = $00000000
Global LPM\CheckColorDisable    = $0089A0A4
Global LPM\SelectorFrameColor.l = $002B7199
Global LPM\SelectorTextColor    = $00105883
Global LPM\MenuColor            = $00FFFFFF
Global LPM\SideText             = "Legion-Menü"
Global LPM\MenuFont = LoadFont(#PB_Any,"MS Sans Serif",10)
;-----------------------------------------------------------------------------------------------------------
Procedure GetMenuHigh(MyMenuHandle)
  MEM = AllocateMemory(1024)
  OrgFont = SelectObject_(HDC, FontID(LPM\MenuFont))
  GetTextExtentPoint32_(HDC,"X",1,Size.SIZE)
  size\cy
  SelectObject_(HDC,OrgFont)

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
Protected ItemDummy$
MII\cbSize        = SizeOf(MENUITEMINFO)
MII\fMask         = #MIIM_STRING;|#MIIM_TYPE
MII\fType         = #MFT_STRING
MII\dwTypeData    = AllocateMemory(1024)
MII\cch           = 1023
If GetMenuItemInfo_(hMenu,itemID,0,MII)
  ItemDummy$        = PeekS(MII\dwTypeData)
EndIf
FreeMemory(MII\dwTypeData)
ProcedureReturn ItemDummy$
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
Procedure DrawGradientSelector(FrameColor,StartColor,EndColor)

SelHeight     = *DIS\rcItem\bottom - *DIS\rcItem\top
SelWidht      = *DIS\rcItem\right - *DIS\rcItem\left
SelDummy      = CreateImage(#PB_Any,SelWidht,SelHeight)
SelBmp        = ImageID(SelDummy)

type = #horz

If type=#vert : i = SelWidht-1 : Else : i = SelHeight-1 : EndIf
sRed.f   = Red(StartColor)   : r.f = (Red  (StartColor) - Red  (EndColor))/i
sGreen.f = Green(StartColor) : g.f = (Green(StartColor) - Green(EndColor))/i
sBlue.f  = Blue(StartColor)  : b.f = (Blue (StartColor) - Blue (EndColor))/i
StartDrawing(ImageOutput(SelDummy))
Box(0,0,SelWidht,SelHeight,FrameColor)
For a = 1 To i-1
  x.f = sRed   - a*r
  y.f = sGreen - a*g
  z.f = sBlue  - a*b
  If type=#horz
    Line(1,a,SelWidht-2,0,RGB(x,y,z))
  Else
    Line(a,1,0,SelHeight-2,RGB(x,y,z))
  EndIf
Next a
StopDrawing()
SelectObject_(SelectorDC,SelBmp)
FreeImage(SelDummy)
EndProcedure
;-----------------------------------------------------------------------------------------------------------
Procedure DrawGradientSidebar(Hwnd,MyDC,BarWidth,StartColor,EndColor,SideText$)
Protected Height,HBmp,HBmpWidth,HBmpHeight,SourceDC,STFontDummy,HBmpDummy

Height     = BarWidth
HBmpDummy  = CreateImage(#PB_Any,GetMenuHigh(Hwnd),BarWidth)
HBmp = ImageID(HBmpDummy)
HBmpWidth  = GetMenuHigh(Hwnd)
HBmpHeight = Height
type = #horz

If type=#vert : i = HBmpWidth : Else : i = HBmpHeight : EndIf
sRed.f   = Red(StartColor)   : r.f = (Red  (StartColor) - Red  (EndColor))/i
sGreen.f = Green(StartColor) : g.f = (Green(StartColor) - Green(EndColor))/i
sBlue.f  = Blue(StartColor)  : b.f = (Blue (StartColor) - Blue (EndColor))/i
STFontDummy = LoadFont(#PB_Any,"Arial",12,#PB_Font_Bold|#PB_Font_HighQuality)
StartDrawing(ImageOutput(HBmpDummy))
For a = 0 To i-1
  x.f = sRed   - a*r
  y.f = sGreen - a*g
  z.f = sBlue  - a*b
  If type=#horz
    Line(0,a,HBmpWidth,0,RGB(x,y,z))
  Else
    Line(a,0,0,HBmpHeight,RGB(x,y,z))
  EndIf
Next a
DrawingMode(#PB_2DDrawing_Transparent)
DrawingFont(FontID(STFontDummy))
DrawText(5, 5, SideText$,LPM\SideText1Color)
DrawText(4, 4, SideText$,LPM\SideText2Color)
StopDrawing()
FreeFont(STFontDummy)
SourceDC  = CreateCompatibleDC_(MyDC)
SelectObject_(SourceDC,HBmp)
FreeImage(HBmpDummy)

Dummy = CreateImage(#PB_Any,BarWidth,GetMenuHigh(Hwnd))
Dest = ImageID(Dummy)
SelectObject_(MyDC,Dest)
FreeImage(Dummy)
;links oben
PtList(0)\x = 0
PtList(0)\y = HBmpWidth
;rechts oben
PtList(1)\x = 0
PtList(1)\y = 0
;links unten
PtList(2)\x = HBmpHeight
PtList(2)\y = HBmpWidth

PlgBlt_(MyDC,PtList(),SourceDC,0,0,HBmpWidth,HBmpHeight,0,0,0)
LPM\ImageWidth = HBmpWidth
LPM\ImageHeight = HBmpHeight
ReleaseDC_(hWnd,SourceDC)
EndProcedure
;-----------------------------------------------------------------------------------------------------------
Procedure DrawCheckState(CheckColor)
Height      = 18
Width       = 18
HCheckDummy = CreateImage(#PB_Any,Width,Height)
HCheck      = ImageID(HCheckDummy)
StartDrawing(ImageOutput(HCheckDummy))
Box(0,0,Width,Height,CheckColor)
Box(1,1,Width-2,Height-2,$FFFFFF)
StopDrawing()
EndProcedure
;-----------------------------------------------------------------------------------------------------------
Procedure DrawSelected()
SetTextColor_(*DIS\HDC,LPM\SelectorTextColor)

If *DIS\itemState & #ODS_GRAYED
  SetTextColor_(*DIS\HDC,GetSysColor_(#COLOR_GRAYTEXT))
  CheckColor = LPM\CheckColorDisable
Else
  CheckColor = LPM\CheckColorEnable
EndIf

x = *DIS\rcItem\left + GetSystemMetrics_(#SM_CXMENUCHECK)+2
y = *DIS\rcItem\top

ItemName$ = GetMenuIDName(*DIS\itemID)
If ItemName$
  BitBlt_(*DIS\HDC,*DIS\rcItem\left,*DIS\rcItem\Top,SelWidht,SelHeight,SelectorDC,0,0,#SRCCOPY)
  SelectObject_(*DIS\HDC,FontID(LPM\MenuFont)); Den Font umstellen
  *DIS\rcItem\left = *DIS\rcItem\left + LPM\SideBarWidth + 4
  DrawText_(*DIS\HDC,@ItemName$,Len(ItemName$),*DIS\rcItem,#DT_SINGLELINE|#DT_VCENTER|#DT_LEFT)
  ;-----------------------------------------------------------------------------------------------------------
Else ;Seperator zeichnen
  rect\top    = *DIS\rcItem\top+2
  rect\bottom = *DIS\rcItem\top+4
  rect\right  = *DIS\rcItem\right
  rect\left   = *DIS\rcItem\left + LPM\SideBarWidth +2
  DrawEdge_(*DIS\hDC,@rect,#BDR_SUNKENOUTER,#BF_RECT)
EndIf
;-----------------------------------------------------------------------------------------------------------
If *DIS\itemState & #ODS_CHECKED
  DrawCheckState(CheckColor)
  Bmp = LoadBitmap_(0,#OBM_CHECK)
  old = SelectObject_(TempDC,HCheck)
  BitBlt_(*DIS\hDC,*DIS\rcItem\left-CheckPos-4,*DIS\rcItem\top+2,20,20,tempDC,0,0,#SRCCOPY)
  SelectObject_(TempDC,Bmp)
  BitBlt_(*DIS\hDC,*DIS\rcItem\left-CheckPos,y+4,GetSystemMetrics_(#SM_CXMENUCHECK),GetSystemMetrics_(#SM_CYMENUCHECK),tempDC,0,0,#SRCAND)
  SelectObject_(TempDC,old)
  DeleteObject_(HCheck)
  DeleteObject_(Bmp)
EndIf
EndProcedure
;-----------------------------------------------------------------------------------------------------------
Procedure DrawNorm()
LPM\FrameColor = $FFFFFF
If *DIS\itemState & #ODS_GRAYED
  SetTextColor_(*DIS\HDC,GetSysColor_(#COLOR_GRAYTEXT))
  CheckColor = LPM\CheckColorDisable
Else
  CheckColor = LPM\CheckColorEnable
EndIf

x = *DIS\rcItem\left + GetSystemMetrics_(#SM_CXMENUCHECK)+2
y = *DIS\rcItem\top

ItemName$ = GetMenuIDName(*DIS\itemID)
If ItemName$
  brush = CreateSolidBrush_(LPM\MenuColor)
  FillRect_(*DIS\HDC,*DIS\rcItem,brush)
  FrameBrush  = CreateSolidBrush_(LPM\FrameColor)
  FrameRect_(*DIS\HDC,*DIS\rcItem,FrameBrush)
  DeleteObject_(brush)
  DeleteObject_(FrameBrush)
  SelectObject_(*DIS\HDC,FontID(LPM\MenuFont)); Den Font umstellen
  *DIS\rcItem\left = *DIS\rcItem\left + LPM\SideBarWidth + 4
  DrawText_(*DIS\HDC,@ItemName$,Len(ItemName$),*DIS\rcItem,#DT_SINGLELINE|#DT_VCENTER|#DT_LEFT)
  ;-----------------------------------------------------------------------------------------------------------
Else ;Seperator zeichnen
  rect\top    = *DIS\rcItem\top+2
  rect\bottom = *DIS\rcItem\top+4
  rect\right  = *DIS\rcItem\right
  rect\left   = *DIS\rcItem\left + LPM\SideBarWidth +2
  DrawEdge_(*DIS\hDC,@rect,#BDR_SUNKENOUTER,#BF_RECT)
EndIf

If *DIS\itemState & #ODS_CHECKED
  DrawCheckState(CheckColor)
  Bmp = LoadBitmap_(0,#OBM_CHECK)
  old = SelectObject_(TempDC,HCheck)
  BitBlt_(*DIS\hDC,*DIS\rcItem\left-CheckPos -4,*DIS\rcItem\top+2,20,20,tempDC,0,0,#SRCCOPY)
  SelectObject_(TempDC,Bmp)
  BitBlt_(*DIS\hDC,*DIS\rcItem\left-CheckPos,y+4,GetSystemMetrics_(#SM_CXMENUCHECK),GetSystemMetrics_(#SM_CYMENUCHECK),tempDC,0,0,#SRCAND)
  SelectObject_(TempDC,old)
  DeleteObject_(HCheck)
  DeleteObject_(Bmp)
EndIf
BitBlt_(*DIS\HDC,0,0,LPM\ImageHeight,LPM\ImageWidth,GradTextDC,0,0,#SRCAND)
EndProcedure
;-----------------------------------------------------------------------------------------------------------
Procedure WndProc(hWnd,Msg,wParam,lParam)
Result = #PB_ProcessPureBasicEvents
Select Msg
  ;-----------------------------------------------------------------------------------------------------------
  Case #WM_INITMENU
    HDC           = GetDC_(hWnd)
    TempDC        = CreateCompatibleDC_(HDC)
    GradTextDC    = CreateCompatibleDC_(HDC)
    SelectorDC    = CreateCompatibleDC_(HDC)
    SetMenuOwnerDrawn(hMenu);Menü in den OwnerDrawnModus schalten
    DrawGradientSidebar(hMenu,GradTextDC,LPM\SideBarWidth,LPM\GradStartColor,LPM\GradEndColor,LPM\SideText)
    ;-----------------------------------------------------------------------------------------------------------
  Case #WM_MEASUREITEM
    *MIS.MEASUREITEMSTRUCT = lParam
    ItemName$ = GetMenuIDName(*MIS\itemID)
    If ItemName$ = ""
      *MIS\itemWidth  = LPM\SideBarWidth
      *MIS\itemHeight = 6
    Else
      OrgFont = SelectObject_(HDC, FontID(LPM\MenuFont))
      GetTextExtentPoint32_(HDC,ItemName$,Len(ItemName$),TextRect.SIZE)
      *MIS\itemWidth  = TextRect\cx + LPM\SideBarWidth +2
      *MIS\itemHeight = TextRect\cy +6
      SelectObject_(HDC,OrgFont)
    EndIf
    ;-----------------------------------------------------------------------------------------------------------
  Case #WM_DRAWITEM
    *DIS.DRAWITEMSTRUCT = lParam
    SetBkMode_(*DIS\HDC, #TRANSPARENT)
    If *DIS\itemState & #ODS_SELECTED
      DrawGradientSelector(LPM\SelectorFrameColor,LPM\SelGradStartColor,LPM\SelGradEndColor)
      DrawSelected()
    Else
      DrawNorm()
    EndIf

  Case #WM_EXITMENULOOP
    ReleaseDC_(hWnd,HDC)
    ReleaseDC_(hWnd,TempDC)
    ReleaseDC_(hWnd,GradTextDC)
    ReleaseDC_(hWnd,SelectorDC)
EndSelect
ProcedureReturn Result
EndProcedure
;-----------------------------------------------------------------------------------------------------------
;Popup-Menü erzeugen
PMenuNr = CreatePopupMenu(#PB_Any)
hMenu = MenuID(PMenuNr)
For i = 1 To 15
MenuItem(100+i,"Ein Menüeintrag "+Str(i))
Next i
MenuBar()
MenuItem(5, "Beenden")
; Menustate setzen
SetMenuItemState(PMenuNr,104,1)
SetMenuItemState(PMenuNr,105,1)
DisableMenuItem(PMenuNr,105,1)
;-----------------------------------------------------------------------------------------------------------
;Neues Fenster öffen
If OpenWindow(0,200,200,600,400,"Office Xp Popup-Menü",#PB_Window_SystemMenu)
SetWindowCallback(@WndProc())
;-----------------------------------------------------------------------------------------------------------
Repeat
  Select WaitWindowEvent()
    Case #WM_RBUTTONDOWN
      DisplayPopupMenu(PMenuNr,WindowID(0))
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