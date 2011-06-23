; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2409&highlight=
; Author: Werner Schieber
; Date: 28. September 2003
; OS: Windows
; Demo: Yes

; Sortierstring für Sortierung nach deutscher Norm konvertieren
; -------------------------------------------------------------
;1.  In Grossbuchstaben konvertieren
;2.  Deutsche Umlaute expandieren
;3.  Kovertierung mit Umsetzungstabelle
;      Akzente auf Buchstaben entfernen, d.h. in Bereich 65 bis 90 konvertieren
;      Sonderzeichen, die weder Ziffer noch Buchstabe sind durch Space ersetzen
;4.  Alle Spaces im String entfernen
;------------------------------------------------------------------------------------
Procedure.s sortierstring(quellstring.s)
  quellstring=UCase(quellstring)
  quellstring=ReplaceString(quellstring,"ß","SS")
  quellstring=ReplaceString(quellstring,"Ä","AE")
  quellstring=ReplaceString(quellstring,"Ö","OE")
  quellstring=ReplaceString(quellstring,"Ü","UE")
  
  Length.l = Len(quellstring)
  StringAusgabe.s = Space(Len(quellstring))
  For Pos.l = 0 To Length - 1
    ASCII.b = PeekB(@quellstring + Pos)
    Byte.b = PeekB(?Tabelle + ASCII & $FF)
    PokeB(@StringAusgabe + Pos, Byte)
  Next
  StringAusgabe=ReplaceString(StringAusgabe, Chr(32),"")
  
  ProcedureReturn StringAusgabe
  
  DataSection
  Tabelle:
  Data.b 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32
  Data.b 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32
  Data.b 32, 32, 32, 32, 32, 32, 32, 32, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 32, 32
  Data.b 32, 32, 32, 32, 32, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79
  Data.b 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 32, 32, 32, 32, 32, 32, 32, 32, 32
  Data.b 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32
  Data.b 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 83, 32
  Data.b 32, 32, 90, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 90, 89
  Data.b 32, 73, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32
  Data.b 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 65, 65, 65, 65, 65, 65, 65, 67
  Data.b 69, 69, 69, 69, 73, 73, 73, 73, 68, 78, 79, 79, 79, 79, 79, 32, 79, 85, 85, 85
  Data.b 85, 89, 80, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32
  Data.b 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32
  EndDataSection
EndProcedure


string.s = "Müller René"
string=sortierstring(string)

Debug string


End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
