; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7930&highlight=
; Author: Berikco (updated for PB4.00 by blbltheworm)
; Date: 19. October 2003
; OS: Windows
; Demo: Yes


;- Window Constants 
; 
Enumeration 
  #Window_0 
  #Window_1 
EndEnumeration 

;- Gadget Constants 
; 
Enumeration 
  #Text_0 
  #Frame3D_0 
  #Frame3D_1 
  #Text_1 
  #OK_Button_0 
EndEnumeration 

;- Fonts 
; 
Global FontID1 
FontID1 = LoadFont(1, "Arial", 20) 
Global FontID2 
FontID2 = LoadFont(2, "Arial", 16) 

Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 405, 334, 431, 100, "New window ( 0 )",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
    If CreateGadgetList(WindowID(#Window_0)) 
      TextGadget(#Text_0, 40, 30, 340, 80, "Main Window", #PB_Text_Center) 
      SetGadgetFont(#Text_0, FontID1) 
      Frame3DGadget(#Frame3D_0, 100, 10, 220, 70, "") 
      
    EndIf 
  EndIf 
EndProcedure 

Procedure Open_Window_1() 
  If OpenWindow(#Window_1, 452, 518, 258, 152, "New window ( 1 )",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
    If CreateGadgetList(WindowID(#Window_1)) 
      Frame3DGadget(#Frame3D_1, 10, 10, 240, 80, "") 
      TextGadget(#Text_1, 20, 30, 220, 60, "About Window", #PB_Text_Center) 
      SetGadgetFont(#Text_1, FontID2) 
      ButtonGadget(#OK_Button_0, 90, 110, 80, 30, "Ok") 
      
    EndIf 
  EndIf 
EndProcedure 

Open_Window_0() 
Open_Window_1() 

Repeat 
  
  Event = WaitWindowEvent() 
  
  WindowID = EventWindow() 
  
  If WindowID = #Window_1 
    If Event = #PB_Event_CloseWindow 
      CloseWindow(#Window_1) 
    EndIf 
    If Event = #PB_Event_Gadget 
      
      GadgetID = EventGadget() 
      
      If GadgetID = #OK_Button_0 
        CloseWindow(#Window_1) 
        
      EndIf 
    EndIf 
  EndIf 
  
Until WindowID = #Window_0 And Event = #PB_Event_CloseWindow 

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
