; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1316&highlight=
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 11. June 2003
; OS: Windows
; Demo: No


; String zwischen 2 Programmen übermitteln. 

; Changes by blbltheworm:
;   For testing compile the program and run it twice.
;   Then close one of the windows, so the "sender mode" will be activated.
;   Now the example can be tested...


; Änderungen von blbltheworm:
;   Zum Testen einfach das Programm compilieren und zweimal ausführen.
;   Eines der beiden Fenster schließen, dann wird der SenderModus aktiviert
;   Jetzt kann das Beispiel getestet werden

; EMPFÄNGER-PROGRAMM 
Procedure wcb(wnd, msg, wParam, lParam) 
    Result = #PB_ProcessPureBasicEvents 
    Select msg 
    Case 2000 
        Atom.l = wParam 
        Buffer$ = Space(1204) 
        GlobalGetAtomName_(Atom,Buffer$,1024) 
        MessageRequester("Meldung angekommen",Buffer$,0) 
        GlobalDeleteAtom_(Atom) 
    EndSelect 
    ProcedureReturn Result 
EndProcedure 

If OpenWindow(0, 100, 200, 195, 260, "TEST", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
    SetWindowCallback(@wcb()) 
    Repeat 
        EventID.l = WaitWindowEvent() 
        If EventID = #PB_Event_CloseWindow 
            Quit = 1 
        EndIf 
    Until Quit = 1 
EndIf 

Quit=0 ;<-added by blbltheworm


; SENDER-PROGRAMM 
If OpenWindow(0, 400, 200, 195, 260, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
    CreateGadgetList(WindowID(0)) 
    ButtonGadget(1,10,10,120,24,"Meldung senden") 
    Repeat 
        EventID.l = WaitWindowEvent() 
        If EventID = #PB_Event_Gadget 
            Select EventGadget() 
            Case 1 
                Atom.l = GlobalAddAtom_("Dieser Text kommt vom Sender") 
                SendMessage_(FindWindow_(0,"TEST"),2000,Atom,0) 
            EndSelect 
        EndIf 
        If EventID = #PB_Event_CloseWindow 
            Quit = 1 
        EndIf 
    Until Quit = 1 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
