; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=519&highlight=
; Author: GPI (updated for PB4.00 by blbltheworm)
; Date: 15. December 2003
; OS: Windows
; Demo: No

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
  Handle=CreateFile_(@File$,#GENERIC_READ,#FILE_SHARE_READ|#FILE_SHARE_WRITE,0,#OPEN_EXISTING,#FILE_ATTRIBUTE_NORMAL,0) 
  If Handle<>#INVALID_HANDLE_VALUE 
    GetFileTime_(Handle,0,0,FT.FILETIME) 
    Result=FileTimeToDate(FT) 
    CloseHandle_(Handle) 
  EndIf 
  ProcedureReturn Result 
EndProcedure 

Procedure SetFileTime(File$,date); - Set the time of a File 
  Handle=CreateFile_(@File$,#GENERIC_WRITE,#FILE_SHARE_READ|#FILE_SHARE_WRITE,0,#OPEN_EXISTING,#FILE_ATTRIBUTE_NORMAL,0) 
  If Handle<>#INVALID_HANDLE_VALUE 
    DateToFileTime(date,FT.FILETIME) 
    SetFileTime_(Handle,0,0,FT.FILETIME) 
    CloseHandle_(Handle) 
  Else 
    Debug "Cant" 
  EndIf 
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
