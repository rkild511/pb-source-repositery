; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2894&highlight=
; Author: Rings (improved version by Then, updated for PB4.00 by blbltheworm)
; Date: 21. November 2003
; OS: Windows
; Demo: No

#WindowWidth  = 600 
#WindowHeight = 400 
If OpenWindow(0, 100, 200, #WindowWidth, #WindowHeight, "PureBasic - EditorGadget Zooming", #PB_Window_MinimizeGadget) 
  If CreateGadgetList(WindowID(0)) 
    rhwnd=EditorGadget(0,1,60,#WindowWidth  ,#WindowHeight-60) 
    SetGadgetText(0,"Purebasic rocks!") 
    SetGadgetFont(0,LoadFont(1,"Arial",12)) 
    Maxrange=300 
    MaxD=Maxrange/64 +1 
    TrackBarGadget(1, 1, 1, #WindowWidth, 40, 1, Maxrange ) 
    TextGadget(2,2,40,400,14,"Set Zooming of Editgadget with Trackbar") 
  EndIf 
  
  Repeat 
    EventID = WaitWindowEvent() 
    If EventID = #PB_Event_Gadget 
      If EventGadget()=1 
        Value=GetGadgetState(1) 
        lRet=SendMessage_(rhwnd,#EM_SETZOOM,Value,MaxD) 
        If lRet=0 
          Debug "Error, Cannot set new zooming Range" 
        EndIf 
      EndIf 
    EndIf 
  Until EventID = #PB_Event_CloseWindow 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
