; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8531&highlight=
; Author: Num3
; Date: 27. November 2003
; OS: Windows
; Demo: Yes


; Just a procedure i made to check out dates... 
Procedure.s _fdate(date.s) 

  ; date: (day-month-year) 
  
  For a = 1 To Len(date) 
    If Mid(date,a,1)="/" 
     _date.s + "-" 
    ElseIf Mid(date,a,1)="\" 
    _date.s + "-" 
    ElseIf Mid(date,a,1)="-" 
    _date.s + "-" 
    ElseIf Mid(date,a,1)="." 
      _date.s + "-" 
    ElseIf Mid(date,a,1)=>"0" And Mid(date,a,1)<="9" 
      _date.s + Mid(date,a,1) 
    EndIf  
  Next 
    
    xa=FindString(_date,"-",1) 
    day.s + Mid(_date,1,xa-1) 

    day.s=Str(Val(day)) 
    
    If Val(day.s)>31 
      ProcedureReturn "ED" 
    EndIf 
    
    xb=FindString(_date,"-",xa+1) 
    
    month.s + Mid(_date,xa+1,xb-xa-1)    

    month.s=Str(Val(month)) 
    
    If Val(month.s)>12 
      ProcedureReturn "EM" 
    EndIf 

    year.s + Mid(_date,xb+1,Len(_date)) 
    
    If Val(year.s) <60 
      year.s =Str(Val(year)+2000) 
    ElseIf Val(year.s) >59 And Val(year.s)<100 
      year.s =Str(Val(year)+1900) 
    EndIf 
    
    If Val(year.s)<1960 Or Val(year.s)>2060 
      ProcedureReturn "EY" 
    EndIf    
  
    If Len(day.s) = 1 : day.s = "0"+day.s:EndIf 
    If Len(month.s) = 1 : month.s = "0"+month.s:EndIf 

    If ParseDate("%dd-%mm-%yyyy", date) 
      ProcedureReturn day + "-" + month + "-" + year    
    Else 
     ProcedureReturn "ID" 
    EndIf 

EndProcedure 

date.s= _fdate("1-12-2033") 


If date="ED" 
  MessageRequester( "Error", "The day of the date is incorrect") 
  ;Repeat date 
ElseIf date="EM" 
  MessageRequester( "Error", "The month of the date is incorrect") 
  ;Repeat date 
ElseIf date="EY" 
  MessageRequester( "Error", "The year of the date is not between 1960 and 2060 !") 
  ;Repeat date 
EndIf 


Debug date

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
