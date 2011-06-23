; PureBasic Chat
; Author: Danilo (updated for PB3.93 by ts-soft)
; Date: 10. January 2004
; OS: Windows
; Demo: Yes


;- CLASS cTEST  start
  ; cTest CLASS Interface
  Interface cTEST
    Procedure1.l()
    Procedure2.f(String$)
  EndInterface

  ; cTest CLASS Object
  Structure cTEST_OBJ
    VTable.l
    Functions.l[SizeOf(cTEST)/4]
  EndStructure

  Procedure.l cTEST__Procedure1(*this.cTEST)
    MessageRequester("INFO","Procedure 1 in cTEST")
    ProcedureReturn 12
  EndProcedure

  Procedure.f cTEST__Procedure2(*this.cTEST, String$)
    MessageRequester("INFO",String$)
    ProcedureReturn 123.456
  EndProcedure

  ; cTEST CLASS Constructor
  Procedure cTEST()
    ; Function table
    *object.cTEST_OBJ = AllocateMemory(SizeOf(cTEST_OBJ))
    If *object=0: ProcedureReturn 0: EndIf ; memory allocation failed

    *object\VTable  = *object+OffsetOf(cTEST_OBJ\Functions)
    *object\Functions[0] = @cTEST__Procedure1()
    *object\Functions[1] = @cTEST__Procedure2()
    ProcedureReturn *object
  EndProcedure


;- Program Start
*obj1.cTEST = cTEST()
If *obj1
  Debug *obj1\Procedure1()
  Debug *obj1\Procedure2("Hello World !")
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -