; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3001&highlight=
; Author: isidoro (updated for PB4.00 by blbltheworm)
; Date: 11. December 2003
; OS: Windows
; Demo: No

#SB_SETBKCOLOR = $2001 
color=RGB($FF,$FF,$AA) 

#MainWin=0 
MainWinX=100 
MainWinY=150
MainWinW=400 
MainWinH=200 


hwnd=OpenWindow(#MainWin, MainWinX, MainWinY, MainWinW, MainWinH, "Test Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 

statuswnd= CreateStatusBar(0,WindowID(#MainWin)) 
If statuswnd 
  AddStatusBarField(500) 
EndIf 


If hwnd 
;  OleTranslateColor_(color,0,@color); Falls Farbwerte umgewandelt werden müssen 
SendMessage_(statuswnd,#SB_SETBKCOLOR ,0,color) 
StatusBarText(0,0,"Das ist die tolle bunte Leiste ",#PB_StatusBar_Center ) 
  
  Repeat 
    EventID.l = WindowEvent() 
    If EventID 
      Select EventID 
        Case #PB_Event_CloseWindow 
          Quit=1 
      EndSelect 
    Else 
      Delay(10) 
    EndIf 
  Until Quit 
EndIf 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
