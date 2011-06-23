; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3712&highlight=
; Author: Dristar (corrected by ChaOsKid, updated for PB 4.00 by Andre)
; Date: 15. February 2004
; OS: Windows
; Demo: Yes

Procedure FileCompare(file1$,file2$)
  LOF1=FileSize(file1$): If LOF1<0: ProcedureReturn 1: EndIf
  LOF2=FileSize(file2$): If LOF2<0: ProcedureReturn 1: EndIf
  *ram0 = AllocateMemory(4096)
  *ram1 = AllocateMemory(4096)
  If LOF1 <> LOF2
    ProcedureReturn 2
  EndIf
  If file1$ = file2$
    ProcedureReturn 3
  EndIf
  If OpenFile(100,file1$)
    If OpenFile(101,file2$)
      Repeat
        If Lof(101) - Loc(101) > 4096
          MBytes = 4096
        Else
          MBytes = Lof(101) - Loc(101)
        EndIf
        Zeiger = Loc(101)
        ReadData(100, *ram0, MBytes)
        ReadData(101, *ram1, MBytes)
        If CompareMemory(*ram0, *ram1, MBytes) = 0
          For a=0 To MBytes - 1
            d=PeekB(*ram0+a)
            e=PeekB(*ram1+a)
            If d<>e
              Debug Right("0"+Hex(d&$FF), 2)+"="+Right("0"+Hex(e&$FF), 2)+" Position:"+Str(Zeiger+a)
            EndIf
          Next
        EndIf
      Until Eof(100) < 0
      CloseFile(101)
      FreeMemory(*ram1)
      CloseFile(100)
      FreeMemory(*ram0)
      ProcedureReturn 0
    EndIf
  EndIf
EndProcedure

Debug FileCompare("c:\test", "c:\test1")

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -