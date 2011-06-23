; www.purearea.net
; Author: Sunny (updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: No


; Sourcecode geschrieben von Sunny - Datum: [22.11.03]
; F�r den uneingeschr�nkten freien Gebrauch


quit.b = 0                                                           ;Eine Byte Variable die Werte von - 128 bis + 127 haben kann,
                                                                     ;wir ben�tigen hier aber nur die Werte 0 und 1
                                                                     ;wenn die Variable den Wert 0 beibeh�lt, so soll nicht geschehen,
                                                                     ;wird die Variable aber zu 1, so soll die Hauptschleife unterbrochen werden
                                                                     ;und somit das Fenster geschlossen
                                                                   

If OpenWindow(0,150,300,200,200,"Fenster 1",#PB_Window_SystemMenu)   ;Ein neues Fenster Nr.0 wird ge�ffnet
  If OpenWindow(1,400,300,260,90,"Fenster 2",#PB_Window_SystemMenu)  ;Ein neues Fenster Nr.1 wird ge�ffnet
    If CreateGadgetList(WindowID(1))                                 ;Eine neue Gadgetliste wird angelegt
      ButtonGadget(0, 20, 20, 120, 20, "Fenster deaktivieren")       ;Das Buttongadget zum deaktivieren/ aktivieren wird erstellt
      ButtonGadget(1, 145, 50, 80, 20, "Best�tigen")                 ;Das Buttongadget zum Namen Best�tigen wird erstellt
      StringGadget(2, 20, 50, 120, 20, "Name eingeben")              ;Das Stringgadget f�r die Namenseingabe wird erstellt     
    EndIf
  EndIf
EndIf

  Repeat                                                            ;Die Hauptschleife l�uft best�ndig weiter
    EventID = WaitWindowEvent()                                      ;warten auf die Eingabe des Users

      Select EventID                                                ;Erstellt eine Kollektive-Abfrage des Ereignisses
        Case #PB_Event_CloseWindow                                  ;Wenn das Fenster-schlie�en Gadget gedr�ckt wurde
          quit = 1                                                   ;Die Variable zum Schlie�en auf 1 setzen
        
        Case #PB_Event_Gadget                                       ;Wenn ein Gadget gedr�ckt wurde

          Select EventGadget()                                      ;Wieder eine Kollektive Abfrage, welches Gadget wurde gedr�ckt?
            Case 0                                                  ;Wenn es Gadget 0 ist... (Gadget f�r Deaktivieren / Aktivieren)
              If EnableWindow_(WindowID(0), #False)                      ;Ist das Fenster deaktiviert...  (Die Konstante #False hat den Wert = 0, die Konstante #True den Wert = 1)
                EnableWindow_(WindowID(0), #True)                       ; so aktiviere es wieder
                SetGadgetText(0, "Fenster deaktivieren")             ;Und den Text des Gadgets �nder
              Else                                                  ;wenn das Fenster noch aktiviert ist...
                EnableWindow_(WindowID(0), #False)                       ;so deaktiviere das Fenster
                SetGadgetText(0, "Fenster aktivieren")               ;und wieder den Text des Gadgets �ndern
              EndIf  
            
            Case 1                                                  ;Wenn Gadget 1 gedr�ckt wurde (Gadget zum Namen�ndern)
              SetWindowText_(WindowID(0), GetGadgetText(2))          ;Dann den Text des Stringgadgets als neuen Titelzeilentext des Fensters 0 nehmen

          EndSelect                                                 ;Hier endet die kollektive Abfrage
      EndSelect                                                     ;Hier endet die kollektive Abfrage
      
  Until quit=1                                                       ;Wenn die Quit Variable = 1 ist, werden die Fenster geschlossen und das Programm beendet
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP