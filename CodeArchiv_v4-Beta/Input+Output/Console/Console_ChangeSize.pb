; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2776&highlight=
; Author: wichtel
; Date: 08. November 2003
; OS: Windows
; Demo: No


Global stdout.l, stdin.l, NL$ 

NL$=Chr(13)+Chr(10) 

Procedure myPrintN(text$) 
  text$+NL$ 
  size.l=Len(text$) 
  bWritten.l 
  WriteConsole_(stdout,@text$,size, @bWritten, #Null) 
EndProcedure 

Procedure myPrint(text$) 
  size.l=Len(text$) 
  bWritten.l 
  WriteConsole_(stdout,@text$,size, @bWritten, #Null) 
EndProcedure 

Procedure.s myInkey() ; geht nur richtig wenn SetConsoleMode benutzt wurde 
  input$=Space(256) 
  size.l=1 
  bRead.l 
  ReadConsole_(stdin,@input$,size, @bRead, #Null) 
  ProcedureReturn input$ 
EndProcedure 

AllocConsole_() 
stdout=GetStdHandle_(#STD_OUTPUT_HANDLE) 
stdin=GetStdHandle_(#STD_INPUT_HANDLE) 
oldmode.l 
GetConsoleMode_(stdin,@oldmode) ; alten mode merken 
SetConsoleMode_(stdin,oldmode | #ENABLE_PROCESSED_INPUT) ; neuen mode setzen, damit readconsole wie Inkey arbeitet 


possiz.SMALL_RECT 

size.COORD 
size\x=100 
size\y=10 

SetConsoleTitle_("hallo") 
Delay(1000) 
myPrintN("test test test") 

possiz\left=8 
possiz\top=6 
possiz\right=20 
possiz\bottom=20 

ret=SetConsoleWindowInfo_(stdout,1,@possiz) 

Delay(5000) 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
