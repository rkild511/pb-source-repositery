; www.purearea.net
; Author: Peter Heinzig (updated for PB4.00 by blbltheworm)
; Date: 24. October 2003
; OS: Windows
; Demo: No


; Original version for PureBasic 3.80
;
; Eine effektive Suche nach Programmierbeispielen ist für Anfänger und Fortgeschrittene wichtig.
; Dieses Programm realisiert die Suche in  *.pb - Dateien.
;
; Initial wird im PB - Verzeichnis und dessen Unterverzeichnissen nach einem String gesucht.
; Beachte: Setze in der 2. Programmzeile DEIN PureBasic-Verzeichnis ein!
; Das Suchverzeichnis kann mit "Auswahl" während der Laufzeit geändert werden (nicht die Initialisierung).
;
; Im Programm kann mit der Maus oder auch nur mit der Tastatur gearbeitet werden.
; Mit RETURN während der Suchstringeingabe wird die Suche sofort ausgelöst (ohne den Button "Suche").
;
; Dateien, die den Suchstring enthalten werden in der Liste angezeigt.
; Mit Doppelklick oder RETURN wird die markierte Datei im PB - Editor geöffnet.
; Dort kann mit STRG + F und anschließendem STRG + C nach dem Suchstring in der Datei gesucht werden.
;
; Ist die Voreinstellung im Editor "Starte nur eine Instanz" und der Editor bereits geöffnet, wird die Datei
; in einem neuem Karteikarten-Reiter geöffnet. Ist "Starte nur eine Instanz" nicht gesetzt, wird ein zweiter
; PB - Editor mit der Datei geöffnet.
;
; Es ist vorteilhaft, das Programm als Tool in den PB - Editor einzubinden (Tools, Konfiguriere Tools).
; Damit hat man schnellstmöglichen Zugriff auf das Werkzeug.
;
; Die Sprache im Programm wird aus "Purebasic.prefs" ermittelt, ist also gleich der Editorsprache.
; Einschränkung: Es ist nur Deutsch und Englisch realisiert (bei Editorsprache ungleich Deutsch
; wird immer Englisch initialisiert.
; Andere Sprachen können aber leicht hinzugefügt werden.
;===================================================================================

Global Such$, Verz$, l , Modus
Verz$ = "D:\PB\"             ;Setze Dein PureBasic-Verzeichnis ein! / Set the path to your PureBasic-directory here!

Declare SUCHE(Path$, Rek)
Declare SET(x)

;__________ Sprache, Texte _________________________________________________________
If OpenPreferences(Verz$ + "Purebasic.prefs") And PreferenceGroup("Global") ;Sprache des PB-Editors ermitteln
  Language$ = ReadPreferenceString("CurrentLanguage", "Deutsch") : ClosePreferences()
EndIf

DataSection
Deutsch:
Data.s " TextSuche in  <*.Pb> - Dateien", "Suche in:"+Chr(10)+"+ Unterverzeichnissen", "Suchen nach:"
Data.s "Beachte Groß-/"+Chr(10)+"Kleinschreibung", "&Auswahl", "SuchString", "suchstring", "&Suchen", "&Ende"
Data.s "NICHTS GEFUNDEN", "String gefunden in:","LESEFEHLER","Fehler!", "Bitte Suchstring eingeben"
Data.s "Markiere den Ordner, in dem gesucht werden soll"
English:
Data.s " TextSearch in  <*.Pb> - Files", "Search in:"+Chr(10)+"+ subdirectory","Search for:"    ;Please improve my English
Data.s "Case sensitive"+Chr(10)+"search", "Sele&ct","SearchString","searchstring","&Search","&End"
Data.s "NOTHING FOUND", "String found in:", "READ-MISTAKE", "MISTAKE", "Please input search-string"
Data.s "Choose the directory, in which you want search"
EndDataSection

If Language$ = "Deutsch" : Restore Deutsch : Else : Restore English : EndIf  
Global Dim txt.s(14) : For x=0 To 14: Read txt(x) : Next x

;__________ Fenster ________________________________________________________________
If OpenWindow(0, 0, 0, 400, 480,  txt(0), #PB_Window_ScreenCentered) = 0 : End : EndIf
If CreateGadgetList(WindowID(0)) = 0 : End : EndIf

ContainerGadget  (1,  10, 10, 380, 100, #PB_Container_Single) 
TextGadget            (2,     5,   5, 150, 28, txt(1))
TextGadget            (3,     5, 42, 100, 18, txt(2))
TextGadget            (4,     5, 65, 130, 28, txt(3))
StringGadget         (5, 120, 10, 160, 18, Verz$,#PB_String_ReadOnly)
ButtonGadget        (6, 290, 10,   80, 18, txt(4))
StringGadget         (7, 120, 40, 160, 18, txt(5))
ButtonGadget        (8, 290, 40,   80, 18, txt(7))
CheckBoxGadget(9, 120, 70,   30, 18, "  ")
ButtonGadget      (10, 290, 70,   80, 18, txt(8))
TextGadget          (11, 145, 70, 135, 18, txt(9), #PB_Text_Border | #PB_Text_Center) 
CloseGadgetList() 

x =  #PB_ListIcon_GridLines | #PB_ListIcon_AlwaysShowSelection | #PB_ListIcon_FullRowSelect 
ListIconGadget (12, 10, 125, 380, 345, txt(10), 800, x)

If Language$ = "Deutsch" : AddKeyboardShortcut(0, #PB_Shortcut_Alt | #PB_Shortcut_A, 6)    ;für Buttons
Else : AddKeyboardShortcut(0, #PB_Shortcut_Alt | #PB_Shortcut_C, 6) : EndIf
AddKeyboardShortcut(0, #PB_Shortcut_Alt | #PB_Shortcut_S, 8) 
AddKeyboardShortcut(0, #PB_Shortcut_Alt | #PB_Shortcut_E, 10) 
AddKeyboardShortcut(0, #PB_Shortcut_Return, 8)  ;für Return: wenn Focus in Liste = Öffnen Datei, sonst immer = Start Suche

SET(1)

;__________ Ereignisse _____________________________________________________________
Repeat
   Event = WaitWindowEvent()   
   If  Event = #PB_Event_Gadget Or Event =  #PB_Event_Menu
      Select  EventGadget()
   
         Case 6   ;----------------------------------------------------------- Button VerzeichnisWahl 
            Repeat : v$ = PathRequester(txt(14), Verz$) : Until v$<>"\" 
            If v$ : SetGadgetText(5, v$) : Verz$ = v$ : ClearGadgetItemList(12) : EndIf
            SET(1)
                  
         Case 7   ;----------------------------------------------------------- Eingabe Such$         
            If EventType() = #PB_EventType_Focus
               ClearGadgetItemList(12) : SET(1)
            ElseIf EventType() = #PB_EventType_Change
               HideGadget(11, 1)
            EndIf
            
         Case 8   ;----------------------------------------------------------- Button Suchen
            If Event =  #PB_Event_Menu And CountGadgetItems(12) : Goto M1     ;bei Enter in Listbox gehe zu Case 12
            Else            
               Such$ = GetGadgetText(7) : l = Len(Such$) : Modus = 0
               If GetGadgetState(9) = 0 : Such$ = LCase(Such$) : Modus = 1: EndIf
               If Such$ = txt(5) Or Such$ = txt(6) Or Such$ = ""
                  Beep_(0,0) : MessageRequester(txt(12),txt(13), 0) : SET(1)
               Else
                  ClearGadgetItemList(12) : SUCHE(Verz$, 0) 
                  If CountGadgetItems(12) : SetGadgetState(12, 0) : Else : Beep_(0,0) : SET(0) : EndIf
               EndIf
            EndIf
         
         Case 9    ;----------------------------------------------------------- Checkbox Groß/Kleinschreibung
            ClearGadgetItemList(12) : SET(1)

         Case 10  ;----------------------------------------------------------- Button Beenden
            Event = #PB_Event_CloseWindow
                        
         Case 12  ;----------------------------------------------------------- Liste
            If EventType() = #PB_EventType_LeftDoubleClick 
M1:        SetClipboardText(GetGadgetText(7))                    ;Such$ in ClipBoard. Nach Öffnen der Datei: STR+F, STR+V = Suche 
               RunProgram(GetGadgetText(12), "", "", 2 )           ;Datei in PB-Editor
            EndIf
            
      EndSelect
   EndIf
Until Event = #PB_Event_CloseWindow
End

;===================================================================================
Procedure SUCHE(Path$, Rek) 
   ExamineDirectory(Rek, Path$, "") 
   Repeat 
         Typ = NextDirectoryEntry(Rek) : Name$ = DirectoryEntryName(Rek) 
         If Typ = 1 And LCase(Right(Name$, 3)) = ".pb"  ;--------------------------- = gültige Datei
            If ReadFile(0, Path$ + Name$)                              ;SUCHE:                   
              FileLen = Lof(0) : Mem = AllocateMemory(FileLen+8) : ReadData(0,Mem, FileLen) : CloseFile(0)
               For x = Mem To Mem + FileLen - l
                If CompareMemoryString(x, @Such$ , Modus, l) = 0 
                     AddGadgetItem(12, -1, Path$ + Name$) 
                     Repeat : Until WindowEvent() = 0 : Break 
                  EndIf
               Next x
         Else : MessageRequester("", txt(11), 0) : EndIf
      ElseIf Typ = 2 And Name$ <> "." And Name$ <> ".."  ;------------------- = Unterverzeichnis
         SUCHE(UCase(Path$  + Name$) + "\", Rek + 1) : ;Rekursion
      EndIf 
   Until Typ = 0
EndProcedure 
;===================================================================================
Procedure SET(x)
   HideGadget(11, x) : SendMessage_(GadgetID(7),#EM_SETSEL, 0, -1) : SetActiveGadget(7)
   Repeat : Until WindowEvent() = 0  ;sofort ausführen                                                                                                                                       
EndProcedure 
;===================================================================================


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; UseIcon = D:\Bas2\Programme\EXE\Dateien\SM.ico
; Executable = D:\PB\Examples\AAA\PROG\Suchmaschine\Such.exe
; DisableDebugger