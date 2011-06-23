; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8613&highlight=
; Author: scurrier (updated for PB 4.00 by Andre)
; Date: 07. December 2003
; OS: Windows
; Demo: Yes

;- Window Constants
; Constants are just variables you could do the same this as this
; #Window_0=1
; the Enumeration just adds the 1 to the first one 2 the the second and 3 to the third etc...
;
Enumeration
  #Window_0
EndEnumeration

;- Gadget Constants
;
Enumeration
  #Text_0 ; same as #Text_0=1
  #Text_1 ; same as #Text_0=2
  #Text_2 ; same as #Text_0=3
  #Text_3 ; same as #Text_0=4
  #Button_0 ; same as #Button_0=5
  #Button_1 ; same as #Button_0=6
EndEnumeration

; this creates your window notice the variable #Window_0
If OpenWindow(#Window_0, 242, 114, 338, 217, "My First Program", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar)
  ; this checks to see if it ok to create gadgets for the current window
  If CreateGadgetList(WindowID(#Window_0)) ; Constant internal to PB
    TextGadget(#Text_0, 50, 20, 220, 20, "Hello World", #PB_Text_Center) ;this is a Text Box
    TextGadget(#Text_1, 40, 60, 240, 20, "Hello World", #PB_Text_Right) ;this is a Text Box
    TextGadget(#Text_2, 40, 100, 250, 30, "Hello World") ;this is a Text Box
    TextGadget(#Text_3, 30, 140, 260, 20, "Hello World", #PB_Text_Center | #PB_Text_Border)
    ButtonGadget(#Button_0, 30, 180, 80, 30, "OK") ; this is a button
    ButtonGadget(#Button_1, 200, 180, 80, 30, "Cancel") ; this is a button
  EndIf
EndIf

quit=0 ; sets a variable to 0 to make it not true, good for a different way to exit a program
;
;main loop
;
Repeat
  If EventID = #PB_Event_Gadget ; checks to see if a gadget has been pressed
    Select EventGadget()
    Case #Button_0 ; check if #Button_0 or (OK Button) has been pressed
      ; if a #Button_0 has been pressed do whats in here up until the next Case Statement
      MessageRequester("Button Pressed","you have pressed the OK Button",#PB_MessageRequester_Ok)
      
    Case #Button_1 ; check if #Button_1 or (Cancel Button) has been pressed
      ; if a #Button_1 has been pressed do whats in here up until the next Case Statement
      ; or the EndSelect
      quit=1
      
    EndSelect
  EndIf
  EventID=WaitWindowEvent() ; this returns the event number if a event happens
  
Until EventID=#PB_Event_CloseWindow Or quit=1

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
