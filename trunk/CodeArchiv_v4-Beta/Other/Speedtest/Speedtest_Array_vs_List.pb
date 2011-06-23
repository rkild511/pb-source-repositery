; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3221&highlight=
; Author: NicTheQuick
; Date: 23. December 2003
; OS: Windows
; Demo: No

#Max = 1000 

Structure typ 
    x.f 
    y.l 
EndStructure 

NewList liste.typ() 
For i = 1 To #Max 
  AddElement(liste()) 
  liste()\x = 1.2 
  liste()\y = 3 
Next 

Dim array.typ(#Max - 1) 
For i = 0 To #Max - 1 
  array(i)\x = 1.2 
  array(i)\y = 3 
Next 

liste.l = 0 
array.l = 0 
timer.l 
Repeat 
    timer = timeGetTime_() 
    For i = 1 To #Max 
      SelectElement(liste(), Random(#Max - 1)) 
      liste()\x * -1 
      liste()\y * -1 
    Next 
    liste + timeGetTime_() - timer 
    
    timer = timeGetTime_() 
    For i = 1 To #Max 
      a = Random(#Max - 1) 
      array(a)\x * -1 
      array(a)\y * -1 
    Next 
    array + timeGetTime_()-timer 
    
    z+1 
Until z >= 1000 

MessageRequester("info", "List: " + Str(liste) + " ms; Array: " + Str(array) + " ms")
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
