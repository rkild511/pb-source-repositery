; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1918&highlight=
; Author: Danilo
; Date: 04. August 2003
; OS: Windows
; Demo: No

; Displays a popup-window "Buy me" every 10-30 seconds....  ;-))))

Global _KaufMich 

Procedure KaufMich(a) 
  _KaufMich = 1 
  OpenWindow(1,200,200,300,300,"KaufMich",#PB_Window_SystemMenu,WindowID(0)) 
    CreateGadgetList(WindowID(1)) 
    TextGadget(1,10,10,280,280,"Kauf Mich !") 
    SetGadgetFont(1,FontID(1)) 
  
  Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow 

  SetTimer_(WindowID(0),0,10000+Random(20000),0) 
  _KaufMich = 0 
EndProcedure 


OpenWindow(0,200,200,300,200,"ProgrammName",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(0)) 
  ButtonGadget(0,10,10,100,20,"eXit") 

LoadFont(1,"Arial",72) 
SetTimer_(WindowID(0),0,3000,0) 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow: End 
    Case #WM_TIMER 
      If _KaufMich=0 
        CreateThread(@KaufMich(),0) 
      EndIf 
  EndSelect 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
