; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7191&highlight=
; Author: GPI
; Date: 11. August 2003
; OS: Windows
; Demo: No

;Info: Create and Read file with API 
#API_File_BufferLen=1024*4 

Structure API_FileHandle 
  FHandle.l 
  Buffer.l 
  ReadPos.l 
  DataInBuffer.l 
EndStructure 
Procedure API_LOF(*File.API_FileHandle) 
  ProcedureReturn GetFileSize_(*File\FHandle,0) 
EndProcedure 
Procedure API_CloseFile(*File.API_FileHandle) 
  CloseHandle_(*File\FHandle) 
  If *File\Buffer 
    GlobalFree_(*File\Buffer):*File\Buffer=0 
  EndIf 
EndProcedure 
Procedure API_FileRead(*File.API_FileHandle,File$) 
  *File\FHandle=CreateFile_(File$,#GENERIC_READ,#FILE_SHARE_READ,0,#OPEN_EXISTING,#FILE_ATTRIBUTE_NORMAL,0) 
  If *File\FHandle=#INVALID_HANDLE_VALUE 
    ProcedureReturn #False 
  Else 
    *File\Buffer=GlobalAlloc_(#GMEM_FIXED|#GMEM_ZEROINIT,#API_File_BufferLen) 
    *File\ReadPos=*File\Buffer 
    *File\DataInBuffer=0 
    ProcedureReturn #True 
  EndIf 
EndProcedure 
Procedure API_ReadData(*File.API_FileHandle,*Buffer,len) 
  Result=0 
  If *File\DataInBuffer>=len 
    CopyMemory(*File\ReadPos,*Buffer,len) 
    *File\DataInBuffer-len 
    If *File\DataInBuffer 
      *File\ReadPos+len 
    Else 
      *File\ReadPos=*File\Buffer 
    EndIf 
    Result=len 
  Else 
    If *File\DataInBuffer>0 
      CopyMemory(*File\ReadPos,*Buffer,*File\DataInBuffer) 
      *Buffer+*File\DataInBuffer 
      Result=*File\DataInBuffer 
      len-*File\DataInBuffer 
      *File\DataInBuffer=0 
      *File\ReadPos=*File\Buffer 
    EndIf 
    If ReadFile_(*File\FHandle,*Buffer,len,@readed,0)<>0 
      Result+readed 
    EndIf 
  EndIf 
  ProcedureReturn Result 
EndProcedure 
Procedure API_ReadByte(*File.API_FileHandle) 
  If *File\DataInBuffer=0 
    If ReadFile_(*File\FHandle,*File\Buffer,#API_File_BufferLen,@readed,0)<>0 
      *File\DataInBuffer=readed 
      *File\ReadPos=*File\Buffer 
    EndIf 
  EndIf 
  If *File\DataInBuffer 
    Result=PeekB(*File\ReadPos) &$FF : *File\ReadPos+1:*File\DataInBuffer-1 
  Else 
    Result=-1 
  EndIf 
  ProcedureReturn Result 
EndProcedure 
Procedure API_PushBackByte(*File.API_FileHandle) 
  If *File\ReadPos>*File\Buffer 
    *File\ReadPos-1:*File\DataInBuffer+1 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 
Procedure API_EOF(*File.API_FileHandle) 
  If API_ReadByte(*File)=-1 
    ProcedureReturn #True 
  Else 
    API_PushBackByte(*File) 
    ProcedureReturn #False 
  EndIf 
EndProcedure 
Procedure.s API_ReadString(*File.API_FileHandle) 
  a$="" 
  ende=#False 
  Repeat 
    byte=API_ReadByte(*File) 
    Select byte 
      Case 0:ende=#True 
      Case 10:ende=#True:byte=API_ReadByte(*File):If byte<>13 And byte<>10 And byte<>0 And byte<>-1: API_PushBackByte(*File) :EndIf 
      Case 13:ende=#True:byte=API_ReadByte(*File):If byte<>13 And byte<>10 And byte<>0 And byte<>-1: API_PushBackByte(*File) :EndIf 
      Case -1:ende=#True 
      Default 
        a$+Chr(byte) 
    EndSelect 
  Until ende 
  
  ProcedureReturn a$ 
EndProcedure 
Procedure API_FileCreate(*File.API_FileHandle,File$) 
  *File\FHandle=CreateFile_(File$,#GENERIC_WRITE   ,0,0,#CREATE_ALWAYS   ,#FILE_ATTRIBUTE_NORMAL,0) 
  If *File\FHandle=#INVALID_HANDLE_VALUE 
    ProcedureReturn #False 
  Else 
    ProcedureReturn #True 
  EndIf 
EndProcedure 
Procedure API_WriteData(*File.API_FileHandle,*Buffer,len) 
  If WriteFile_(*File\FHandle,*Buffer,len,@written,0) 
    ProcedureReturn written 
  Else 
    ProcedureReturn 0 
  EndIf 
EndProcedure 
Procedure API_WriteString(*File.API_FileHandle,a$) 
  ProcedureReturn API_WriteData(*File,@a$,Len(a$)) 
EndProcedure 
Procedure API_WriteStringN(*File.API_FileHandle,a$) 
  a$+Chr(13)+Chr(10) 
  ProcedureReturn API_WriteData(*File,@a$,Len(a$)) 
EndProcedure 

FHandle.API_FileHandle 
File$="Hallo.txt" 
random$=Str(Random(1000)) 
Debug "random:"+random$ 
If API_FileCreate(FHandle,File$) 
  API_WriteString(FHandle,"Test ") 
  API_WriteStringN(FHandle,"Hallo") 
  API_WriteStringN(FHandle,"Zeile 2") 
  API_WriteStringN(FHandle,"Zeile 3") 
  API_WriteStringN(FHandle,random$) 
  API_CloseFile(FHandle) 
EndIf 
Debug "---" 
If API_FileRead(FHandle,File$) 
  While API_EOF(FHandle)=#False 
    Debug API_ReadString(FHandle) 
  Wend 
  API_CloseFile(FHandle) 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ---
