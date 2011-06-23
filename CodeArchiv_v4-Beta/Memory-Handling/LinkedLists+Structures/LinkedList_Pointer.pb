; German forum: 
; Author: Unknown
; Date: 31. December 2002
; OS: Windows
; Demo: Yes


NewList Liste.Point() 

Procedure MachWas(*LinkedList.POINT) 
  *LinkedList\x = 12 
  *LinkedList\y = 98 
EndProcedure 

AddElement(Liste()) 

MachWas(@Liste()) 

Debug Liste()\x 
Debug Liste()\y 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -