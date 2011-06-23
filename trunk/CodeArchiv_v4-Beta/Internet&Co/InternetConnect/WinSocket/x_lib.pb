Procedure x_032x_031003EJN()
  ;
  ; *** general procedures
  ;
  ; version history
  ; ---------------
  ;
  ; x031:
  ;
  ; - first version in purebasic
  ;
EndProcedure

Procedure x_init()
  ;
  ; *** initialize variables, constants and parameters
  ;
  #False = 0 
  #True = 1 
  ;
  Global xpbh.l , x_pbh_n.l
  x_pbh_n = 1000                           ; arbitrary value, first unique number given out 
  Global NewList x_pbh_list.l()                   ; see x_pbh() for more details
  ;
EndProcedure

Procedure x_end()
  ;
  ClearList(x_pbh_list())
EndProcedure

Procedure.l x_pbh()
  Global x_pbh.l, x_pbh_n.l
  ;
  ; *** generates a new unique number
  ;
  ; in:     none
  ; out:    unused unique number
  ;
  ; pure sometimes uses 'numbers' to identify elements instead of windows handles
  ; these numbers are arbitrary and fully defined by the user, this can cause trouble
  ; when using multiple libraries or code from different people as they might be reusing
  ; these unique numbers, for this purpose, i've added a x_pbh procedure that returns
  ; a new unique number on every call
  ;
  ; you decide yourself if you want to free them or not :-)
  ; i would suggest doing so if you don't 'recycle' them... 
  ;
  If CountList(x_pbh_list()) > 0         ; which means there's some stuff on the list
    x_pbh = x_pbh_list()                 ; then use that number
    DeleteElement(x_pbh_list())          ; and take if from the list
  Else
    x_pbh = x_pbh_n
    x_pbh_n = x_pbh_n+1
  EndIf
  ProcedureReturn x_pbh
EndProcedure

Procedure x_freepbh(n.l)
  ;
  ; put this number into the 'free numbers' list so it can be reused by x_pbh()
  ;
  AddElement(x_pbh_list())
  x_pbh_list()=n
  ;
EndProcedure

Procedure.l x_not(var) 
  ;
  ; not statement is missing in purebasic
  ; note: this does not work with strings or expressions!
  ;
  If var = false 
    ProcedureReturn true 
  Else 
    ProcedureReturn false 
  EndIf 
EndProcedure 

Procedure.s x_waitkey()
  Protected k.s
  ;
  ; wait for a key to be pressed, return key in uppercase 1 char string
  ;
  Repeat
    k = Left(UCase(Inkey()),1)
    If k = ""
      Delay(30)
    EndIf
  Until k>""
  ProcedureReturn k
EndProcedure

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --