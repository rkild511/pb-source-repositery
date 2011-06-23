; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1279&highlight= 
; Author: LittleFurz (updated for PB 4.00 by Andre + edel) 
; Date: 18. December 2004 
; OS: Windows 
; Demo: No 


Procedure NewMenuIcon(id,color) 
  CreateImage(id, 16, 16) 
  
  StartDrawing(ImageOutput(id)) 
  Box(0,0,16,16,color) 
  StopDrawing() 
  
  ProcedureReturn ImageID(id) 
EndProcedure 

Enumeration 
  #MENU_OPEN 
  #MENU_SAVE 
  #MENU_SAVEAS 
  #MENU_CLOSE 
  #MENU_UNDO 
  #MENU_REDO 
EndEnumeration 


OpenWindow(0, 10, 10, 200, 100, "Menu Test", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
If CreateMenu(0, WindowID(0))    ; hier beginnt das Erstellen des Menüs... 
  MenuTitle("Datei") 
  MenuItem(#MENU_OPEN   , "Open"   +Chr(9)+"Ctrl+O") 
  MenuItem(#MENU_SAVE   , "Save"   +Chr(9)+"Ctrl+S") 
  MenuItem(#MENU_SAVEAS , "Save as"+Chr(9)+"Ctrl+A") 
  MenuItem(#MENU_CLOSE  , "Close"  +Chr(9)+"Ctrl+C") 
  MenuTitle("Bearbeiten") 
  MenuItem(#MENU_UNDO   , "Undo"   +Chr(9)+"Ctrl+Z") 
  MenuItem(#MENU_REDO   , "Redo"   +Chr(9)+"Ctrl+Y") 
EndIf 

SetMenuItemBitmaps_(MenuID(0), #MENU_OPEN   , #MF_BYCOMMAND, NewMenuIcon(0,$FF0000), 0) 
SetMenuItemBitmaps_(MenuID(0), #MENU_SAVE   , #MF_BYCOMMAND, NewMenuIcon(1,$0000FF), 0) 
SetMenuItemBitmaps_(MenuID(0), #MENU_SAVEAS , #MF_BYCOMMAND, NewMenuIcon(2,$FF80FF), 0) 
SetMenuItemBitmaps_(MenuID(0), #MENU_CLOSE  , #MF_BYCOMMAND, NewMenuIcon(3,$00FF80), 0) 

SetMenuItemBitmaps_(MenuID(0), #MENU_UNDO   , #MF_BYCOMMAND, NewMenuIcon(4,$000080), 0) 
SetMenuItemBitmaps_(MenuID(0), #MENU_REDO   , #MF_BYCOMMAND, NewMenuIcon(5,$FFFF00), 0) 

Repeat 
  
Until WaitWindowEvent() = #PB_Event_CloseWindow 

; Hier ne kurze erklärung der API SetMenuItemBitmaps_(): 

; SetMenuItemBitmaps_(hMenu, uPosition, uFlags, hBitmapUnchecked, hBitmapChecked) 
; 
; hMenu            - hWnd zum Menü, wo sich das Menüitem befindet 
; uPosition        - Position im Menü des Menüitems 
; uFlags           - Keine Ahnung o_O. Sollte #MF_BYPOSITION bleiben 
; hBitmapUnchecked - hWnd von einem Bild im Ram. Angezeigt, wenn sich vor dem Menüitem kein Häckchen befindet 
; hBitmapChecked   - hWnd von einem Bild im Ram. Angezeigt, wenn sich vor dem Menüitem ein Häckchen befindet 
; 
; Setzt ein kleines Icon vor einem Menuitem im Menü. Kann dazu benutzt werden um ein Programm grafisch etwas aufzuwerten. 
; 
; 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -