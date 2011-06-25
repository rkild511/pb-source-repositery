;**********************
;* by djes
;* http://djes.free.fr
;* 4 nov 2005
;**********************

;IncludePath "..\include\"
XIncludeFile "headers.pb"

;*************************************************************************************************************************************
Procedure.f pi()
 !FLDPI
EndProcedure

;*************************************************************************************************************************************

Procedure matrix_by_matrix_multiply(*a.matrix, *b.matrix) ;/* Return To a */

  Define.matrix tmp

  For i.l = 0 To 2
    For j.l = 0 To 2
      tmp\mat[i+j*3] = *a\mat[i+0*3] * *b\mat[0+j*3] + *a\mat[i+1*3] * *b\mat[1+j*3] + *a\mat[i+2*3] * *b\mat[2+j*3]
    Next
  Next
  For i = 0 To 2
    For j = 0 To 2
      *a\mat[i+j*3] = tmp\mat[i+j*3];
    Next j
  Next i
;/* 3dica:
;   ¦ a b c ¦   ¦ k l m ¦   ¦ ak+bn+cq al+bo+cr am+bp+cs ¦
;   ¦ d e f ¦ * ¦ n o p ¦ = ¦ dk+en+fq dl+eo+fr dm+ep+fs ¦
;   ¦ h i j ¦   ¦ q r s ¦   ¦ hk+in+jq hl+io+jr hm+ip+js ¦
;*/
EndProcedure

;*************************************************************************************************************************************

Procedure matrix_copy(*a.matrix, *b.matrix) ;/* Return To a */

 For i=0 To 8
  *a\mat[i]=*b\mat[i]
 Next i

EndProcedure

;*************************************************************************************************************************************

Procedure matrix_by_vector_multiply(*vekto.vector, *result.vector, *mat.matrix)

 vekx.f=*vekto\x
 veky.f=*vekto\y
 vekz.f=*vekto\z

 *result\x = *mat\mat[0] * vekx + *mat\mat[1] * veky + *mat\mat[2] * vekz;
 *result\y = *mat\mat[3] * vekx + *mat\mat[4] * veky + *mat\mat[5] * vekz;
 *result\z = *mat\mat[6] * vekx + *mat\mat[7] * veky + *mat\mat[8] * vekz;

;/*
; 3dica:
;                ¦ a b c 0 ¦
;   (Xi+Yj+Zk) * ¦ e f g 0 ¦ = (aX+eY+iZ+m)i + (bX+fY+jZ+n)j +
;                ¦ i j k 0 ¦   (cX+gY+kZ+o)k
;                ¦ m n o 1 ¦
;*/
EndProcedure

;*************************************************************************************************************************************

Procedure matrix_rotation(*m.matrix, tangage.f, cap.f, roulis.f)

 sx.f=Sin(tangage)
 sy.f=Sin(cap)
 sz.f=Sin(roulis)

 cx.f=Cos(tangage)
 cy.f=Cos(cap)
 cz.f=Cos(roulis)

 *m\mat[0+0*3] = cy * cz;
 *m\mat[0+1*3] = cy * sz;
 *m\mat[0+2*3] = -sy;

 *m\mat[1+0*3] = sx * sy * cz - cx * sz;
 *m\mat[1+1*3] = sx * sy * sz + cx * cz;
 *m\mat[1+2*3] = sx * cy;

 *m\mat[2+0*3] = cx * sy * cz + sx * sz;
 *m\mat[2+1*3] = cx * sy * sz - sx * cz;
 *m\mat[2+2*3] = cx * cy;

;/*3dica:
;                     ¦ cy*cz          cy*sz          -sy    0 ¦
;                     ¦ sx*sy*cz-cx*sz sx*sy*sz+cx*cz  sx*cy 0 ¦
;       [X]*[Y]*[Z] = ¦ cx*sy*cz+sx*sz cx*sy*sz-sx*cz  cx*cy 0 ¦
;                     ¦ 0              0               0     1 ¦
;*/
EndProcedure

