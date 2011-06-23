; German forum: 
; Author: freak (updated for PB4.00 by blbltheworm)
; Date: 06. September 2002
; OS: Windows
; Demo: No



; ------------------------------------------------------------------------------------
; ScrollGadget:
;
; Erstellt einen scrollbaren Bereich, in dem man wiederrum Gadgets und sonstige Controls
; Erstellen kann.
;
; OpenScrollGadget(x, y, Width, Height, SizeX, SizeY, Flags, WindowID)
;
; x,y          = Position des Bereichs
; Width,Height = Größe des Bereichs
; SizeX,SizeY  = Virtuelle Größe des Bereichs (das, was dann gescrollt werden kann)
; Flags        = Eine, oder mehrere der folgenden Konstanten (mit '|' verknüpfen)
;
;                #ScrollBar_ScrollH     Horizontale Scroollbar anzeigen
;                #ScrollBar_ScrollV     Vertikale Scrollbar anzeigen
;                #ScrollBar_Border      Um den Bereich wird ein Ramen gezeichnet
;                #ScrollBar_ThickBorder Ein dicker (3d) Ramen wird gezeichnet
;
; WindowID     = Die ID von dem Fenster, in dem das GAdget erstellt wird (einfach WindowID() verwenden)
;
; CloseScrollGadget()   Dieser Befehl schliest die erstellung eines ScrollGadgets ab, alle Gadgets, die zwischen
;                       OpenScrollGadget() und CloseScrollGadget stehen, sind dann scrollbar.
;
;
; Anmerkungen:
;
; * Gadgets, die in einem ScrollGadget erstellt werden, werden relativ dazu positioniert, nicht relativ zum Fenster.
;
; * Die Anzahl der möglichen ScrollGadgets ist unbegrenzt.
;
; * Um ein ScrollGadget in einem anderen zu erstellen, muss man die vom ersten ScrollGadget zurückgegebene ID als
;   WindowID für das neue ScrollGAdget verwenden. (wie unten im Beispiel)
;
; * Um ein ScrollGadget in einem PanelGadget zu erstellen, muss man ein Frame3dGadget erstellen, und die davon
;   zurückgegebene ID (id.l = Frame3DGadget...) as WindowID für das ScrollGAdget verwenden.
;   Nach CloseScrollGadget() muss dann noch volgendes stehen: UseGadgetList(WindowID())
;

;#NULL=0 
;#FALSE=0
;#TRUE=0
; ------------------------------------------------------------------------------------
; Der volgende code muss am Anfang der Programme stehen, die ScrollGAdget benutzen
; ------------------------------------------------------------------------------------
 
Structure ScrollInfo2
  *Previous.l
  hParent.l
  hPB.l
  hWindow.l
  hScrollV.l
  hScrollH.l
  Height.l
  Width.l
  SizeX.l
  SizeY.l
  PosX.l
  PosY.l
EndStructure
 
Global NewList ScrollGadgets.ScrollInfo2()
 
Declare OpenScrollGadget(x, y, Width, Height, SizeX, SizeY, Flags, WindowID)
Declare CloseScrollGadget()
Declare WindowCallback(WindowID, Message, wParam, lParam)
 
#ScrollBar_ScrollH = 1
#ScrollBar_ScrollV = 2
#ScrollBar_Border = 4
#ScrollBar_ThickBorder = 8
 
 
; ------------------------------------------------------------------------------------
; Was jetzt kommt, ist ein kurzes Beispiel zur Benutzung...
; ------------------------------------------------------------------------------------
 
 
 
 
 
If OpenWindow(0, 0, 0, 500, 500, "Scrollbar Example", #PB_Window_SystemMenu) = 0    ; Fenster erstellen
  MessageRequester("","Windowerror!",0)
  End
EndIf
 
CreateGadgetList(WindowID(0))                                    ; einige nicht scrollbare Gadgets
ButtonGadget(1, 10, 10, 140, 20, "Not scrolled Button!")
ButtonGadget(2, 160, 10, 100, 20, "Another Button!")
 
hScr.l = OpenScrollGadget(10, 40, 465, 400, 550, 700, #ScrollBar_ScrollH | #ScrollBar_ScrollV | #ScrollBar_Border, WindowID(0))
                                                                ; ScrollGaget mit 2 Scrollbars und Ramen
 
  For i = 1 To 10                                               ; ein parr gescrollte Gadgets
    ButtonGadget(i+2, 20, i*70-60, 140, 25, "Button Number "+Str(i+2))
  Next i
   
  OpenScrollGadget(200, 100, 80, 30, 250, 0, #ScrollBar_ScrollH, hScr.l)  ; ScrollGAdget im ScrollGadget
   
    ButtonGadget(13, 0, 0, 250, 30, "A Loooooooooooooooooong Gadget!")
   
  CloseScrollGadget()                                                     ; Scrollgadgets schließen
   
CloseScrollGadget()
 
ButtonGadget(14, 10, 465, 100, 25, "not Scrolled")                        ; nicht gescrollter Button

 
 
Repeat                                                                   ; Loop
  Event = WaitWindowEvent()
  If Event = #PB_Event_Gadget
    MessageRequester("Event","Button Number "+Str(EventGadget())+" pushed!",#MB_ICONINFORMATION)
  EndIf
Until Event = #PB_Event_CloseWindow
End
 
 
 
 
 
; ------------------------------------------------------------------------------------
; Das sind die Prozeduren, sie sollten am Ende des codes, oder in einem IncludeFile stehen
; ------------------------------------------------------------------------------------
 
Procedure OpenScrollGadget(x, y, Width, Height, SizeX, SizeY, Flags, WindowID)
  Protected WinFlag.l, Previous.l, *pointer
  If SizeX < Width: SizeX = Width: EndIf
  If SizeY < Height: SizeY = Height: EndIf
  If Flags & #ScrollBar_Border
    WinFlag = #WS_CHILD | #WS_VISIBLE | #WS_BORDER
  ElseIf Flags & #ScrollBar_ThickBorder
    WinFlag = #WS_CHILD | #WS_VISIBLE | #WS_THICKFRAME
  Else
    WinFlag = #WS_CHILD | #WS_VISIBLE
  EndIf
  AddElement(ScrollGadgets())
  Previous = @ScrollGadgets()
  ScrollGadgets()\Previous = Previous
  ScrollGadgets()\hPB = WindowID
  ScrollGadgets()\hParent = CreateWindowEx_(0, "Static", "", WinFlag, x, y, Width, Height, WindowID, 0, GetModuleHandle_(0), 0)
  If ScrollGadgets()\hParent = #Null
    DeleteElement(ScrollGadgets())
    *pointer = Prevoius: ChangeCurrentElement(ScrollGadgets(), *pointer)
    ProcedureReturn #False
  EndIf 
  ScrollGadgets()\hWindow = CreateWindowEx_(0, "Static", "", #WS_CHILD | #WS_VISIBLE, 0, 0, SizeX, SizeY, ScrollGadgets()\hParent, 0, GetModuleHandle_(0), 0)
  If ScrollGadgets()\hWindow = #Null
    DeleteElement(ScrollGadgets())
    *pointer = Prevoius: ChangeCurrentElement(ScrollGadgets(), *pointer)
    ProcedureReturn #False
  EndIf 
  If Flags & #ScrollBar_ScrollV
    ScrollGadgets()\hScrollV = CreateWindowEx_(0, "ScrollBar", "", #WS_CHILD | #WS_VISIBLE | #SBS_VERT | #SBS_LEFTALIGN, x+Width+1, y, 0, Height, WindowID, 0, GetModuleHandle_(0), 0)   
    If ScrollGadgets()\hScrollV = #Null
      DeleteElement(ScrollGadgets())
      *pointer = Prevoius: ChangeCurrentElement(ScrollGadgets(), *pointer)
      ProcedureReturn #False
    EndIf     
    params.SCROLLINFO
    params\cbSize = SizeOf(SCROLLINFO)
    params\fMask = #SIF_DISABLENOSCROLL | #SIF_PAGE | #SIF_POS | #SIF_RANGE
    params\nMin = 0
    params\nMax = SizeY
    params\nPage = Height
    params\nPos = 0
    SendMessage_(ScrollGadgets()\hScrollV, #SBM_SETSCROLLINFO, #True, @params)
    ScrollGadgets()\Height = Height
    ScrollGadgets()\SizeY = SizeY
  EndIf
  If Flags & #ScrollBar_ScrollH
    ScrollGadgets()\hScrollH = CreateWindowEx_(0, "ScrollBar", "", #WS_CHILD | #WS_VISIBLE | #SBS_HORZ | #SBS_TOPALIGN, x, y+Height+1, Width, 0, WindowID, 0, GetModuleHandle_(0), 0)   
    If ScrollGadgets()\hScrollH = #Null
      DeleteElement(ScrollGadgets())
      *pointer = Prevoius: ChangeCurrentElement(ScrollGadgets(), *pointer)
      ProcedureReturn #False
    EndIf     
    params.SCROLLINFO
    params\cbSize = SizeOf(SCROLLINFO)
    params\fMask = #SIF_DISABLENOSCROLL | #SIF_PAGE | #SIF_POS | #SIF_RANGE
    params\nMin = 0
    params\nMax = SizeX
    params\nPage = Width
    params\nPos = 0
    SendMessage_(ScrollGadgets()\hScrollH, #SBM_SETSCROLLINFO, #True, @params)
    ScrollGadgets()\Width = Width
    ScrollGadgets()\SizeX = SizeX
  EndIf
  CreateGadgetList(ScrollGadgets()\hWindow)
  SetWindowCallback(@WindowCallback())
  SetWindowLong_(ScrollGadgets()\hWindow,#GWL_WNDPROC,GetWindowLong_(WindowID(0),#GWL_WNDPROC))
  ProcedureReturn ScrollGadgets()\hWindow
EndProcedure
 
 
Procedure CloseScrollGadget()
  Protected *poiner.l
  UseGadgetList(ScrollGadgets()\hPB)
  *pointer = ScrollGadgets()\Previous
  ChangeCurrentElement(ScrollGadgets(), *pointer)
EndProcedure
 
 
Procedure WindowCallback(WindowID, Message, wParam, lParam)
  Result = #PB_ProcessPureBasicEvents
  Select Message
    Case #WM_HSCROLL
      If lParam <> #Null
         ResetList(ScrollGadgets())
         Repeat: ne = NextElement(ScrollGadgets())
         Until ScrollGadgets()\hScrollH = lParam Or ne = #False
         wLow = PeekW(@wParam)
         wHi  = PeekW(@wParam+2)
         Select wLow
           Case #SB_LEFT: ScrollGadgets()\PosX = 0
           Case #SB_RIGHT: ScrollGadgets()\PosX = ScrollGadgets()\SizeX
           Case #SB_LINELEFT: ScrollGadgets()\PosX + 10
           Case #SB_LINERIGHT: ScrollGadgets()\PosX - 10
           Case #SB_PAGELEFT: ScrollGadgets()\PosX + ScrollGadgets()\Width
           Case #SB_PAGERIGHT: ScrollGadgets()\PosX - ScrollGadgets()\Width
           Case #SB_THUMBPOSITION: ScrollGadgets()\PosX = -wHi
           Case #SB_THUMBTRACK: ScrollGadgets()\PosX = -wHi
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
         wHi  = PeekW(@wParam+2)
         Select wLow
           Case #SB_TOP: ScrollGadgets()\PosY = 0
           Case #SB_BOTTOM: ScrollGadgets()\PosY = ScrollGadgets()\SizeY
           Case #SB_LINEUP: ScrollGadgets()\PosY + 10
           Case #SB_LINEDOWN: ScrollGadgets()\PosY - 10
           Case #SB_PAGEUP: ScrollGadgets()\PosY + ScrollGadgets()\Height
           Case #SB_PAGEDOWN: ScrollGadgets()\PosY - ScrollGadgets()\Height
           Case #SB_THUMBPOSITION: ScrollGadgets()\PosY = -wHi
           Case #SB_THUMBTRACK: ScrollGadgets()\PosY = -wHi
         EndSelect
         SetWindowPos_(ScrollGadgets()\hWindow, 0, ScrollGadgets()\PosX, ScrollGadgets()\PosY, 0, 0, #SWP_NOACTIVATE | #SWP_NOOWNERZORDER | #SWP_NOSIZE | #SWP_NOZORDER | #SWP_SHOWWINDOW)
         SetScrollPos_(ScrollGadgets()\hScrollV, #SB_CTL, -ScrollGadgets()\PosY, #True)
         Result = 0
       EndIf
    Default
  EndSelect
  ProcedureReturn Result
EndProcedure

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger