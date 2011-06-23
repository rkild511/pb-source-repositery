; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=904&highlight=
; Author: CyberRun8 (updated for PB4.00 by blbltheworm + Andre)
; Date: 06. May 2003
; OS: Windows
; Demo: No

;IconFinder 0.2 von CyberRun8 
;für PureBasic 3.62 
;Mai 2003 
;Es sind noch ein paar kleine Schönheitsfehler vorhanden 
;und der Code ist noch nicht ganz vollständig, aber es funktioniert. 

;- Linked List 
Global NewList Dateiliste.s() 

;-Konstanten setzen 
#Window = 0 

#Menu   = 0 

#Gadget_TextFilter        =  0 
#Gadget_Filter            =  1 
#Gadget_Pfad              =  2 
#Gadget_PfadAuswahl       =  3 
#Gadget_Dateiliste        =  4 
#Gadget_DateilisteAktuell =  5 
#Gadget_Icon              =  6 
#Gadget_TextChangeListMod =  7 
#Gadget_ChangeListMod     =  8 
#Gadget_IconsZeigen       =  9 
#Gadget_ListeOhneIcons    = 10 
#Gadget_AuflistenAbbruch  = 11 
#Gadget_AuflistenStop     = 12 
#Gadget_Symboldaten       = 13 

#Verzeichnis = 0 

#Selbst    =  1 
#Definiert = -1 

;-Windowspfad ermitteln 
Windowspfad.s = Space(256) 
GetWindowsDirectory_(@Windowspfad, 256) 
Pfad.s = Windowspfad + "\" 

;-Fenster darstellen 
If OpenWindow(#Window, 0, 0, 790, 500, "IconFinder", #PB_Window_MinimizeGadget| #PB_Window_ScreenCentered) 
  If CreateMenu(#Menu, WindowID(#Window)) 
    MenuTitle("Menu") 
  EndIf 
  If CreateGadgetList(WindowID(#Window)) 
    TextGadget(#Gadget_TextFilter, 5, 7, 29, 20, "Filter:") 
    ComboBoxGadget(#Gadget_Filter, 35, 3, 55, 40) 
      AddGadgetItem(#Gadget_Filter, -1, "*.*") 
      AddGadgetItem(#Gadget_Filter, -1, "*.ico") 
      AddGadgetItem(#Gadget_Filter, -1, "*.exe") 
      AddGadgetItem(#Gadget_Filter, -1, "*.dll") 
      SetGadgetState(#Gadget_Filter, 0) 
    
    StringGadget(#Gadget_Pfad, 170, 3, 250, 21, Pfad, #PB_String_ReadOnly) 
    ButtonGadget(#Gadget_PfadAuswahl, 425, 3, 80, 21, "Pfad wählen") 
    
    ListIconGadget(#Gadget_Dateiliste, 2, 30, 165, 420, "Dateiauswahl", 165, #PB_ListIcon_MultiSelect) 
    ButtonGadget(#Gadget_DateilisteAktuell, 2, 454, 165, 21, "Dateien aktuallisiern") 
    
    ListIconGadget(#Gadget_Icon, 170, 30, 450, 420, "Icons", 45) 
      AddGadgetColumn(#Gadget_Icon, 1, "IconNr", 50) 
      AddGadgetColumn(#Gadget_Icon, 2, "Dateiname", 120) 
      AddGadgetColumn(#Gadget_Icon, 3, "Dateipfad", 240) 
    ButtonGadget(#Gadget_IconsZeigen, 170, 454, 100, 21, "Symbole auflisten") 
    ButtonGadget(#Gadget_AuflistenAbbruch, 271, 454, 120, 21, "Auflistung abbrechen") 
    DisableGadget(#Gadget_AuflistenAbbruch, #True) 
    ButtonGadget(#Gadget_AuflistenStop, 392, 454, 120, 21, "Auflistung anhalten") 
    DisableGadget(#Gadget_AuflistenStop, #True) 
    ButtonGadget(#Gadget_Symboldaten, 513, 454, 107, 21, "Daten des Symbols") 

    TextGadget(#Gadget_TextChangeListMod, 645, 434, 78, 20, "Symbol-Anzeige:") 
    ComboBoxGadget(#Gadget_ChangeListMod, 645, 454, 120, 40) 
      AddGadgetItem(#Gadget_ChangeListMod, -1, "großer Icon Modus") 
      AddGadgetItem(#Gadget_ChangeListMod, -1, "kleiner Icon Modus") 
      AddGadgetItem(#Gadget_ChangeListMod, -1, "List Modus") 
      AddGadgetItem(#Gadget_ChangeListMod, -1, "Standardmodus") 
      SetGadgetState(#Gadget_ChangeListMod, 3)  
    
    ListIconGadget(#Gadget_ListeOhneIcons, 623, 30, 165, 400, "Dateien ohne Icons", 165)              
  EndIf    
EndIf 

;-Schleife 
Repeat 
  EventID.l = WaitWindowEvent() 
  
  If EventID = #PB_Event_Menu 
    Select EventMenu() 
    EndSelect  
  EndIf 
  If EventID = #PB_Event_Gadget 
    Select EventGadget() 
      Case #Gadget_Filter 
        Filter$ = GetGadgetText(#Gadget_Filter) 
      Case #Gadget_PfadAuswahl 
        DateiName$ = PathRequester("Suchpfad wählen", Pfad) 
        If Dateiname$ <> "" 
          Pfad = Dateiname$ 
          SetGadgetText(#Gadget_Pfad, Pfad) 
          ClearGadgetItemList(#Gadget_Dateiliste) 
        EndIf 
      Case #Gadget_DateilisteAktuell 
        If ExamineDirectory(#Verzeichnis, Pfad, Filter$) 
          Quit = #False 
          ClearGadgetItemList(#Gadget_Dateiliste) 
          Repeat 
            If NextDirectoryEntry(#Verzeichnis) = 0 
              Quit = #True 
            ElseIf NextDirectoryEntry(#Verzeichnis) = 1 
              DateiName$ = DirectoryEntryName(#Verzeichnis) 
              AddGadgetItem(#Gadget_Dateiliste, -1, DateiName$) 
            EndIf 
          Until Quit = #True 
        EndIf
      Case #Gadget_ChangeListMod 
        Text$ = GetGadgetText(#Gadget_ChangeListMod) 
        If Text$ = "großer Icon Modus" 
          ChangeListIconGadgetDisplay(#Gadget_Icon, 0) 
        ElseIf Text$ = "kleiner Icon Modus" 
          ChangeListIconGadgetDisplay(#Gadget_Icon, 1) 
        ElseIf Text$ = "List Modus" 
          ChangeListIconGadgetDisplay(#Gadget_Icon, 2) 
        ElseIf Text$ = "Standardmodus" 
          ChangeListIconGadgetDisplay(#Gadget_Icon, 3)  
        EndIf 
      Case #Gadget_IconsZeigen 
        ClearGadgetItemList(#Gadget_Icon) 
        ClearGadgetItemList(#Gadget_ListeOhneIcons) 
        DisableGadget(#Gadget_AuflistenAbbruch, #False) 
        DisableGadget(#Gadget_AuflistenStop, #False) 
        Zaehler = 0 
        Ergebnis = CountGadgetItems(#Gadget_Dateiliste) 
        If Ergebnis = 0 
          MessageRequester("Info", "Bitte die Dateiliste aktuallisiern!", 0) 
        Else 
          For a = 0 To Ergebnis 
            If GetGadgetItemState(#Gadget_Dateiliste, a) = 1 
              AddElement(Dateiliste()) 
              Dateiliste() = GetGadgetItemText(#Gadget_Dateiliste, a, 0) 
              Zaehler + 1 
            EndIf 
          Next a 
          If Zaehler = 0 
            MessageRequester("Info", "Bitte Datei(en) auswählen!", 0) 
          Else 
            ResetList(Dateiliste()) 
            For a = 0 To Zaehler - 1 
              NextElement(Dateiliste()) 
              Position = 0 
              Repeat 
                EventID = WindowEvent() 
                If EventID = #PB_Event_Gadget 
                  Select EventGadget() 
                    Case #Gadget_AuflistenAbbruch 
                      a = Zaehler - 1 
                    Case #Gadget_AuflistenStop 
                      SetGadgetText(#Gadget_AuflistenStop, "Weiter auflisten") 
                      While weiter = #False 
                        EventID = WindowEvent() 
                        If EventID = #PB_Event_Gadget 
                          Select EventGadget() 
                            Case #Gadget_AuflistenStop 
                              weiter = #True 
                            Case #Gadget_AuflistenAbbruch 
                              a = Zaehler - 1 
                              weiter = #True    
                          EndSelect 
                        EndIf      
                      Wend 
                      SetGadgetText(#Gadget_AuflistenStop, "Auflistung anhalten") 
                      weiter = #False                      
                  EndSelect  
                EndIf  
                IconID = ExtractIcon_(0, Pfad + Dateiliste(), Position) 
                If IconID <> 0 
                  Text$ = "" + Chr(10) + Str(Position) + Chr(10) + Dateiliste() + Chr(10) + Pfad 
                  AddGadgetItem(#Gadget_Icon, -1, Text$, IconID) 
                EndIf 
                Position + 1    
              Until IconID = 0 
              If Position - 1 = 0 
                AddGadgetItem(#Gadget_ListeOhneIcons, -1, Dateiliste()) 
              EndIf    
            Next  
          EndIf        
        EndIf 
        DisableGadget(#Gadget_AuflistenAbbruch, #True) 
        DisableGadget(#Gadget_AuflistenStop, #True) 
        ClearList(Dateiliste()) 
      Case #Gadget_Symboldaten 
        ErgebnisSymboldaten = CountGadgetItems(#Gadget_Icon) 
        If ErgebnisSymboldaten = 0 
          MessageRequester("Info", "Es ist keine Symbolliste vorhanden", 0) 
        Else 
          For a = 0 To ErgebnisSymboldaten 
            If GetGadgetItemState(#Gadget_Icon, a) = 1 
              IconNr$ = GetGadgetItemText(#Gadget_Icon, a, 1) 
              Dateinname$ = GetGadgetItemText(#Gadget_Icon, a, 2) 
              Dateipfad$ = GetGadgetItemText(#Gadget_Icon, a, 3) 
              MessageRequester("Info des Symbols", "IconNr: " + IconNr$ + Chr(13) + "Dateiname: " + Dateinname$ + Chr(13) + "Dateipfad: " + Dateipfad$, 0)  
            EndIf 
          Next 
        EndIf    
    EndSelect 
  EndIf  
Until EventID = #PB_Event_CloseWindow 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
