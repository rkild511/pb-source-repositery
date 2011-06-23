; http://www.purearea.net
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 16. August 2003
; OS: Windows
; Demo: Yes

  If OpenWindow(0,0,0,400,150,"ListIcon - Add Columns",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
    ListIconGadget(0,10,10,380,100,"Standard Column",150,#PB_ListIcon_GridLines)
    ButtonGadget(1,10,120,150,20,"Add new column")
    index = 1     ; "Standard column" has already index 0
    Repeat
      ev.l= WaitWindowEvent()
      If ev = #PB_Event_Gadget
        If EventGadget()=1
          AddGadgetColumn(0,index,"Column "+Str(index),80)
          index + 1
        EndIf
      EndIf
    Until ev = #PB_Event_CloseWindow
  EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP