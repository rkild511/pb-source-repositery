; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8030&highlight=
; Author: DominiqueB (updated for PB3.93 by ts-soft)
; Date: 24. October 2003
; OS: Windows
; Demo: Yes

;
; Example to build your COM/DX interface yourself, for example developping an Object 
; Oriented DLL to use in C++ or Java 
; 

Interface IMyClock 
  GetTime() 
  SetTime(NewTime) 
  GetName() 
  SetName(Name$) 
EndInterface 


Structure MyClockFunctions 
  GetTime.l 
  SetTime.l 
  GetName.l 
  SetName.l 
EndStructure 


Structure MyClockObject 
*VirtualTable.MyClockFunctions 
  CurrentTime.l 
  Name$  
EndStructure 


Procedure GetTime(*Object.MyClockObject) 

  ; MessageRequester("Info", "GetTime()") 

  ProcedureReturn *Object\CurrentTime 
EndProcedure 


Procedure SetTime(*Object.MyClockObject, NewTime) 

  ; MessageRequester("Info", "SetTime(): "+Str(NewTime)) 

  *Object\CurrentTime = NewTime 
EndProcedure 


Procedure SetName(*Object.MyClockObject, Name$) 

  MessageRequester("Info", "SetName(): "+Name$) 

  *Object\Name$ = Name$ 
EndProcedure 


MyClockFunctions.MyClockFunctions\GetTime = @GetTime() 
MyClockFunctions.MyClockFunctions\SetTime = @SetTime() 
; MyClockFunctions.MyClockFunctions\GetName = @GetName() 
MyClockFunctions.MyClockFunctions\SetName = @SetName() 


MyClockObject.MyClockObject\VirtualTable = MyClockFunctions 

MyClock.IMyClock= @MyClockObject 


MyClock\SetTime(10) 
MyClock\GetTime() 

MyClock\SetName("My new clock name") 

Debug OffsetOf(IMyClock\SetName()) 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
