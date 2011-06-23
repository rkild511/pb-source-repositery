; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7752&highlight=
; Author: Froggerprogger 
; Date: 05. October 2003
; OS: Windows
; Demo: Yes


; 05.10.03 by Froggerprogger 
; 
; >>>>>>>>>> VECTOR-PROCEDURES 1.1 <<<<<<<<<<< 
; 
; These procedures handle 3D-FLOAT-vectors 
; 
; How To Use: 
; - The vector-coordinates are stored in a structure named .VectorF containing .x .y .z 
; - To create a new vector declare a variable of type VectorF - e.g. Vector1.VectorF, 
;   then call Vec_Define() or Vec_DefinePTL() (or set .x .y .z manually) 
; - Use the functions Vec_Acc(), Vec_Add(), Vec_AddXYZ(), Vec_Copy(), Vec_GetLength() 
;   Vec_GetPan(), Vec_GetTilt(), Vec_Normalize(), Vec_Rotate(), Vec_RotateXYZ() 
;   Vec_SetLength(), Vec_Stretch(), Vec_Sub(), Vec_SubXYZ() 
; - All Procedures request POINTERS to your vector-structure, so overgive e.g. @MyVector 
; 
; Changes from 1.0 to 1.1: 
; - replace Peek/Poke by Structures inside all procedures 
; - renamed Vec_DefineEx() to Vec_DefinePTL() 
; - new functions: Vec_AddXYZ(), Vec_SubXYZ(), Vec_Copy(), Vec_SetLength(), Vec_RotateXYZ() 

;- START OF INCLUDECODE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
Structure VectorF 
  x.f 
  y.f 
  z.f 
EndStructure 

#Deg2Rad = 0.01745329 
#Rad2Deg = 57.2957795 

Declare.l Vec_Acc(*Vec1.VectorF, *Vec2.VectorF, *VecResult.VectorF) 
Declare.l Vec_Add(*Vec1.VectorF, *Vec2.VectorF, *VecResult.VectorF) 
Declare.l Vec_AddXYZ(*Vec1.VectorF, x.f, y.f, z.f, *VecResult.VectorF) 
Declare.l Vec_Copy(*Vec1.VectorF, *VecResult.VectorF) 
Declare.l Vec_Define(*Vec1.VectorF, x.f, y.f, z.f) 
Declare.l Vec_DefinePTL(*Vec1.VectorF, Pan.f, Tilt.f, length.f) 
Declare.f Vec_GetLength(*Vec1.VectorF) 
Declare.f Vec_GetPan(*Vec1.VectorF) 
Declare.f Vec_GetTilt(*Vec1.VectorF) 
Declare.l Vec_Normalize(*Vec1.VectorF, *VecResult.VectorF) 
Declare.l Vec_Rotate(*Vec1.VectorF, Pan.f, Tilt.f, *VecResult.VectorF) 
Declare.l Vec_RotateXYZ(*Vec1.VectorF, Pan.f, Tilt.f, x.f, y.f, z.f, *VecResult.VectorF) 
Declare.l Vec_SetLength(*Vec1.VectorF, length.f, *VecResult.VectorF) 
Declare.l Vec_Stretch(*Vec1.VectorF, factor.f, *VecResult.VectorF) 
Declare.l Vec_Sub(*Vec1.VectorF, *Vec2.VectorF, *VecResult.VectorF) 
Declare.l Vec_SubXYZ(*Vec1.VectorF, x.f, y.f, z.f, *VecResult.VectorF) 

;- 
;- Vec_Acc :       Multiplies all components of Vec2 with their complements of Vec1 and stores 
;-                 the result in VecResult. 
;-                 If *VecResult is 0, the result is stored in Vec1 
;-                 returns a pointer to the resulting vector 
;-                 This procedure is good to use for acceleration. 
Procedure.l Vec_Acc(*Vec1.VectorF, *Vec2.VectorF, *VecResult.VectorF) 
  If *VecResult 
    *VecResult\x = *Vec1\x * *Vec2\x 
    *VecResult\y = *Vec1\y * *Vec2\y 
    *VecResult\z = *Vec1\z * *Vec2\z 
    ProcedureReturn *VecResult 
  Else 
    *Vec1\x = *Vec1\x * *Vec2\x 
    *Vec1\y = *Vec1\y * *Vec2\y 
    *Vec1\z = *Vec1\z * *Vec2\z 
    ProcedureReturn *Vec1 
  EndIf 
EndProcedure 
;- 
;- Vec_Add :       Adds Vec1 to the Vec2 and stores the result in the 3rd given vector (VecResult). 
;-                 If *VecResult is 0, the result is stored in Vec1 
;-                 returns a pointer to the resulting vector 
Procedure.l Vec_Add(*Vec1.VectorF, *Vec2.VectorF, *VecResult.VectorF) 
  If *VecResult 
    *VecResult\x = *Vec1\x + *Vec2\x 
    *VecResult\y = *Vec1\y + *Vec2\y 
    *VecResult\z = *Vec1\z + *Vec2\z 
    ProcedureReturn *VecResult 
  Else 
    *Vec1\x = *Vec1\x + *Vec2\x 
    *Vec1\y = *Vec1\y + *Vec2\y 
    *Vec1\z = *Vec1\z + *Vec2\z 
    ProcedureReturn *Vec1 
  EndIf 
EndProcedure 
;- 
;- Vec_AddXYZ :    Adds x, y and z to Vec1 and stores the result in the 2nd given vector (VecResult). 
;-                 If *VecResult is 0, the result is stored in Vec1 
;-                 returns a pointer to the resulting vector 
Procedure.l Vec_AddXYZ(*Vec1.VectorF, x.f, y.f, z.f, *VecResult.VectorF) 
  If *VecResult 
    *VecResult\x = *Vec1\x + x 
    *VecResult\y = *Vec1\y + y 
    *VecResult\z = *Vec1\z + z 
    ProcedureReturn *VecResult 
  Else 
    *Vec1\x = *Vec1\x + x 
    *Vec1\y = *Vec1\y + y 
    *Vec1\z = *Vec1\z + z 
    ProcedureReturn *Vec1 
  EndIf 
EndProcedure 
;- 
;- Vec_Copy :     Copies Vec1's coordinates to VecResult 
;-                returns a pointer to VecResult 
Procedure.l Vec_Copy(*Vec1.VectorF, *VecResult.VectorF) 
  *VecResult\x = *Vec1\x 
  *VecResult\y = *Vec1\y 
  *VecResult\z = *Vec1\z 
  ProcedureReturn *VecResult 
EndProcedure 
;- 
;- Vec_Define :    Sets the specified xyz-coordinates for the given vector of type VektorF 
;-                 So it's the same as vector\x = x : vector\y = y : vector\z = z 
;-                 returns a pointer to the defined vector 
Procedure.l Vec_Define(*Vec1.VectorF, x.f, y.f, z.f) 
  *Vec1\x = x 
  *Vec1\y = y 
  *Vec1\z = z 
  ProcedureReturn *Vec1 
EndProcedure 
;- 
;- Vec_DefinePTL : Calculates and sets the coordinates for the given vector of type VektorF 
;-                 and requests the values Pan, Tilt and Length for therefore. 
;-                 length should be positive 
;-                 Pan should be between 0 and 360 degrees (but need not) 
;-                 Tilt should be between -90 and 90 degrees (but need not) 
;-                 returns a pointer to the defined vector 
Procedure.l Vec_DefinePTL(*Vec1.VectorF, Pan.f, Tilt.f, length.f) 
  *Vec1\x = length * Cos(Tilt * #Deg2Rad) * Cos(-1*Pan * #Deg2Rad) 
  *Vec1\y = length * Sin(Tilt * #Deg2Rad) 
  *Vec1\z = length * Cos(Tilt * #Deg2Rad) * Sin(-1*Pan * #Deg2Rad) 
  ProcedureReturn *Vec1 
EndProcedure 
;- 
;- Vec_GetLength : Returns the length of the vector. This is always > 0 
Procedure.f Vec_GetLength(*Vec1.VectorF) 
  Protected x1.f, y1.f, z1.f 
  
  x1 = *Vec1\x 
  y1 = *Vec1\y 
  z1 = *Vec1\z 

  ProcedureReturn Sqr(x1*x1+y1*y1+z1*z1) 
EndProcedure 
;- 
;- Vec_GetPan :    Returns the angle between the vector and the x/y-plane, 
;-                 which is between 0 and 360 degrees. 
;-                 (positive z => Vec_GetPan > 180, negative z => Vec_GetPan < 180) 
Procedure.f Vec_GetPan(*Vec1.VectorF) 
  Protected x1.f, z1.f, temp.f 
  x1 = *Vec1\x 
  z1 = *Vec1\z 
  temp = ATan(z1 / x1) * #Rad2Deg 
  If z1 <= 0 
    If temp <= 0 
      temp * -1 
    Else 
      temp = 180 - temp 
    EndIf 
  Else 
    If temp < 0 
      temp = 180 - temp 
    Else 
      temp = 360 - temp 
    EndIf 
  EndIf 
  ProcedureReturn temp 
EndProcedure 
;- 
;- Vec_GetTilt :   Returns the smallest angle between the vector and the x/z-plane. 
;-                 So it lays between -90 and +90 degrees. 
Procedure.f Vec_GetTilt(*Vec1.VectorF) 
  Protected x1.f, y1.f, z1.f, temp1.f, temp2.f 
  
  x1 = *Vec1\x 
  y1 = *Vec1\y 
  z1 = *Vec1\z 
  
  temp1 = Sqr(x1*x1+z1*z1) 
  If temp1 = 0 : ProcedureReturn 0 : EndIf 
  
  temp2 = ATan(y1 / temp1) * #Rad2Deg 

  ProcedureReturn temp2 
EndProcedure 
;- 
;- Vec_Normalize : Normalizes a vector to the length 1 without changing Pan and Tilt. 
;-                 The result is stored in VecResult 
;-                 If *VecResult is 0, the result is stored in Vec1 
;-                 returns a pointer to the resulting vector 
Procedure.l Vec_Normalize(*Vec1.VectorF, *VecResult.VectorF) 
  Protected x1.f, y1.f, z1.f, length.f 
  
  x1 = *Vec1\x 
  y1 = *Vec1\y 
  z1 = *Vec1\z 
  length.f = Sqr(x1*x1+y1*y1+z1*z1) 

  If *VecResult 
    *VecResult\x = x1 / length 
    *VecResult\y = y1 / length 
    *VecResult\z = z1 / length 
    ProcedureReturn *VecResult 
  Else 
    *Vec1\x = x1 / length 
    *Vec1\y = y1 / length 
    *Vec1\z = z1 / length 
    ProcedureReturn *Vec1 
  EndIf 
EndProcedure 
;- 
;- Vec_Rotate :    Rotates Vec1 with the given Pan and Tilt-values and stores the result 
;-                 in VecResult. 
;-                 If *VecResult is 0, the result is stored in Vec1 
;-                 returns a pointer to the resulting vector 
Procedure.l Vec_Rotate(*Vec1.VectorF, Pan.f, Tilt.f, *VecResult.VectorF) 
  Protected oldLength.f, oldPan.f, oldTilt.f 
  
  oldLength = Vec_GetLength(*Vec1) 
  oldPan = Vec_GetPan(*Vec1) 
  oldTilt = Vec_GetTilt(*Vec1) 
  
  If *VecResult 
    ProcedureReturn Vec_DefinePTL(*VecResult, oldPan + Pan, oldTilt + Tilt, oldLength) 
  Else 
    ProcedureReturn Vec_DefinePTL(*Vec1, oldPan + Pan, oldTilt + Tilt, oldLength) 
  EndIf 
  
EndProcedure 
;- 
;- Vec_RotateXYZ : Rotates Vec1 with the given Pan and Tilt-values around the by *Vec2 
;-                 specified rotation center and stores the result in VecResult. 
;-                 If *VecResult is 0, the result is stored in Vec1 
;-                 returns a pointer to the resulting vector 
Procedure.l Vec_RotateXYZ(*Vec1.VectorF, Pan.f, Tilt.f, x.f, y.f, z.f, *VecResult.VectorF) 
  Protected oldLength.f, oldPan.f, oldTilt.f, Vec_temp.VectorF 
  
  Vec_SubXYZ(*Vec1, x, y, z, @Vec_temp) 
  oldLength = Vec_GetLength(@Vec_temp) 
  oldPan = Vec_GetPan(@Vec_temp) 
  oldTilt = Vec_GetTilt(@Vec_temp) 
    
  If *VecResult 
    ProcedureReturn Vec_AddXYZ(Vec_DefinePTL(*VecResult, oldPan + Pan, oldTilt + Tilt, oldLength), x, y, z, #False) 
  Else 
    ProcedureReturn Vec_AddXYZ(Vec_DefinePTL(*Vec1, oldPan + Pan, oldTilt + Tilt, oldLength), x, y, z, #False) 
  EndIf 
  
EndProcedure 
;- 
;- Vec_SetLength : Sets the given vector to the specified length and stores the result in 
;-                 VecResult. 
;-                 if *VecResult is 0, the result is stored in Vec1 
;-                 returns a pointer to the resulting vector 
Procedure.l Vec_SetLength(*Vec1.VectorF, length.f, *VecResult.VectorF) 
  Protected x1.f, y1.f, z1.f, originallength.f 
  
  x1 = *Vec1\x 
  y1 = *Vec1\y 
  z1 = *Vec1\z 
  originallength.f = Sqr(x1*x1+y1*y1+z1*z1) 

  If *VecResult 
    *VecResult\x = x1 / originallength * length 
    *VecResult\y = y1 / originallength * length 
    *VecResult\z = z1 / originallength * length 
    ProcedureReturn *VecResult 
  Else 
    *Vec1\x = x1 / originallength * length 
    *Vec1\y = y1 / originallength * length 
    *Vec1\z = z1 / originallength * length 
    ProcedureReturn *Vec1 
  EndIf 
EndProcedure 
;- 
;- Vec_Strech :    Stretches Vec1 by the given factor and stores the result in the 2nd given vector (VecResult). 
;-                 If *VecResult is 0, the result is stored in Vec1 
;-                 returns a pointer to the resulting vector 
Procedure.l Vec_Stretch(*Vec1.VectorF, factor.f, *VecResult.VectorF) 
  If *VecResult 
    *VecResult\x = *Vec1\x * factor 
    *VecResult\y = *Vec1\y * factor 
    *VecResult\z = *Vec1\z * factor 
    ProcedureReturn *VecResult 
  Else 
    *Vec1\x = *Vec1\x * factor 
    *Vec1\y = *Vec1\y * factor 
    *Vec1\z = *Vec1\z * factor 
    ProcedureReturn *Vec1 
  EndIf 
EndProcedure 
;- 
;- Vec_Sub :       Subtrahates Vec2 from Vec1 and stores the result in the 3rd given vector (VecResult). 
;-                 If *VecResult is 0, the result is stored in Vec1 
;-                 returns a pointer to the resulting vector 
Procedure.l Vec_Sub(*Vec1.VectorF, *Vec2.VectorF, *VecResult.VectorF) 
  If *VecResult 
    *VecResult\x = *Vec1\x - *Vec2\x 
    *VecResult\y = *Vec1\y - *Vec2\y 
    *VecResult\z = *Vec1\z - *Vec2\z 
    ProcedureReturn *VecResult 
  Else 
    *Vec1\x = *Vec1\x - *Vec2\x 
    *Vec1\y = *Vec1\y - *Vec2\y 
    *Vec1\z = *Vec1\z - *Vec2\z 
    ProcedureReturn *Vec1 
  EndIf 
EndProcedure 
;- 
;- Vec_SubXYZ :    Subtrahates x, y and z from Vec1 and stores the result in the 2nd given vector (VecResult). 
;-                 If *VecResult is 0, the result is stored in Vec1 
;-                 returns a pointer to the resulting vector 
Procedure.l Vec_SubXYZ(*Vec1.VectorF, x.f, y.f, z.f, *VecResult.VectorF) 
  If *VecResult 
    *VecResult\x = *Vec1\x - x 
    *VecResult\y = *Vec1\y - y 
    *VecResult\z = *Vec1\z - z 
    ProcedureReturn *VecResult 
  Else 
    *Vec1\x = *Vec1\x - x 
    *Vec1\y = *Vec1\y - y 
    *Vec1\z = *Vec1\z - z 
    ProcedureReturn *Vec1 
  EndIf 
EndProcedure 
;- END OF INCLUDECODE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 




;- 
;-  Examples 
;- 
Global Vector1.VectorF 
Global Vector2.VectorF 
Global Vector3.VectorF 

Procedure Showvector(*Vec1.VectorF) 
  PrintN("       X : "+ LSet(StrF(*Vec1\x), 10)+           "     Y : "+LSet(StrF(*Vec1\y),10)+            "       Z : "+LSet(StrF(*Vec1\z),10)) 
  PrintN("     Pan : "+ LSet(StrF(Vec_GetPan(*Vec1)), 10)+"  Tilt : "+LSet(StrF(Vec_GetTilt(*Vec1)),10)+"  Length : "+LSet(StrF(Vec_GetLength(*Vec1)),10)) 
  PrintN("") 
EndProcedure 

OpenConsole() 
PrintN("Define Vector 1 by x=1, y=2, z=3") 
Vec_Define(@Vector1, 1, 2, 3) ; x = 1 : y = 2 : z = 3 
Showvector(@Vector1) 

PrintN("Define Vector 2 by pan = 80 : tilt = 70 : length = 100") 
Vec_DefinePTL(@Vector2, 80, 70, 100) ; pan = 80 : tilt = 70 : length = 100 
Showvector(@Vector2) 

PrintN("Add 10, 10, 10 to Vector2 and then Vector 2 to Vector1") 
Vec_Add(@Vector1, Vec_AddXYZ(@Vector2, 10, 10, 10,0), 0) 
Showvector(@Vector1) 

PrintN("Normalize Vector1 and store result in Vector3") 
Vec_Normalize(@Vector1, @Vector3) 
Showvector(@Vector3) 

PrintN("Stretch Vector3 by factor 32") 
Vec_Stretch(@Vector3, 32, 0) 
Showvector(@Vector3) 

PrintN("Rotate Vector3 by +32 Pan and -31 Tilt") 
Vec_Rotate(@Vector3, 32, -31, 0) 
Showvector(@Vector3) 


Input() 
CloseConsole()
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ---
