; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7241&highlight=
; Author: spangly (updated for PB3.93 by ts-soft, updated for PB 4.00 by Andre)
; Date: 16. August 2003
; OS: Windows
; Demo: No

; Note: Will not work on Win9x !!!
; The following code is an example of how to add the XP manifest file to your program,
; it could be adapted to add anything you like to the resource section of any program.
; There isn't much error checking, but I've added comments so you know what's going on  

#RT_MANIFEST  = 24 
#LANG_ID      = $0809 ; English (United Kingdom) 

; change the following to the name of the exe 
filename.s="filename.exe" 

manifest.s=filename+".manifest" ; tag the ".manifest" suffix onto the filename 

;Get the size of the manifest, allocate some memory and load it in. 
size.l=FileSize(manifest) 
If size>0 
  mem.l=AllocateMemory(size) 
  ReadFile(0,manifest) 
  ReadData(0,mem,size) 
  CloseFile(0) 
EndIf 

; Warning, if the manifest already exists, it will be overwritten ! 

hUpdateRes = BeginUpdateResource_(filename, FALSE) 
; if hUpdateRes = 0 then error occured 

result = UpdateResource_(hUpdateRes,#RT_MANIFEST,1,#LANG_ID,mem,size) 
; if result = 0 then an error occured 

result = EndUpdateResource_(hUpdateRes, #False) 
; if result = 0 then an error occured 

If mem
  FreeMemory(mem) 
EndIf

End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -