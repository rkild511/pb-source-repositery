; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 13. July 2003
; OS: Windows
; Demo: Yes

  If OpenWindow(0,0,0,305,140,"ScrollAreaGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
    ScrollAreaGadget(0, 10, 10,290,120, 375, 155, 30)
      ButtonGadget  (1, 10, 10,230, 30,"Button 1")
      ButtonGadget  (2, 50, 50,230, 30,"Button 2")
      ButtonGadget  (3, 90, 90,230, 30,"Button 3")
      TextGadget    (4,130,130,230, 20,"This is the content of a ScrollAreaGadget!",#PB_Text_Right)
      CloseGadgetList() 
    Repeat 
      Select WaitWindowEvent() 
        Case  #PB_Event_CloseWindow 
          End 
        Case  #PB_Event_Gadget 
          Select EventGadget()
            Case 1
              MessageRequester("Info","Button 1 was pressed!",#PB_MessageRequester_Ok)
            Case 2
              MessageRequester("Info","Button 2 was pressed!",#PB_MessageRequester_Ok)
            Case 3
              MessageRequester("Info","Button 3 was pressed!",#PB_MessageRequester_Ok)
          EndSelect
      EndSelect 
    ForEver 
  EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP