; http://www.purebasic-lounge.de
; Author: remi_meier
; Date: 09. December 2006
; OS: Windows
; Demo: Yes


Global ___Exception.l
Macro Throw(ex)
  ___Exception = ex
  ProcedureReturn
EndMacro

Macro Exception(ex = -1)
  CompilerIf ex = -1
    If ___Exception : ProcedureReturn : EndIf
  CompilerElse
    If ex = ___Exception : ProcedureReturn : EndIf
  CompilerEndIf
EndMacro

Macro CatchException(ex = -1)
  CompilerIf ex = -1
    If ___Exception : Break : EndIf
  CompilerElse
    If ex = ___Exception : Break : EndIf
  CompilerEndIf
EndMacro

Macro Try()
  Repeat ;<
EndMacro

Macro EndTry()
  Until #True ;>
EndMacro

Macro Catch(ex = -1)
  CompilerIf ex = -1
    If ___Exception ;<
  CompilerElse
    If ex = ___Exception ;<
  CompilerEndIf
EndMacro

Macro EndCatch()
  EndIf ;>
EndMacro

Macro ClearException()
  ___Exception = 0
EndMacro



;- EXAMPLE

Enumeration 1
  #ALLOCATION_FAILED
  #READFILE_FAILED
  #OPENWINDOW_FAILED
EndEnumeration


Procedure.l memAlloc(Size.l) : Exception()
  Protected *mem
  *mem = AllocateMemory(Size)
  If Not *mem
    Throw(#ALLOCATION_FAILED)
  EndIf
  ProcedureReturn *mem
EndProcedure

Procedure.l fileRead(name.s) : Exception()
  Protected file.l
  file = ReadFile(#PB_Any, name)
  If Not file
    Throw(#READFILE_FAILED)
  EndIf
  ProcedureReturn file
EndProcedure

Procedure.l winOpen() : Exception()
  Protected win.l
  win = OpenWindow(#PB_Any, 0, 0, 200, 200, "")
  If Not win
    Throw(#OPENWINDOW_FAILED)
  EndIf
  ProcedureReturn win
EndProcedure


Try() ;>
  winOpen()
  *mem = memAlloc(20)
  CatchException()
  PokeS(*mem, "c:\lol")
  
  file = fileRead(PeekS(*mem))
  CatchException()
  WriteString(file, "lol")
EndTry() ;<

Catch() ;>
  Debug "exception!!"
EndCatch() ;<

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --