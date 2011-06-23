; German forum: http://www.purebasic.fr/german/viewtopic.php?t=668&highlight=
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 01. November 2004
; OS: Windows
; Demo: No


; Open a context menu via command (after keypress) or right-click with the mouse
; Per Befehl (nach Tastendruck) oder Rechtsklick mit der Maus ein Kontext-Menü öffnen

; SendMessage_(arg1,arg2,arg3,arg4) 
; arg1: Handle des Fensters an welches die Message gesendet wird 
; arg2: #WM_CONTEXTMENU, die Message 
; arg3: Handle des Fensters auf welchem der Rechtsklick war (kann auch ein Child sein, also ein Gadget) 
; arg4: MausKoordinaten, im unteren Word ist x, im oberen Word ist y 
; 
; Das ContextMenu funktioniert bei RechtsKlick mit der Maus, 
; wenn man SHIFT+F10 drückt, und bei VK_APPS (das ist die 
; "Menu-Taste" gleich nehmen der rechten STRG-Taste auf 
; der Tastatur). 
; 
; 
; by Danilo, 01.11.2004 - german forum 
; 
If CreatePopupMenu(0) 
  MenuItem(1, "Cut") 
  MenuItem(2, "Copy") 
  MenuItem(3, "Paste") 
  MenuItem(4, "Quit") 
Else 
  End ; Error 
EndIf 

If CreatePopupMenu(1) 
  MenuItem(1, "ButtonMenu 1") 
  MenuItem(2, "ButtonMenu 2") 
Else 
  End ; Error 
EndIf 


Procedure WndProc(hWnd,Msg,wParam,lParam) 
  Select Msg 
    Case #WM_CONTEXTMENU 
      ; Diese Message kommt automatisch von Windows 
      ; bei Right-Click aufs Fenster und bei Shift+F10 
      ; 
      ; Bei Shift + F10 sind die MausKoordinaten in lParam 
      ; beide -1, weshalb wir dafr die Koordinaten des 
      ; Fensters (wParam) nehmen: 
      If lParam = $FFFFFFFF 
        GetWindowRect_(wParam,r.RECT) 
        lParam = (r\top<<16)|(r\left&$FFFF) 
      EndIf 
      ; 
      ; Display PopUp Menu: 
      If wParam = GadgetID(2) 
        ; PopUp Menu für den Button 2 
        DisplayPopupMenu(1,wParam,lParam&$FFFF,(lParam>>16)&$FFFF) 
      Else 
        ; PopUp Menu für den Rest 
        DisplayPopupMenu(0,wParam,lParam&$FFFF,(lParam>>16)&$FFFF) 
      EndIf 
      ProcedureReturn 0 
  EndSelect 
  ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 


If OpenWindow(0,0,0,200,200,"Press SHIFT+F10",#PB_Window_TitleBar|#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID(0)) 
  ButtonGadget(1,10,10,100,20,"PopUp Main Menu") 
  ButtonGadget(2,10,35,100,20,"Right Click Me!") 
  SetWindowCallback(@WndProc()) 

  Repeat 
    Select WaitWindowEvent() 
      Case #PB_Event_Gadget 
        Select EventGadget() 
          Case 1 
            GetCursorPos_(p.POINT) 
            SendMessage_(WindowID(0),#WM_CONTEXTMENU,WindowID(0),(p\y<<16)|(p\x&$FFFF)) 
        EndSelect 
      Case #PB_Event_Menu 
        Select EventMenu() 
          Case 4 ; Quit              ; funktioniert nur bei Aufruf des PopUps nach Links-Klick auf Button!
            Break 
        EndSelect 
    EndSelect 
  ForEver 
Else 
  End ; Error 
EndIf 

; Bei RechtsKlick aufs Fenster kommt das Menu(0), genauso 
; wie bei drücken des 1. Buttons und beim drücken von 
; SHIFT+F10 oder VK_APPS. 
; 
; Der 2. Button hat ein eigenes PopupMenu, wenn Du auf dem 
; einen Rechtsklick machst. 
; Wenn Du den 2.Button mal normal (links) klickst, so daß er 
; den Focus hat, dann funktionieren auch SHIFT+F10 und VK_APPS 
; mit diesem Button. 
; 
; So kann man ganz einfach jedem Gadget ein eigenes RechtsKlick-Menu 
; geben, indem man im Callback einfach nur wParam auswertet (wie gezeigt). 
; Das fuktioniert dann immer mit RechtsKlick, mit SHIFT+F10 
; und VK_APPS - also Windows-Standard. 
; 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP