; English forum: http://www.purebasic.fr/english/viewtopic.php?t=5992&highlight=
; Author: Berikco
; Date: 29. April 2003
; OS: Windows
; Demo: No

If OpenWindow(1,200, 200, 185, 330, "UpdateWindow_() - Test", #PB_Window_SystemMenu | #PB_Window_TitleBar ) 
  If CreateGadgetList(WindowID(1)) 
    ButtonGadget(1,0,0,185,45,"Klick me to toggle UpdateWindow ON/OFF",#PB_Button_MultiLine) 
    act.s = "not active" 
    TextGadget(2, 0, 60, 185, 50, "UpdateWindow_() is " + act, #PB_Text_Border) 
    Frame3DGadget(3, 0, 128, 185, 30, "Debugger on ?? ") 
    TextGadget(4, 0, 165, 185, 55, "Just move the Debugger-Window around over me.", #PB_Text_Border) 
    SpinGadget(5,0,230,185,25,1,100) 
    SetGadgetState(5, 123456) 
    StringGadget(6, 0, 260, 185, 25, "move it move it !") 
    TrackBarGadget(7, 0, 290, 185, 24, 200, 400) 
  EndIf 
  
  Repeat 
    If toggle : UpdateWindow_(WindowID(1)) : EndIf 
    Delay(1) 
    Repeat 
      getevent = WindowEvent() 
      If getevent = #PB_Event_Gadget And EventGadget() = 1 
        toggle!1 
        If toggle : act = "active" : Else : act ="not active" : EndIf 
        SetGadgetText(2,"UpdateWindow_() is " + act) 
      ElseIf getevent = #PB_Event_CloseWindow 
        End 
      EndIf 
    Until getevent = 0 
  ForEver 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
