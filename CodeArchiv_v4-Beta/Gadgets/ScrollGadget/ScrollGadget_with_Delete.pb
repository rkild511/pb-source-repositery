; English forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 31. December 2002
; OS: Windows
; Demo: No



; ScrollInfo2 
;Debugger  ausschalten

#winMain=1

Structure ScrollInfo2 
  ;##### Fixed Data ##### 
  *Previous.l 
  Scroll_ID.l 
  ;Window Handles 
  hEnv.l  ; Envelope Window 
  hPB.l    ; Window 
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

  ;hideflags 
  hide.l 
  hideV.l 
  hideH.l 
EndStructure 
Global NewList ScrollGadgets.ScrollInfo2() 
; ######################################################################################################## 


; ######################################################################################################## 
; Some more declarations (constants and forward-declaration of functions) 
Declare CreateScrollGadget(Scroll_ID, X, Y, Width, Height, SizeX, SizeY, Flags, WindowID) 
Declare SetScrollGadget(Scroll_ID, X, Y, Width, Height, ClientW, ClientH) 
Declare CloseScrollGadget() 
Declare WindowCallback(WindowID, Message, wParam, lParam) 

;constants 
#Null=0 
#False=0 
#True=1 

#ScrollBar_NoScrollH  = 1 
#ScrollBar_NoScrollV  = 2 
#ScrollBar_Border   = 4 
#ScrollBar_ThickBorder = 8 
#ScrollBar_Left    = 16 
#ScrollBar_Top     = 32 
; ######################################################################################################## 
; ScrollGadget-Procedures 
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
  ScrollGadgets()\X = X : ScrollGadgets()\Y = Y 
  ScrollGadgets()\Width = Width : ScrollGadgets()\Height = Height 
  ScrollGadgets()\Flags = Flags 

  ;Client Data 
  ScrollGadgets()\PosX = 1 : ScrollGadgets()\PosY = 1 
  ScrollGadgets()\ClientW = ClientW : ScrollGadgets()\ClientH = ClientH 

  ;###### CREATING THE WINDOWS ###### 
  ;Parent-Window 
  ScrollGadgets()\hPB = WindowID 
  ;Envelope-Window 
  ScrollGadgets()\hEnv = CreateWindowEx_(0, "Static", "", WinFlag, 0, 0, 0, 0, WindowID, 0, GetModuleHandle_(0), 0) 
  ;Client-Area 
  ScrollGadgets()\hWindow = CreateWindowEx_(0, "Static", "", #WS_CHILD | #WS_VISIBLE, 0, 0, 0, 0, ScrollGadgets()\hEnv, 0, GetModuleHandle_(0), 0) 
  ;ScrollBars 
  ScrollGadgets()\hScrollV = CreateWindowEx_(0, "ScrollBar", "", #WS_CHILD | #WS_VISIBLE | #SBS_VERT | #SBS_LEFTALIGN, 0, 0, 0, 0, WindowID, 0, GetModuleHandle_(0), 0)  
  ScrollGadgets()\hScrollH = CreateWindowEx_(0, "ScrollBar", "", #WS_CHILD | #WS_VISIBLE | #SBS_HORZ | #SBS_TOPALIGN, 0, 0, 0, 0, WindowID, 0, GetModuleHandle_(0), 0) 

  SetScrollGadget(Scroll_ID, -1, -1, -1, -1, -1, -1) 

  CreateGadgetList(ScrollGadgets()\hWindow) 
  SetWindowCallback(@WindowCallback()) 
  SetWindowLong_(ScrollGadgets()\hWindow, #GWL_WNDPROC, GetWindowLong_(WindowID(#winMain), #GWL_WNDPROC)) 

  ProcedureReturn ScrollGadgets()\hWindow 
EndProcedure 

Procedure HideScrollGadget(Scroll_ID,X) 
  ResetList(ScrollGadgets()) 
  Repeat 
    ne = NextElement(ScrollGadgets()) 
    If ne = #Null :   ProcedureReturn #False :  EndIf 
  Until (ScrollGadgets()\Scroll_ID = Scroll_ID) 
  ScrollGadgets()\hide=X 
  If X:X=#SW_HIDE:Else:X=#SW_SHOWNA:EndIf 
  ShowWindow_(ScrollGadgets()\hEnv,X) 
  ShowWindow_(ScrollGadgets()\hWindow,X) 
  If ScrollGadgets()\hideV : ShowWindow_(ScrollGadgets()\hScrollV,X) : EndIf 
  If ScrollGadgets()\hideH : ShowWindow_(ScrollGadgets()\hScrollH,X) : EndIf 
  ProcedureReturn #True 
EndProcedure 

Procedure DeleteScrollGadget(Scroll_ID) 
  ResetList(ScrollGadgets()) 
  Repeat 
    ne = NextElement(ScrollGadgets()) 
    If ne = #Null :   ProcedureReturn #False :  EndIf 
  Until (ScrollGadgets()\Scroll_ID = Scroll_ID) 

  DestroyWindow_(ScrollGadgets()\hEnv) 
  DestroyWindow_(ScrollGadgets()\hWindow) 
  DestroyWindow_(ScrollGadgets()\hScrollV) 
  DestroyWindow_(ScrollGadgets()\hScrollH) 
  
  DeleteElement(ScrollGadgets()) 
  
  ProcedureReturn #True 
EndProcedure 

Procedure SetScrollGadget(Scroll_ID, X, Y, Width, Height, ClientW, ClientH) 
  Protected Flags.l, WinFlag.l, BorderW.l, BorderH.l, ScrollBarW.l, ScrollBarH.l 
  Protected WEnvW.l, XEnvW.l, HEnvW.l, YEnvW.l, YScr.l, XScr.l, params.SCROLLINFO 

  ;Retrieving the Gadget with the right ID 
  ResetList(ScrollGadgets()) 
  Repeat 
    ne = NextElement(ScrollGadgets()) 
    If ne = #Null :   ProcedureReturn #False :  EndIf 
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
  If Width <>-1 : ScrollGadgets()\Width = Width : Else : Width = ScrollGadgets()\Width : EndIf 
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

  If ScrollGadgets()\hide:hide=#SWP_HIDEWINDOW:Else:hide=#SWP_SHOWWINDOW:EndIf 


  SetWindowPos_(ScrollGadgets()\hEnv, 0, XEnvW, YEnvW, WEnvW, HEnvW, #SWP_NOACTIVATE | #SWP_NOOWNERZORDER | #SWP_NOZORDER | hide) 
  SetWindowPos_(ScrollGadgets()\hWindow, 0, ScrollGadgets()\PosX, ScrollGadgets()\PosY, ScrollGadgets()\SizeX, ScrollGadgets()\SizeY, #SWP_NOACTIVATE & 0 | #SWP_NOOWNERZORDER | #SWP_NOZORDER | hide) 

  ScrollGadgets()\hideV=sbVActive: ScrollGadgets()\hideH=sbHActive 

  If(sbVActive) 
    SetWindowPos_(ScrollGadgets()\hScrollV, #Null, XScr, YEnvW, ScrollBarW, HEnvW,#SWP_NOACTIVATE | #SWP_NOOWNERZORDER | #SWP_NOZORDER | hide) 
  Else 
    SetWindowPos_(ScrollGadgets()\hScrollV, #Null, XScr, YEnvW, ScrollBarW, HEnvW,#SWP_NOACTIVATE | #SWP_NOOWNERZORDER | #SWP_NOZORDER | #SWP_HIDEWINDOW) 
  EndIf 
  If(sbHActive) 
    SetWindowPos_(ScrollGadgets()\hScrollH, #Null, XEnvW, YScr, WEnvW, ScrollBarH,#SWP_NOACTIVATE | #SWP_NOOWNERZORDER | #SWP_NOZORDER | hide) 
  Else 
    SetWindowPos_(ScrollGadgets()\hScrollH, #Null, XEnvW, YScr, WEnvW, ScrollBarH,#SWP_NOACTIVATE | #SWP_NOOWNERZORDER | #SWP_NOZORDER | #SWP_HIDEWINDOW) 
  EndIf 

  If IsWindowVisible_(ScrollGadgets()\hPB) 
     ShowWindow_(ScrollGadgets()\hPB,#SW_SHOWNA) 
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
  Protected *pointer.l 
  *pointer=@ScrollGadgets() 
  ResetList(ScrollGadgets()) 

  Select Message 
    Case #WM_SIZE 
     If(WindowID =WindowID(#winMain)) 
      SetScrollGadget(2, -1, -1, -1, WindowHeight(#winMain)-20, -1, -1) 
     EndIf 
    Case #WM_HSCROLL 
     If lParam <> #Null 
      ResetList(ScrollGadgets()) 
      Repeat 
       ne = NextElement(ScrollGadgets()) 
      Until (ScrollGadgets()\hScrollH = lParam) Or (ne = #False) 
      wLow = PeekW(@wParam) 
      wHi = PeekW(@wParam+2) - 1 
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
      Result = 0 
     EndIf 

    Case #WM_VSCROLL 
     If lParam <> #Null 
      ResetList(ScrollGadgets()) 
      Repeat: ne = NextElement(ScrollGadgets()) 
      Until ScrollGadgets()\hScrollV = lParam Or ne = #False 
      wLow = PeekW(@wParam) 
      wHi = PeekW(@wParam+2) - 1 
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
      Result = 0 
     EndIf 
  EndSelect 

  ChangeCurrentElement(ScrollGadgets(), *pointer) 
  ProcedureReturn Result 
EndProcedure 



;- *** Example *******

OpenWindow(#winMain,0,200,500,500,"HALLO",#PB_Window_SystemMenu) 
CreateGadgetList(WindowID(#winMain)) 

;PanelGadget(0,20,20,400,400); Dummy - für den Rahmen 
;DisableGadget(0,1) 

PanelGadget(1,20,20,400,400) 
AddGadgetItem(1,-1,"TEST") 
CloseGadgetList() 

rec.rect 
;getclientrect_(GadgetID(1), @rec.rect) 
SendMessage_(GadgetID(1),#TCM_GETITEMRECT ,0,@rec.rect) 
;getclientrect_(GadgetID(1), @rec.rect) 
hh=rec\bottom-rec\top+1 
ww=rec\right-rec\left+1 
bb=rec\left 


X=GadgetX(1)+bb 
Y=GadgetY(1)+hh+bb 
w=GadgetWidth(1)-bb*2 
h=GadgetHeight(1)-hh-bb*2 
ResizeGadget(1,#PB_Ignore,#PB_Ignore,#PB_Ignore,hh+bb) 

ScrollBarW = GetSystemMetrics_(#SM_CXVSCROLL) : ScrollBarH = GetSystemMetrics_(#SM_CYVSCROLL) 

For i=1 To 3 
  If i>1: w1=w-ScrollBarW:h1=h+i*40:Else :w1=w:h1=h:EndIf 
  CreateScrollGadget(i*10, X, Y, w, h, w1,h1, #ScrollBar_Border & 0,WindowID(1)) 
  ButtonGadget(i*10+1,i*10,i*10,150,50,"Delete ScrollGadget "+Str(i)) 
  CloseScrollGadget() 
  HideScrollGadget(i*10,1) 
Next 

AddGadgetItem(1,-1,"TEST2") 
AddGadgetItem(1,-1,"TEST3") 

Select GetGadgetState(1);0=Zeigen 1=hide 
  Case 0 
    HideScrollGadget(10,0):HideScrollGadget(20,1):HideScrollGadget(30,1) 
  Case 1 
    HideScrollGadget(10,1):HideScrollGadget(20,0):HideScrollGadget(30,1) 
  Case 2 
    HideScrollGadget(10,1):HideScrollGadget(20,1):HideScrollGadget(30,0) 
EndSelect 


Repeat 
  eventid= WaitWindowEvent() 
  Select eventid 
    Case #PB_Event_CloseWindow:End 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case 11 
          DeleteScrollGadget(10) 
        Case 21 
          DeleteScrollGadget(20) 
        Case 31 
          DeleteScrollGadget(30) 
          
        Case 1 
          Select GetGadgetState(1);0=Zeigen 1=hide 
            Case 0 
              HideScrollGadget(10,0):HideScrollGadget(20,1):HideScrollGadget(30,1) 
            Case 1 
              HideScrollGadget(10,1):HideScrollGadget(20,0):HideScrollGadget(30,1) 
            Case 2 
              HideScrollGadget(10,1):HideScrollGadget(20,1):HideScrollGadget(30,0) 
          EndSelect 
      EndSelect 
  EndSelect 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; EnableXP
; DisableDebugger