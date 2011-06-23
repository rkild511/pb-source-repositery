; German forum: 
; Author: Rings (updated for PB4.00 by blbltheworm)
; Date: 16. January 2002
; OS: Windows
; Demo: No


Procedure.s InputBox(Titel$)
 
  SizeX=220
  SizeY=100
   If OpenWindow(500,(GetSystemMetrics_(#SM_CXSCREEN)/2)-(SizeX/2),(GetSystemMetrics_(#SM_CYSCREEN)/2)-(SizeY/2),SizeX,SizeY,Titel$,0)
  
   If CreateGadgetList(WindowID(500))
    hwnd=StringGadget(1,10,10,191,21,"")
    SendMessage_(hwnd,204,42,0)
    ButtonGadget(2,10,40,89,25,"Okay")
    ButtonGadget(3,110,40,89,25,"Abort")
   EndIf 
   SetForegroundWindow_(WindowID(500));SetForeGroundWindow_()
   SetActiveGadget(1) 
   Repeat 
    EventID.l = WaitWindowEvent()
    Key.w= GetKeyState_( #VK_RETURN) 
    If Key & %100000000000000
      dummy$=GetGadgetText(1)
      Quit=1
    EndIf
    If EventID = #PB_Event_CloseWindow
     Quit=1
    EndIf 
    If EventID = #PB_Event_Gadget
 
     Select EventGadget()
      Case 2
       dummy$=GetGadgetText(1)
       Quit=1
      Case 3
       Quit=1
     EndSelect
   EndIf
  Until Quit=1
  EndIf   
  CloseWindow(500)
  ProcedureReturn dummy$
EndProcedure

Debug InputBox("Password")

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -