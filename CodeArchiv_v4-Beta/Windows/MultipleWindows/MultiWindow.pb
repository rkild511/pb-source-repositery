; English forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 21. January 2003
; OS: Windows
; Demo: Yes

Procedure Crea(num.l)
  OpenWindow(num,100,100, 100, 200,Str(num), #PB_Window_SystemMenu )
  If CreateGadgetList(WindowID(num))
    ButtonGadget(num, 50, 75, 40, 20, "Send" ,#PB_Button_Default)
    ButtonGadget(num + 1, 50, 175, 40, 20, "Send" ,#PB_Button_Default)
  EndIf
EndProcedure

If OpenWindow(0,100,100, 400, 300,"memory", #PB_Window_SystemMenu )
  If CreateGadgetList(WindowID(0))
    ButtonGadget(0, 50, 75, 40, 20, "Send" ,#PB_Button_Default)
  EndIf


Repeat 
  EventID.l = WaitWindowEvent()

  If EventID = #PB_Event_Gadget
    Select EventGadget()
     Case 0
       Cont.l = Cont + 1
       Crea(Cont)
     Default
      If EventGadget() = EventWindow()
        CloseWindow(EventGadget())
      Else
        SetGadgetText(EventGadget(),Str(EventGadget()))
      EndIf
    EndSelect
  EndIf

  If EventID = #PB_Event_CloseWindow
    If EventWindow() = 0
      Final.l = 1
    EndIf
    CloseWindow(EventWindow())
  EndIf
Until Final.l = 1 

EndIf
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; Executable = C:\Programmation\PureBasic\Examples\GadgetAdvanced.exe