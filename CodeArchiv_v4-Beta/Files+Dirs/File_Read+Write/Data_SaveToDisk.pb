; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13460&start=15
; Author: GedB (updated for PB 4.00 by Andre)
; Date: 31. December 2004
; OS: Windows
; Demo: Yes


; Output and save a data block to disk
; Data-Block ausgeben und auf Disk speichern

Procedure DebugBuffer(*MemoryBuffer, LengthToWrite)
  For i = 0 To LengthToWrite -1 Step 4 ;(Remember that longs are 4 bytes long)
    Debug PeekL(*MemoryBuffer + i)
  Next i
EndProcedure

*DataBuffer = ?StartOfData
LengthOfData = ?EndOfData - ?StartOfData

DebugBuffer(*DataBuffer, LengthOfData)

If OpenFile(0, "Data.tbl")
  WriteData(0, *DataBuffer, LengthOfData)
  CloseFile(0)
EndIf

*ReadBuffer = AllocateMemory(LengthOfData)
If ReadFile(0, "Data.tbl")
  ReadData(0, *ReadBuffer, LengthOfData)
  CloseFile(0)
EndIf

DebugBuffer(*ReadBuffer, LengthOfData)

DataSection
  StartOfData:
  Data.l 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  EndOfData:
EndDataSection

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -