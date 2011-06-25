;EnableDebugger
;DebugLevel 2

IncludePath "include\"
XIncludeFile "lwo_loader.pb"
XIncludeFile "headers.pb"
XIncludeFile "matrix.pb"


InitSprite() 
InitKeyboard()
InitMouse()

hScreen = OpenScreen(800,600,32,"LWO Example")

; *** Open DirectX Screen

If hScreen = 0 
	MessageRequester("Error","Cant open DirectX Screen",0)
	End
EndIf

RandomSeed(ElapsedMilliseconds())

cap.f=0.01
tangage.f=0.015
roulis.f=0.018

; *** Petites variables pour la persp
d.f=2000
ppd.f=-60

Gosub INIT_OBJECTS
Gosub TRANSFORM_OBJECTS

; *** M a i n L o o p
 
Repeat

	ClearScreen(0)

	StartDrawing(ScreenOutput())
		Gosub DRAW_OBJECTS
	StopDrawing()

	FlipBuffers(1)

	; -------- Obj movements --------

	Gosub TRANSFORM_OBJECTS

	; -------- Check Window Events --------

	lEvent.l = WindowEvent()
	While lEvent
		If lEvent = #PB_Event_CloseWindow
			wQuit.w = 1
		EndIf
		lEvent = WindowEvent()
	Wend
	
	; -------- Check if ESCAPE pressed --------
	DisableDebugger
	ExamineKeyboard()
	ExamineMouse()
	If KeyboardPushed(#PB_Key_Space)
		d+100
		If d>10000000
			d=0
		EndIf
	EndIf
	
Until KeyboardPushed(#PB_Key_Escape) Or wQuit

EnableDebugger

CloseScreen()
End


;*** New object

INIT_OBJECTS:

	LWO_Load("cube.lwo")
	matrix_identity(@objects()\rotation)
	LWO_Load("sphere.lwo")
	matrix_identity(@objects()\rotation)
	LWO_Load("cube2.lwo")
	matrix_identity(@objects()\rotation)
  Return

;*** Draw objects

DRAW_OBJECTS:

	ResetList(objects())
	While NextElement(objects())
		object.l=ListIndex(objects())
		ResetList(layers())
		While NextElement(layers())	
			If layers()\object_id=object
				layer.l=ListIndex(layers())
				ResetList(polygons())
				While NextElement(polygons())
					If polygons()\layer_id=layer
						SelectElement(polygon_points_index(), polygons()\points_list)				;locate the first point of this polygon in the index
						SelectElement(transformed_points(),polygon_points_index())					;select the point
						x1.f=transformed_points()\x
						y1.f=transformed_points()\y
						z1.f=transformed_points()\z
						x1t.f=400+(x1*d)/(ppd+z1)
						y1t.f=300+(y1*d)/(ppd+z1)							
						NextElement(polygon_points_index())											;next point in the index
						For u=1 To polygons()\points_nb-1
							SelectElement(transformed_points(),polygon_points_index())				;give the point
							x2.f=transformed_points()\x
							y2.f=transformed_points()\y
							z2.f=transformed_points()\z
							x2t.f=400+(x2*d)/(ppd+z2)
							y2t.f=300+(y2*d)/(ppd+z2)
							LineXY(x1t,y1t,x2t,y2t,$5588FF)
							x1t=x2t
							y1t=y2t
							NextElement(polygon_points_index())
						Next u	
					EndIf
				Wend
			EndIf
		Wend
	Wend		
	Return
	
;*** Transform objects

TRANSFORM_OBJECTS:

	ResetList(objects())
	While NextElement(objects())	
		object.l=ListIndex(objects())
		matrix_rotate_around_object_axis(@objects()\rotation, tangage.f, cap.f, roulis.f)
		ResetList(layers())
		While NextElement(layers())	
			If layers()\object_id=object
				layer.l=ListIndex(layers())
				ResetList(polygons())
				While NextElement(polygons())
					If polygons()\layer_id=layer
						SelectElement(polygon_points_index(), polygons()\points_list)				;locate the first point of this polygon in the index
						For u=1 To polygons()\points_nb
							SelectElement(points(),polygon_points_index())							;select the point
							SelectElement(transformed_points(),polygon_points_index())
							matrix_by_vector_multiply(@points(), @transformed_points(),  @objects()\rotation)
							NextElement(polygon_points_index())
						Next u
					EndIf
				Wend
			EndIf
		Wend
	Wend		
	Return

; IDE Options = PureBasic v4.00 (Windows - x86)
; CursorPosition = 15
; FirstLine = 122
; Folding = -
; EnableAsm
; DisableDebugger