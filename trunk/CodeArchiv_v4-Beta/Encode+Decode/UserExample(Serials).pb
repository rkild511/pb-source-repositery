; German forum:
; Author: Unknown (updated for PB 4.00 by Andre)
; Date: 31. December 2002
; OS: Windows
; Demo: No


;- Window Constants
;
#Window_1=1

;- Gadget Constants
;
#Gadget_0=0
#Gadget_1=1

UseJPEGImageDecoder()


Procedure Open_Window_1()
  If OpenWindow(#Window_1, 216,0,100,100, "Werbung",#PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar)
    If CreateGadgetList(WindowID(#Window_1))
      ImageGadget(#Gadget_1,180,30,90,90, LoadImage(1, "Werbung.jpg"))
    EndIf
  EndIf
EndProcedure

Open_Window_1()

If OpenWindow(0,450,340,450,340,"Serialz X",#PB_Window_SystemMenu)
  If CreateGadgetList(WindowID(0))
  EndIf
  
  If CreateMenu(0,WindowID(0))
    MenuTitle("Datei")
    MenuItem(1,"Cheat drucken")
    MenuItem(2,"Serialz X beenden")
    MenuTitle("Einstellungen")
    MenuItem(3,"Sprachen")
    MenuTitle("Info")
    MenuItem(4,"Handbuch")
    MenuItem(5,"Serialz X Website")
    MenuItem(6,"Updates")
    MenuItem(7,"Version Info")
  EndIf
  
  ListViewGadget(8,0,0,150,318)
EndIf

Repeat
  
  EventID= WaitWindowEvent()
  
  If EventID=#PB_Event_Menu
    
    Select EventMenu()
    Case 7: MessageRequester("Version Info","Version 1.0", #PB_MessageRequester_Ok)
    Case 4: ShellExecute_(0, "open", "Handbuch.txt", 0, 0, 1)  ; Handbuch.txt sollte auch existieren
    Case 2: MessageRequester("","Serialz X wird beendet!",0) : End
    EndSelect
    
  EndIf
  
  If EventID=#PB_Event_CloseWindow And EventWindow()=0
    Quit=2
  EndIf
  If EventID=#PB_Event_CloseWindow And EventWindow()=1
    CloseWindow(#Window_1)
  EndIf
  
Until Quit=2
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -