; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2951&highlight=
; Author: RayMan1970
; Date: 27. November 2003
; OS: Windows
; Demo: No


; Der Consolen Befehl PrintN zeigt keine Umlaute. 
; Hier mal eine kleine Abhilfe daf�r ! 
;  
; Code by Rayman1970@Arcor (c) 27.11.03 



Procedure print_s(text.s) 
  
   CharToOem_(text.s,text.s) 
   PrintN( text.s) 
  
EndProcedure 


OpenConsole() 

PrintN("K�he k�nnen vieles fressen da sie Wiederk�uer sind !")  

print_s("K�he k�nnen vieles fressen da sie Wiederk�uer sind !") 

p.s = Input() 

CloseConsole()
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
