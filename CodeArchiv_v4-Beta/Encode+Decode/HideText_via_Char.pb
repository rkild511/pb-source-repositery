; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13553&highlight=
; Author: Pupil
; Date: 02. January 2005
; OS: Windows
; Demo: Yes

Dim Char.s(255)

Restore Characters
Read a$
For i = 1 To Len(a$)
  b$ = Mid(a$, i, 1)
  Char(Asc(b$)) = b$
Next

b$ = Char('H')+Char('e')+Char('l')+Char('l')+Char('o')

Debug b$
End

DataSection
  Characters:
  Data.s "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234546789"
EndDataSection

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -