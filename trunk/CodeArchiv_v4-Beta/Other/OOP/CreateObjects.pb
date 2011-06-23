; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8538&highlight=
; Author: GedB (updated for PB 4.00 by Andre)
; Date: 28. November 2003
; OS: Windows
; Demo: Yes


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

; Each instance of our component will need to have a unique VirtualTable 
; and Implementation structure. 
; For convenience I am putting both into a 'Holder' structure. 
Structure PBFriendlyHolder 
  VT.VTPBFriendlyFunctions 
  Impl.PBFriendly 
EndStructure 

; Instances is a linked list that will be used to keep all of the 
; Holders for our instances. 
Global NewList Instances.PBFriendlyHolder() 

; The Components contructor.  The creates a new Holder within the 
; Instances list and prepares it.  The Holders Impl field is returned 
; For the user to manipulate through an interface, rather than the whole 
; holdre. 
Procedure.l CreateFriendly() 
  ; Create a new Holder within the Instances list. 
  AddElement(Instances()) 

  ; Populate the Virtual Table. 
  Instances()\VT\SayHello = @SayHello() 
  Instances()\VT\SayGoodbye = @SayGoodbye() 
  Instances()\VT\TellMyName = @TellMyName() 

  ; Prepare the implementation 
  ; Assign the Virtual table 
  Instances()\Impl\VirtualTable = Instances()\VT 
  
  ; Initialise the fields 
  Instances()\Impl\Name = "" 

  ; Return a pointer (hence the @) to the Implementation 
  ProcedureReturn @Instances()\Impl 
EndProcedure 


; Now for a demonstration.  Create and use two separate components. 

Simon.IPBFriendly = CreateFriendly() 
Debug Simon 
Simon\SayHello() 

Peter.IPBFriendly = CreateFriendly() 
Peter\TellMyName("Peter") 
Peter\SayHello() 

Simon\SayGoodbye() 
Peter\SayGoodbye() 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
