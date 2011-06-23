; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3339&highlight=
; Author: PWS32 (updated for PB4.00 by blbltheworm)
; Date: 05. January 2004
; OS: Windows
; Demo: No


If OpenWindow(0, 100, 200, 195, 260, "Test Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 

  If CreatePopupMenu(0) 
    MenuItem(1, "Restore Window") 
    MenuBar() 
    MenuItem(2, "Quit") 
  EndIf  
  
  MessageRequester("Info", "lass mal verschwinden", 0) 
  HideWindow(0, 1) 
  AddSysTrayIcon (1, WindowID(0), LoadImage(0, "..\..\Graphics\Gfx\help16.ico")) ; <<--- hier irgend ein 16X16 Icon nehmen 
  SysTrayIconToolTip (1, "Rechte Maustaste für PopUp") 


  Repeat 

    EventID.l = WaitWindowEvent() 

    If EventID = #PB_Event_SysTray ; <<-- PopUp bei click auf rechter Maustaste auf Dein Systray Icon 
      If EventType() = #PB_EventType_RightClick 
        DisplayPopupMenu(0, WindowID(0)) 
      EndIf 
    EndIf 

    If EventID = #PB_Event_Menu ; <<-- PopUp Event 
      Select EventMenu() 
        Case 1 ; Restore 
           RemoveSysTrayIcon (1) 
           HideWindow(0, 0) 
           MessageRequester("Info", "drück mal OK und dann den Minimize Button am Fenster", 0) 
        Case 2 ; Quit 
           Quit = 1 
      EndSelect 
    EndIf 
    
    If IsIconic_(WindowID(0)) ;<<-- dasselbe mit dem Minimize Button 
      HideWindow(0, 1) 
      AddSysTrayIcon (1, WindowID(0), LoadImage(0, "..\..\Graphics\Gfx\help16.ico")) 
      SysTrayIconToolTip (1, "Rechte Maustaste für PopUp") 
    EndIf 



    If EventID = #PB_Event_CloseWindow 
      Quit = 1 
    EndIf 

  Until Quit = 1 
  
EndIf 

End  

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
