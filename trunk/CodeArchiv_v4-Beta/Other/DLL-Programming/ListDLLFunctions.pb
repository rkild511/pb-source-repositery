; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8607&highlight=
; Author: PB
; Date: 04. December 2003
; OS: Windows
; Demo: Yes

; If you need to know what functions a particular DLL has, you can find out 
; with the following code. However, note that this code doesn't list the 
; required parameters for each API function, so you may need To do a bit 
; of Google searching (or whatever) to find out. 

If OpenLibrary(0,"shell32.dll") ; Name of DLL to browse. 
  If ExamineLibraryFunctions(0) 
    While NextLibraryFunction() 
      Debug LibraryFunctionName() 
    Wend 
  EndIf 
  CloseLibrary(0) 
EndIf 
 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
