; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8860&highlight=
; Author: einander (updated for PB4.00 by blbltheworm)
; Date: 26. December 2003
; OS: Windows
; Demo: No

; Grid with input text 
; December 26 -2003- PB 3.81 
; by Einander 

Enumeration 
    #Ret 
    #Txt 
    #Input 
EndEnumeration 

#LightGray = $BDBDBD : #SAND = $BBFFFF 

Global Dim Selected.l(1): Global Dim textcell$(0) : Global Dim xcell.w(0) : Global Dim ycell.w(0) 
Global Mx, My, Mk,S$ 
Global Grid, Colum, Rows, _X, _Y, WCell, HCell, XGrid, YGrid, NColumns, NRows, NCells, WGrid, HGrid, SmallFont 
S$="  " 

Procedure inmous(x, y, x1, y1) 
    ProcedureReturn Mx >= x And My >= y And Mx <= x1 And My <= y1 
EndProcedure 

Procedure CleanCell(COLU, ROW) 
    x = XGrid + 1 + (COLU - 1) * WCell+1 
    y = YGrid + 1 + (ROW - 1) * HCell+1 
    Box(x, y-1, WCell-2, HCell-1, #SAND) 
    SEL = (ROW - 1 ) * NColumns + COLU 
    DrawingFont(SmallFont) 
    FrontColor(RGB(0,0,0)) 
    DrawText(x , y,textcell$(SEL - 1)) 
    Selected(0) = 0 
EndProcedure 

Procedure DrawCell(Ev) 
    If inmous(XGrid + 1, YGrid + 1, XGrid + WGrid - 2, YGrid + HGrid - 2) 
        COLU = (Mx - XGrid) / WCell + 1 : ROW = (My - YGrid) / HCell + 1 
        SEL = (ROW - 1 ) * NColumns + COLU 
        If Ev = #WM_LBUTTONDOWN : ProcedureReturn SEL : EndIf 
        If Selected(0) <> COLU Or Selected(1) <> ROW 
            If Selected(0) : CleanCell(SELECTED(0), Selected(1)) : EndIf 
            x = XGrid + (COLU - 1) * WCell + 1 : y = YGrid + ((ROW - 1) * HCell) + 1 
            Box(x+1, y, WCell-2 , HCell-1 , #Green) 
            DrawingMode(1) 
            FrontColor(RGB(0,0,0)) 
            DrawingFont(SmallFont) 
            DrawText(x + 1, y+1,textcell$(SEL - 1)) 
            DrawingMode(1) 
            Selected(0) = COLU : Selected(1) = ROW 
        EndIf 
    ElseIf selected(0) 
        CleanCell(Selected(0), Selected(1)) 
        ProcedureReturn 0 
    EndIf 
EndProcedure 

Procedure DrawGrid() 
    Grid = CreateImage(1, wGrid, hGrid ) 
    StartDrawing(ImageOutput(1)) 
        DrawingMode(1) 
        Box(0, 0, wGrid, hGrid, #SAND) 
        Pos = HCell * NRows 
        x1 = 0 : y1 = 0 
        For i = 0 To NColumns 
            LineXY(x1, 0, x1, Pos, #LightGray) 
            x1 + WCell 
        Next i 
        Pos = WCell * NColumns 
        For i = 0 To NRows 
            LineXY(0, y1, Pos, y1) 
            y1 + HCell 
        Next i 
        FrontColor(RGB(0,0,0)) 
        DrawingFont(SmallFont) 
        For i = 0 To Ncells 
            DrawText(xcell(i) + 2, ycell(i)+2,textcell$(i)) 
        Next 
    StopDrawing() 
EndProcedure 

_X = GetSystemMetrics_(#SM_CXSCREEN) - 8 : _Y = GetSystemMetrics_(#SM_CYSCREEN) - 68 
hWnd = OpenWindow(0, 0, 0, _X, _Y, "Grid", #WS_OVERLAPPEDWINDOW) 
AddKeyboardShortcut(0, #PB_Shortcut_Return, #Ret) 

XGrid = 100 : YGrid = 120 ; grid position 
NColumns = 8 : NRows = 12 ; number of rows & columns 
WCell = 72 : HCell = 22 ; cell sizes 
SmallFont = LoadFont(0, "Tahoma ", hcell/2) 

NCells = NColumns * NRows 
WGrid = WCell * NColumns + 1 : HGrid = HCell * NRows + 1 
Global Dim TextCell$(Ncells) 
Global Dim XCell.w(Ncells) 
Global Dim YCell.w(Ncells) 

For i = 0 To ncells 
    If i > 0 And i % ncolumns = 0 : x = 0 : y + hcell : EndIf 
    TextCell$(i) = Str(i + 1) 
    Xcell(i) = x : ycell(i) = y 
    x + wcell 
Next 

CreateGadgetList(hWnd) 
TextGadget(#Txt, _x / 2, yGrid + hGrid + 10, 100, 40, "", #PB_Text_Center | #PB_Text_Border ) 
StringGadget(#Input, 0, 0, 0, 0, "") 

DrawGrid() 
StartDrawing(WindowOutput(0)) 
    
    Repeat 
        MX = WindowMouseX(0) - GetSystemMetrics_(#SM_CYSIZEFRAME) 
        MY = WindowMouseY(0) - GetSystemMetrics_(#SM_CYCAPTION) - GetSystemMetrics_(#SM_CYSIZEFRAME) 
        If #WM_LBUTTONDOWN : mk = 1 : Else : mk = 0 : EndIf 
        Ev = WindowEvent() 
        SEL = DrawCell(Ev) 
        If SEL 
            If mk 
                HideGadget(#input, 0) 
                ResizeGadget(#Input, mx, my, 200, 20) 
                    Repeat 
                    SetActiveGadget(#Input) 
                    ev = WaitWindowEvent() 
                    t$ = GetGadgetText(#Input) 
                  If TextWidth(t$+"W")>wcell:Break:EndIf   ; limit for text too long 
              Until ev = #PB_Event_Menu And EventMenu() = #Ret 
               If Len(t$): textcell$(sel - 1) = t$ : EndIf 
            StopDrawing() 
            drawgrid() 
            StartDrawing(WindowOutput(0)) 
               SetGadgetText(#input, "") 
               ResizeGadget(#input, 0, 0, 0, 0) 
               EndIf 
             SetGadgetText(#Txt, "Selected " + Str(SEL)+s$+textcell$(sel-1)) 
             selected(0) = 0 
        EndIf 
        If Ev = #WM_PAINT : DrawImage(Grid, xgrid, ygrid) : EndIf 
    Until Ev = #PB_Event_CloseWindow 
StopDrawing() 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
