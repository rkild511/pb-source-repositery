; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3207&start=10
; Author: Lars (updated for PB4.00 by blbltheworm)
; Date: 23. December 2003
; OS: Windows
; Demo: No


;- Window Constants 
Enumeration 
  #Window_0 
EndEnumeration 

;- Gadget Constants 
Enumeration 
  #Button_0 
  #Button_1 
  #Button_2 
EndEnumeration 

;- Menu Constants 
Enumeration 
  #Shortcut_0 
  #Shortcut_1 
EndEnumeration 

If OpenWindow(#Window_0, 216, 150, 145, 115, "New window ( 0 )",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
  
  If CreateGadgetList(WindowID(#Window_0)) 
    ButtonGadget(#Button_0, 10, 10, 125, 25, "0") 
    ButtonGadget(#Button_1, 10, 45, 125, 25, "1", #PB_Button_Default) ;Das ist ein Default Button 
    CurrentDefaultButton = #Button_1 
    ButtonGadget(#Button_2, 10, 80, 125, 25, "2") 
  EndIf 
  
  AddKeyboardShortcut(#Window_0, #PB_Shortcut_Return, #Shortcut_0) 
  AddKeyboardShortcut(#Window_0, #PB_Shortcut_Escape, #Shortcut_1) 
  
  Repeat 
    
    Select WaitWindowEvent() 
      
      Case #PB_Event_Gadget 
        Select EventGadget() 
          Case #Button_0 
            SendMessage_(GadgetID(#Button_0), #BM_SETSTYLE, #BS_DEFPUSHBUTTON, #True) 
            CurrentDefaultButton = #Button_0 
            SendMessage_(GadgetID(#Button_1), #BM_SETSTYLE, 0, #True) 
            SendMessage_(GadgetID(#Button_2), #BM_SETSTYLE, 0, #True) 
          Case #Button_1 
            SendMessage_(GadgetID(#Button_1), #BM_SETSTYLE, #BS_DEFPUSHBUTTON, #True) 
            CurrentDefaultButton = #Button_1 
            SendMessage_(GadgetID(#Button_0), #BM_SETSTYLE, 0, #True) 
            SendMessage_(GadgetID(#Button_2), #BM_SETSTYLE, 0, #True) 
          Case #Button_2 
            SendMessage_(GadgetID(#Button_2), #BM_SETSTYLE, #BS_DEFPUSHBUTTON, #True) 
            CurrentDefaultButton = #Button_2 
            SendMessage_(GadgetID(#Button_0), #BM_SETSTYLE, 0, #True) 
            SendMessage_(GadgetID(#Button_1), #BM_SETSTYLE, 0, #True) 
        EndSelect 
        
      Case #PB_Event_Menu 
        Select EventMenu() 
          Case #Shortcut_0 
            Debug Str(CurrentDefaultButton) + " is current default." 
          Case #Shortcut_1 
            End 
        EndSelect 
        
      Case #PB_Event_CloseWindow 
        End 
        
    EndSelect 
    
  ForEver 
  
EndIf 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
