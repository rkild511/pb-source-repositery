; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2381&postdays=0&postorder=asc&start=0
; Author: Topsoft (updated for PB4.00 by blbltheworm)
; Date: 24. September 2003
; OS: Windows
; Demo: No

Procedure Pref_WriteString(Abschnitt.s,Schluessel.s,Wert.s,Datei.s) 
  Debug Abschnitt
  Debug Schluessel
  Debug Wert
  Debug Datei
  Debug "---"
  WritePrivateProfileString_ (Abschnitt, Schluessel, Wert,Datei) 
EndProcedure 

Procedure Pref_WriteByte(Abschnitt.s,Schluessel.s,Wert.b,Datei.s) 
     WritePrivateProfileString_ (Abschnitt, Schluessel, Str(Wert & $FF),Datei) 
EndProcedure 

Procedure Pref_WriteWord(Abschnitt.s,Schluessel.s,Wert.w,Datei.s) 
     WritePrivateProfileString_ (Abschnitt, Schluessel, Str(Wert & $FFFF),Datei) 
EndProcedure 

Procedure Pref_WriteLong(Abschnitt.s,Schluessel.s,Wert.l,Datei.s) 
     WritePrivateProfileString_ (Abschnitt, Schluessel, Str(Wert),Datei) 
EndProcedure 

Procedure.s Pref_ReadString(Abschnitt.s,Schluessel.s,Datei.s) 
     value.s = Space(255) 
     Result.l = GetPrivateProfileString_ (Abschnitt, Schluessel, "", value, Len(value), Datei) 
     value = Left(value, Result) 
     ProcedureReturn value 
EndProcedure 

Procedure.b Pref_ReadByte(Abschnitt.s,Schluessel.s,Datei.s) 
     value.s = Space(255) 
     Result.l = GetPrivateProfileString_ (Abschnitt, Schluessel, "", value, Len(value), Datei) 
     value = Left(value, Result) 
     ProcedureReturn Val(value) & $FF 
EndProcedure 

Procedure.w Pref_ReadWord(Abschnitt.s,Schluessel.s,Datei.s) 
     value.s = Space(255) 
     Result.l = GetPrivateProfileString_ (Abschnitt, Schluessel, "", value, Len(value), Datei) 
     value = Left(value, Result) 
     ProcedureReturn Val(value) & $FFFF 
EndProcedure 

Procedure.l Pref_ReadLong(Abschnitt.s,Schluessel.s,Datei.s) 
     value.s = Space(255) 
     Result.l = GetPrivateProfileString_ (Abschnitt, Schluessel, "", value, Len(value), Datei) 
     value = Left(value, Result) 
     ProcedureReturn Val(value) 
EndProcedure 

Procedure Pref_DelSchluessel(Abschnitt.s,Schluessel.s,Datei.s) 
     WritePrivateProfileString_ (Abschnitt, Schluessel, 0,Datei) 
EndProcedure 

Procedure Pref_DelAbschnitt(Abschnitt.s,Datei.s) 
     WritePrivateProfileString_ (Abschnitt, 0, "",Datei) 
EndProcedure 

;- Example
Datei.s = "C:\Test.ini" 
Pref_WriteString("Test","String","Hallo",Datei) 
Pref_WriteByte("Test","Byte",77,Datei) 
Pref_WriteWord("Test","Word",777,Datei) 
Pref_WriteLong("Test","Long",77777,Datei) 

Pref_WriteString("Test1","String","Hallo1",Datei) 
Pref_WriteByte("Test1","Byte",177,Datei) 
Pref_WriteWord("Test1","Word",1777,Datei) 
Pref_WriteLong("Test1","Long",177777,Datei) 

Debug Pref_ReadString("Test","String",Datei) 
Debug Pref_ReadByte("Test","Byte",Datei) 
Debug Pref_ReadWord("Test","Word",Datei) 
Debug Pref_ReadLong("Test","Long",Datei) 

Debug Pref_ReadString("Test1","String",Datei) 
Debug Pref_ReadByte("Test1","Byte",Datei) 
Debug Pref_ReadWord("Test1","Word",Datei) 
Debug Pref_ReadLong("Test1","Long",Datei) 

Pref_DelSchluessel("Test","String", Datei) 

Debug Pref_ReadString("Test","String",Datei) 
Debug Pref_ReadByte("Test","Byte",Datei) 
Debug Pref_ReadWord("Test","Word",Datei) 
Debug Pref_ReadLong("Test","Long",Datei) 

Debug Pref_ReadString("Test1","String",Datei) 
Debug Pref_ReadByte("Test1","Byte",Datei) 
Debug Pref_ReadWord("Test1","Word",Datei) 
Debug Pref_ReadLong("Test1","Long",Datei) 

Pref_DelAbschnitt("Test",Datei) 

Debug Pref_ReadString("Test","String",Datei) 
Debug Pref_ReadByte("Test","Byte",Datei) 
Debug Pref_ReadWord("Test","Word",Datei) 
Debug Pref_ReadLong("Test","Long",Datei) 

Debug Pref_ReadString("Test1","String",Datei) 
Debug Pref_ReadByte("Test1","Byte",Datei) 
Debug Pref_ReadWord("Test1","Word",Datei) 
Debug Pref_ReadLong("Test1","Long",Datei) 

Pref_DelAbschnitt("Test1",Datei) 

Debug Pref_ReadString("Test","String",Datei) 
Debug Pref_ReadByte("Test","Byte",Datei) 
Debug Pref_ReadWord("Test","Word",Datei) 
Debug Pref_ReadLong("Test","Long",Datei) 

Debug Pref_ReadString("Test1","String",Datei) 
Debug Pref_ReadByte("Test1","Byte",Datei) 
Debug Pref_ReadWord("Test1","Word",Datei) 
Debug Pref_ReadLong("Test1","Long",Datei)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
