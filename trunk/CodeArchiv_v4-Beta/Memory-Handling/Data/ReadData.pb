; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=9075#9075
; Author: Caliban
; Date: 12. June 2003
; OS: Windows
; Demo: Yes

For x = 1 To 10 
  Read a 
  Debug a 
Next x 

;Jetzt lassen wir 11-20 aus 
Restore Lable2 

For x = 1 To 10 
  Read a 
  Debug a 
Next x 


DataSection 
  
  Label1: 
  Data.l 1,2,3,4,5,6,7,8,9,10 
  Data.l 11,12,13,14,15,16,17,18,19,20 
  
  Lable2: 
  Data.l 21,22,23,24,25,26,27,28,29,30 

EndDataSection 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
