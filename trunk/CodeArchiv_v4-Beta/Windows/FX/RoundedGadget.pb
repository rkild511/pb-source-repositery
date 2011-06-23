; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2993&highlight=
; Author: Nico Grüner (updated for PB4.00 by blbltheworm)
; Date: 03. December 2003
; OS: Windows
; Demo: No

;***************************************************************************** 
; I have only test this code for ListIconGadget 
; 
; Ich habe den Code nur mit ListIconGadget getestet 
;***************************************************************************** 

hwnd = OpenWindow(0, 100, 200, 400, 160, "Rounded-Gadget", #PB_Window_TitleBar | #PB_Window_ScreenCentered | #PB_Window_SystemMenu) 

hBrush = CreateSolidBrush_(RGB(255, 25, 255)) ;here set the backroundcolor for better view 
SetClassLong_(hwnd, #GCL_HBRBACKGROUND, hBrush) ; here change the backroundcolor of the window hwnd 

If CreateGadgetList(WindowID(0)) 
hlnd = ListIconGadget(0,10,10,380,115,"Tracks",231) ;the ListIconGadget 
       ButtonGadget(1,10,130,380,20,"close") 
EndIf 
  RoundRgn = CreateRoundRectRgn_(0, 0, 380, 115, 70, 70) ;region for rectangle off the ListIconGadget 
  SetWindowRgn_(hlnd, RoundRgn, #True) ; set the roundet corner of the gadget (hlnd) and #True repaint the gadget 


Repeat 
  EventID.l = WaitWindowEvent() 
  If EventID = #PB_Event_Gadget 
    Select EventGadget() 
      Case 1 
        End 
    EndSelect 
  EndIf 
  If EventID = #PB_Event_CloseWindow 
    End 
  EndIf 
Until quit = 1 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
