; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 11. May 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,0,0,355,180,"TreeGadget",#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0))
  TreeGadget(0, 10,10,160,160)                                       ; TreeGadget standard
  TreeGadget(1,180,10,160,160,#PB_Tree_CheckBoxes|#PB_Tree_NoLines)  ; TreeGadget with Checkboxes + no lines
  For id=0 To 1
    For a=0 To 10
      AddGadgetItem (id, -1, "Normal Item "+Str(a))  ; if you want to add an image, use UseImage(x) as 4th parameter
      AddGadgetItem (id, -1, "Node "+Str(a))
      AddGadgetItem(id, -1, "Sub-Item 1",0,1)
      AddGadgetItem(id, -1, "Sub-Item 2",0,1)
      AddGadgetItem(id, -1, "Sub-Item 3",0,2)
      AddGadgetItem(id, -1, "Sub-Item 4",0,1)
      AddGadgetItem (id, -1, "File "+Str(a))
    Next
  Next
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP