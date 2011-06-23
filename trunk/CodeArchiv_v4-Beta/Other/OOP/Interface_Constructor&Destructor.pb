; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1025&highlight=
; Author: DarkDragon (updated for PB 4.00 by Andre)
; Date: 27. November 2004
; OS: Windows
; Demo: Yes

Interface Inter_Face 
  MSG(Message.s) 
EndInterface 

Structure OBJ 
  VTable.l 
  Function.l[SizeOf(Inter_Face)/4] 
EndStructure 

Procedure Message(*t.Inter_Face, Message.s) 
  MessageRequester("", Message.s) 
EndProcedure 

Procedure Constructor() 
  *OBJ.OBJ = AllocateMemory(SizeOf(OBJ)) 
  *OBJ\VTable = *OBJ+OffsetOf(OBJ\Function) 
  *OBJ\Function[0] = @Message() 
  ProcedureReturn *OBJ 
EndProcedure 

Procedure Destructor(*OBJ.OBJ) 
  FreeMemory(*OBJ.OBJ) 
EndProcedure 

*MyOBJ.Inter_Face = Constructor() 
*MyOBJ\MSG("Hallo, dies ist ein Testtext") 
Destructor(*MyOBJ)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -