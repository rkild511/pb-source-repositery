; German forum:
; Author: Olli B (updated for PB 4.00 by Andre)
; Date: 12. December 2002
; OS: Windows
; Demo: Yes


;Anwendung Date Libary

Dim wochentag.s(6)

For a=0 To 6
  Read wochentag(a)
Next

DataSection
  Data.s "Sonntag","Montag","Dienstag","Mittwoch","Donnerstag","Freitag","Samstag"
EndDataSection

datum.s=FormatDate("%dd.%mm.%yyyy", Date())
tag.l=DayOfWeek(Date())
text.s="Heute ist "+wochentag(tag)+", der "+datum+Chr(10)


MessageRequester("Date",text,0)
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -