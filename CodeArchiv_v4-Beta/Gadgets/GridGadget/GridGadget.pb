; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8860&highlight=
; Author: einander (updated for PB4.00 by blbltheworm)
; Date: 25. December 2003
; OS: Windows
; Demo: No


; Grid - PB 3.81 
; by Einander 

#LightGray = $BDBDBD : #SAND = $BBFFFF 

Global Dim Selected.l(1) 
Global Grid, Colum, Rows, _X, _Y, WCell, HCell, XGrid, YGrid, NColumns, NRows, NCells, WGrid, HGrid,SmallFont 
SmallFont=LoadFont(0, "Tahoma ", 8) 

Procedure inmous(x, y, x1, y1, mx, my) 
    ProcedureReturn mx >= x And my >= y And mx <= x1 And my <= y1 
EndProcedure 

Procedure CleanCell(COLU, ROW) 
    Box(XGrid + 1 + (COLU - 1) * WCell, YGrid + 1 + (ROW - 1) * HCell, WCell - 1, HCell - 1, #SAND) 
    Selected(0) = 0 
EndProcedure 

Procedure DrawCell(Ev) 
    mx = WindowMouseX(0) - GetSystemMetrics_(#SM_CYSIZEFRAME) 
    my = WindowMouseY(0) - GetSystemMetrics_(#SM_CYCAPTION) - GetSystemMetrics_(#SM_CYSIZEFRAME) 
    If inmous(XGrid + 1, YGrid + 1, XGrid + WGrid - 2, YGrid + HGrid - 2, mx, my) 
        COLU = (mx - XGrid) / WCell + 1 : ROW = (my - YGrid) / HCell + 1 
        SEL = (ROW - 1) * NColumns + COLU 
        If Ev = #WM_LBUTTONDOWN  : ProcedureReturn SEL : EndIf 
        If Selected(0) <> COLU Or Selected(1) <> ROW 
            If Selected(0) : CleanCell(Selected(0), Selected(1)) : EndIf 
            x = XGrid + (COLU - 1) * WCell + 1 : y = YGrid + ((ROW - 1) * HCell) + 1 
            Box(x, y, WCell - 1, HCell - 1, #Green) 
            DrawingMode(1) 
            FrontColor(RGB(0,0,0)) 
            DrawingFont(SmallFont)  
            DrawText(x, y,Str(SEL)) 
            DrawingMode(0) 
            Selected(0) = COLU : Selected(1) = ROW 
        EndIf 
    ElseIf Selected(0) 
        CleanCell(Selected(0), Selected(1)) 
        ProcedureReturn 0 
    EndIf 
EndProcedure 

Procedure DrawGrid() 
    Grid = CreateImage(1, WGrid , HGrid ) 
    StartDrawing(ImageOutput(1)) 
        Box(0,0, WGrid, HGrid, #SAND) 
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
    StopDrawing() 
EndProcedure 


_X = GetSystemMetrics_(#SM_CXSCREEN) - 8 : _Y = GetSystemMetrics_(#SM_CYSCREEN) - 68 
hWnd = OpenWindow(0, 0, 0, _X, _Y, "Grid", #WS_OVERLAPPEDWINDOW) 

XGrid = 100 : YGrid = 120        ;grid position 
NColumns = 10 : NRows = 20   ;number of rows & columns 
WCell = 60 : HCell = 16           ;cell sizes 
NCells = NColumns * NRows 
WGrid = WCell * NColumns+1 : HGrid = HCell * NRows+1 

CreateGadgetList(hWnd) 
TextGadget(2, _X / 2, YGrid + HGrid + 10, 100, 20, "", #PB_Text_Center | #PB_Text_Border ) 

DrawGrid() 
StartDrawing(WindowOutput(0)) 
  
    Repeat 
        Ev = WindowEvent() 
        SEL = DrawCell(Ev) 
        If SEL : SetGadgetText(2, "Selected " + Str(SEL)) : Selected(0) = 0 : EndIf 
        If Ev=#WM_PAINT :  DrawImage(Grid, XGrid,YGrid) : EndIf 
    Until Ev = #PB_Event_CloseWindow 
StopDrawing() 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
