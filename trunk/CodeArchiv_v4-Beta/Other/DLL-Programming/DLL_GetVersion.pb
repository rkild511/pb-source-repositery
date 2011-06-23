; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2320&highlight=
; Author: Rings (updated for PB 4.00 by Andre)
; Date: 17. September 2003
; OS: Windows
; Demo: Yes

dwVersion.DllVersionInfo 
dwVersion\cbSize=20 

#Shlwapi=1 

If OpenLibrary(#Shlwapi,"Shlwapi.dll")    ; Example for Internet Explorer
  FunctionPointer=GetFunction(#Shlwapi,"DllGetVersion") 
  If FunctionPointer 
    Result=CallFunctionFast(FunctionPointer, dwVersion) 
    Debug dwVersion\dwMajorVersion 
  EndIf 
  CloseLibrary(#Shlwapi) 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
