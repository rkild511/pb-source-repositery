; English forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 31. December 2002
; OS: Windows
; Demo: No


#Window1 = 1 
#W1Btn1 = 1 
#W1Btn2 = 2 

WinW=500 : WinH=410 
hwnd = OpenWindow( #Window1, (GetSystemMetrics_(#SM_CXSCREEN)-WinW)/2, (GetSystemMetrics_(#SM_CYSCREEN)-WinH)/2, WinW, WinH,"Region Mask", 0)   ; centred window 
If hwnd <> 0 

If CreateGadgetList(WindowID(1)) 
   ButtonGadget(#W1Btn1,103,330 ,89,25,"Mask Window") 
   ButtonGadget(#W1Btn2,264,330 ,89,25,"Close") 
EndIf 

RectRgn = CreateRoundRectRgn_(0, 0, WinW, WinH, 50, 50)  ; rectangle region to give the window rounded edges 
EllipRgn = CreateEllipticRgn_(50, 50, 250, 250) ; elliptic region 
CombinedRgn = RectRgn ; to combine regions, the target region must exist before calling CombineRgn 
CombineRgn_(CombinedRgn, CombinedRgn, EllipRgn, #RGN_XOR) ;the parameter #RGN_XOR creates the union of two combined regions except for any overlapping areas. 

Repeat 
  Delay(1) 
  EventID.l = WaitWindowEvent() 

  Select EventID 

     Case #PB_Event_Gadget 

              Select EventGadget() 
               Case #W1Btn1 ;----------Code 
                  SetWindowRgn_(hwnd, RectRgn, #True) ;sets the window region of a window, #TRUE repaints the window 

               Case #W1Btn2 ;----------Code 
                  EventID = #PB_Event_CloseWindow 

              EndSelect 

  EndSelect 

Until EventID = #PB_Event_CloseWindow 

EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP