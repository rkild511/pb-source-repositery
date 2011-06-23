; http://www.purebasic.com
; Author: Andre Beer / PureBasic Team (updated for PB4.00 by blbltheworm + Andre)
; Date: 14. November 2004
; OS: Windows
; Demo: Yes

; ---------------------------------------------------------------------------
;  PureBasic - "GadgetDemo" demonstrates the available gadgets in PureBasic
;  ************************************************************************
;                    (c) 2003 - Fantaisie Software
;
;      Created: 5-11th May 2003 by Andre Beer (andre@purebasic.com)
;       Thanks to David 'Tinman' McMinn for spell corrections :-)
; ---------------------------------------------------------------------------

;- Init values
#Lg = 200       ; auf 0 setzen für deutsche Lokalisierung, auf 200 für englische Lokalisierung
                ; set to 0 for german localization, set to 200 for english localization
                      
#WindowWidth  = 700
#WindowHeight = 530


;- * Localization
; Array für Lokalisierung definieren / create and fill array for localization
Global Dim loc$(400)
; Deutsch                             ; English
loc$(1)  = "Neu"                    : loc$(201) = "New"
loc$(2)  = "Öffnen"                 : loc$(202) = "Open"
loc$(3)  = "Speichern"              : loc$(203) = "Save"
loc$(4)  = "Drucken"                : loc$(204) = "Print"
loc$(5)  = "Suchen"                 : loc$(205) = "Search"
loc$(6)  = "Projekt"                : loc$(206) = "Project"
loc$(7)  = "Speichern als"          : loc$(207) = "Save as"
loc$(8)  = "Beenden"                : loc$(208) = "Quit"
loc$(9)  = "Bearbeiten"             : loc$(209) = "Edit"
loc$(10) = "Rückgängig"             : loc$(210) = "Undo"
loc$(11) = "Ausschneiden"           : loc$(211) = "Cut"
loc$(12) = "Kopieren"               : loc$(212) = "Copy"
loc$(13) = "Einfügen"               : loc$(213) = "Paste"
loc$(14) = "Suchen in ..."          : loc$(214) = "Search in ..."
loc$(15) = "Optionen"               : loc$(215) = "Options"
loc$(16) = "Zeichensatz auswählen"  : loc$(216) = "Choose font"
loc$(17) = "Farbe auswählen"        : loc$(217) = "Choose colour"
loc$(18) = "Pfad festlegen"         : loc$(218) = "Define path"
loc$(19) = "Sonstiges"              : loc$(219) = "Others"
loc$(20) = "Aktiviere Untermenü"    : loc$(220) = "Activate Sub-menu"
loc$(21) = "Untermenü"              : loc$(221) = "Sub-Menu"
loc$(22) = "Eintrag 1"              : loc$(222) = "Item 1"
loc$(23) = "Eintrag 2"              : loc$(223) = "Item 2"
loc$(24) = "Über..."                : loc$(224) = "About..."
loc$(25) = "Schalter"               : loc$(225) = "Button"
loc$(26) = "Erklärung zum Gadget Button"  : loc$(226) = "Description for Button Gadget"
loc$(27) = "Markierungsschalter"    : loc$(227) = "CheckBox Gadget"
loc$(28) = "Element 1"              : loc$(228) = "Item 1"
loc$(29) = "Element 2"              : loc$(229) = "Item 2"
loc$(30) = "Element 3"              : loc$(230) = "Item 3"
loc$(31) = "Element 4"              : loc$(231) = "Item 4"
loc$(32) = "Element 5"              : loc$(232) = "Item 5"
loc$(33) = "Spalte 2"               : loc$(233) = "Column 2"
loc$(34) = "Spalte 3"               : loc$(234) = "Column 3"
loc$(35) = "Zeile "                 : loc$(235) = "Line "
loc$(36) = " vom Listview"          : loc$(236) = " of the Listview"
loc$(37) = "Feld 1"                 : loc$(237) = "Field 1"
loc$(38) = "Feld 2"                 : loc$(238) = "Field 2"
loc$(39) = "Feld 3"                 : loc$(239) = "Field 3"
loc$(40) = "Frame3DGadget"          : loc$(240) = "Frame3DGadget"
loc$(41) = "Option 1"               : loc$(241) = "Option 1"
loc$(42) = "Option 2"               : loc$(242) = "Option 2"
loc$(43) = "Option 3"               : loc$(243) = "Option 3"
loc$(44) = "Info"                   : loc$(244) = "Info"
loc$(45) = "Panel 1"                : loc$(245) = "Panel 1"
loc$(46) = "Panel 2"                : loc$(246) = "Panel 2"
loc$(47) = "Schalter 1"             : loc$(247) = "Button 1"
loc$(48) = "Schalter 2"             : loc$(248) = "Button 2"
loc$(49) = "Schalter 3"             : loc$(249) = "Button 3"
loc$(50) = "Schalter 4"             : loc$(250) = "Button 4"
loc$(51) = "Allgemein "             : loc$(251) = "General "
loc$(52) = "Verzeichnis "           : loc$(252) = "Directory "
loc$(53) = "Datei 1"                : loc$(253) = "File 1"
loc$(54) = "Datei 2"                : loc$(254) = "File 2"
loc$(55) = "Datei 3"                : loc$(255) = "File 3"
loc$(56) = "Datei 4"                : loc$(256) = "File 4"
loc$(57) = "Datei "                 : loc$(257) = "File "
loc$(58) = "Dies ist ein SpinGadget."                     : loc$(258) = "This is a SpinGadget."
loc$(59) = "StringGadget - bitte Text eingeben..."        : loc$(259) = "StringGadget - please input some text..."
loc$(60) = "Dies ist ein TextGadget..."                   : loc$(260) = "This is a TextGadget..."
loc$(61) = "... und dies eins mit Rand und rechtsbündig"  : loc$(261) = "... and this one has a border and is right-aligned"
loc$(62) = "Beispiel für die Verwendung von DisableGadget()" : loc$(262) = "Example for the use of DisableGadget()"
loc$(63) = "Der Schalter wird gleich deaktiviert"         : loc$(263) = "This button will be disabled now"
loc$(64) = "und der Bildschalter (wieder) aktiviert..."   : loc$(264) = "and the image-button is enabled (again) ..."
loc$(65) = "Der Bildschalter wird gleich deaktiviert"     : loc$(265) = "The image-button will be disabled now"
loc$(66) = "und der normale Schalter (wieder) aktiviert..."  : loc$(266) = "and the normal button is enabled (again) ..."
loc$(67) = "Das Häkchen wurde soeben gesetzt."            : loc$(267) = "The check mark was just set."
loc$(68) = "Das Häkchen wurde soeben entfernt."           : loc$(268) = "The check mark was just removed."
loc$(69) = "Information zum Häkchen-Schalter"             : loc$(269) = "Information about the Checkbox-Gadget"
loc$(70) = "Es wurde nichts ausgewählt !"                 : loc$(270) = "Nothing was chosen !"
loc$(71) = "Sie haben folgenden Eintrag ausgewählt:"      : loc$(271) = "You have selected the following item:"
loc$(72) = "Index-Nr.: "                                  : loc$(272) = "Index-No.:"
loc$(73) = "  - Name des Eintrags: "                      : loc$(273) = "  - Name of the item: "
loc$(74) = "Information zur Auswahlbox"                   : loc$(274) = "Information about the ComboBox"
loc$(75) = "Information über das IPAddressGadget"         : loc$(275) = "Information about the IPAddressGadget"
loc$(76) = "Die eingegebene IP-Adresse lautet: "          : loc$(276) = "The entered IP-address is: "
loc$(77) = "Frage"                                        : loc$(277) = "Question"
loc$(78) = "Das Demo wirklich beenden ?"                  : loc$(278) = "Really quit the demo ?"
loc$(79) = "Weiter gehts..."                              : loc$(279) = "We go further..."
loc$(80) = "Sie haben Abbrechen angeklickt..."            : loc$(280) = "You have clicked Cancel..."
loc$(81) = "Sie haben sich für nein entschieden  :))"     : loc$(281) = "You have chosen No :))"
loc$(82) = "ListIcon Gadget"                              : loc$(282) = "ListIcon Gadget"
loc$(83) = "Lfd. Nummer des Eintrags: "                   : loc$(283) = "Current entry number: "
loc$(84) = "Inhalt: "                                     : loc$(284) = "Content: "
loc$(85) = "Information zum ListIconGadget"               : loc$(285) = "Information about the ListIconGadget"
loc$(86) = "Doppelter Mausklick: Eintrag "                : loc$(286) = "Double-click: Item "
loc$(87) = ", Text: "                                     : loc$(287) = ", Text: "
loc$(88) = "Hilfe"                                        : loc$(288) = "Help"
loc$(89) = "Dies ist ein ListIcon-Gadget!"                : loc$(289) = "This is a ListIcon gadget!"
loc$(90) = "ListView Gadget"                              : loc$(290) = "ListView Gadget"
loc$(91) = "Das Listview enthält "                        : loc$(291) = "The Listview contains "
loc$(92) = " Einträge"                                    : loc$(292) = " entries"
loc$(93) = "Information zum ListViewGadget"               : loc$(293) = "Information about the ListViewGadget"
loc$(94) = "Jetzt wollen wir den aktuell ausgewählten Eintrag im ListView entfernen..."
    loc$(294) = "Now we will remove the currently selected entry in the ListView..."
loc$(95) = "Na, sehen Sie ?"                              : loc$(295) = "Hm, you see ?"
loc$(96) = "Tomaten auf den Augen... ?   ;)"              : loc$(296) = "Tomatoes on the eyes... ?  ;)"
loc$(97) = "Damit das Listview aber nicht leer wird,"+Chr(10)+"müssen wir natürlich auch wieder einen Eintrag hinzufügen."
    loc$(297) = "Because the Listview shouldn't become empty"+Chr(10)+"we must of course add an entry again."
loc$(98) = "Das war ein kleines Beispiel im Umgang mit dem ListViewGadget."  
    loc$(298) = "This was a small example in the working with the ListViewGadget." 
loc$(99) = "keiner"                                       : loc$(299) = "none"
loc$(100) = "Information zum OptionGadget"                : loc$(300) = "Information about the OptionGadget"
loc$(101) = "Ausgewählter Eintrag: "                      : loc$(301) = "Selected entry: "
loc$(102) = "PanelGadget"                                 : loc$(302) = "PanelGadget"
loc$(103) = "Seite 1 des PanelGadget"                     : loc$(303) = "Page 1 of the PanelGadget"
loc$(104) = "Schalter 1 angeklickt."                      : loc$(304) = "Button 1 clicked."
loc$(105) = "Schalter 2 angeklickt."                      : loc$(305) = "Button 2 clicked."
loc$(106) = "Seite 2 des PanelGadget"                     : loc$(306) = "Page 2 of the PanelGadget"
loc$(107) = "Schalter 3 angeklickt."                      : loc$(307) = "Button 3 clicked."
loc$(108) = "Schalter 4 angeklickt."                      : loc$(308) = "Button 4 clicked."
loc$(109) = "TreeGadget"                                  : loc$(309) = "TreeGadget"
loc$(110) = "Information zum TreeGadget"                  : loc$(310) = "Information about the TreeGadget"
loc$(111) = "Dies ist ein Tree-Gadget!"+Chr(10)+Chr(10)+"Jetzt werde ich Ihnen ein Popup-Menü anzeigen...."
    loc$(311) = "This is a Tree-Gadget!"+Chr(10)+Chr(10)+"Now I will show you a popup-menu...."
loc$(112) = "Popup-Menü"                                  : loc$(312) = "Popup-Menu"
loc$(113) = "Eintrag "                                    : loc$(313) = "Item "
loc$(114) = "Information"                                 : loc$(314) = "Information"
loc$(115) = "Die Return-Taste wurde gedrückt."            : loc$(315) = "The Return key was pressed."
loc$(116) = "Der aktuelle Stand des Schiebereglers liegt bei "       : loc$(316) = "The current state of the trackbar is "
loc$(117) = "Information zum TrackBarGadget"              : loc$(317) = "Information about the TrackBarGadget"
loc$(118) = "Der aktuelle Stand des Fortschrittsbalkens liegt bei "  : loc$(318) = "The current state of the progressbar is "
loc$(119) = " von 50."                                    : loc$(319) = " of 50."
loc$(120) = "Information zum ProgressBarGadget"           : loc$(320) = "Information about the ProgressBarGadget"
loc$(121) = "Dies können wir jedoch auch einfach ändern:"+Chr(10)+"Mit den Befehlen SetGadgetState() und Random() setzen"+Chr(10)+"wir den Wert auf einen zufällig ermittelten neuen Wert."
    loc$(321) = "We could easily change this:"+Chr(10)+"With the commands SetGadgetState() and Random() we set"+Chr(10)+"the value to a new value determined by chance."
loc$(122) = "Bitte Datei zum Laden auswählen"             : loc$(322) = "Please choose file to load"
loc$(123) = "Alle Dateien"                                : loc$(323) = "All files"
loc$(124) = "Sie haben folgende Datei ausgewählt:"        : loc$(324) = "You have selected the following file:"
loc$(125) = "Der Requester wurde abgebrochen."            : loc$(325) = "The requester was cancelled."
loc$(126) = "Bitte Datei zum Speichern auswählen"         : loc$(326) = "Please choose file to save as"
loc$(127) = "Sie haben das erste der beiden selbst erstellten Toolbar-Icons angeklickt." : loc$(327) = "You have clicked on the first of the two self-created toolbar icons."
loc$(128) = "Sie haben das zweite der beiden selbst erstellten Toolbar-Icons angeklickt." : loc$(328) = "You have clicked on the second of the two self-created toolbar icons."
loc$(129) = "Text"                                        : loc$(329) = "Text"
loc$(130) = "Sie haben folgenden Zeichensatz ausgewählt:" : loc$(330) = "You have selected the following font:"
loc$(131) = "Name:  "                                     : loc$(331) = "Name:  "
loc$(132) = "Höhe:  "                                     : loc$(332) = "Height:  "
loc$(133) = "Information zum FontRequester"               : loc$(333) = "Information about the FontRequester"
loc$(134) = "Stil: "                                      : loc$(334) = "Style: "
loc$(135) = "Fett"                                        : loc$(335) = "Bold"
loc$(136) = "Kursiv"                                      : loc$(336) = "Italic"
loc$(137) = "Fett kursiv"                                 : loc$(337) = "Bold italic"
loc$(138) = "Standard"                                    : loc$(338) = "Standard"
loc$(139) = "Sie haben folgenden Farbwert ausgewählt:"    : loc$(339) = "You have selected the following color value:"
loc$(140) = "Rot:  "                                      : loc$(340) = "Red:   "
loc$(141) = "Grün: "                                      : loc$(341) = "Green: "
loc$(142) = "Blau: "                                      : loc$(342) = "Blue:  "
loc$(143) = "Information zum ColorRequester"              : loc$(343) = "Information about the ColorRequester"
loc$(144) = "Wählen Sie einen Dateipfad aus..."           : loc$(344) = "Choose a path..."
loc$(145) = "Information zum PathRequester"               : loc$(345) = "Information about the PathRequester"
loc$(146) = "Folgender Dateipfad wurde ausgewählt:"       : loc$(346) = "Following path was chosen:"
loc$(147) = "Diese Demo wurde für die PureBasic-Community geschaffen und soll"+Chr(10)+"Ihnen den Einstieg in die Programmierung von Windows-Oberflächen erleichtern."+Chr(10)+Chr(10)
    loc$(347) = "This demo was created for the PureBasic community and should help"+Chr(10)+"you get into the programming of Windows GUI interfaces more easily."+Chr(10)+Chr(10)
loc$(148) = "Sie haben die F1-Taste gedrückt."            : loc$(348) = "You have pressed the F1 button."
loc$(149) = "Sie haben die Esc-Taste gedrückt."           : loc$(349) = "You have pressed the Esc button."
loc$(150) = "Ausgewählter ToolBar- bzw. Menü-Eintrag: "   : loc$(350) = "Selected toolbar- or menu item: "
loc$(151) = "Dies ist ein ImageGadget..."                 : loc$(351) = "This is an ImageGadget..."
loc$(152) = "Dies ist ein ButtonImageGadget..."           : loc$(352) = "This is a ButtonImageGadget..."
loc$(153) = "Dies ist ein CheckBoxGadget..."              : loc$(353) = "This is a CheckBoxGadget..."
loc$(154) = "Dies ist ein ComboBoxGadget..."              : loc$(354) = "This is a ComboBoxGadget..."
loc$(155) = "Dies ist ein ListIconGadget..."              : loc$(355) = "This is a ListIconGadget..."
loc$(156) = "Dies ist ein ListViewGadget..."              : loc$(356) = "This is a ListViewGadget..."
loc$(157) = "Dies ist das erste OptionGadget..."          : loc$(357) = "This is the first OptionGadget..."
loc$(158) = "Dies ist ein PanelGadget..."                 : loc$(358) = "This is a PanelGadget..."
loc$(159) = "Dies ist ein TreeGadget..."                  : loc$(359) = "This is a TreeGadget..."
loc$(160) = "Dies ist ein StringGadget..."                : loc$(360) = "This is a StringGadget..."
loc$(161) = "Dies ist ein TrackBarGadget..."              : loc$(361) = "This is a TrackBarGadget..."
loc$(162) = "Dies ist ein ProgressBarGadget..."           : loc$(362) = "This is a ProgressBarGadget..."
loc$(163) = "Dies ist ein IPAddressGadget..."             : loc$(363) = "This is an IPAddressGadget..."


;- * OpenWindow
; Erstellen des gewünschten Fensters / Creation of the window
If OpenWindow(0, 100, 120, #WindowWidth, #WindowHeight, "PureBasic - Gadget Demonstration  (c) 2003-2004 by Fantaisie Software", #PB_Window_MinimizeGadget)

  ;- Graphics
  ; Laden der verwendeten Grafiken / Load graphics
  LoadImage(0, "Gfx\PureBasic.bmp")
  LoadImage(1, "Gfx\Map.bmp")
  LoadImage(2, "Gfx\Drive.bmp")
  LoadImage(3, "Gfx\File.bmp")
  LoadImage(4, "Gfx\New.ico")
  LoadImage(5, "Gfx\Save.ico")

  ;- ToolBar creating
  ; Erstellen der ToolBar-Leiste / Create the tool-bar
  If CreateToolBar(0, WindowID(0))                      ; ToolTop-Texte definieren / Define Tooltip texts
    ToolBarStandardButton(0, #PB_ToolBarIcon_New)  : ToolBarToolTip(0,0, loc$(1+#Lg))    ; Neu / New
    ToolBarStandardButton(1, #PB_ToolBarIcon_Open) : ToolBarToolTip(0,1, loc$(2+#Lg))    ; Öffnen / Open
    ToolBarStandardButton(2, #PB_ToolBarIcon_Save) : ToolBarToolTip(0,2, loc$(3+#Lg))    ; Speichern / Save
    ToolBarSeparator()
    ToolBarStandardButton(4, #PB_ToolBarIcon_Print) : ToolBarToolTip(0,4, loc$(4+#Lg))   ; Drucken / Print
    ToolBarStandardButton(10, #PB_ToolBarIcon_Find) : ToolBarToolTip(0,10, loc$(5+#Lg))  ; Suchen / Search
    ToolBarSeparator()
    ToolBarImageButton(11, ImageID(4))
    ToolBarImageButton(12, ImageID(5))
  EndIf

  ;-Menu creating
  ; Erstellen des Menüs / Create the menu
  If CreateMenu(0, WindowID(0))   ; ermittelt die eindeutige WindowID und erstellt darauf die neue Menüliste / get the unique WindowID and creates the new menu-list on it
    MenuTitle(loc$(6+#Lg))                 ; Projekt / Project
      MenuItem(0, loc$(1+#Lg))             ; Neu / New
      MenuItem(1, loc$(2+#Lg))             ; Öffnen / Open
      MenuItem(2, loc$(3+#Lg))             ; Speichern / Save
      MenuItem(3, loc$(7+#Lg))             ; Speichern als / Save as
      MenuBar()
      MenuItem(4, loc$(4+#Lg))             ; Drucken / Print
      MenuBar()
      MenuItem(5, loc$(8+#Lg))             ; Beenden / Quit
    MenuTitle(loc$(9+#Lg))                 ; Bearbeiten / Edit
      MenuItem(6, loc$(10+#Lg))            ; Rückgängig / Undo
      MenuItem(7, loc$(11+#Lg))            ; Ausschneiden / Cut
      MenuItem(8, loc$(12+#Lg))            ; Kopieren / Copy
      MenuItem(9, loc$(13+#Lg))            ; Einfügen / Paste
      MenuBar()
      MenuItem(10, loc$(14+#Lg))           ; Suchen in / Search in
    MenuTitle(loc$(15+#Lg))                ; Optionen / Options
      MenuItem(16, loc$(16+#Lg))           ; Zeichensatz auswählen / Choose font
      MenuItem(17, loc$(17+#Lg))           ; Farbe auswählen / Choose color
      MenuBar()
      MenuItem(18, loc$(18+#Lg))           ; Pfad festlegen / Define path
    MenuTitle(loc$(19+#Lg))                ; Sonstiges / Others
      MenuItem(13, loc$(20+#Lg))           ; Aktiviere Untermenü / Activate sub-menu
      OpenSubMenu(loc$(21+#Lg))            ; Untermenü / Sub-Menu
        MenuItem(14, loc$(22+#Lg))         ; Eintrag 1 / Item 1
        MenuItem(15, loc$(23+#Lg))         ; Eintrag 2 / Item 2
      CloseSubMenu()
      SetMenuItemState(0,13,1)    ; setzt Häkchen vor dem Menüeintrag "Aktiviere Untermenü" / set a check mark before the menu-item "Activate Sub-menu"
    MenuTitle("?")
      MenuItem(19, loc$(24+#Lg))           ; Über... / About...
  EndIf

  ;- Popup Menu
  If CreatePopupMenu(1)
    MenuTitle(loc$(112+#Lg))               ; Popup-Menü  /  Popup-Menu
      MenuItem(30, loc$(113+#Lg)+" 30")    ; Eintrag 30  /  Item 30
      MenuItem(31, loc$(113+#Lg)+" 31")    ; Eintrag 31  /  Item 31
      MenuItem(32, loc$(113+#Lg)+" 32")    ; Eintrag 32  /  Item 32
      MenuItem(33, loc$(113+#Lg)+" 33")    ; Eintrag 33  /  Item 33
      MenuBar()
      MenuItem(34, loc$(113+#Lg)+" 34")    ; Eintrag 34  /  Item 34
  EndIf

  ;- Keyboard shortcuts
  ; Festlegen der Tastenkürzel (u.a. für Menü-Einträge) / Define the keyboard shortcuts (for menu-items and more)
  AddKeyboardShortcut(0, #PB_Shortcut_Control | #PB_Shortcut_Z, 16)  ; STRG + Z: Rückgabewert 16 entspricht dem Menüeintrag "Zeichensatz auswählen"
  AddKeyboardShortcut(0, #PB_Shortcut_Control | #PB_Shortcut_F, 17)  ; STRG + F: Rückgabewert 17 entspricht dem Menüeintrag "Farbe auswählen"
  AddKeyboardShortcut(0, #PB_Shortcut_Control | #PB_Shortcut_P, 18)  ; STRG + P: Rückgabewert 18 entspricht dem Menüeintrag "Pfad festlegen"
  AddKeyboardShortcut(0, #PB_Shortcut_Control | #PB_Shortcut_I, 19)  ; STRG + I: Rückgabewert 19 entspricht dem Menüeintrag "Über..."
  AddKeyboardShortcut(0, #PB_Shortcut_F1, 500)                       ; F1:       Legt 500 als Rückgabewert für die "F1"-Taste fest
  AddKeyboardShortcut(0, #PB_Shortcut_Escape, 501)                   ; ÊSC:      Legt 501 als Rückgabewert für die "ESC"-Taste fest

  ;- Gadgets
  ; Erstellen der Gadgets / Create the gadgets
  If CreateGadgetList(WindowID(0))     ; ermittelt die eindeutige WindowID und darauf die neue Gadgetliste / get the unique WindowID and creates the new gadget-list on it
    #y=15   ; definiert zusätzlichen Abstand zum Fensterrand wegen der ToolBar-Leiste
    ButtonGadget     (1, 20,#y+ 20, 80, 24, loc$(25+#Lg))          ; Schalter / Button
    GadgetToolTip    (1, loc$(26+#Lg))                             ; Erklärung zum Gadget Schalter / Description for Button Gadget
    ButtonImageGadget(2, 20,#y+ 62,100, 83, ImageID(1))
    GadgetToolTip    (2,loc$(152+#Lg))                             ; Dies ist ein ButtonImageGadget. / This is a ButtonImageGadget.
    CheckBoxGadget   (3, 20,#y+160,120, 24, loc$(27+#Lg))          ; Markierungsschalter / CheckBox Gadget
    GadgetToolTip    (3,loc$(153+#Lg))                             ; Dies ist ein CheckBoxGadget. / This is a CheckBoxGadget.
    ComboBoxGadget   (4, 20,#y+200,130,100)
    GadgetToolTip    (4,loc$(154+#Lg))                             ; Dies ist ein ComboBoxGadget. / This is a ComboBoxGadget.
      AddGadgetItem  (4,-1,loc$(28+#Lg))                           ; Element 1 / Item 1
      AddGadgetItem  (4,-1,loc$(29+#Lg))                           ; Element 2 / Item 2
      AddGadgetItem  (4,-1,loc$(30+#Lg))                           ; Element 3 / Item 3
      AddGadgetItem  (4,-1,loc$(31+#Lg))                           ; Element 4 / Item 4
      ButtonGadget  (98,155,#y+200, 20, 22, "?")
    Frame3DGadget    (5, 20,#y+240,150, 40,loc$(40+#Lg),0)         ; Frame3DGadget
    IPAddressGadget  (6, 20,#y+300,120, 22)    
    GadgetToolTip    (6,loc$(163+#Lg))                             ; Dies ist ein IPAddressGadget. / This is a IPAddressGadget.
      ButtonGadget  (97,145,#y+300, 20, 22, "?")
    ImageGadget      (7, 20,#y+340,168, 35,ImageID(0))
    GadgetToolTip    (7,loc$(151+#Lg))                             ; Dies ist ein ImageGadget. / This is an ImageGadget.
    TextGadget      (99, 20,#y+395,168, 47,"Gadget Demonstration"+Chr(10)+"(c) 14.11.2004 by Andre Beer"+Chr(10)+"PureBasic Team",#PB_Text_Center|#PB_Text_Border)
      ButtonGadget  (96, 79,#y+450, 50, 22, "Exit")
    ListIconGadget   (8,220,#y+ 20,250, 80,loc$(37+#Lg),75)        ; Feld 1 / Field 1 of ListIcon
    GadgetToolTip    (8,loc$(155+#Lg))                             ; Dies ist ein ListIconGadget. / This is a ListIconGadget.
      AddGadgetColumn(8, 1, loc$(38+#Lg),75)                       ; Feld 2 / Field 2
      AddGadgetColumn(8, 2, loc$(39+#Lg),75)                       ; Feld 3 / Field 3
      AddGadgetItem  (8,-1, loc$(28+#Lg)+Chr(10)+loc$(33+#Lg)+Chr(10)+loc$(34+#Lg))   ; Element 1, Spalte 2, Spalte 3 / Item 1, Column 2, Column 3
      AddGadgetItem  (8,-1, loc$(29+#Lg)+Chr(10)+loc$(33+#Lg)+Chr(10)+loc$(34+#Lg))   ; Element 2 .... / Item 2 .....
      AddGadgetItem  (8,-1, loc$(30+#Lg)+Chr(10)+loc$(33+#Lg)+Chr(10)+loc$(34+#Lg))   ; Element 3 .... / Item 3 .....
      AddGadgetItem  (8,-1, loc$(31+#Lg)+Chr(10)+loc$(33+#Lg)+Chr(10)+loc$(34+#Lg))   ; Element 4 .... / Item 4 .....
      AddGadgetItem  (8,-1, loc$(32+#Lg)+Chr(10)+loc$(33+#Lg)+Chr(10)+loc$(34+#Lg))   ; Element 5 .... / Item 5 .....
    ListViewGadget   (9,220,#y+115,250, 80)
    GadgetToolTip    (9,loc$(156+#Lg))                             ; Dies ist ein ListViewGadget. / This is a ListViewGadget.
      For a=1 To 6
        AddGadgetItem  (9,-1,loc$(35+#Lg)+Str(a)+loc$(36+#Lg))   ; Listview Inhalt definieren / Define Listview content
      Next  
    OptionGadget    (10,220,#y+205, 60, 20,loc$(41+#Lg))        ; Option 1
    GadgetToolTip   (10,loc$(157+#Lg))                          ; Dies ist das erste OptionGadget. / This is the first OptionGadget.
    OptionGadget    (11,220,#y+223, 60, 20,loc$(42+#Lg))        ; Option 2
    OptionGadget    (12,220,#y+241, 60, 20,loc$(43+#Lg))        ; Option 3
      ButtonGadget  (94,220,#y+264, 60, 20,loc$(44+#Lg))        ; Info
      TextGadget    (95,300,#y+205,170, 60,"",#PB_Text_Border)     ; in dieses Textausgabe-Gadget erfolgen später Ausdrucke vom ListView und ListIcon /
                                                                   ; in this TestGadget the output of ListView and ListIcon will be displayed
    PanelGadget     (13,220,#y+295,250,80)
    GadgetToolTip   (13,loc$(158+#Lg))                  ; Dies ist ein PanelGadget. / This is a PanelGadget.
      AddGadgetItem (13,-1,loc$(45+#Lg))                ; "Panel 1" - Erstellen der ersten "Seite" des Panel-Gadgets / Creating of the first page of the PanelGadget
        ButtonGadget(93, 10, 15, 80, 24,loc$(47+#Lg))   ;             auf dieser Seite können jetzt beliebige weitere Gadgets eingefügt werden /
        ButtonGadget(92, 95, 15, 80, 24,loc$(48+#Lg))   ;             more gadgets can now be inserted into this page
      AddGadgetItem (13,-1,loc$(46+#Lg))                ; "Panel 2" - Erstellen der zweiten "Seite" des Panel-Gadgets / Creating of the second "site" of the PanelGadget
        ButtonGadget(91, 50, 15, 80, 24,loc$(49+#Lg))   ;             auf dieser Seite können jetzt beliebige weitere Gadgets eingefügt werden /
        ButtonGadget(90,135, 15, 80, 24,loc$(50+#Lg))   ;             more gadgets can now be inserted into this page
    CloseGadgetList()
    
    TreeGadget      (17,500,#y+ 20,170,150)
    GadgetToolTip   (17,loc$(159+#Lg))                              ; Dies ist ein TreeGadget. / This is a TreeGadget.
    For k=0 To 10
      AddGadgetItem (17, -1, loc$(51+#Lg)+Str(k), ImageID(3))      ; "Allgemein "  / "General "
      AddGadgetItem (17, -1, loc$(52+#Lg)+Str(k), ImageID(2))      ; "Verzeichnis" / "Directory "
        AddGadgetItem(17, -1, loc$(53+#Lg), ImageID(3),1)            ; Datei 1 / File 1
        AddGadgetItem(17, -1, loc$(54+#Lg), ImageID(3),1)            ; Datei 2 / File 2
        AddGadgetItem(17, -1, loc$(55+#Lg), ImageID(3),1)            ; Datei 3 / File 3
        AddGadgetItem(17, -1, loc$(56+#Lg), ImageID(3),1)            ; Datei 4 / File 4
      AddGadgetItem (17, -1, loc$(57+#Lg)+Str(k), ImageID(3))      ; Datei xx / File xx
    Next
    SpinGadget      (18,500,#y+185,170,24,0,1000)          ; 0 = Minimum, 1000 = Maximum
    SetGadgetState  (18,5) : SetGadgetText(18,"5")         ; Anfangswert einstellen / Set initial value
    GadgetToolTip   (18,loc$(58+#Lg))                      ; Dies ist ein SpinGadget. / This is a SpinGadget.
    StringGadget    (19,500,#y+225,173,24,loc$(59+#Lg))    ; StringGadget - bitte Text eingeben...  /  StringGadget - please input some text...
    GadgetToolTip   (19,loc$(160+#Lg))                     ; Dies ist ein StringGadget. / This is a StringGadget.
    TextGadget      (20,500,#y+260,173,20,loc$(60+#Lg))                                   ; Dies ist ein TextGadget...   /  This is a TextGadget...
    TextGadget      (21,500,#y+280,173,35,loc$(61+#Lg),#PB_Text_Right|#PB_Text_Border)    ; ... und dies eins mit Rand und rechtsbündig  /  ... and this one with border and right-aligned
    TrackBarGadget  (22,500,#y+325,157,24,0,100)
    GadgetToolTip   (22,loc$(161+#Lg))                             ; Dies ist ein TrackBarGadget. / This is a TrackBarGadget.
    SetGadgetState  (22,70)
      ButtonGadget  (88,662,#y+325, 20, 20, "?")
    ProgressBarGadget(14,500,#y+355,157,18,0,50)
    GadgetToolTip   (14,loc$(162+#lg))                             ; Dies ist ein ProgressBarGadget. / This is a ProgressBarGadget.
    SetGadgetState  (14,20)
      ButtonGadget  (89,662,#y+354, 20, 20, "?")
      
    ; Ermitteln des aktuellen Dateipfads  /  Get the current path
    Dir$ = GetCurrentDirectory()
    WebGadget       (23,220,#y+385,462,100,"file://"+Dir$+"Html\map.htm") 

    ;- * Event loop
    Repeat
      EventID.l = WaitWindowEvent()
    
      ;- Gadget events
      ; Hier folgt jetzt die Überprüfung auf aufgetretene Ereignisse bei den Gadgets...
      ; The following checks any gadget events which have been reported
      If EventID = #PB_Event_Gadget

        Select EventGadget()     ; Abfrage, bei welchem Gadget ein Ereignis auftrat (mit Hilfe der definierten Gadget-Nummer)
                                   ; Check, at which Gadget an event has appeared (with the help of the defined Gadget number)

          ; Gadgets der linken Spalte im Demo-Fenster / Gadgets in the left column in demo window
          Case 1   ; Schalter (Button)
            MessageRequester(loc$(62+#lg),loc$(63+#lg)+Chr(10)+loc$(64+#lg),0)   ; Info-Requester Schalter / Info requester button
            DisableGadget(2,0)  ; Aktiviert das Bild-Gadget  /  Activates the image-button
            DisableGadget(1,1)  ; Deaktiviert den "normalen" Schalter  /  Deactivates the "normal" button

          Case 2   ; Bild-Schalter (ButtonImage)
            MessageRequester(loc$(62+#lg),loc$(65+#lg)+Chr(10)+loc$(66+#lg),0)   ; Info-Requester Bild-Schalter / Info requester image-button
            DisableGadget(1,0)  ; Aktiviert den "normalen" Schalter  /  Activates the "normal" button
            DisableGadget(2,1)  ; Deaktiviert den Bild-Schalter  /  Deactivates the image-button
        
          Case 3   ; Häkchen-Schalter (CheckBox)
            If GetGadgetState(3) = 1    ; mit Häkchen   /  with check mark
              a$=loc$(67+#lg)      ; Das Häkchen wurde soeben gesetzt.  /  The check was just set.
            Else                        ; ohne Häkchen  /  without check mark
              a$=loc$(68+#lg)      ; Das Häkchen wurde soeben entfernt.  /  The check mark was just removed.
            EndIf
            MessageRequester(loc$(69+#lg),a$,0)    ; Information zum Häkchen-Schalter / Information about the Checkbox gadget
        
          Case 98   ; Fragezeichen beim Auswahl-Gadget (Question mark at the ComboBox gadget)
            a=GetGadgetState(4)
            If a = -1               ; nichts markiert  / nothing marked
              a$=loc$(70+#lg)       ;  Es wurde nichts ausgewählt !  /  There was nothing chosen !
            Else                    ; ein Eintrag wurde ausgewählt  /  an item was selected
              a$=loc$(71+#lg)+Chr(10)   ; "Sie haben folgenden Eintrag ausgewählt: / You have selected the following:  (Chr(10) fügt einen Zeilenumbruch hinzu / Chr(10) adds a linefeed)
              a$+loc$(72+#lg)+Str(a)+loc$(73+#lg)+GetGadgetText(4)   ; Index-Nr.: xx - Name des Eintrags: xx  /  Index-No.: xx - Name of the item: xx
            EndIf  
            MessageRequester(loc$(74+#lg),a$,0)   ; Information zur Auswahlbox / Information about the ComboBox
             
          Case 5   ; Frame3DGadget
            ; hier erfolgt keine Abfrage, da ein Anklicken des Frame3DGadgets nicht möglich ist
            ; dieses Gadget dient nur zur Verzierung, ist also "lediglich" ein graphisches Element
                ; no checks are made here, as clicking on the Frame3dGadget does not produce any event
                ; this gadget only serves for ornamentation, it's merely a graphical element
          Case 97  ; Fragezeichen beim IPAddressGadget  /  Question mark at the IPAddressGadget
            MessageRequester(loc$(75+#lg),loc$(76+#lg)+GetGadgetText(6),0)   
            ; Information über das IPAddressGadget, Die eingegebene IP-Adresse lautet: xx  /  Information about the IPAddressGadget, The entered IP-address is: xx

          Case 7   ; ImageGadget
            ; hier erfolgt kein Abfrage, das ein Anklicken des ImageGadgets nicht möglich ist
            ; dieses Gadget dient nur zur Verzierung, ist also "lediglich" ein graphisches Element
                ; no checks are made here, as clicking on the Frame3dGadget does not produce any event
                ; this gadget only serves for ornamentation, it's merely a graphical element

          Case 96  ; Exit...
            a = MessageRequester(loc$(77+#lg),loc$(78+#lg),#PB_MessageRequester_YesNoCancel)  ; Frage, Das Demo wirklich beeenden?  /  Question, Really quiting the Demo?
            If a = 6       ; Ja angeklickt...  /  Yes clicked
              EventID = #PB_Event_CloseWindow    ; die Bedingung der übergeordneten Repeat-Until Schleife wird damit erfüllt und das Programm beendet
                                                ; the condition of the main Repeat-Until loop is set to true and the program exits
            ElseIf a = 2   ; Abbrechen angeklickt  /  Cancel clicked
              MessageRequester(loc$(79+#lg),loc$(80+#lg),#PB_MessageRequester_Ok)
            Else           ; Nein angeklickt  (a = 7)   /  No clicked
              MessageRequester(loc$(79+#lg),loc$(81+#lg),#PB_MessageRequester_Ok)
            EndIf
          
          ; Gadgets der mittleren Spalte im Demo-Fenster  /  Gadgets of the middle column in the demo window
          Case 8   ; ListIcon
            SetGadgetText(95, loc$(82+#lg)+Chr(10)+"-------------------------"+Chr(10)+loc$(83+#lg)+Str(GetGadgetState(8))+Chr(10)+loc$(84+#lg)+GetGadgetText(8))  ; ListIcon Gadget, Lfd. Nummer des Eintrags:, Inhalt:  /  ListIcon Gadget, Current number of the entry:, Content:
            If EventType() = 2       ; Doppelter Mausklick  /  Double mouse click
              MessageRequester(loc$(85+#lg), loc$(86+#lg)+Str(GetGadgetState(8))+loc$(87+#lg)+GetGadgetText(8), 0)  ; Information zum ListIconGadget, Doppelter Mausklick: Eintrag xx, Text: xx  /  Information about the ListIconGadget, Double-click: Item xx, Text: xx
            ElseIf EventType() = 1   ; Rechter Mausklick  /  Right mouse click
              MessageRequester(loc$(88+#lg), loc$(89+#lg), 0)    ; Hilfe, Dies ist ein ListIcon-Gadget!  /  Help, This is a ListIcon gadget!
            EndIf

          Case 9   ; ListView
            SetGadgetText(95, loc$(90+#lg)+Chr(10)+"-------------------------"+Chr(10)+loc$(83+#lg)+Str(GetGadgetState(9))+Chr(10)+loc$(84+#lg)+GetGadgetText(9))
            If EventType() = 2        ; Doppelter Mausklick (entspricht #PB_EventType_LeftDoubleClick)  /  Double mouse click (correspond to #PB_EventType_LeftDoubleClick)
              a$=loc$(86+#lg)+Str(GetGadgetState(9))       ; ermittelt die Position des ausgewählten Eintrags, beginnend bei 0  /  find out the position of the selected entry, beginning at 0
              a$+loc$(87+#lg)+GetGadgetText(9)             ; ermittelt den (Text-) Inhalt des ausgewählten Eintrags  /  find out the (text-) content of the selected entry
              a$+Chr(10)                                   ; fügt einen Zeilenumbruch hinzu  /  adds a linefeed
              a$+loc$(91+#lg)+Str(CountGadgetItems(9))+loc$(92+#lg)   ; ermittelt die Anzahl der Einträge im Listview   /  find out the number of items in the listview
              MessageRequester(loc$(93+#lg),a$, 0)         ; Ausgabe der eben im String a$ gespeicherten Informationen...  /  Output of the informations just saved in the string a$...
              MessageRequester(loc$(90+#lg),loc$(94+#lg),0)
              RemoveGadgetItem(9, GetGadgetState(9))       ; entfernt das aktuelle Element im ListView  /  removes the current element in the listview
              a=MessageRequester(loc$(90+#lg),loc$(95+#lg),#PB_MessageRequester_YesNo)
              If a=7     ; mit Nein geantwortet  /  answered with No
                a$=loc$(96+#lg)
              Else       ; mit Ja geantwortet  /  answered with Yes
                a$=":)))"
              EndIf
              MessageRequester(loc$(90+#lg),a$,0)
              MessageRequester(loc$(90+#lg),loc$(97+#lg),0)
              AddGadgetItem(9,0,a$)   ; die 0 bestimmt die Position, an der neue Eintrag eingefügt wird - in diesem Fall an erster Stelle 
                                      ; genauso wäre eine höhere Zahl möglich oder -1, wenn der neue Eintrag an letzter Stelle eingefügt werden soll
                                         ; the 0 determines the position, at which a new entry is inserted - in this case in first place 
                                         ; higher numbers are also possible, or -1 if the new entry should be inserted at the end
              MessageRequester(loc$(90+#lg),loc$(98+#lg),0)
            EndIf

          Case 94   ; Info-Schalter bei den OptionGadgets  /  Info button at the OptionGadgets
            a$=loc$(99+#lg)             ; keiner  /  none
            If GetGadgetState(10) : a$ = GetGadgetText(10) : EndIf
            If GetGadgetState(11) : a$ = GetGadgetText(11) : EndIf
            If GetGadgetState(12) : a$ = GetGadgetText(12) : EndIf
            MessageRequester(loc$(100+#lg), loc$(101+#lg)+a$, 0)  ; Information zum OptionGadget, Ausgewählter Eintrag: xx  /  Information about the OptionGadget, Selected entry: xx
  
          Case 93
            MessageRequester(loc$(102+#lg), loc$(103+#lg)+Chr(10)+loc$(104+#lg), 0)   ; Seite 1 des PanelGadget, Schalter 1 angeklickt.  /  Page 1 of the PanelGadget, Button 1 clicked.
          Case 92
            MessageRequester(loc$(102+#lg), loc$(103+#lg)+Chr(10)+loc$(105+#lg), 0)   ; Seite 1 des PanelGadget, Schalter 2 angeklickt.  /  Page 1 of the PanelGadget, Button 2 clicked.
          Case 91  
            MessageRequester(loc$(102+#lg), loc$(106+#lg)+Chr(10)+loc$(107+#lg), 0)   ; Seite 2 des PanelGadget, Schalter 3 angeklickt.  /  Page 2 of the PanelGadget, Button 3 clicked.
          Case 90
            MessageRequester(loc$(102+#lg), loc$(106+#lg)+Chr(10)+loc$(108+#lg), 0)   ; Seite 2 des PanelGadget, Schalter 4 angeklickt.  /  Page 2 of the PanelGadget, Button 4 clicked.

         
          ; Gadgets der rechten Spalte im Demo-Fenster  /  Gadgets in the right column of demo-window
          Case 17    ; TreeGadget
            SetGadgetText(95, loc$(109+#lg)+Chr(10)+"--------------------"+Chr(10)+loc$(83+#lg)+Str(GetGadgetState(17))+Chr(10)+loc$(84+#lg)+GetGadgetText(17))  ; TreeGadget, Lfd. Nummer des Eintrags:, Inhalt:  /  TreeGadget, Current number of the entry:, Content:
            If EventType() = 2     ; Doppelter Mausklick  /  Double mouse click
              MessageRequester(loc$(110+#lg), loc$(86+#lg)+Str(GetGadgetState(17))+loc$(87+#lg)+GetGadgetText(17), 0)   ; Information zum TreeGadget, Doppelter Mausklick: Eintrag xx, Text: xx  /  Information about the TreeGadget, Double-click: Item xx, Text: xx
            ElseIf EventType() = 1
              MessageRequester(loc$(90+#lg), loc$(111+#lg), 0)
              DisplayPopupMenu(1, WindowID(0))
            EndIf

          Case 18    ; SpinGadget
            SetGadgetText(18,Str(GetGadgetState(18)))
            WindowEvent()      ; unbedingt erforderlich, um endlose Ereignissschleifen zu vermeiden  /  absolutely needed to avoid endless event-loops

          Case 19    ; String-Gadget
            If EventType() = #PB_EventType_ReturnKey
              MessageRequester(loc$(114+#lg), loc$(115+#lg), 0)   ; Information, Die Return-Taste wurde gedrückt.  /  Information, The Return key was pressed.
            EndIf

          Case 88   ; Fragezeichen neben dem TrackBarGadget  /  Question mark beside the TrackBarGadget
            a$=loc$(116+#lg)+Str(GetGadgetState(22))+"%."     ; Der aktuelle Stand des Schiebereglers liegt bei...  /  The current state of the trackbar is...
            MessageRequester(loc$(117+#lg), a$, 0)    ; Information zum TrackBarGadget  /  Information about the TrackBarGadget


          Case 89   ; Fragezeichen neben dem ProgressBarGadget  /  Question mark beside the ProgressBarGadget
            a$=loc$(118+#lg)+Str(GetGadgetState(14))+loc$(119+#lg)    ; Der aktuelle Stand des Fortschrittsbalkens liegt bei xx von 50.  /  The current state of the progressbar is xx of 50.
            MessageRequester(loc$(120+#lg), a$, 0)                    ; Information zum ProgressBarGadget  / Information about the ProgressBarGadget
            a$=loc$(121+#lg)                                          ; Dies können wir jedoch einfach ändern.....   /  This we could easily change...
            MessageRequester(loc$(120+#lg), a$, 0)
            SetGadgetState(14,Random(50))

        EndSelect
      EndIf 
      
      ;- Toolbar Menu events
      ; Überprüfen der Menü- UND Toolbar-Ereignisse
      ; ===========================================
      ; Dabei handelt es sich in diesem Beispiel um die gleichen Ereignisse (da die ToolBar-Piktogramme
      ; oftmals als "Shortcuts" für die entsprechenden Menü-Punkte dienen). Bei Verwendung der gleichen
      ; IDs für ToolBar- und Menüeinträge können mit EINER Abfrage die gleichen Operationen eingeleitet
      ; werden

      ; Detecting the Menu- AND Toolbar-events
      ; =========================================
      ; In this example we will get the same events (as the toolbar icons are often used as 
      ; "shortcuts" for the relating menu-items). When using the same IDs for ToolBar- and
      ; Menu-items it's easily possible to start the same operations with only ONE check.
      
      If EventID = #PB_Event_Menu
        Select EventMenu()
          Case 1
            Name$ = OpenFileRequester(loc$(122+#lg), "C:\autoexec.bat", loc$(129+#lg)+" (*.txt)|*.txt;*.bat|PureBasic (*.pb)|*.pb|"+loc$(123+#lg)+" (*.*)|*.*", 0)   ;  Bitte Datei zum Laden auswählen  /  Please choose file to load
            If Name$+Name$
              MessageRequester(loc$(114+#lg), loc$(124+#lg)+Chr(10)+Name$, 0)   ; Sie haben folgende Datei ausgewählt: xx  /  You have selected following file: xx
            Else
              MessageRequester(loc$(114+#lg), loc$(125+#lg), 0)   ; Der Requester wurde abgebrochen.  /  The requester was cancelled.
            EndIf
          Case 3
            Name$ = SaveFileRequester(loc$(126+#lg), "C:\autoexec.bat", loc$(129+#lg)+" (*.txt)|*.txt;*.bat|PureBasic (*.pb)|*.pb|"+loc$(123+#lg)+" (*.*)|*.*", 0)   ;  Bitte Datei zum Speichern auswählen  /  Please choose file to save as
            If Name$
              MessageRequester(loc$(114+#lg), loc$(124+#lg)+Chr(10)+Name$, 0)   ; Sie haben folgende Datei ausgewählt: xx  /  You have selected following file: xx
            Else
              MessageRequester(loc$(114+#lg), loc$(125+#lg), 0)   ; Der Requester wurde abgebrochen.  /  The requester was cancelled.
            EndIf
          Case 11
            MessageRequester(loc$(114+#lg),loc$(127+#lg),0)   ; das erste der beiden selbsterstellen Toolbar-Icons angeklickt  /  Clicked on first of the two self-created toolbar icons 
          Case 12
            MessageRequester(loc$(114+#lg),loc$(128+#lg),0)   ; das erste der beiden selbsterstellen Toolbar-Icons angeklickt  /  Clicked on first of the two self-created toolbar icons 
          Case 13
            If GetMenuItemState(0,13) = 1    ; Häkchen am Menüeintrag ist gesetzt   /  check mark at the menu-item is set
              SetMenuItemState(0,13,0) ; Häkchen entfernen          /  remove check mark
              DisableMenuItem(1,14,1)    ; Untermenü 1 deaktivieren   /  deactivate submenu 1
              DisableMenuItem(1,15,1)    ; Untermenü 2 deaktivieren   /  deactivate submenu 2
            Else                             ; Häkchen am Menüeintrag war nicht gesetzt   /  check mark at the menu-item is not set
              SetMenuItemState(0,13,1) ; Häkchen hinzufügen         /  add check mark
              DisableMenuItem(1,14,0)    ; Untermenü 1 aktivieren     /  activate submenu 1
              DisableMenuItem(1,15,0)    ; Untermenü 2 aktivieren     /  activate submenu 2
            EndIf
          Case 16    ; Zeichensatz auswählen  /  choose font
            If FontRequester("Courier", -13, 0)
              a$=loc$(130+#lg)+Chr(10)    ; Sie haben folgenden Zeichensatz ausgewählt:  /  You have selected the following font
              a$+loc$(131+#lg)+SelectedFontName()+Chr(10)        ; Name  /  Name
              a$+loc$(132+#lg)+Str(SelectedFontSize())+Chr(10)   ; Höhe  /  Height
              a$+loc$(134+#lg)                                   ; Stil  /  Style
              a.l=SelectedFontStyle()
;               If a = 42241       
;                 a$+loc$(135+#lg)     ; fett  /  bold
;               ElseIf a = 42497   
;                 a$+loc$(136+#lg)     ; kursiv  /  italic
;               ElseIf a = 42753  
;                 a$+loc$(137+#lg)     ; fett kursiv  /  bold italic
;               ElseIf a = 9217
;                 a$+loc$(138+#lg)     ; Standard  /  Standard
;               EndIf
              If a & #PB_Font_Bold   
                a$+loc$(135+#lg)     ; fett  /  bold
              ElseIf a & #PB_Font_Italic 
                a$+loc$(136+#lg)     ; kursiv  /  italic
              Else
                a$+loc$(138+#lg)     ; Standard  /  Standard
              EndIf
              
              ; a$+"Farbe: "+Str(SelectedFontColor())
              MessageRequester(loc$(133+#lg), a$, 0)      ; Information zum FontRequester  /  Information about FontRequester
            EndIf

          Case 17    ; Farbe auswählen  /  Select colour
            Farbe = ColorRequester()
            If Farbe > -1
              a$=loc$(139+#lg)+Chr(10)                    ; Sie haben folgenden Farbwert ausgewählt:  /  You have selected following color value
              a$+loc$(140+#lg)+Str(Red(Farbe))+Chr(10)    ; Rot   /  Red
              a$+loc$(141+#lg)+Str(Green(Farbe))+Chr(10)  ; Grün  /  Green
              a$+loc$(142+#lg)+Str(Blue(Farbe))           ; Blau  /  Blue
              MessageRequester(loc$(143+#lg), a$, 0)      ; Information zum ColorRequester  /  Information about the ColorRequester
            EndIf

          Case 18    ; Pfad festlegen  /  Choose path
            Pfad$ = PathRequester(loc$(144+#lg),"C:\")    ; Wählen Sie einen Dateipfad aus...  /  Choose a path...
            If Pfad$
              MessageRequester(loc$(145+#lg), loc$(146+#lg)+Chr(10)+Pfad$, 0)   ; Information zum PathRequester, Folgender Dateipfad wurde ausgewählt:  /  Information about the PathRequester, Following path was chosen:
            Else
              MessageRequester(loc$(145+#lg), loc$(125+#lg), 0)   ; Information zum PathRequester, Der Requester wurde abgebrochen.  /  Information about the PathRequester, The requester was cancelled.
            EndIf

          Case 19    ; Über - Requester  /  About requester
            a$=loc$(147+#lg)         ; Diese Demo wurde...  /  This demo was ...
            a$+"(c) Nov. 2004 by Andre Beer / Fantaisie Software"
            MessageRequester(loc$(24+#lg),a$,0)     ;  Über...  / About...
            
          Case 500   ; F1-Taste
            MessageRequester(loc$(114+#lg),loc$(148+#lg),0)   ; Sie haben die F1-Taste gedrückt.  /  You have pressed the F1 button.
            
          Case 501   ; ESC-Taste
            MessageRequester(loc$(114+#lg),loc$(149+#lg),0)   ; Sie haben die Esc-Taste gedrückt.  /  You have pressed the Esc button.

          Default
            MessageRequester(loc$(114+#lg),loc$(150+#lg)+Str(EventMenu()), 0)   ; Ausgewählter ToolBar- bzw. Menü-Eintrag: xx  /  Selected toolbar- or menu item: xx
        EndSelect  
      EndIf

    Until EventID = #PB_Event_CloseWindow
  EndIf 
EndIf

End  

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableAsm
; EnableXP
; Executable = M:\Documents and Settings\fred\Bureau\Gadget.exe