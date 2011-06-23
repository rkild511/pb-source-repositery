; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2415&highlight=
; Author: freedimension (based on VarX code, extended by Andre, updated for PB4.00 by blbltheworm)
; Date: 30. September 2003
; OS: Windows
; Demo: No

GoodOS = OSVersion() 
If GoodOS = #PB_OS_Windows_2000 Or GoodOS = #PB_OS_Windows_XP Or GoodOS = #PB_OS_Windows_Future 
  GoodOS = #True : Else : GoodOS = #False 
EndIf 

; SetLayeredWindowAttributes is only available for Win2000, WinXP - so we have this little version check included
Procedure SetWinOpacity (hwnd.l, Opacity.l) ; Opacity: Undurchsichtigkeit 0-255 
  SetWindowLong_(hwnd, #GWL_EXSTYLE, $00080000) 
  If OpenLibrary(1, "user32.dll") 
    CallFunction(1, "SetLayeredWindowAttributes", hwnd, 0, Opacity, 2) 
    CloseLibrary(1) 
  EndIf 
  ;MakeToolWindow(hwnd, 1)   ; activate this line, if you want to have a ToolWindow  (need user-lib ToolBar Prof. from Danilo)
EndProcedure 


hwnd=OpenWindow(0,0,0,300,300,"testing...",#PB_Window_SystemMenu |#PB_Window_ScreenCentered) 
If GoodOS 
  SetWinOpacity(hwnd, 100) 
EndIf

Repeat 
Until WaitWindowEvent() = #PB_Event_CloseWindow 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
