; English forum: 
; Author: Unknown (updated for PB3.93 by ts-soft + Andre, updated for PB4.00 by blbltheworm)
; Date: 28. April 2003
; OS: Windows
; Demo: No


;Edited for Manolo with the colaboration of El_Choni and others. (Thanks to all) 
;Aclarations tecla in spanish is key in English 

;REPLY TO THE NEXT QUESTIONS: 

;How can work with arrows up and down in gadgets??? How can change the colors in gadget focused??? 
;How can change the value of Return for Tab???. See the solution down: 
;--------------------------------------------------------- 
#Gadget_0 = 0 
#OK = 10 
#CANCEL = 20 
#Gadget_30 = 30 
#Gadget_40 = 40 


Global Frente.l, Fondo.l, Esc.l,MyGadget.l 

Procedure GetKey() 
  
  If GetAsyncKeyState_(#VK_RETURN)=-32767 
    tecla = 13 
  ElseIf GetAsyncKeyState_(#VK_ESCAPE)<>0 
    tecla = 27  
  ElseIf GetAsyncKeyState_(#VK_UP)<>0 
    tecla = 38 
  ElseIf GetAsyncKeyState_(#VK_DOWN)<>0 
    tecla = 40 
  EndIf 
  Select tecla 
    Case #VK_RETURN ;push return 
      keybd_event_(#VK_RETURN, 0, #KEYEVENTF_KEYUP, 0)          
      keybd_event_(#VK_TAB,0,0,0) ; TAB key down. 
      keybd_event_(#VK_TAB,0,#KEYEVENTF_KEYUP,0);free TAB 
    Case #VK_UP ; Push UP Arrow 
      keybd_event_(#VK_UP, 0, #KEYEVENTF_KEYUP, 0) 
      keybd_event_(#VK_SHIFT,0,0,0) 
      keybd_event_(#VK_TAB,0,0,0) ; TAB key down. 
      
      keybd_event_(#VK_TAB,0,#KEYEVENTF_KEYUP,0) 
      keybd_event_(#VK_SHIFT,0,#KEYEVENTF_KEYUP,0)      
    Case #VK_DOWN ; Push DOWN Arrow 
      keybd_event_(#VK_DOWN, 0, #KEYEVENTF_KEYUP, 0) 
      keybd_event_(#VK_TAB,0,0,0) ; TAB key down. 
      keybd_event_(#VK_TAB,0,#KEYEVENTF_KEYUP,0) 
    Case #VK_ESCAPE; Push ESC 
      keybd_event_(#VK_ESCAPE, 0, #KEYEVENTF_KEYUP, 0) 
      Esc=1; Return value for close Window or others 
  EndSelect 
  ProcedureReturn MyGadget 
EndProcedure 




Procedure Colorear(WindowID, Message, wParam, lParam) 
  Result = #PB_ProcessPureBasicEvents 
  Select Message 
    Case #WM_CTLCOLOREDIT 
      If IsGadget(MyGadget)
      Select lParam 
        Case GadgetID(MyGadget) 
          SetBkMode_(wParam,#TRANSPARENT) 
          SetTextColor_(wParam, Frente) 
          Result=CreateSolidBrush_(Fondo);Solid background color 
      EndSelect 
      EndIf
  EndSelect 
  ProcedureReturn  Result 
EndProcedure 


If OpenWindow(0,100,150,350,300,"Gadgets: Colors, Arrows, Esc, Return And Tab",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(0)) 
  
  ButtonGadget(#OK, 20, 102, 80, 25, "OK") 
  ButtonGadget(#CANCEL, 100, 102, 100, 25, "Abruch") 
  StringGadget(1,20,20,100,21,"") 
  CheckBoxGadget(#Gadget_30, 20, 45, 90, 15, "Test the West") 
  StringGadget(2,20,64,100,21,"") 
  oldMyGadget = MyGadget 
  Frente = 8454143 ;Front Color 
  Fondo = 16744448 ;Background Color 
  SetWindowCallback(@Colorear()) 
  SetActiveGadget(1) 
  
  
  Repeat 
    EventID=WaitWindowEvent() 
    Select EventID 
      Case #PB_Event_Gadget 
        EventGadget = EventGadget() 
        If EventGadget>0 And EventGadget<9999; This is only if you want limit the gadgets colored 
          MyGadget = EventGadget    
          If oldMyGadget<>MyGadget; this is neccesary for not persistent colors in the gadgets 
            If IsGadget(oldMyGadget)
              RedrawWindow_(GadgetID(oldMyGadget), 0, 0, #RDW_INVALIDATE|#RDW_INTERNALPAINT|#RDW_ERASE) 
            EndIf
            If IsGadget(EventGadget)
              RedrawWindow_(GadgetID(EventGadget), 0, 0, #RDW_INVALIDATE|#RDW_INTERNALPAINT|#RDW_ERASE) 
            EndIf
            oldMyGadget = MyGadget 
          EndIf 
        EndIf 
        Debug EventGadget      
        Select EventGadget 
          Case 1 
            ;you code 
          Case 2 
            ;you code 
          Case #CANCEL 
            End 
        EndSelect 
      Default 
        If GetKey()<>oldMyGadget 
          SetActiveGadget(MyGadget) 
        EndIf 
        GetKey() 
    EndSelect 
    
  Until EventID=#PB_Event_CloseWindow Or Esc=1 
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP