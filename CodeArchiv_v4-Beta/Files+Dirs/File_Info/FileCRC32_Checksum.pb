; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2921&highlight=
; Author: ChaOsKid (updated for PB3.92+ by Lars, updated for PB4.00 by blbltheworm)
; Date: 24. November 2003
; OS: Windows
; Demo: Yes

Procedure.s FileCRC32(Filename$) 
  l = FileSize(Filename$) 
  Buffer = AllocateMemory(l) 
  If Buffer 
    If OpenFile(0,Filename$) 
      ReadData(0,Buffer, l) 
      String$ = RSet(Hex(CRC32Fingerprint(Buffer, l)), 8, "0") 
      CloseFile(0) 
    EndIf 
    FreeMemory(Buffer) 
  EndIf 
ProcedureReturn String$ 
EndProcedure 

Debug FileCRC32("FileCRC32_Checksum.pb")

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
