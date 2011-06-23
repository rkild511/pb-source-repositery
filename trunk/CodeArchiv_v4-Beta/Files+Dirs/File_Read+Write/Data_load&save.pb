; German forum:
; Author: Olli B (updated for PB4.00 by blbltheworm)
; Date: 02. August 2002
; OS: Windows
; Demo: Yes


;Weiteres über Daten laden und speichern
;von Olli, August 2002


;Variablen definieren
Global Dim text$(100):Global anzahl

;Fenster und Gadget-Liste
If OpenWindow(0,100,100,400,520,"Daten laden/speichern",#PB_Window_SystemMenu)
  If CreateGadgetList(WindowID(0))
    ButtonGadget(1,20,20,100,20,"Laden")
    ButtonGadget(2,140,20,100,20,"Speichern")
    ButtonGadget(3,260,20,100,20,"Löschen")
    ListViewGadget(4,20,60,360,380)
    ButtonGadget(5,20,460,150,20,"Ein Element hinzufügen")
    ButtonGadget(6,240,460,140,20,"Letztes Element löschen")
  EndIf
Else
  MessageRequester("","Fenster konnte nicht geöffnet werden!",0)
EndIf

;StatusBar öffnen
If CreateStatusBar(0,WindowID(0))
  AddStatusBarField(500)
EndIf

;Laden
Procedure Laden()
If ReadFile(1,"Daten.txt")
  anzahl=Val(ReadString(1))
  For a=0 To anzahl
    text$(a)=ReadString(1)
    AddGadgetItem(4,-1,text$(a))
  Next
CloseFile(1)
StatusBarText(0,0,"Daten erfolgreich geladen "+FormatDate("%hh:%ii:%ss", Date()),#PB_StatusBar_Center )
EndIf
EndProcedure

;Speichern
Procedure Speichern()
If OpenFile(1,"Daten.txt")
  WriteStringN(1,Str(anzahl))
  For a=0 To anzahl
    WriteStringN(1,text$(a))
  Next
CloseFile(1)
StatusBarText(0,0,"Daten erfolgreich gespeichert "+FormatDate("%hh:%ii:%ss", Date()),#PB_StatusBar_Center )
EndIf
EndProcedure

;Zum eigentlichen Programmstart: Laden aufrufen
Laden()

;Das erste Element der Liste aktivieren
SetGadgetState(4,0)


Repeat
  EventID.l = WaitWindowEvent()
    If EventID = #PB_Event_Gadget
      
      ;Schalter LADEN
      If EventGadget()=1
        ClearGadgetItemList(4):Laden()
      EndIf
      
      ;Schalter SPEICHERN
      If EventGadget()=2
        Speichern()
      EndIf      
      
      ;Schalter LISTE LÖSCHEN
      If EventGadget()=3
        ClearGadgetItemList(4)
        StatusBarText(0,0,"Liste gelöscht "+FormatDate("%hh:%ii:%ss", Date()),#PB_StatusBar_Center )
      EndIf
      
      ;Schalter NEUER EINTRAG
      If EventGadget()=5
        anzahl=anzahl+1
        text$(anzahl)="Neuer Eintrag "+FormatDate("%hh:%ii:%ss", Date())
        AddGadgetItem(4,anzahl,text$(anzahl))
      EndIf
      
      ;Schalter LETZTEN EINTRAG LÖSCHEN
      If EventGadget()=6
      If anzahl>=0
        RemoveGadgetItem(4,anzahl)
        anzahl=anzahl-1
      EndIf
      EndIf
             
     EndIf

Until EventID = #PB_Event_CloseWindow   

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger