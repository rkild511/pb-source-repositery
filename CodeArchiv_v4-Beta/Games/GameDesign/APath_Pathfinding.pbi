; German forum: http://www.purebasic.fr/german/viewtopic.php?t=11552
; Author: Artus
; Date: 09. Janaury 2007
; OS: Windows
; Demo: Yes

;// *********************************************** //;
;// * APath.pb                                      //;
;// * 14.11.06        
;// *Programmed by Arthur
;// *********************************************** //;



Structure APath_Field
	X.l
	Y.l
	ParentX.l
	ParentY.l
	F.l
	G.l
	H.l
	Cost.b
EndStructure

Structure APath_Point
  X.l
  Y.l
  Cost.b
EndStructure


Structure APath_Map
  Blocked.b
  Type.l
EndStructure


Global Dim APath_Map.APath_Map(0,0)

Global NewList APath_Points.APath_Point() ;// Liste der fertigem Weges
Global NewList APath_List.APath_Field()
Global NewList APath_ClosedList.APath_Field()

Global APath_Cost.b
Global APath_NormalCost.b = 2
Global APath_CrossOverCost.b = 3
Global APath_Cycles = 100
Global APath_SelectPathPoint

Procedure APath_PathFinding8_BlockedA(StartX.l,StartY.l,EndX.l,EndY.l,MapX.l,MapY.l)
	
	If APath_Map(EndX,EndY)\Blocked = #True 
	  ProcedureReturn #False
	ElseIf StartX = EndX And StartY = EndY
	  ProcedureReturn #False
	EndIf
	
	
	Static ElementExist.b, Pointer.Point
	
	AddElement(APath_ClosedList())
	APath_ClosedList()\X = StartX
	APath_ClosedList()\Y = StartY
	APath_ClosedList()\ParentX = StartX
	APath_ClosedList()\ParentY = StartY
		
	Pointer\X = StartX
	Pointer\Y = StartY

	Repeat
    If Pointer\Y = 0      : PYa = 0 : Else : PYa = 1 : EndIf
		If Pointer\Y = MapY   : PYb = 0 : Else : PYb = 1 : EndIf
		If Pointer\X = 0      : PXa = 0 : Else : PXa = 1 : EndIf
		If Pointer\X = MapX   : PXb = 0 : Else : PXb = 1 : EndIf

		For PY = Pointer\Y - PYa To Pointer\Y + PYb
		For PX = Pointer\X - PXa To Pointer\X + PXb
      If PX <> Pointer\X Or PY <> Pointer\Y ;// ist das Feld nicht der Pointer(Ursprungsfeld)
							
				If Not APath_Map(PX,PY)\Blocked = #True ;// Schaut ob Feld Blockiert ist
					ElementExist = 0
					
				  ;////
  				If    PX = Pointer\X - 1 And PY = Pointer\Y - 1 
            If APath_Map(PX+PXb,PY)\Blocked = #True Or APath_Map(PX,PY+PYb)\Blocked = #True
  				    ElementExist = 2
  				  EndIf
          ElseIf PX = Pointer\X + 1 And PY = Pointer\Y - 1 
            If APath_Map(PX-PXa,PY)\Blocked = #True Or APath_Map(PX,PY+PYb)\Blocked = #True
  				    ElementExist = 2
            EndIf
          ElseIf PX = Pointer\X + 1 And PY = Pointer\Y + 1
            If APath_Map(PX-PXa,PY)\Blocked = #True Or APath_Map(PX,PY-PYa)\Blocked = #True
  				    ElementExist = 2
  				  EndIf
  				ElseIf PX = Pointer\X - 1 And PY = Pointer\Y + 1 
  				  If APath_Map(PX+PXb,PY)\Blocked = #True Or APath_Map(PX,PY-PYa)\Blocked = #True
  				    ElementExist = 2
  				  EndIf
  				EndIf
  				;//// 				
					
					ForEach APath_List()
						If PX = APath_List()\X And PY = APath_List()\Y
							ElementExist = 1
							Break
						EndIf
					Next
					If ElementExist = 0
						ForEach APath_ClosedList()
							If PX = APath_ClosedList()\X And PY = APath_ClosedList()\Y
								ElementExist = 2
								Break
							EndIf
						Next
					EndIf
					


					
          LastElement(APath_ClosedList())
          If PX <> Pointer\X And PY <> Pointer\Y
            G_Step=14
            APath_Cost = APath_CrossOverCost
          Else
            G_Step=10
            APath_Cost = APath_NormalCost
          EndIf
          If ElementExist = 0
            AddElement(APath_List())
            APath_List()\X = PX
            APath_List()\Y = PY
            APath_List()\ParentX = Pointer\X
            APath_List()\ParentY = Pointer\Y
            APath_List()\G = APath_ClosedList()\G + G_Step
            APath_List()\H = (Abs(PX-EndX) + Abs(PY-EndY))*10
            APath_List()\F = APath_List()\H + APath_List()\G
            APath_List()\Cost = APath_Cost
          ElseIf ElementExist = 1         
            If APath_ClosedList()\G + G_Step < APath_List()\G
              APath_List()\X = PX
              APath_List()\Y = PY
              APath_List()\ParentX = Pointer\X
              APath_List()\ParentY = Pointer\Y
              APath_List()\G = APath_ClosedList()\G + G_Step
              APath_List()\H = (Abs(PX-EndX) + Abs(PY-EndY))*10
              APath_List()\F = APath_List()\H + APath_List()\G
              APath_List()\Cost = APath_Cost
            EndIf
          EndIf
        EndIf
      EndIf
		Next
		Next
			
    If CountList(APath_List()) = 0 
     ProcedureReturn #False
    EndIf
	
		SortStructuredList(APath_List(), 0, OffsetOf(APath_Field\F), #PB_Sort_Long)
		FirstElement(APath_List()) 
	
		AddElement(APath_ClosedList())
		APath_ClosedList()\X = APath_List()\X
		APath_ClosedList()\Y = APath_List()\Y
		APath_ClosedList()\ParentX = APath_List()\ParentX
		APath_ClosedList()\ParentY = APath_List()\ParentY	
		APath_ClosedList()\G	= APath_List()\G	
		APath_ClosedList()\H = APath_List()\H
		APath_ClosedList()\F = APath_List()\F
		APath_ClosedList()\Cost = APath_List()\Cost
		Pointer\X = APath_ClosedList()\X
		Pointer\Y = APath_ClosedList()\Y
		DeleteElement(APath_List())

    Lili + 1
		If Pointer\X = EndX And Pointer\Y = EndY
			Lili = APath_Cycles
		EndIf
	Until Lili = APath_Cycles

	LastElement(APath_ClosedList())

	AddElement(APath_Points())
	APath_Points()\X = APath_ClosedList()\X
	APath_Points()\Y = APath_ClosedList()\Y
	APath_Points()\Cost = APath_ClosedList()\Cost
	Pointer\X = APath_Points()\X 
	Pointer\Y = APath_Points()\Y

	Repeat
		ForEach APath_ClosedList()
			If APath_ClosedList()\X = Pointer\X And APath_ClosedList()\Y = Pointer\Y
				AddElement(APath_Points())
				APath_Points()\X = APath_ClosedList()\ParentX
				APath_Points()\Y = APath_ClosedList()\ParentY
				APath_Points()\Cost = APath_ClosedList()\Cost
				Pointer\X = APath_Points()\X 
				Pointer\Y = APath_Points()\Y
			EndIf
		Next
	Until Pointer\X = StartX And Pointer\Y = StartY
	
	DeleteElement(APath_Points())
	LastElement(APath_Points())
	ProcedureReturn #True
EndProcedure

Procedure APath_PathFinding8_BlockedB(StartX.l,StartY.l,EndX.l,EndY.l,MapX.l,MapY.l)
	If APath_Map(EndX,EndY)\Blocked = #True 
	  ProcedureReturn #False
	ElseIf StartX = EndX And StartY = EndY
	  ProcedureReturn #False
	EndIf
	
	Static ElementExist.b, Pointer.Point
	
	AddElement(APath_ClosedList())
	APath_ClosedList()\X = StartX
	APath_ClosedList()\Y = StartY
	APath_ClosedList()\ParentX = StartX
	APath_ClosedList()\ParentY = StartY
		
	Pointer\X = StartX
	Pointer\Y = StartY

	Repeat
    If Pointer\Y = 0      : PYa = 0 : Else : PYa = 1 : EndIf
		If Pointer\Y = MapY   : PYb = 0 : Else : PYb = 1 : EndIf
		If Pointer\X = 0      : PXa = 0 : Else : PXa = 1 : EndIf
		If Pointer\X = MapX   : PXb = 0 : Else : PXb = 1 : EndIf

		For PY = Pointer\Y - PYa To Pointer\Y + PYb
		For PX = Pointer\X - PXa To Pointer\X + PXb
      If PX <> Pointer\X Or PY <> Pointer\Y ;// ist das Feld nicht der Pointer(Ursprungsfeld)
							
				If Not APath_Map(PX,PY)\Blocked = #True ;// Schaut ob Feld Blockiert ist
					ElementExist = 0
					ForEach APath_List()
						If PX = APath_List()\X And PY = APath_List()\Y
							ElementExist = 1
							Break
						EndIf
					Next
					If ElementExist = 0
						ForEach APath_ClosedList()
							If PX = APath_ClosedList()\X And PY = APath_ClosedList()\Y
								ElementExist = 2
								Break
							EndIf
						Next
					EndIf
					
          LastElement(APath_ClosedList())
          If PX <> Pointer\X And PY <> Pointer\Y
            G_Step=14
          Else
            G_Step=10
          EndIf
          If ElementExist = 0
            AddElement(APath_List())
            APath_List()\X = PX
            APath_List()\Y = PY
            APath_List()\ParentX = Pointer\X
            APath_List()\ParentY = Pointer\Y
            APath_List()\G = APath_ClosedList()\G + G_Step
            APath_List()\H = (Abs(PX-EndX) + Abs(PY-EndY))*10
            APath_List()\F = APath_List()\H + APath_List()\G
          ElseIf ElementExist = 1         
            If APath_ClosedList()\G + G_Step < APath_List()\G
              APath_List()\X = PX
              APath_List()\Y = PY
              APath_List()\ParentX = Pointer\X
              APath_List()\ParentY = Pointer\Y
              APath_List()\G = APath_ClosedList()\G + G_Step
              APath_List()\H = (Abs(PX-EndX) + Abs(PY-EndY))*10
              APath_List()\F = APath_List()\H + APath_List()\G
            EndIf
          EndIf
        EndIf
      EndIf
		Next
		Next
		
		If CountList(APath_List()) = 0 
     ProcedureReturn #False
    EndIf
	
		SortStructuredList(APath_List(), 0, OffsetOf(APath_Field\F), #PB_Sort_Long)
		FirstElement(APath_List()) 
	
		AddElement(APath_ClosedList())
		APath_ClosedList()\X = APath_List()\X
		APath_ClosedList()\Y = APath_List()\Y
		APath_ClosedList()\ParentX = APath_List()\ParentX
		APath_ClosedList()\ParentY = APath_List()\ParentY	
		APath_ClosedList()\G	= APath_List()\G	
		APath_ClosedList()\H = APath_List()\H
		APath_ClosedList()\F = APath_List()\F
		Pointer\X = APath_ClosedList()\X
		Pointer\Y = APath_ClosedList()\Y
		DeleteElement(APath_List())

    Lili + 1
		If Pointer\X = EndX And Pointer\Y = EndY
			Lili = APath_Cycles
		EndIf
	Until Lili = APath_Cycles


	LastElement(APath_ClosedList())

	AddElement(APath_Points())
	APath_Points()\X = APath_ClosedList()\X
	APath_Points()\Y = APath_ClosedList()\Y
	Pointer\X = APath_Points()\X 
	Pointer\Y = APath_Points()\Y

	Repeat
		ForEach APath_ClosedList()
			If APath_ClosedList()\X = Pointer\X And APath_ClosedList()\Y = Pointer\Y
				AddElement(APath_Points())
				APath_Points()\X = APath_ClosedList()\ParentX
				APath_Points()\Y = APath_ClosedList()\ParentY
				Pointer\X = APath_Points()\X 
				Pointer\Y = APath_Points()\Y
			EndIf
		Next
	Until Pointer\X = StartX And Pointer\Y = StartY
	
	DeleteElement(APath_Points())
	LastElement(APath_Points())
	ProcedureReturn #True
EndProcedure

Procedure APath_PathFinding4_Blocked(StartX.l,StartY.l,EndX.l,EndY.l,MapX.l,MapY.l)
	If APath_Map(EndX,EndY)\Blocked = #True 
	  ProcedureReturn #False
	ElseIf StartX = EndX And StartY = EndY
	  ProcedureReturn #False
	EndIf
	
	Static ElementExist.b, Pointer.Point
	
	AddElement(APath_ClosedList())
	APath_ClosedList()\X = StartX
	APath_ClosedList()\Y = StartY
	APath_ClosedList()\ParentX = StartX
	APath_ClosedList()\ParentY = StartY
		
	Pointer\X = StartX
	Pointer\Y = StartY

	Repeat
    If Pointer\Y = 0      : PYa = 0 : Else : PYa = 1 : EndIf
		If Pointer\Y = MapY   : PYb = 0 : Else : PYb = 1 : EndIf
		If Pointer\X = 0      : PXa = 0 : Else : PXa = 1 : EndIf
		If Pointer\X = MapX   : PXb = 0 : Else : PXb = 1 : EndIf

		For PY = Pointer\Y - PYa To Pointer\Y + PYb
		For PX = Pointer\X - PXa To Pointer\X + PXb
      If PX = Pointer\X Or PY = Pointer\Y ;// ist das Feld nicht der Pointer(Ursprungsfeld)
				
				If Not APath_Map(PX,PY)\Blocked = #True ;// Schaut ob Feld Blockiert ist
					ElementExist = 0
					ForEach APath_List()
						If PX = APath_List()\X And PY = APath_List()\Y
							ElementExist = 1
							Break
						EndIf
					Next
					If ElementExist = 0
						ForEach APath_ClosedList()
							If PX = APath_ClosedList()\X And PY = APath_ClosedList()\Y
								ElementExist = 2
								Break
							EndIf
						Next
					EndIf
					
          LastElement(APath_ClosedList())
          If PX <> Pointer\X And PY <> Pointer\Y
            G_Step=14
          Else
            G_Step=10
          EndIf
          If ElementExist = 0
            AddElement(APath_List())
            APath_List()\X = PX
            APath_List()\Y = PY
            APath_List()\ParentX = Pointer\X
            APath_List()\ParentY = Pointer\Y
            APath_List()\G = APath_ClosedList()\G + G_Step
            APath_List()\H = (Abs(PX-EndX) + Abs(PY-EndY))*10
            APath_List()\F = APath_List()\H + APath_List()\G
          ElseIf ElementExist = 1         
            If APath_ClosedList()\G + G_Step < APath_List()\G
              APath_List()\X = PX
              APath_List()\Y = PY
              APath_List()\ParentX = Pointer\X
              APath_List()\ParentY = Pointer\Y
              APath_List()\G = APath_ClosedList()\G + G_Step
              APath_List()\H = (Abs(PX-EndX) + Abs(PY-EndY))*10
              APath_List()\F = APath_List()\H + APath_List()\G
            EndIf
          EndIf
        EndIf
      EndIf
		Next
		Next
			
    If CountList(APath_List()) = 0 
     ProcedureReturn #False
    EndIf
	
		SortStructuredList(APath_List(), 0, OffsetOf(APath_Field\F), #PB_Sort_Long)
		FirstElement(APath_List()) 
	
		AddElement(APath_ClosedList())
		APath_ClosedList()\X = APath_List()\X
		APath_ClosedList()\Y = APath_List()\Y
		APath_ClosedList()\ParentX = APath_List()\ParentX
		APath_ClosedList()\ParentY = APath_List()\ParentY	
		APath_ClosedList()\G	= APath_List()\G	
		APath_ClosedList()\H = APath_List()\H
		APath_ClosedList()\F = APath_List()\F
		Pointer\X = APath_ClosedList()\X
		Pointer\Y = APath_ClosedList()\Y
		DeleteElement(APath_List())

    Lili + 1
		If Pointer\X = EndX And Pointer\Y = EndY
			Lili = APath_Cycles
		EndIf
	Until Lili = APath_Cycles

	LastElement(APath_ClosedList())

	AddElement(APath_Points())
	APath_Points()\X = APath_ClosedList()\X
	APath_Points()\Y = APath_ClosedList()\Y
	Pointer\X = APath_Points()\X 
	Pointer\Y = APath_Points()\Y

	Repeat
		ForEach APath_ClosedList()
			If APath_ClosedList()\X = Pointer\X And APath_ClosedList()\Y = Pointer\Y
				AddElement(APath_Points())
				APath_Points()\X = APath_ClosedList()\ParentX
				APath_Points()\Y = APath_ClosedList()\ParentY
				Pointer\X = APath_Points()\X 
				Pointer\Y = APath_Points()\Y
			EndIf
		Next
	Until Pointer\X = StartX And Pointer\Y = StartY
	
	DeleteElement(APath_Points())
	LastElement(APath_Points())
EndProcedure


Procedure APath_ClearPath()
  ClearList(APath_Points())
  ClearList(APath_List())
  ClearList(APath_ClosedList())
EndProcedure

Procedure APath_NextPathPoint()
	If APath_SelectPathPoint = 0
		LastElement(APath_Points())
		APath_SelectPathPoint = ListIndex(APath_Points())+1
	EndIf
		APath_SelectPathPoint-1
		SelectElement(APath_Points(),APath_SelectPathPoint)
EndProcedure

Procedure APath_SelectPathPoint()
	SelectElement(APath_Points(),APath_SelectPathPoint)
EndProcedure

Procedure.l APath_GivePathPointX()
	ProcedureReturn APath_Points()\X
EndProcedure

Procedure.l APath_GivePathPointY()
	ProcedureReturn APath_Points()\Y
EndProcedure

Procedure.l APath_GiveFieldCost()
	ProcedureReturn APath_Points()\Cost
EndProcedure

Procedure APath_CreatePathMap(MapSizeX.l, MapSizeY.l) 
  Global Dim APath_Map.APath_Map(MapSizeX,MapSizeY)
EndProcedure

Procedure APath_SetPathMapBlock(X.l, Y.l, Blocked.b)
  APath_Map(X, Y)\Blocked = Blocked
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = H3