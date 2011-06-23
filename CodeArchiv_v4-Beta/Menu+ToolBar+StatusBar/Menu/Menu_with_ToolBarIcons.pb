; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=9326#9326
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 15. June 2003
; OS: Windows
; Demo: No

;############################# 
;Author : Andreas 
;15.06.2003 
;############################# 

Global hMenu.l,MenuFont.l 
Global SelFrontColor.l, SelBkColor.l 
Global TBImagelist.l 

Structure MyItem 
hFont.l 
Text.s 
hIco.l 
EndStructure 

;Je nach Anzahl der Menüeinträge dimensionieren 
Global Dim pmyitem.MyItem(4) 


Procedure wcb(wnd, msg, wParam, lParam) 
    
    If msg = #WM_MEASUREITEM 
        hdc = GetDC_(wnd) 
        *lpmis.MEASUREITEMSTRUCT = lParam 
        *lmyitem.MyItem = *lpmis\itemData 
        hFontOld = SelectObject_(hdc,*lmyitem\hFont) 
        GetTextExtentPoint32_(hdc,*lmyitem\Text,Len(*lmyitem\Text),@size.SIZE); 
        *lpmis\itemWidth = size\cx 
        *lpmis\itemHeight = size\cy 
        SelectObject_(hdc,hOldFont) 
        ReleaseDC_(wnd,hdc) 
        ProcedureReturn  #True 
        
    ElseIf msg = #WM_DRAWITEM 
        *lpdis.DRAWITEMSTRUCT = lParam 
        *llmyitem.MyItem = *lpdis\itemData 
        hOldFont = SelectObject_(*lpdis\hdc,*llmyitem\hFont) 
        dwCheckXY = GetMenuCheckMarkDimensions_() 
        wCheckX = (dwCheckXY >> 16 & $FFFF) + 10 
        nTextX = wCheckX + *lpdis\rcItem\left 
        nTextY = *lpdis\rcItem\top 
        If *lpdis\itemState & #ODS_SELECTED 
            SetTextColor_(*lpdis\hDC,SelFrontColor) 
            SetBkColor_(*lpdis\hDC,SelBkColor) 
        EndIf 
        *lpdis\rcItem\left = *lpdis\rcItem\left + nTextX -4 
        ExtTextOut_(*lpdis\hDC,nTextX,nTextY,#ETO_OPAQUE,*lpdis\rcItem,*llmyitem\Text,Len(*llmyitem\Text),0) 
        *lpdis\rcItem\left = *lpdis\rcItem\left - nTextX +4 
        DrawIconEx_(*lpdis\hDC,*lpdis\rcItem\left,*lpdis\rcItem\top,*llmyitem\hIco,16,15,0,GetClassLong_(wnd,#GCL_HBRBACKGROUND),3) 
        SelectObject_(*lpdis\hDC,hOldFont) 
        ProcedureReturn  #True 
        
    ElseIf msg = #WM_DESTROY 
        For i = 0 To 3 
            DeleteObject_(pmyitem(i)\hFont) 
            DeleteObject_(pmyitem(i)\hIco) 
        Next i 
        FreeFont(0) 
        PostQuitMessage_(0) 
    Else 
        ProcedureReturn #PB_ProcessPureBasicEvents 
        
    EndIf 
EndProcedure 

If OpenWindow(0, 100, 150, 195, 260, "PureBasic - OwnMenu", #PB_Window_SystemMenu) 
TB = CreateToolBar(10,WindowID(0)) 
ToolBarStandardButton(1,#PB_ToolBarIcon_Open) 
ToolBarStandardButton(2,#PB_ToolBarIcon_Save) 
ToolBarStandardButton(3,#PB_ToolBarIcon_New) 
ToolBarSeparator() 
ToolBarStandardButton(4,#PB_ToolBarIcon_Delete) 
ExtractIconEx_("winhelp.exe",0,0,@s,1) 
pmyitem(4)\hIco = s 
ToolBarImageButton(5,s) 
TBImagelist = SendMessage_(TB,1073,0,0);TB_GETIMAGELIST 
SendMessage_(TB,1071,4,0);#TB_SETINDENT - von links 4 Pixel abruecken 

    ;Menu anlegen 
    If CreateMenu(0, WindowID(0)) 
        MenuTitle("File") 
        MenuItem( 1, "") 
        MenuItem( 2, "") 
        MenuItem( 3, "") 
        MenuBar() 
        MenuItem( 4, "") 
        MenuTitle("Help") 
        MenuItem( 5, "") 
    EndIf 
    
    ;Menu mopdufizieren 
    hMenu = GetMenu_(WindowID(0)) 
    ModifyMenu_(hMenu,1,#MF_BYCOMMAND|#MF_OWNERDRAW,1,pmyitem(0)) 
    ModifyMenu_(hMenu,2,#MF_BYCOMMAND|#MF_OWNERDRAW,2,pmyitem(1)) 
    ModifyMenu_(hMenu,3,#MF_BYCOMMAND|#MF_OWNERDRAW,3,pmyitem(2)) 
    ModifyMenu_(hMenu,4,#MF_BYCOMMAND|#MF_OWNERDRAW,4,pmyitem(3)) 
    ModifyMenu_(hMenu,5,#MF_BYCOMMAND|#MF_OWNERDRAW,5,pmyitem(4)) 
    
    ;ItemArray mit Text,Font und Icon fuellen 
    MenuFont = LoadFont(0,"Arial",10,#PB_Font_Italic) 
    
    pmyitem(0)\hFont = MenuFont 
    pmyitem(0)\Text = "Load"; + Space(5) 
    pmyitem(0)\hIco = ImageList_GetIcon_(TBImagelist,#PB_ToolBarIcon_Open,0) 
    
    pmyitem(1)\hFont = MenuFont 
    pmyitem(1)\Text = "Save"; + Space(5) 
    pmyitem(1)\hIco = ImageList_GetIcon_(TBImagelist,#PB_ToolBarIcon_Save,0) 
    
    pmyitem(2)\hFont = MenuFont 
    pmyitem(2)\Text = "New"; + Space(5) 
    pmyitem(2)\hIco = ImageList_GetIcon_(TBImagelist,#PB_ToolBarIcon_New,0) 
    
    pmyitem(3)\hFont = MenuFont 
    pmyitem(3)\Text = "Quit"; + Space(5) 
    pmyitem(3)\hIco = ImageList_GetIcon_(TBImagelist,#PB_ToolBarIcon_Delete,0) 

    pmyitem(4)\hFont = MenuFont 
    pmyitem(4)\Text = "Hilfe nicht verfügbar"; + Space(5) 
    pmyitem(4)\hIco = ImageList_GetIcon_(TBImagelist,15,0);1. Eintrag nach den 14 Standard-Icons 
    
    ;Farben setzen 
    SelFrontColor = GetSysColor_(#COLOR_HIGHLIGHTTEXT);Textfarbe selektiert 
    SelBkColor = GetSysColor_(#COLOR_HIGHLIGHT) 
    
    
    SetWindowCallback(@wcb()) 
    Repeat 
        Select WaitWindowEvent() 
        Case #PB_Event_Menu 
            Select EventMenu() 
            Case 4 ; Quit 
                Quit = 1 
                Default 
                MessageRequester("Info", "MenuItem: "+Str(EventMenu()), 0) 
            EndSelect 
        Case #WM_CLOSE 
            Quit = 1 
        EndSelect 
    Until Quit = 1 
EndIf 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
