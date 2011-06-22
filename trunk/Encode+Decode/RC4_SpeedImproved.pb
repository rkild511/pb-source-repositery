; German forum: http://robsite.de/php/pureboard/viewtopic.php?t=1708
; Author: Friedhelm
; Date: 25. July 2003
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


Procedure.l RC4Mem(Mem.l, memLen.l, key.s) 
  ;RC4Mem(*MemoryBuffer.l, MomeryLength.l, Key.s) 
  
  Dim S.l(255) 
  Dim K.l(255)  
  
  i.l=0: j.l=0: t.l=0: x.l=0 
  temp.l=0: y.l=0 
  
  j = 1 
  l.l          =Len(key) 
  *Sp.Long      = @S() 
  *keyP.Byte    = @key 
  For i = 0 To 255 
    *Sp\l = i          
    *Sp + 4          
    If *keyP\b = 0 
      *keyP = @key 
    EndIf 
    K(i) = *keyP\b 
    *keyP+1 
  Next i 
  
  j = 0 
  For i = 0 To 255 
    j = (j + S(i) + K(i)) & 255 
    temp = S(i) 
    S(i) = S(j) 
    S(j) = temp 
  Next i 
  
  i = 0 
  j = 0 
  *Memm.Byte = Mem 
  For x = 0 To memLen-1 
     i = (i+1) & 255 
    j = (j + S(i)) & 255 
    temp = S(i) 
    S(i) = S(j) 
    S(j) = temp 
    t = (S(i) + (S(j) & 255)) & 255 
    y = S(t) 
    *Memm\b ! y 
    *Memm + 1  
  Next 
  ProcedureReturn Mem 
EndProcedure 




;--------------------------------------------- 
; params 
; 


tTEST.s ="1234567890 Hallo       " 
MsgLen.l =  Len(tTEST) 
Mem = @tTEST 
; Key 
key.s = "abc abc 1234567890" 




;--------------------------------------------- 
; test 1 
; 
RC4Mem(Mem,MsgLen,key) 

MessageBox_(0, TEST,  "RC4" , 0) 

RC4Mem(Mem,MsgLen,key) 

MessageBox_(0, TEST,  "RC4" , 0) 

;--------------------------------------------- 
; test 2 
; 

RC4Mem(RC4Mem(Mem,MsgLen,key),MsgLen,key) 

MessageBox_(0, TEST,  "RC4" , 0) 

;--------------------------------------------- 

#WDH_MAX = 1024 
Mem=AllocateMemory(3,1024,0) 
*m.Byte = Mem 
RandomSeed(1024) 
For Z   = Mem To Mem +1024 
  *m\b = Random(255) 
  *m   +  1 
Next 

time.l = GetTickCount_() 
    For i = 0 To #WDH_MAX  
      RC4Mem (Mem,1024,"Test") 
    Next 
    Time1.l = GetTickCount_() - time 
    
    
    
;--------------------------------------------- 
    ; test 1 
      
    MessageBox_(0, StrF(1000/ Time1)+" MB/s", "RC4Mem", 0)  
    
;--------------------------------------------- 
    
; ExecutableFormat=
; FirstLine=1
; EOF