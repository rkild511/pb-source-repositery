; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2942&highlight=
; Author: NicTheQuick (updated for PB4.00 by blbltheworm)
; Date: 26. November 2003
; OS: Windows
; Demo: Yes

#G_Button = 0 

If OpenWindow(0, 0, 0, 150, 20, "KeyBoardShortcut", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
  If CreateGadgetList(WindowID(0)) 
    ButtonGadget(#G_Button, 0, 0, 150, 20, "Klicken oder Return") 
    AddKeyboardShortcut(0, #PB_Shortcut_Return, #G_Button) 
    
    Repeat 
      EventID.l = WaitWindowEvent() 
      Select EventID 
        Case #PB_Event_CloseWindow 
          Break 
          
        Case #PB_Event_Gadget      ;Per Maus 
          Select EventGadget() 
            Case #G_Button 
              Gosub G_Button_Event 
          EndSelect 
        
        Case #PB_Event_Menu        ;Per Tastatur 
          Select EventMenu() 
            Case #G_Button 
              Gosub G_Button_Event 
          EndSelect 
          
      EndSelect 
    ForEver 
  EndIf 
EndIf 
End 

G_Button_Event: 
  MessageRequester("Info", "Button wurde gedrückt", 0) 
Return

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
