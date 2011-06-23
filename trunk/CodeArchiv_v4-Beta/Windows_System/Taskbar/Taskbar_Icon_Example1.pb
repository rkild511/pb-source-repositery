; English forum: 
; Author: alan
; Date: 12. April 2003
; OS: Windows
; Demo: Yes

; Program to create an icon in the task bar that will bring
; up a popup menu on right click and allow you to set a counter that will
; sound an alarm when the counter gets down to 0....

; set up the popup menu with several pre set times and an exit option..
 
CreatePopupMenu(0)
  MenuItem(1, "1 Minute")
  MenuItem(2, "2 Minutes")
  MenuItem(3, "3 Minutes")
  MenuItem(4, "4 Minutes")
  MenuItem(5, "5 Minutes")
  MenuItem(6, "10 Minutes")
  MenuItem(7, "20 Minutes")

  MenuItem(10, "Quit")

; now open a hiddeen windoe (I think I need this to set the taskbar icon)

OpenWindow(0, 10, 10, 10, 10, "Alarm Clock", #PB_Window_Invisible)

;assign a taskbar icon to the above hidden window.

  AddSysTrayIcon(1, WindowID(0), LoadImage(0, "..\..\Graphics\Gfx\tool16.ico"))
  
; and add a tool tip...

  SysTrayIconToolTip(1, "Alarm Clock - Right click to set alarm delay")

Repeat


; wait for the user to do something....
  
  Event=WaitWindowEvent()

; is the "event" over the system tray ?
    
  If Event = #PB_Event_SysTray
    Select EventType()
      Case #PB_EventType_RightClick ; was it a right mouse click ?
      DisplayPopupMenu(0, WindowID(0)) ; then display the popup menu
      EndSelect
  EndIf

; is the event choosing from a menu ?
   
  If Event = #PB_Event_Menu
    Select EventMenu()
      Case 1 ; Set Timer to 1 Minute
        Delay=1
      Case 2 ; Set Timer to 2 Minutes
        Delay=2
      Case 3 ; Set Timer to 3 minutes (etc...)
        Delay=3
      Case 4
        Delay=4
      Case 5
        Delay=5
      Case 6
        Delay=10
      Case 7
        Delay=20
      Case 10 ; Quit
        Quit = 1
      EndSelect
  EndIf

; keep doing the above until user chooses a delay time or the quit option

Until Quit=1 Or Delay>0

If Quit=1
  End
  EndIf
  
; ok the user has choosen a delay time
; so now I need to set some way of alerting the user when the time is up....


; ok a bit basic maybe - just set a delay of user specified time times 60
; (60 seconds in a minute) times 1000 as the delay is in miliseconds
; (1000 miliseconds in 1 second)

; there is a problem with just doing this 
; the icon stays on show but the user can't do anything....

; so I guess the easiest thing is to change the icon to show it is "locked"

ChangeSysTrayIcon(1, LoadImage(0, "..\..\Graphics\Gfx\stop.ico"))
SysTrayIconToolTip(1, "Alarm Clock - LOCKED")

Delay(Delay*1000*60)

; now tell the user that their time is up 
; using a message requester that prints up a message
; and waits for "OK" To be pressed

MessageRequester("Alarm Time", "Your Time is up :)", #PB_MessageRequester_Ok)


End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP