; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7241&highlight=
; Author: spangly (updated for PB3.93 by ts-soft, updated for PB 4.00 by Andre)
; Date: 16. August 2003
; OS: Windows
; Demo: No

; Windows 9x version, download the following dll
; http://download.microsoft.com/download/b/7/5/b75eace3-00e2-4aa0-9a6f-0b6882c71642/unicows.exe
; it's the microsft layer for unicode on win9x

; And use the following code instead

#RT_MANIFEST  = 24
#LANG_ID      = $0809 ; English (United Kingdom)

; change the following to the name of the exe
filename.s="pbbuild2.exe"

manifest.s=filename+".manifest" ; tag the ".manifest" suffix onto the filename

;Get the size of the manifest, allocate some memory and load it in.
size.l=FileSize(manifest)
If size>0
  mem.l=AllocateMemory(size)
  ReadFile(0,manifest)
  ReadData(0,mem,size)
  CloseFile(0)
EndIf

If OpenLibrary(0,"unicows.dll")
  ; Warning, if the manifest already exists, it will be overwritten !

  hUpdateRes = CallFunction(0,"BeginUpdateResourceA",@filename, #False)
  ; if hUpdateRes = 0 then error occured

  result = CallFunction(0,"UpdateResourceA",hUpdateRes,#RT_MANIFEST,1,#LANG_ID,mem,size)
  ; if result = 0 then an error occured

  result = CallFunction(0,"EndUpdateResourceA",hUpdateRes, #False)
  ; if result = 0 then an error occured
EndIf

If mem
  FreeMemory(mem)
EndIf

CloseLibrary(0)

End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP