; German forum: http://www.purebasic.fr/german/viewtopic.php?t=11206
; Author: Fluid Byte
; Date: 17. December 2006
; OS: Windows
; Demo: No


; Background information:
; The tree view control does not support an owner drawn control - not yet. 
; This makes it somewhat difficult to display an image as a background. 
; The basic approach is to let the control draw in a memory device context, 
; draw this transparently over the background image and then draw the final 
; image onto the control client area. 

; Deshalb hat diesen Variante einen Nachteil. Dieser bestehet darin, dass man 
; keine geglättete Schrift benutzen kann bzw. sollte. Da die Farbe Weiss bzw. 
; die momentane Fenster Hintergrundfarbe als transparente Farbe dient und bei 
; geglätteter Schrift aber einige Pixel in ihren RGB Werten verändert werden 
; bleiben beim 'maskieren' Fragmente übrig. 


Import "msimg32.lib" 
   TransparentBlt(hdcDest,nXOriginDest,nYOriginDest,nWidthDest,hHeightDest,hdcSrc,nXOriginSrc,nYOriginSrc,nWidthSrc,nHeightSrc,crTransparent) 
EndImport 

Global lpPrevFunc.l 
Global bPainting.b 

CreateImage(0,10,290) 

StartDrawing(ImageOutput(0)) 
For i=0 To 289 
   CV = i*140/289 
   Box(0,i,10,1,RGB(255,255-CV,0))    
Next 
StopDrawing() 

Procedure TreeViewProc(hWnd.l,uMsg.l,wParam.l,lParam.l) 
   Select uMsg 
      Case #WM_PAINT 
      If bPainting = #False 
         bPainting = #True 
          
         GetClientRect_(hWnd,wrc.RECT) 
          
         BeginPaint_(hWnd,ps.PAINTSTRUCT) 
          
         hDC = GetDC_(hWnd) 
          
         hbmTemp = CreateCompatibleBitmap_(hDC,wrc\right,wrc\bottom) 
          
         hdcMem = CreateCompatibleDC_(hDC) 
         hbmOld = SelectObject_(hdcMem,hbmTemp) 
          
         SendMessage_(hWnd,#WM_PAINT,hdcMem,0) 
          
         hBrushBack = CreatePatternBrush_(ImageID(0)) 
         hBrushOld = SelectObject_(hDC,hBrushBack)          
         SetRect_(trc.RECT,0,0,wrc\right,wrc\bottom)       
         FillRect_(hDC,trc,hBrushBack)          
         SelectObject_(hDC,hBrushOld) 
         DeleteObject_(hBrushBack) 
          
         TransparentBlt(hDC,0,0,wrc\right,wrc\bottom,hdcMem,0,0,wrc\right,wrc\bottom,GetSysColor_(#COLOR_WINDOW)) 
          
         SelectObject_(hdcMem,hbmOld)          
         DeleteObject_(hbmTemp)          
         DeleteDC_(hdcMem) 
         ReleaseDC_(hWnd,hDC) 
          
         EndPaint_(hWnd,ps) 
          
         bPainting = #False 
          
         ProcedureReturn 0          
      Else 
         ProcedureReturn CallWindowProc_(lpPrevFunc,hWnd,uMsg,wParam,lParam) 
      EndIf 
       
      Case #WM_ERASEBKGND 
       
      ProcedureReturn #True 
       
      Case #WM_HSCROLL, #WM_VSCROLL, #WM_MOUSEWHEEL 
    
      InvalidateRect_(hWnd,0,0) 

      ProcedureReturn CallWindowProc_(lpPrevFunc,hWnd,uMsg,wParam,lParam) 
       
      Case #WM_DESTROY 
      SetWindowLong_(hWnd,#GWL_WNDPROC,lpPrevFunc) 
       
      ProcedureReturn CallWindowProc_(lpPrevFunc,hWnd,uMsg,wParam,lParam) 
       
      Default 
      ProcedureReturn CallWindowProc_(lpPrevFunc,hWnd,uMsg,wParam,lParam)       
   EndSelect 
EndProcedure 

; ---------------------------------------------------------- 

OpenWindow(0,0,0,400,300,"TreeView BG Image Demo",#WS_OVERLAPPEDWINDOW | #WS_VISIBLE | 1) 

CreateGadgetList(WindowID(0)) 

*hwndTreeView = TreeGadget(0,5,5,390,290) 

SetGadgetColor(0,#PB_Gadget_LineColor,$505050) 

GetObject_(SendMessage_(*hwndTreeView,#WM_GETFONT,0,0),SizeOf(LOGFONT),lplf.LOGFONT) 
lplf\lfQuality = 3 
hFntTree = CreateFontIndirect_(lplf) 

SendMessage_(*hwndTreeView,#WM_SETFONT,hFntTree,0) 

For i=1 To 30 
   AddGadgetItem(0,-1,"Untitled Item #" + Str(i),0,Random(1)) 
   SetGadgetState(0,i-1) 
Next 

SetGadgetState(0,0) 

lpPrevFunc = SetWindowLong_(*hwndTreeView,#GWL_WNDPROC,@TreeViewProc()) 

HideWindow(0,0) 

; ---------------------------------------------------------- 

Repeat 
   EventID = WaitWindowEvent() 

   If EventID = #PB_Event_SizeWindow 
      ResizeGadget(0,5,5,WindowWidth(0)-10,WindowHeight(0)-10) 
   EndIf 
Until EventID = 16 

DeleteObject_(hFntTree)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP