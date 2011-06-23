; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14336&highlight=
; Author: Rescator
; Date: 09. March 2005
; OS: Windows
; Demo: No


; Get the 64bit filesize of a file! (Windows) 
; 64Bit Dateigröße einer Datei ermitteln! (Windows)

; This example is considered Public Domain, do with as you wish!

; The value in size64 can be used directly by Rings Uint64 library,
; I'm not sure if the F64 library can use the resulting size64 value
; as I doesn't seem to store it's values as a standard LARGER_INTEGER structure,
; nor did I see any functions for handling normal 64bit values.
; F64 lib seems to use it's own structure for storing values (correct me if I'm wrong)
; however Rings Uint64 lib should provide all you need to compare filesizes etc.
; until PureBasics own commands get 64bit support.
;
; Note!
; GetFileSize_() works with any windows,
; GetFileSizeEx_() is only available with NT5+ kernel. (Windows 2000, XP, 2003, and future windows)
;
; And since the current PureBasic seems to lack the definition gor GetFileSizeEx_() a
; temporary solution is used as you can see.
;
; Oh and you can find Rings Uint64 lib at http://www.purearea.net/ in the "User - libs" section.
;
; Have fun!



Procedure.l FileSize64(filename.s,*int64size.LARGE_INTEGER)
  hFile.l=CreateFile_(@filename.s,#GENERIC_READ,#FILE_SHARE_READ,0,#OPEN_EXISTING,0,0)
  If hFile=-1
    ProcedureReturn #False
  EndIf
  os.l=OSVersion()
  If os=#PB_OS_Windows_95 Or os=#PB_OS_Windows_98 Or os=#PB_OS_Windows_ME Or os=#PB_OS_Windows_NT3_51 Or os=#PB_OS_Windows_NT_4
    *int64size\LowPart=GetFileSize_(hFile.l,@*int64size\HighPart)
    CloseHandle_(hFile)
    If *int64size\LowPart=-1
      If GetLastError_()
        *int64size\LowPart=0
        ProcedureReturn #False
      EndIf
    EndIf
  Else ;NT5+ (i.e. 2000, XP, 2003, +++)
    ;when GetFileSizeEx_ api function is added:
    #KERNEL32=0 ;remove this
    OpenLibrary(#KERNEL32,"kernel32.dll") ;remove this
    ;uncomment the next line
    ;result.l=GetFileSizeEx_(hFile.l,*int64size)
    ;and remove the next line
    result.l=CallFunction(#KERNEL32,"GetFileSizeEx",hFile.l,*int64size)
    CloseHandle_(hFile)
    If result=0
      ProcedureReturn #False
    EndIf
  EndIf
  ProcedureReturn *int64size
EndProcedure

size64.LARGE_INTEGER
If FileSize64("f:\simpsons.rar",size64)
  Debug "size64 should now hold the 64bit integer filesize!"
Else
  Debug "There was an error!"
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -