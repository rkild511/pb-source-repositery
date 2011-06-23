; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13929&highlight=
; Author: Sparkie (updated for PB 4.00 by Andre)
; Date: 06. February 2005
; OS: Windows
; Demo: No


#CDDS_ITEM = $10000
#CDDS_PREPAINT = 1
#CDDS_ITEMPREPAINT = #CDDS_ITEM | #CDDS_PREPAINT
#CDDS_SUBITEM = $20000
#CDRF_DODEFAULT = 0
#CDRF_NOTIFYITEMDRAW = $20
#CDRF_SKIPDEFAULT = 4
#TBCD_CHANNEL = 3
#TBCD_THUMB = 2
#TBCD_TICS = 1

Global hTrack1, hTrack3, channelBrush, thumbBrush, thumbPen

; --> pts.POINT holds the PolyGon coordinates for drawing the TrackBarGadget thumb
Global Dim pts.Point(4)
; --> Create brushes to colorize TrackBarGadget
channelBrush = CreateSolidBrush_(RGB(0, 255, 0))
thumbBrush = CreateSolidBrush_(RGB(180, 255, 180))
thumbPen = CreatePen_(#PS_SOLID, 1, RGB(0, 128, 0))

Procedure myWindowCallback(hWnd, msg, wParam, lParam)
  result = #PB_ProcessPureBasicEvents
  Select msg
    Case #WM_CTLCOLORSTATIC
      Select lParam
        Case hTrack1
          ; --> Background color for TrackBarGadget(1)
          ProcedureReturn thumbBrush
      EndSelect
    Case #WM_NOTIFY
      tGadget = #False
      *pnmhdr.NMHDR = lParam
      If *pnmhdr\code = #NM_CUSTOMDRAW And (*pnmhdr\hwndFrom = hTrack1 Or *pnmhdr\hwndFrom = hTrack3)
        ; --> *tbcd.NMCUSTOMDRAW contains TrackBar customdraw info
        *tbcd.NMCUSTOMDRAW = lParam
        ; --> *tbcd\hDC contains the handle to current DC for the current TrackBarGadget part being drawn
        result = #CDRF_DODEFAULT
        Select *tbcd\dwDrawStage
          Case #CDDS_PREPAINT
            result = #CDRF_NOTIFYITEMDRAW
          Case #CDDS_ITEMPREPAINT
            ; --> Colorize the TrackBar channel
            If *tbcd\dwItemSpec = #TBCD_CHANNEL
              DrawEdge_(*tbcd\hDC, *tbcd\rc, #EDGE_SUNKEN, #BF_RECT)
              channelRc.RECT
              channelRc\Left = *tbcd\rc\Left
              channelRc\top = *tbcd\rc\top + 3
              channelRc\Right = *tbcd\rc\Right
              channelRc\bottom = *tbcd\rc\bottom - 3
              FillRect_(*tbcd\hDC, channelRc, channelBrush)
              result = #CDRF_SKIPDEFAULT
            EndIf
            ; --> Colorize the TrackBar thumb
            If *tbcd\dwItemSpec = #TBCD_THUMB
              ; --> pts() is an array of POINTS to draw thumb PolyGon
              pts(0)\x = *tbcd\rc\Left
              pts(0)\y = *tbcd\rc\top
              pts(1)\x = *tbcd\rc\Right-1
              pts(1)\y = *tbcd\rc\top
              pts(2)\x = *tbcd\rc\Right-1
              pts(2)\y = *tbcd\rc\bottom-5
              pts(3)\x = *tbcd\rc\Right-4
              pts(3)\y = *tbcd\rc\bottom-1
              pts(4)\x = *tbcd\rc\Left
              pts(4)\y = *tbcd\rc\bottom-5
              ; --> Select our brush and pen into the DC
              SelectObject_(*tbcd\hDC, thumbBrush)
              SelectObject_(*tbcd\hDC, thumbPen)
              ; --> Draw the thumb
              Polygon_(*tbcd\hDC, pts(), 5)
              result = #CDRF_SKIPDEFAULT
            EndIf
            If *tbcd\dwItemSpec = #TBCD_TICS
              result = #CDRF_DODEFAULT
            EndIf
        EndSelect
      EndIf
  EndSelect
  ProcedureReturn result
EndProcedure
If OpenWindow(0, 0, 0, 270, 150, "Colorized TrackBarGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
  SetWindowCallback(@myWindowCallback())
  TextGadget(0, 10, 20, 250, 20, "Colored Background", #PB_Text_Center)
  hTrack1 = TrackBarGadget(1, 10, 40, 250, 20, 0, 20, #PB_TrackBar_Ticks)
  SetGadgetState(1, 1)
  InvalidateRect_(hTrack1, 0, 1)
  TextGadget(2, 10, 90, 250, 20, "Normal Background", #PB_Text_Center)
  hTrack3 = TrackBarGadget(3, 10, 110, 250, 20, 0, 20, #PB_TrackBar_Ticks)
  SetGadgetState(3, 5)
  InvalidateRect_(hTrack3, 0, 1)
  Repeat
    event = WaitWindowEvent()
  Until event = #PB_Event_CloseWindow
  ; --> Clean up
  DeleteObject_(channelBrush)
  DeleteObject_(thumbBrush)
  DeleteObject_(thumbdPen)
EndIf
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP