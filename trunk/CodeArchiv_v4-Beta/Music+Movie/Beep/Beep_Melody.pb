; www.purearea.net (Guestbook)
; Author: Rob
; Date: 01. December 2003
; OS: Windows
; Demo: No

;------
Procedure MelodieBeep(melodie.s)
  Repeat
    freq.l = Val(StringField(melodie,i+1,","))
    laeng.l = Val(StringField(melodie,i+2,","))
    i+2 
    If freq Or laeng : Beep_(freq,laeng) : EndIf 
  Until freq = 0 And laeng = 0
EndProcedure


MelodieBeep("393,200,526,200,526,200,526,200,678,100,526,100,440,200,440,200,440,200,580,100,526,100,493,200,580,100,493,100,393,200,440,100,493,100,526,200,526,200,526,200")
;-----------

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -