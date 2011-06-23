; German forum: http://www.purebasic.fr/german/viewtopic.php?t=723&highlight=
; Author: hardy (updated for PB 4.00 by Andre)
; Date: 03. November 2004
; OS: Windows
; Demo: No

; Codebeispiel, in welchem das automatische Scrollen in einem Popupmenü funktioniert, 
; wenn sich der Mauszeiger über dem Pfeil im Menü befindet. 

;*************************************************************************************************** 
;*   erstellen Popupmenu                                                                           * 
;* =============================================================================================== * 
;*   - automatisches scrollen, wenn Maus auf Pfeilen                                               * 
;*************************************************************************************************** 


Global ia.l, winid, menuid, rec.RECT, curpos.POINT 

ia=99   ;itemanzahl    

Procedure WindowProc(hWnd,Msg,wParam,lParam) 

  Select Msg 

;   ------------   rechte maustaste im fenster gedrueckt   ------------ 

    Case #WM_RBUTTONDOWN 
      DisplayPopupMenu(0,WindowID(0),0,0) 
      
;   ------------   menuepunkt im popupmenu ausgewaehlt (maus ueber menupunkt)  ------------ 

    Case #WM_MENUSELECT 
      lw=wParam & $FFFF   ;loword: menupunkt-nummer 
;      Debug "menupunkt " + Str(lw) + " mouseselect" 
      menunr=lw 
      hw=wParam >> 16 & $8000   ;highword: bit für flag "mouseselect" filtern                          
;      Debug "flag " + Str(hw) 
      If hw=#MF_MOUSESELECT 
        Debug "wm_menuselect/mf_mouseselect: menupunkt = " + Str(lw) 
        Debug "lparam="+Str(lParam)   ;handle menue 
;        getmenuitemrect_(winid,menuid,menunr,rec) 
      EndIf 
      If hw=0   ;scroll-pfeil ausgewaehlt ? 
        Debug "pfeil" 
;       ------------   simuliere linke maustaste   ------------ 
        GetCursorPos_(cp.POINT) 
        mouse_event_(#MOUSEEVENTF_ABSOLUTE | #MOUSEEVENTF_LEFTDOWN, cp\x, cp\y,0,0)   ;simuliere linke maustaste 
;        Debug "autoscroll" 
      EndIf      
;    Case #pb_event_menu 
;      menuid=EventMenuID() 
;        Debug "menupunkt " + Str(menuid) + " mouseselect" 
      
;   ------------   menuepunkt geklickt   ------------    
      
    Case #WM_COMMAND 
      If (wParam >> 16 & $FFFF) = 0   ;hw/wparam=0: nachricht ist von menue 
        ;        Debug "wm_command: " + Str(wparam & $FFFF) 
        MessageRequester("","Menupunkt =" + Str(wParam & $FFFF),0) 
      EndIf  
      
      
  EndSelect 
  
ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 

;=================================================================================================== 
;=   Hauptprogramm                                                                                 = 
;=================================================================================================== 

winid=OpenWindow (0,200,200,600,400,"Test ...",#PB_Window_SystemMenu) 
SetWindowCallback(@WindowProc()) 

menuid=CreatePopupMenu(0) 
Debug "anzahl der menuepunkte = " + Str(ia) 
For z=1 To ia 
  MenuItem(z,"Menuepunkt " + Str(z)) 
Next 

Repeat 
  event=WaitWindowEvent() 
   Select event 
;     Case #pb_event_menu 
;       Debug "menuepunkt = " + Str(EventMenuID()) 
    Case #PB_Event_CloseWindow 
      quit=1 
  EndSelect 
Until quit=1 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -