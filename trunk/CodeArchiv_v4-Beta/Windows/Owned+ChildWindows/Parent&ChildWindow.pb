; German forum: http://www.purebasic.fr/german/viewtopic.php?t=710&highlight=
; Author: nco2k (updated for PB 4.00 by Andre)
; Date: 02. November 2004
; OS: Windows
; Demo: No

;- Window Constants 
Enumeration 
  #Window_Main 
  #Window_Child 
EndEnumeration 

;- Shortcut Constants 
Enumeration 
  #Shortcut_Escape 
  #Shortcut_Return 
EndEnumeration 

;- Gadget Constants 
Enumeration 
  #Button_Click 
  #Button_Quit 
  #Button_Ok 
EndEnumeration 

;- Close Child Window 
Procedure Close_Window_Child() 
  If WindowID(#Window_Child) 
    CloseWindow(#Window_Child) 
  EndIf 
  EnableWindow_(WindowID(#Window_Main), #True) 
  SetActiveWindow(#Window_Main) 
EndProcedure 

;- Close Main Window 
Procedure Close_Window_Main() 
  If WindowID(#Window_Main) 
    End 
  EndIf 
EndProcedure 

;- Open Child Window 
Procedure Open_Window_Child() 
  EnableWindow_(WindowID(#Window_Main), #False) 
  If OpenWindow(#Window_Child, 0, 0, 300, 200, "Child", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_TitleBar | #PB_Window_WindowCentered, WindowID(#Window_Main)) 
    If CreateGadgetList(WindowID(#Window_Child)) 
      ButtonGadget(#Button_Ok, 20, 20, 100, 25, "Ok", #PB_Button_Default) 
    EndIf 
    AddKeyboardShortcut(#Window_Child, #PB_Shortcut_Escape, #Shortcut_Escape) 
    AddKeyboardShortcut(#Window_Child, #PB_Shortcut_Return, #Shortcut_Return) 
  Else 
    MessageRequester("", "Error", #MB_ICONERROR) 
    End 
  EndIf 
  SetActiveWindow(#Window_Child) 
EndProcedure 

;- Open Main Window 
Procedure Open_Window_Main() 
  If OpenWindow(#Window_Main, 0, 0, 400, 300, "Main", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered) 
    If CreateGadgetList(WindowID(#Window_Main)) 
      ButtonGadget(#Button_Click, 20, 20, 100, 25, "Click Me!") 
      ButtonGadget(#Button_Quit, 20, 70, 100, 25, "Quit") 
    EndIf 
    AddKeyboardShortcut(#Window_Main, #PB_Shortcut_Escape, #Shortcut_Escape) 
  Else 
    MessageRequester("", "Error", #MB_ICONERROR) 
    End 
  EndIf 
  SetActiveWindow(#Window_Main) 
EndProcedure 

;- Start 
Open_Window_Main() 

;- Event Child Window 
Procedure Event_Window_Child(EventID) 
  Select EventID 
    Case #PB_Event_Menu 
      Select EventMenu() 
        Case #Shortcut_Escape 
          Close_Window_Child() 
        Case #Shortcut_Return 
          Close_Window_Child() 
      EndSelect 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case #Button_Ok 
          Close_Window_Child() 
      EndSelect 
    Case #PB_Event_CloseWindow 
      Close_Window_Child() 
  EndSelect 
EndProcedure 

;- Event Main Window 
Procedure Event_Window_Main(EventID) 
  Select EventID 
    Case #PB_Event_Menu 
      Select EventMenu() 
        Case #Shortcut_Escape 
          Close_Window_Main() 
        Case #Shortcut_Return 
          Close_Window_Main() 
      EndSelect 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case #Button_Click 
          Open_Window_Child() 
        Case #Button_Quit 
          Close_Window_Main() 
      EndSelect 
    Case #PB_Event_CloseWindow 
      Close_Window_Main() 
  EndSelect 
EndProcedure 

;{- Event Loop 
Repeat 
  EventID.l = WaitWindowEvent() 
  If EventID 
    Select EventWindow() 
      Case #Window_Main 
        Event_Window_Main(EventID) 
      Case #Window_Child 
        Event_Window_Child(EventID) 
    EndSelect 
  EndIf 
ForEver 

End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP