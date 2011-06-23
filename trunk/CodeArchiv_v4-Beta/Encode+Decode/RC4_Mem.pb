; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1708&highlight=
; Author: Pille (updated for PB3.92+ by Lars)
; Date: 15. July 2003
; OS: Windows
; Demo: Yes

; 
; RC4Mem for PB by Pille, 15.07.2003 
; Special Thanks to Rings 
; 

; 
; RC4 is a stream cipher designed by Rivest for RSA 
; Data Security (now RSA Security). It is a variable 
; key-size stream cipher with byte-oriented operations. 
; The algorithm is based on the use of a random 
; permutation. Analysis shows that the period of the 
; cipher is overwhelmingly likely to be greater than 
; 10^100. Eight to sixteen machine operations are required 
; per output byte, and the cipher can be expected to run 
; very quickly in software. Independent analysts have 
; scrutinized the algorithm and it is considered secure. 
; 

Procedure Mod(a,b) 
  ProcedureReturn a-(a/b)*b 
EndProcedure 

Procedure.l RC4Mem(Mem.l, memLen.l, key.s) 
  ;RC4Mem(*MemoryBuffer.l, MomeryLength.l, Key.s) 
  
  Dim S.w(255) 
  Dim K.w(255) 
  i.l=0: j.l=0: t.l=0: x.l=0 
  temp.w=0: y.w=0 
  Outp.s="" 
  
  For i = 0 To 255 
    S(i) = i 
  Next 
  
  j = 1 
  For i = 0 To 255 
    If j > Len(key) 
      j = 1 
    EndIf 
    K(i) = Asc(Mid(key, j, 1)) 
    j = j + 1 
  Next i 
  
  j = 0 
  For i = 0 To 255 
    j = Mod(j + S(i) + K(i), 256) 
    temp = S(i) 
    S(i) = S(j) 
    S(j) = temp 
  Next i 
  
  i = 0 
  j = 0 
  For x = 0 To memLen-1 
    i = Mod(i + 1, 256) 
    j = Mod(j + S(i),256) 
    temp = S(i) 
    S(i) = S(j) 
    S(j) = temp 
    t = Mod(S(i) + Mod(S(j), 256) , 256) 
    y = S(t) 
    PokeB(Mem+x, PeekB(Mem+x)!y) 
  Next 
  ProcedureReturn Mem 
EndProcedure 




;--------------------------------------------- 
; params 
; 

; Message length 
MsgLen.l=13 

; Message Bin 
Mem=AllocateMemory(MsgLen) 
PokeB(Mem,Asc("H")) 
PokeB(Mem+1,Asc("e")) 
PokeB(Mem+2,Asc("l")) 
PokeB(Mem+3,Asc("l")) 
PokeB(Mem+4,Asc("o")) 
PokeB(Mem+5,Asc(" ")) 
PokeB(Mem+6,0) 
PokeB(Mem+7,Asc("W")) 
PokeB(Mem+8,Asc("o")) 
PokeB(Mem+9,Asc("r")) 
PokeB(Mem+10,Asc("l")) 
PokeB(Mem+11,Asc("d")) 
PokeB(Mem+12,Asc("!")) 

; Key 
key.s = "abc" 




;--------------------------------------------- 
; test 1 
; 
Debug RC4Mem(Mem,MsgLen,key) 

For i.l=0 To MsgLen-1 
  Debug Chr(PeekB(Mem+i)) 
Next 

Debug RC4Mem(Mem,MsgLen,key) 

For i.l=0 To MsgLen-1 
  Debug Chr(PeekB(Mem+i)) 
Next 

;--------------------------------------------- 
; test 2 
; 

Debug RC4Mem(RC4Mem(Mem,MsgLen,key),MsgLen,key) 

For i.l=0 To MsgLen-1 
  Debug Chr(PeekB(Mem+i)) 
Next

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
