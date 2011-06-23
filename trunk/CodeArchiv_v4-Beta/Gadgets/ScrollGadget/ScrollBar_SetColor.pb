; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1278&start=10
; Author: Andreas (updated for PB 4.00 by Andre)
; Date: 07. September 2003
; OS: Windows
; Demo: No


; Updated on 23-Oct-2004 with correct LoWord and HiWord procedures by traumatic

Procedure.w LOWORD(Value.l)
  ProcedureReturn Value & $FFFF
EndProcedure
Procedure.w HIWORD(Value.l)
  ProcedureReturn (Value >> 16) & $FFFF
EndProcedure

Declare.l WindowCallback(WindowID, message, wParam, lParam)
Declare SetColor(BkColor,wParam,lParam)

#Window_Title = "scrollbar-test"
#Gadget_PBScroll = 1
#Gadget_PBText = 2

Global hPBSB.l,hScrollPos.l
Global hWindow.l

hWindow = OpenWindow(0,0,0,800,80, #Window_Title,#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
CreateGadgetList(hWindow)
TextGadget(#Gadget_PBText, 10, 10, 780, 20, "")
hPBSB = ScrollBarGadget(#Gadget_PBScroll, 10, 30 , 780, 20, 0, 1099, 100)
hScrollPos= 500
SetGadgetState(#Gadget_PBScroll, hScrollPos)

SetWindowCallback(@WindowCallback())
SetGadgetText(#Gadget_PBText, "PB-Scrollbar: "+Str(GetGadgetState(#Gadget_PBScroll)))

SetWindowLong_(hPBSB,#GWL_HWNDPARENT,hWindow);neues Elternfenster für ScrollGadget
SetWindowPos_(hPBSB,0,10,30,780,20,1);neu positionieren

Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
End

Procedure SetColor(BkColor,wParam,lParam)
  Shared Brush
  If Brush
    DeleteObject_(Brush)
  EndIf
  Brush = CreateSolidBrush_(BkColor)
  result = Brush
  ProcedureReturn result
EndProcedure


;- Window-Callback-Procedure
Procedure.l WindowCallback(WindowID, message, wParam, lParam)
  Protected result.l : result = #PB_ProcessPureBasicEvents
  Select message

    Case #WM_COMMAND
      If wParam = #Gadget_PBScroll And lParam = hPBSB
        ;hier kommt nichts mehr an !!
      EndIf
    Case #WM_HSCROLL
      If LoWord(wParam) = #SB_LINEUP
        hScrollPos = hScrollPos - 1
      EndIf
      If LoWord(wParam) = #SB_LINEDOWN
        hScrollPos = hScrollPos + 1
      EndIf
      If LoWord(wParam) = #SB_PAGEUP
        hScrollPos = hScrollPos - 16
      EndIf
      If LoWord(wParam) = #SB_PAGEDOWN
        hScrollPos = hScrollPos + 16
      EndIf
      If LoWord(wParam) = #SB_THUMBTRACK
        hScrollPos = HiWord(wParam)
      EndIf
      SetGadgetState(#Gadget_PBScroll, hScrollPos)
      SetGadgetText(#Gadget_PBText, "PB-Scrollbar: "+Str(GetGadgetState(#Gadget_PBScroll)))
    Case #WM_CTLCOLORSCROLLBAR
      result = SetColor(RGB(255,0,255),wParam,lParam)


  EndSelect

  ProcedureReturn result
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP