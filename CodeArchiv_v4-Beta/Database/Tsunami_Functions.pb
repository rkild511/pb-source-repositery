; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8223&highlight=
; Author: the.weavster
; Date: 26. January 2004
; OS: Windows
; Demo: Yes

;Contributed by the.weavster
;I hope they work ok...

; I created these procedures to simplify using the Tsunami dll.
; They seem to work though, just Xinclude this file with your program.
; I haven't done all the commands yet, just the ones I needed to get going.

; Declare your table as a TsunamiTable
; e.g.
; Global tblCustomer.TsunamiTable
;
; Set the filename, keypath and record length
; tblCustomer\FileName = "c:\Data\Customer.dat"
; tblCustomer\KeyNo = 1
; tblCustomer\RecLength = 500
;
; get the File handle
; tblCustomer\FileHandle = w_Open(tblCustomer)
;
; And you're away
; now you can just pass the table Structure and parameters (string Or long) to your
; procedures And not worry about pointers etc..


;-Define Structures
Structure TFS
  op.l           ; Tsunami operation number
  file.l          ; File handle
  dataptr.l   ; Data buffer address
  datalen.l   ; Data buffer length
  keyptr.l    ; Key buffer address
  keylen.l    ; Key buffer length
  keyno.l     ; Key number
EndStructure

Structure TsunamiTable
  FileName.s    ;The name (including full path) of the Tsunami *.DAT file
  FileHandle.l   ;Returned by w_open
  KeyNo.l        ;The index or 'Key Path'
  FileMode.l     ;0=Single User 1=Multi User R/W 2=Multi User RO
  RecLength.l   ;Number of characters making up one record
EndStructure

;-Declare global variable
Global Tsu.TFS

;- Internal Procedures
;You will never have to call these from your program code
Procedure ResetTsu()
  Tsu\op = 0
  Tsu\file = 0
  Tsu\dataptr = 0
  Tsu\datalen = 0
  Tsu\keyptr = 0
  Tsu\keylen = 0
  Tsu\keyno = 0
EndProcedure

Procedure ExplainError(ErrCode.l)
  Text$ = "Unknown Error"
  Select ErrCode
    Case 1
      Text$ = "Not A Tsunami File"
    Case 2
      Text$ = "I/O Error"
    Case 3
      Text$ = "File Not Open"
    Case 4
      Text$ = "Key Not Found"
    Case 5
      Text$ = "Duplicate Key"
    Case 6
      Text$ = "Invalid Key Number"
    Case 7
      Text$ = "File Corrupt"
    Case 8
      Text$ = "No Current Position"
    Case 9
      Text$ = "End Of File"
    Case 10
      Text$ = "Invalid Page Size"
    Case 11
      Text$ = "Invalid Number Of Key Segments"
    Case 12
      Text$ = "Invalid File Definition String"
    Case 13
      Text$ = "Invalid Key Segment Postion"
    Case 14
      Text$ = "Invalid Key Segment Length"
    Case 15
      Text$ = "Inconsistent Key Segment Definitions"
    Case 20
      Text$ = "Invalid Record Length"
    Case 21
      Text$ = "Invalid Record Pointer"
    Case 22
      Text$ = "Lost Record Position"
    Case 30
      Text$ = "Access Denied"
    Case 31
      Text$ = "File Already Exists"
    Case 32
      Text$ = "No More File Handles"
    Case 33
      Text$ = "Max Files Open"
    Case 40
      Text$ = "Accelerated Access Denied"
    Case 41
      Text$ = "Acceleration Cache Error"
    Case 46
      Text$ = "Access To File Denied"
    Case 50
      Text$ = "Data Buffer Too Small"
    Case 99
      Text$ = "Time Out"
  EndSelect
  MessageRequester("Error",Text$,#PB_MessageRequester_Ok)
EndProcedure
;End of internal procedures


;-Procedures to replace Tsunami commands start here
Procedure.l w_Open(*tblInfo.TsunamiTable)
  ;Reset starting values
  ResetTsu()
  ;Initialise variables for this op
  FileName$ = *tblInfo\FileName
  FileMode.l = *tblInfo\FileMode

  Tsu\op = 0 ;Open
  Tsu\keyptr = @FileName$
  Tsu\keylen = Len(FileName$)
  Tsu\keyno = FileMode
  ;Open the data file
  Result = CallFunction(0, "trm_udt", @Tsu)
  ;Check Response
  If Result <> 0
    ExplainError(Result)
  Else
    FileHandle.l = Tsu\file
  EndIf
  ;Pass back the file handle
  ProcedureReturn FileHandle
EndProcedure

Procedure.l w_Count(*tblInfo.TsunamiTable)
  ;Reset starting values
  ResetTsu()
  ;Initialise variables for this op
  Tsu\op = 17 ;Count
  Tsu\file = *tblInfo\FileHandle
  ;Count the records
  Result = CallFunction(0,"trm_udt",@Tsu)
  ;Did it work?
  If Result = 0
    RecordCount.l = Tsu\keyno
  Else
    ExplainError(Result)
  EndIf
  ;Pass back the number
  ProcedureReturn RecordCount
EndProcedure

Procedure w_SetKeyPath(*tblInfo.TsunamiTable)
  ;Reset starting values
  ResetTsu()
  ;Initialise variables for this op
  Tsu\op = 30 ;Set Key Path
  Tsu\file = *tblInfo\FileHandle
  Tsu\keyno = *tblInfo\KeyNo
  Result = CallFunction(0,"trm_udt",@Tsu)
  ;Warn user if failed
  If Result <> 0
    ExplainError(Result)
  EndIf
EndProcedure

Procedure.s w_GetFirst(*tblInfo.TsunamiTable)
  ResetTsu()
  sRecord$ = ""
  FileName$ = *tblInfo\FileName
  RecLen.l = *tblInfo\RecLength
  sRecord$ = Space(RecLen)

  Tsu\op = 12 ;Get First
  Tsu\file = *tblInfo\FileHandle
  Tsu\keyno = *tblInfo\KeyNo
  Tsu\dataptr = @sRecord$
  Tsu\datalen = RecLen

  If RecLen = 0
    MessageRequester("Error","Record length can not be zero",#PB_MessageRequester_Ok)
  Else
    Result = CallFunction(0,"trm_udt",@Tsu)
    If Result <> 0
      ExplainError(Result)
    EndIf
  EndIf
  ;Pass back the record
  ProcedureReturn (sRecord$)
EndProcedure

Procedure.s w_GetNext(*tblInfo.TsunamiTable)
  ResetTsu()
  sRecord$ = ""
  FileName$ = *tblInfo\FileName
  RecLen.l = *tblInfo\RecLength
  sRecord$ = Space(RecLen)

  Tsu\op = 6 ;Get Next
  Tsu\file = *tblInfo\FileHandle
  Tsu\keyno = *tblInfo\KeyNo
  Tsu\dataptr = @sRecord$
  Tsu\datalen = RecLen

  If RecLen = 0
    MessageRequester("Error","Record length can not be zero",#PB_MessageRequester_Ok)
  Else
    Result = CallFunction(0,"trm_udt",@Tsu)
    If Result <> 0
      ExplainError(Result)
    EndIf
  EndIf
  ;Pass back the record
  ProcedureReturn (sRecord$)
EndProcedure

Procedure.s w_GetPrevious(*tblInfo.TsunamiTable)
  ResetTsu()
  sRecord$ = ""
  FileName$ = *tblInfo\FileName
  RecLen.l = *tblInfo\RecLength
  sRecord$ = Space(RecLen)

  Tsu\op = 7 ;Get Previous
  Tsu\file = *tblInfo\FileHandle
  Tsu\keyno = *tblInfo\KeyNo
  Tsu\dataptr = @sRecord$
  Tsu\datalen = RecLen

  If RecLen = 0
    MessageRequester("Error","Record length can not be zero",#PB_MessageRequester_Ok)
  Else
    Result = CallFunction(0,"trm_udt",@Tsu)
    If Result <> 0
      ExplainError(Result)
    EndIf
  EndIf
  ;Pass back the record
  ProcedureReturn (sRecord$)
EndProcedure

Procedure.s w_GetLast(*tblInfo.TsunamiTable)
  ResetTsu()
  sRecord$ = ""
  FileName$ = *tblInfo\FileName
  RecLen.l = *tblInfo\RecLength
  sRecord$ = Space(RecLen)

  Tsu\op = 13 ;Get Last
  Tsu\file = *tblInfo\FileHandle
  Tsu\keyno = *tblInfo\KeyNo
  Tsu\dataptr = @sRecord$
  Tsu\datalen = RecLen

  If RecLen = 0
    MessageRequester("Error","Record length can not be zero",#PB_MessageRequester_Ok)
  Else
    Result = CallFunction(0,"trm_udt",@Tsu)
    If Result <> 0
      ExplainError(Result)
    EndIf
  EndIf
  ;Pass back the record
  ProcedureReturn (sRecord$)
EndProcedure

Procedure w_Insert(*tblInfo.TsunamiTable,Record$)
  ResetTsu()
  sRecord$ = Record$
  RecLen.l = *tblInfo\RecLength

  Tsu\op = 2 ;Insert
  Tsu\file = *tblInfo\FileHandle
  Tsu\dataptr = @sRecord$
  Tsu\datalen = RecLen
  ;Look up the record length from the structure file
  Result = CallFunction(0,"trm_udt",@Tsu)
  If Result <> 0
    ExplainError(Result)
  EndIf
EndProcedure

Procedure w_Delete(*tblInfo.TsunamiTable)
  ResetTsu()
  Tsu\op = 4 ;Delete
  Tsu\file = *tblInfo\FileHandle
  Result = CallFunction(0,"trm_udt",@Tsu)
  If Result <> 0
    ExplainError(Result)
  EndIf
EndProcedure

Procedure w_Close(*tblInfo.TsunamiTable)
  ResetTsu()
  Tsu\op = 1 ;Close
  Tsu\file = *tblInfo\FileHandle
  Result = CallFunction(0,"trm_udt",@Tsu)
  If Result <> 0
    ExplainError(Result)
  EndIf
EndProcedure

Procedure w_CloseAll()
  ResetTsu()
  Tsu\op = 28 ;Close All
  Result = CallFunction(0,"trm_udt",@Tsu)
  If Result <> 0
    ExplainError(Result)
  EndIf
EndProcedure

Procedure.l w_Version(*tblInfo.TsunamiTable)
  ResetTsu()
  Tsu\op = 26 ;Version

  Result = CallFunction(0,"trm_udt",@Tsu)
  If Result <> 0
    ExplainError(Result)
  Else
    lVersion.l = Tsu\KeyNo
  EndIf
  ProcedureReturn lVersion
EndProcedure

Procedure.l w_CurrKeyPos(*tblInfo.TsunamiTable)
  ResetTsu()
  Tsu\op = 45 ;Current Key Position
  Tsu\file = *tblInfo\FileHandle
  Result = CallFunction(0,"trm_udt",@Tsu)
  If Result <> 0
    ExplainError(Result)
  Else
    lKeyPos.l = Tsu\KeyNo
  EndIf
  ProcedureReturn lKeyPos
EndProcedure

Procedure w_Accelerate(*tblInfo.TsunamiTable,lCache.l)
  ResetTsu()
  Tsu\op = 32 ;Accelerate
  Tsu\file = *tblInfo\FileHandle
  Tsu\KeyNo = lCache
  Result = CallFunction(0,"trm_udt",@Tsu)
  If Result <> 0
    ExplainError(Result)
  EndIf
EndProcedure

Procedure.l w_FileIsOpen(*tblInfo.TsunamiTable)
  ResetTsu()
  Tsu\op = 16 ;File Is Open
  Tsu\file = *tblInfo\FileHandle
  Result = CallFunction(0,"trm_udt",@Tsu)
  ProcedureReturn Result
EndProcedure

Procedure.l w_FileSize(*tblInfo.TsunamiTable)
  ResetTsu()
  Tsu\op = 18 ;File Size
  Tsu\file = *tblInfo\FileHandle
  Result = CallFunction(0,"trm_udt",@Tsu)
  If Result <> 0
    ExplainError(Result)
  Else
    lFileSize.l = Tsu\KeyNo
  EndIf
  ProcedureReturn lFileSize
EndProcedure

Procedure.l w_Flush()
  ResetTsu()
  Tsu\op = 29 ;Flush
  Result = CallFunction(0,"trm_udt",@Tsu)
  ProcedureReturn Result
EndProcedure

Procedure.s w_GetByKeyPos(*tblInfo.TsunamiTable,lKeyPos.l)
  ResetTsu()
  sRecord$ = ""
  RecLen.l = *tblInfo\RecLength
  sRecord$ = Space(RecLen)

  Tsu\op = 44 ;Get By Key Position
  Tsu\file = *tblInfo\FileHandle
  Tsu\dataptr = @sRecord$
  Tsu\datalen = RecLen
  Tsu\keyno = lKeyPos

  If RecLen = 0
    MessageRequester("Error","Record length can not be zero",#PB_MessageRequester_Ok)
  Else
    Result = CallFunction(0,"trm_udt",@Tsu)
    If Result <> 0
      ExplainError(Result)
    EndIf
  EndIf
  ;Pass back the record
  ProcedureReturn (sRecord$)
EndProcedure

Procedure.s w_GetEqual(*tblInfo.TsunamiTable,KeyVal$)
  ResetTsu()
  sRecord$ = ""
  RecLen.l = *tblInfo\RecLength
  sRecord$ = Space(RecLen)

  Tsu\op = 5 ;Get Equal
  Tsu\file = *tblInfo\FileHandle
  Tsu\keyno = *tblInfo\KeyNo
  Tsu\dataptr = @sRecord$
  Tsu\datalen = RecLen
  Tsu\KeyPtr = @KeyVal$
  Tsu\KeyLen = Len(KeyVal$)

  If RecLen = 0
    MessageRequester("Error","Record length can not be zero",#PB_MessageRequester_Ok)
  Else
    Result = CallFunction(0,"trm_udt",@Tsu)
    If Result <> 0
      ExplainError(Result)
    EndIf
  EndIf
  ;Pass back the record
  ProcedureReturn (sRecord$)
EndProcedure

Procedure.s w_GetEqualOrGreater(*tblInfo.TsunamiTable,KeyVal$)
  ResetTsu()
  sRecord$ = ""
  RecLen.l = *tblInfo\RecLength
  sRecord$ = Space(RecLen)

  Tsu\op = 9 ;Get Equal Or Greater
  Tsu\file = *tblInfo\FileHandle
  Tsu\keyno = *tblInfo\KeyNo
  Tsu\dataptr = @sRecord$
  Tsu\datalen = RecLen
  Tsu\KeyPtr = @KeyVal$
  Tsu\KeyLen = Len(KeyVal$)

  If RecLen = 0
    MessageRequester("Error","Record length can not be zero",#PB_MessageRequester_Ok)
  Else
    Result = CallFunction(0,"trm_udt",@Tsu)
    If Result <> 0
      ExplainError(Result)
    EndIf
  EndIf
  ;Pass back the record
  ProcedureReturn (sRecord$)
EndProcedure

Procedure.s w_GetEqualOrLess(*tblInfo.TsunamiTable,KeyVal$)
  ResetTsu()
  sRecord$ = ""
  RecLen.l = *tblInfo\RecLength
  sRecord$ = Space(RecLen)

  Tsu\op = 11 ;Get Equal Or Less
  Tsu\file = *tblInfo\FileHandle
  Tsu\keyno = *tblInfo\KeyNo
  Tsu\dataptr = @sRecord$
  Tsu\datalen = RecLen
  Tsu\KeyPtr = @KeyVal$
  Tsu\KeyLen = Len(KeyVal$)

  If RecLen = 0
    MessageRequester("Error","Record length can not be zero",#PB_MessageRequester_Ok)
  Else
    Result = CallFunction(0,"trm_udt",@Tsu)
    If Result <> 0
      ExplainError(Result)
    EndIf
  EndIf
  ;Pass back the record
  ProcedureReturn (sRecord$)
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ----