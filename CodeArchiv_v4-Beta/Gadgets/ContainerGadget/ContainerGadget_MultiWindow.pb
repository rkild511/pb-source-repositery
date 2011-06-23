; English forum: http://www.purebasic.fr/english/viewtopic.php?t=10903&highlight=
; Author: Chris (updated for PB 4.00 by Andre)
; Date: 21. May 2004
; OS: Windows
; Demo: No


; You can, too, create two windows with the purebasic standard commands, and create 
; a GadgetList for every windows, and put a ContainerGadget in the GadgetList.. 

;- Constantes Fenêtres 
Enumeration 
  #Win_Main 
  #Win_Child_1 
  #Win_Child_2 
EndEnumeration 

;- Constantes Gadgets 
Enumeration 
  #Text_1 
  #Btn_1 
  #Contain_1 
  #String_1 
  #Text_2 
  #Btn_2 
  #Contain_2 
#String_2  
EndEnumeration 

;- Constantes Menus 
Enumeration 
  #Menu_Win_1 
  #M_Open_1 
  #M_Save_1 
  #M_SaveAs_1 
  #Menu_Win_2 
  #M_Open_2 
  #M_Save_2 
  #M_SaveAs_2 
EndEnumeration 
  
Style = #WS_POPUP|#WS_SYSMENU 
Parent.RECT 

hWnd = OpenWindow(#Win_Main, 0, 0, 500, 300, "MultiWindow",  #PB_Window_ScreenCentered | #PB_Window_SystemMenu) 
GetClientRect_(hWnd, Parent) 

; If CreateGadgetList(hWnd) 
; put here the gadgets for the main window 
; endif 
  
  ; Opening the first window 
hWin1 = OpenWindow(#Win_Child_1,Parent\left,Parent\top,500,150,"Window 1",Style   ,hWnd) 
SetParent_(hWin1,hWnd) 
  
  ;  and creation of the menu... 
hMenu1 = CreateMenu(#Menu_Win_1,hWin1) 
MenuTitle("Project") 
MenuItem(#M_Open_1, "Open"   +Chr(9)+"Ctrl+O") 
MenuItem(#M_Save_1, "Save"   +Chr(9)+"Ctrl+S") 
MenuItem(#M_SaveAs_1, "Save as"+Chr(9)+"Ctrl+A") 
  
  ; and the GadgetList for the first window. 
If CreateGadgetList(hWin1) 
  TextGadget(#Text_1,10,10,100,15,"Bouton n° 1") 
  ButtonGadget(#Btn_1,10,25,100,20,"Bouton") 
  ContainerGadget(#Contain_1,120,10,370,120,#PB_Container_Raised) 
  StringGadget(#String_1,10,10,200,25,"Mon texte") 
  CloseGadgetList() 
EndIf 
  
  ; Opening the second window 
hWin2 = OpenWindow(#Win_Child_2,Parent\left,Parent\top+150,500,150,"Window 2",Style ,hWnd) 
SetParent_(hWin2,hWnd) 
  
  ; and creation of the menu... 
hMenu2 = CreateMenu(#Menu_Win_2,hWin2) 
MenuTitle("Project") 
MenuItem(#M_Open_2, "Open"   +Chr(9)+"Ctrl+O") 
MenuItem(#M_Save_2, "Save"   +Chr(9)+"Ctrl+S") 
MenuItem(#M_SaveAs_2, "Save as"+Chr(9)+"Ctrl+A") 
  
  ; and creation of an another GadgetList for the second window 
If CreateGadgetList(hWin2) 
  TextGadget(#Text_2,10,10,100,15,"Bouton n° 2") 
  ButtonGadget(#Btn_2,10,25,100,20,"Bouton") 
  ContainerGadget(#Contain_2,120,10,370,120,#PB_Container_Raised) 
  StringGadget(#String_2,10,10,200,25,"Mon texte") 
  CloseGadgetList() 
  
EndIf 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_Menu 
      Select EventMenu() 
        Case #M_Open_1 : Debug "Menu Open, fenêtre 1" 
        Case #M_Open_2 : Debug "Menu Open, fenêtre 2" 
        Case #M_Save_1 : Debug "Menu Save, fenêtre 1" 
        Case #M_Save_2 : Debug "Menu Save, fenêtre 2" 
        Case #M_SaveAs_1 : Debug "Menu Save As, fenêtre 1" 
        Case #M_SaveAs_2 : Debug "Menu Save As, fenêtre 2" 
      EndSelect 
      
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case #Btn_1 : Debug "Bouton 1 cliqué" 
        Case #Btn_2 : Debug "Bouton 2 cliqué" 
      EndSelect 
    Case #PB_Event_CloseWindow 
      Quit = 1 
  EndSelect 
  
Until  Quit =1 
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP