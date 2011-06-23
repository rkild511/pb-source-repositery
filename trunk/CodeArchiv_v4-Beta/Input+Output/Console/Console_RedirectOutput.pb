; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7219&highlight=
; Author: Insomniac
; Date: 12. August 2003
; OS: Windows
; Demo: No

; Allows console program output to be sent to a file ( eg. myprogram > myfile.txt )
; or to a pipe (e.g. myprogram | more ) or to the screen of course. 
; Note: You have to compile it as a console application!

; Ermöglich die Ausgabe eines Konsolenprogrammes an eine Datei oder Pipe zu senden.
; Hinweis: Muss als Konsolen-Applikation kompiliert werden!


; allows console output to scroll and be redirected to file and pipe 
; expanded version of wichtel's scrolling console example 
; does not support ansi ( ie. color) or unicode 
; as writefile is used in place of writeconsole - see api doc 

Global stdout.l ; stdout handle 

Procedure.l MyOpenConsole() 

  stdout = GetStdHandle_(#STD_OUTPUT_HANDLE) ; check if we already have a console ie. command prompt 
  If stdout = #INVALID_HANDLE_VALUE ; no we don't have existing console 
    If AllocConsole_() ;attempt to open a new one 
      stdout=GetStdHandle_(#STD_OUTPUT_HANDLE) 
    Else 
      ProcedureReturn #False 
    EndIf 
  EndIf 

  ProcedureReturn #True      
EndProcedure 
  
  
Procedure.l MyPrintN(Stringparm.s) 
  
  written.l 
  msg$ = Stringparm + Chr(13) + Chr(10) 
  size.l=Len(msg$) 
  res = WriteFile_(stdout,@msg$,size, @written, #Null) 
  Delay(30) 
    
  ProcedureReturn res 
EndProcedure 

Procedure.l MyCloseConsole() 

  Delay(1000) 
  res = FreeConsole_() 

  ProcedureReturn res 
EndProcedure 
  
; Main program 

If MyOpenConsole() 

  For i=1 To 100 

  MyPrintN("hello world "+Str(i)) 

  Next i 
  
  MyCloseConsole() 
  
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
