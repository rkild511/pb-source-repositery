; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1673&highlight=
; Author: NicTheQuick (extended by Andre, updated for PB4.00 by blbltheworm)
; Date: 11. July 2003
; OS: Windows
; Demo: No


; Note: a DisableWindow() command is now natively integrated in PB v4
; Hinweis: ein DisableWindow() Befehl ist in PB v4 jetzt nativ integriert

Procedure iDisableWindow(WindowId.l, bDisable.l) 
  If bDisable 
    EnableWindow_(WindowID(WindowId), #False) 
  Else 
    EnableWindow_(WindowID(WindowId), #True) 
  EndIf 
EndProcedure

;- Example:
If OpenWindow(0,150,100,400,150,"Window disabling",#PB_Window_SystemMenu)
  If CreateGadgetList(WindowID(0))
    ButtonGadget(0,20,20,360,20,"Disable Window")
  EndIf
  Repeat 
    ev.l= WaitWindowEvent()
    If ev = #PB_Event_Gadget
      If EventGadget() = 0
        SetGadgetText(0,"Window is now disabled... Wait 5 seconds")
        iDisableWindow(0,#True)
        Delay(5000)
        SetGadgetText(0,"Window is now active... Disable again.")
        iDisableWindow(0,#False)
      EndIf
    EndIf
  Until ev=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
