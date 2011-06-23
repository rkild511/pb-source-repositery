; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2293&highlight=
; Author: GPI
; Date: 14. September 2003
; OS: Windows
; Demo: No

Structure HiLow 
  lowlow.w 
  lowhi.w 
  hilow.w 
  hihi.w 
EndStructure 
Procedure.s GetFreeSpace(p$) 
  #div=10 
  #mask=(1<<#div)-1 
  #mul=16-#div 
  If Left(p$,2)="\\" 
    a=FindString(p$,"\",3) 
  Else 
    a=FindString(p$,"\",1) 
  EndIf 
  If a=0 : a=Len(p$) : EndIf 
  p$=Left(p$,a) 
  If GetDiskFreeSpaceEx_(@p$,@free.HiLow,@Total.HiLow,@TotalFree.HiLow) 
    hilow=free\hilow&$ffff 
    hihi=free\hihi&$ffff 
    lowlow=free\lowlow&$ffff 
    lowhi=free\lowhi&$ffff 
    
    p=1 
    While hihi>0 Or hilow>0 Or lowhi>0 
      ;Debug RSet(Bin(hihi),16,"o")+RSet(Bin(hilow),16,"o")+RSet(Bin(lowhi),16,"o")+RSet(Bin(lowlow),16,"o") 
      
      lowlow=(lowlow>>#div)+((lowhi & #mask)<<#mul) 
      lowhi =(lowhi >>#div)+((hilow & #mask)<<#mul) 
      hilow =(hilow >>#div)+((hihi & #mask)<<#mul) 
      hihi  =(hihi>>#div) 
      
      p+1 
    Wend 
    ;Debug RSet(Bin(hihi),16,"o")+RSet(Bin(hilow),16,"o")+RSet(Bin(lowhi),16,"o")+RSet(Bin(lowlow),16,"o") 
    If lowlow>1024 
      a$= StrF(lowlow/1024,2)+" "+StringField("Byte,KB,MB,GB,TB",p+1,",") 
    Else 
      a$= StrF(lowlow,2)+" "+StringField("Byte,KB,MB,GB,TB",p,",") 
    EndIf 
  Else 
    a$="---" 
  EndIf 
  ProcedureReturn a$ 
EndProcedure 

Debug GetFreeSpace("c:\") 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
