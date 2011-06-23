; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2537&highlight=
; Author: ChaOsKid (updated for PB4.00 by blbltheworm)
; Date: 13. October 2003
; OS: Windows
; Demo: Yes

OpenWindow(0,0,0,200,200,"Refresh WebGadget ?",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 

url$="javascript:document.write('Hallo Welt 1'); document.close()" 
WebGadget(1,5,5,190,190,url$) 

While WindowEvent() : Delay(1) : Wend 
Delay(3000) 

url$="javascript:document.write('Hallo Welt 2'); document.close()" 
SetGadgetText(1,url$) 

While WindowEvent() : Delay(1) : Wend 
Delay(3000) 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
