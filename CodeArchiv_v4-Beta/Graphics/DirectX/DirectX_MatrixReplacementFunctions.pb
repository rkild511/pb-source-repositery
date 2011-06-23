; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9457&highlight=
; Author: traumatic
; Date: 09. February 2004
; OS: Windows
; Demo: Yes


; D3DX Replacement Functions
; --------------------------
; I found the following code on my HD, maybe some of you find this useful. 
; I did this because I hate DLLs and overblown libs... 
; It has initially been written for DX8, but should of course also work
; for other versions (it's just math anyway) ... 
; 
; Note that this is only about the matrix-functions (and only some of them).
; Well, hope you'll get the idea. 
;
; Whatever... provided 'as is': 


; 
; D3DpbMATRIX.pb :: D3DX8 - Matrix Replacement Functions 
; 
; traumatic! '03 
; 
; 
; 

; 
; ------------------------------------------------------------ 
; 

Structure D3DpbMATRIX 
  _11.f : _12.f : _13.f : _14.f 
  _21.f : _22.f : _23.f : _24.f 
  _31.f : _32.f : _33.f : _34.f 
  _41.f : _42.f : _43.f : _44.f 
EndStructure 


Structure D3DpbVECTOR3 
  x.f 
  y.f 
  z.f 
EndStructure 

; 
; ------------------------------------------------------------ 
; 

; 
; vector functions 
; 
Declare.f D3DpbMagnitude(*v.D3DpbVECTOR3) 
Declare   D3DpbNormalize(*v.D3DpbVECTOR3) 
Declare.f D3DpbDot(*v1.D3DpbVECTOR3, *v2.D3DpbVECTOR3) 
Declare   D3DpbCross(*out.D3DpbVECTOR3, *v1.D3DpbVECTOR3, *v2.D3DpbVECTOR3) 
Declare   D3DpbSubstract(*dst.D3DpbVECTOR3, *a.D3DpbVECTOR3, *b.D3DpbVECTOR3) 


; 
; matrix functions 
; 
Declare D3DpbMatrixLookAtLH(*out.D3DpbMATRIX, *eye.D3DpbVECTOR3, *at.D3DpbVECTOR3, *up.D3DpbVECTOR3) 
Declare D3DpbMatrixOrthoLH(*out.D3DpbMATRIX, w.f, h.f, zn.f, zf.f) 
Declare D3DpbMatrixPerspectiveFovLH(*out.D3DpbMATRIX, fov.f, aspect.f, zn.f, zf.f) 
Declare D3DpbMatrixPerspectiveLH(*out.D3DpbMATRIX, w.f, h.f, zn.f, zf.f) 
Declare D3DpbMatrixRotationX(*out.D3DpbMATRIX, angle.f) 
Declare D3DpbMatrixRotationYawPitchRoll(*out.D3DpbMATRIX, yaw.f, pitch.f, roll.f) 
Declare D3DpbMatrixRotationY(*out.D3DpbMATRIX, angle.f) 
Declare D3DpbMatrixRotationZ(*out.D3DpbMATRIX, angle.f) 
Declare D3DpbMatrixScaling(*out.D3DpbMATRIX, sx.f, sy.f, sz.f) 
Declare D3DpbMatrixTranslation(*out.D3DpbMATRIX, x.f, y.f, z.f) 


; 
; ------------------------------------------------------------ 
; 


; magnitude 
Procedure.f D3DpbMagnitude(*v.D3DpbVECTOR3) 
  ProcedureReturn Sqr(*v\x * *v\x + *v\y * *v\y + *v\z * *v\z) 
EndProcedure 

; normalize 
Procedure D3DpbNormalize(*v.D3DpbVECTOR3) 
  len.f = D3DpbMagnitude(*v) 
  *v\x / len : *v\y / len : *v\z / len 
EndProcedure 

; dotproduct 
Procedure.f D3DpbDot(*v1.D3DpbVECTOR3, *v2.D3DpbVECTOR3) 
  ProcedureReturn *v1\x * *v2\x + *v1\y * *v2\y + *v1\z * *v2\z 
EndProcedure 

; crossproduct 
Procedure D3DpbCross(*out.D3DpbVECTOR3, *v1.D3DpbVECTOR3, *v2.D3DpbVECTOR3) 
  *out\x = (*v1\y * *v2\z) - (*v1\z * *v2\y) 
  *out\y = (*v1\z * *v2\x) - (*v1\x * *v2\z) 
  *out\z = (*v1\x * *v2\y) - (*v1\y * *v2\x) 
EndProcedure 

; subtraction 
Procedure D3DpbSubstract(*out.D3DpbVECTOR3, *a.D3DpbVECTOR3, *b.D3DpbVECTOR3) 
  *out\x = *a\x - *b\x 
  *out\y = *a\y - *b\y 
  *out\z = *a\z - *b\z 
EndProcedure 

; 
; ------------------------------------------------------------ 
; 

; 
; Builds a left-handed perspective projection matrix 
; 
Procedure D3DpbMatrixLookAtLH(*out.D3DpbMATRIX, *eye.D3DpbVECTOR3, *at.D3DpbVECTOR3, *up.D3DpbVECTOR3) 
  ; zaxis = normal(At - Eye)  
  D3DpbSubstract(zaxis.D3DpbVECTOR3, *at, *eye) 
  D3DpbNormalize(zaxis.D3DpbVECTOR3) 

  ; xaxis = normal(cross(Up, zaxis))  
  D3DpbCross(xaxis.D3DpbVECTOR3, *up, zaxis) 
  D3DpbNormalize(xaxis) 

  ; yaxis = cross(zaxis, xaxis)  
  D3DpbCross(yaxis.D3DpbVECTOR3, zaxis, xaxis) 
  
  xdot.f = D3DpbDot(xaxis, *eye) 
  ydot.f = D3DpbDot(yaxis, *eye) 
  zdot.f = D3DpbDot(zaxis, *eye)  
  
  *out\_11 = xaxis\x : *out\_12 = yaxis\x : *out\_13 = zaxis\x : *out\_14 = 0.0 
  *out\_21 = xaxis\y : *out\_22 = yaxis\y : *out\_23 = zaxis\y : *out\_24 = 0.0 
  *out\_31 = xaxis\z : *out\_32 = yaxis\z : *out\_33 = zaxis\z : *out\_34 = 0.0 
  *out\_41 = -xdot   : *out\_42 = -ydot   : *out\_43 = -zdot   : *out\_44 = 1.0 
EndProcedure 

; 
; Builds a left-handed orthogonal projection matrix. 
; 
Procedure D3DpbMatrixOrthoLH(*out.D3DpbMATRIX, w.f, h.f, zn.f, zf.f) 
  *out\_11 = 2/w  : *out\_12 = 0.0  : *out\_13 = 0.0        : *out\_14 = 0.0 
  *out\_21 = 0.0  : *out\_22 = 2/h  : *out\_23 = 0.0        : *out\_24 = 0.0 
  *out\_31 = 0.0  : *out\_32 = 0.0  : *out\_33 = 1/(zf-zf)  : *out\_34 = 0.0 
  *out\_41 = 0.0  : *out\_42 = 0.0  : *out\_43 = zn/(zn-zf) : *out\_44 = 1.0 
EndProcedure 

; 
; Builds a left-handed perspective projection matrix based on a field of view (FOV). 
; 
Procedure D3DpbMatrixPerspectiveFovLH(*out.D3DpbMATRIX, fov.f, aspect.f, zn.f, zf.f) 
  h.f = Cos(fov/2) / Sin(fov/2) 
  w.f= h / aspect 

  *out\_11 = 2*zn/w : *out\_12 = 0.0    : *out\_13 = 0.0            : *out\_14 = 0.0 
  *out\_21 = 0.0    : *out\_22 = 2*zn/h : *out\_23 = 0.0            : *out\_24 = 0.0 
  *out\_31 = 0.0    : *out\_32 = 0.0    : *out\_33 = zf/(zf-zn)     : *out\_34 = 1.0 
  *out\_41 = 0.0    : *out\_42 = 0.0    : *out\_43 = zn*zf/(zn-zf)  : *out\_44 = 0.0 
EndProcedure 

; 
; Builds a left-handed perspective projection matrix 
; 
Procedure D3DpbMatrixPerspectiveLH(*out.D3DpbMATRIX, w.f, h.f, zn.f, zf.f) 
  *out\_11 = 2*zn/w : *out\_12 = 0.0    : *out\_13 = 0.0            : *out\_14 = 0.0 
  *out\_21 = 0.0    : *out\_22 = 2*zn/h : *out\_23 = 0.0            : *out\_24 = 0.0 
  *out\_31 = 0.0    : *out\_32 = 0.0    : *out\_33 = zf/(zf-zn)     : *out\_34 = 1.0 
  *out\_41 = 0.0    : *out\_42 = 0.0    : *out\_43 = zn*zf/(zn-zf)  : *out\_44 = 0.0 
EndProcedure 

; 
; Builds a matrix that rotates around the x-axis. 
; 
Procedure D3DpbMatrixRotationX(*out.D3DpbMATRIX, angle.f) 
   tsin.f = Sin(angle) 
   tcos.f = Cos(angle) 

  *out\_11 = 1.0  : *out\_12 = 0.0    : *out\_13 = 0.0  : *out\_14 = 0.0 
  *out\_21 = 0.0  : *out\_22 =  tcos  : *out\_23 = tsin : *out\_24 = 0.0 
  *out\_31 = 0.0  : *out\_32 = -tsin  : *out\_33 = tcos : *out\_34 = 0.0 
  *out\_41 = 0.0  : *out\_42 = 0.0    : *out\_43 = 0.0  : *out\_44 = 1.0 
EndProcedure 

; 
; Builds a matrix that rotates around the Y-axis. 
; 
Procedure D3DpbMatrixRotationY(*out.D3DpbMATRIX, angle.f) 
   tsin.f = Sin(angle) 
   tcos.f = Cos(angle) 

  *out\_11 = tcos : *out\_12 = 0.0  : *out\_13 = -tsin  : *out\_14 = 0.0 
  *out\_21 = 0.0  : *out\_22 = 1.0  : *out\_23 =  0.0   : *out\_24 = 0.0 
  *out\_31 = tsin : *out\_32 = 0.0  : *out\_33 =  tcos  : *out\_34 = 0.0 
  *out\_41 = 0.0  : *out\_42 = 0.0  : *out\_43 =  0.0   : *out\_44 = 1.0 
EndProcedure 

; 
; Builds a matrix with a specified yaw, pitch, and roll. 
; 
Procedure D3DpbMatrixRotationYawPitchRoll(*out.D3DpbMATRIX, yaw.f, pitch.f, roll.f) 
  D3DpbMatrixRotationZ(*out.D3DpbMATRIX, roll) 
  D3DpbMatrixRotationX(*out.D3DpbMATRIX, pitch) 
  D3DpbMatrixRotationY(*out.D3DpbMATRIX, yaw) 
EndProcedure 


; 
; Builds a matrix that rotates around the Z-axis. 
; 
Procedure D3DpbMatrixRotationZ(*out.D3DpbMATRIX, angle.f) 
   tsin.f = Sin(angle) 
   tcos.f = Cos(angle) 

  *out\_11 =  tcos  : *out\_12 = tsin : *out\_13 = 0.0  : *out\_14 = 0.0 
  *out\_21 = -tsin  : *out\_22 = tcos : *out\_23 = 0.0  : *out\_24 = 0.0 
  *out\_31 =  0.0   : *out\_32 = 0.0  : *out\_33 = 1.0  : *out\_34 = 0.0 
  *out\_41 =  0.0   : *out\_42 = 0.0  : *out\_43 = 0.0  : *out\_44 = 1.0 
EndProcedure 

; 
; Builds a matrix that scales along the x-, y-, and z-axes. 
; 
Procedure D3DpbMatrixScaling(*out.D3DpbMATRIX, sx.f, sy.f, sz.f) 
  *out\_11 = sx   : *out\_12 = 0.0 : *out\_13 = 0.0 : *out\_14 = 0.0 
  *out\_21 = 0.0  : *out\_22 = sy  : *out\_23 = 0.0 : *out\_24 = 0.0 
  *out\_31 = 0.0  : *out\_32 = 0.0 : *out\_33 = sz  : *out\_34 = 0.0 
  *out\_41 = 0.0  : *out\_42 = 0.0 : *out\_43 = 0.0 : *out\_44 = 1.0 
EndProcedure 

; 
; Builds a matrix using the specified offsets. 
; 
Procedure D3DpbMatrixTranslation(*out.D3DpbMATRIX, x.f, y.f, z.f) 
  *out\_11 = 1.0 : *out\_12 = 0.0 : *out\_13 = 0.0  : *out\_14 = 0.0 
  *out\_21 = 0.0 : *out\_22 = 1.0 : *out\_23 = 0.0  : *out\_24 = 0.0 
  *out\_31 = 0.0 : *out\_32 = 0.0 : *out\_33 = 1.0  : *out\_34 = 0.0 
  *out\_41 = x   : *out\_42 = y   : *out\_43 = z    : *out\_44 = 1.0 
EndProcedure 
 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ---