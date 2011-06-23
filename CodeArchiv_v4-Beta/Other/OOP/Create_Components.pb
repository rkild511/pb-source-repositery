; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9553&highlight=
; Author: GedB (updated for PB 4.00 by Andre)
; Date: 18. February 2004
; OS: Windows
; Demo: Yes


; The following is an example of how to create components using the Interface feature of PB. 


;IPBFriendly is the interface.  Programs will use this interface to 
;access the components methods 
Interface IPBFriendly 
  SayHello() 
  SayGoodbye() 
  TellMyName(Name.s) 
EndInterface 

;VTPBFriendlyFunctions is IPBFriendly's Virtual Table. 
;The virtual table is used to look up a method's address. 
;When Component\Method is encountered the address of the 
;method's function is looked up in the VirtualTable. 
Structure VTPBFriendlyFunctions 
  SayHello.l 
  SayGoodbye.l 
  TellMyName.l 
EndStructure 

;PBFriendly is the structure for the Components implementation. 
;It must have an entry for the VirtualTable, and any private fields 
;that the Component will need to maintain its state. 
Structure PBFriendly 
  *VirtualTable.VTPBFriendlyFunctions 
  Name.s 
EndStructure 

;We now define the Procedures that will be used for the Components 
;methods. 
Procedure SayHello(*Self.PBFriendly) 
  If *Self\Name > "" 
    MessageRequester("Friendly", "Hello " + *Self\Name + ".") 
  Else 
    MessageRequester("Friendly", "Hello.  I'm afraid we haven't been introduced") 
  EndIf 
EndProcedure 

Procedure SayGoodbye(*Self.PBFriendly) 
  If *Self\Name > "" 
    MessageRequester("Friendly", "Goodbye " + *Self\Name + ".") 
  Else 
    MessageRequester("Friendly", "Goodbye.  It's a shame we didn't get to know each other better") 
  EndIf 
EndProcedure 

Procedure TellMyName(*Self.PBFriendly, Name.s) 
  *Self\Name = Name 
  MessageRequester("Friendly", "Pleased to meet you, " + Name + ", I'm Purebasic.") 
EndProcedure 

; A Single global virtual table is created to he shared between all instances. 
Global VTPBFriendly.VTPBFriendlyFunctions 
VTPBFriendly\SayHello = @SayHello() 
VTPBFriendly\SayGoodbye = @SayGoodbye() 
VTPBFriendly\TellMyName = @TellMyName() 

Global NewList Instances.PBFriendly() 

; The Components contructor.  
; The instances of the objects are held within a global linked list. 
Procedure.l CreateFriendly() 
  ; Create a new PBFriendly within the Instances list. 
  AddElement(Instances()) 

  ; Assign the Virtual table 
  Instances()\VirtualTable = VTPBFriendly 

  ; Initialise the fields 
  Instances()\Name = "" 

  ; Return a pointer (hence the @) to the new structure 
  ProcedureReturn @Instances() 
EndProcedure 

; Now for a demonstration.  Create and use three separate components. 

Simon.IPBFriendly = CreateFriendly() 
Simon\SayHello() 

Peter.IPBFriendly = CreateFriendly() 
Peter\TellMyName("Peter") 
Peter\SayHello() 

John.IPBFriendly = CreateFriendly() 
John\TellMyName("John") 
John\SayHello() 

Simon\SayGoodbye() 
Peter\SayGoodbye() 
John\SayGoodbye() 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -