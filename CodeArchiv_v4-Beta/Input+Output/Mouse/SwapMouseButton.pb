; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3083&highlight=
; Author: cnesm (updated for PB4.00 by blbltheworm)
; Date: 09. December 2003
; OS: Windows
; Demo: No

; Winziges Tool zum Vertauschen der Maustaste. Ist vor allem für das Einstellen von Links
; und Rechtshändlern gedacht, oder einfach als kleiner Spass für Freunde. Vielleicht kann
; es ja jemand gebrauchen. Hier das ganze etwas angepasst als Beispiel:

; Autor: cnesm
; Hinweiss: Die Einstellungen funktionieren dabei systemweit und müssen vor Programmende wieder umgestellt werden
;                Die Nutzung geschieht auf eigene Gefahr des Benutzers
;                Dieser Quelltext darf nicht benutzt werden, um das Eingreifen des Benutzers gewollt zu unterbinden

If OpenWindow(0, 100, 200, 300, 260, "Maustasten vertauschen", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
  CreateGadgetList(WindowID(0))
  
  TextGadget(3,10,60,250,40, "Die Maustasten sind nun nach Systemeinstellung eingestellt")
  
  ButtonGadget(1,10,20,80,16, "Linkshändler")
  ButtonGadget(2,110,20,80,16, "Rechtshändler")
  
  ButtonGadget(4,30,170,150,40, "Drück mich zum Testen")
  
  
  Repeat
    EventID.l = WaitWindowEvent()
    
    If EventID = #PB_Event_CloseWindow
      Quit = 1
    ElseIf EventID = #PB_Event_Gadget
      Select EventGadget()
      Case 1
        SwapMouseButton_(#True)
        SetGadgetText(3,"Jetzt sind die Tasten vertauscht (Rechte Maustaste - Links; Linke Maustaste - Rechts")
      Case 2
        SwapMouseButton_(#False)
        SetGadgetText(3,"Die Maustasten sind nun nach Systemeinstellung nutzbar")
      EndSelect
    EndIf
    
  Until Quit = 1
  
EndIf

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