;*************************************************************************************************************************************

Procedure matrix_rotation_around_axis(*m.matrix, *axis.vector, angle.f)

 nx.f=*axis\x
 ny.f=*axis\y
 nz.f=*axis\z

 ;normalize axis
 length.f = Sqr(nx*nx + ny*ny + nz*nz);

 ;// too close To 0, can't make a normalized vector
 If (length < 0.000001) 
  length=0.000001
 EndIf

 nx = nx/length
 ny = ny/length
 nz = nz/length

 sina.f=Sin(angle)
 cosa.f=Cos(angle)

 nx2.f=nx*nx
 ny2.f=ny*ny
 nz2.f=nz*nz

 *m\mat[0+0*3] = nx2 + (1-nx2)*cosa
 *m\mat[0+1*3] = nx*ny*(1-cosa)+nz*sina
 *m\mat[0+2*3] = nx*nz*(1-cosa)-ny*sina

 *m\mat[1+0*3] = nx*ny*(1-cosa)-nz*sina
 *m\mat[1+1*3] = ny2+(1-ny2)*cosa
 *m\mat[1+2*3] = ny*nz*(1-cosa)+nx*sina

 *m\mat[2+0*3] = nx*nz*(1-cosa)+ny*sina
 *m\mat[2+1*3] = ny*nz*(1-cosa)-nx*sina
 *m\mat[2+2*3] = nz2+(1-nz2)*cosa

EndProcedure

;*************************************************************************************************************************************

Procedure matrix_identity(*m.matrix)

 *m\mat[0+0*3] = 1: *m\mat[1+0*3] = 0: *m\mat[2+0*3] = 0;
 *m\mat[0+1*3] = 0: *m\mat[1+1*3] = 1: *m\mat[2+1*3] = 0;
 *m\mat[0+2*3] = 0: *m\mat[1+2*3] = 0: *m\mat[2+2*3] = 1;
;/* 3dica:
;     ¦ 1 0 0 0 ¦
;     ¦ 0 1 0 0 ¦
;     ¦ 0 0 1 0 ¦
;     ¦ 0 0 0 1 ¦
;*/
EndProcedure

;*************************************************************************************************************************************

Procedure matrix_rotate_around_object_axis(*obj_rotation_matrix.matrix, tangage.f, cap.f, roulis.f) ;/* Return To obj_rotation_matrix. */

 Protected axis_x.vector, axis_y.vector, axis_z.vector
 Protected axis_x_rotation_matrix.matrix, axis_y_rotation_matrix.matrix, axis_z_rotation_matrix.matrix

 ;rotation autour de l'axe x de l'objet
 axis_x\x=*obj_rotation_matrix\mat[0+0*3]
 axis_x\y=*obj_rotation_matrix\mat[0+1*3]
 axis_x\z=*obj_rotation_matrix\mat[0+2*3]
 matrix_rotation_around_axis(@axis_x_rotation_matrix, @axis_x, tangage)

 ;rotation autour de l'axe y de l'objet
 axis_y\x=*obj_rotation_matrix\mat[1+0*3]
 axis_y\y=*obj_rotation_matrix\mat[1+1*3]
 axis_y\z=*obj_rotation_matrix\mat[1+2*3]
 matrix_rotation_around_axis(@axis_y_rotation_matrix, @axis_y, cap)

 ;rotation autour de l'axe z de l'objet
 axis_z\x=*obj_rotation_matrix\mat[2+0*3]
 axis_z\y=*obj_rotation_matrix\mat[2+1*3]
 axis_z\z=*obj_rotation_matrix\mat[2+2*3]
 matrix_rotation_around_axis(@axis_z_rotation_matrix, @axis_z, roulis)

 matrix_by_matrix_multiply(@axis_x_rotation_matrix,@axis_y_rotation_matrix)
 matrix_by_matrix_multiply(@axis_x_rotation_matrix,@axis_z_rotation_matrix)
 matrix_by_matrix_multiply(*obj_rotation_matrix,@axis_x_rotation_matrix)
EndProcedure

;*************************************************************************************************************************************

Procedure.f radians(angle.f)
!FLDPI

 ProcedureReturn (angle*2.0*#PI)/360.0
EndProcedure

;*************************************************************************************************************************************

Procedure.f degrees(angle.f)
 ProcedureReturn (angle*360.0)/(2.0*#PI)
EndProcedure

;*************************************************************************************************************************************

Procedure vector_define(*vertex.vector, x, y, z)
 *vertex\x=x
 *vertex\y=y
 *vertex\z=z
EndProcedure

;*************************************************************************************************************************************

Procedure vectors_add(*vertex.vector, *vertex2add.vector)
 *vertex\x+*vertex2add\x
 *vertex\y+*vertex2add\y
 *vertex\z+*vertex2add\z
EndProcedure

;*************************************************************************************************************************************

Procedure vectors_sub(*vertex.vector, *vertex2sub.vector)
 *vertex\x-*vertex2sub\x
 *vertex\y-*vertex2sub\y
 *vertex\z-*vertex2sub\z
EndProcedure

;*************************************************************************************************************************************

Procedure vector_copy(*vertexsrc.vector, *vertexdest.vector)
 *vertexdest\x=*vertexsrc\x
 *vertexdest\y=*vertexsrc\y
 *vertexdest\z=*vertexsrc\z
EndProcedure

;*************************************************************************************************************************************

Procedure vector_rotate(*vertex.vector, *pivot.vector, tangage.f, cap.f, roulis.f)

 vectors_sub(*vertex, *pivot)

 If roulis <> 0
     x.f = Cos(roulis) * *vertex\x - Sin(roulis) * *vertex\z
     *vertex\z = Sin(roulis) * *vertex\x + Cos(roulis) * *vertex\z
     *vertex\x = x
 EndIf

 If tangage <> 0
     y.f = Cos(tangage) * *vertex\y - Sin(tangage) * *vertex\z
     *vertex\z = Sin(tangage) * *vertex\y + Cos(tangage) * *vertex\z
     *vertex\y = y
 EndIf

 If cap <> 0
     x.f = Cos(cap) * *vertex\x - Sin(cap) * *vertex\y
     *vertex\y = Sin(cap) * *vertex\x + Cos(cap) * *vertex\y
     *vertex\x = x
 EndIf

 vectors_add(*vertex, *pivot)

EndProcedure

;*************************************************************************************************************************************

Procedure vector_rotate2(*vertex.vector, *pivot.vector, tangage.f, cap.f, roulis.f )

  cr.f = Cos( tangage );
  sr.f = Sin( tangage );
  cp.f = Cos( roulis  );
  sp.f = Sin( roulis  );
  cy.f = Cos( cap );
  sy.f = Sin( cap );

  Dim m.f(12)
  m(0) = ( cp*cy );
  m(1) = ( cp*sy );
  m(2) = ( -sp );

  srsp.f = sr*sp;
  crsp.f = cr*sp;

  m(4) = ( srsp*cy-cr*sy );
  m(5) = ( srsp*sy+cr*cy );
  m(6) = ( sr*cp );

  m(8) = ( crsp*cy+sr*sy );
  m(9) = ( crsp*sy-sr*cy );
  m(10) = ( cr*cp );

  tmpx.f=*vertex\x
  tmpy.f=*vertex\y
  tmpz.f=*vertex\z

  *vertex\x = tmpx*m(0) + tmpy*m(1) + tmpz*m(2);
  *vertex\y = tmpx*m(4) + tmpy*m(5) + tmpz*m(6);
  *vertex\z = tmpx*m(8) + tmpy*m(9) + tmpz*m(10)

EndProcedure
; IDE Options = PureBasic v4.00 (Windows - x86)
; CursorPosition = 6
; Folding = ---