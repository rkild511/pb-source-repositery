; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8480&highlight=
; Author: Berikco  (updated for PB4.00 by blbltheworm)
; Date: 25. November 2003
; OS: Windows
; Demo: Yes


;- Window Constants 
; 
Enumeration 
  #Window_0 
EndEnumeration 

;- MenuBar Constants 
; 
Enumeration 
  #MenuBar_0 
EndEnumeration 

Enumeration 
  #MENU_1 
  #MENU_2 
EndEnumeration 


Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 216, 150, 363, 217, "New window ( 0 )",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
    If CreateMenu(#MenuBar_0, WindowID(#Window_0)) 
      MenuTitle("File") 
      MenuItem(#MENU_1, "Open"+Chr(9)+"Ctrl+O") 
      MenuItem(#MENU_2, "Quit") 
    EndIf 
    
    If CreateGadgetList(WindowID(#Window_0)) 
      
    EndIf 
  EndIf 
EndProcedure 

Open_Window_0() 
AddKeyboardShortcut(#Window_0, #PB_Shortcut_Control | #PB_Shortcut_O, #MENU_1) 

Repeat 
  
  Event = WaitWindowEvent() 
  
  If Event = #PB_Event_Menu 
    
    ;Debug "WindowID: " + Str(EventWindowID()) 
    
    MenuID = EventMenu() 
    
    If MenuID = #MENU_1 
      Debug "GadgetID: #MENU_1" 
      
    ElseIf MenuID = #MENU_2 
      Debug "GadgetID: #MENU_2" 
      
    EndIf 
    
  EndIf 
  
  If Event = #PB_Event_Gadget 
    
    ;Debug "WindowID: " + Str(EventWindowID()) 
    
    GadgetID = EventGadget() 
    
    
    
  EndIf 
  
Until Event = #PB_Event_CloseWindow 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
