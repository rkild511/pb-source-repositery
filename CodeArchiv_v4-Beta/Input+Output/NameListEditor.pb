; German forum:
; Author: Herbi (updated for PB4.00 by blbltheworm)
; Date: 15. January 2003
; OS: Windows
; Demo: Yes


; ------------------------------------------------------------
;
;   PureBasic - Muster - Datei
;
; ------------------------------------------------------------

If OpenWindow(0, 100, 100, 600, 460, "Fenster", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget)
   ; hier muß ein Fenster geöffnet werden, um die Dialogelemente auch darstellen zu können.

  If CreateGadgetList(WindowID(0))
     ; hier wird die Dialogmaske oder Eingabemaske erstellt.
     ; zuerst die Eingabefelder
     TextGadget(1,    5, 50,  70, 25,  "Name :")
     StringGadget(2, 80, 50, 240, 25,  "")
     TextGadget(3,    5,100,  70, 25,  "Vorname : ")
     StringGadget(4, 80,100, 120, 25, "")
     
     ; hier werden die Buttons zur Kommunikation zwischen Dialog
     ; und Anwender erstellt.
     ButtonGadget(11, 5,  200, 60, 25,  "Speichern")
     ButtonGadget(12, 85, 200, 60, 25,  "Info")
     ButtonGadget(13,165, 200, 60, 25,  "Ende")
     
     ; hier noch eine Listbox, falls eine gebraucht wird.
     ; Andernfalls mit einem Semikolon auskommentieren
     
     ListViewGadget(30, 5, 280, 590, 160)
  EndIf   

  Repeat
    ; hier beginnt die Schleife zur Abfrage der Buttons
    ; das Programm soll ja reagieren, wenn der Anwender
    ; einen Button betätigt. Es soll ja ein Kreislauf sein, damit der
    ; Anwender mehr als einmal einen Button drücken kann. Deshalb verwendet
    ; man eine Wiederholungs - Schleife.
    ; WaitWindowEvent() wartet auf ein Ereignis, welches dann ausgewertet wird.
    EventID.l = WaitWindowEvent()
   Select EventID
      Case #PB_Event_CloseWindow
              ; hier wird beendet, wenn der Anwender das x rechts oben im Fenster
              ; anklickt. Quit wird wahr (siehe unten) und das Programm wird beendet.
              Quit = 1
      Case #PB_Event_Gadget
        Select EventGadget()
           ; Hier werden die oben vergebenen IDs ausgewertet. Dem Button Speichern
           ; haben wir die ID 11, dem Info die ID 12 , dem Ende Button die ID 13 und der
           ; Listbox die ID 30 oben gegeben.
           ; Ebenfalls ist hier der Platz, um eventuelle Checkboxen oder Radiobuttons
           ; abzufragen.
            Case 11
             ; Button 1 (Speichern)
             ; hier kann man entweder direkt den Code eingeben.
             ; Zur besseren Übersichtlichkeit bietet sich aber
             ; ein Unterprogramm an, also gehe zu Unterprogramm 1 (UProg1)
             Gosub UProg1
             Case 12
             ; Button 2 (Info Button)
             ; Gehe zu Unterprogramm Unterprogramm2
             Gosub UProg2
           Case 13
             ; Button 3 (Ende Button)
             ; hier wird die Variable "Quit" gleich 1 gesetzt und somit wahr
             ; Das veranlaßt das Programm, aus der Schleife herauszugehen (Until Quit = 1)
             ; Da hinter der Schleife, außer dem schließenden Endif nur noch  End steht,
             ; wird das Programm beendet.
             Quit = 1
             
           Case 30
             ; Listbox
             ; wenn nicht gebraucht, den Case 30  - Zweig einfach löschen
             
             Gosub Listbox1
        EndSelect           
    EndSelect

  Until Quit = 1
 
EndIf

End   

UProg1:
  ; In dieses Unterprogramm kann man seinen Quellcode zum Reagieren des Buttons Speichern
  ; hineinschreiben.
  ; Ich lese hier mal die zwei Eingabefelder (Name, Vorname) aus und setze sie
  ; als String in die Listbox
  name.s    = GetGadgetText(2)
  vorname.s = GetGadgetText(4)
  ; hier frage ich ab, ob im Eingabefeld Name etwas hineingeschrieben wurde.
  ; wenn nichts eingegeben wurde, schreibe ich einfach "Kein Eintrag" in die Listbox.
  If name <> ""
      AddGadgetItem(30, -1, vorname + "   " + name)
  Else
      AddGadgetItem(30, -1, "Kein Eintrag !")
  EndIf     
  ; Position -1 setzt den String ans Ende des letzten Eintrages in der Listbox
Return

UProg2:
  ; hier kommt der Quellcode für den Info - Button hinein
  MessageRequester("Info !", "Info Button gedrückt !" + Chr(13) + "Gruß von Pure Basic !", #PB_MessageRequester_Ok)

Return

Listbox1:
  ; wenn der Anwender einen Eintrag in der Listbox angeklickt hat,
  ; kann mit GetGadgetState(30) die Nummer des Eintrages ermittelt werden.
  ; Auch der ausgewählte String kann mit GetGadgetItemText() gelesen werden.
  
  num.l = GetGadgetState(30)
  zeile.s =  GetGadgetItemText(30, num, 0)
  ; Als Spaltennummer kann hier 0 oder 1 eingesetzt werden, da bei einer Listbox theoretisch
  ; nur eine Spalte (als ganzer String) existiert. Beim ListIcon Gadget kann das anders sein.
  
  MessageRequester("Listview !", zeile, #PB_MessageRequester_Ok)
Return

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger