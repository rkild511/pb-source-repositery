; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1045&highlight=
; Author: Franky  (updated for PB4.00 by blbltheworm)
; Date: 18. May 2003
; OS: Windows
; Demo: No

Procedure SelectStringText(handle,pos1,pos2) 
   SendMessage_(handle,#EM_SETSEL,pos1,pos2) 
EndProcedure 

OpenWindow(1,200,200,200,100,"",#PB_Window_SystemMenu) 
   CreateGadgetList(WindowID(1)) 
   string1 = StringGadget(1,0, 0,199,49,"Test 1 - cool Test"         ,#ES_NOHIDESEL) 
   string2 = StringGadget(2,0,50,199,49,"Test 2 - Set CursorPosition",#ES_NOHIDESEL) 



Repeat 
  event=WaitWindowEvent()  
  If event=#PB_Event_Gadget 
    If EventGadget()=1 
      Select EventType() 
        Case #PB_EventType_Focus 
          SelectStringText(string1, 0,Len(GetGadgetText(1))) 
      EndSelect 
    EndIf 
  EndIf 
Until event=#WM_CLOSE

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
