; German forum: http://www.purebasic.fr/german/viewtopic.php?t=427&highlight=
; Author: computerkranker (updated for PB 4.00 by Andre)
; Date: 14. October 2004
; OS: Windows
; Demo: No

Procedure IEPopup(x,y,xLen,yLen,url.s) 
  Protected Result 
  Result=OpenWindow(#PB_Any,x,y,xLen,yLen,url.s,#PB_Window_SystemMenu) 
  If Result 
    If CreateGadgetList(WindowID(Result)) 
      WebGadget(#PB_Any,0,0,xLen,yLen,url.s) 
    EndIf 
  EndIf 
  ProcedureReturn Result 
EndProcedure 


OpenWindow(1,0,0,100,100,"Test",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
CreateGadgetList(WindowID(1)) 
ButtonGadget(1,0,0,100,24,"IE Window") 

Repeat 
  Event = WaitWindowEvent() 
  Select Event
    Case #PB_Event_Gadget 
      If EventGadget()=1 And EventType()=#PB_EventType_LeftClick 
        If IsWindow(MainIEWindow) = #False 
          MainIEWindow = IEPopup(100,100,200,200,"http://heise.de") 
        EndIf 
      EndIf 
    Case #PB_Event_CloseWindow 
      If IsWindow(MainIEWindow) And EventWindow()=MainIEWindow 
        CloseWindow(MainIEWindow) 
      ElseIf EventWindow()=1 
        Quit= #True 
      EndIf 
  EndSelect 
Until Quit = #True

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP