; German forum: 
; Author: NicTheQuick (updated for PB4.00 by blbltheworm)
; Date: 26. April 2003
; OS: Windows
; Demo: No

Procedure.s OpenBeschrWindow(Text.s, ProcName.s) 
  Protected BWidth.l, BHeight.l, Quit.l, OffsetY.l, TmpText.s 
  
  TmpText = Text 
  EnableWindow_(WindowID(0), #False) 

  BWidth = 350 
  BHeight = 300 
  #BButtonHeight = 20 
  If OpenWindow(1, 0, 0, BWidth, BHeight, "Beschreibung - " + Chr(34) + ProcName + Chr(34), #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MinimizeGadget | #PB_Window_WindowCentered) 
    If CreateGadgetList(WindowID(1)) 
      StringGadget(100, 5, 5, BWidth - 10, BHeight - #BButtonHeight - 15, Text, #ES_MULTILINE | #WS_VSCROLL | #WS_HSCROLL) 
      OffsetY = BHeight - #BButtonHeight - 5 
      ButtonGadget(101, 5, OffsetY, (BWidth - 15) / 2, #BButtonHeight, "OK", #PB_Button_Default) 
      ButtonGadget(102, 5 + (BWidth - 10 + 5) / 2, OffsetY, (BWidth - 15) / 2, #BButtonHeight, "Abbrechen") 
    EndIf 
    
    SetActiveGadget(100) 
    
    Quit = #False 
    Repeat 
      If WindowWidth(1) <> BWidth Or WindowHeight(1) <> BHeight 
        BWidth = WindowWidth(1) 
        BHeight = WindowHeight(1) 
        ResizeGadget(100,#PB_Ignore,#PB_Ignore, BWidth - 10, BHeight - #BButtonHeight - 15) 
        OffsetY = BHeight - #BButtonHeight - 5 
        ResizeGadget(101,#PB_Ignore, OffsetY, (BWidth - 15) / 2, #BButtonHeight) 
        ResizeGadget(102, 5 + (BWidth - 10 + 5) / 2, OffsetY, (BWidth - 15) / 2, #BButtonHeight) 
      EndIf 
      
      EventID.l = WaitWindowEvent() 
      Select EventID 
        Case #PB_Event_CloseWindow 
          Quit = #True 
        
        Case #PB_Event_Gadget 
          Select EventGadget() 
            Case 101 
              Quit = #True 
              Text = GetGadgetText(100) 
            Case 102 
              Quit = #True 
              Text = TmpText 
          EndSelect 
      EndSelect 
    Until Quit 
    
    UseGadgetList(WindowID(0)) 
    CloseWindow(1) 
    EnableWindow_(WindowID(0), #True) 
    SetActiveWindow(0) 
  EndIf 

  ProcedureReturn Text 

EndProcedure 

If OpenWindow(0, 0, 0, 400, 300, "MainWindow", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
  If CreateMenu(0, WindowID(0)) 
    MenuTitle("Datei") 
    MenuItem(1, "Öffnen") 
  EndIf 
  
  Repeat 
    EventID.l = WaitWindowEvent() 
    Select EventID 
      Case #PB_Event_CloseWindow 
        End 
      Case #PB_Event_Menu 
        Select EventMenu() 
          Case 1: OpenBeschrWindow("Test... 1, 2, 3", "Test-Procedure") 
        EndSelect 
    EndSelect 
  ForEver 
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger