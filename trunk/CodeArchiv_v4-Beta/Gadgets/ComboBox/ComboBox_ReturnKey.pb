; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2032&highlight=
; Author: Gezuppel (updated for PB4.00 by blbltheworm)
; Date: 20. August 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0, 0, 0, 100, 40, "ComboBox-Test", #PB_Window_ScreenCentered | #PB_Window_SystemMenu) 
  If CreateGadgetList(WindowID(0)) 
    StringGadget(0, 0, 0, 200, 20, "Press Return") 
    ComboBoxGadget(1, 0, 20, 100, 100, #PB_ComboBox_Editable) 
    For a.l = 0 To 9 
      AddGadgetItem(1, a, Str(a) + " Press Return") 
    Next 
    
    EventID.l 
    Repeat 
      EventID = WaitWindowEvent() 
      Select EventID 
        Case #PB_Event_CloseWindow 
          End 
        Case #WM_KEYFIRST 
          Select EventwParam() 
            Case #VK_RETURN 
              Debug "Return..." 
              Select EventGadget() 
                Case 1 
                  Debug "...in ComboBox ("+GetGadgetText(1)+")"
                Case 0 
                  Debug "...im StringGadget" 
                Default 
                  Debug "...nirgendwo" 
              EndSelect 
          EndSelect 
      EndSelect 
    ForEver 
  EndIf 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
