; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2342&highlight=
; Author: GPI
; Date: 20. September 2003
; OS: Windows
; Demo: No


; Some functions for using 64 bit Longs with PureBasic, e.g. for handling the
; results of some WinAPI functions (example: free disk space)
; Values from 0 - 18,446,744,073,709,551,615  are possible

; Einige WinAPI-Funktionen liefern ja 64-Bit-Zahlen zurück (bsw.: Freier Festplattenplatz,
; auch die Dateigröße bei NTSC-System kann so groß werden!), so daß ich hier ein paar
; Funktionen geschrieben hab, die mit Longs umgehen können. 
; Damit sind Zahlen von  0 - 18.446.744.073.709.551.615  möglich.

Structure LongLongs 
  lowlow.w 
  lowhi.w 
  LongLongs.w 
  hihi.w 
EndStructure 

Structure LongLongs2 
  low.l 
  hi.l 
EndStructure 

Procedure.s LL_Hex(*Value1.LongLongs); hex(value1) 
  a$=RSet(Hex(*Value1\hihi&$ffff),4,"0")+RSet(Hex(*Value1\LongLongs&$ffff),4,"0")+RSet(Hex(*Value1\lowhi&$ffff),4,"0")+RSet(Hex(*Value1\lowlow&$ffff),4,"0") 
  While Left(a$,1)="0" 
    a$=Mid(a$,2,Len(a$)-1) 
  Wend 
  If a$ 
    ProcedureReturn a$ 
  Else 
    ProcedureReturn "0" 
  EndIf 
EndProcedure 


Procedure.s LL_Bin(*Value1.LongLongs); bin(value1) 
  a$=RSet(Bin(*Value1\hihi&$ffff),16,"0")+RSet(Bin(*Value1\LongLongs&$ffff),16,"0")+RSet(Bin(*Value1\lowhi&$ffff),16,"0")+RSet(Bin(*Value1\lowlow&$ffff),16,"0") 
  While Left(a$,1)="0" 
    a$=Mid(a$,2,Len(a$)-1) 
  Wend 
  If a$ 
    ProcedureReturn a$ 
  Else 
    ProcedureReturn "0" 
  EndIf 
EndProcedure 


Procedure LL_ShiftRight(*Value1.LongLongs,divx) ; Value1=Value1>>divx 
  LongLongs=*Value1\LongLongs&$ffff 
  hihi=*Value1\hihi&$ffff 
  lowlow=*Value1\lowlow&$ffff 
  lowhi=*Value1\lowhi&$ffff 
  While divx>0 
    If divx>16: divx-16:div=16 : Else : div=divx:divx=0 : EndIf 
    mask=(1<<div)-1: mul=16-div 
    lowlow=(lowlow>>div)+((lowhi&mask)<<mul) 
    lowhi =(lowhi >>div)+((LongLongs&mask)<<mul) 
    LongLongs =(LongLongs >>div)+((hihi&mask)<<mul) 
    hihi  =(hihi>>div) 
  Wend 
  *Value1\LongLongs=LongLongs 
  *Value1\lowlow=lowlow 
  *Value1\hihi=hihi 
  *Value1\lowhi=lowhi 
  ProcedureReturn *Value1 
EndProcedure 


Procedure LL_ShiftLeft(*Value1.LongLongs,mulx) ; Value1=Value1<<mulx 
  LongLongs=*Value1\LongLongs&$ffff 
  hihi=*Value1\hihi&$ffff 
  lowlow=*Value1\lowlow&$ffff 
  lowhi=*Value1\lowhi&$ffff 
  While mulx>0 
    If mul>16: mulx-16:mul=16 : Else : mul=mulx:mulx=0 : EndIf 
    lowlow=(lowlow<<mul) 
    lowhi =(lowhi <<mul)+(lowlow>>16&$ffff)        :lowlow&$ffff 
    LongLongs =(LongLongs <<mul)+(lowhi>>16&$ffff)         :lowhi&$ffff 
    hihi  =((hihi <<mul)+(LongLongs>>16&$ffff))&$ffff  :LongLongs&$ffff 
  Wend 
  *Value1\LongLongs=LongLongs 
  *Value1\lowlow=lowlow 
  *Value1\hihi=hihi 
  *Value1\lowhi=lowhi 
  ProcedureReturn *Value1 
EndProcedure 


Procedure LL_Add(*Value1.LongLongs,*Value2.LongLongs) ; Value1+Value2 
  LongLongs1=*Value1\LongLongs&$ffff 
  hihi1=*Value1\hihi&$ffff 
  lowlow1=*Value1\lowlow&$ffff 
  lowhi1=*Value1\lowhi&$ffff 
  
  LongLongs2=*Value2\LongLongs&$ffff 
  hihi2=*Value2\hihi&$ffff 
  lowlow2=*Value2\lowlow&$ffff 
  lowhi2=*Value2\lowhi&$ffff 
  
  lowlow=lowlow1+lowlow2 
  lowhi=(lowhi1+lowhi2)+((lowlow>>16)&$ffff):lowlow&$FFFF 
  LongLongs=(LongLongs1+LongLongs2)+((lowhi>>16)&$FFFF):lowhi&$ffff 
  hihi=((hihi1+hihi2)+((LongLongs>>16)&$FFFF))&$FFFF:LongLongs&$FFFF 
  
  
  *Value1\LongLongs=LongLongs 
  *Value1\lowlow=lowlow 
  *Value1\hihi=hihi 
  *Value1\lowhi=lowhi 
  ProcedureReturn *Value1 
EndProcedure 


Procedure LL_Sub(*Value1.LongLongs,*Value2.LongLongs) ; Value1-Value2 
  LongLongs1=*Value1\LongLongs&$ffff 
  hihi1=*Value1\hihi&$ffff 
  lowlow1=*Value1\lowlow&$ffff 
  lowhi1=*Value1\lowhi&$ffff 
  LongLongs2=(~*Value2\LongLongs)&$ffff 
  hihi2=(~*Value2\hihi)&$ffff 
  lowlow2=(~*Value2\lowlow)&$ffff 
  lowhi2=(~*Value2\lowhi)&$ffff 
  
  lowlow=lowlow1+lowlow2+1 
  lowhi=(lowhi1+lowhi2)+((lowlow>>16)&$ffff):lowlow&$FFFF 
  LongLongs=(LongLongs1+LongLongs2)+((lowhi>>16)&$FFFF):lowhi&$ffff 
  hihi=((hihi1+hihi2)+((LongLongs>>16)&$FFFF))&$FFFF:LongLongs&$FFFF 
  
  *Value1\LongLongs=LongLongs 
  *Value1\lowlow=lowlow 
  *Value1\hihi=hihi 
  *Value1\lowhi=lowhi 
  ProcedureReturn *Value1 
EndProcedure 


Procedure LL_Bit(*Value1.LongLongs2,bit) ; Test if bit set 
  If bit>=32 
    x=1<<(bit-32) 
    ProcedureReturn (*Value1\hi&x) 
  Else 
    x=1<<bit 
    ProcedureReturn ((*Value1\low)&$FFFF&x) 
  EndIf 
EndProcedure 


Procedure LL_Set(*Value1.LongLongs2,*Value2.LongLongs2) ; Value1=Value2 
  *Value1\hi=*Value2\hi 
  *Value1\low=*Value2\low 
EndProcedure 
Procedure LL_SetLL(*Value1.LongLongs2,hi,low) ; Value1=hi<<32+low 
  *Value1\hi=hi 
  *Value1\low=low 
EndProcedure  


Procedure LL_Comp(*Value1.LongLongs,*Value2.LongLongs) ; -1=Value1 is bigger, 0=same, 1 Value1 is bigger 
  LongLongs1=*Value1\LongLongs&$ffff 
  hihi1=*Value1\hihi&$ffff 
  lowlow1=*Value1\lowlow&$ffff 
  lowhi1=*Value1\lowhi&$ffff 
  
  LongLongs2=*Value2\LongLongs&$ffff 
  hihi2=*Value2\hihi&$ffff 
  lowlow2=*Value2\lowlow&$ffff 
  lowhi2=*Value2\lowhi&$ffff 
  
  If hihi1>hihi2 
    Result=-1 
  ElseIf hihi1<hihi2 
    Result=1 
  ElseIf LongLongs1>LongLongs2 
    Result=-1 
  ElseIf LongLongs1<LongLongs2 
    Result=1 
  ElseIf lowhi1>lowhi2 
    Result=-1 
  ElseIf lowhi1<lowhi2 
    Result=1 
  ElseIf lowlow1>lowlow2 
    Result=-1 
  ElseIf lowlow1<lowlow2 
    Result=1 
  Else 
    Result=0 
  EndIf 
  ProcedureReturn Result 
EndProcedure 


Procedure LL_Mul(*Value1.LongLongs,*Value2.LongLongs) ; Value1*Value2 
  value.LongLongs 
  For i=0 To 63 
    If LL_Bit(*Value2,i) 
      LL_Add(value,*Value1) 
    EndIf 
    LL_ShiftLeft(*Value1,1) 
  Next 
  LL_Set(*Value1,value) 
  ProcedureReturn *Value1 
EndProcedure 


Procedure LL_Div(*Value1.LongLongs,*Value2.LongLongs,*mod.LongLongs) ; Mod=value1-(value1/value2)*value2:value1/value2 
  LL_Set(div.LongLongs,*Value2) 
  value.LongLongs 
  kk=0 
  While LL_Bit(div,63)=0 
    LL_ShiftLeft(div,1):kk+1 
  Wend 
  
  For i=0 To kk 
    LL_ShiftLeft(value,1) 
    If LL_Comp(*Value1,div)<=0 
      LL_Sub(*Value1,div) 
      value\lowlow+1 
    EndIf 
    
    LL_ShiftRight(div,1) 
  Next 
  If *mod 
    LL_Set(*mod,*Value1) 
  EndIf 
  LL_Set(*Value1,value) 
  ProcedureReturn *Value1 
EndProcedure 


Procedure.s LL_Str(*Value1.LongLongs) ; Str(value1) 
  LL_Set(value.LongLongs,*Value1) 
  LL_SetLL(div.LongLongs,$8ac72304,$89e80000); Höchste Ziffer 
  LL_SetLL(min.LongLongs,0,0);niedrigeste Ziffer 
  LL_SetLL(ten.LongLongs,0,10);10 
  Repeat 
    LL_Div(value,div,mod.LongLongs) 
    a=value\lowlow 
    If a Or a$ 
      a$+Chr(48+a) 
    EndIf 
    LL_Set(value,mod) 
    LL_Div(div,ten,0) 
  Until LL_Comp(div,min)=0 
  ProcedureReturn a$ 
EndProcedure 


Procedure LL_Val(*Value1,string$) ; value1=val(string$) 
  LL_SetLL(ten.LongLongs,0,10) 
  LL_SetLL(z1.LongLongs,0,1) 
  LL_SetLL(z2.LongLongs,0,2) 
  LL_SetLL(z3.LongLongs,0,3) 
  LL_SetLL(z4.LongLongs,0,4) 
  LL_SetLL(z5.LongLongs,0,5) 
  LL_SetLL(z6.LongLongs,0,6) 
  LL_SetLL(z7.LongLongs,0,7) 
  LL_SetLL(z8.LongLongs,0,8) 
  LL_SetLL(z9.LongLongs,0,9) 
  LL_SetLL(*Value1,0,0) 
  string$=Trim(string$) 
  *buf.Byte=@string$ 
  ok=#True 
  While *buf\b And ok 
    LL_Mul(*Value1,ten) 
    Select *buf\b 
      Case '0' 
      Case '1': LL_Add(*Value1,z1) 
      Case '2': LL_Add(*Value1,z2) 
      Case '3': LL_Add(*Value1,z3) 
      Case '4': LL_Add(*Value1,z4) 
      Case '5': LL_Add(*Value1,z5) 
      Case '6': LL_Add(*Value1,z6) 
      Case '7': LL_Add(*Value1,z7) 
      Case '8': LL_Add(*Value1,z8) 
      Case '9': LL_Add(*Value1,z9) 
      Default : ok=#False 
    EndSelect 
    *buf+1 
  Wend 
  ProcedureReturn *Value1 
EndProcedure 


Procedure LL_BinVal(*Value1,string$) ; value1=BinVal(string$) 
  LL_SetLL(ten.LongLongs,0,10) 
  LL_SetLL(z1.LongLongs,0,1) 
  string$=Trim(string$) 
  *buf.Byte=@string$ 
  ok=#True 
  While *buf\b And ok 
    LL_ShiftLeft(*Value1,1) 
    Select *buf\b 
      Case '%' 
      Case '0' 
      Case '1': LL_Add(*Value1,z1) 
      Default : ok=#False 
    EndSelect 
    *buf+1 
  Wend 
  ProcedureReturn *Value1 
EndProcedure 


Procedure LL_HexVal(*Value1,string$) ; value1=BinVal(string$) 
  LL_SetLL(ten.LongLongs,0,10) 
  LL_SetLL(z1.LongLongs,0,1) 
  LL_SetLL(z2.LongLongs,0,2) 
  LL_SetLL(z3.LongLongs,0,3) 
  LL_SetLL(z4.LongLongs,0,4) 
  LL_SetLL(z5.LongLongs,0,5) 
  LL_SetLL(z6.LongLongs,0,6) 
  LL_SetLL(z7.LongLongs,0,7) 
  LL_SetLL(z8.LongLongs,0,8) 
  LL_SetLL(z9.LongLongs,0,9) 
  LL_SetLL(za.LongLongs,0,10) 
  LL_SetLL(zb.LongLongs,0,11) 
  LL_SetLL(zc.LongLongs,0,12) 
  LL_SetLL(zd.LongLongs,0,13) 
  LL_SetLL(ze.LongLongs,0,14) 
  LL_SetLL(zf.LongLongs,0,15) 
  LL_SetLL(*Value1,0,0) 
  string$=Trim(UCase(string$)) 
  *buf.Byte=@string$ 
  ok=#True 
  While *buf\b And ok 
    LL_ShiftLeft(*Value1,4) 
    Select *buf\b 
      Case '$' 
      Case '0' 
      Case '1': LL_Add(*Value1,z1) 
      Case '2': LL_Add(*Value1,z2) 
      Case '3': LL_Add(*Value1,z3) 
      Case '4': LL_Add(*Value1,z4) 
      Case '5': LL_Add(*Value1,z5) 
      Case '6': LL_Add(*Value1,z6) 
      Case '7': LL_Add(*Value1,z7) 
      Case '8': LL_Add(*Value1,z8) 
      Case '9': LL_Add(*Value1,z9) 
      Case 'A': LL_Add(*Value1,za) 
      Case 'B': LL_Add(*Value1,zb) 
      Case 'C': LL_Add(*Value1,zc) 
      Case 'D': LL_Add(*Value1,zd) 
      Case 'E': LL_Add(*Value1,ze) 
      Case 'F': LL_Add(*Value1,zf) 
      Default : ok=#False 
    EndSelect 
    *buf+1 
  Wend 
  ProcedureReturn *Value1 
EndProcedure 


Procedure Mirror(*string) 
  *start.Byte=*string 
  *Ende.Byte=*string+MemoryStringLength(*string)-1 
  While *start<*Ende 
    a=*start\b:*start\b=*Ende\b 
    *Ende\b=a 
    *start+1:*Ende-1 
  Wend 
EndProcedure 


Procedure.s Using(format$,Digits$,Fill) 
  Mirror(@format$):Mirror(@Digits$) 
  *format.Byte=@format$ 
  *digits.Byte=@Digits$ 
  While *format\b 
    Select *format\b 
      Case '#' 
        If *digits\b 
          *format\b=*digits\b 
          *digits+1 
          If *digits\b='.' : *digits+1 : EndIf 
        Else 
          *format\b=Fill 
        EndIf 
      Default 
        If *digits\b=0 
          *format\b=Fill 
        EndIf 
    EndSelect 
    *format+1 
  Wend 
  Mirror(@format$) 
  ProcedureReturn format$ 
EndProcedure 

GetDiskFreeSpaceEx_(@"c:\",free.LongLongs,Total.LongLongs,TotalFree.LongLongs) 
Debug "free bytes for user:"+Using("##,###,###,###,###,###,###",LL_Str(free),0)+" Bytes" 
Debug "bytes on the disk:"+Using("##,###,###,###,###,###,###",LL_Str(Total),0)+" Bytes" 
Debug "free bytes on the disk:"+Using("##,###,###,###,###,###,###",LL_Str(TotalFree),0)+" Bytes" 

Debug "btw:"+Using("###,###.##",StrF(1223.1243,2),0) 

a$="18446744073709551615" 
LL_Val(value.longlongs,a$) 
Debug a$ 
Debug LL_Str(value)
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ----
