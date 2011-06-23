; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9135&highlight=
; Author: Berikco
; Date: 13. January 2004
; OS: Windows
; Demo: Yes


; Click with right mouse-button the Stringgadget and you will see the Popup menu

;- Window Constants 
; 
Enumeration 
#Window_0 
EndEnumeration 

;- Gadget Constants 
; 
Enumeration 
#String_0 
EndEnumeration 


Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 450, 188, 315, 229, "Popup Menu on right mouse click...",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
    If CreateGadgetList(WindowID(#Window_0)) 
      StringGadget(#String_0, 20, 30, 160, 30, "") 
      
    EndIf 
    If CreatePopupMenu(0)      ; here the creating of the pop-up menu begins... 
      
      MenuItem(1, "Open")    ; just like in a normal menu... 
      MenuItem(2, "Save") 
      MenuBar() 
      MenuItem(3, "Quit") 
      
    EndIf 
    
  EndIf 
EndProcedure 

Open_Window_0() 

Repeat 
  
  Event = WaitWindowEvent() 
  
  If Event = #WM_RBUTTONDOWN 
    DisplayPopupMenu(0,WindowID(#Window_0)) 
    
  ElseIf Event = #PB_Event_Menu 
    Select EventMenu()     ; get the clicked menu item... 
      Case 1 : Debug "Menu: Open" 
      Case 2 : Debug "Menu: Save" 
      Case 3 : Debug "Menu: Quit" 
        
    EndSelect 
  ElseIf Event = #PB_Event_Gadget 
    
    ;Debug "WindowID: " + Str(EventWindowID()) 
    
    GadgetID = EventGadget() 
    
    If GadgetID = #String_0 
      Debug "GadgetID: #String_0" 
      
    EndIf 
    
  EndIf 
  
Until Event = #PB_Event_CloseWindow 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
