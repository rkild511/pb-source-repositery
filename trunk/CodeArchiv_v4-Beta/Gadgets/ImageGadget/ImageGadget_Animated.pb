; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9170&highlight=
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 24. January 2004
; OS: Windows
; Demo: No

; 
; by Danilo, 08.01.2004 
; 
Procedure.f DSin(angle_in_degree.f) 
  ; returns Sinus of 'angle in degree 
  ProcedureReturn Sin(angle_in_degree*0.01745329) 
EndProcedure 

Procedure.f DCos(angle_in_degree.f) 
  ; returns CoSinus of 'angle in degree 
  ProcedureReturn Cos(angle_in_degree*0.01745329) 
EndProcedure 

Global Angle.f 

Procedure UpdateDisplay() 
  StartDrawing(ImageOutput(1)) 
    Box(0,0,200,120,RGB($0A,$94,$C6)) 
    LineXY(100-Dsin(Angle)*50,60-Dcos(Angle)*50,100-Dsin(Angle)*50,60+Dcos(Angle)*50,$FFFFFF) 
    LineXY(100+Dsin(Angle)*50,60+Dcos(Angle)*50,100-Dsin(Angle)*50,60+Dcos(Angle)*50,$FFFFFF) 
  StopDrawing() 
  Angle + 5 
  SetGadgetState(2,ImageID(1)) 
EndProcedure 

If CreateImage(1,200,120)=0 
  MessageRequester("ERROR","Cant create image!",#MB_ICONERROR):End 
EndIf 

OpenWindow(0,0,0,200,140,"Player",#PB_Window_ScreenCentered|#WS_POPUP) 
  CreateGadgetList(WindowID(0)) 
  ButtonGadget(1,0,0,100,20,"eXit") 
  ImageGadget(2,0,20,200,120,ImageID(1)) : UpdateDisplay() 

SetTimer_(WindowID(0),0,20,0) ; LowRes Timer with 20 milliseconds 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow 
      End 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case 1 ; eXit 
          End 
      EndSelect 
    Case #WM_TIMER 
      UpdateDisplay() 
  EndSelect 
ForEver
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger