; www.PureArea,net
; Author: Danilo (improved and commented by Lars, updated for PB3.93 by ts-soft)
; Date: 11. January 2004
; OS: Windows
; Demo: Yes

;- CLASS cTEST  start
   ; cTest CLASS Interface
Interface MessageBoxes
   ErrorBox.l(ErrorMsg.s)
   WarningBox.l(msg.s)
EndInterface

   ; cTest CLASS Object
Structure MessageBoxes_OBJ
   VTable.l
   Functions.l[SizeOf(MessageBoxes)/4]  ;In our interface are just pointers to the procedures. One pointer is a long, so 4 Bytes, so the total amount
                                        ;of Procedures in the interface is SizeOf(MessageBoxes)/4.
EndStructure

Procedure.l MessageBoxes__ErrorBox(*this.MessageBoxes, ErrorMsg.s)   ;Our procedures. You can name them as you like, but CLASSNAME__Procedurename
   ProcedureReturn MessageRequester("Error", ErrorMsg, #MB_ICONERROR) ;would be a great standart.
EndProcedure

Procedure.l MessageBoxes__WarningBox(*this.MessageBoxes, msg.s)
   ProcedureReturn MessageRequester("Attention",msg.s, #MB_ICONWARNING)
EndProcedure

   ; cTEST CLASS Constructor
Procedure cMessageBoxes()
   ; Function table
   *object.MessageBoxes_OBJ = AllocateMemory(SizeOf(MessageBoxes_OBJ))
   If *object=0: ProcedureReturn 0: EndIf ; memory allocation failed

   *object\VTable  = *object+OffsetOf(MessageBoxes_OBJ\Functions) ;Pointer to the place where the pointers To the procedures are
   *object\Functions[0] = @MessageBoxes__ErrorBox()                ;Attention: The order of the procedures here is the order of the procedures in the
   *object\Functions[1] = @MessageBoxes__WarningBox()              ;interface! If you swap these two, *obj1\Errorbox() will go to Warningbox()!
   ProcedureReturn *object
EndProcedure


;- Program Start
*obj1.MessageBoxes = cMessageBoxes()  ;Construct our class
If *obj1
   a.l = *obj1\ErrorBox("TEST")
   Debug a
   a.l = *obj1\WarningBox("TEST")
   Debug a
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -