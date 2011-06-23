; German forum:
; Author: Unknown (updated for PB4.00 by blbltheworm + Andre)
; Date: 02. March 2003
; OS: Windows
; Demo: No

;Das Gleiche wie SetGadgetText, ausser das Flackern verhindert wird! 
Procedure.l SetGadgetText2(GadgetID.l,Text.s) 
  If GetGadgetText(GadgetID)<>Text 
    SetGadgetText(GadgetID,Text) 
  EndIf 
EndProcedure 


;------------------------------------------------------------ 
;CODE 
;------------------------------------------------------------ 

;Definition von Strukturen 
Structure _POINTAPI 
  X.l 
  Y.l 
EndStructure 
Structure _RECT 
  Left.l 
  Top.l 
  Right.l 
  Bottom.l 
EndStructure 

;Prozedur um zu ermitteln, ob sich ein Element an einer Position befindet! 
Procedure.s _MouseOverM(PopupMenu.l,X.l,Y.l) 
  Gefunden.l=1 
  ThisMenu.l=0 
  Ergebnis.s="" 
  FoundThisRound.l=0 
  Repeat 
    ret=GetMenuItemRect_(0,PopupMenu,ThisMenu,R._RECT) 
    If ret=0 
      Gefunden=0 
    Else 
      If X>=R\Left And X<=R\Right 
        If Y>=R\Top And Y<=R\Bottom And FoundThisRound=0 
          Ergebnis.s+Str(ThisMenu+1)+"," 
          FoundThisRound=1 
        EndIf 
      EndIf 
      If GetSubMenu_(PopupMenu,ThisMenu)<>0 And FoundThisRound=0 
        Res.s=_MouseOverM(GetSubMenu_(PopupMenu,ThisMenu),X,Y) 
        If Res<>"" 
          Ergebnis+Str(ThisMenu+1)+","+Res 
        EndIf 
      EndIf 
      ThisMenu+1 
    EndIf 
  Until Gefunden=0 
  ProcedureReturn Ergebnis 
EndProcedure 

;Prozedur um das Item unter der Mausposition zu ermitteln! 
Procedure.s GetMouseOverMenu(PopupMenu.l) 
  GetCursorPos_(Position._POINTAPI) 
  Res.s=_MouseOverM(PopupMenu,Position\X,Position\Y) 
  If Res<>"" 
    ProcedureReturn Left(Res,Len(Res)-1) 
  Else 
    ProcedureReturn "" 
  EndIf 
EndProcedure 

;Diese Prozedur wird als Thread gestartet und bearbeitet die Ereignise des Popup-Fensters 
Procedure.l ShowPopupInfo(PopupMenu.l) 
  Repeat 
    MouseOverMenu.s=GetMouseOverMenu(PopupMenu) 
    
    ;Überprüfen, was ausgewählt wurde 
    Select MouseOverMenu 
      Case "":SetGadgetText2(0,"Die Maus ist NICHT über dem Fenster") 
      Case "1":SetGadgetText2(0,"Die Maus ist über ITEM 1 (Kopieren)") 
      Case "2":SetGadgetText2(0,"Die Maus ist über ITEM 2 (Einfügen)") 
      Case "3":SetGadgetText2(0,"Die Maus ist über ITEM 3 (Ausschneiden)") 
      Case "4":SetGadgetText2(0,"Die Maus ist über ITEM 4 (Trennungslinie)") 
      Case "5":SetGadgetText2(0,"Die Maus ist über ITEM 5 (Optionen)") 
      Case "5,1":SetGadgetText2(0,"Die Maus ist über ITEM 5,1 (Einstellungen)") 
      Case "5,2":SetGadgetText2(0,"Die Maus ist über ITEM 5,2 (Anderes)") 
      Case "5,3":SetGadgetText2(0,"Die Maus ist über ITEM 5,3 (Irgendetwas)") 
      Case "5,3,1":SetGadgetText2(0,"Die Maus ist über ITEM 5,3,1 (SubMenu)") 
      Case "6":SetGadgetText2(0,"Die Maus ist über ITEM 6 (Trennungslinie)") 
      Case "7":SetGadgetText2(0,"Die Maus ist über ITEM 7 (Beenden)") 
    EndSelect 
    
  ForEver 
EndProcedure 


;------------------------------------------------------------ 
;BEISPIEL 
;------------------------------------------------------------ 

;Erstelle das PopupMenü (DAS ERGEBNIS MUSS IN EINER VARIABLE GESPEICHERT WERDEN!) 
MeinPopupFenster.l =  CreatePopupMenu(0) 
If MeinPopupFenster 
  MenuItem(1, "Kopieren") 
  MenuItem(2, "Einfügen") 
  MenuItem(3, "Ausschneiden") 
  MenuBar() 
  OpenSubMenu("Optionen") 
    MenuItem(6, "Einstellungen") 
    MenuItem(7, "Anderes") 
    OpenSubMenu("Irgendetwas") 
      MenuItem(9, "SubMenu") 
    CloseSubMenu() 
  CloseSubMenu() 
  MenuBar() 
  MenuItem( 11, "Beenden") 
EndIf 

If OpenWindow(0, 100, 100, 300, 260, "PopupMenu Beispiel", #PB_Window_SystemMenu) 
  
  CreateGadgetList(WindowID(0)) 
  TextGadget(0,0,0,300,260,"Klicken sie mit der rechten Maustaste auf das Fenster um das Popup-Menü anzuzeigen!",0) 
  
  Repeat 
  
      Select WaitWindowEvent() 
          
        Case #WM_RBUTTONDOWN 
          ;ERSTELLT EINEN THREAD, DER IM HINTERGRUND LÄUFT! 
          ThreadID=CreateThread(@ShowPopupInfo(),MeinPopupFenster) 
          DisplayPopupMenu(0, WindowID(0)) 
          ;LÖSCHT DEN THREAD 
          KillThread(ThreadID) 
            
        Case #PB_Event_Menu 
        
          MessageRequester("KLICK!","Es wurde auf das Popup-Fenster geklickt!",0) 
          
        Case #PB_Event_CloseWindow 
          Quit = 1 
  
      EndSelect 
  
    Until Quit = 1 
  
EndIf 

End   

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -