; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1457&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 24. June 2003
; OS: Windows
; Demo: Yes

OpenWindow(0,000,200,800,400,"Counter",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(0)) 
  Frame3DGadget(150, y+170, 120, 550, 190, "") 
    StringGadget(151, y+210, 200, 500, 20, "") 
      TextGadget(152, y+420, 90, 60, 30, "", #PB_Text_Border) 
      TextGadget(153, y+420, 70, 60, 20, "Timer", #PB_Text_Center) 
      TextGadget(154, y+180, 200, 20, 20, "", #PB_Text_Border) 
     result=MessageRequester("Achtung Fertig ...","und Los gehts !",#PB_MessageRequester_Ok  ) 

For i=1 To 10 
  a$=Str(i) 
  SetGadgetText(151,a$) 
  While WindowEvent():Wend ; updaten 
  Delay (2000) 
Next 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
