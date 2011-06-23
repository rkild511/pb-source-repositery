; English forum:
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 31. December 2002
; OS: Windows
; Demo: No


Procedure mytimer1()
Shared hoehe
If hoehe = 1000: hoehe = 100: EndIf
   Beep_(hoehe,100)
hoehe+100
EndProcedure



Procedure mytimer2()
   Beep_(1800,5)
EndProcedure


Procedure mytimer3()
   Beep_(1800,100)
EndProcedure


Procedure mytimer4()
   Beep_(800,100)
EndProcedure


hWnd = OpenWindow(0, (GetSystemMetrics_(#SM_CXSCREEN)-200)/2,(GetSystemMetrics_(#SM_CYSCREEN)-277)/2, 400, 360, "High Resolution Timer by Danilo", #PB_Window_SystemMenu|#PB_Window_SizeGadget)

SetTimer_(WindowID(0),0,1000,@mytimer1())
SetTimer_(WindowID(0),1, 200,@mytimer2())
SetTimer_(WindowID(0),2,2000,@mytimer3())
SetTimer_(WindowID(0),3, 600,@mytimer4())


  Repeat
         Select WaitWindowEvent()
              ; IF LeftMouseButton pressed...
              Case #WM_LBUTTONDOWN
                KillTimer_(WindowID(0),1) : KillTimer_(WindowID(0),2): KillTimer_(WindowID(0),3)
              Case #PB_Event_CloseWindow
                 End
         EndSelect
  ForEver

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP