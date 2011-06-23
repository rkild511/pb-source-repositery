; English forum: http://www.purebasic.fr/english/viewtopic.php?t=15568&postdays=0&postorder=asc&start=30
; Author: Dreglor (updated for PB 4.00 by Andre)
; Date: 23. June 2005
; OS: Windows
; Demo: Yes


;/Title: PBRay 
;/Author: Dreglor 
;/Date: 6-21-05 
;/Version: Alpha 
;/Function: Renders scenes using raytracing 
;/Notes: Special Thanks to MrMat for helping me :) 
;/Todo: fix bugs, phong lighting, shadows ,Refractions 

;- Constants 

#Version="Alpha" 

#Tolerance=0.0001 

#ObjectType_Null=0 
#ObjectType_PointLight=1 
#ObjectType_Sphere=2 

#MaxChildren=3 

#EPSILON=0.0001 
;#PI=3.14159265 

;- Structures 

Structure xyz 
  x.f 
  y.f 
  z.f 
EndStructure 

Structure Matrix 
  e11.f 
  e12.f 
  e13.f 
  e21.f 
  e22.f 
  e23.f 
  e31.f 
  e32.f 
  e33.f 
EndStructure 

Structure Camera 
  Origin.xyz 
  Direction.xyz 
  ViewingAngle.xyz 
EndStructure 

Structure Color 
  Red.f 
  Green.f 
  Blue.f 
EndStructure 

Structure Material 
  SoildColor.Color 
  Diffuse.f 
  Reflect.f 
  Refract.f 
EndStructure 

Structure PointLight 
  Color.Color 
  Origin.xyz 
EndStructure 

Structure Sphere 
  radius.f 
EndStructure 

; Structure Plane ;incomplete 
; normal.xyz 
; Distance.xyz ;??? 
; EndStructure 

; Structure Triangle ;incomplete 
; v1.xyz 
; v2.xyz 
; v3.xyz 
; normal.xyz 
; EndStructure 

Structure Object 
  Type.b 
  Material.Material 
  Origin.xyz 
  Direction.xyz 
  IsLight.b 
  Primitive.l ;points to a memory that get[primitive]structure will use to fill a structure with 
EndStructure 

Structure Scene 
  Ambient.Color 
  ScreenWidth.w 
  ScreenHeight.w 
  HalfScreenWidth.w 
  HalfScreenHeight.w 
EndStructure 

;- Globals 

Global MainScene.Scene 

Global NewList ObjectList.Object() 

;- Declares 

Declare.l TestLoop();tester 
Declare.b RenderScene(*Scene.Scene, *ViewPort.Camera,angle.l) 
Declare.l TraceRay(*Origin.xyz, *Direction.xyz, depth.b, *res.Color) 
Declare.f TestSphere(*Origin.xyz, *Direction.xyz, *Sphere.Object) 
Declare.l Shade(*Intersection.xyz,*Normal.xyz,*Direction.xyz,*Material.Material,depth.b,*res.Color) 
Declare.b RemoveObject(objectHandle) 
Declare.b AddSphereObject(*Sphere.Object,radius.f) 
Declare.b GetObjectStructure(ObjectPointer,*destination.Object) 
Declare.b SetObjectStructure(ObjectPointer,*source.Object) 
Declare.b AddPointLightObject(*Light.PointLight) 
Declare.w MatrixScalarDivision(*a.Matrix, Scalar.f,  *result.Matrix);divides a matrix to a scalar 
Declare.w MatrixScalarMuiltply(*a.Matrix, Scalar.f,  *result.Matrix);muiltplies a matrix to a scalar 
Declare.w MatrixSubtract(*a.Matrix,  *b.Matrix,  *result.Matrix);subtract 2 matrice together 
Declare.w MatrixAdd(*a.Matrix,  *b.Matrix,  *result.Matrix);adds 2 matrice together 
Declare.w MatrixInverse(*this.Matrix);returns the inverse of a matrix 
Declare.w MatrixTranspose(*this.Matrix,  *result.Matrix);returns the transpose of a matrix 
Declare.f MatrixDeterminant(*this.Matrix);returns the determiant of a matrix 
Declare.f VectorTripleScalarProduct(*a.xyz,  *b.xyz,  *c.xyz);returns triple scalar product of 3 vectors 
Declare.b VectorScalarDivide(*a.xyz, b.f,  *result.xyz);returns a pointer to a vector that has been divided 
Declare.b VectorScalarMuilply(*a.xyz, b.f,  *result.xyz);returns a pointer to a vector that has been muiltiplied 
Declare.b VectorSubtract(*a.xyz,  * b.xyz,  *result.xyz);returns a pointer to a vector that has been Subtracted 
Declare.b VectorAdd(*a.xyz,  * b.xyz,  *result.xyz);returns a pointer to a vector that has been added 
Declare.b VectorCrossMuiltply(*a.xyz,  *b.xyz,  *result.xyz);returns a pointer to a vector that has been crossed muiltiplied 
Declare.b VectorReverse(*this.xyz);reverses a Vector 
Declare.b VectorNormalize(*this.xyz);normilzes a vector 
Declare.f VectorDotProduct(*a.xyz,  *b.xyz) 
Declare.f VectorMagnitude(*this.xyz);returns the maginitude of a Vector 
Declare.b ColorRangeCheck(*a.Color) 
Declare.b ColorAdd(*a.Color,  *b.Color,  *result.Color);returns a pointer to a Color that has been added 
Declare.b ColorMuilply(*a.Color,  *b.Color,  *result.Color);returns a pointer to a Color that has been muiltiplied 
Declare.b ColorScalarMuilply(*a.Color, b.f,  *result.Color);returns a pointer to a Color that has been muiltiplied by a scalar 

;- Procedures 

;- Color Math 

Procedure.b ColorScalarMuilply(*a.Color, b.f, *result.Color);returns a pointer to a Color that has been muiltiplied by a scalar 
  *result\Red = *a\Red * b 
  *result\Green = *a\Green * b 
  *result\Blue = *a\Blue * b 
EndProcedure 

Procedure.b ColorMuilply(*a.Color, *b.Color, *result.Color);returns a pointer to a Color that has been muiltiplied 
  *result\Red = *a\Red * *b\Red 
  *result\Green = *a\Green * *b\Green 
  *result\Blue = *a\Blue * *b\Blue 
EndProcedure 

Procedure.b ColorAdd(*a.Color, *b.Color, *result.Color);returns a pointer to a Color that has been added 
  *result\Red = *a\Red + *b\Red 
  *result\Green = *a\Green + *b\Green 
  *result\Blue = *a\Blue + *b\Blue 
EndProcedure 

Procedure.b ColorRangeCheck(*a.Color) 
  If *a\Red>1 
    *a\Red=1 
  EndIf 
  If *a\Green>1 
    *a\Green=1 
  EndIf 
  If *a\Blue>1 
    *a\Blue=1 
  EndIf 
EndProcedure 

;-Vector Math 

Procedure.f VectorMagnitude(*this.xyz);returns the maginitude of a Vector 
ProcedureReturn Sqr((*this\x * *this\x)+(*this\y * *this\y)+(*this\z * *this\z)) 
EndProcedure 

Procedure.f VectorDotProduct(*a.xyz, *b.xyz) 
ProcedureReturn *a\x * *b\x + *a\y * *b\y + *a\z * *b\z 
EndProcedure 

Procedure.b VectorNormalize(*this.xyz);normilzes a vector 
  m.f = Sqr(*this\x * *this\x + *this\y * *this\y + *this\z * *this\z) 
  If m > #Tolerance 
    *this\x = *this\x / m 
    *this\y = *this\y / m 
    *this\z = *this\z / m 
  EndIf 
  If  Abs(*this\x) < #Tolerance 
    *this\x = 0 
  EndIf 
  If  Abs(*this\y) < #Tolerance 
    *this\y = 0 
  EndIf 
  If  Abs(*this\z) < #Tolerance 
    *this\z = 0 
  EndIf 
EndProcedure 

Procedure.b VectorReverse(*this.xyz);reverses a Vector 
  *this\x = -*this\x 
  *this\y = -*this\y 
  *this\z = -*this\z 
EndProcedure 

Procedure.b VectorCrossMuiltply(*a.xyz, *b.xyz, *result.xyz);returns a pointer to a vector that has been crossed muiltiplied 
  *result\x = *a\y * *b\z - *a\z * *b\y 
  *result\y = -*a\x * *b\z + *a\z * *b\x 
  *result\z = *a\x * *b\y - *a\y * *b\x 
EndProcedure 

Procedure.b VectorAdd(*a.xyz, *b.xyz, *result.xyz);returns a pointer to a vector that has been added 
  *result\x = *a\x + *b\x 
  *result\y = *a\y + *b\y 
  *result\z = *a\z + *b\z 
EndProcedure 

Procedure.b VectorSubtract(*a.xyz, *b.xyz, *result.xyz);returns a pointer to a vector that has been Subtracted 
  *result\x = *a\x - *b\x 
  *result\y = *a\y - *b\y 
  *result\z = *a\z - *b\z 
EndProcedure 

Procedure.b VectorScalarMuilply(*a.xyz, b.f, *result.xyz);returns a pointer to a vector that has been muiltiplied 
  *result\x = *a\x * b 
  *result\y = *a\y * b 
  *result\z = *a\z * b 
EndProcedure 

Procedure.b VectorScalarDivide(*a.xyz, b.f, *result.xyz);returns a pointer to a vector that has been divided 
  *result\x = *a\x / b 
  *result\y = *a\y / b 
  *result\z = *a\z / b 
EndProcedure 

Procedure.f VectorTripleScalarProduct(*a.xyz, *b.xyz, *c.xyz);returns triple scalar product of 3 vectors 
ProcedureReturn  *a\x * (*b\y * *c\z - *b\z * *c\y)+(*a\y * (-*b\x * *c\z + *b\z * *c\x))+(*a\z * (*b\x * *c\y - *b\y * *c\x)) 
EndProcedure 

;-Matrix Math 

Procedure.f MatrixDeterminant(*this.Matrix);returns the determiant of a matrix 
ProcedureReturn  *this\e11 * *this\e22 * *this\e33 - *this\e11 * *this\e32 * *this\e23 + *this\e21 * *this\e32 * *this\e13 - *this\e21 * *this\e12 * *this\e33 + *this\e31 * *this\e12 * *this\e23 - *this\e31 * *this\e22 * *this\e13 
EndProcedure 

Procedure.w MatrixTranspose(*this.Matrix, *result.Matrix);returns the transpose of a matrix 
  *result\e11 = *this\e11 
  *result\e21 = *this\e12 
  *result\e31 = *this\e13 
  *result\e12 = *this\e21 
  *result\e22 = *this\e22 
  *result\e32 = *this\e23 
  *result\e13 = *this\e31 
  *result\e23 = *this\e32 
  *result\e33 = *this\e33 
EndProcedure 

Procedure.w MatrixInverse(*this.Matrix);returns the inverse of a matrix 
  d.f  = MatrixDeterminant(*this) 
  If d  = 0 
    d  = 1 
  EndIf 
  *this\e11 =  (*this\e22  *  *this\e33  -  *this\e23  *  *this\e32)/d 
  *this\e21 = -(*this\e12  *  *this\e33  -  *this\e13  *  *this\e32)/d 
  *this\e31 =  (*this\e12  *  *this\e23  -  *this\e13  *  *this\e22)/d 
  *this\e12 = -(*this\e21  *  *this\e33  -  *this\e23  *  *this\e31)/d 
  *this\e22 =  (*this\e11  *  *this\e33  -  *this\e13  *  *this\e31)/d 
  *this\e32 = -(*this\e11  *  *this\e23  -  *this\e13  *  *this\e21)/d 
  *this\e13 =  (*this\e21  *  *this\e32  -  *this\e12  *  *this\e31)/d 
  *this\e23 = -(*this\e11  *  *this\e32  -  *this\e12  *  *this\e31)/d 
  *this\e33 =  (*this\e11  *  *this\e22  -  *this\e12  *  *this\e21)/d 
EndProcedure 

Procedure.w MatrixAdd(*a.Matrix, *b.Matrix, *result.Matrix);adds 2 matrice together 
  *result\e11 = *a\e11 + *b\e11 
  *result\e12 = *a\e12 + *b\e12 
  *result\e13 = *a\e13 + *b\e13 
  *result\e21 = *a\e21 + *b\e21 
  *result\e22 = *a\e22 + *b\e22 
  *result\e23 = *a\e23 + *b\e23 
  *result\e31 = *a\e31 + *b\e31 
  *result\e32 = *a\e32 + *b\e32 
  *result\e33 = *a\e33 + *b\e33 
EndProcedure 

Procedure.w MatrixSubtract(*a.Matrix, *b.Matrix, *result.Matrix);subtract 2 matrice together 
  *result\e11 = *a\e11 - *b\e11 
  *result\e12 = *a\e12 - *b\e12 
  *result\e13 = *a\e13 - *b\e13 
  *result\e21 = *a\e21 - *b\e21 
  *result\e22 = *a\e22 - *b\e22 
  *result\e23 = *a\e23 - *b\e23 
  *result\e31 = *a\e31 - *b\e31 
  *result\e32 = *a\e32 - *b\e32 
  *result\e33 = *a\e33 - *b\e33 
EndProcedure 

Procedure.w MatrixScalarMuiltply(*a.Matrix, Scalar.f, *result.Matrix);muiltplies a matrix to a scalar 
  *result\e11 = *a\e11 * Scalar 
  *result\e12 = *a\e12 * Scalar 
  *result\e13 = *a\e13 * Scalar 
  *result\e21 = *a\e21 * Scalar 
  *result\e22 = *a\e22 * Scalar 
  *result\e23 = *a\e23 * Scalar 
  *result\e31 = *a\e31 * Scalar 
  *result\e32 = *a\e32 * Scalar 
  *result\e33 = *a\e33 * Scalar 
EndProcedure 

Procedure.w MatrixScalarDivision(*a.Matrix, Scalar.f, *result.Matrix);divides a matrix to a scalar 
  *result\e11 = *a\e11 / Scalar 
  *result\e12 = *a\e12 / Scalar 
  *result\e13 = *a\e13 / Scalar 
  *result\e21 = *a\e21 / Scalar 
  *result\e22 = *a\e22 / Scalar 
  *result\e23 = *a\e23 / Scalar 
  *result\e31 = *a\e31 / Scalar 
  *result\e32 = *a\e32 / Scalar 
  *result\e33 = *a\e33 / Scalar 
EndProcedure 

;-FrameWork 

Procedure.b AddPointLightObject(*Light.PointLight) 
  If CountList(ObjectList())>0 
    *Old_Element = @ObjectList() 
  EndIf 
  AddElement(ObjectList()) 
  ObjectList()\Type=#ObjectType_PointLight 
  ObjectList()\Material\SoildColor\Red=*Light\Color\Red 
  ObjectList()\Material\SoildColor\Green=*Light\Color\Green 
  ObjectList()\Material\SoildColor\Blue=*Light\Color\Blue 
  ObjectList()\Origin\x=*Light\Origin\x 
  ObjectList()\Origin\y=*Light\Origin\y 
  ObjectList()\Origin\z=*Light\Origin\z 
  ObjectList()\IsLight=#True 
  ObjectList()\Primitive=#Null 
  result.l=@ObjectList() 
  If *Old_Element<>#Null 
    ChangeCurrentElement(ObjectList(), *Old_Element) 
  EndIf 
  ProcedureReturn result 
EndProcedure 

Procedure.b AddSphereObject(*Sphere.Object,radius.f) 
  If CountList(ObjectList())>0 
    *Old_Element = @ObjectList() 
  EndIf 
  AddElement(ObjectList()) 
  ;copy object data into the new object 
  CopyMemory(*Sphere,@ObjectList(),SizeOf(Object)) 
  ;put any primtive specific data into there places 
  ObjectList()\Primitive=AllocateMemory(4) 
  PokeF(ObjectList()\Primitive,radius) 
  ObjectList()\Type=#ObjectType_Sphere 
  result.l=@ObjectList() 
  If *Old_Element<>#Null 
    ChangeCurrentElement(ObjectList(), *Old_Element) 
  EndIf 
  ProcedureReturn result 
EndProcedure 

Procedure.b GetObjectStructure(ObjectPointer,*destination.Object) 
  If CountList(ObjectList())>0 
    *Old_Element = @ObjectList() 
  EndIf 
  ChangeCurrentElement(ObjectList(), ObjectPointer) 
  ;copy object data into the new object 
  CopyMemory(@ObjectList(),*destination,SizeOf(Object)) 
  If *Old_Element<>#Null 
    ChangeCurrentElement(ObjectList(), *Old_Element) 
  EndIf 
EndProcedure 

Procedure.b SetObjectStructure(ObjectPointer,*source.Object) 
  If CountList(ObjectList())>0 
    *Old_Element = @ObjectList() 
  EndIf 
  ChangeCurrentElement(ObjectList(), ObjectPointer) 
  ;copy object data into the new object 
  CopyMemory(*source,@ObjectList(),SizeOf(Object)) 
  If *Old_Element<>#Null 
    ChangeCurrentElement(ObjectList(), *Old_Element) 
  EndIf 
EndProcedure 

Procedure.b RemoveObject(ObjectPointer) 
  If CountList(ObjectList())>0 
    *Old_Element = @ObjectList() 
  EndIf 
  ChangeCurrentElement(ObjectList(), ObjectPointer) 
  If ObjectList()\Primitive<>#Null 
    FreeMemory(ObjectList()\Primitive) 
  EndIf 
  DeleteElement(ObjectList()) 
  If CountList(ObjectList())>0 And *Old_Element<>#Null 
    ChangeCurrentElement(ObjectList(), *Old_Element) 
  EndIf 
EndProcedure 

