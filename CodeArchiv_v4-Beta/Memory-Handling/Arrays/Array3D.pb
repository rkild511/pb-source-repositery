; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2982
; Author: NicTheQuick (updated for PB 4.00 by Andre)
; Date: 02. December 2003
; OS: Windows
; Demo: No

Structure MapID 
  id.l 
  MapHandle.l 
EndStructure 
Global NewList MapID.MapID() 

Procedure CreateMap(id.l, Width.l, Height.l) 
  Protected MapHandle.l, *Size.POINT 
  MapHandle = GlobalAlloc_(#GPTR, ((Width * Height) - 1) * SizeOf(POINT) + 8) 
  If MapHandle 
    *Size = MapHandle 
    *Size\x = Width 
    *Size\y = Height 
    AddElement(MapID()) 
    MapID()\id = id 
    MapID()\MapHandle = MapHandle 
    ProcedureReturn MapHandle 
  EndIf 
  ProcedureReturn 0 
EndProcedure 

Procedure GetMapHandle(id.l) 
  ForEach MapID() 
    If MapID()\id = id 
      ProcedureReturn MapID()\MapHandle 
    EndIf 
  Next 
EndProcedure 

Procedure SetValue_X(MapHandle.l, x.l, y.l, Value_X.l) 
  Protected *Field.POINT, *Size.POINT 
  *Size = MapHandle 
  *Field = MapHandle + 8 + ((x * *Size\x) + y) * SizeOf(POINT) 
  *Field\x = Value_X 
EndProcedure 
Procedure SetValue_Y(MapHandle.l, x.l, y.l, Value_Y.l) 
  Protected *Field.POINT, *Size.POINT 
  *Size = MapHandle 
  *Field = MapHandle + 8 + ((x * *Size\x) + y) * SizeOf(POINT) 
  *Field\y = Value_Y 
EndProcedure 

Procedure GetValue_X(MapHandle.l, x.l, y.l) 
  Protected *Field.POINT, *Size.POINT 
  *Size = MapHandle 
  *Field = MapHandle + 8 + ((x * *Size\x) + y) * SizeOf(POINT) 
  ProcedureReturn *Field\x 
EndProcedure 
Procedure GetValue_Y(MapHandle.l, x.l, y.l) 
  Protected *Field.POINT, *Size.POINT 
  *Size = MapHandle 
  *Field = MapHandle + 8 + ((x * *Size\x) + y) * SizeOf(POINT) 
  ProcedureReturn *Field\y 
EndProcedure 

CreateMap(0, 2, 2) 

MapHandle = GetMapHandle(0) 

SetValue_X(MapHandle, 0, 0, 0) 
SetValue_X(MapHandle, 0, 1, 1) 
SetValue_X(MapHandle, 1, 0, 2) 
SetValue_X(MapHandle, 1, 1, 3) 

SetValue_Y(MapHandle, 0, 0, 4) 
SetValue_Y(MapHandle, 0, 1, 5) 
SetValue_Y(MapHandle, 1, 0, 6) 
SetValue_Y(MapHandle, 1, 1, 7) 

Debug GetValue_X(MapHandle, 0, 0) 
Debug GetValue_X(MapHandle, 0, 1) 
Debug GetValue_X(MapHandle, 1, 0) 
Debug GetValue_X(MapHandle, 1, 1) 

Debug GetValue_Y(MapHandle, 0, 0) 
Debug GetValue_Y(MapHandle, 0, 1) 
Debug GetValue_Y(MapHandle, 1, 0) 
Debug GetValue_Y(MapHandle, 1, 1)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
