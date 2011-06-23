; English forum:
; Author: Unknown (updated for PB4.00 by Andre)
; Date: 21. June 2003
; OS: Windows
; Demo: Yes

;---[ Fake look, works ]---
hWnd = OpenWindow(1,100,100,400,400,"FramePanel",#PB_Window_SystemMenu)
CreateGadgetList(hWnd)
Button = ButtonGadget(2,325,350,50,22,"Quit")
Panel  = PanelGadget(1, 6,24,388,300)
For a = 1 To 6  
  AddGadgetItem(1,-1,"File "+Str(a))
  TextGadget(2+a,10,10,200,25,"Hello World! on Panel "+StrU(a,2))
Next a
CloseGadgetList()
SetGadgetState(1,0)
Frame  = Frame3DGadget(9,2,2,396,396,"",1)
 
Repeat
   Select WaitWindowEvent()
      Case #PB_Event_CloseWindow: End
      Case #PB_Event_Gadget: If EventGadget() = 2: End: EndIf
   EndSelect
ForEver
;--------------------------
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP