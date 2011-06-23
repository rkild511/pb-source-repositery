; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2652
; Author: Deeem2031
; Date: 27. March 2005
; OS: Windows
; Demo: Yes


; Schnelle Suchroutine, Speicherbereiche nach bestimmten Bytefolgen durchsucht. 

; Für Strings gibt es da z.b. CountString(), erfolgt jedoch ein direktes 
; Durchsuchen des Speichers. 


Procedure HuntMemory(Mem,len,s) 
  ; mem = Startaddress of memory block
  ; len = Length of memory block
  ; s = search for...
  Protected SMem,*SMemPos.LONG,*p,*SMemTmp.LONG,f 
  SMem = AllocateMemory(8+s) 
  For *p = Mem To Mem+len-s 
    *SMemPos = @SMem 
    f = 0 
    Repeat 
      *SMemPos = *SMemPos\l 
      If CompareMemory(*p,*SMemPos+8,s) 
        *SMemTmp = *SMemPos+4 
        *SMemTmp\l+1 
        f = 1 
      EndIf 
    Until *SMemPos\l = 0 
    If f = 0 
      *SMemPos\l = AllocateMemory(8+s) 
      *SMemPos = *SMemPos\l 
      PokeL(*SMemPos+4,1) 
      CopyMemory(*p,*SMemPos+8,s) 
    EndIf 
  Next 
  
  *SMemPos = SMem 
  Repeat 
    Debug Right("0000"+Hex(PeekW(*SMemPos+8)),4)+" "+Str(PeekL(*SMemPos+4)) 
    SMem = *SMemPos 
    *SMemPos = *SMemPos\l 
    FreeMemory(SMem) 
  Until *SMemPos = 0 
EndProcedure 

memsize=1048;576 ; 1 MB Ram durchsuchen! 
summe=0 
Dim founds(65535) 
bnk=AllocateMemory(memsize) 

For z=0 To memsize-1 Step 2:PokeW(bnk+z,Random(200)):Next 

HuntMemory(bnk,memsize,2) 

For z=0 To memsize-1 
  bits=PeekW(bnk+z) & $FFFF 
  founds(bits)+1 
  ;If PeekW(bnk+z+1) & $FFFF=bits:z+1:EndIf 
  If founds(bits)>summe:summe=founds(bits):word=bits:EndIf 
Next 

a$=Right("0000"+Hex(word),4) 

MessageRequester("Info", "Funde = "+Str(summe)+Chr(10)+"Wert.W = $"+a$+Chr(10)+"",#MB_OK|#MB_ICONINFORMATION)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -