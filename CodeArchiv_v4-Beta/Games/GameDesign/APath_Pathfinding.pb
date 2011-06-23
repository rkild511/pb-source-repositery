; German forum: http://www.purebasic.fr/german/viewtopic.php?t=11552
; Author: Artus
; Date: 09. Janaury 2007
; OS: Windows
; Demo: Yes


; Example for using the APath_Pathfinding.pbi include
  ; Usage:
  ; F1 = Set start point (to mouse cursor)
  ; F2 = Set destination point (to mouse cursor)
  ; F3 = Let the point "walk"...  (Error!)
  ;
  ; 1-3 = Modes of pathfinding
  ;
  ; Delete lists
  ;
  ; Space = Calculate path
  

; Beispiel für die Verwendung der APath_Pathfinding.pbi Include
  ; Verwendung:
  ; F1 = StartPunkt Setzen (auf das Feld unter dem Mauscursor)
  ; F2 = Zielpunkt Setzen (auf das Feld unter dem Mauscursor)
  ; F3 = Punkt laufe lasse (Fehler^^)
  ; 
  ; 1-3 = PathfindungsModi
  ; 
  ; C = ListenLöschen
  ; 
  ; Leertaste = Pfad berechnen



InitSprite()
InitKeyboard()
InitSprite3D()
InitMouse()
UseJPEGImageDecoder()
UseJPEGImageEncoder()

OpenWindow(0,10,10,800,600,"APath V 1.0 - Arthur Studio")
OpenWindowedScreen(WindowID(0),0, 0,800,600,1,0,0)

XIncludeFile "APath_Pathfinding.pbi"


Structure Player
	X.l
	Y.l
	TargetX.l
	TargetY.l
	PathOK.b
	StartTime.f
EndStructure


Global Dim Map.b(8,8)    
APath_CreatePathMap(8, 8) 


Global Player.Player
Player\X = 1
Player\Y = 1
Player\TargetX = 6
Player\TargetY = 6


StartTime.q = 0
CalculateTime.q = 0
PathMode.b = 1

;// ScreenshotFunktion
Global ScreenshotNr.l = 0
Procedure MakeScreenshot()
    DC.l = GetDC_(0)
    MemDC.l = CreateCompatibleDC_(DC)
    ScreenWidth = GetSystemMetrics_(#SM_CXSCREEN)
    ScreenHeight = GetSystemMetrics_(#SM_CYSCREEN)
    ColorDepth = GetDeviceCaps_(DC,#BITSPIXEL)
    BmpID.l = CreateImage(0,ScreenWidth,ScreenHeight)
    SelectObject_(MemDC, BmpID)
    BitBlt_(MemDC, 0, 0, ScreenWidth, ScreenHeight,DC, 0, 0, #SRCCOPY)
    DeleteDC_(MemDC)
    ReleaseDC_(0,DC)
    StartDrawing(ScreenOutput())
    DrawImage(BmpID,0,0)
    SaveImage(0,"Screenshot" + Str(ScreenshotNr) + ".jpg",#PB_ImagePlugin_JPEG,9) 
    StopDrawing()
    ScreenshotNr + 1
EndProcedure



Repeat
	Event = WindowEvent()
	If Event = #PB_Event_CloseWindow
   	End
	EndIf

	ClearScreen($000000)
	ExamineKeyboard()
	ExamineMouse()
  Time.f = ElapsedMilliseconds()/1000

	If KeyboardReleased(#PB_Key_Space)
	  APath_ClearPath()
		StartTime = 0
		CalculateTime = 0
		StartTime = ElapsedMilliseconds()
		If PathMode = 1
		  APath_PathFinding4_Blocked(Player\X,Player\Y,Player\TargetX,Player\TargetY,8,8)
		ElseIf  PathMode = 2
		  APath_PathFinding8_BlockedA(Player\X,Player\Y,Player\TargetX,Player\TargetY,8,8)
		ElseIf  PathMode = 3
		  APath_PathFinding8_BlockedB(Player\X,Player\Y,Player\TargetX,Player\TargetY,8,8)
		EndIf
		CalculateTime = ElapsedMilliseconds() - StartTime
	EndIf 

	If KeyboardReleased(#PB_Key_C)
		APath_ClearPath()
		StartTime = 0
		CalculateTime = 0
	EndIf

  If KeyboardReleased(#PB_Key_F1)
    Player\X = MouseX()/64
    Player\Y = MouseY()/64
  ElseIf KeyboardReleased(#PB_Key_F2)
    Player\TargetX = MouseX()/64
    Player\TargetY = MouseY()/64
  ElseIf KeyboardReleased(#PB_Key_F3)
  	Player\PathOK = 1
  	Player\StartTime = Time
  EndIf
  
  If KeyboardReleased(#PB_Key_F12)
  	MakeScreenshot()
  EndIf
  
  If KeyboardPushed(#PB_Key_1)
    PathMode = 1
  ElseIf KeyboardPushed(#PB_Key_2)
    PathMode = 2
  ElseIf KeyboardPushed(#PB_Key_3)
    PathMode = 3
  EndIf

  If Player\PathOK = 1
    APath_SelectPathPoint()
    If Time - Player\StartTime >= 0.25
      APath_NextPathPoint()
    	Player\X = APath_GivePathPointX()
    	Player\Y = APath_GivePathPointY()
    	Player\StartTime = Time
  	EndIf
  EndIf



  StartDrawing(ScreenOutput())
	
	DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_Transparent)
	For y = 0 To 8
		For x = 0 To 8
			Box(x*64, y*64, 64, 64,$FFFFFF) 
			DrawText(30+(x*64),578,Str(x),$FFFFFF) 
			DrawText(578,30+(y*64),Str(y),$FFFFFF) 
		Next
	Next
	
  
	
	ForEach APath_List()
  	DrawingMode(#PB_2DDrawing_Outlined)
  	Box(APath_List()\X*64, APath_List()\Y*64, 64, 64,$70BD6A) 
  	DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_Transparent)
  	Box((APath_List()\X*64)+1,(APath_List()\Y*64)+1, 62, 62,$7DD382) 
  	
  	DrawText((APath_List()\X*64)+10, APath_List()\Y*64,Str(APath_List()\F))
  	DrawText(APath_List()\X*64,(APath_List()\Y*64)+42,Str(APath_List()\G))
  	DrawText((APath_List()\X*64)+32,(APath_List()\Y*64)+42,Str(APath_List()\H))
  	LineXY((APath_List()\X*64)+32,(APath_List()\Y*64)+32,(APath_List()\ParentX*64)+32,(APath_List()\ParentY*64)+32,$8E9691) 
  Next
	
	ForEach APath_ClosedList()
  	DrawingMode(#PB_2DDrawing_Outlined)
  	Box(APath_ClosedList()\X*64, APath_ClosedList()\Y*64, 64, 64,$FA5B05) 
  	DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_Transparent)
  	Box((APath_ClosedList()\X*64)+1,(APath_ClosedList()\Y*64)+1, 62, 62,$E1A91E) 
  	DrawText((APath_ClosedList()\X*64)+10, APath_ClosedList()\Y*64,Str(APath_ClosedList()\F))
  	DrawText(APath_ClosedList()\X*64,(APath_ClosedList()\Y*64)+42,Str(APath_ClosedList()\G))
  	DrawText((APath_ClosedList()\X*64)+32,(APath_ClosedList()\Y*64)+42,Str(APath_ClosedList()\H))
  	LineXY((APath_ClosedList()\X*64)+32,(APath_ClosedList()\Y*64)+32,(APath_ClosedList()\ParentX*64)+32,(APath_ClosedList()\ParentY*64)+32,$8E9691) 
  Next
	


	
	DrawingMode(#PB_2DDrawing_Default)
	For y = 0 To 8
		For x = 0 To 8
			If Map(x,y) = #True
				Box(x*64, y*64, 64, 64,$FF0000) 
			EndIf
		Next
	Next
	
  Box(Player\TargetX*64, Player\TargetY*64, 64, 64,$0000FF) 
	Box(Player\X*64, Player\Y*64, 64, 64,$00FF00) 
  


	ForEach APath_Points()
  	DrawingMode(#PB_2DDrawing_Default)
  	Circle((APath_Points()\X*64)+32,(APath_Points()\Y*64)+32, 16 ,$6EF6FF) 
  	DrawingMode(#PB_2DDrawing_Outlined)
  	Box(APath_Points()\X*64, APath_Points()\Y*64, 64, 64,$6EF6FF) 
  	Box((APath_Points()\X*64)+1,(APath_Points()\Y*64)+1, 62, 62,$6EF6FF) 
	Next

	DrawingMode(#PB_2DDrawing_Transparent)

	
	Box(MouseX()-4,MouseY()-4, 9, 9,$FFFFFF) 
	If MouseButton(1)
	 APath_SetPathMapBlock(MouseX()/64, MouseY()/64, #True)
	 Map(MouseX()/64, MouseY()/64) = #True
	ElseIf MouseButton(2)
	 APath_SetPathMapBlock(MouseX()/64, MouseY()/64, #False)
	 Map(MouseX()/64, MouseY()/64) = #False
	EndIf
	
	DrawText(10,10,Str(CalculateTime),$6EF6FF)
	DrawText(590,20,"Programmed by Arthur Studio",$B0FFF1)
	
	
	If PathMode = 1
	  DrawText(590,120,"Mode("+Str(PathMode)+"): "+"APath_PathFinding4",$7FD7FF)
	ElseIf  PathMode = 2
	  DrawText(590,120,"Mode("+Str(PathMode)+"): "+"APath_PathFinding8_A",$7FD7FF)
	ElseIf  PathMode = 3
	  DrawText(590,120,"Mode("+Str(PathMode)+"): "+"APath_PathFinding8_B",$7FD7FF)
	EndIf
	

	DrawText(595,150,"1 = "+"APath_PathFinding4",$A2F9FF)
	DrawText(595,165,"2 = "+"APath_PathFinding8_A",$A2F9FF)
	DrawText(595,180,"3 = "+"APath_PathFinding8_B",$A2F9FF)

	
StopDrawing()


FlipBuffers()
Until KeyboardPushed(#PB_Key_Escape)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = +
; EnableXP
; Executable = Test2.dll
; DisableDebugger