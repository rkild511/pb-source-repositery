; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7262&highlight=
; Author: nessie (fixed + updated for PB4.00 by blbltheworm)
; Date: 18. August 2003
; OS: Windows
; Demo: No

; Input the time using a spin gadget

;**********************************
; Time Spin Gadget
; By Garry Watson aka Nessie
; 17/08/03
; Use as you please
;**********************************

FontID1 = LoadFont(1, "Arial", 12, #PB_Font_Bold)
min = 0
spin = 1
hours = 2
sepa = 3
mins = 4
hr=12:hr$="12"
hWnd = OpenWindow(0,0,0,100,100,"TIME",#PB_Window_ScreenCentered|#PB_Window_SystemMenu)
If hWnd=0 Or CreateGadgetList(hWnd)=0:End:EndIf
If hr=00:hr$="00":EndIf
If state=0:state$="00":EndIf
If hr<10:hr$="0"+Str(hr):EndIf
If hr>9:hr$=Str(hr):EndIf
If state<10:state$="0"+Str(state):EndIf
If state>9:state$=Str(state):EndIf
StringGadget(5, 25, 29, 49, 23,"")
DisableGadget(5,1)
StringGadget(hours, 26, 30, 19, 20, hr$, #PB_String_Numeric | #PB_String_BorderLess)
SetGadgetFont(hours, FontID1)
SendMessage_(GadgetID(hours), #EM_LIMITTEXT, 2, 0)
StringGadget(sepa, 45, 30, 6, 20, ":", #PB_String_BorderLess)
SetGadgetFont(sepa, FontID1)
SendMessage_(GadgetID(sepa), #EM_LIMITTEXT, 1, 0)
SpinGadget(spin, 72, 30, 10, 20, -1, 60)
StringGadget(mins, 51, 30, 20, 20, state$, #PB_String_Numeric | #PB_String_BorderLess)
SetGadgetFont(mins, FontID1)
SendMessage_(GadgetID(mins), #EM_LIMITTEXT, 2, 0)
Repeat
  string = EventGadget ()
  If string=3 : SetActiveGadget(4) : EndIf
  EventID.l = WaitWindowEvent()
  If EventID = #PB_Event_Gadget
  ElseIf EventID = 15
  EndIf
  Select EventID
  Case #PB_Event_Gadget
    Select EventGadget()
    Case mins                                     ;<-added to fix problems with changeing the mins
        If EventType()=#PB_EventType_Change
          state=Val(GetGadgetText(mins)):SetGadgetState(spin,state)
        EndIf
      Case spin
        hr=Val(GetGadgetText(hours))
        state=GetGadgetState(spin)
      evtp=EventType()
      If state>60:SetGadgetState(spin,59):hr=hr-1:EndIf
      If state>59 And state <70 :hr=hr+1:SetGadgetState(spin,0):state=0:EndIf
      If state<10:SetGadgetText(mins,"0"+Str(GetGadgetState(spin))):EndIf
      If state>9:SetGadgetText(mins,Str(GetGadgetState(spin))):EndIf
      If hr<0 :hr=23:EndIf
      If hr>23:hr=0:EndIf
      If hr<10:SetGadgetText(2,"0"+Str(hr)):EndIf
      If hr>9:SetGadgetText(2,Str(hr)):EndIf
    EndSelect
  EndSelect
Until EventID = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
