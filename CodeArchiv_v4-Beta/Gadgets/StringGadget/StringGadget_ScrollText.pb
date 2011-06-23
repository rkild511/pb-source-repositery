; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2832&highlight=
; Author: wichtel (updated for PB4.00 by blbltheworm)
; Date: 15. November 2003
; OS: Windows
; Demo: Yes

#Window_0 = 0 
#edtText = 0 
#btnBeenden = 1 
#chkStartStop = 2 


Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 322, 170, 244, 66, "Scrolling text...",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
    If CreateGadgetList(WindowID(#Window_0)) 
      StringGadget(#edtText, 15, 10, 210, 15, "",#PB_String_BorderLess|#PB_String_ReadOnly) 
      ButtonGadget(#btnBeenden, 15, 30, 100, 30, "Beenden") 
      CheckBoxGadget(#chkStartStop,150, 30,80,30,"Text an") 
      
    EndIf 
  EndIf 
EndProcedure 


Global Trackname.s 
Global threaddelay.l 
Global threadonoff.l 


Trackname = "Dies ist ein langer Lauftext zum testen (4:20) *** " 

Open_Window_0() 


Procedure ShowText() 
  SetGadgetText(#edtText, Trackname) 
EndProcedure 

Procedure UpdateText() 
  help1$ = Mid(Trackname, 1, 1) 
  help2$ = Mid(Trackname, 2, Len(Trackname)) 
  help3$ = help2$ + help1$ 
  Trackname = help3$ 
EndProcedure 

Procedure Thread() 
  If threaddelay<=0 
    UpdateText() 
    ShowText() 
    Delay(30) 
    threaddelay=100 
  Else 
    threaddelay-10 
    Delay(10) 
  EndIf  
EndProcedure 

Repeat 
  Event = WindowEvent() 
  If Event 
    If Event = #PB_Event_Gadget 
      GadgetID = EventGadget() 
      Select GadgetID 
        Case #btnBeenden 
          Event = #PB_Event_CloseWindow 
        Case #chkStartStop 
          threadonoff=GetGadgetState(#chkStartStop) 
      EndSelect    
    EndIf 
  Else 
    If threadonoff 
      Thread() 
    Else 
      Delay(30) 
    EndIf  
  EndIf  
Until Event = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
