; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3656&highlight=
; Author: bingo
; Date: 08. February 2004
; OS: Windows
; Demo: No
 
; Setzt in der Registry unter HKEY_LOCAL_MACHINE\SOFTWARE einen BINÄRWERT TEST mit dem Inhalt
; der Datei 'reg.bin'.
openkey = #HKEY_LOCAL_MACHINE 
subkey.s = "SOFTWARE" 
keyset.s = "test" 
hkey.l = 0 

RegCreateKey_(OpenKey,SubKey,@hKey) 
datasize.l = ?endofmykeydata - ?mykeydata 
RegSetValueEx_(hKey,keyset,0,#REG_BINARY,?mykeydata,datasize) 
RegCloseKey_(hKey) 

DataSection 
  mykeydata: 
  IncludeBinary "reg.bin" 
  endofmykeydata: 
  Data.b 0 
EndDataSection 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -