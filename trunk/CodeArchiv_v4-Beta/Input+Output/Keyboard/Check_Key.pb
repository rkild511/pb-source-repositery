; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1532&highlight=
; Author: NicTheQuick (updated for PB4.00 by blbltheworm)
; Date: 28. June 2003
; OS: Windows
; Demo: Yes


; Checks, if F3 was pressed and count the key presses (displayed in the messagerequester)

If OpenWindow(1,400,400,100,100,"Press F3!",#PB_Window_SystemMenu) 
  AddKeyboardShortcut(1,#PB_Shortcut_F3 ,1) 
  Repeat 
    Event = WaitWindowEvent() 
    MenuID = EventMenu() 
    Select Event 
      Case #PB_Event_Menu 
        Select MenuID 
          Case 1 
            w = w + 1 
            MessageRequester("Keyboard","Hi,ich komme immer wieder.So oft schon "+Str(w),0) 
        EndSelect 
    EndSelect 
  Until Event = #PB_Event_CloseWindow 
  End 
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
