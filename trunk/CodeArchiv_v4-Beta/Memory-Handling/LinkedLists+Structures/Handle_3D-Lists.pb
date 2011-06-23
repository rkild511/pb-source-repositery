; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9246&highlight=
; Author: GedB (updated for PB 4.00 by Andre)
; Date: 21. January 2004
; OS: Windows
; Demo: Yes

Structure MyPoint 
  x.l 
  y.l 
  z.l 
EndStructure 

#NumberOfPoints = 100 
Structure PointsIndex 
  Points.l[#NumberOfPoints] 
EndStructure 

Global arr.PointsIndex 


MessageRequester("Size of array", Str(SizeOf(arr))) 

Global NewList PointsList.MyPoint() 

Procedure AddPoint(i, x, y, z) 
  If i < #NumberOfPoints 
    ptr = AddElement(PointsList()) 
    If ptr > 0 
      PointsList()\x = x 
      PointsList()\y = y 
      PointsList()\z = z 
      arr\Points[i-1] = ptr + 8 ; Take 1 off i because our index is 1 based.  Add 8 to ptr to allow for the extra values add by linked list 
    Else 
      MessageRequester("Error!", "Unable to allocate memory for new element", #PB_MessageRequester_Ok) 
    EndIf 
  Else 
    MessageRequester("Index out of range", "Unable to allocate memory for new element", #PB_MessageRequester_Ok) 
  EndIf 
EndProcedure 

Procedure.l GetPoint(i) 
  If i < #NumberOfPoints 
    ptr = arr\Points[i-1] 
    If ptr > 0 
      ProcedureReturn ptr 
    Else 
      MessageRequester("Empty position", "Unable to allocate memory for new element", #PB_MessageRequester_Ok) 
    EndIf 
  Else 
    MessageRequester("Index out of range", "Unable to allocate memory for new element", #PB_MessageRequester_Ok) 
  EndIf 
EndProcedure 

Procedure ShowPoint(*p.MyPoint) 
  MessageRequester("MyPoint", "(" + Str(*p\x) + ", " + Str(*p\y) + ", " + Str(*p\z) + ")") 
EndProcedure 
  
AddPoint(5, 10, 11, 12) 
AddPoint(20, 20, 21, 22) 
AddPoint(99, 30, 31, 32) 

ShowPoint(GetPoint(5)) 
ShowPoint(GetPoint(20)) 
ShowPoint(GetPoint(99)) 
 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -