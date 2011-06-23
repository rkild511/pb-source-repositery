; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3656&highlight=
; Author: bingo
; Date: 08. February 2004
; OS: Windows
; Demo: No

DataSection 
  regbin_data: 
  Data.b 128,0,0,0,1,2,3,4,5,6,7,8,9 ;byte-werte decimal ! 
EndDataSection 

datasize.l = 13 ;anzahl der binärdaten ! 

openkey = #HKEY_LOCAL_MACHINE 
subkey.s = "SOFTWARE" 
keyset.s = "test" 
hkey.l = 0 

RegCreateKey_(OpenKey,SubKey,@hKey) 
RegSetValueEx_(hKey,keyset,0,#REG_BINARY,?regbin_data,datasize) 
RegCloseKey_(hKey) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -