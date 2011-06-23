; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3896&highlight=
; Author: helpy (updated for PB 4.00 by Andre)
; Date: 05. March 2004
; OS: Windows
; Demo: No


; Inheritance
; Vererbung

; Und hier das ganze mit Erben der vorgehenden Klasse:
XIncludeFile "class_tools.pbi" 
XIncludeFile "class_template_1.pb" 

;{- CLASS cKLASSENNAME2  - START 
;- ... cKLASSENNAME2 CLASS Interface 
Interface cKLASSENNAME2 Extends cKLASSENNAME1 
  ; Hier die Funktionen eintragen 
  Procedure3() 
  Procedure4(String.s) 
  ;... 
EndInterface 

;- ... cKLASSENNAME2 CLASS Data Struct 
Structure sKLASSENNAME2 Extends sKLASSENNAME1 
  ; Hier die Daten der Klasse 
  ;... 
  test2.l 
EndStructure 

;- ... cKLASSENNAME2 CLASS Object 
Structure cKLASSENNAME2_OBJ Extends CLASS_OBJ_BASE 
  Functions.l[SizeOf(cKLASSENNAME2)/4+SizeOf(cKLASSENNAME1)/4] 
EndStructure 

;- ... Funktionen der Klasse 
Procedure cKLASSENNAME2__Procedure3(*this.cKLASSENNAME2) 
  Protected *obj_data.sKLASSENNAME2 
  *obj_data = CLASS__GetDataPointer(*this) 
  *obj_data\test2 = 1 
EndProcedure 
  
Procedure cKLASSENNAME2__Procedure4(*this.cKLASSENNAME2, String.s) 
  Debug String 
EndProcedure 

;- ... cKLASSENNAME2 CLASS Constructor 
Procedure cKLASSENNAME2__Constructor(ExtendFunction,ExtendData) 
  Protected *object.cKLASSENNAME2_OBJ 
  Protected SizeOfInterface.l, FunctionOffset.l 
  
  SizeOfInterface = SizeOf(cKLASSENNAME2) 
  FunctionOffset = OffsetOf(cKLASSENNAME2_OBJ\Functions)+SizeOf(cKLASSENNAME1) 
  
  *object = cKLASSENNAME1__Constructor( SizeOf(cKLASSENNAME2_OBJ)-SizeOf(cKLASSENNAME1_OBJ)+ExtendFunction, SizeOf(sKLASSENNAME2)-SizeOf(sKLASSENNAME1)+ExtendData ) 
  If *object <> 0 
    CLASS__AddFunction( *object, SizeOfInterface, FunctionOffset, @cKLASSENNAME2__Procedure3() ) 
    CLASS__AddFunction( *object, SizeOfInterface, FunctionOffset, @cKLASSENNAME2__Procedure4() ) 
    ;... 
  EndIf 
  ProcedureReturn *object 
EndProcedure 

; cKLASSENNAME2 CLASS itself 
Procedure cKLASSENNAME2() 
  ProcedureReturn cKLASSENNAME2__Constructor(0,0) 
EndProcedure 
;}- CLASS cKLASSENNAME2  END 


;{- Anwendung der Klasse >>> 
Debug "=================================" 
Debug "Test von cKLASSENNAME2" 
*obj2.cKLASSENNAME2 = cKLASSENNAME2() 
If *obj2 
  *obj2_data.sKLASSENNAME2 = CLASS__GetDataPointer(*obj2) 
  Debug *obj2_data\test 
  *obj2\Procedure1() 
  Debug *obj1_data\test 
  *obj2\Procedure2("Hello World !") 
  
  Debug *obj2_data\test2 
  *obj2\Procedure3() 
  Debug *obj2_data\test2 
  *obj2\Procedure4("Hello World !") 
  
  
  Debug CLASS__Release(*obj2) 
  ; Sollten von der Klasse selbst noch mehr Speicher allokiert 
  ; werden, muss dieser natürlich durch eine Klassen-eigene 
  ; Release-Routine freigegeben werden. 
EndIf 
;}- Anwendung der Klasse - <<< 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --