; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=629&highlight=
; Author: Franco
; Date: 20. April 2003
; OS: Windows
; Demo: No

;Systemmen�-Eintr�ge ver�ndern 

#HOMEPAGE = 1 
#INFO     = 2 

hWnd.l = OpenWindow(0, 100, 200, 250, 260, "Systemmen�-Modifikation", #PB_Window_SystemMenu ) 

  ;Handle zum Systemmen� abrufen 
  hSysMenu.l = GetSystemMenu_(hWnd, #False) 

  ;Men�eintrag aus dem Systemmen� entfernen (Verschieben...) 
  DeleteMenu_(hSysMenu, 1, #MF_BYPOSITION) 

  ;neue Eintr�ge hinzuf�gen 
  AppendMenu_(hSysMenu, #MF_STRING, #HOMEPAGE, "www.&pure-board.de") 
  AppendMenu_(hSysMenu, #MF_STRING, #INFO, "&Info...") 

  Repeat 
    EventID.l = WaitWindowEvent() 
    If EventID = #PB_Event_CloseWindow 
      Quit = 1 
    ElseIf EventID =  #WM_SYSCOMMAND 
      Select EventwParam() 
        ;Homepage-Auswahl wurde getroffen 
        Case #HOMEPAGE: 
            ShellExecute_(hWnd, "Open", "http://www.pure-board.de", "", "", 1) 
        ;Info-Auswahl wurde getroffen 
        Case #INFO: 
            MessageRequester("Info", "Das ist eine Info", 0) 
      EndSelect 
    EndIf 
  Until Quit = 1 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
