;*****************************************************************************
;*
;* Name   : Stupidnoid
;* Author : Zikitrake
;* Date   : 18 June 2009
;* Notes  : Calls Win API, so only for Windows(ReadConsoleOutputCharacter_())
;*
;*****************************************************************************

Macro P(a,b):ConsoleLocate(a,b):EndMacro:OpenConsole():EnableGraphicalConsole(1)
For y=0 To 5:P(10,y*2):Print(LSet("=",60,"=")):Next:px=20:X=px:Y=23
Dx=1:Dy=-1:Macro ENDE():P(30,11):Print(" GAME OVER "):Input():CloseConsole()
End:EndMacro:Repeat:P(0,0):Print("POINTS:"+Str(PT)):Inkey():k=RawKey()
If k=37 And Px>0:Px-1:EndIf:If k=39 And Px<72:Px+1:EndIf:P(Px,24)
Print(" ------ "):If m>400:P(X,Y):Print(" "):X+Dx:Y+Dy:m=0:EndIf:m+1
PokeW(@coord.l,X):PokeW(@coord+2,Y):NCR.l:B$=" "
ReadConsoleOutputCharacter_(7,B$,1,coord,@NCR):If B$="=":Dy*-1:P(X,Y):Print(" ")
PT+1:EndIf:If B$="-" And Dy=1 :Dy=-1:EndIf:If X>78 Or X<1
Dx*-1:EndIf:If X<1:Dx=1:EndIf:If Y>24:ENDE():EndIf:P(X,Y):Print("o"):Until k=27
; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 8
; Folding = -