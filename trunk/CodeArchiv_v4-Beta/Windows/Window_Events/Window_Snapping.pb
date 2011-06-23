; German forum: http://www.purebasic.fr/german/viewtopic.php?t=11634&highlight=
; Author: Fluid Byte
; Date: 17. January 2007
; OS: Windows
; Demo: No

; Checks, if the window is near the left screen border. If the #Tolerance value
; is reached, it 'snaps' to the left border.
; Überprüft, ob das Fenster den linken Bildschirmrand erreicht. Wenn der #Tolerance
; (Toleranz-Wert in Pixel) erreicht ist, 'schnappt' das Fenster an den linken Rand.

#TOLERANCE = 40

OpenWindow(0,0,0,280,200,"Window Snapping",#WS_OVERLAPPEDWINDOW | 1)
CreateGadgetList(WindowID(0))
TextGadget(0,10,40,260,180,"MOVE" + #CRLF$ + "ME!",#SS_CENTER)
SetGadgetFont(0,LoadFont(0,"Arial",40,#PB_Font_Bold))

Procedure WindowCallback(hWnd.l,uMsg.l,wParam.l,lParam.l)
  Select uMsg
    Case #WM_WINDOWPOSCHANGING
      *lpwp.WINDOWPOS = lParam

      SystemParametersInfo_(#SPI_GETWORKAREA,0,rwa.RECT,0)

      ; // OUTSIDE SCREEN
      If *lpwp\x < 0
        *lpwp\x - #TOLERANCE
      EndIf

      If (*lpwp\x + *lpwp\cx) > rwa\right
        *lpwp\x + #TOLERANCE
      EndIf

      If *lpwp\y < 0
        *lpwp\y - #TOLERANCE
      EndIf

      If (*lpwp\y + *lpwp\cy) > rwa\bottom
        *lpwp\y + #TOLERANCE
      EndIf

      ; // INSIDE SCREEN
      If *lpwp\x >= 0 And *lpwp\x <= (rwa\Left + #TOLERANCE)
        *lpwp\x = rwa\Left
      EndIf

      If (*lpwp\x + *lpwp\cx) <= rwa\right And (*lpwp\x + *lpwp\cx) >= (rwa\right - #TOLERANCE)
        *lpwp\x = rwa\right - *lpwp\cx
      EndIf

      If *lpwp\y >= 0 And *lpwp\y <= (rwa\Top + #TOLERANCE)
        *lpwp\y = rwa\Top
      EndIf

      If (*lpwp\y + *lpwp\cy) <= rwa\Bottom And (*lpwp\y + *lpwp\cy) >= (rwa\Bottom - #TOLERANCE)
        *lpwp\y = rwa\Bottom - *lpwp\cy
      EndIf
  EndSelect

  ProcedureReturn #PB_ProcessPureBasicEvents
EndProcedure

SetWindowCallback(@WindowCallback())

While WaitWindowEvent() ! 16 : Wend
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP