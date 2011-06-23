; German forum:
; Author: Unknown
; Date: 31. December 2002
; OS: Windows
; Demo: Yes

tag$ = Str(Day(Date())) 
monat$ = Str(Month(Date())) 
jahr$ = Str(Year(Date())) 
stunde$ = Str(Hour(Date())) 
minute$ = Str(Minute(Date())) 
sekunde$ = Str(Second(Date())) 
datum$ = tag$+"."+monat$+"."+jahr$ 
zeit$ = stunde$+":"+minute$+":"+sekunde$ 
MessageRequester("Aktuelle Zeit",datum$+" "+zeit$,0) 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -