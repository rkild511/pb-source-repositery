; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8988&highlight=
; Author: Berikco
; Date: 03. January 2004
; OS: Windows
; Demo: Yes

Structure MyStruct 
  NumericID.l 
EndStructure 

NewList Original.MyStruct() 
NewList TheCopy.MyStruct() 
AddElement(Original()) 
AddElement(TheCopy()) 

Original()\NumericID = 10 

Procedure CopyListItem(*Source.MyStruct, *Destination.MyStruct) 
  *Destination\NumericID = *Source\NumericID 
EndProcedure 

CopyListItem(@Original(), @TheCopy()) 

Debug TheCopy()\NumericID
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
