;*****************************************************************************
;*
;* Name   :  Punch Blitz
;* Author : Huitbit
;* Date   : 10 June 2009
;* Notes  : Old MSX code translated  ;)
;*
;*****************************************************************************
Macro c(a,b):ConsoleLocate(a,b):EndMacro:*z=AllocateMemory(1920):OpenConsole()
w=v:n.s="   ":EnableGraphicalConsole(1):a.s=" "+Chr(200)+Chr(205)+Chr(206)
For i=12 To 28:For j=23 To Random(5)+14 Step -1:PokeC(*z+i+j*40,1):c(i,j)
Print(Chr(178)):Next j:Next i:For y=0 To 23:For x=0 To 38:c(x,y):Print(a)
If x<37:If Inkey()<>"" And v=0:u=x+1:v=y+1:EndIf:EndIf:If PeekC(*z+x+4+y*40)
s=40*y+x:For i=y To 22:c(x+1,i):Print(n):c(x+1,i+1):Print(Right(a,3))
Delay(99):Next i:c(3,0):Print("SCORE : "+Str(s)):Input():End:EndIf:If v<>0
If v>23:v=0:EndIf:PokeC(*z+u+w*40,0):c(u,v-1):Print(" "):w=v:If v:c(u,v)
Print("*"):v=v+1:EndIf:EndIf:Delay(50):Next x:c(39,y):Print(n):Next y
c(3,0):Print("**MISSION ACCOMPLIE !**"):Input():End
; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 17
; Folding = -