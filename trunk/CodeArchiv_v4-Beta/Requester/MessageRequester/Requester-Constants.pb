; German forum:
; Author: Danilo
; Date: 14. November 2002
; OS: Windows
; Demo: Yes


; 14.11.2002 - by Danilo
;
;
; Flags fuer MessageRequester(Title$, Text$, Flags)
; -------------------------------------------------
;
; - gilt nur fuer PureBasic /Windows
; - API: MessageBox_() & MessageBoxEx_()
;
;
; [ Button-Typen ]
;
;                       #MB_OK = [OK]              ( --> 0 = Standard )
;                 #MB_OKCANCEL = [OK] [Abbrechen]
;
;                    #MB_YESNO = [Ja] [Nein]
;              #MB_YESNOCANCEL = [Ja] [Nein] [Abbrechen]
;
;              #MB_RETRYCANCEL = [Wiederholen] [Abbrechen]
;
;         #MB_ABORTRETRYIGNORE = [Abbrechen] [Wiederholen] [Ignorieren]
;        #MB_CANCELTRYCONTINUE = [Abbrechen] [Wiederholen] [Fortsetzen]  -  (erst ab Windows 98/2000)
;
;                     #MB_HELP = [Help] --> Help-Button (erst ab Windows NT4/95)
;                                Beim betätigen dieses Buttons wird die
;                                Windows-Message '#WM_HELP' an das Programm
;                                gesendet.
;
; [ Icons (Symbole/Bilder) ]
;
;                 #MB_ICONSTOP = Icon (X) : Stop
;                #MB_ICONERROR = Icon (X) : Stop (erst ab Windows NT4/95)
;                 #MB_ICONHAND = Icon (X) : Stop
;
;             #MB_ICONQUESTION = Icon (?) : Frage
;
;             #MB_ICONASTERISK = Icon (i) : Information
;          #MB_ICONINFORMATION = Icon (i) : Information
;
;              #MB_ICONWARNING = Icon (!) : Warnung (erst ab Windows NT4/95)
;          #MB_ICONEXCLAMATION = Icon (!) : Warnung
;
; [ Default Button ]
;
;               #MB_DEFBUTTON1 = 1. Button ist 'default' (selektiert)
;               #MB_DEFBUTTON2 = 2. Button ist 'default' (selektiert)
;               #MB_DEFBUTTON3 = 3. Button ist 'default' (selektiert)
;               #MB_DEFBUTTON4 = 4. Button ist 'default' (selektiert)  -  (erst ab Windows NT4/95)
;
; [ Prioritäten ]
;
;                #MB_APPLMODAL = User muss erst die MsgBox bestätigen
;                                ehe er mit dem Programm weiterarbeiten kann. (default)
;              #MB_SYSTEMMODAL = User muss erst die MsgBox bestätigen
;                                ehe er mit Windows weiterarbeiten kann.
;                                Dies soll nur bei schwerwiegenden Fehlern benutzt
;                                werden, durch die man evtl. nicht mehr Windows arbeiten
;                                kann - zum Beispiel wenn kein Speicher mehr vor-
;                                handen ist.
;
;                #MB_TASKMODAL = Das Gleiche wie #MB_APPLMODAL (generell), bloss werden
;                                hier auch andere Fenster des eigenen Tasks disabled.
;
; [ Verschiedenes ]
;
;                    #MB_RIGHT = Alle Texte rechtsbündig  -  (erst ab Windows NT4/95)
;            #MB_SETFOREGROUND = Die MsgBox wird in den Vordergrund gerückt
;                                (intern wird SetForegroundWindow_() aufgerufen)
;                  #MB_TOPMOST = MsgBox ist das oberste Fenster ('Stay-on-Top')  -  (erst ab Windows NT4/95)
;     #MB_SERVICE_NOTIFICATION = Das Programm ist ein Windows-Service und die MsgBox
;                                wird auch angezeigt, wenn kein User eingeloggt ist.  -  (nur Windows NT ab 4.0)
;               #MB_RTLREADING = Fenster ist an der Y-Achse gespiegelt
;                                (für arabische und hebräische Systeme)  -  (erst ab Windows NT4/95)
;
;
;
; [ RückgabeWerte ]
;
;                 #IDYES       = Ja (Yes)
;                 #IDNO        = Nein (No)
;                 #IDOK        = OK
;                 #IDABORT     = Abbrechen (Abort)
;                 #IDCANCEL    = Abbrechen (Cancel)
;                 #IDCONTINUE  = Fortsetzen (Continue)     ; (ab Windows 98/2000)
;                 #IDIGNORE    = Ignorieren (Ignore)
;                 #IDRETRY     = Wiederholen (Retry)
;                 #IDTRYAGAIN  = Wiederholen (Retry again) ; (ab Windows 98/2000)
;                            0 = Fehler, Funktion konnte nicht
;                                ausgeführt werden
;
;
#MB_CANCELTRYCONTINUE    = $00000006 ; (erst ab Windows 2000)
#MB_HELP                 = $00004000 ; (erst ab Windows NT4/95)
#MB_DEFBUTTON4           = $00000300 ; (erst ab Windows NT4/95)
#MB_RIGHT                = $00080000 ; (erst ab Windows NT4/95)
#MB_TOPMOST              = $00040000 ; (erst ab Windows NT4/95)
;#MB_SERVICE_NOTIFICATION = $00040000 ; (nur Windows NT ab 4.0)
#MB_RTLREADING           = $00100000 ; (erst ab Windows NT4/95)
#IDCONTINUE              = $0000000B ; (ab Windows 98/2000)
#IDTRYAGAIN              = $0000000A ; (ab Windows 98/2000)

Select MessageRequester("FEHLER", "Datei xyz konnte nicht gelesen werden !", #MB_ABORTRETRYIGNORE | #MB_ICONSTOP | #MB_DEFBUTTON2)
   Case #IDYES      : Result$ = "Ja (Yes)"
   Case #IDNO       : Result$ = "Nein (No)"
   Case #IDOK       : Result$ = "OK"
   Case #IDABORT    : Result$ = "Abbrechen (Abort)"
   Case #IDCANCEL   : Result$ = "Abbrechen (Cancel)"
   Case #IDCONTINUE : Result$ = "Fortsetzen (Continue)"     ; (ab Windows 98/2000)
   Case #IDIGNORE   : Result$ = "Ignorieren (Ignore)"
   Case #IDRETRY    : Result$ = "Wiederholen (Retry)"
   Case #IDTRYAGAIN : Result$ = "Wiederholen (Retry again)" ; (ab Windows 98/2000)
EndSelect

MessageRequester("Auswahl",Result$,0)
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -