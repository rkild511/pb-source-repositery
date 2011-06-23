; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13449&highlight=
; Author: dom (updated for PB 4.00 by Andre)
; Date: 23. December 2004
; OS: Windows
; Demo: Yes


; PureBasic's StringField() function can only accept a delimiter of ONE character. 
; This function removes this restriction, and is handy with delimiters like "stop". 

Procedure.s stringfield2(var$,indice,p$) 
lp=Len(p$) 
bak=1 
Repeat 
  x=FindString(var$+p$,p$,bak+1) 
  If x 
    c+1 
    If c=indice 
      ProcedureReturn Mid(var$,bak,x-(bak)) 
    EndIf 
    bak=x+lp 
  EndIf        
Until x=0 
EndProcedure 


a$="123456789stop123456789stoppurebasicstopisstopcool" 

;using STRINGFIELD NORMAL 
Debug StringField(a$,1,"stop") 
Debug StringField(a$,2,"stop") 
Debug StringField(a$,3,"stop") 
Debug StringField(a$,4,"stop") 
Debug StringField(a$,5,"stop") 
Debug StringField(a$,6,"stop") 
Debug StringField(a$,7,"stop") 
Debug StringField(a$,8,"stop") 
Debug StringField(a$,9,"stop") 


;using STRINGFIELD2 MODIFIED 
Debug StringField2(a$,1,"stop") 
Debug StringField2(a$,2,"stop") 
Debug StringField2(a$,3,"stop") 
Debug StringField2(a$,4,"stop") 
Debug StringField2(a$,5,"stop") 
Debug StringField2(a$,6,"stop") 
Debug StringField2(a$,7,"stop") 
Debug StringField2(a$,8,"stop") 
Debug StringField2(a$,9,"stop")
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -