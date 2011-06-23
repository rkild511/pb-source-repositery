; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8729&highlight=
; Author: Danilo
; Date: 14. December 2003
; OS: Windows
; Demo: No

; Speedtest: CallFunction VS. CallFunctionFast

; I want to compare as realistic and fair as i can, and this 
; means an object has always 1 parameter more than a procedure 
; that does the same. 

; If the Procedure has 3 params, the same procedure in an object 
; has 4 params because ALWAYS '*this' is given to the object. 

; Without objects, you call function(handle,x,y) for example. 
; OOP-Style you call the same as obj\function(x,y) and the handle 
; is saved in a variable in the object itself.

DisableDebugger ; !!! 

Procedure XYZ(a,b,c) 
  ProcedureReturn 12 
EndProcedure 

Procedure XYZ2(*this,a,b,c) 
  ProcedureReturn 12 
EndProcedure 

Structure myObject 
  vTable.l 
  Function_XYZ.l 
EndStructure 

Interface myInterface 
  XYZ(a,b,c) 
EndInterface 

object.myObject 
object\vTable       = @object\Function_XYZ 
object\Function_XYZ = @XYZ2() 

obj.myInterface = object 

#count = 99999999;9999999999 
A$="The test begins and takes some time!" 
B$="System is locked while the test runs... JUST WAIT!" 
C$="The test *can* run several minutes!" 
MessageRequester("ATTENTION!",A$+Chr(13)+B$+Chr(13)+C$,#MB_ICONEXCLAMATION) 

Delay(500) 
SetPriorityClass_(GetCurrentProcess_(),#REALTIME_PRIORITY_CLASS) 

start = timeGetTime_() 
For a = 0 To #count 
  XYZ(1,2,3) 
Next a 
Test1 = timeGetTime_()-start 

start = timeGetTime_() 
For a = 0 To #count 
  obj\XYZ(1,2,3) 
Next a 
Test2 = timeGetTime_()-start 

SetPriorityClass_(GetCurrentProcess_(),#NORMAL_PRIORITY_CLASS) 


A$ = "Result 1:"+StrU(Test1,#Long) 
B$ = "Result 2:"+StrU(Test2,#Long) 
MessageRequester("RESULT",A$+Chr(13)+B$,0)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
