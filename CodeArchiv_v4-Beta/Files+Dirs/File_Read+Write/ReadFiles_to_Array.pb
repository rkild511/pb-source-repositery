; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2211&highlight=
; Author: mutzel.man (updated for PB4.00 by blbltheworm)
; Date: 05. September 2003
; OS: Windows
; Demo: Yes


QuellDatei.s    = "TEST.TXT" 
DateiNr.l       = 1 
ZeilenAnzahl.l  = 0 
Dummy.s         = "" 


If ReadFile(DateiNr.l , QuellDatei.s) 
  ; prüfen ob Datei vorhanden und Zeilenanzahl ermitteln 
  ZeilenAnzahl.l = 0 
  Repeat 
    ZeilenAnzahl.l = ZeilenAnzahl.l + 1 
    Dummy.s = ReadString(DateiNr.l ) 
  Until Eof(DateiNr.l) 
  CloseFile(DateiNr.l) 
  MessageRequester("Zeilenanzahl", "Datei: " + QuellDatei.s + " Zeilenanzahl: " + Str(ZeilenAnzahl.l), 0) 

  ; Datein einlesen 
  Global Dim DateiInhalt.s(ZeilenAnzahl.l) 
  If ReadFile(DateiNr.l , QuellDatei.s) 
    ZeilenAnzahl.l = 0 
    Repeat 
      DateiInhalt.s(ZeilenAnzahl) = ReadString(DateiNr.l ) 
      ZeilenAnzahl.l = ZeilenAnzahl.l + 1 
    Until Eof(DateiNr.l) 
    CloseFile(DateiNr.l) 
    ; Datein ausgeben 
    For i = 0 To ZeilenAnzahl.l 
      Debug DateiInhalt.s(i) 
    Next i 
  Else 
    MessageRequester("Fehler", "Datei: " + QuellDatei.s + " kann nicht geöffnet werden !", 0) 
  EndIf 

Else 
  MessageRequester("Fehler", "Datei: " + QuellDatei.s + " kann nicht geöffnet werden !", 0) 
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
