;**
;* info: Use of the internal Packer + Header & CRC-Check _
;* Original from jaPBe IncludesPack _
;* change for PB4 by ts-soft _
;* _
;* The Pack-Functions of PureBasic are good, but they have a little problem. _
;* They don't add a header or a CRC-Check. _
;* So when you open the wrong/currupted file, your Programm will crash. _
;* This Include should close this hole

Enumeration 1
  #PackMemErr_CRC       ;* CRC-Checksum-error
  #PackMemErr_Memory    ;* Out of Memory
  #PackMemErr_Read      ;* Can't open File to read
  #PackMemErr_Create    ;* Can't open File to create
  #PackMemErr_NoPack    ;* File is not a packfile / Can't Pack File
  #PackMemErr_NotFound  ;* File not found
EndEnumeration

Global PackPlus_LoadPackMemAdr_.l, PackPlus_LoadPackMemError_.l, PackPlus_LoadPackMemLen_.l

;** FreePackMem
;* Give the reserved memory free, _
;* needed after CatchPackMem() & LoadPackMem()
Procedure FreePackMem()
  If PackPlus_LoadPackMemAdr_
    FreeMemory(PackPlus_LoadPackMemAdr_)
    PackPlus_LoadPackMemAdr_=0
  EndIf
EndProcedure

;** CatchPackMem
;* This routine return the address to the unpacked file. _
;* If you need the length, use PackMemLength(). _
;* This function reserved memory, so don't forget to give it with FreePackMem() free. _
;* When a error happen, a #False is returned. _
;* In this Case use GetLastPackError()
Procedure CatchPackMem(adr1)
  Protected nlen.l, len.l, crc.l

  PackPlus_LoadPackMemError_=0
  FreePackMem()
  If PeekL(adr1)='kcap' ;=pack
    nlen=PeekL(adr1+4)
    len=PeekL(adr1+8)
    crc=PeekL(adr1+12)

    adr1+16
    If CRC32Fingerprint(adr1,nlen)=crc
      PackPlus_LoadPackMemAdr_=AllocateMemory(len)
      If PackPlus_LoadPackMemAdr_
        If len=nlen
          CopyMemory(adr1,PackPlus_LoadPackMemAdr_,len)
        Else
          UnpackMemory(adr1,PackPlus_LoadPackMemAdr_)
        EndIf
        PackPlus_LoadPackMemLen_=len
        ProcedureReturn PackPlus_LoadPackMemAdr_
      Else
        PackPlus_LoadPackMemError_=#PackMemErr_Memory
      EndIf
    Else
      PackPlus_LoadPackMemError_=#PackMemErr_CRC
    EndIf
  Else
    PackPlus_LoadPackMemError_=#PackMemErr_NoPack
  EndIf
  ProcedureReturn 0
EndProcedure

;** LoadPackMem
;* After you saved a file, you need to load it. _
;* This routine Return the address To the unpacked file. _
;* If you need the length, use PackMemLength(). _
;* This function reserved memory, so don't forget to give it with FreePackMem() free. _
;* When a error happen, a #False is returned. _
;* In this Case use GetLastPackError()
Procedure LoadPackMem(File$)
  Protected adrReturn.l, len.l, adr.l, FileHandle.l

  PackPlus_LoadPackMemError_=0
  len=FileSize(File$)
  If len>0
    adr=AllocateMemory(len)
    If adr
      FileHandle = ReadFile(#PB_Any, File$)
      If FileHandle
        ReadData(FileHandle, adr, len)
        CloseFile(FileHandle)
        adrReturn=CatchPackMem(adr)
      Else
        PackPlus_LoadPackMemError_=#PackMemErr_Read
      EndIf
      FreeMemory(adr)
    Else
      PackPlus_LoadPackMemError_=#PackMemErr_Memory
    EndIf
  Else
    PackPlus_LoadPackMemError_=#PackMemErr_NotFound
  EndIf
  ProcedureReturn adrReturn
EndProcedure

;** SavePackMem
;* This function will pack the given data and save it. _
;* Also a Header And a crc-checksum is added. _
;* When a error happen, a #False is returned. _
;* In this Case use GetLastPackError()
Procedure SavePackMem(File$, Buffer, len)
  Protected Result.l, nlen.l, FileHandle.l, adr.l
  Protected *buf.Long

  PackPlus_LoadPackMemError_=0
  FreePackMem()
  PackPlus_LoadPackMemAdr_=AllocateMemory(len+100)
  If PackPlus_LoadPackMemAdr_
    nlen=PackMemory(Buffer,PackPlus_LoadPackMemAdr_,len,9)
    If nlen=0 Or nlen>=len
      PackPlus_LoadPackMemError_=#PackMemErr_NoPack
      nlen=len
      CopyMemory(Buffer,PackPlus_LoadPackMemAdr_,len)
    EndIf

    FileHandle = CreateFile(#PB_Any, File$)
    If FileHandle
      adr=AllocateMemory(4+4+4+4)
      If adr
        *buf=adr
        *buf\l='kcap'                                :*buf+4; WriteLong('kcap');0 =pack
        *buf\l=nlen                                  :*buf+4; WriteLong(nlen);+4
        *buf\l=len                                   :*buf+4; WriteLong(len);+8
        *buf\l=CRC32Fingerprint(PackPlus_LoadPackMemAdr_,nlen):*buf+4; WriteLong(CRC32Fingerprint(PackPlus_LoadPackMemAdr_,nlen));+12
        WriteData(FileHandle, adr, 4+4+4+4)
        WriteData(FileHandle, PackPlus_LoadPackMemAdr_,nlen)
        CloseFile(FileHandle)
        Result = #True
        FreeMemory(adr)
      Else
        PackPlus_LoadPackMemError_=#PackMemErr_Memory
      EndIf
    Else
      PackPlus_LoadPackMemError_=#PackMemErr_Create
    EndIf
  Else
    PackPlus_LoadPackMemError_=#PackMemErr_Memory
  EndIf
  FreePackMem()
  ProcedureReturn Result
EndProcedure

Procedure AppendPackMem(FileHandle, Buffer, len)
  Protected Result.l, nlen.l, adr.l
  Protected *buf.Long

  PackPlus_LoadPackMemError_=0
  FreePackMem()
  PackPlus_LoadPackMemAdr_=AllocateMemory(len+100)
  If PackPlus_LoadPackMemAdr_
    nlen=PackMemory(Buffer,PackPlus_LoadPackMemAdr_,len,9)
    If nlen=0 Or nlen>=len
      PackPlus_LoadPackMemError_=#PackMemErr_NoPack
      nlen=len
      CopyMemory(Buffer,PackPlus_LoadPackMemAdr_,len)
    EndIf

    adr=AllocateMemory(4+4+4+4)
    If adr
      *buf = adr
      *buf\l='kcap'                                :*buf+4; WriteLong('kcap');0 =pack
      *buf\l=nlen                                  :*buf+4; WriteLong(nlen);+4
      *buf\l=len                                   :*buf+4; WriteLong(len);+8
      *buf\l=CRC32Fingerprint(PackPlus_LoadPackMemAdr_,nlen):*buf+4; WriteLong(CRC32Fingerprint(PackPlus_LoadPackMemAdr_,nlen));+12
      WriteData(FileHandle, adr, 4+4+4+4)
      WriteData(FileHandle, PackPlus_LoadPackMemAdr_,nlen)
      Result=4+4+4+4+nlen
      FreeMemory(adr)
    Else
      PackPlus_LoadPackMemError_=#PackMemErr_Memory
    EndIf
  Else
    PackPlus_LoadPackMemError_=#PackMemErr_Memory
  EndIf
  FreePackMem()
  ProcedureReturn Result
EndProcedure

;** CatchPackImage
;* This routine return the address to the unpacked file and automatic use CatchImage(). _
;* When a error happen, a #False is returned. _
;* In this Case use GetLastPackError()
Procedure CatchPackImage(Image, adr)
  Protected a.l, Result.l

  PackPlus_LoadPackMemError_= 0
  a=CatchPackMem(adr)
  If a
    Result = CatchImage(Image, a)
    FreePackMem()
    ProcedureReturn Result
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

;** CatchPackSprite
;* This routine return the address to the unpacked file and automatic use CatchSprite(). _
;* When a error happen, a #False is returned. _
;* In this Case use GetLastPackError()
Procedure CatchPackSprite(Sprite, adr, Flag)
  Protected a.l, Result.l

  PackPlus_LoadPackMemError_=0
  a=CatchPackMem(adr)
  If a
    Result = CatchSprite(Sprite, a, Flag)
    FreePackMem()
    ProcedureReturn Result
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

;** CatchPackSound
;* This routine return the address to the unpacked file and automatic use CatchSound(). _ 
;* When a error happen, a #False is returned. _
;* In this Case use GetLastPackError()
Procedure CatchPackSound(Sound, adr)
  Protected a.l, Result.l

  PackPlus_LoadPackMemError_=0
  a=CatchPackMem(adr)
  If a
    Result = CatchSound(Sound, a)
    FreePackMem()
    ProcedureReturn Result
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

;** GetLastPackError
;* Return the last errorcode
Procedure GetLastPackError()
  ProcedureReturn PackPlus_LoadPackMemError_
EndProcedure

;** PackMemFile
;* This function load, pack and then save a file. _
;* When a error happen, a #False is returned. _
;* In this Case use GetLastPackError()
Procedure PackMemFile(in$,out$)
  Protected Result.l, len.l, adr.l, FileHandle.l

  PackPlus_LoadPackMemError_=0
  len=FileSize(in$)
  If len>0
    adr=AllocateMemory(len)
    If adr
      FileHandle = ReadFile(#PB_Any, in$)
      If FileHandle
        ReadData(FileHandle, adr, len)
        CloseFile(FileHandle)
        Result =  SavePackMem(out$, adr, len)
      Else
        PackPlus_LoadPackMemError_=#PackMemErr_Create
      EndIf
      FreeMemory(adr)
    Else
      PackPlus_LoadPackMemError_=#PackMemErr_Memory
    EndIf
  Else
    PackPlus_LoadPackMemError_=#PackMemErr_NotFound
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure AppendPackFile(in$, OutFile)
  Protected Result.l, len.l, adr.l, FileHandle.l
  Protected file$

  PackPlus_LoadPackMemError_=0
  len=FileSize(in$)
  If len>0
    adr=AllocateMemory(len)
    If adr
      FileHandle = ReadFile(#PB_Any, file$)
      If FileHandle
        ReadData(FileHandle, adr, len)
        CloseFile(FileHandle)
        Result=AppendPackMem(OutFile, adr, len)
      Else
        PackPlus_LoadPackMemError_=#PackMemErr_Create
      EndIf
      FreeMemory(adr)
    Else
      PackPlus_LoadPackMemError_=#PackMemErr_Memory
    EndIf
  Else
    PackPlus_LoadPackMemError_=#PackMemErr_NotFound
  EndIf
  ProcedureReturn Result
EndProcedure

;** PackMemLength
;* This will return the length of the last unpacked file
Procedure.l PackMemLength()
  ProcedureReturn PackPlus_LoadPackMemLen_
EndProcedure


; IDE Options = PureBasic v4.00 (Windows - x86)
; CursorPosition = 207
; FirstLine = 24
; Folding = AA-
; EnableXP
; HideErrorLog