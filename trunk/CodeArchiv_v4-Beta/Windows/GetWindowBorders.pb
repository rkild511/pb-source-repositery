; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8476&highlight=
; Author: Edwin Knoppert (example by Andre, updated for PB4.00 by blbltheworm)
; Date: 24. November 2003
; OS: Windows
; Demo: No

Procedure.l GetBordersFromhWnd( hWnd.l, *R.RECT )
    Protected WR.RECT
    Protected PA.Point    
    If IsWindow_( hWnd ) = 0
       ProcedureReturn 0
    EndIf
    GetWindowRect_( hWnd, WR )
    ClientToScreen_( hWnd, PA )
    WR\Left = PA\X - WR\Left
    WR\Top = PA\Y - WR\Top
    WR\Right = WR\Left
    WR\Bottom = WR\Left

    ;*R/Left = 100
    ;*R = WR

    MessageRequester( Str( hWnd ), "Left border: "+Str( WR\Left ) + ", Top border: " + Str( WR\Top ), 0 )

    ProcedureReturn 1
EndProcedure

hWnd.l = OpenWindow(0,150,150,200,100,"Get borders...",#PB_Window_SystemMenu)
GetBordersFromhWnd(hWnd, *R.RECT)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
