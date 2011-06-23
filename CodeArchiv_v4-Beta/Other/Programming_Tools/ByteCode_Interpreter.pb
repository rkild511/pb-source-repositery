; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3676&start=20
; Author: Danilo
; Date: 14. February 2004
; OS: Windows
; Demo: Yes

Procedure Interpreter(*IP.BYTE) 
  Repeat 
    Opcode = *IP\b & $FF : *IP + 1 
    Select Opcode 
      Case 1 
        OpenConsole() 
      Case 2 
        A$ = PeekS(*IP) 
        *IP + Len(A$)+1 
        ConsoleTitle(A$) 
      Case 3 
        A$ = PeekS(*IP) 
        *IP + Len(A$)+1 
        PrintN(A$) 
      Case 4 
        Input() 
      Case 5 
        CloseConsole() 
      Case 255 
        MessageRequester("Interpreter Info","Program end reached.") 
        End 
    EndSelect 
  ForEver 
EndProcedure 

Interpreter(?ByteCode) 

DataSection 
  ByteCode: 
  Data.b $01,$02,$74,$65,$73,$74,$00,$03,$48,$65,$6C,$6C 
  Data.b $6F,$21,$00,$03,$54,$68,$69,$73,$20,$69,$73,$20 
  Data.b $61,$20,$73,$6D,$61,$6C,$6C,$20,$63,$6F,$6E,$73 
  Data.b $6F,$6C,$65,$20,$74,$65,$73,$74,$2E,$00,$03,$00 
  Data.b $03,$70,$72,$65,$73,$73,$20,$3C,$52,$45,$54,$55 
  Data.b $52,$4E,$3E,$20,$74,$6F,$20,$63,$6F,$6E,$74,$69 
  Data.b $6E,$75,$65,$2E,$2E,$2E,$00,$04,$05,$FF 
EndDataSection
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger