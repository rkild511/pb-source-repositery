; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1141&highlight=
; Author: Rings (updated for PB4.00 by blbltheworm)
; Date: 26. May 2003
; OS: Windows
; Demo: No

;Search For 
; direct use of google :) 
; by Siegfried Rings 5/2003 

#Window_0=1 
#Search_Text=1  ; 
#Search_Result=2  ;about:blank 
#GO_Search=3  ;Search 


Procedure Open_Window_0() 
If OpenWindow(#Window_0,318,80,640,480,"Search For",$CC0000) 
  If CreateGadgetList(WindowID(#Window_0)) 
   StringGadget(#Search_Text,3,3,550,20,"Purebasic") 
   WebGadget(#Search_Result,3,26,635,450,"about:blank") 
   ButtonGadget(#GO_Search,560,3,78,20,"Search") 
   AddKeyboardShortcut(#Window_0,  #PB_Shortcut_Return, #GO_Search) 
  EndIf 
EndIf 
EndProcedure 

Open_Window_0() ;Generate the Window and gadgets 

;-Main Eventhandler 
ExitCounter=2 
Repeat 
  WhichEvent = WaitWindowEvent() ;Wait for an Event 
  WhichWindow = EventWindow();Number of Window which fires the event 
  WhichGadget = EventGadget();Is an Gadget used ? 
  WhichEventType = EventType() ; 
  If WhichWindow = #Window_0 
   Select WhichEvent 
    Case #PB_Event_CloseWindow 
     CloseWindow(#Window_0) 
     ExitHandler-1 
    Case  #PB_Event_Gadget 
     Select WhichGadget 
      Case #Search_Text 
      Case #Search_Result 
      Case #GO_Search 
       If WhichEventType= #PB_EventType_LeftClick 
         search.s="http://www.google.com/search?hl=en&ie=ISO-8859-1&q="  + GetGadgetText(#Search_Text) 
         SetGadgetText(#Search_Result,Search.s) 
       EndIf 
     EndSelect ;WhichGadget 
    Case #PB_Event_Menu 
     If EventMenu() =#GO_Search 
          search.s="http://www.google.com/search?hl=en&ie=ISO-8859-1&q="  + GetGadgetText(#Search_Text) 
         SetGadgetText(#Search_Result,Search.s) 
       EndIf 
     Default 
     EndSelect 
   EndIf 
Until Exithandler>0

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
