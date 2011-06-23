; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1355&highlight=
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 14. June 2003
; OS: Windows
; Demo: No

;############################# 
;Author : Andreas 
;14.06.2003 
;############################# 

Global hMenu.l,MenuFont.l 
Global SelFrontColor.l, SelBkColor.l 

Structure MyItem 
hFont.l 
Text.s 
hIco.l 
EndStructure 

;Je nach Anzahl der Menüeinträge dimensionieren 
Global Dim pmyitem.MyItem(3) 


Procedure wcb(wnd, msg, wParam, lParam) 
    fSelected = #False 
    
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
        If *lpdis\itemState & #ODS_SELECTED 
            SetTextColor_(*lpdis\hDC,SelFrontColor) 
            SetBkColor_(*lpdis\hDC,SelBkColor) 
            fSelected = #True 
            dwCheckXY = GetMenuCheckMarkDimensions_() 
            wCheckX = (dwCheckXY >> 16 & $FFFF) + 10 
            nTextX = wCheckX + *lpdis\rcItem\left 
            nTextY = *lpdis\rcItem\top 
            ExtTextOut_(*lpdis\hDC,nTextX,nTextY,#ETO_OPAQUE,*lpdis\rcItem,*llmyitem\Text,Len(*llmyitem\Text),0) 
            DrawIconEx_(*lpdis\hDC,*lpdis\rcItem\left,*lpdis\rcItem\top,*llmyitem\hIco,14,14,0,0,3) 
            SelectObject_(*lpdis\hDC,hOldFont) 
        Else 
            dwCheckXY = GetMenuCheckMarkDimensions_() 
            wCheckX = (dwCheckXY >> 16 & $FFFF) + 10 
            nTextX = wCheckX + *lpdis\rcItem\left 
            nTextY = *lpdis\rcItem\top 
            ExtTextOut_(*lpdis\hDC,nTextX,nTextY,#ETO_OPAQUE,*lpdis\rcItem,*llmyitem\Text,Len(*llmyitem\Text),0) 
            DrawIconEx_(*lpdis\hDC,*lpdis\rcItem\left,*lpdis\rcItem\top,*llmyitem\hIco,14,14,0,0,3) 
            SelectObject_(*lpdis\hDC,hOldFont) 
        EndIf 
        
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
    
    ;Menu anlegen 
    If CreateMenu(0, WindowID(0)) 
        MenuTitle("File") 
        MenuItem( 1, "") 
        MenuItem( 2, "") 
        MenuItem( 3, "") 
        MenuBar() 
        MenuItem( 4, "") 
    EndIf 
    
    ;Menu mopdufizieren 
    hMenu = GetMenu_(WindowID(0)) 
    ModifyMenu_(hMenu,1,#MF_BYCOMMAND|#MF_OWNERDRAW,1,pmyitem(0)) 
    ModifyMenu_(hMenu,2,#MF_BYCOMMAND|#MF_OWNERDRAW,2,pmyitem(1)) 
    ModifyMenu_(hMenu,3,#MF_BYCOMMAND|#MF_OWNERDRAW,3,pmyitem(2)) 
    ModifyMenu_(hMenu,4,#MF_BYCOMMAND|#MF_OWNERDRAW,4,pmyitem(3)) 
    
    ;ItemArray mit Text,Font und Icon fuellen 
    MenuFont = LoadFont(0,"Ms Sans Serif",10) 
    
    pmyitem(0)\hFont = MenuFont 
    pmyitem(0)\Text = "Load" + Space(5) 
    ExtractIconEx_("shell32.dll",4,0,@s,1) 
    pmyitem(0)\hIco = s 
    
    pmyitem(1)\hFont = MenuFont 
    pmyitem(1)\Text = "Save" + Space(5) 
    ExtractIconEx_("shell32.dll",0,0,@s,1) 
    pmyitem(1)\hIco = s 
    
    pmyitem(2)\hFont = MenuFont 
    pmyitem(2)\Text = "Save As...." + Space(5) 
    ExtractIconEx_("shell32.dll",2,0,@s,1) 
    pmyitem(2)\hIco = s 
    
    pmyitem(3)\hFont = MenuFont 
    pmyitem(3)\Text = "Quit" + Space(5) 
    ExtractIconEx_("shell32.dll",31,0,@s,1) 
    pmyitem(3)\hIco = s 
    
    ;Farben setzen 
    SelFrontColor = $00FFFF;Textfarbe selektiert 
    SelBkColor = $010101;Hintergrundfarbe selektiert 
    
    
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
; EnableXP
