; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9024&highlight=
; Author: boop64  (exist file check added by Andre)
; Date: 05. January 2004
; OS: Windows
; Demo: No


; Here is some simple code to get simple file info like when the file was created,
; modified or accessed last. The code is pretty straight forward and uses the
; following windows API calls I will put them in purebasic terms.
;
; GetFileTime_(FileID , A, B, C)
; FileID = Result obtained from using OpenFile(), ReadFile(), UseFile() etc.
; A = FILETIME structure to get the date And time the file was created.
; B = FILETIME structure to get the date And time the file was last accessed.
; C = FILETIME structure to get the date And time the file was last modified.
;
; FileTimeToLocalFileTime_(A, B)
; A = One of the FILETIME structures previously used in the GetFileTime_() function To be converted into a local file time.
; B = FILETIME structure to store converted file time.
;
; FileTimeToSystemTime_(A, B)
; A = FILETIME structure with local file time To be converted To system time.
; B = SYSTEMTIME structure to store converted system time.


FileToTest$ = "isnamevalid.pb"

;|---------------------|
;|  Coded By: Boop64   |
;|http://www.boop64.net|
;|---------------------|
;Structure FILETIME
;    dwLowDateTime.l
;    dwHighDateTime.l
;EndStructure

;Structure SYSTEMTIME
;    wYear.w
;    wMonth.w
;    wDayOfWeek.w
;    wDay.w
;    wHour.w
;    wMinute.w
;    wSecond.w
;    wMilliseconds.w
;EndStructure
;I left the structres commented here so that you can see what variables are acctually in them
;so that you can modify this code for your purposes.
;To use this just include in your projects.

Procedure.s WeekDay(day)
  Select day
  Case 0
    wday$ = "Sunday"
  Case 1
    wday$ = "Monday"
  Case 2
    wday$ = "Tuesday"
  Case 3
    wday$ = "Wedsday"
  Case 4
    wday$ = "Thursday"
  Case 5
    wday$ = "Friday"
  Case 6
    wday$ = "Saturday"
  EndSelect
  ProcedureReturn wday$
EndProcedure

Procedure.s ModifiedOn(File$)
  F1.FILETIME
  F2.FILETIME
  S1.SYSTEMTIME
  fileid.l = ReadFile(0, File$)
  GetFileTime_(fileid , #Null, #Null, F2)
  FileTimeToLocalFileTime_(F2, F1)
  FileTimeToSystemTime_(F1, S1)
  
  fileinfo$ = WeekDay(S1\wDayOfWeek) +" " + Str(S1\wMonth) +"/"+ Str(S1\wDay) +"/"+ Str(S1\wYear)
;  CloseFile(0)
  ProcedureReturn fileinfo$
EndProcedure

Procedure.s LastAccess(File$)
  F1.FILETIME
  F2.FILETIME
  S1.SYSTEMTIME
  fileid.l = ReadFile(0, File$)
  GetFileTime_(fileid , #Null, F2, #Null)
  FileTimeToLocalFileTime_(F2, F1)
  FileTimeToSystemTime_(F1, S1)
  
  fileinfo$ = WeekDay(S1\wDayOfWeek) +" " + Str(S1\wMonth) +"/"+ Str(S1\wDay) +"/"+ Str(S1\wYear)
;  CloseFile(0)
  ProcedureReturn fileinfo$
EndProcedure

Procedure.s CreatedOn(File$)
  F1.FILETIME
  F2.FILETIME
  S1.SYSTEMTIME
  fileid.l = ReadFile(0, File$)
  GetFileTime_(fileid , F2, #Null, #Null)
  FileTimeToLocalFileTime_(F2, F1)
  FileTimeToSystemTime_(F1, S1)
  
  fileinfo$ = WeekDay(S1\wDayOfWeek) +" " + Str(S1\wMonth) +"/"+ Str(S1\wDay) +"/"+ Str(S1\wYear)
;  CloseFile(0)
  ProcedureReturn fileinfo$
EndProcedure

If FileSize(FileToTest$) > 0
  MessageRequester("Created On", CreatedOn(FileToTest$))
  MessageRequester("Last Accessed", LastAccess(FileToTest$))
  MessageRequester("Modified On", ModifiedOn(FileToTest$))
Else
  MessageRequester("Error", "File "+FileToTest$ + " don't exist!")
EndIf
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
