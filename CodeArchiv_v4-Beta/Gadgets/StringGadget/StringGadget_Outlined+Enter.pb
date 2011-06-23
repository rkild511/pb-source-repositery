; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7584&highlight=
; Author: TerryHough (based on Paul's code, fixed + updated for PB4.00 by blbltheworm)
; Date: 19. September 2003
; OS: Windows
; Demo: No

; 2005-05-15: Redrawing problems fixed by Andre

;   Allow Enter to respond like Tab and to Outline every entry box 
;   This code from the PB forum by Paul responding to query at 
;   http://purebasic.myforums.net/viewtopic.php?t=7584 
;   Additional Case #PB_Event_Repaint code added by Sec 
;   Additional condition added by TerryHough to exclude Exit button from outline 

;-Init Includes 
Enumeration
  #Window_Main
EndEnumeration

Enumeration
  #Gadget_Main_Text2
  #Gadget_Main_Text4
  #Gadget_Main_Text6
  #Gadget_Main_Name
  #Gadget_Main_City
  #Gadget_Main_Phone
  #Gadget_Main_Exit
EndEnumeration

Procedure.l Window_Main() 
  If OpenWindow(#Window_Main,175,0,290,207,"Data Input",#PB_Window_SystemMenu|#PB_Window_WindowCentered) 
    If CreateGadgetList(WindowID(#Window_Main)) 
      TextGadget  (#Gadget_Main_Text2, 10, 10, 60,15,"Name:") 
      StringGadget(#Gadget_Main_Name , 10, 25,165,20,"") 
      TextGadget  (#Gadget_Main_Text4, 10, 60, 60,15,"City:") 
      StringGadget(#Gadget_Main_City , 10, 75,165,20,"") 
      TextGadget  (#Gadget_Main_Text6, 10,110, 60,15,"Phone:") 
      StringGadget(#Gadget_Main_Phone, 10,125,165,20,"") 
      ButtonGadget(#Gadget_Main_Exit ,220,175, 60,20,"Exit") 
      ProcedureReturn WindowID(#Window_Main) 
    EndIf 
  EndIf 
EndProcedure 

Procedure FocusMe(id.l) 
  RedrawWindow_(WindowID(#Window_Main),0,0,#RDW_UPDATENOW|#RDW_ERASE|#RDW_INVALIDATE) 
  If id <> #Gadget_Main_Exit   ; condition added to not box the Exit button 
    StartDrawing(WindowOutput(#Window_Main)) 
    DrawingMode(4) 
    Box(GadgetX(id),GadgetY(id),GadgetWidth(id),GadgetHeight(id),RGB(255,0,0)) 
    StopDrawing() 
  EndIf
EndProcedure 

;-Main Loop 
If Window_Main() 
  AddKeyboardShortcut(#Window_Main,#PB_Shortcut_Return,99) 
  AddKeyboardShortcut(#Window_Main,#PB_Shortcut_Tab   ,99) ; added to maintain Tab compatibility 
  pos=#Gadget_Main_Name 
  FocusMe(pos) 
  
  quitMain=0 
  
  Repeat 
    EventID=WaitWindowEvent() 
    Select EventID 
      Case #PB_Event_CloseWindow 
        If EventWindow()=#Window_Main 
          quitMain=1 
        EndIf 
      
      Case #PB_Event_Menu 
        If EventMenu()=99 
          pos+1 
          If pos>#Gadget_Main_Exit 
            pos=#Gadget_Main_Name 
          EndIf 
          FocusMe(pos) 
          SetActiveGadget(pos)
        EndIf 
        
      Case #PB_Event_Gadget 
        eID=EventGadget() 
        If eID<>oldid 
          oldid=eID 
          pos=eID
          FocusMe(pos) 
        EndIf 
      
        Select eID 
          Case #Gadget_Main_Exit 
          quitMain=1 
        EndSelect 
      
    EndSelect 
  Until quitMain 
  CloseWindow(#Window_Main) 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
