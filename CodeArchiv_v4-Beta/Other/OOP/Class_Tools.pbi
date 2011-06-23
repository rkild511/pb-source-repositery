; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3896&highlight=
; Author: helpy (updated for PB 4.00 by Andre)
; Date: 05. March 2004
; OS: Windows
; Demo: No


; Ich habe auf der Basis von Danilos OOP-Beispiel versucht eine Art Template
; für die Anwendung von Objekten in PB zu schreiben. 

; Hier die allgemeinen Funktionen in einer eigenen Include-Datei: Code: 

; Dateiname: class_tools.pbi 

;/ Funktionen für Erzeugung/Verwaltung von Klassen 
#HEAP_ZERO_MEMORY = $00000008 

; Basis-Klasse für Objekte mit Pointer auf VTable und auf die Datenstruktur 
Structure CLASS_OBJ_BASE 
  VTable.l 
  ObjData.l 
EndStructure 

Procedure CLASS__GetHeap() 
  !MOV dword  EAX ,[PB_MemoryBase] 
  !MOV dword [ESP], EAX 
  ProcedureReturn Heap 
EndProcedure 

Procedure CLASS__GetDataPointer(*obj.CLASS_OBJ_BASE) 
  ProcedureReturn *obj\ObjData 
EndProcedure 

; Speicher für Objekte allokieren und initialisieren 
Procedure.l CLASS__CreateObject(SizeOfObject.l, SizeOfData.l, FunctionOffset.l) 
  Protected *object.CLASS_OBJ_BASE 
  Protected *ObjData.l 
  
  ; Speicher für Objekt-Struktur allokieren 
  *object = HeapAlloc_(CLASS__GetHeap(),#HEAP_ZERO_MEMORY,SizeOfObject) 
  If *object=0: ProcedureReturn 0: EndIf 
  
  ; Speicher für Daten-Struktur allokieren 
  *ObjData = HeapAlloc_(CLASS__GetHeap(),#HEAP_ZERO_MEMORY,SizeOfData) 
  If *ObjData=0: HeapFree_(CLASS__GetHeap(),0,*object) : ProcedureReturn 0: EndIf 
  
  *object\VTable  = *object + FunctionOffset 
  *object\ObjData = *ObjData 
  ProcedureReturn *object 
EndProcedure 

Procedure CLASS__AddFunction(*obj.CLASS_OBJ_BASE, SizeOfInterface.l, FunctionOffset.l, *NewFunction.l) 
  Protected xFunction, blnOverflow, *FunctionTable.LONG 
  blnOverflow = #True 
  *FunctionTable = *obj + FunctionOffset 
  For xFunction = 0 To SizeOfInterface-1 
    If *FunctionTable\l = 0 
      *FunctionTable\l = *NewFunction 
      blnOverflow = #False 
      Break 
    EndIf 
    *FunctionTable + SizeOf(LONG) 
  Next 
  If blnOverflow 
    MessageRequester("CLASS Cunstructor", "Size of the Function table is too small!") 
    End -1 
  EndIf 
EndProcedure 

Procedure CLASS__Release(*obj.CLASS_OBJ_BASE) 
  If HeapFree_(CLASS__GetHeap(),0,CLASS__GetDataPointer(*obj)) 
    If HeapFree_(CLASS__GetHeap(),0,*obj) 
      ProcedureReturn #True 
    EndIf 
  EndIf 
  ProcedureReturn #False 
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -