; German forum: http://robsite.de/php/pureboard/viewtopic.php?t=1828
; Author: galaxy
; Date: 26. July 2003

;EasyBase DLL - Include File - 
;(C) 2002, MRK-Soft 
;Version 1.03 

; DLL can be found on Galaxy's homepage: http://www.mrk-soft.de > Software > EASYDB.DLL

;Diese Include Datei vereinfacht die Aufrufe von EasyDB in Pure-Basic ab V3.00 
;Die Syntax ist der HTM Dokumentation zu entnehmen. 

;Besonderheit 

;      value$ = edbGET(n1$)    
; Es wird nur EIN Parameter übergeben. N1$ ist der Name des Feldes, die Funktion 
; gibt als String den Inhalt des Feldes zurück. 

;      value$ = edbGETIDX(n1.l)    
; Es wird nur EIN Parameter übergeben. N1 ist die Nummer des Feldes, die Funktion 
; gibt als String den Inhalt des Feldes zurück. 

;      value$ = edbGetInfo(n1$) 
; Entgegen der Dokumentation zur DLL wird hier nur 1 Parameter übergeben, und zwars 
; die System-Variable als STRING. Die Funktion wird hier durch die Procedure vereinfacht. 

#base100dll = 0 
basedll.l = OpenLibrary(#base100dll,"base100.dll")      ;dll öffnen 

Procedure.l edbRegister(p1.l) 
value.l = CallFunction(#base100dll,"edbRegister",p1) 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbOpen(p1.w, p2.s, p3.s, p4.s) 
value.l = CallFunction(#base100dll,"edbOpen",p1,p2,p3,p4) 
ProcedureReturn Value 
EndProcedure 


Procedure.l edbClose(p1.w) 
value.l = CallFunction(#base100dll,"edbClose",p1) 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbUse(p1.w) 
value.l = CallFunction(#base100dll,"edbUse",p1) 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbDelete(p1.l) 
value.l = CallFunction(#base100dll,"edbDelete",p1) 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbUnDelete(p1.l) 
value.l = CallFunction(#base100dll,"edbUnDelete",p1) 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbDeleteForm(p1.l, p2.l) 
value.l = CallFunction(#base100dll,"edbDeleteForm",p1,p2) 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbUnDeleteForm(p1.l, p2.l) 
value.l = CallFunction(#base100dll,"edbUnDeleteForm",p1,p2) 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbAppend() 
value.l = CallFunction(#base100dll,"edbAppend") 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbPut(p1.s, p2.s) 
value.l = CallFunction(#base100dll,"edbPut",p1,p2) 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbPutIDX(p1.w, p2.s) 
value.l = CallFunction(#base100dll,"edbPutIDX",p1,p2) 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbWriteRecord(p1.l) 
value.l = CallFunction(#base100dll,"edbWriteRecord",p1) 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbReadRecord(p1.l) 
value.l = CallFunction(#base100dll,"edbReadRecord",p1) 
ProcedureReturn Value 
EndProcedure 

Procedure.s edbGet(p1.s) 
p2.w = CallFunction(#base100dll,"edbGetIndexLen",p1) 
*smem = GlobalAlloc_(0, p2.w) 
res.b = CallFunction(#base100dll,"edbGet",p1,*smem) 
Value.s = PeekS(*smem) 
GlobalFree_(*smem) 
ProcedureReturn Value.s 
EndProcedure 

Procedure.s edbGetIDX(p1.w) 
p2.w = CallFunction(#base100dll,"edbGetIndexLenIDX",p1) 
*smem = GlobalAlloc_(0, p2.w) 
res.b = CallFunction(#base100dll,"edbGetIDX",p1,*smem) 
Value.s = PeekS(*smem) 
GlobalFree_(*smem) 
ProcedureReturn Value.s 
EndProcedure 

Procedure.l edbGetIndexLen(p1.s) 
value.l = CallFunction(#base100dll,"edbGetIndexLen",p1) 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbGetIndexLenIDX(p1.w) 
value.l = CallFunction(#base100dll,"edbGetIndexLenIDX",p1) 
ProcedureReturn Value 
EndProcedure 

Procedure.s edbGetInfo(p1.s) 
*smem = GlobalAlloc_(0, 8) 
res.b = CallFunction(#base100dll,"edbGetInfo",p1,*smem) 
Value.s = PeekS(*smem) 
GlobalFree_(*smem) 
ProcedureReturn Value.s 
EndProcedure 

Procedure.l edbSearch(p1.s, p2.s, p3.b, p4.l, p5.l) 
value.l = CallFunction(#base100dll,"edbSearch",p1,p2,p3,p4,p5) 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbGO(p1.s) 
value.l = CallFunction(#base100dll,"edbGO",p1) 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbLock(p1.l) 
value.l = CallFunction(#base100dll,"edbLock",p1) 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbUnLock(p1.l) 
value.l = CallFunction(#base100dll,"edbUnLock",p1) 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbLockForm(p1.l, p2.l) 
value.l = CallFunction(#base100dll,"edbLockForm",p1,p2) 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbUnLockForm(p1.l, p2.l) 
value.l = CallFunction(#base100dll,"edbUnLockForm",p1,p2) 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbWriteProtect(p1.l, p2.b) 
value.l = CallFunction(#base100dll,"edbWriteProtect",p1,p2) 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbWriteProtectForm(p1.l, p2.l, p3.b) 
value.l = CallFunction(#base100dll,"edbWriteProtectForm",p1,p2,p3) 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbKillCompare() 
value.l = CallFunction(#base100dll,"edbKillCompare") 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbGetLastUpdate() 
value.l = CallFunction(#base100dll,"edbGetLastUpdate") 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbSetLastUpdate() 
value.l = CallFunction(#base100dll,"edbSetLastUpdate") 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbCreate(p1.s, p2.s, p3.s, p4.s) 
value.l = CallFunction(#base100dll,"edbCreate",p1,p2,p3,p4) 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbCreateNulldb(p1.s, p2.s, p3.s) 
value.l = CallFunction(#base100dll,"edbCreateNulldb",p1,p2,p3) 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbCreateAddField(p1.s) 
value.l = CallFunction(#base100dll,"edbCreateAddField",p1) 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbCreateDelField(p1.s) 
value.l = CallFunction(#base100dll,"edbCreateDelField",p1) 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbGetRecord() 
value.l = CallFunction(#base100dll,"edbGetRecord") 
ProcedureReturn Value 
EndProcedure 

Procedure.l edbGetMaxRecord() 
value.l = CallFunction(#base100dll,"edbGetMaxRecord") 
ProcedureReturn Value 
EndProcedure 

;ermittelt den aktuellen Pfad vom Programm 
Procedure.s GetPath() 
datei$ = Space(255) 
GetCurrentDirectory_(255,@datei$) 
ProcedureReturn Trim(datei$) + "\" 
EndProcedure 

; ExecutableFormat=Windows
; FirstLine=1
; EOF