; German forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 21. January 2003
; OS: Windows
; Demo: No

SystemPath.s=Space(255)
Result=GetSystemDirectory_(SystemPath.s,255)
OpenWindow(0,0,0,800,150,"Icon-Test",#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)
If CreateGadgetList(WindowID(0))
 For a=0 To 19
  ButtonImageGadget(a,10+a*36,10,36,36,ExtractIcon_(0,SystemPath+"\SetupAPI.dll",a))
  ButtonImageGadget(a,10+a*36,50,36,36,ExtractIcon_(0,SystemPath+"\SetupAPI.dll",a+19))
 Next
EndIf
Repeat : Until WindowEvent()=#PB_Event_CloseWindow
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -