; German forum:
; Author:
; Date:

;- Window Constants
;
#Window_1=1

;- Gadget Constants
;
#Gadget_0=0
#Gadget_1=1

UseJPEGImageDecoder()


Procedure Open_Window_1()
  If OpenWindow(#Window_1, 216,0,100,100,#PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar, "Werbung")
    If CreateGadgetList(WindowID())
      ImageGadget(#Gadget_1,180,30,90,90, LoadImage(1, "Werbung.jpg"))
    EndIf
  EndIf
EndProcedure

Open_Window_1()

If OpenWindow(0,450,340,450,340,#PB_Window_SystemMenu,"Serialz X")
  If CreateGadgetList(WindowID())
  EndIf
  
  If CreateMenu(0,WindowID())
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
  
  If EventID=#PB_EventMenu
    
    Select EventMenuID()
    Case 7: MessageRequester("Version Info","Version 1.0", #PB_MessageRequester_Ok)
    Case 4: ShellExecute_(0, "open", "Handbuch.txt", 0, 0, 1)  ; Handbuch.txt sollte auch existieren
    Case 2: MessageRequester("","Serialz X wird beendet!",0) : End
    EndSelect
    
  EndIf
  
  If EventID=#PB_Event_CloseWindow And EventWindowID()=0
    Quit=2
  EndIf
  If EventID=#PB_Event_CloseWindow And EventWindowID()=1
    CloseWindow(#Window_1)
  EndIf
  
Until Quit=2
End
; ExecutableFormat=Windows
; EOF