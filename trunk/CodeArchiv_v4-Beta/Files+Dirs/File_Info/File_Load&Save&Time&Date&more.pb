; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2988&highlight=
; Author: GPI (updated for PB4.00 by blbltheworm)
; Date: 02. December 2003
; OS: Windows
; Demo: No

#FileAttribute_Archive   =#FILE_ATTRIBUTE_ARCHIVE 
#FileAttribute_Compressed=#FILE_ATTRIBUTE_COMPRESSED 
#FileAttribute_Directory =#FILE_ATTRIBUTE_DIRECTORY 
#FileAttribute_Hidden    =#FILE_ATTRIBUTE_HIDDEN 
#FileAttribute_Normal    =#FILE_ATTRIBUTE_NORMAL 
#FileAttribute_ReadOnly  =#FILE_ATTRIBUTE_READONLY 
#FileAttribute_System    =#FILE_ATTRIBUTE_SYSTEM 
#FileAttribute_Temporary =#FILE_ATTRIBUTE_TEMPORARY 

Procedure FileTimeToDate(*FT.FILETIME); - Convert API-Time-Format to PB-Date() 
  FileTimeToLocalFileTime_(*FT.FILETIME,FT2.FILETIME) 
  FileTimeToSystemTime_(FT2,st.SYSTEMTIME) 
  ProcedureReturn Date(st\wYear,st\wMonth,st\wDay,st\wHour,st\wMinute,st\wSecond) 
EndProcedure 

Procedure DateToFileTime(date,*FT.FILETIME); - Convert PB-Date() to API-Time-Format 
  st.SYSTEMTIME 
  st\wYear=Year(date) 
  st\wMonth=Month(date) 
  st\wDayOfWeek=DayOfWeek(date) 
  st\wDay=Day(date) 
  st\wHour=Hour(date) 
  st\wMinute=Minute(date) 
  st\wSecond=Second(date) 
  SystemTimeToFileTime_(st,FT2.FILETIME) 
  LocalFileTimeToFileTime_(FT2,*FT) 
EndProcedure 

Procedure GetFileTime(File$); - Get the time of a File 
  Result=0 
  handle=CreateFile_(@File$,#GENERIC_READ,#FILE_SHARE_READ|#FILE_SHARE_WRITE,0,#OPEN_EXISTING,#FILE_ATTRIBUTE_NORMAL,0) 
  If handle<>#INVALID_HANDLE_VALUE 
    GetFileTime_(handle,0,0,FT.FILETIME) 
    Result=FileTimeToDate(FT) 
    CloseHandle_(handle) 
  EndIf 
  ProcedureReturn Result 
EndProcedure 

Procedure SetFileTime(File$,date); - Set the time of a File 
  handle=CreateFile_(@File$,#GENERIC_WRITE,#FILE_SHARE_READ|#FILE_SHARE_WRITE,0,#OPEN_EXISTING,#FILE_ATTRIBUTE_NORMAL,0) 
  If handle<>#INVALID_HANDLE_VALUE 
    DateToFileTime(date,FT.FILETIME) 
    SetFileTime_(handle,0,0,FT.FILETIME) 
    CloseHandle_(handle) 
  Else 
    Debug "Cant" 
  EndIf 
EndProcedure 

Procedure.s GetAttribMask(Attribute); - Create a String with every char stands for a Attribute (a--r-) 
  mask$="-----" : 
  If Attribute & #FILE_ATTRIBUTE_ARCHIVE    : mask$="A"+Mid(mask$,2,5)               : EndIf 
  If Attribute & #FILE_ATTRIBUTE_COMPRESSED : mask$=Left(mask$,1)+"C"+Mid(mask$,3,3) : EndIf 
  If Attribute & #FILE_ATTRIBUTE_HIDDEN     : mask$=Left(mask$,2)+"H"+Mid(mask$,4,2) : EndIf 
  If Attribute & #FILE_ATTRIBUTE_READONLY   : mask$=Left(mask$,3)+"R"+Mid(mask$,5,1) : EndIf 
  If Attribute & #FILE_ATTRIBUTE_SYSTEM     : mask$=Left(mask$,4)+"S"                : EndIf 
  ProcedureReturn mask$ 
EndProcedure 

Procedure.l RecycleFile(File$); - Delete a file and move it in the Recycle-Bin 
  SHFileOp.SHFILEOPSTRUCT 
  SHFileOp\pFrom=@File$ 
  SHFileOp\wFunc=#FO_DELETE 
  SHFileOp\fFlags=#FOF_ALLOWUNDO 
  ProcedureReturn SHFileOperation_(SHFileOp) 
EndProcedure 

Procedure BLoad(File$,Address); - Load a file into memory 
  If ReadFile(0,File$) 
    ReadData(0,Address,Lof(0)) 
    CloseFile(0) 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 

Procedure BSave(File$,Address,length); - Save a memory-block 
  If CreateFile(0,File$) 
    WriteData(0,Address,length) 
    CloseFile(0) 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 

Structure Dir_Handle 
  dwFileAttributes.l 
  ftCreationTime.FILETIME 
  ftLastAccessTime.FILETIME 
  ftLastWriteTime.FILETIME 
  nFileSizeHigh.l 
  nFileSizeLow.l 
  dwReserved0.l 
  dwReserved1.l 
  cFileName.b[ #MAX_PATH ] 
  cAlternate.b[ 14 ] 
  DontRead.l ;additional 
  handle.l 
EndStructure 

Procedure Dir_Examine(*Handle.Dir_Handle,File$); - Start examine directory 
  *Handle\handle = FindFirstFile_(@File$,*Handle) 
  *Handle\DontRead=1 
  If *Handle\handle <> #INVALID_HANDLE_VALUE 
    ProcedureReturn #True 
  Else 
    ProcedureReturn 0 
  EndIf 
EndProcedure 

Procedure Dir_End(*Handle.Dir_Handle) 
  FindClose_(*Handle\handle) 
EndProcedure  

Procedure Dir_NextEntry(*Handle.Dir_Handle) 
  If *Handle\DontRead=1 
    *Handle\DontRead=0 
    x=#True 
  Else 
    x=FindNextFile_(*Handle\handle,*Handle) 
  EndIf 
  If x 
    If *Handle\dwFileAttributes&#FILE_ATTRIBUTE_DIRECTORY 
      ProcedureReturn 2; verzeichnis 
    Else 
      ProcedureReturn 1; datei 
    EndIf 
  Else 
    ProcedureReturn 0; ende 
  EndIf 
EndProcedure 

Procedure.s Dir_EntryName(*Handle.Dir_Handle) 
  ProcedureReturn PeekS(@*Handle\cFileName[0],#MAX_PATH) 
EndProcedure 

Procedure Dir_EntryAttributes(*Handle.Dir_Handle) 
  ProcedureReturn *Handle\dwFileAttributes 
EndProcedure 

Procedure Dir_EntryTime(*Handle.Dir_Handle) 
  ProcedureReturn FileTimeToDate(*Handle\ftLastWriteTime) 
EndProcedure 

Procedure Dir_EntrySize(*Handle.Dir_Handle) 
  ProcedureReturn (*Handle\nFileSizeHigh<<16+*Handle\nFileSizeLow) 
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ---
