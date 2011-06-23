; German forum: http://www.purebasic.fr/german/viewtopic.php?t=113&highlight=
; Author: PBZecke (updated for PB 4.00 by Andre)
; Date: 12. September 2004
; OS: Windows
; Demo: Yes


Global screenwidth,  screenheight 

ExamineDesktops()
screenwidth  = DesktopWidth(0)
screenheight = DesktopHeight(0)

OpenWindow(0, 434, 377, 285, 173, "Move window....", #PB_Window_SystemMenu | #PB_Window_TitleBar) 
  
  
  ;WindowsCallback ------------------------ 
  Procedure myCallback(WindowID, Message, wParam, lParam) 
    Result = #PB_ProcessPureBasicEvents 
    If Message =#WM_MOVING 
      
      *windowRect.Rect = lparam 
  
      If *windowRect\left <= 0 
        *windowRect\left = 0 
        *windowRect\right = *windowRect\left + 285            
      EndIf 
      If *windowRect\Top < 0  
        *windowRect\Top = 0 
        *windowRect\bottom = *windowRect\Top + 173                    
      EndIf 
      If *windowRect\right >= screenwidth  
        *windowRect\left = screenwidth -  285 
        *windowRect\right = *windowRect\left + 285 
      EndIf 
      If *windowRect\bottom >= screenheight  
        *windowRect\Top = screenheight  -  173 
        *windowRect\bottom = *windowRect\top + 173 
      EndIf 
      
    EndIf 
          
    ProcedureReturn result 
  EndProcedure 


;Callback definieren 
SetWindowCallback(@myCallback()) 






Repeat 
  
  Event = WaitWindowEvent() 
  
  
Until Event = #PB_Event_CloseWindow 

End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -