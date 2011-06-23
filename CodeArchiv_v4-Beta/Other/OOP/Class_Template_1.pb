; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3896&highlight=
; Author: helpy (updated for PB 4.00 by Andre)
; Date: 05. March 2004
; OS: Windows
; Demo: No


; Und hier das Template: 

; Dateiname: class_template_1.pb 

XIncludeFile "class_tools.pbi" 

;{- CLASS cKLASSENNAME1  - START 
;- ... cKLASSENNAME1 CLASS Interface 
Interface cKLASSENNAME1 
  ; Hier die Funktionen eintragen 
  Procedure1() 
  Procedure2(String.s) 
  ;... 
EndInterface 

;- ... cKLASSENNAME1 CLASS Data Struct 
Structure sKLASSENNAME1 
  ; Hier die Daten der Klasse 
  ;... 
  test.l 
EndStructure 

;- ... cKLASSENNAME1 CLASS Object 
Structure cKLASSENNAME1_OBJ Extends CLASS_OBJ_BASE 
  Functions.l[SizeOf(cKLASSENNAME1)/4] 
EndStructure 

;- ... Funktionen der Klasse 
Procedure cKLASSENNAME1__Procedure1(*this.cKLASSENNAME1) 
  Protected *obj_data.sKLASSENNAME1 
  *obj_data = CLASS__GetDataPointer(*this) 
  *obj_data\test = 1 
EndProcedure 
  
Procedure cKLASSENNAME1__Procedure2(*this.cKLASSENNAME1, String.s) 
  Debug String 
EndProcedure 

;- ... cKLASSENNAME1 CLASS Constructor 
Procedure cKLASSENNAME1__Constructor(ExtendFunction,ExtendData) 
  Protected *object.cKLASSENNAME1_OBJ 
  Protected SizeOfInterface.l, FunctionOffset.l 
  
  SizeOfInterface = SizeOf(cKLASSENNAME1) 
  FunctionOffset = OffsetOf(cKLASSENNAME1_OBJ\Functions) 
  
  *object = CLASS__CreateObject( SizeOf(cKLASSENNAME1_OBJ)+ExtendFunction, SizeOf(sKLASSENNAME1)+ExtendData, FunctionOffset ) 
  If *object <> 0 
    CLASS__AddFunction( *object, SizeOfInterface, FunctionOffset, @cKLASSENNAME1__Procedure1() ) 
    CLASS__AddFunction( *object, SizeOfInterface, FunctionOffset, @cKLASSENNAME1__Procedure2() ) 
    ;... 
  EndIf 
  ProcedureReturn *object 
EndProcedure 

; cKLASSENNAME1 CLASS itself 
Procedure cKLASSENNAME1() 
  ProcedureReturn cKLASSENNAME1__Constructor(0,0) 
EndProcedure 
;}- CLASS cKLASSENNAME1  END 


;{- Anwendung der Klasse >>> 
Debug "=================================" 
Debug "Test von cKLASSENNAME1" 
*obj1.cKLASSENNAME1 = cKLASSENNAME1() 
If *obj1 
  *obj1_data.sKLASSENNAME1 = CLASS__GetDataPointer(*obj1) 
  Debug *obj1_data\test 
  *obj1\Procedure1() 
  Debug *obj1_data\test 
  *obj1\Procedure2("Hello World !") 
  Debug CLASS__Release(*obj1) 
  ; Sollten von der Klasse selbst noch mehr Speicher allokiert 
  ; werden, muss dieser natürlich durch eine Klassen-eigene 
  ; Release-Routine freigegeben werden. 
EndIf 
;}- Anwendung der Klasse - <<< 
 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --