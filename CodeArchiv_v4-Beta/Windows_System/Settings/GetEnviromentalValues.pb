; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7019&highlight=
; Author: oldefoxx
; Date: 28. July 2003
; OS: Windows
; Demo: No


;Get Environmental Variable Directly 
;-------------------------------------------------------------------------------- 
;  My first PureBASIC Program 
;  By Donald Darden 
;This program finds the starting address for Current 
;Environmental Space where the Environmental Variables 
;are stored.  Normally, in calling GetEnvVariable_(), you 
;must already know the specific variable name.  This 
;approach exposes each one already in the environmental 
;space, regardless of what it is called. 

;This is a program To demonstrate how you can see all the 
;current environmental variables (count.l=0) or just the 
;one corresponding to the count.l downdown 

;Declare Procedure.s GetEnvVarByNum(count.l) 

Procedure.s GetEnvVarByNum(count.l) 
  counter.l=count.l 
  *envptr=GetEnvironmentStrings_() 
  envstr$="" 
  MessageRequester("Pointer to Variable #"+Str(count.l),"Pointer = "+Str(*envptr),0) 
  ;counter.l=0                  ;dummy assignment 
  aptr=*envptr 
  Repeat 
    envs$="" 
    If PeekS(aptr,1)=Null$    ;Environmental Variables end with 
      Goto alldone            ;two consecutive zero bytes 
    EndIf 
    bptr=aptr 
    Repeat 
      envs$=PeekS(bptr,1) 
      bptr=bptr+1 
      If envs$=Null$             ;each environmental variable is            
       Goto gotcha            ;Null character terminatged    
      EndIf 
    ForEver 
  gotcha: 
    If counter.l<2 
      envs$=PeekS(aptr,bptr-aptr)   ;collect the environmental variable 
  ;   PrintN(envs$)                  ;print it to the console window 
      envstr$=envstr$+envs$+crlf$    
    EndIf 
    If counter.l>0                     ;do a variable @ countdown 
      counter.l=counter.l-1 
      If counter.l=0                   ;exit when we get to zero  
        Goto alldone 
      EndIf    
    EndIf 
    aptr=bptr                           ;continue if no one variable sought 
  ForEver                               ;(counter=0) or not yet to variable 
  alldone: 
  ;MessageRequester("Returned Environmental",envstr$,0) 
  ProcedureReturn envstr$    
EndProcedure 



OpenConsole() 
Global Null,s,crlf.s 
Null$=Chr(0) 
crlf$=Chr(13)+Chr(10) 
For n.l=0 To 1000 
  environ$=GetEnvVarByNum(n.l) 
  If environ$="" 
    Goto pau 
  EndIf 
  b.l=0 
  While b.l<Len(environ$) 
    c.l=FindString(environ$,crlf$,b.l+1) 
    If c.l=0 
      c.l=Len(environ$)+1 
    EndIf 
    nstr$=Mid(environ$,b.l+1,c.l-b.l) 
    PrintN(nstr$) 
    b.l=c.l+1 
  Wend  
  MessageRequester("Environmental Variable #"+Str(n.l),environ$,0) 
Next 
pau: 
result$=Space(512) 
variable$="USERPROFILE" 
res=GetEnvironmentVariable_(variable$,@result$,512) 
If res 
  MessageRequester(variable$+" Result",result$,0) 
Else 
  MessageRequester(variable$+" Error","Variable Not Found",0) 
EndIf 
CloseConsole() 
End  

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
