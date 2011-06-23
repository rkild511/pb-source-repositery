; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7030&highlight=
; Author: Kale (updated for PB3.92 by Andre, updated for PB4.00 by blbltheworm)
; Date: 29. July 2003
; OS: Windows
; Demo: No


;-Init Constants 

#WindowIndex    =0 
#GadgetIndex    =0 
#ImageIndex     =0 
#StatusBarIndex =0 
#MenuBarIndex   =0 


;-Window Constants 
Enumeration 
  #WINDOW_MAIN
EndEnumeration


;-Gadget Constants 

;Window_Main 
Enumeration
  #MenuBar_Main 
  #MenuBar_Main_New   
  #MenuBar_Main_Open  
  #MenuBar_Main_Save  
  #MenuBar_Main_Exit  
  #MenuBar_Main_Settings
  #MenuBar_Main_Help   
  #MenuBar_Main_About  
  #MenuBar_1
  #MENU_NEW
  #MENU_OPEN
  #MENU_SAVE
  #MENU_SAVEAS
  #MENU_UNDO 
  #MENU_REDO 
  #MENU_CUT  
  #MENU_COPY 
  #MENU_PASTE
EndEnumeration

Enumeration
  #Gadget_Main_Editor
EndEnumeration

Enumeration
  #StatusBar_Main  
  #StatusBar_Main_Field1
  #StatusBar_Main_Field2
EndEnumeration


Procedure NoTabJump(pGadgetID) 
  ;Needed, because i don't want a jump with tab 
  Style = GetWindowLong_(pGadgetID, #GWL_STYLE) 
  newStyle = Style & (~#WS_TABSTOP) 
  SetWindowLong_(pGadgetID, #GWL_STYLE, newStyle) 
  ProcedureReturn pGadgetID 
EndProcedure 


Procedure.l Window_Main() 
  If OpenWindow(#WINDOW_MAIN,175,0,400,300,"Editor Test",#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_TitleBar|#PB_Window_ScreenCentered|#PB_Window_Invisible) 
    
    CreateMenu(#MenuBar_Main,WindowID(#WINDOW_MAIN)) 
      MenuTitle("File") 
      MenuItem(#MenuBar_Main_New,"New") 
      MenuBar() 
      MenuItem(#MenuBar_Main_Open,"Open") 
      MenuItem(#MenuBar_Main_Save,"Save") 
      MenuBar() 
      MenuItem(#MenuBar_Main_Exit,"Exit") 
      MenuTitle("Edit") 
      MenuItem(#MenuBar_Main_Settings,"Settings") 
      MenuTitle("Help") 
      MenuItem(#MenuBar_Main_Help,"Help") 
      MenuBar() 
      MenuItem(#MenuBar_Main_About,"About") 
      
      If CreateToolBar(10, WindowID(#WINDOW_MAIN)) 
        ToolBarStandardButton(#MENU_NEW, #PB_ToolBarIcon_New) 
        ToolBarToolTip(10,#MENU_NEW, "New") 
        ToolBarStandardButton(#MENU_OPEN, #PB_ToolBarIcon_Open) 
        ToolBarToolTip(10,#MENU_OPEN, "Open") 
        ToolBarStandardButton(#MENU_SAVE, #PB_ToolBarIcon_Save) 
        ToolBarToolTip(10,#MENU_SAVE, "Save") 
        
        ToolBarSeparator() 
        
        ToolBarStandardButton(#MENU_UNDO, #PB_ToolBarIcon_Undo) 
        ToolBarToolTip(10,#MENU_UNDO, "Undo") 
        ToolBarStandardButton(#MENU_REDO, #PB_ToolBarIcon_Redo) 
        ToolBarToolTip(10,#MENU_REDO, "Redo") 
        ToolBarSeparator() 
        ToolBarStandardButton(#MENU_CUT, #PB_ToolBarIcon_Cut) 
        ToolBarToolTip(10,#MENU_CUT, "Cut") 
        ToolBarStandardButton(#MENU_COPY, #PB_ToolBarIcon_Copy) 
        ToolBarToolTip(10,#MENU_COPY, "Copy") 
        ToolBarStandardButton(#MENU_PASTE, #PB_ToolBarIcon_Paste) 
        ToolBarToolTip(10,#MENU_PASTE, "Paste") 
      EndIf 
      
    If CreateGadgetList(WindowID(#WINDOW_MAIN)) 
      EditorGadget(#Gadget_Main_Editor,0,25,400,233) 
      CreateStatusBar(#StatusBar_Main,WindowID(#WINDOW_MAIN)) 
      AddStatusBarField(100) 
      AddStatusBarField(100) 
      HideWindow(#WINDOW_MAIN,0) 
      ProcedureReturn WindowID(#WINDOW_MAIN) 
    EndIf 
  EndIf 
EndProcedure 

;-Main Loop 
If Window_Main() 

    RemoveKeyboardShortcut(#WINDOW_MAIN, #PB_Shortcut_All) 

  quitMain=0 
  Repeat 
    EventID=WaitWindowEvent() 
    Select EventID 
      
      Case #PB_Event_CloseWindow 
        If EventWindow()=#WINDOW_MAIN 
          quitMain=1 
        EndIf 
        
      Case #PB_Event_Menu 
        Select EventMenu() 
          Case #MenuBar_Main_New 
          Case #MenuBar_Main_Open 
          Case #MenuBar_Main_Save 
          Case #MenuBar_Main_Exit 
            quitMain = 1 
          Case #MenuBar_Main_Settings 
          Case #MenuBar_Main_Help 
          Case #MenuBar_Main_About 
        EndSelect 

      Case #PB_Event_Gadget 
        Select EventGadget() 
          Case #Gadget_Main_Editor 
        EndSelect 

    EndSelect 
  Until quitMain 
  CloseWindow(#WINDOW_MAIN) 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
