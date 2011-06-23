; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1913&highlight=
; Author: ChaOsKid
; Date: 03. February 2005
; OS: Windows
; Demo: Yes


; String table for multi language support

; Stringtabelle für Mehrsprachigkeit 
; 
; Sprungmarken sind die Bezeichner 
; Sprachreihenfolge: de, en 

; Texte 
; Sprachen ( 0 = de, 1 = en ) 
Global currentLanguage.b 

; Deutsch 
currentLanguage = 0 

; Methode, um den richtigen String zu erhalten 
Procedure.s GetLanguageText(eintrag.l) 
  ; lokale Variable innerhalb der Funktion 
  Protected i.b 
  Protected returnString.s 
  ; springen zum richtigen Inhalt 
  Select eintrag 
    Case 1 
      Restore title 
    Case 2 
      Restore headline 
  EndSelect 
  ; entsprechenden String auslesen 
  For i = 0 To currentLanguage 
    Read returnString 
  Next 
  ProcedureReturn returnString 
EndProcedure 

MessageRequester("Deutsch",GetLanguageText(1) + " - " + GetLanguageText(2)) 
currentLanguage = 1 
MessageRequester("English",GetLanguageText(1) + " - " + GetLanguageText(2)) 


DataSection 
title: 
Data.s = "Hier der Titel", "Here the title" 
headline: 
Data.s = "Dies ist die Überschrift", "This is the headline" 
EndDataSection 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -