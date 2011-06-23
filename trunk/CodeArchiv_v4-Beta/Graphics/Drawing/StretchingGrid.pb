; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9263 
; Author: einander (updated for PB 4.00 by Andre + edel) 
; Date: 22. January 2004 
; OS: Windows 
; Demo: No 


; Problem: innerhalb der Event-Rountine wird zwar offensichtlich die Maus abgefragt, es passiert aber nichts... 


;Stretching grid by Einander  (updated Sizes() procedure included) 
;PB 3.81 - jan 22-2004 

Enumeration 
  #grid 
  #IMG 
EndEnumeration 

Global Xmin, Ymin, Xmax, Ymax 
Global _X, _Y, XX, YY, s$, MX, MY, MK, mxant, myant 
Global  Xpoints, Ypoints 

Global Dim Xgrid(0, 0) : Global Dim Ygrid(0, 0) : Global Dim Xstep.f(0) : Global Dim Ystep.f(0) 

_X = GetSystemMetrics_(#SM_CXSCREEN) - 8 : _Y = GetSystemMetrics_(#SM_CYSCREEN) - 68 
XX = _X / 2 : YY = _Y / 2 
Global Dim PX(3) : Global Dim PY(3) 

Procedure VarL(DIR, i) ; RET ELEM I DEL ARRAY CON DIRECCION DIR 
  ProcedureReturn PeekL(DIR + i * 4) ; VALE COMO REEMPLAZO PARA PASAR ARRAYS A PROCS 
EndProcedure 

Procedure Near(x, y, ArrSize, DIR1, DIR2) ; ; retorna indice del elem de LOS ARRAYS EN DIR1, DIR2 mas Near a x,y 
  MIN = $FFFF 
  For i = 0 To ArrSize 
    A = Sqr(Pow(x - VarL(DIR1, i), 2) + Pow(y - VarL(DIR2, i), 2)) 
    If A < MIN : MIN = A : IN = i: EndIf 
  Next i 
  ProcedureReturn IN 
EndProcedure 

Procedure.s LoadIMG() 
  Show$ = "c:\" 
  Pat$ = "BitMap (*.BMP)|*.bmp;*.bmp|Jpg (*.jpg)|*.bmp|All files (*.*)|*.*" 
  File$ = OpenFileRequester("Choose file to load", Show$, Pat$, 0) 
  If File$ 
    ProcedureReturn File$ 
  Else 
    End 
  EndIf 
EndProcedure 

Procedure MOU(Ev) 
  Select Ev 
    Case #WM_LBUTTONDOWN 
      If MK = 2 : MK = 3 : Else : MK = 1 : EndIf 
    Case #WM_LBUTTONUP 
      If MK = 3 : MK = 2 : Else : MK = 0 : EndIf 
    Case #WM_RBUTTONDOWN 
      If MK = 1 : MK = 3 : Else : MK = 2 : EndIf 
    Case #WM_RBUTTONUP 
      If MK = 3 : MK = 1 : Else : MK = 0 : EndIf 
    Case #WM_MOUSEMOVE 
      MX = WindowMouseX(0) - GetSystemMetrics_(#SM_CYSIZEFRAME) 
      MY = WindowMouseY(0) - GetSystemMetrics_(#SM_CYCAPTION) - GetSystemMetrics_(#SM_CYSIZEFRAME) 
  EndSelect 
EndProcedure 

Procedure Sizes() 
  Xmax = 0 : Xmin = _X : Ymax = 0 : Ymin = _Y 
  For i = 0 To 3 
    x = PX(i) : y = PY(i) 
    If x < Xmin : Xmin = x : EndIf 
    If x > Xmax : Xmax = x : EndIf 
    If y < Ymin : Ymin = y : EndIf 
    If y > Ymax : Ymax = y : EndIf 
  Next 
  
  Xstep(0) = (PX(1) - PX(0)) / Xpoints ; step X horiz sup 
  Ystep(0) = (PY(1)-PY(0)) / Xpoints ; step Y HOR SUP 
  
  Xstep(1) = (PX(2) - PX(3)) / Xpoints ; stepX HOR INF 
  Ystep(1) = (PY(2)-PY(3)) / Xpoints ; step Y HOR INF 
  
  Xstep(2) = (PX(3) - PX(0)) / Ypoints ; step X VER IZQ 
  Ystep(2) = (PY(3)-PY(0)) / Ypoints ; step Y VER IZQ 
  
  Xstep(3) = (PX(2) - PX(1)) / Ypoints ; step X VER DER 
  Ystep(3) = (PY(2)-PY(1)) / Ypoints ; step Y VER DER 
  
  DXstep1.f=(Xstep(1)-Xstep(0))/Ypoints  ; para calcular posic horiz de cruces internos 
  DpX1.f=(PX(3)-PX(0))/Ypoints 
  DXstep2.f=(Ystep(1)-Ystep(0))/Ypoints 
  DpX2.f=(PY(3)-PY(0))/Ypoints 
  
  For j=0 To Ypoints 
    For i = 0 To Xpoints  ; posic x  para verticales 
      Xgrid(i, j) = (Xstep(0)+DXstep1*j)*i+PX(0)+DpX1*j : Ygrid(i, j) = (Ystep(0)+DXstep2*j)*i+PY(0)+DpX2*j 
    Next 
  Next 
  
  DYstep1.f=(Xstep(3)-Xstep(2))/Xpoints  ; para calcular posic vert de cruces internos 
  DpY1.f=(PX(1)-PX(0))/Xpoints 
  DYstep2.f=(Ystep(3)-Ystep(2))/Xpoints 
  DpY2.f=(PY(1)-PY(0))/Xpoints 
  
  For j = 1 To Xpoints 
    For i = 1 To Ypoints  ; posic Y  para horizontales 
      Xgrid( j,i) = (Xstep(2)+DYstep1*j)*i+PX(0)+DpY1*j  :  Ygrid( j,i) = (Ystep(2)+DYstep2*j)*i+PY(0)+DpY2*j 
    Next 
  Next 
EndProcedure ; _______________________________ 

Procedure ShowGrid() 
  hIMG = CreateImage(#IMG, _X,_Y) 
  StartDrawing (ImageOutput(#IMG)) 
  DrawingMode(4) 
  BackColor(RGB(0,0,0)) 
  
  For i = 0 To 3 
    Circle (PX(i) , PY(i) , 8,#Yellow) 
    DrawText(PX(i) + 10, PY(i), Str(i)) 
  Next 
  Box(Xmin, Ymin, Xmax-Xmin, Ymax-Ymin, #Blue) 
  
  For i = 0 To Xpoints ; vertical lines 
    LineXY(Xgrid( i, 0), Ygrid( i, 0), Xgrid(i, Ypoints ), Ygrid(i, Ypoints ),  #Green) 
  Next 
  
  For i = 0 To Ypoints ;horizontal lines 
    LineXY(Xgrid(0,i), Ygrid(  0,i), Xgrid( Xpoints,i ), Ygrid( Xpoints,i ),  #Magenta) 
  Next 
  
  StopDrawing() 
  StartDrawing(WindowOutput(0)) 
  SetGadgetState(#grid, ImageID(#IMG)) 
  StopDrawing() 
EndProcedure 
; ____________________________________________________________________________________________________ 

OpenWindow(0, 0, 0, _X, _Y, "", #WS_OVERLAPPEDWINDOW | #WS_MAXIMIZE) 
CreateGadgetList(WindowID(0)) 
ImageGadget(#grid,0,0,0,0,0) 

DisableGadget(#grid,#True) 

Xpoints = 28 : Ypoints = 14; Here you can choose how many grid lines********************************* 
Dim Xgrid (Xpoints , Ypoints ) 
Dim Ygrid (Xpoints , Ypoints ) 
Dim Xstep.f(3 ) : Dim Ystep.f(3 ) 

PX(0) = _X / 2-100 : PY(0) = _Y / 2-100 : PX(1) = PX(0) + 200 : PY(1) = PY(0) 
PX(2) = PX(1) : PY(2) = PY(1) + 200 : PX(3) = PX(0) : PY(3) = PY(2) 

Sizes() 
ShowGrid() 

Repeat 
  Ev = WaitWindowEvent(10) 
  
  MOU(Ev) 
  
  If MX <> mxant Or MY <> myant Or MK <> mkant 
    If sel=0 :   C = Near(MX, MY, 3, @PX(), @PY()):sel=1:EndIf 
    If MK = 1 
      PX(C) = MX : PY(C) = MY 
      Sizes() 
      ShowGrid() 
    Else 
      sel=0 
    EndIf 
  EndIf 
  mxant = MX : myant = MY : mkant = MK 
Until Ev = #PB_Event_CloseWindow 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; DisableDebugger