; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8860&highlight=
; Author: srod (updated for PB4.00 by blbltheworm)
; Date: 01. January 2004
; OS: Windows
; Demo: No


; Here is a piece of code which I haven't had time to complete as yet but offers
; a grid in which selections of multiple cells / columns / rows can be made.

; It's approach is not quite as subtle as Einander's but as I say it does allow
; for click and drag type selections.
; It's unlikely that I will fully complete the code but most of the 'leg work' is done.


;PureGrid version 1.0 by Stephen Rodriguez.
;
;Nov 2003.
;********************************************


;This source file allows the programmer to utilise a small grid control within an application.
;This file should ideally be 'XIncludeFile' at the beginning of an application.

;The programmer first needs to construct a '_PureGrid' structure and pass a pointer to this to the OpenPureGrid procedure.
;On return from this module, the '_PureGrid' structure will be modified to reflect changes made by the
;user etc. In particular,the underlying data array will reflect any changes made.


Structure _PureGrid
  PtrDataArray.l; This should contain the address of a string array used to hold the underlying data.
  ; Dim DataArray.s (NumberRows, NumberCols). PtrDataArray = DataArray().
  NumberRows.w; The number of rows in the underlying DataArray excluding row(0) which contains column headings (optional)
  NumberColumns.w; The number of columns in the underlying DataArray excluding column(0) which contains optional row headings.
  ColumnHeadings.b; 1 = Yes.  Flag to indicate whether read-only column headings are included within the DataArray
  RowHeadings.b; 1 = Yes.  Flag to indicate whether read-only row headings are included within the DataArray.
  ReadOnly.b; 1 = Read only. Flag to indicate whether the underlying data array can be written to.
EndStructure


Enumeration
#PureGrid_Window = 900
#PureGrid_ZoomWindow
#PureGrid_Menu
EndEnumeration

;Menu enumeration.
Enumeration
#MenuPureGrid_Copy
#MenuPureGrid_Cut
#MenuPureGrid_Paste
#MenuPureGrid_Clear
#MenuPureGrid_Zoom
EndEnumeration

;Gadget enumeration.
Enumeration
#PureGrid_Container=900
#PureGrid_HScroll
#PureGrid_VScroll
#PureGrid_ZoomEdit
#PureGrid_ZoomButtonOkay
#PureGrid_ZoomButtonCancel
#PureGrid_StringBase
EndEnumeration

;Font enumeration
Enumeration
#PureGrid_Font1=900
#PureGrid_Font2
EndEnumeration


Enumeration; Used for selecting rectangular regions.
#Inactive
#BeginSelect
#SizingSelect
#RectangleSelected
EndEnumeration


;Declare constants.
#PureGrid_Yes = 1 : #PureGrid_No = 0 : #PureGrid_DefaultCellWidth = 100 : #PureGrid_DefaultCellHeight = 20
#PureGrid_EnableZoomBox = #PureGrid_Yes; Change this option if you do not wish to offer the Zoom Box facility.

;Declare globals.
Global PureGrid_DisplayedRows.b, PureGrid_DisplayedColumns; No. of rows/columns to be displayed.
Global PureGrid_DefaultDisplayedRows.b, PureGrid_DefaultDisplayedColumns.b; Default no. of rows/columns to be displayed.
Global PureGrid_Left.w, PureGrid_Top.w; Used to indicate which data item occupies grid cell (1, 1).
Global PureGrid_x.w, PureGrid_y.w; Points to the grid cell with the focus; NOT the corresponding element within the data array.
Global PureGrid_DataRows.w, PureGrid_DataColumns.w, PureGrid_RowHeadings.b, PureGrid_ColumnHeadings.b, PureGrid_PtrDataArray, PureGrid_ReadOnly.b; These are used to record information about the underlying data array.
Global PureGrid_SelectingRectangle.b, PureGrid_Rectangle.RECT; Used when selecting a region.
Global BlackBrush.l, WhiteBrush.l; Used when highlighting selected cells.
;Declare fonts used.
LoadFont(#PureGrid_Font1, "Arial", 10, #PB_Font_Bold)
LoadFont(#PureGrid_Font2, "Arial", 10)


;Declare procedures.
Declare InitialisePureGridVariables()
Declare OpenPureGrid(*Grid._PureGrid, Title$)
Declare CreatePureGridGadgets(Title$)
Declare PaintPureGrid(flag.b)
Declare PureGridWriteDataFromCell(tempx.w, tempy.w)
Declare PureGridRowColumnIdentify(*temp.POINT)
Declare WindowCallBack(WindowID,Message,wParam,lParam)
Declare PureGridZoom()

;Set up some dummy data for testing purposes.
PureGrid._PureGrid
PureGrid\NumberRows = 20
PureGrid\NumberColumns = 16
PureGrid\ColumnHeadings = #PureGrid_No
PureGrid\RowHeadings = #PureGrid_No
PureGrid\ReadOnly = #PureGrid_No
Global Dim DataArray.s (20,16)

For PureGrid_LoopRow = 1 To PureGrid\NumberRows
  For PureGrid_LoopCol = 1 To PureGrid\NumberColumns
    DataArray(PureGrid_LoopRow, PureGrid_LoopCol) = "(" + Str(PureGrid_LoopRow) + ", " + Str(PureGrid_LoopCol) +  ")"
  Next PureGrid_LoopCol
Next PureGrid_LoopRow

PureGrid\PtrDataArray = DataArray()
OpenPureGrid(@PureGrid, "TESTING.")
End

;End of setting up dummy data.


;The following procedure initialises global variables etc.
Procedure InitialisePureGridVariables()
  ;First calculate the possible number of rows and columns which can fit on the screen.
  ;This obviously depends upon the screen resolution etc.
  PureGrid_DefaultDisplayedRows = 15
  PureGrid_DefaultDisplayedColumns = WindowWidth(#PureGrid_Window)/#PureGrid_DefaultCellWidth - 2
  PureGrid_Left = 1
  PureGrid_Top = 1
  PureGrid_x = 1
  PureGrid_y = 1
  PureGrid_Rectangle\left = -1:PureGrid_Rectangle\Top = -1:PureGrid_Rectangle\right = -1:PureGrid_Rectangle\bottom = -1
  PureGrid_SelectingRectangle = #Inactive
  ;Create brushes used in highlighting selected cells.
  BlackBrush = CreateSolidBrush_($0)
  WhiteBrush = CreateSolidBrush_($FFFFFF)
EndProcedure


Procedure CreatePureGridGadgets(Title$)
  Protected LoopRow, LoopColumn, OldAddress, ContainerWidth, ContainerHeight, Style
  ;The TempDataArray essentially points to the actual underlying data array.
  Global Dim TempDataArray.s(PureGrid_DataRows, PureGrid_DataColumns)
  OldAddress = TempDataArray()
  TempDataArray() = PureGrid_PtrDataArray
  ;Finished setting up TempDataArray.
  
  ;First load the underlying data array with default row and column headings if none are given.
  If PureGrid_ColumnHeadings = #PureGrid_No
    For LoopColumn = 1 To PureGrid_DataColumns
      TempDataArray(0, LoopColumn) = "Col " + Str(LoopColumn)
    Next LoopColumn
  EndIf
  If PureGrid_RowHeadings = #PureGrid_No
    For LoopRow = 1 To PureGrid_DataRows
      TempDataArray(LoopRow,0) = "Row " + Str(LoopRow)
    Next LoopRow
  EndIf
  ;Finished loading row and column headings.
  
  ;Now set up the main gadgets.
  ContainerWidth = (PureGrid_DisplayedColumns+1)*(#PureGrid_DefaultCellWidth+1)+20
  ContainerHeight = (PureGrid_DisplayedRows+1)*(#PureGrid_DefaultCellHeight+1)+20
  CreateGadgetList(WindowID(#PureGrid_Window))
  ContainerGadget(#PureGrid_Container,(WindowWidth(#PureGrid_Window) - ContainerWidth)/2,(WindowHeight(#PureGrid_Window) - ContainerHeight)/3,ContainerWidth,ContainerHeight,#PB_Container_BorderLess)
  For LoopRow = 0 To PureGrid_DisplayedRows
    For LoopColumn = 0 To PureGrid_DisplayedColumns
      If LoopRow = 0 Or LoopColumn = 0
        ButtonGadget(#PureGrid_StringBase + (LoopRow)*(PureGrid_DisplayedColumns+1) + LoopColumn,(#PureGrid_DefaultCellWidth+1)*(LoopColumn),(#PureGrid_DefaultCellHeight+1)*(LoopRow),#PureGrid_DefaultCellWidth,#PureGrid_DefaultCellHeight,"")
        SetGadgetFont(#PureGrid_StringBase + (LoopRow)*(PureGrid_DisplayedColumns+1) + LoopColumn,FontID(#PureGrid_Font1))
      Else
        Style = #PB_String_BorderLess | #ES_MULTILINE 
        If PureGrid_ReadOnly = #PureGrid_Yes
          Style = Style | #PB_String_ReadOnly
        EndIf
        StringGadget(#PureGrid_StringBase + (LoopRow)*(PureGrid_DisplayedColumns+1) + LoopColumn,(#PureGrid_DefaultCellWidth+1)*(LoopColumn),(#PureGrid_DefaultCellHeight+1)*(LoopRow),#PureGrid_DefaultCellWidth,#PureGrid_DefaultCellHeight,"", Style)
        SetGadgetFont(#PureGrid_StringBase + (LoopRow)*(PureGrid_DisplayedColumns+1) + LoopColumn,FontID(#PureGrid_Font2))
      EndIf
      SetGadgetText(#PureGrid_StringBase + (LoopRow)*(PureGrid_DisplayedColumns+1) + LoopColumn, TempDataArray(LoopRow, LoopColumn))
    Next LoopColumn
  Next LoopRow
  ;Now for the scroll bar gadgets.
  ScrollBarGadget(#PureGrid_HScroll, #PureGrid_DefaultCellWidth+1, (PureGrid_DisplayedRows+1)*(#PureGrid_DefaultCellHeight+1),(PureGrid_DisplayedColumns)*(#PureGrid_DefaultCellWidth+1), 20, 1, PureGrid_DataColumns, PureGrid_DisplayedColumns)
  ScrollBarGadget(#PureGrid_VScroll, (PureGrid_DisplayedColumns+1)*(#PureGrid_DefaultCellWidth+1),#PureGrid_DefaultCellHeight+1, 20, (PureGrid_DisplayedRows)*(#PureGrid_DefaultCellHeight+1), 1, PureGrid_DataRows, PureGrid_DisplayedRows, #PB_ScrollBar_Vertical)
  CloseGadgetList()
  SetActiveGadget(#PureGrid_StringBase+1*(PureGrid_DisplayedColumns+1) +1); Cell (1, 1)
  ;Tidy up.
  TempDataArray() = OldAddress; Restore temporary array.
  Global Dim TempDataArray.s(0,0); Free temporary array
  ;End of tidying up.
EndProcedure


;The following procedure re-paints the grid, typically after it has been scrolled etc.
Procedure PaintPureGrid(flag.b); Flag = 1 for setting fonts only; 0 for writing data.
  Protected LoopRow, LoopColumn, OldAddress
  ;The TempDataArray essentially points to the actual underlying data array.
  Global Dim TempDataArray.s(PureGrid_DataRows, PureGrid_DataColumns)
  OldAddress = TempDataArray()
  TempDataArray() = PureGrid_PtrDataArray
  ;Finished setting up TempDataArray.
  ;Now re-paint the grid with the correct contents taken from the underlying data array.
  For LoopRow = flag To PureGrid_DisplayedRows
    For LoopColumn = flag To PureGrid_DisplayedColumns
      If LoopRow = 0 And LoopColumn = 0; Ignore this cell.
      ElseIf LoopRow = 0
        SetGadgetText(#PureGrid_StringBase + (LoopRow)*(PureGrid_DisplayedColumns+1) + LoopColumn,TempDataArray(LoopRow, LoopColumn+PureGrid_Left-1))
      ElseIf LoopColumn = 0
        SetGadgetText(#PureGrid_StringBase + (LoopRow)*(PureGrid_DisplayedColumns+1) + LoopColumn,TempDataArray(LoopRow+PureGrid_Top-1, LoopColumn))
      Else
        If flag = 0; Write data only if required.
          SetGadgetText(#PureGrid_StringBase + (LoopRow)*(PureGrid_DisplayedColumns+1) + LoopColumn,TempDataArray(LoopRow+PureGrid_Top-1, LoopColumn+ PureGrid_Left-1))
        EndIf
        ;The following SetGadgetFont statement will cause the WindowCallBack procedure to be called which will
        ;set the background colour as appropriate.
        SetGadgetFont(#PureGrid_StringBase + (LoopRow)*(PureGrid_DisplayedColumns+1) + LoopColumn,FontID(#PureGrid_Font2))
      EndIf
    Next LoopColumn
  Next LoopRow
  ;Adjust cursor position after any possible scrolling etc.
  ;Activate relevant string gadget.
  If PureGrid_x < PureGrid_Left
    PureGrid_x = PureGrid_Left
  EndIf
  If PureGrid_x >= PureGrid_Left + PureGrid_DisplayedColumns
    PureGrid_x = PureGrid_Left + PureGrid_DisplayedColumns-1
  EndIf
  If PureGrid_y < PureGrid_Top
    PureGrid_y = PureGrid_Top
  EndIf
  If PureGrid_y >= PureGrid_Top + PureGrid_DisplayedRows
    PureGrid_y = PureGrid_Top + PureGrid_DisplayedRows - 1
  EndIf
  ;Now highlight the text within the selected string gadget.
  SetActiveGadget(#PureGrid_StringBase+(PureGrid_y-PureGrid_Top+1)*(PureGrid_DisplayedColumns+1) + PureGrid_x-PureGrid_Left+1)
  ;Tidy up.
  TempDataArray() = OldAddress; Restore temporary array.
  Global Dim TempDataArray.s(0,0); Free temporary array
  ;End of tidying up.
EndProcedure


;The following procedure performs all writing of data to the underlying array.
;This ensures that we can introduce an 'Undo' facility later.
Procedure PureGridWriteDataFromCell(tempx.w, tempy.w); (tempx, tempy) point to the underlying data array.
  Protected LoopRow.b, LoopColumn.b, OldAddress
  ;The TempDataArray essentially points to the actual underlying data array.
  Global Dim TempDataArray.s(PureGrid_DataRows, PureGrid_DataColumns)
  OldAddress = TempDataArray()
  TempDataArray() = PureGrid_PtrDataArray
  ;Finished setting up TempDataArray.
  ;Now copy data from the grid ONLY if it HAS NOT been altered at all. This will allow for an UNDO action later.
  If TempDataArray(tempy, tempx) <> GetGadgetText(#PureGrid_StringBase+(tempy-PureGrid_Top+1)*(PureGrid_DisplayedColumns+1) + tempx-PureGrid_Left+1)
    
    ;INSERT CODE FOR DEALING WITH AN UNDO FACILITY.
    
    TempDataArray(tempy, tempx) = GetGadgetText(#PureGrid_StringBase+(tempy-PureGrid_Top+1)*(PureGrid_DisplayedColumns+1) + tempx-PureGrid_Left+1)
  EndIf
  ;Tidy up.
  TempDataArray() = OldAddress; Restore temporary array.
  Global Dim TempDataArray.s(0,0); Free temporary array
  ;End of tidying up.
EndProcedure


;The following procedure involves calling the Windows API to convert the cursor screen coordinates
;into coordinates relative to the top left of the container gadget.
;This could be done using PB's WindowMouseX and WindowMouseY functions but that then leaves the task
;of determining where in the gadget the cursor is pointing to the programmer.
;The coordinates are then converted into the (row,column) position of the underlying data array which has the focus.
;(NOT the respective string gadget.) This data is then placed into the PureGrid_Rectangle structure as appropriate.
Procedure PureGridRowColumnIdentify(*temp.POINT)
  Protected Column.w, Row.w, temporary.f
  GetCursorPos_(*temp)
  MapWindowPoints_(0,GadgetID(#PureGrid_Container),*temp,1)
  ;First identify the (row, column) grid coordinates of the gadget with the focus.
  Column = Round(*temp\x /(#PureGrid_DefaultCellWidth+1),0); Ensures calculation is rounded down.
  Row = Round(*temp\y /(#PureGrid_DefaultCellHeight+1),0);Avoids problems with -0.6 being rounded to 0 etc.
  ;Now convert to the coordinates of the respective cell in the underlying data array.
  *temp\x = Column+PureGrid_Left-1
  *temp\y = Row+PureGrid_Top-1
EndProcedure


;The following procedure deals with the zoom facility.
Procedure PureGridZoom()
  OpenWindow(#PureGrid_ZoomWindow,175,0,639,243,"ZOOM BOX",#PB_Window_SystemMenu|#PB_Window_TitleBar|#PB_Window_ScreenCentered, WindowID(#PureGrid_Window))
  CreateGadgetList(WindowID(#PureGrid_ZoomWindow))
  EditorGadget(#PureGrid_ZoomEdit,49,37,450,150,#PB_String_ReadOnly)
  ;Send an API message to set read only if appropriate.
  SendMessage_(GadgetID(#PureGrid_ZoomEdit),#EM_SETREADONLY, PureGrid_ReadOnly, 0)
  ButtonGadget(#PureGrid_ZoomButtonOkay,520,116,85,30,"OKAY")
  ButtonGadget(#PureGrid_ZoomButtonCancel,520,156,85,30,"CANCEL")
  SetGadgetText(#PureGrid_ZoomEdit,GetGadgetText(#PureGrid_StringBase+(PureGrid_y-PureGrid_Top+1)*(PureGrid_DisplayedColumns+1) + PureGrid_x-PureGrid_Left+1))
  SetActiveGadget(#PureGrid_ZoomEdit)
  Repeat
    EventID=WaitWindowEvent()
  Until EventID=#PB_Event_CloseWindow Or (EventID = #PB_Event_Gadget And EventGadget() = #PureGrid_ZoomButtonOkay) Or (EventID = #PB_Event_Gadget And EventGadget() = #PureGrid_ZoomButtonCancel)
  ;Now write data back to the grid only if the proceed button was pushed.
  If EventID = #PB_Event_Gadget And EventGadget() = #PureGrid_ZoomButtonOkay
    SetGadgetText(#PureGrid_StringBase+(PureGrid_y-PureGrid_Top+1)*(PureGrid_DisplayedColumns+1) + PureGrid_x-PureGrid_Left+1, GetGadgetText(#PureGrid_ZoomEdit))
  EndIf
  CloseWindow(#PureGrid_ZoomWindow)
  SetActiveGadget(#PureGrid_StringBase+(PureGrid_y-PureGrid_Top+1)*(PureGrid_DisplayedColumns+1) + PureGrid_x-PureGrid_Left+1)
EndProcedure


;The main procedure.
Procedure OpenPureGrid(*Grid._PureGrid, Title$)
  Protected temp.POINT, x.w, y.w, flag.b
  If Title$ <> ""
    Title$ = Title$ + "     "
  EndIf
  Title$ = Title$ + "PRESS F2 TO OPEN A 'ZOOM' BOX."
  OpenWindow(#PureGrid_Window,0,0,400,400,Title$,  #PB_Window_Invisible | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  ShowWindow_(WindowID(#PureGrid_Window), #SW_MAXIMIZE)
  ;  SetClassLong_(WindowID(), #GCL_STYLE, GetClassLong_(WindowID(), #GCL_STYLE)|#CS_DBLCLKS); This allows the trapping of double click events.
  
  ;Initialise global variables.
  InitialisePureGridVariables()
  
  ;Load data array and associated information.
  PureGrid_PtrDataArray = *Grid\PtrDataArray; This gives direct access to the underlying DataArray.
  PureGrid_DataRows = *Grid\NumberRows
  PureGrid_DataColumns = *Grid\NumberColumns
  PureGrid_RowHeadings = *Grid\RowHeadings
  PureGrid_ColumnHeadings = *Grid\ColumnHeadings
  PureGrid_ReadOnly = *Grid\ReadOnly
  ;The PureGrid_DisplayedRows / Columns variables denote the number of visible rows / columns.
  ;These are either default values (depending on window size) or the actual dimensions of the underlying
  ;data array; whichever is the smaller.
  PureGrid_DisplayedRows = PureGrid_DefaultDisplayedRows
  If PureGrid_DataRows < PureGrid_DefaultDisplayedRows : PureGrid_DisplayedRows = PureGrid_DataRows : EndIf
  PureGrid_DisplayedColumns = PureGrid_DefaultDisplayedColumns
  If PureGrid_DataColumns < PureGrid_DefaultDisplayedColumns : PureGrid_DisplayedColumns = PureGrid_DataColumns : EndIf
  ;End of loading data.
  
  ;Create menu.
  CreateMenu(#PureGrid_Menu, WindowID(#PureGrid_Window))
  MenuTitle("Edit")
  MenuItem(#MenuPureGrid_Copy, "Copy" + Chr(9) + "(Ctrl+c)")
  MenuItem(#MenuPureGrid_Cut, "Cut"+Chr(9)+"(Ctrl+x)")
  MenuItem(#MenuPureGrid_Paste, "Paste"+Chr(9)+"(Ctrl+v)")
  MenuItem(#MenuPureGrid_Clear, "Clear")
  MenuItem(#MenuPureGrid_Zoom, "Zoom box"+Chr(9)+"(F2)")
  ;Create menu shortcuts.
  AddKeyboardShortcut(#PureGrid_Window, #PB_Shortcut_F2, #MenuPureGrid_Zoom)
  
  
  CreatePureGridGadgets(Title$)
  SetWindowCallback(@WindowCallBack())
  
  ;Main event loop.
  Repeat
    ;Check to see if the user has pressed the tab key.
    ;In which case we must ensure correct movement through the grid.
    If GetAsyncKeyState_(#VK_TAB) & 1 = 1;  Bit 0 is set if the tab key was pressed since the last check.
      flag = 2; Used to determine how the grid will be painted. 2 means NO PAINT required.
      ;Write data back to the data array if it has changed.
      PureGridWriteDataFromCell(PureGrid_x, PureGrid_y)
      
      If PureGrid_x <  PureGrid_DataColumns; Scroll right.
        PureGrid_x = PureGrid_x + 1
        ;Check if we've moved to far right.
        If PureGrid_x >= PureGrid_Left + PureGrid_DisplayedColumns
          SetGadgetState(#PureGrid_HScroll, GetGadgetState(#PureGrid_HScroll)+1)
          PureGrid_Left = GetGadgetState(#PureGrid_HScroll)
          flag = 0; Complete paint required, including text.
        EndIf
      ElseIf PureGrid_y < PureGrid_DataRows;  Need to move the focus down a row.
        PureGrid_x = 1
        SetGadgetState(#PureGrid_HScroll, 1)
        If PureGrid_Left > 1
          PureGrid_Left = 1
          flag = 0
        EndIf
        PureGrid_y = PureGrid_y + 1
        If PureGrid_y >= PureGrid_Top + PureGrid_DisplayedRows
          SetGadgetState(#PureGrid_VScroll, GetGadgetState(#PureGrid_VScroll)+1)
          PureGrid_Top = GetGadgetState(#PureGrid_VScroll)
          flag = 0
        EndIf
      EndIf
      ;Clear any current selection.
      PureGrid_Rectangle\right = -1 : PureGrid_Rectangle\bottom = -1
      If PureGrid_SelectingRectangle = #RectangleSelected
        If flag > 0 : flag = 1 : EndIf; Only the font properties etc. need painting.
        PureGrid_SelectingRectangle = #Inactive
      EndIf
      If flag < 2
        PaintPureGrid(flag)
      EndIf
      ;Now highlight the relevant gadget.
      SetActiveGadget(#PureGrid_StringBase+(PureGrid_y-PureGrid_Top+1)*(PureGrid_DisplayedColumns+1) + PureGrid_x-PureGrid_Left+1)
      SendMessage_(GadgetID(#PureGrid_StringBase+(PureGrid_y-PureGrid_Top+1)*(PureGrid_DisplayedColumns+1) + PureGrid_x-PureGrid_Left+1),#EM_SETSEL, 0, -1)
    EndIf
    
    
    EventID=WaitWindowEvent()
    
    If EventType() = #PB_EventType_Change; Indicates that the contents of a string gadget have changed.
      ;Clear any current selection.
      PureGrid_Rectangle\right = -1 : PureGrid_Rectangle\bottom = -1
      If PureGrid_SelectingRectangle <> #Inactive
        PaintPureGrid(1)
        PureGrid_SelectingRectangle = #Inactive;
      EndIf
    EndIf
    Select EventID
    Case #WM_LBUTTONDOWN
      ;Here the user is probably about to select a region to copy / cut etc.
      ;First write data back to the data array if it has changed.
      PureGridWriteDataFromCell(PureGrid_x, PureGrid_y)
      ;We call a function to get the mouse (x, y) co-ordinates relative to the top-left of the container gadget
      ;and the coordinates are then converted into the (row,column) position of the underlying data array which has the focus.
      PureGridRowColumnIdentify(@temp); The point structure will hold the retrieved data.
      ;Check whether the 'data point' is within the visible grid.
      If temp\x >= PureGrid_Left And temp\x < PureGrid_Left + PureGrid_DisplayedColumns And temp\y >= PureGrid_Top And temp\y < PureGrid_Top + PureGrid_DisplayedRows
        ;Clear any current selection.
        PureGrid_Rectangle\right = -1 : PureGrid_Rectangle\bottom = -1
        ;Set the initial top-left corner of the PureGrid_Rectangle structure to the current point.
        x = temp\x
        y = temp\y
        ;And the current cursor position.
        PureGrid_x = temp\x
        PureGrid_y = temp\y
        If PureGrid_SelectingRectangle = #RectangleSelected Or PureGrid_SelectingRectangle = #SizingSelect
          PaintPureGrid(1); This will remove the current selection.
        EndIf
        ;Flag that the selection process has begun.
        PureGrid_SelectingRectangle = #BeginSelect
      ElseIf temp\x = PureGrid_Left-1 And temp\y = PureGrid_Top -1; Indicates that the whole data set has been selected.
        PureGrid_Rectangle\left = 1
        PureGrid_Rectangle\Top = 1
        PureGrid_Rectangle\right = PureGrid_DataColumns
        PureGrid_Rectangle\bottom = PureGrid_DataRows
        PaintPureGrid(1); This will highlight the current selection.
        PureGrid_SelectingRectangle = #RectangleSelected
      ElseIf temp\x = PureGrid_Left-1 And temp\y >= PureGrid_Top And temp\y < PureGrid_Top + PureGrid_DisplayedRows; Indicates that a row has been selected.
        x = 0 : y = temp\y; The 0 indicates that a whole row has been selected.
        ;Highlight the selected row.
        PureGrid_Rectangle\left = 1
        PureGrid_Rectangle\Top = temp\y
        PureGrid_Rectangle\right = PureGrid_DataColumns
        PureGrid_Rectangle\bottom = temp\y
        PaintPureGrid(1); This will highlight the current selection.
        PureGrid_SelectingRectangle = #SizingSelect
      ElseIf temp\y = PureGrid_Top-1 And temp\x >= PureGrid_Left And temp\x < PureGrid_Left + PureGrid_DisplayedColumns; Indicates that a column has been selected.
        y = 0 : x = temp\x; The 0 indicates that a whole column has been selected.
        ;Highlight the selected column.
        PureGrid_Rectangle\left = temp\x
        PureGrid_Rectangle\Top = 1
        PureGrid_Rectangle\right = temp\x
        PureGrid_Rectangle\bottom = PureGrid_DataRows
        PaintPureGrid(1); This will highlight the current selection.
        PureGrid_SelectingRectangle = #SizingSelect
      EndIf
      
    Case #WM_LBUTTONUP
      Select PureGrid_SelectingRectangle
      Case #BeginSelect
        PureGrid_SelectingRectangle = #Inactive
      Case #SizingSelect
        PureGrid_SelectingRectangle = #RectangleSelected
      EndSelect
      
    Case #WM_MOUSEMOVE
      ;If the user is in the middle of selecting a rectangle then we need to adjust the selection rectangle etc.
      If PureGrid_SelectingRectangle = #BeginSelect Or PureGrid_SelectingRectangle = #SizingSelect
        flag = 1; Indicate that repainting requires only change of background colour etc.
        ;We call a function to get the mouse (x, y) co-ordinates relative to the top-left of the container gadget
        ;and the coordinates are then converted into the (row,column) position of the underlying data array which has the focus.
        PureGridRowColumnIdentify(@temp); The point structure will hold the retrieved data.
        
        ;CODE FOR SCROLLING SELECTION.
        ;Check if the cursor is too far right.
        If (temp\x >= PureGrid_Left + PureGrid_DisplayedColumns)
          SetGadgetState(#PureGrid_HScroll, GetGadgetState(#PureGrid_HScroll)+1)
          PureGrid_Left = GetGadgetState(#PureGrid_HScroll)
          flag = 0
        EndIf
        ;Check if the cursor is too far left. Must also check that row selection is not engaged.
        If (temp\x < PureGrid_Left) And x > 0
          SetGadgetState(#PureGrid_HScroll, GetGadgetState(#PureGrid_HScroll)-1)
          PureGrid_Left = GetGadgetState(#PureGrid_HScroll)
          flag = 0
        EndIf
        ;Check if the cursor is too far down.
        If (temp\y >= PureGrid_Top + PureGrid_DisplayedRows)
          SetGadgetState(#PureGrid_VScroll, GetGadgetState(#PureGrid_VScroll)+1)
          PureGrid_Top = GetGadgetState(#PureGrid_VScroll)
          flag = 0
        EndIf
        ;Check if the cursor is too far up. Must also check that column selection is not engaged.
        If (temp\y < PureGrid_Top) And y > 0
          SetGadgetState(#PureGrid_VScroll, GetGadgetState(#PureGrid_VScroll)-1)
          PureGrid_Top = GetGadgetState(#PureGrid_VScroll)
          flag = 0
        EndIf
        
        If x = 0; Row selection.
          If temp\y < y
            PureGrid_Rectangle\bottom = y
            PureGrid_Rectangle\Top = temp\y
          Else
            PureGrid_Rectangle\Top = y
            PureGrid_Rectangle\bottom = temp\y
          EndIf
          
        ElseIf y = 0; Column selection.
          If temp\x < x
            PureGrid_Rectangle\right = x
            PureGrid_Rectangle\left = temp\x
          Else
            PureGrid_Rectangle\left = x
            PureGrid_Rectangle\right = temp\x
          EndIf
          
          ;Adjust coordinates so that (PureGrid_Rectangle\left, PureGrid_Rectangle\top) points to the top left of the selection etc.
        Else
          PureGrid_Rectangle\right = temp\x
          PureGrid_Rectangle\bottom = temp\y
          If x > PureGrid_Rectangle\right
            PureGrid_Rectangle\left = PureGrid_Rectangle\right
            PureGrid_Rectangle\right = x
          Else
            PureGrid_Rectangle\left = x
          EndIf
          If y > PureGrid_Rectangle\bottom
            PureGrid_Rectangle\Top = PureGrid_Rectangle\bottom
            PureGrid_Rectangle\bottom = y
          Else
            PureGrid_Rectangle\Top = y
          EndIf
        EndIf
        PaintPureGrid(flag); This will highlight the current selection.
        PureGrid_SelectingRectangle = #SizingSelect
      EndIf
      
    Case #PB_Event_Menu
      ;Write data back to the data array if it has changed.
      PureGridWriteDataFromCell(PureGrid_x, PureGrid_y)
      Select EventMenu()
      Case #MenuPureGrid_Zoom
        ;Clear any current selection.
        PureGrid_Rectangle\right = -1 : PureGrid_Rectangle\bottom = -1
        If PureGrid_SelectingRectangle <> #Inactive
          PaintPureGrid(1)
          PureGrid_SelectingRectangle = #Inactive;
        EndIf
        ;Call Zoom procedure.
        PureGridZoom()
        ;Write data back to the data array if it has changed.
        PureGridWriteDataFromCell(PureGrid_x, PureGrid_y)
      EndSelect
      
      
    Case #PB_Event_Gadget
      Select EventGadget()
      Case #PureGrid_HScroll; Indicates that the horziontal scroll bar has been adjusted.
        If PureGrid_Left <> GetGadgetState(#PureGrid_HScroll); Save some processing time by making this check.
          ;Write data back to the data array if it has changed.
          PureGridWriteDataFromCell(PureGrid_x, PureGrid_y)
          PureGrid_Left = GetGadgetState(#PureGrid_HScroll)
          PaintPureGrid(0)
        EndIf
      Case #PureGrid_VScroll; Indicates that the vertical scroll bar has been adjusted.
        If PureGrid_Top <> GetGadgetState(#PureGrid_VScroll); Save some processing time by making this check.
          ;Write data back to the data array if it has changed.
          PureGridWriteDataFromCell(PureGrid_x, PureGrid_y)
          PureGrid_Top = GetGadgetState(#PureGrid_VScroll)
          PaintPureGrid(0)
        EndIf
      EndSelect
      Default
    EndSelect
  Until EventID=#PB_Event_CloseWindow
  ;Write data back to the data array if it has changed.
  PureGridWriteDataFromCell(PureGrid_x, PureGrid_y)
  ;Delete the rosources given over to the two brushes.
  DeleteObject_(BlackBrush)
  DeleteObject_(WhiteBrush)
EndProcedure


;The following callback procedure intercepts the drawing of each string gadget.
;This makes it possible to highlight any selected gadgets.
Procedure WindowCallBack(WindowID,Message,wParam,lParam)
  ReturnValue=#PB_ProcessPureBasicEvents
  If Message=#WM_CTLCOLOREDIT; This indicates that one of the string gadgets is about to be drawn.
    ;We first need to identify which string gadget is being drawn.
    For LoopRow = 1 To PureGrid_DisplayedRows
      For LoopColumn = 1 To PureGrid_DisplayedColumns
        If lParam = GadgetID(#PureGrid_StringBase + (LoopRow)*(PureGrid_DisplayedColumns+1) + LoopColumn)
          Break 2; Break out of the 2 loops.
        EndIf
      Next LoopColumn
    Next LoopRow
    ;(LoopRow, LoopColumn) identifies the string gadget being drawn.
    ;Now check if the string gadget is within a selected region.
    SetBkMode_(wParam,#OPAQUE)
    If (PureGrid_Rectangle\right <>-1) And ((LoopColumn + PureGrid_Left-1) >= PureGrid_Rectangle\left) And ((LoopColumn + PureGrid_Left-1) <= PureGrid_Rectangle\right) And ((LoopRow + PureGrid_Top-1) >= PureGrid_Rectangle\Top) And ((LoopRow + PureGrid_Top-1) <= PureGrid_Rectangle\bottom)
      SetTextColor_(wParam,$FFFFFF)
      SetBkColor_(wParam,$0000)
      ReturnValue=BlackBrush
    Else
      SetBkColor_(wParam,$FFFFFF)
      ReturnValue=WhiteBrush
    EndIf
  EndIf
  ProcedureReturn  ReturnValue
EndProcedure


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; EnableXP
; DisableDebugger
