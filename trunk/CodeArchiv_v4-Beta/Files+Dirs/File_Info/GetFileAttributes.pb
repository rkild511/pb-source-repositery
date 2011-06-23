; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=769&highlight=
; Author: NicTheQuick (updated for PB3.92+ by Lars)
; Date: 11. December 2003
; OS: Windows
; Demo: No

#TrennZ = ";" 
LF.s = Chr(13) + Chr(10) 
Tab.s = Chr(9) 

Procedure GetSystemTime(*FileTime.FILETIME, *SystemTime.SYSTEMTIME) 
  ProcedureReturn FileTimeToSystemTime_(*FileTime, *SystemTime) 
EndProcedure 
Procedure.s GetDateOfSystemTime(*SystemTime.SYSTEMTIME) 
  Protected Date.s 
  Date = Str(*SystemTime\wDay) + "." + Str(*SystemTime\wMonth) + "." + Str(*SystemTime\wYear) 
  ProcedureReturn Date 
EndProcedure 
Procedure.s StrEx(Value.l, Length.l) 
  Protected StrEx.s 
  StrEx = RSet(Str(Value), Length, "0") 
  ProcedureReturn StrEx 
EndProcedure 
Procedure.s GetTimeOfSystemTime(*SystemTime.SYSTEMTIME) 
  Protected time.s 
  time = StrEx(*SystemTime\wHour, 2) + ":" + StrEx(*SystemTime\wMinute, 2) + ":" + StrEx(*SystemTime\wSecond, 2) + "," + Str(*SystemTime\wMilliseconds) 
  ProcedureReturn time 
EndProcedure 
Procedure.s GetDayOfSystemTime(*SystemTime.SYSTEMTIME) 
  Protected Day.s 
  Select *SystemTime\wDayOfWeek 
    Case 0 : Day = "Sonntag" 
    Case 1 : Day = "Montag" 
    Case 2 : Day = "Dienstag" 
    Case 3 : Day = "Mittwoch" 
    Case 4 : Day = "Donnerstag" 
    Case 5 : Day = "Freitag" 
    Case 6 : Day = "Samstag" 
  EndSelect 
  ProcedureReturn Day 
EndProcedure 
Procedure.s GetStringOfSystemTime(*SystemTime.SYSTEMTIME) 
  Protected String.s 
  String = GetDayOfSystemTime(*SystemTime) + ", " + GetDateOfSystemTime(*SystemTime) + ", " + GetTimeOfSystemTime(*SystemTime) 
  ProcedureReturn String 
EndProcedure 

Structure FileAttributes 
  FileAttributes.l 
  CreationTime.FILETIME 
  LastAccessTime.FILETIME 
  LastWriteTime.FILETIME 
  FileSizeHigh.l 
  FileSizeLow.l 
EndStructure 

Structure FileInformation Extends FileAttributes 
  Name.s 
EndStructure 

Procedure.s GetStringAttributes(Attr.l) 
  Protected Attributes.s 
  If Attr & #FILE_ATTRIBUTE_ARCHIVE 
    Attributes = "Archived" + #TrennZ 
  EndIf 
  If Attr & #FILE_ATTRIBUTE_COMPRESSED 
    Attributes = Attributes + "Compressed" + #TrennZ 
  EndIf 
  If Attr & #FILE_ATTRIBUTE_DIRECTORY 
    Attributes = Attributes + "IsDirectory" + #TrennZ 
  EndIf 
  If Attr & #FILE_ATTRIBUTE_ENCRYPTED 
    Attributes = Attributes + "Encrypted" + #TrennZ 
  EndIf 
  If Attr & #FILE_ATTRIBUTE_HIDDEN 
    Attributes = Attributes + "Hidden" + #TrennZ 
  EndIf 
  If Attr & #FILE_ATTRIBUTE_NORMAL 
    Attributes = Attributes + "Normal" + #TrennZ 
  EndIf 
  If Attr & #FILE_ATTRIBUTE_OFFLINE 
    Attributes = Attributes + "Offline" + #TrennZ 
  EndIf 
  If Attr & #FILE_ATTRIBUTE_READONLY 
    Attributes = Attributes + "Readonly" + #TrennZ 
  EndIf 
  If Attr & #FILE_ATTRIBUTE_REPARSE_POINT 
    Attributes = Attributes + "Reparse Point" + #TrennZ 
  EndIf 
  If Attr & #FILE_ATTRIBUTE_SPARSE_FILE 
    Attributes = Attributes + "Sparse File" + #TrennZ 
  EndIf 
  If Attr & #FILE_ATTRIBUTE_SYSTEM 
    Attributes = Attributes + "System" + #TrennZ 
  EndIf 
  If Attr & #FILE_ATTRIBUTE_TEMPORARY 
    Attributes = Attributes + "Temporary" + #TrennZ 
  EndIf 
  ProcedureReturn Left(Attributes, Len(Attributes) - 1) 
EndProcedure 

#GetFileExInfoStandard = 0 
Procedure GetFileInformation(File.s, *FileInformation.FileInformation) 
  *FileInformation\Name = File 
  ProcedureReturn GetFileAttributesEx_(@File, #GetFileExInfoStandard, @*FileInformation\FileAttributes) 
EndProcedure 

File.s = OpenFileRequester("Informationen von", "", "Alle Dateien (*.*)|*.*", 0) 
If File 
  
  FileInfo.FileInformation 
  SystemTime.SYSTEMTIME 
  GetFileInformation(File, FileInfo) 
  
  Info.s =        "File: " + Tab + Tab + FileInfo\Name + LF 
  Info   = Info + "Attributes: " + Tab + GetStringAttributes(FileInfo\FileAttributes) + LF 
  GetSystemTime(@FileInfo\CreationTime, @SystemTime) 
  Info   = Info + "Creation Time: " + Tab + GetStringOfSystemTime(@SystemTime) + LF 
  GetSystemTime(@FileInfo\LastAccessTime, @SystemTime) 
  Info   = Info + "Last Access Time: " + Tab + GetDayOfSystemTime(@SystemTime) + ", " + GetDateOfSystemTime(@SystemTime) + LF 
  GetSystemTime(@FileInfo\LastWriteTime, @SystemTime) 
  Info   = Info + "Last Write Time: " + Tab + GetStringOfSystemTime(@SystemTime) + LF 
  
  MessageRequester("File Info", Info) 
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
