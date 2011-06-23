; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=943&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 8. May 2003
; OS: Windows
; Demo: Yes

; Show / hide gadgets on request....

#VersionMajor = 0 
#VersionMinor = 2 

Procedure ExitQuestion() 
  If MessageRequester("FRAGE","Wollen Sie das Spiel"+Chr(13)+"wirklich schon verlassen ??",#MB_YESNO|#MB_ICONQUESTION) = #IDYES 
    ProcedureReturn #True 
  EndIf 
EndProcedure 

If OpenWindow(0,200,150,250,250,"Ping-Pong",#PB_Window_SystemMenu) 

  If CreateGadgetList(WindowID(0)) 
    ButtonGadget(2,50,200,150,20,"Programm Ende"):HideGadget(2,#True) ; Gadget verstecken 
  EndIf 

  If CreateMenu(0, WindowID(0)) 
    MenuTitle("Datei") 
    MenuItem( 1, "Neues Spiel") 
    MenuBar() 
    MenuItem( 5, "Ende") 
    MenuTitle("Hilfe") 
    MenuItem(3,"Hilfe") 
    MenuItem(4,"Version") 
  EndIf 

  Repeat 
    Select WaitWindowEvent() 
      Case #PB_Event_CloseWindow : eXit=ExitQuestion() 
      Case #PB_Event_Menu 
        Select EventMenu() 
          Case 1 ; Neues Spiel 
            :HideGadget(2,#False) ; Gadget anzeigen 
          Case 5 ; Ende 
            eXit=ExitQuestion() 
          Case 3 
            MessageRequester("HILFE","HILFE !!!!",0) 
          Case 4 
            MessageRequester("INFO","Ping-Pong Version: "+Str(#VersionMajor)+"."+Str(#VersionMinor)+Chr(13)+Chr(13)+"Copyright (c) 2003 by Cyby",#MB_ICONINFORMATION) 
        EndSelect 
    EndSelect 
  Until eXit 

EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
