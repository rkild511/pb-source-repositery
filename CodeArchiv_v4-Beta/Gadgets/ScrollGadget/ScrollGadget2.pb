; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8741&highlight=
; Author: freedimension (updated for PB4.00 by blbltheworm)
; Date: 29. January 2003
; OS: Windows
; Demo: No

; ######################################################################################################## 
; ScrollGadget by freedimension based on the work by freak (January 2003) 
; ######################################################################################################## 


; ######################################################################################################## 
;- ENGLISH Manual 
; First of all I want to thank "Freak" for his superb code-pattern, on which this work is based. 
; 
; The ScrollGadget can be used like any other Gadget except that it has its own GadgetID 
; that does not interfere with the IDs of other Gadgets. 
; One of his strengths is the possibility to place other Gadgets (even ScrollGadgets) inside 
; the ScrollGadget. To do so, just create the Gadgets after the creation of the ScrollGadget. 
; After all Gadgets are placed in the ScrollGadget you have to Close it with the 
; CloseScrollGadget() Command. All Gadgets created afterwards are placed outside of the ScrollGadget. 

; CreateScrollGadget(Scroll_ID, x, y, Width, Height, SizeX, SizeY, Flags, WindowID) 
; --------------------------------------------------------------------------------- 
; Scroll_ID     : The User defined ID of the ScrollGadget (to be used with SetScrollGadget() ) 
; x, y          : The Position on the Parent-Window 
; Width, Height : The Dimensions of the ScrollGadgets (including ScrollBars and Borders) 
; SizeX, SizeY  : The Dimensions of the scrollable ClientArea of the Gadget 
; Flags         : Here you can characterize the look of the ScrollGadget 
; WindowID      : The Window Handle of the Parent-Window (to which the ScrollGadget should belong) 

; Options for the Flags-Parameter: 
;   #ScrollBar_NoScrollH   : In no case a horizontal ScrollBar will be displayed 
;   #ScrollBar_NoScrollV   :    -"-       vertical            -"- 
;   #ScrollBar_Border      : Gives the ScrollArea a thin (2D) Border 
;   #ScrollBar_ThickBorder :        -"-           a thick 3D-Border 
;   #ScrollBar_Left        : The vertical ScrollBar will be displayed on the left Side 
;   #ScrollBar_Top         : The horizontal ScrollBar will be displayed on the Top 
; --------------------------------------------------------------------------------- 

; SetScrollGadget(Scroll_ID, X, Y, Width, Height, ClientW, ClientH) 
; ----------------------------------------------------------------- 
; Scroll_ID     : The User defined ID of the ScrollGadget (defined on creation) 
; X, Y          : The new Position on the Parent-Window * 
; Width, Height : The new Dimensions of the ScrollGadget * 
; SizeX, SizeY  : The new Dimensions of the ClientArea * 
; 
; * Old Values can be taken on by setting the Parameter to -1 
; ----------------------------------------------------------------- 

; CloseScrollGadget() 
; ------------------- 
; This Function has to be called to finish the creation of the ScrollGadget. 
; Gadgets created in between are placed inside of the ScrollGadget. 
; ------------------- 
; ######################################################################################################## 


; ######################################################################################################## 
;- DEUTSCHE Anleitung 
; Zu allererst möchte ich "Freak" danken für sein hervorragendes Code-Beispiel auf welchem ich 
; diesen Code aufgebaut habe. 
; 
; Das ScrollGadget wird wie jedes andere Gadget auch benutzt, es hat benutzt jedoch eine eigene 
; GadgetID so das es hier nicht zu Überschneidungen mit den IDs anderer Gadgets kommen kann. 
; Eine der Stärken der ScrollGadgets ist die Möglichkeit, weitere Gadgets (sogar ScrollGadgets 
; sind möglich) innerhalb des ScrollGadgets zu platzieren. Dazu müssen nur diese Gadgets nach dem 
; Erzeugen des ScrollGadgets erzeugt werden. Sind sämtliche Gadgets innerhalb des ScrollGadgets 
; erstellt, muß das ScrollGadget mittels CloseScrollGadget() geschlossen werden. Alle Gadgets welche 
; danach erzeugt wurden, werden ausserhalb des ScrollGadgets platziert. 

; CreateScrollGadget(Scroll_ID, x, y, Width, Height, SizeX, SizeY, Flags, WindowID) 
; --------------------------------------------------------------------------------- 
; Scroll_ID     : Die Benutzerdefinierte ID des ScrollGadget (wird zusammen mit SetScrollGadget() benutzt) 
; x, y          : Die Position des übergeordneten Fensters 
; Width, Height : Höhe und Breite des ScrollGadgets (dies schließt die Bildlaufleisten und Rahmen mit ein) 
; SizeX, SizeY  : Die Höhe und Breite des scrollbaren Bereichs. 
; Flags         : Einige Optionen zum Steuern des Aussehens des ScrollGadgets (s.u.) 
; WindowID      : Das Handle des Fensters in welchem das ScrollGadgets erstellt werden soll 

; Options for the Flags-Parameter: 
;   #ScrollBar_NoScrollH   : Eine horizontale Bildlaufleiste wird auf keinen Fall dargestellt 
;   #ScrollBar_NoScrollV   : Eine vertikale                    -"- 
;   #ScrollBar_Border      : Gibt dem scrollbaren Bereich eine dünne (2D) Begrenzungslinie 
;   #ScrollBar_ThickBorder :               -"-            einen dicken 3D-Rahmen 
;   #ScrollBar_Left        : Die vertikale Bildlaufleiste wird auf der linken Seite dargestellt 
;   #ScrollBar_Top         : Die horizontale Bildlaufleiste wird oberhalb des scrollbaren Bereichs 
;                            dargestellt 
; --------------------------------------------------------------------------------- 

; SetScrollGadget(Scroll_ID, X, Y, Width, Height, ClientW, ClientH) 
; ----------------------------------------------------------------- 
; Scroll_ID     : Die benutzerdefinierte ID des ScrollGadget (welche bei der Erzeugung angegeben wurde) 
; X, Y          : Die neue Position auf dem übergeordneten Fenster * 
; Width, Height : Die neue Höhe und Breite des ScrollGadgets * 
; SizeX, SizeY  : Die neue Höhe und Breite des scrollbaren Bereichs * 
; 
; * Die alten Werte können übernommen werden wenn hier jeweils -1 übergeben wird 
; ----------------------------------------------------------------- 

; CloseScrollGadget() 
; ------------------- 
; Diese Funktion muss aufgerufen werden um die Erstellung des ScrollGadgets abzuschließen. 
; Gadgets welche zwischen der Erzeugung und dem Abschluß erzeugt wurden, werden innerhalb 
; des ScrollGadgets dargestellt. 
; ------------------- 
; ######################################################################################################## 


; ######################################################################################################## 
;- ScrollInfo2 
Structure ScrollInfo2 
;##### Fixed Data ##### 
  *Previous.l 
  Scroll_ID.l 
  ;Window Handles 
  hEnv.l   ; Envelope Window 
  hPB.l       ; Window 
  hWindow.l 
  hScrollV.l 
  hScrollH.l 
  ;Flags for the Look and Feel of the ScrollGadget 
  Flags.l 

;##### Variable Data ##### 
  ;Position of the ScrollGadget on Parent Window 
  X.l 
  Y.l 

  ;Size of the ScrollGadget (including the ScrollBars and Borders) 
  Width.l 
  Height.l 
  
  ;Position of the ClientArea in Envelope Window 
  PosX.l 
  PosY.l 

  ;Minimum Size of ClientArea 
  ClientW.l 
  ClientH.l 
  ;Actual Size of ClientArea (May differ when PageSize < [GadgetSize - ScrollBars - Borders] ) 
  SizeX.l 
  SizeY.l 
  
  ;Size of the visible Part of ClientArea 
  VisW.l 
  VisH.l 
EndStructure 
Global NewList ScrollGadgets.ScrollInfo2() 
; ######################################################################################################## 


; ######################################################################################################## 
; Some more declarations (constants and forward-declaration of functions) 
Declare CreateScrollGadget(Scroll_ID, X, Y, Width, Height, SizeX, SizeY, Flags, WindowID) 
Declare SetScrollGadget(Scroll_ID, X, Y, Width, Height, ClientW, ClientH) 
Declare CloseScrollGadget() 
Declare WindowCallback(WindowID, Message, wParam, lParam) 

;- constants 
#Null=0 
#False=0 
#True=1    ; <-- do not touch this, it took me a whole day to figure out that a bug was caused 
           ;     by this constant being set to 0 ;-) 

#ScrollBar_NoScrollH   =  1 
#ScrollBar_NoScrollV   =  2 
#ScrollBar_Border      =  4 
#ScrollBar_ThickBorder =  8 
#ScrollBar_Left        = 16 
#ScrollBar_Top         = 32 
; ######################################################################################################## 


; ######################################################################################################## 
;- Example Application 
If OpenWindow(0, 0, 0, 500, 500, "Scrollbar Example", #PB_Window_SystemMenu|#PB_Window_SizeGadget) = 0    ; Fenster erstellen 
  MessageRequester("","Windowerror!",0) 
  End 
EndIf 

CreateGadgetList(WindowID(0)) 

sbHnd.l = CreateScrollGadget(2, 10, 10, 200, WindowHeight(0)-20, 1000, 1200, #ScrollBar_Border |#ScrollBar_Top, WindowID(0) ) 
  For i=0 To 10 
    ButtonGadget(i, i * 30, i * 55, 400, 40, "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 1 2 3 4 5 6 7 8 9 0") 
  Next i 
  CreateScrollGadget(3, 5, 500, 200, 200, 400, 400, #ScrollBar_ThickBorder, sbHnd) 
    ButtonGadget(12, 0, 0, 400, 400, "Can You See This Button? If not, you have To scroll!") 
  CloseScrollGadget() 
CloseScrollGadget() 

ButtonGadget(3, 240, 10, 100, 25, "not Scrolled") 

i=200 
Repeat 
  Event = WaitWindowEvent() 
  If Event = #PB_Event_Gadget 
    i=i-1 
    SetScrollGadget(1, -1, -1, 200, i, -1, -1) 
  EndIf 
Until Event = #PB_Event_CloseWindow 
End 
; ######################################################################################################## 


; ######################################################################################################## 
;- ScrollGadget-Procedures 
Procedure CreateScrollGadget(Scroll_ID, X, Y, Width, Height, ClientW, ClientH, Flags, WindowID) 
  Protected WinFlag.l, Previous.l 

  If Flags & #ScrollBar_Border 
    WinFlag = #WS_CHILD | #WS_VISIBLE | #WS_BORDER 
  ElseIf Flags & #ScrollBar_ThickBorder 
    WinFlag = #WS_CHILD | #WS_VISIBLE | #WS_THICKFRAME 
  Else 
    WinFlag = #WS_CHILD | #WS_VISIBLE 
  EndIf 

  ;Generating new listentry 
  AddElement(ScrollGadgets()) 
  Previous = @ScrollGadgets() 

;###### STORING THE RAWDATA ###### 
  ;Userdefined ID 
  ScrollGadgets()\Scroll_ID = Scroll_ID 
  ;Pointer to Previous ScrollGadget in list 
  ScrollGadgets()\Previous = Previous 
  ;Gadget Data 
  ScrollGadgets()\X = X :  ScrollGadgets()\Y = Y 
  ScrollGadgets()\Width = Width :  ScrollGadgets()\Height = Height 
  ScrollGadgets()\Flags = Flags 

  ;Client Data 
  ScrollGadgets()\PosX = 1 :  ScrollGadgets()\PosY = 1 
  ScrollGadgets()\ClientW = ClientW :  ScrollGadgets()\ClientH = ClientH 

;###### CREATING THE WINDOWS ###### 
  ;Parent-Window 
  ScrollGadgets()\hPB = WindowID 
  ;Envelope-Window 
  ScrollGadgets()\hEnv = CreateWindowEx_(0, "Static", "", WinFlag, 0, 0, 0, 0, WindowID, 0, GetModuleHandle_(0), 0) 
  ;Client-Area 
  ScrollGadgets()\hWindow = CreateWindowEx_(0, "Static", "", #WS_CHILD | #WS_VISIBLE, 0, 0, 0, 0, ScrollGadgets()\hEnv, 0, GetModuleHandle_(0), 0) 
  ;ScrollBars 
  ScrollGadgets()\hScrollV = CreateWindowEx_(0, "ScrollBar", "", #WS_CHILD | #WS_VISIBLE | #SBS_VERT | #SBS_LEFTALIGN, 0, 0, 0, 0, WindowID, 0, GetModuleHandle_(0), 0)    
  ScrollGadgets()\hScrollH = CreateWindowEx_(0, "ScrollBar", "", #WS_CHILD | #WS_VISIBLE | #SBS_HORZ | #SBS_TOPALIGN,  0, 0, 0, 0, WindowID, 0, GetModuleHandle_(0), 0) 
  
  SetScrollGadget(Scroll_ID, -1, -1, -1, -1, -1, -1) 

  CreateGadgetList(ScrollGadgets()\hWindow) 
  SetWindowCallback(@WindowCallback()) 
  SetWindowLong_(ScrollGadgets()\hWindow, #GWL_WNDPROC, GetWindowLong_(WindowID(0), #GWL_WNDPROC)) 

  ProcedureReturn ScrollGadgets()\hWindow 
EndProcedure 

Procedure SetScrollGadget(Scroll_ID, X, Y, Width, Height, ClientW, ClientH) 

  Protected Flags.l, WinFlag.l, BorderW.l, BorderH.l, ScrollBarW.l, ScrollBarH.l 
  Protected WEnvW.l, XEnvW.l, HEnvW.l, YEnvW.l, YScr.l, XScr.l, params.SCROLLINFO 

  ;Retrieving the Gadget with the right ID 
  ResetList(ScrollGadgets()) 
  Repeat 
    ne = NextElement(ScrollGadgets()) 
    If ne = #Null 
      ProcedureReturn #False 
    EndIf 
  Until (ScrollGadgets()\Scroll_ID = Scroll_ID) 

  ScrollBarW = GetSystemMetrics_(#SM_CXVSCROLL) : ScrollBarH = GetSystemMetrics_(#SM_CYVSCROLL) 
  
  Flags = ScrollGadgets()\Flags 
  
  If Flags & #ScrollBar_Border 
    WinFlag = #WS_CHILD | #WS_VISIBLE | #WS_BORDER 
    BorderW = GetSystemMetrics_(#SM_CXBORDER) : BorderH = GetSystemMetrics_(#SM_CYBORDER) 
  ElseIf Flags & #ScrollBar_ThickBorder 
    WinFlag = #WS_CHILD | #WS_VISIBLE | #WS_THICKFRAME 
    BorderW = GetSystemMetrics_(#SM_CXFIXEDFRAME) : BorderH = GetSystemMetrics_(#SM_CYFIXEDFRAME) 
  Else 
    WinFlag = #WS_CHILD | #WS_VISIBLE 
    BorderW = 0 : BorderH = 0 
  EndIf 

  ; Check if the dimensions have changed 
  If X <> -1 : ScrollGadgets()\X = X : Else : X = ScrollGadgets()\X : EndIf 
  If Y <> -1 : ScrollGadgets()\Y = Y : Else : Y = ScrollGadgets()\Y : EndIf 
  If ClientW <> -1 : ScrollGadgets()\ClientW = ClientW : Else : ClientW = ScrollGadgets()\ClientW : EndIf 
  If ClientH <> -1 : ScrollGadgets()\ClientH = ClientH : Else : ClientH = ScrollGadgets()\ClientH : EndIf 
  If Width <>-1 : ScrollGadgets()\Width  = Width  : Else : Width  = ScrollGadgets()\Width  : EndIf 
  If Height<>-1 : ScrollGadgets()\Height = Height : Else : Height = ScrollGadgets()\Height : EndIf 


  If(ClientW > (Width - (2 * BorderW))) And (Flags & #ScrollBar_NoScrollH = 0) : sbHActive.b = #True : Else : sbHActive.b = #False : EndIf 
  If(ClientH > (Height - (2 * BorderH))) And (Flags & #ScrollBar_NoScrollV = 0) : sbVActive.b = #True : Else : sbVActive.b = #False : EndIf 
  If(sbHActive) And (Flags & #ScrollBar_NoScrollV = 0) 
    If(ClientH > (Height - (2 * BorderH) ) - ScrollBarH) : sbVActive = #True : Else : sbVActive = #False : EndIf 
  EndIf 
  If(sbVActive) And (Flags & #ScrollBar_NoScrollH = 0) 
    If(ClientW > (Width - (2 * BorderW) ) - ScrollBarW) : sbHActive = #True : Else : sbHActive = #False : EndIf 
  EndIf 
  If sbVActive 
    If(Flags & #ScrollBar_Left)>0 : XEnvW = X + ScrollBarW : XScr = X : Else : XEnvW = X : XScr = X + Width - ScrollBarW : EndIf 
    WEnvW = Width - ScrollBarW 
  Else : XEnvW = X : XScr = X : WEnvW = Width : EndIf 
  If sbHActive 
    If(Flags & #ScrollBar_Top)>0 : YEnvW = Y + ScrollBarH : YScr = Y : Else : YEnvW = Y : YScr = Y + Height - ScrollBarH : EndIf 
    HEnvW = Height - ScrollBarH 
  Else : YEnvW = Y : YScr = Y : HEnvW = Height : EndIf 
  ScrollGadgets()\VisW = WEnvW - 2*BorderW : ScrollGadgets()\VisH = HEnvW - 2*BorderH 
  
  If (ClientW < (Width - 2*BorderW - (sbVActive*ScrollBarW) ) ) 
    ScrollGadgets()\SizeX = Width - 2*BorderW - (sbVActive*ScrollBarW) 
  Else : ScrollGadgets()\SizeX = ClientW : EndIf 
  If (ClientH < (Height - 2*BorderH - (sbHActive*ScrollBarH) ) ) 
    ScrollGadgets()\SizeY = Height - 2*BorderH - (sbHActive*ScrollBarH) 
  Else : ScrollGadgets()\SizeY = ClientH : EndIf 

  params\cbSize = SizeOf(SCROLLINFO) 
  params\fMask = #SIF_DISABLENOSCROLL | #SIF_PAGE | #SIF_POS | #SIF_RANGE 
  params\nMin = 0 
  params\nMax = ClientW 
  params\nPage = ScrollGadgets()\VisW 
  params\nPos = -ScrollGadgets()\PosX 
  SendMessage_(ScrollGadgets()\hScrollH, #SBM_SETSCROLLINFO, #True, @params) 

  params\cbSize = SizeOf(SCROLLINFO) 
  params\fMask = #SIF_DISABLENOSCROLL | #SIF_PAGE | #SIF_POS | #SIF_RANGE 
  params\nMin = 0 
  params\nMax = ClientH 
  params\nPage = ScrollGadgets()\VisH 
  params\nPos = -ScrollGadgets()\PosY 
  SendMessage_(ScrollGadgets()\hScrollV, #SBM_SETSCROLLINFO, #True, @params) 

  SetWindowPos_(ScrollGadgets()\hEnv, 0, XEnvW, YEnvW, WEnvW, HEnvW, #SWP_NOACTIVATE | #SWP_NOOWNERZORDER | #SWP_NOZORDER | #SWP_SHOWWINDOW) 
  SetWindowPos_(ScrollGadgets()\hWindow, 0, ScrollGadgets()\PosX, ScrollGadgets()\PosY, ScrollGadgets()\SizeX, ScrollGadgets()\SizeY, #SWP_NOACTIVATE | #SWP_NOOWNERZORDER | #SWP_NOZORDER | #SWP_SHOWWINDOW) 

  If(sbVActive) 
    Debug "hallo" 
    SetWindowPos_(ScrollGadgets()\hScrollV, #Null, XScr, YEnvW, ScrollBarW, HEnvW, #SWP_NOACTIVATE | #SWP_NOOWNERZORDER | #SWP_NOZORDER | #SWP_SHOWWINDOW) 
  Else 
    SetWindowPos_(ScrollGadgets()\hScrollV, #Null, XScr, YEnvW, ScrollBarW, HEnvW, #SWP_NOACTIVATE | #SWP_NOOWNERZORDER | #SWP_NOZORDER | #SWP_HIDEWINDOW) 
  EndIf 
  If(sbHActive) 
    SetWindowPos_(ScrollGadgets()\hScrollH, #Null, XEnvW, YScr, WEnvW, ScrollBarH, #SWP_NOACTIVATE | #SWP_NOOWNERZORDER | #SWP_NOZORDER | #SWP_SHOWWINDOW) 
  Else 
    SetWindowPos_(ScrollGadgets()\hScrollH, #Null, XEnvW, YScr, WEnvW, ScrollBarH, #SWP_NOACTIVATE | #SWP_NOOWNERZORDER | #SWP_NOZORDER | #SWP_HIDEWINDOW) 
  EndIf 
  ProcedureReturn ScrollGadgets()\hWindow 
EndProcedure 

Procedure CloseScrollGadget() 
  Protected *pointer.l 
  UseGadgetList(ScrollGadgets()\hPB) 
  *pointer = @ScrollGadgets()\Previous 
  ChangeCurrentElement(ScrollGadgets(), *pointer) 
EndProcedure 
; ######################################################################################################## 

; ######################################################################################################## 
; Die folgenden Ereignisbehandlungsroutinen müssen in ihre eigene WindowCallback-Funktion eingebaut werden 
Procedure WindowCallback(WindowID, Message, wParam, lParam) 
  Result = #PB_ProcessPureBasicEvents 
  Select Message 
    Case #WM_SIZE 
;      If(WindowID = ScrollGadgets()\hPB) 
        SetScrollGadget(2, -1, -1, -1, WindowHeight(0)-20, -1, -1) 
;     EndIf 
    Case #WM_HSCROLL 
      If lParam <> #Null 
        ResetList(ScrollGadgets()) 
        Repeat 
          ne = NextElement(ScrollGadgets()) 
        Until (ScrollGadgets()\hScrollH = lParam) Or (ne = #False) 
        wLow = PeekW(@wParam) 
        wHi  = PeekW(@wParam+2) - 1 
        Select wLow 
          Case #SB_LINELEFT: ScrollGadgets()\PosX + 10 
              If(ScrollGadgets()\PosX > 0) : ScrollGadgets()\PosX = 1 : EndIf 
          Case #SB_LINERIGHT: ScrollGadgets()\PosX - 10 
              If(ScrollGadgets()\PosX < (-(ScrollGadgets()\SizeX - ScrollGadgets()\VisW) ) ) 
                ScrollGadgets()\PosX = - (ScrollGadgets()\SizeX - ScrollGadgets()\VisW) 
              EndIf 
          Case #SB_PAGELEFT: ScrollGadgets()\PosX + ScrollGadgets()\Width 
              If(ScrollGadgets()\PosX > 0) : ScrollGadgets()\PosX = 1 : EndIf 
          Case #SB_PAGERIGHT: ScrollGadgets()\PosX - ScrollGadgets()\Width 
              If(ScrollGadgets()\PosX < (-(ScrollGadgets()\SizeX - ScrollGadgets()\VisW) ) ) 
                ScrollGadgets()\PosX = - (ScrollGadgets()\SizeX - ScrollGadgets()\VisW) 
              EndIf 
          Case #SB_THUMBPOSITION : ScrollGadgets()\PosX = -wHi 
          Case #SB_THUMBTRACK : ScrollGadgets()\PosX = -wHi 
        EndSelect 
        SetWindowPos_(ScrollGadgets()\hWindow, 0, ScrollGadgets()\PosX, ScrollGadgets()\PosY, 0, 0, #SWP_NOACTIVATE | #SWP_NOOWNERZORDER | #SWP_NOSIZE | #SWP_NOZORDER | #SWP_SHOWWINDOW)          
        SetScrollPos_(ScrollGadgets()\hScrollH, #SB_CTL, -ScrollGadgets()\PosX, #True) 
        result = 0 
      EndIf 

    Case #WM_VSCROLL 
      If lParam <> #Null 
        ResetList(ScrollGadgets()) 
        Repeat: ne = NextElement(ScrollGadgets()) 
        Until ScrollGadgets()\hScrollV = lParam Or ne = #False 
        wLow = PeekW(@wParam) 
        wHi  = PeekW(@wParam+2) - 1 
        Select wLow 
          Case #SB_LINEUP 
            ScrollGadgets()\PosY + 10 
            If(ScrollGadgets()\PosY > 0) : ScrollGadgets()\PosY = 1 : EndIf 
          Case #SB_LINEDOWN 
            ScrollGadgets()\PosY - 10 
            If(ScrollGadgets()\PosY < (-(ScrollGadgets()\SizeY - ScrollGadgets()\VisH) ) ) 
              ScrollGadgets()\PosY = - (ScrollGadgets()\SizeY - ScrollGadgets()\VisH) 
            EndIf 
          Case #SB_PAGEUP 
            ScrollGadgets()\PosY + ScrollGadgets()\Height 
            If(ScrollGadgets()\PosY > 0) : ScrollGadgets()\PosY = 1 : EndIf 
          Case #SB_PAGEDOWN 
            ScrollGadgets()\PosY - ScrollGadgets()\Height 
            If(ScrollGadgets()\PosY < (-(ScrollGadgets()\SizeY - ScrollGadgets()\VisH) ) ) 
              ScrollGadgets()\PosY = - (ScrollGadgets()\SizeY - ScrollGadgets()\VisH) 
            EndIf 
          Case #SB_THUMBPOSITION : ScrollGadgets()\PosY = -wHi 
          Case #SB_THUMBTRACK : ScrollGadgets()\PosY = -wHi 
        EndSelect 
        SetWindowPos_(ScrollGadgets()\hWindow, 0, ScrollGadgets()\PosX, ScrollGadgets()\PosY, 0, 0, #SWP_NOACTIVATE | #SWP_NOOWNERZORDER | #SWP_NOSIZE | #SWP_NOZORDER | #SWP_SHOWWINDOW) 
        SetScrollPos_(ScrollGadgets()\hScrollV, #SB_CTL, -ScrollGadgets()\PosY, #True) 
        result = 0 
      EndIf 
  EndSelect 
  ProcedureReturn Result 
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