Procedure Shade(*Intersection.xyz,*Normal.xyz,*Direction.xyz,*Material.Material,depth.b,*Accumalated.Color) 
  *Old_Element=@ObjectList() 
  *result.Color 
  Color.Color 
  Light.xyz 
  Relfection.xyz 
  reflectcolor.Color 
  ReflectOrigin.xyz 
  tempvec.xyz 
  ResetList(ObjectList()) 
  For Object=0 To CountList(ObjectList()) - 1 
    NextElement(ObjectList()) 
    If ObjectList()\IsLight=#True 
      VectorSubtract(ObjectList()\Origin,*Intersection,Light) ;Origin - Intersection; 
      VectorNormalize(Light) 
      If *Material\Diffuse > 0 
        dot.f=VectorDotProduct(*Normal,Light) 
        If dot>0 
          diff.f=dot * *Material\Diffuse 
          ColorMuilply(*Material\SoildColor,ObjectList()\Material\SoildColor,Color) ;Accumalated += diff * MaterialColor * LightColor 
          ColorScalarMuilply(Color,diff,Color) 
          ColorAdd(Color,*Accumalated,*Accumalated) 
        EndIf 
        If *Material\Reflect>0 
          r.f=2*VectorDotProduct(*Direction,*Normal) 
          VectorScalarMuilply(*Normal,r,tempvec) 
          VectorSubtract(*Direction,tempvec,Relfection);Direction - 2 * DOT( Direction, normal ) * normal 
          VectorScalarMuilply(Relfection,#EPSILON,ReflectOrigin) 
          VectorAdd(*Intersection,ReflectOrigin,ReflectOrigin);Intersection+Reflection*EPSILON 
          TraceRay(ReflectOrigin,Relfection,depth+1,reflectcolor) 
          SelectElement(ObjectList(), Object) 
          ColorScalarMuilply(reflectcolor,*Material\Reflect,Color.Color) 
          ColorMuilply(Color,*Material\SoildColor,Color) 
          ColorAdd(Color,*Accumalated,*Accumalated);Accumalated += MaterialReflect * reflectcolor * MaterialColor 
        EndIf 
      EndIf 
    EndIf 
  Next Object 
  ColorRangeCheck(*Accumalated) 
  ChangeCurrentElement(ObjectList(), *Old_Element) 
EndProcedure 

Procedure.f TestSphere(*Origin.xyz,*Direction.xyz,*Sphere.Object) 
offset.xyz 
VectorSubtract(*Origin, *Sphere\Origin, offset) 

radius.f = PeekF(*Sphere\Primitive) 

b.f = 2 * (*Direction\x * offset\x + *Direction\y * offset\y + *Direction\z * offset\z) 
c.f = offset\x * offset\x + offset\y * offset\y + offset\z * offset\z - radius * radius 
d.f = b * b - 4 * c 

If d > 0 ;hit the sphere 
  t.f = (-b - Sqr(d)) * 0.5 ; Could return +ve or -ve number! 
EndIf 

ProcedureReturn t 
EndProcedure 

Procedure TraceRay(*Origin.xyz,*Direction.xyz,depth.b,*res.Color) 
  Intersection.xyz 
  Normal.xyz 
  *Old_Element=@ObjectList() 
  result.Color 
  If depth<#MaxChildren 
    Closesthandle=-1 
    ClosestT.f=-1 
    ResetList(ObjectList()) 
    For Object=0 To CountList(ObjectList()) - 1 
      NextElement(ObjectList()) 
      Select ObjectList()\Type 
      Case #ObjectType_Sphere 
        t.f=TestSphere(*Origin,*Direction,@ObjectList()) 
        If t>0 
          If t<ClosestT Or ClosestT=-1 
            Closesthandle=Object 
            ClosestT=t 
          EndIf 
        EndIf 
        ;other cases will be added 
      EndSelect 
    Next Object 
    If ClosestT>0 
      t=ClosestT 
      SelectElement(ObjectList(),Closesthandle) 
      VectorScalarMuilply(*Direction,t,Intersection) ;Calulate Interesction point with 
      VectorAdd(*Origin,Intersection,Intersection) ;Origin + Direction * T; 
      If ObjectList()\Type=#ObjectType_Sphere ;normal Calulations are diffrent per object 
        VectorSubtract(Intersection ,ObjectList()\Origin,Normal) 
        VectorScalarDivide(Normal,PeekF(ObjectList()\Primitive),Normal) 
        ;other cases will be added 
      EndIf 
      Shade(Intersection,Normal,*Direction,ObjectList()\Material,depth,result) 
    EndIf 
  EndIf 
  ChangeCurrentElement(ObjectList(), *Old_Element) 
  *res\Red = result\Red 
  *res\Green = result\Green 
  *res\Blue = result\Blue 
EndProcedure 

Procedure.b RenderScene(*Scene.Scene,*ViewPort.Camera,angle) 
  Color.Color 
  For y = -*Scene\HalfScreenHeight To *Scene\HalfScreenHeight - 1 
    For x = -*Scene\HalfScreenWidth To *Scene\HalfScreenWidth - 1 
      *ViewPort\Origin\x=-1000 * Sin(angle * #PI / 180) 
      *ViewPort\Origin\y=0 
      *ViewPort\Origin\z=-1000 * Cos(angle * #PI / 180) 
      *ViewPort\Direction\x = 1000 * Sin((angle + 0.1*x) * #PI / 180) 
      *ViewPort\Direction\y = 2*y 
      *ViewPort\Direction\z = 1000 * Cos((angle + 0.1*x) * #PI / 180) 
      VectorSubtract(*ViewPort\Direction,*ViewPort\Origin,*ViewPort\Direction) 
      VectorNormalize(*ViewPort\Direction) 
      TraceRay(*ViewPort\Origin,*ViewPort\Direction,0,Color) 
      If Color\Red<>0 Or Color\Green<>0 Or Color\Blue<>0 
        Plot(*Scene\HalfScreenWidth + x, *Scene\HalfScreenHeight + y,RGB(Color\Red*255,Color\Green*255,Color\Blue*255)) 
      EndIf 
    Next x 
  Next y 
EndProcedure 

Procedure TestLoop() ;tester 
  Sphere1.Object 
  Sphere1Radius.f 
  Sphere2.Object 
  Sphere2Radius.f 
  Light1.PointLight 
  Light2.PointLight 
  MainCamera.Camera 
  MainScene.Scene 
  
  Sphere1\Origin\x=-170 
  Sphere1\Origin\y=0 
  Sphere1\Origin\z=0 
  Sphere1\Material\SoildColor\Red=0.75 
  Sphere1\Material\SoildColor\Green=0.25 
  Sphere1\Material\SoildColor\Blue=0.25 
  Sphere1\Material\Diffuse=1 
  Sphere1\Material\Reflect=1 
  Sphere1\Material\Refract=0 
  Sphere1Radius=150 
  
  AddSphereObject(Sphere1,Sphere1Radius) 
  
  Sphere2\Origin\x=120 
  Sphere2\Origin\y=0 
  Sphere2\Origin\z=0 
  Sphere2\Material\SoildColor\Red=0.25 
  Sphere2\Material\SoildColor\Green=0.25 
  Sphere2\Material\SoildColor\Blue=0.75 
  Sphere2\Material\Diffuse=1 
  Sphere2\Material\Reflect=1 
  Sphere2\Material\Refract=0 
  Sphere2Radius=100 
  
  AddSphereObject(Sphere2,Sphere2Radius) 
  
  Light1\Origin\x=-200 
  Light1\Origin\y=200 
  Light1\Origin\z=200 
  Light1\Color\Red=1 
  Light1\Color\Green=1 
  Light1\Color\Blue=1 
  
  AddPointLightObject(Light1) 
  
  Light2\Origin\x=0 
  Light2\Origin\y=-100 
  Light2\Origin\z=-100 
  Light2\Color\Red=1 
  Light2\Color\Green=1 
  Light2\Color\Blue=1 
  
  AddPointLightObject(Light2) 

  MainCamera\ViewingAngle\x=0 
  MainCamera\ViewingAngle\y=0 
  MainCamera\ViewingAngle\z=0 
  
  ; MainScene\Ambient\Red=0.125 
  ; MainScene\Ambient\Green=0.125 ;not active 
  ; MainScene\Ambient\Blue=0.125 
  MainScene\ScreenWidth=320 
  MainScene\ScreenHeight=240 
  MainScene\HalfScreenWidth=MainScene\ScreenWidth/2 
  MainScene\HalfScreenHeight=MainScene\ScreenHeight/2 
  
  InitSprite() 
  OpenWindow(0,0,0,MainScene\ScreenWidth,MainScene\ScreenHeight,"PBRay - FPS: 0",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  OpenWindowedScreen(WindowID(0),0,0,MainScene\ScreenWidth,MainScene\ScreenHeight,0,0,0) 
  
  
  angle.l = 0 
  
  Repeat 
    angle+3 
    frame+1 
    start=ElapsedMilliseconds() 
    
    ClearScreen(RGB(0, 0, 0))
    StartDrawing(ScreenOutput()) 
    
    RenderScene(MainScene,MainCamera,angle) 
    
    StopDrawing() 
    FlipBuffers(0) 
    stop=ElapsedMilliseconds() 
    ;    CallDebugger 
    If stop-start2>=1000 
      start2=ElapsedMilliseconds() 
      fps=frame 
      frame=0 
    EndIf 
    SetWindowTitle(0,"PBRay - FPS: "+Str(fps)+" RenderTime: "+Str(stop-start)+" Angle: "+Str(angle)) 
  Until WindowEvent() = #PB_Event_CloseWindow 
EndProcedure 

TestLoop()
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ------
; DisableDebugger