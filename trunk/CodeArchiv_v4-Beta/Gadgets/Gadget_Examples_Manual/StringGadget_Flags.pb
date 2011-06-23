; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 10. May 2003
; OS: Windows
; Demo: Yes

; Shows possible flags of StringGadget in action...
If OpenWindow(0,0,0,322,275,"StringGadget Flags",#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0))
  StringGadget(0,8, 10,306,20,"Normal StringGadget...")
  StringGadget(1,8, 35,306,20,"1234567",#PB_String_Numeric)
  StringGadget(2,8, 60,306,20,"Readonly StringGadget",#PB_String_ReadOnly)
  StringGadget(3,8, 85,306,20,"lowercase...",#PB_String_LowerCase)
  StringGadget(4,8,110,306,20,"uppercase...",#PB_String_UpperCase)
  StringGadget(5,8,140,306,20,"Borderless StringGadget",#PB_String_BorderLess)
  StringGadget(6,8,170,306,20,"Password",#PB_String_Password)
  StringGadget(7,8,205,306,60,"Multiline StringGadget..."+Chr(13)+Chr(10)+"second line...",#ES_MULTILINE )
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -