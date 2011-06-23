; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1613&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 06. July 2003
; OS: Windows
; Demo: No

; EditorGadget - define visible area
;    SendMessage_(GadgetID(0),#EM_LINESCROLL,0,-1) 

OpenWindow(0,200,200,300,300,"Test",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(0)) 
  EditorGadget(0,5,5,290,290) 

  For i = 0 To 50 
    AddGadgetItem(0,-1,"Item "+RSet(Str(i),4,"0")) 
    SendMessage_(GadgetID(0),#EM_LINESCROLL,0,1) 
    Delay(40) 
    While WindowEvent():Wend 
  Next i 

  For i = 0 To 20 
    SendMessage_(GadgetID(0),#EM_LINESCROLL,0,-1) 
    Delay(100) 
    While WindowEvent():Wend 
  Next i 

Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
