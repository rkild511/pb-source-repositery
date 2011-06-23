; German forum: http://www.purebasic.fr/german/viewtopic.php?t=574&highlight=
; Author: DarkDragon (updated for PB 4.00 by Andre)
; Date: 24. October 2004
; OS: Windows
; Demo: No

If OpenWindow(0,0,0,322,180,"EditorGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
  TextGadget (1,8,150,306,20,"Make window fullsize, when you click inside")
  EditorGadget (0,8,8,306,133,#PB_Container_Raised)
  For a=0 To 5
    AddGadgetItem(0,a,"Line "+Str(a))
  Next
  
  Repeat
    ;EventID=WindowEvent()
    ;Delay(100)
    EventID=WaitWindowEvent()
    ;Debug EventID
    Select EventID
    Case 513 ;Ändern, wenn Klick in TextGadget
      If state=0
        ShowWindow_(WindowID(0),#SW_MAXIMIZE)
        state=1
      Else
        ShowWindow_(WindowID(0),#SW_SHOWNORMAL)
        state=0
      EndIf
    EndSelect
  Until EventID=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP