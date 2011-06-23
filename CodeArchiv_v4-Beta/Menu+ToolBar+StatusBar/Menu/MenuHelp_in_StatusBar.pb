; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8149&highlight=
; Author: fsw (updated for PB4.00 by blbltheworm)
; Date: 06. November 2003
; OS: Windows
; Demo: Yes


; Example Of Another MenuItem Help 
; (c) 2003 - By FSW 
; 
; do whatever you want with it 
; 


; Note: It's important that you enumerate the Items with numbers higher the amount of your menu titles. 
; Because: 
; 1st MenuTitle = 0 
; 2nd MenuTitle = 1 
; and so on. 
; If your MenuItem start with 0 it doesn't work out.

#Window = 1 
#MenuFocus = 287 
#Menu = 1 

Enumeration 100 
  #Menu1 
  #Menu2 
  #Menu3 
  #Menu4 
  #Menu5 
  #Menu6 
  #StatusBar 
EndEnumeration 

Procedure  LoWord (var) 
  ProcedureReturn var & $FFFF 
EndProcedure 

Procedure MyWindowCallback(WindowID, Message, wParam, lParam) 
  Result = #PB_ProcessPureBasicEvents 

  wParamLo = LoWord (wParam) 
  lParamLo = LoWord (lParam) 

  If Message = #MenuFocus 

    If wParamLo = 0 ;File Title 
      StatusBarText(#StatusBar, 0, "File Title: Help Text") 
    ElseIf wParamLo = #Menu1 
      StatusBarText(#StatusBar, 0, "File 1: Help Text") 
    ElseIf wParamLo = #Menu2 
      StatusBarText(#StatusBar, 0, "File 2: A Much Longer Help Text") 
    ElseIf wParamLo = #Menu3 
      StatusBarText(#StatusBar, 0, "File 3: This Is The Longest Help Text. Believe Me!") 
      
    ElseIf wParamLo = 1 ;Edit Title 
      StatusBarText(#StatusBar, 0, "Edit Title: Help Text") 
    ElseIf wParamLo = #Menu4 
      StatusBarText(#StatusBar, 0, "Edit 1: Help Text") 
    ElseIf wParamLo = #Menu5 
      StatusBarText(#StatusBar, 0, "Edit 2: A Much Longer Help Text") 
    ElseIf wParamLo = #Menu6 
      StatusBarText(#StatusBar, 0, "Edit 3: This Is The Longest Help Text. Believe Me!") 
      
    EndIf 

  ElseIf Message = 32 

    If lParamLo = 5 ; menu 
      StatusBarText(#StatusBar, 0, "You are over the menu") 
    ElseIf lParamLo = 1 ; client area ; you need this to cancel the text 
      StatusBarText(#StatusBar, 0, "") 
    EndIf 

  EndIf 
  
  ProcedureReturn Result 
EndProcedure 


If OpenWindow(#Window,0,0,320,240,"Menu Help Text In Statusbar",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 

  CreateMenu(#Menu,WindowID(#Window)) 
    MenuTitle("File") 
      MenuItem(#Menu1,"File 1") 
      MenuItem(#Menu2,"File 2") 
      MenuItem(#Menu3,"File 3") 
    MenuTitle("Edit") 
      MenuItem(#Menu4,"Edit 1") 
      MenuItem(#Menu5,"Edit 2") 
      MenuItem(#Menu6,"Edit 3") 
    
  CreateStatusBar(#StatusBar, WindowID(#Window)) 
    
  SetWindowCallback(@MyWindowCallback()) 

  Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow 
    
EndIf 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
