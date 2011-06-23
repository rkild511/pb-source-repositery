; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=931&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 07. May 2003
; OS: Windows
; Demo: No

Procedure SelectStringText(handle,pos1,pos2) 
   SendMessage_(handle,#EM_SETSEL,pos1,pos2) 
EndProcedure 

EOL.s = Chr(13)+Chr(10) 

OpenWindow(1,200,200,200,100,"",#PB_Window_SystemMenu) 
   CreateGadgetList(WindowID(1)) 
   string1 = StringGadget(1,0, 0,199,49,"Test 1 - cool Test"+EOL+"Line 2"         ,#ES_NOHIDESEL|#ES_MULTILINE) 
   string2 = StringGadget(2,0,50,199,49,"Test 2 - Set CursorPosition"+EOL+"Line 2",#ES_NOHIDESEL|#ES_MULTILINE) 

SelectStringText(string1, 5,25) 
SelectStringText(string2,$FFFFFFF,$FFFFFFF) ; ans Ende setzen 

SetActiveGadget(2) 

While WaitWindowEvent() <> #PB_Event_CloseWindow: Wend 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
