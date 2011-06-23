; English forum: http://www.purebasic.fr/english/viewtopic.php?t=12957
; Author: Manolo (updated for PB 4.00 by Andre)
; Date: 29. October 2004
; OS: Windows
; Demo: No


; Original was:
; -------------
; English forum: http://purebasic.myforums.net/viewtopic.php?t=8860&highlight=
; Author: einander
; Date: 26. December 2003

; Grid with input text
; December 26 -2003- PB 3.81
; by Einander
;
; Useful additions are:
; ---------------------
; -Implementation of direct input in the cell
; -Implementation of beatiful titles with degree-colors from Num3
; -and another small changes
; -by Manolo
; -October 28, 2004 - PB 3.92

DataSection
  Dia_Semana:
  Data.s "Lun","Mar","Mie","Jue","Vie","Sab","Dom"
  Mes:
  Data.s "ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"
EndDataSection
Dim Dia.s(7)
Global Dim OrgDia.s(7)
Dim Mes.s(12)
For i=1 To 7:Read Dia(i):Next
For i=1 To 12:Read Mes(i):Next

For i=1 To 7
  date+1
  Result = DayOfWeek(AddDate(Date(), #PB_Date_Day, date))
  Mes = Month(AddDate(Date(), #PB_Date_Day, date))
  Dia=Day(AddDate(Date(), #PB_Date_Day, date))
  If Result=0 :OrgDia(i)=Dia(7)+" "+Str(Dia): Else : OrgDia(i)=Dia(result)+" "+Str(Dia): EndIf
Next




;Read Dia(i)
;Next
Enumeration
  #Ret
  #Txt
  #Input
  #SepaHori
  #SepaVert
EndEnumeration

#LightGray =$AA1216;$BDBDBD
#SAND= $BBFFFF



Global Dim Selected.l(1): Global Dim textcell$(0) : Global Dim xcell.W(0) : Global Dim ycell.W(0)
Global Mx, My, Mk,S$, gad$
Global Grid, Colum, Rows, _X, _Y, WCell, HCell, XGrid, YGrid, NColumns, NRows, NCells, WGrid, HGrid, SmallFont
S$="  "

Procedure separator(id,x,y,width,height,text.s,fontid,color1,color2,Columnas,Filas)


  If CreateImage(id,width*(Columnas),height*(Filas))

    i = width
    sRed.f   = Red(color1)   : r.f = (Red  (color1) - Red  (color2))/i
    sGreen.f = Green(color1) : g.f = (Green(color1) - Green(color2))/i
    sBlue.f  = Blue(color1)  : b.f = (Blue (color1) - Blue (color2))/i

    StartDrawing(ImageOutput(id))
    Pos=0
    If id=#SepaHori
      For k=1 To Columnas
        ;----------------
        For a = 0 To i-1
          xx.f = sRed   - a*r
          yy.f = sGreen - a*g
          zz.f = sBlue  - a*b

          Line(a+Pos,0,0,height,RGB(xx,yy,zz))
        Next a
        ;----------------
        DrawingMode(1)
        FrontColor(RGB(255,156,41))
        ; FrontColor($FF,$FF,$FF)
        If fontid<>0
          DrawingFont(fontid)
        EndIf
        ;----------
        DrawText(Pos+5,2,OrgDia(k))
        Pos+width
      Next k
      StopDrawing()
    EndIf

    If id=#SepaVert
      Pos-height

      For k=-1 To Filas-1

        ;----------------
        For a = 0 To i-1

          xx.f = sRed   - a*r
          yy.f = sGreen - a*g
          zz.f = sBlue  - a*b

          Line(a,Pos,0,height,RGB(xx,yy,zz))
        Next a
        ;----------------
        DrawingMode(1)
        FrontColor(RGB(255,156,41))
        ; FrontColor($FF,$FF,$FF)
        If fontid<>0
          DrawingFont(fontid)
        EndIf
        ;----------

        If k=0
          FrontColor(RGB(255,100,200))
          Texto$="Octubre"
          DrawText(5,Pos,Texto$)
        Else
          FrontColor(RGB(255,156,41))
          Texto$="Hora"+Str(k)
          DrawText(5,Pos,Texto$)
        EndIf
        Pos+height

      Next k
      StopDrawing()
    EndIf



  EndIf

  ImageGadget(id,x,y,width,Header,ImageID(id))


EndProcedure

Procedure inmous(x, y, x1, y1)
  ProcedureReturn mx >= x And my >= y And mx <= x1 And my <= y1
EndProcedure

Procedure CleanCell(COLU, ROW)
  Global x, y ;implantada
  x = XGrid + 1 + (COLU - 1) * WCell+1
  y = YGrid + 1 + (ROW - 1) * HCell+1
  Box(X, Y-1, WCell-2, HCell-1, #SAND)
  SEL = (ROW - 1 ) * NColumns + COLU
  DrawingFont(SmallFont)
  FrontColor(RGB(0, 0, 0))
  gad$=textcell$(SEL - 1)
  minu=Len(gad$)
  While TextWidth(gad$)>(Wcell-(TextWidth("W")))
    minu-2
    gad$=Mid(textcell$(sel-1),1,minu)
  Wend
  If TextWidth(gad$)<>0
    Posicion=(WCell-TextWidth(gad$))/2
  Else
    Posicion=2
  EndIf
  ;Debug posicion
  ;Debug WCell
  ;Debug TextWidth(gad$)
  DrawText(x+Posicion,y,gad$);+"..") ;DrawText(textcell$(i))
  ; Locate(x , y) :DrawText(textcell$(SEL - 1)) ;DrawText(textcell$(SEL - 1))
  Selected(0) = 0
EndProcedure

Procedure DrawCell(Ev)
  If inmous(xGrid + 1, yGrid + 1, xGrid + wGrid - 2, yGrid + hGrid - 2)
    COLU = (MX - XGrid) / WCell + 1 : ROW = (MY - YGrid) / HCell + 1
    SEL = (ROW - 1 ) * NColumns + COLU
    If Ev = #WM_LBUTTONDOWN : ProcedureReturn SEL : EndIf
    If Selected(0) <> COLU Or Selected(1) <> ROW
      If Selected(0) : CleanCell(SELECTED(0), Selected(1)) : EndIf
      x = XGrid + (COLU - 1) * WCell + 1 : y = YGrid + ((ROW - 1) * HCell) + 1



      Box(x+1, y, WCell-2 , HCell-1 , #Green)
      DrawingMode(1)
      FrontColor(RGB(0, 0, 0))
      DrawingFont(SmallFont)
      gad$=textcell$(sel-1)
      minu=Len(gad$)
      While TextWidth(gad$)>(Wcell);-(TextLength("W")))
        minu-2
        gad$=Mid(textcell$(sel-1),1,minu)
      Wend
      If TextWidth(gad$)<>0
        Posicion=(WCell-TextWidth(gad$))/2
      Else
        Posicion=1
      EndIf

      DrawText(x+Posicion, y+1, textcell$(sel-1));+"..")
      ; Locate(x + 1, y+1) : DrawText(textcell$(SEL - 1))
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
  FrontColor(RGB(0, 0, 0))
  DrawingFont(SmallFont)
  For i = 0 To Ncells
    gad$=textcell$(i)
    minu=Len(gad$)
    While TextWidth(gad$)>(Wcell-(TextWidth("W")))
      minu-2
      gad$=Mid(textcell$(i),1,minu)
    Wend
    If TextWidth(gad$)<>0
      Posicion=(WCell-TextWidth(gad$))/2
    Else
      Posicion=2
    EndIf

    DrawText(xcell(i) + Posicion, ycell(i)+2, gad$);+"..") ;DrawText(textcell$(i))
  Next
  StopDrawing()
EndProcedure

;_X = GetSystemMetrics_(#SM_CXSCREEN) - 8 : _Y = GetSystemMetrics_(#SM_CYSCREEN) - 68
;hWnd = OpenWindow(0, 0, 0, _X, _Y, #WS_OVERLAPPEDWINDOW, "Grid")
hWnd =OpenWindow(0,0,0,600,400,"Nice bars",#PB_Window_TitleBar|#PB_Window_ScreenCentered|#PB_Window_SystemMenu)
AddKeyboardShortcut(0, #PB_Shortcut_Return, #Ret)
AddKeyboardShortcut(0, #PB_Shortcut_Escape, #ESC)
XGrid = 90 : YGrid = 100 ; grid position
NColumns = 7 : NRows = 7 ; number of rows & columns
WCell = 72 : HCell = 22 ; cell sizes
SmallFont = LoadFont(0, "Tahoma ", hcell/2)

NCells = NColumns * NRows
WGrid = WCell * NColumns + 1 : HGrid = HCell * NRows + 1
Dim TextCell$(Ncells)
Dim XCell.w(Ncells)
Dim YCell.w(Ncells)

For i = 0 To ncells
  If i > 0 And i % ncolumns = 0 : x = 0 : y + hcell : EndIf
  ;TextCell$(i) ="";"Manolo" ;Str(i + 1)
  Xcell(i) = x : ycell(i) = y
  x + wcell
Next

CreateGadgetList(hWnd)
TextGadget(#Txt, _x / 2, yGrid + hGrid + 10, 100, 40, "", #PB_Text_Center | #PB_Text_Border )
StringGadget(#Input, 0, 0, 0, 0, "",#PB_String_BorderLess )
XRGrid=XGrid
YRGrid=YGrid
Filas=1
Columnas=NColumns

separator(#SepaHori,XRGrid,YGrid-HCell,WCell,HCell,"Nombre",fontid,RGB($40,$40,$40),RGB($CC,$CC,$CC), Columnas, Filas)
Columnas=1
Filas=NRows

separator(#SepaVert,XGrid-WCell+1,YRGrid-HCell,WCell,HCell,"Nombre",fontid,RGB($40,$40,$40),RGB($CC,$CC,$CC), Columnas, Filas+1)

DrawGrid()



Repeat
  MX = WindowMouseX(0) ;- GetSystemMetrics_(#SM_CYSIZEFRAME)
  MY = WindowMouseY(0) ;- GetSystemMetrics_(#SM_CYCAPTION) - GetSystemMetrics_(#SM_CYSIZEFRAME)
  If #WM_LBUTTONDOWN : mk = 1 : Else : mk = 0 : EndIf
  Ev = WindowEvent()
  StartDrawing(WindowOutput(0))
  SEL = DrawCell(Ev)
  StopDrawing()
  If SEL
    If mk
      HideGadget(#input, 0)
      ;ResizeGadget(#Input, mx, my, 200, 20)

      ResizeGadget(#Input, x, y, WCell-1,HCell-1);modificada
      SetGadgetFont(#Input,LoadFont(#Input,"Tahoma ",hcell/2,0));implantada
      SetGadgetText(#Input,textcell$(sel - 1));Implantada

      Repeat
        SetActiveGadget(#Input)
        ev = WaitWindowEvent()
        t$ = GetGadgetText(#Input)
        If GetAsyncKeyState_(#VK_ESCAPE)=-32767
          t$=textcell$(sel-1)
          SetGadgetText(#Input,textcell$(sel-1))

          Break
        EndIf
        ; Debug TextLength(t$)
        ;If TextLength(t$+"W")>wcell :Break:EndIf   ; limit for text too long
      Until ev = #PB_Event_Menu And EventMenu() = #Ret
      textcell$(sel-1)=t$
      ;If Len(t$): textcell$(sel - 1) = t$ : EndIf
      ;StopDrawing()
      drawgrid()
      ;StartDrawing(WindowOutput(0))
      SetGadgetText(#input, "")
      ResizeGadget(#input, 0, 0, 0, 0)
    EndIf
    SetGadgetText(#Txt, "Selected " + Str(SEL)+s$+textcell$(sel-1))
    selected(0) = 0
  EndIf
  If Ev = #WM_PAINT
    StartDrawing(WindowOutput(0))
    DrawImage(Grid, xgrid, ygrid)
    StopDrawing()
  EndIf
Until Ev = #PB_Event_CloseWindow
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -