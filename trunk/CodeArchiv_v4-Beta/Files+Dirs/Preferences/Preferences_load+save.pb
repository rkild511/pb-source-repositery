; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2034&highlight=
; Author: NicTheQuick
; Date: 20. August 2003
; OS: Windows
; Demo: Yes

; Loading + saving preferences
; Laden + Speichern von Voreinstellungen

;Preferences auslesen (wenn noch nicht vorhanden, Standardwerte setzen) 
OpenPreferences("test.pref") 
  PreferenceGroup("Strings") 
    String1.s = ReadPreferenceString("String1", "Das ist der erste String") 
    String2.s = ReadPreferenceString("String2", "Das ist der zweite String") 
  PreferenceGroup("Longs") 
    Long1.l = ReadPreferenceLong("Long1", 1234) 
    Long2.l = ReadPreferenceLong("Long2", 5678) 
ClosePreferences() 

;Werte anzeigen 
Debug "String1: " + String1 
Debug "String2: " + String2 
Debug "Long1: " + Str(Long1) 
Debug "Long2: " + Str(Long2) 

;Andere Werte setzen 
String1 = "Blablabla Nummer 1" 
String2 = "lalala Nummer 2" 
Long1 = Random($FFFFFFF) 
Long2 = Random($FFFFFFF) 

;Preferences schreiben 
If CreatePreferences("test.pref") 
  PreferenceGroup("Strings") 
    WritePreferenceString("String1", String1) 
    WritePreferenceString("String2", String2) 
  PreferenceGroup("Longs") 
    WritePreferenceLong("Long1", Long1) 
    WritePreferenceLong("Long2", Long2) 
  ClosePreferences() 
EndIf
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
