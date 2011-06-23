; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2999&highlight=
; Author: neotoma
; Date: 03. December 2003
; OS: Windows
; Demo: Yes


;Demonstration, wie man eine Strucure innerhalb einer 
;LinkedList tauschen kann. Hier wird es zum mischen genutzt. 
; 

;Demonstration, how to exchange a structure in a LinkedList. 
;Example shows a shuffle. 
; 

;Structure to use 
Structure tag 
  id.l 
  name.s 
EndStructure 

;LinkedList 
Global NewList shuffletest.tag() 

;This Procedure shuffles the LinkedList 
;max - how often to shuffle 
Procedure Shuffle(max.l) 
  temp.tag 
  tagsize.l = SizeOf(tag) 
  sh_count= CountList(shuffletest()) 
  For ii = 0 To max    
    SelectElement(shuffletest(),Random(sh_count)) 
    first.l = @shuffletest() 
    SelectElement(shuffletest(),Random(sh_count)) 
    second.l = @shuffletest() 

    CopyMemory(first, @temp, tagsize) 
    CopyMemory(second,first, tagsize) 
    CopyMemory(@temp,second, tagsize) 
  Next    
EndProcedure 

;makes this Example life with a 
;small LinkedList 
For i = 1 To 100 
  AddElement(shuffletest()) 
  shuffletest()\id = i 
  shuffletest()\name = "User" + Str(i) 
Next 

RandomSeed(Date()) 

;Do the shuffle 
Shuffle(1000)  

;Spit out the result 
ResetList(shuffletest()) 
While NextElement(shuffletest()) 
Debug("Id:" + Str(shuffletest()\id) + " // User:" +shuffletest()\name) 
Wend 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
