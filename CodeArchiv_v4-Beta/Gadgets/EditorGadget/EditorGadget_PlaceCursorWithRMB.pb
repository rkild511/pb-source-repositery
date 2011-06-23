; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5430&highlight=
; Author: NicTheQuick (updated for PB 4.00 by Andre)
; Date: 18. August 2004
; OS: Windows
; Demo: No


; Place the cursor with clicking right mouse-button
; Cursor platzieren durch Klicken mit der rechten Maustaste

Procedure Editor_Add(Gadget.l,Text.s) 
  SendMessage_(GadgetID(Gadget), #EM_SETSEL, -1, -1) 
  SendMessage_(GadgetID(Gadget), #EM_REPLACESEL, 1, @Text) 
  SendMessage_(GadgetID(Gadget), #EM_SETSEL, -1, -1) 
EndProcedure 

If OpenWindow(0, 0, 0, 400, 300, "WM_RButtonUp", #PB_Window_ScreenCentered | #PB_Window_SystemMenu) 
  If CreateGadgetList(WindowID(0)) 
    EditorGadget(0, 0, 0, 400, 300) 
    For a.l = 1 To 100 
      Editor_Add(0, "Hallo Nr. " + Str(a) + Chr(13)) 
    Next 
    
    Repeat 
      Repeat 
        EventID = WindowEvent() 
        If EventID = 0 : Delay(1) : EndIf 
        
        ;Mach noch viele andere Dinge 
        
      Until EventID 
      
      Select EventID 
        Case #PB_Event_CloseWindow 
          Break 
        
        Case #WM_RBUTTONDOWN 
          PostMessage_(GadgetID(0), #WM_LBUTTONDOWN, 0, EventlParam()) 
      EndSelect 
      
      Delay(1) 
    ForEver 
  EndIf 
  CloseWindow(0) 
EndIf
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -