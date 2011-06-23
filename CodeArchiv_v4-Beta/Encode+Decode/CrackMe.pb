; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13511&start=30
; Author: thefool
; Date: 01. January 2004
; OS: Windows
; Demo: Yes


; Hiding/encrypting serial numbers

; ...another nice trick: 
; Jump from RET's.. 
; If you push an address of a label to a stack, and execute the 
; RET command, it will jump to the address. This is actually harder 
; to see in a disassembler, and will often confuse it. 
; 
; For demonstrating i programmed a nice little crackme...
; If you want to try it, compile it without looking. btw: its NOT 
; using any debugger protections, so dont use one... 
; 
; Not much of commentaries, but ask if you have a question.. 
; 
; Protections: Encrypted text [with own lame encryption scheme], 
; Code executed in unusual order, junk code. 
; 

;********************************************************************** 
;*Crackme number 2                                                    * 
;*It uses some rets and pushes to make it execute in a non-normal way.* 
;*Also uses some junk code, and encrypted text ;)                     * 
;*Coded by Daniel Middelhede [thefool]                                * 
;********************************************************************** 

Goto afterproc 
TheEnd: 
End 

Procedure.s dEnc(string.s,pass.s) 
  If string.s="" 
    ProcedureReturn "" 
  Else 
    For a=1 To Len(pass.s) 
      charval=Asc(Mid(pass.s,i,1)) 
      myarr=myarr+charval 
    Next a 
    For i=1 To Len(string.s) 
      myenc=Asc(Mid(string.s,i,1)) ! myarr 
      mystr.s=mystr.s+Chr(myenc) 
    Next i 
    ProcedureReturn mystr 
  EndIf 
EndProcedure 

afterproc: 
ad=?getpw ;Push the adress of the GetPW thingy 
PUSH ad 
serial.s=dEnc("B^SPYYZDYU]E","6") 
RET 

;JunkCodeSection.  will also disturb older disassemblers 
If password.s="quatrofobic" 
  MessageRequester("","Correct!") 
Else 
  MessageRequester("","Nope, im sorry :(") 
EndIf 
;EndofJunk! 

  wrong: 
  MessageRequester("",dEnc("E@]\UBSAAE]@V","2")) 
  Goto TheEnd 
  right: 
  MessageRequester("",dEnc("r^_VCPED]PEX^_BcXVYEAPBBF^CU","1")) 
  Goto TheEnd 

testing: 

If userinput.s=serial.s 
  ad=?right 
Else 
  ad=?wrong 
EndIf 
PUSH ad 
RET 

getpw: 
userinput.s=InputRequester("",dEnc("2 [     W[","crackme 2"),"") 

PUSH l_testing 
RET 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableAsm
; EnableXP