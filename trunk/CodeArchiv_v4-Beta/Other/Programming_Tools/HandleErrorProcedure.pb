; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8074&highlight=
; Author: Kale  (made it as standalone-running example by Andre, updated for PB 4.00 by Andre)
; Date: 27. October 2003
; OS: Windows
; Demo: Yes

Procedure HandleError(result, text.s) 
    If result = 0 : MessageRequester("Error", text, #PB_MessageRequester_Ok) : End : EndIf 
EndProcedure 

HandleError(OpenWindow(0, 416, 266, 313, 305, "Test Window", #PB_Window_SystemMenu | #PB_Window_ScreenCentered), "Configuration window could Not be opened.") 
HandleError(CreateGadgetList(WindowID(0)), "Gadget list could not be created for the configuration dialog box.") 

Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
