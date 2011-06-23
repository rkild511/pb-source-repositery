; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8149&highlight=
; Author: fsw (updated for PB4.00 by blbltheworm)
; Date: 01. November 2003
; OS: Windows
; Demo: Yes

; Example Of A MenuItem Help in Statusbar 
; (c) 2003 - By FSW 
; 
; Tested under WinXP + Win98SE
; do whatever you want with it 
; 

#Window = 0 
#MenuItemFocus = 287 

Enumeration 
  #Menu 
  #Menu1 
  #Menu2 
  #Menu3 
  #StatusBar 
EndEnumeration 

Procedure  LoWord (var) 
  ProcedureReturn var & $FFFF 
EndProcedure 

Procedure MyWindowCallback(WindowID, Message, wParam, lParam) 
  Result = #PB_ProcessPureBasicEvents 

  wParamLo = LoWord (wParam) 

  If Message = #MenuItemFocus 

    If wParamLo = #Menu1 
      StatusBarText(#StatusBar, 0, "Test 1: Help Text") 
    ElseIf wParamLo = #Menu2 
      StatusBarText(#StatusBar, 0, "Test 2: A Much Longer Help Text") 
    ElseIf wParamLo = #Menu3 
      StatusBarText(#StatusBar, 0, "Test 3: This Is The Longest Help Text. Believe Me!") 
    Else 
      StatusBarText(#StatusBar, 0, "") 
    EndIf 

  EndIf 
  
  ProcedureReturn Result 
EndProcedure 


If OpenWindow(#Window,0,0,320,240,"Menu Help Text In Statusbar",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 

  CreateMenu(#Menu,WindowID(#Window)) 
    MenuTitle("File") 
      MenuItem(#Menu1,"Test 1") 
      MenuItem(#Menu2,"Test 2") 
      MenuItem(#Menu3,"Test 3") 
    
  CreateStatusBar(#StatusBar, WindowID(#Window)) 
    
  SetWindowCallback(@MyWindowCallback()) 

  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow 
    
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
