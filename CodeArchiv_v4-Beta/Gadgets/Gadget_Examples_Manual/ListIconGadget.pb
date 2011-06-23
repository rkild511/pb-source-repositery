; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm)
; Date: 11. May 2003
; OS: Windows
; Demo: Yes

; Shows possible flags of ListIconGadget in action...
If OpenWindow(0,0,0,640,300,"ListIconGadgets",#PB_Window_SystemMenu) And CreateGadgetList(WindowID(0))
  ; left column
  TextGadget    (6, 10, 10, 300, 20, "ListIcon Standard", #PB_Text_Center)
  ListIconGadget(0, 10, 25, 300, 70, "Column 1",100)
  TextGadget    (7, 10,105, 300, 20, "ListIcon with Checkbox", #PB_Text_Center)
  ListIconGadget(1, 10,120, 300, 70, "Column 1",100, #PB_ListIcon_CheckBoxes)  ; ListIcon with checkbox
  TextGadget    (8, 10,200, 300, 20, "ListIcon with Multi-Selection", #PB_Text_Center)
  ListIconGadget(2, 10,215, 300, 70, "Column 1",100, #PB_ListIcon_MultiSelect) ; ListIcon with multi-selection
  ; right column
  TextGadget    (9,330, 10, 300, 20, "ListIcon with separator lines",#PB_Text_Center)
  ListIconGadget(3,330, 25, 300, 70, "Column 1",100, #PB_ListIcon_GridLines)
  TextGadget   (10,330,105, 300, 20, "ListIcon with FullRowSelect and AlwaysShowSelection",#PB_Text_Center)
  ListIconGadget(4,330,120, 300, 70, "Column 1",100, #PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection)
  TextGadget   (11,330,200, 300, 20, "ListIcon Standard with large icons",#PB_Text_Center)
  ListIconGadget(5,330,220, 300, 65, "",200,#PB_ListIcon_GridLines)
  For a=0 To 4            ; add columns to each of the first 5 listicons
    For b=2 To 4          ; add 3 more columns to each listicon
      AddGadgetColumn(a,b,"Column "+Str(b),65)
    Next
    For b=0 To 2          ; add 4 items to each line of the listicons
      AddGadgetItem(a,b,"Item 1"+Chr(10)+"Item 2"+Chr(10)+"Item 3"+Chr(10)+"Item 4")
    Next
  Next
  ; Here we change the ListIcon display to large icons and show an image
  If LoadImage(0,"..\..\Graphics\Gfx\map2.bmp")     ; change path/filename to your own 32x32 pixel image
    ChangeListIconGadgetDisplay(5, 0)
    AddGadgetItem(5,1,"Picture 1",ImageID(0))
    AddGadgetItem(5,2,"Picture 2",ImageID(0))
  EndIf  
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP