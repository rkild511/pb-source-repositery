;**********************
;* by djes
;* http://djes.free.fr
;* 4 nov 2005
;**********************

;#PI=3.14159265

Structure matrix
	mat.f[9]
EndStructure

Structure vector
	x.f
	y.f
	z.f
EndStructure

Structure object
	pivot.vector
	rotation.matrix
	parent.l
EndStructure

Structure layer
	object_id.l
	pivot.vector
	rotation.matrix
	parent.l
EndStructure

Structure polygon
	layer_id.l
	points_list.l
	points_nb.l
EndStructure

Structure obj_point
	pos.vector
EndStructure

Structure surface
	polygon_id.l
EndStructure

Global NewList objects.object()
Global NewList layers.layer()
Global NewList polygons.polygon()
Global NewList polygon_points_index.l()
Global NewList points.vector()
Global NewList transformed_points.vector()
; IDE Options = PureBasic v4.00 - Beta 7 (Windows - x86)
; CursorPosition = 6
; Folding = -