; English forum: http://www.purebasic.fr/english/viewtopic.php?t=26742
; Author: walker
; Date: 22. April 2007
; OS: Windows, Linux
; Demo: Yes


;- demo
XIncludeFile "ColorPicker.pbi"

Procedure select_color()
  back_color=$80667F
  a=col_picker(20,back_color)
  If a >-2
    SetWindowColor(0,a)
  EndIf
EndProcedure
OpenWindow(0,0,0,200,200,"Color-Select",#PB_Window_ScreenCentered|#PB_Window_SystemMenu)

If CreateGadgetList(WindowID(0))
  *button1=ButtonGadget(#PB_Any,50,50,100,25,"click me")
  registerGadgetEvent(*button1,@select_color())

EndIf
Repeat
  Event  = WaitWindowEvent()
  Gadget = EventGadget()
  Type   = EventType()
  Window = EventWindow()
  Select Event
    Case #PB_Event_Gadget
      CallEventFunction(Window, Event, Gadget, Type)
    Case #PB_Event_CloseWindow
      quit=1
  EndSelect
Until quit=1
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP