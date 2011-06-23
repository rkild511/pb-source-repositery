; German forum: http://www.purebasic.fr/german/viewtopic.php?t=836&highlight=
; Author: wichtel (updated for PB 4.00 by Andre)
; Date: 09. November 2004
; OS: Windows
; Demo: No

; Set and read status of numlock, capslock and scrolllock keys
; Num-, Caps- und Scrolllock Tasten setzen und auslesen

#VK_NUMLOCK 
#VK_CAPITAL 
#VK_SCROLL 


Enumeration 
  #window 
  #keynumlock 
  #keycapslock 
  #keyscrolllock 
EndEnumeration  
  
Procedure MyGetKey(mykey) 
  ret=GetKeyState_(mykey) 
  ProcedureReturn ret 
EndProcedure  

Procedure MySetKey(mykey,mystate) 
  If MyGetKey(mykey)<>mystate 
    keybd_event_(mykey,0,0,0) 
    keybd_event_(mykey,0,#KEYEVENTF_KEYUP,0) 
  EndIf 
EndProcedure  

OpenWindow(#window,0,0,220,100,"Status Keys",#PB_Window_ScreenCentered|#PB_Window_SystemMenu) 
CreateGadgetList(WindowID(#window)) 
ButtonGadget(#keynumlock,10,10,60,60,"NUM LOCK",#PB_Button_MultiLine|#PB_Button_Toggle) 
ButtonGadget(#keycapslock,80,10,60,60,"CAPS LOCK",#PB_Button_MultiLine|#PB_Button_Toggle) 
ButtonGadget(#keyscrolllock,150,10,60,60,"SCROLL LOCK",#PB_Button_MultiLine|#PB_Button_Toggle) 

Repeat 
  EventID=WaitWindowEvent() 
  
  If EventID = #PB_Event_Gadget 
    GadgetID = EventGadget() 
    If GadgetID = #keynumlock 
      MySetKey(#VK_NUMLOCK,GetGadgetState(#keynumlock)) 
    EndIf 
    If GadgetID = #keycapslock 
      MySetKey(#VK_CAPITAL,GetGadgetState(#keycapslock)) 
    EndIf 
    If GadgetID = #keyscrolllock 
      MySetKey(#VK_SCROLL,GetGadgetState(#keyscrolllock)) 
    EndIf 
  Else 
    ret=MyGetKey(#VK_NUMLOCK) 
    If ret<>GetGadgetState(#keynumlock) 
      SetGadgetState(#keynumlock,ret) 
    EndIf  
    ret=MyGetKey(#VK_CAPITAL) 
    If ret<>GetGadgetState(#keycapslock) 
      SetGadgetState(#keycapslock,ret) 
    EndIf  
    ret=MyGetKey(#VK_SCROLL) 
    If ret<>GetGadgetState(#keyscrolllock) 
      SetGadgetState(#keyscrolllock,ret) 
    EndIf  
  EndIf    
Until EventID = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP