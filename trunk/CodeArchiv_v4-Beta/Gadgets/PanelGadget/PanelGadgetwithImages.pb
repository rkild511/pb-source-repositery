; German forum: http://www.purebasic.fr/german/viewtopic.php?t=10149
; Author: mardanny71
; Date: 03. October 2006
; OS: Windows
; Demo: Yes

; Note: old API code by freak was removed and PB v4 code is used!

; Enable Images for a Panel Gadget
; It can be enabled for as many PanelGadgets as needed

; Load needed Icons (change the Path for your PB dir) 
LoadImage(0, "..\..\Graphics\Gfx\music.ico") 
LoadImage(1, "..\..\Graphics\Gfx\people.ico") 
LoadImage(2, "..\..\Graphics\Gfx\attention.ico") 

#Panel = 1 

; Create Window 
OpenWindow(0,0,0,300,300,"Panel Images",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 

CreateGadgetList(WindowID(0)) 

; Create Panel 
  PanelGadget(#Panel, 20, 20, 260, 260) 
    AddGadgetItem(#Panel, 0, "Item0",ImageID(0)) 
    AddGadgetItem(#Panel, 1, "Item1",ImageID(1)) 
    AddGadgetItem(#Panel, 2, "Item2",ImageID(2))    
CloseGadgetList() 

; 

; Wait for Quit 
Repeat 
Until WaitWindowEvent() = #PB_Event_CloseWindow 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP