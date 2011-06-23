; English forum: http://www.purebasic.fr/english/viewtopic.php?t=10218&highlight=
; Author: USCode (updated for PB 4.00 by Andre)
; Date: 18. April 2004
; OS: Windows
; Demo: Yes


; Test source for the include file RS_ResizeGadgets.pb, so this is needed too !

; 
; RS_ResizeGadgets test 
; 

;- Window Constants 
; 
Enumeration 
  #Window_0 
EndEnumeration 

;- Gadget Constants 
; 
Enumeration 
  #Button_0 
  #Button_1 
  #Button_2 
  #Button_3 
  #Listview_0 
EndEnumeration 

Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 358, 178, 300, 300, "Resize Test", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered) 
    If CreateGadgetList(WindowID(#Window_0)) 
      ButtonGadget(#Button_0, 5, 5, 50, 25, "Button0") 
      ButtonGadget(#Button_1, 245, 5, 50, 25, "Button1") 
      ButtonGadget(#Button_2, 5, 270, 50, 25, "Button2") 
      ButtonGadget(#Button_3, 245, 270, 50, 25, "Button3") 
      ListViewGadget(#Listview_0, 55, 30, 190, 240)      
    EndIf 
  EndIf 
EndProcedure 

Open_Window_0() 

; (1) RESIZE INCLUDE 
IncludeFile "RS_ResizeGadgets.pb"        
; (2) REGISTER RESIZE GADGETS    
; Parameters:  Parent WindowID, GadgetID, Lock Left, Lock Top, Lock Right, Lock Bottom) 
RS_Register(#Window_0,#Button_0,#True,#True,#False,#False)  
RS_Register(#Window_0,#Button_1,#False,#True,#True,#False) 
RS_Register(#Window_0,#Button_2,#True,#False,#False,#True) 
RS_Register(#Window_0,#Button_3,#False,#False,#True,#True) 
RS_Register(#Window_0,#Listview_0,#True,#True,#True,#True) 
; 

Repeat 
  
  Event = WaitWindowEvent() 

; (3) RESIZE GADGETS  
  RS_Resize(Event,EventWindow())                          

  If Event = #PB_Event_Gadget 
    
    GadgetID = EventGadget() 
    
    If GadgetID = #Button_0 
      Debug "GadgetID: #Button_0" 
      
    ElseIf GadgetID = #Button_1 
      Debug "GadgetID: #Button_1" 
      
    ElseIf GadgetID = #Button_2 
      Debug "GadgetID: #Button_2" 
      
    ElseIf GadgetID = #Button_3 
      Debug "GadgetID: #Button_3" 
      
    ElseIf GadgetID = #Listview_0 
      Debug "GadgetID: #Listview_0" 
      
    EndIf 
    
  EndIf 
  
Until Event = #PB_Event_CloseWindow 

End 
;
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -