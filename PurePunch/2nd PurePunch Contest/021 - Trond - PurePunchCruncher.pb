;*****************************************************************************
;*
;* Name   : PurePunchCruncher
;* Author : Trond
;* Date   : 23 June 09
;* Notes  : Only runs in ascii mode on plain text source files
;* Notes  : Specify an existing input file before running
;*
;*****************************************************************************

ReadFile(0,GetHomeDirectory()+"my documents\infile.pb")
CreateFile(1,"c:\out.pb"):E.s:L.c:Macro IsAlNum(L)
((UCase(Chr(L))<>LCase(Chr(L)))Or(L>='0'And L<='9')):EndMacro:While Eof(0)=0
L=ReadCharacter(0):Select L:Case#LF:Case#CR,';':If N+Len(E)+1>80
WriteString(1,#CRLF$):N=Len(E):Else:If E:N+Len(E)+1:WriteString(1,":"):EndIf
EndIf:WriteString(1,E):E="":S=0:Repeat:L=ReadCharacter(0):Until Eof(0)Or L=#LF
Case Asc("'"),'"':E+Chr(L):O=L:Repeat:L=ReadCharacter(0):E+Chr(L)
Until Eof(0)Or L=#CR Or L=O:Case' ':S=1:Default:If S=1
If IsAlNum(Asc(UCase(Right(E,1)))):If IsAlNum(L):E+" ":EndIf:EndIf:EndIf
E+Chr(L):S=0:EndSelect:Wend:RunProgram("c:\out.pb")
; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 19
; Folding = -