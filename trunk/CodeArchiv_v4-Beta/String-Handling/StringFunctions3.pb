; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1380&highlight=
; Author: NicTheQuick (updated for PB3.93 by ts-soft)
; Date: 20. June 2003
; OS: Windows
; Demo: No


; Note: Some of the string functions are not needed anymore, because starting
;       with PB v4 the maximum length of strings is only limited by the memory.


; Same functions as StringFunctions2.pb, but now with improved speed, because
; the heap of PureBasic will be used as memory.

; Die gleichen Funktionen wie StringFunctions2.pb, jetzt aber mit verbesserter
; Geschwindigkeit, da der Heap von PureBasic als Speicherbereich benutzt wird.


#Heap_Zero_Memory = $8 
Procedure.l PbHeap() 
  !MOV EAX, dword [_PB_MemoryBase] 
  ProcedureReturn 
EndProcedure 

;Speichert einen neuen String 
;String.s [in] : Neuer String 
;RETURN : Handle zum String 
Procedure.l mNewString(String.s) 
  Protected hString.l, sString.l, pString.l 
  sString = Len(String) + 1 
  hString = HeapAlloc_(PbHeap(), #Heap_Zero_Memory, sString) 
  CopyMemory(@String, hString, sString) 
  ProcedureReturn hString 
EndProcedure 

;Reserviert einen String mit einer bestimmten Länge 
;Length.l [in] : Länge des zu reservierenden Strings 
;RETURN : Handle zum reservierten String 
Procedure.l mReserveString(Length.l) 
  Protected hString.l 
  hString = HeapAlloc_(PbHeap(), #Heap_Zero_Memory, Length + 1) 
  ProcedureReturn hString 
EndProcedure 

;Ändert einen String 
;hString.l [in] : Handle zum ursprünglichen String 
;String.s [in] : String 
;RETURN : Handle zum String (kann sich ändern) 
Procedure.l mChangeString(hString.l, String.s) 
  Protected sString.l 
  sString = Len(String) + 1 
  shString = HeapSize_(PbHeap(), 0, hString) 
  If sString < shString 
    hString = HeapReAlloc_(PbHeap(), hString, sString, 0) 
  ElseIf sString > shString 
    GlobalFree_(hString) 
    hString = HeapAlloc_(PbHeap(), #Heap_Zero_Memory, sString) 
  EndIf 
  CopyMemory(@String, hString, sString) 
  ProcedureReturn hString 
EndProcedure 

;Kopiert einen String in den anderen 
;hString1.l [in] : Handle zum Quellstring 
;hString2.l [in] : Handle zum Zielstring 
;RETURN : Handle zum Zielstring 
Procedure.l mCopyString(hString1.l, hString2.l) 
  Protected sString1.l, sString2.l 
  sString1 = HeapSize_(PbHeap(), 0, hString1) 
  sString2 = HeapSize_(PbHeap(), 0, hString2) 
  If sString1 < sString2 
    hString2 = HeapReAlloc_(PbHeap(), 0, hString2, sString1) 
  ElseIf sString1 > sString2 
    HeapFree_(PbHeap(), 0, hString2) 
    hString2 = HeapAlloc_(PbHeap(), #Heap_Zero_Memory, sString1) 
  EndIf 
  CopyMemory(hString1, hString2, sString1) 
  ProcedureReturn hString2 
EndProcedure 

;Kopiert einen String in einen neuen 
;hString1.l [in] : Handle zum Quellstring 
;RETURN : Handle zum kopierten String 
Procedure mCopyStringEx(hString1.l) 
  Protected sString1.l, hString2.l 
  sString1 = HeapSize_(PbHeap(), 0, hString1) 
  hString2 = HeapAlloc_(PbHeap(), #Heap_Zero_Memory, sString1) 
  CopyMemory(hString1, hString2, sString1 - 1) 
  ProcedureReturn hString2 
EndProcedure 

;Gibt einen String und den Speicher wieder frei 
;hString.l [in] : Handle zum String 
;RETURN : #NULL, wenn der String erfolgreich gelöscht wurde 
Procedure.l mFreeString(hString.l) 
  ProcedureReturn HeapFree_(PbHeap(), 0, hString) 
EndProcedure 

;Gibt den im Speicher befindlichen String zurück 
;hString.l [in] : Handle zum String 
;RETURN : String 
Procedure.s mValueString(hString.l) 
  Protected String.s 
  If hString 
    String = PeekS(hString) 
    ProcedureReturn String 
  Else 
    ProcedureReturn "" 
  EndIf 
EndProcedure 

;Fügt zwei Strings zu einem neuen String zusammen 
;hString1.l [in] : Handle zum ersten String 
;hString2.l [in] : Handle zum zweiten String 
;RETURN : Handle zum neuen String 
Procedure.l mAddString(hString1.l, hString2.l) 
  Protected sString1.l, sString2.l, hString.l 
  sString1 = HeapSize_(PbHeap(), 0, hString1) 
  sString2 = HeapSize_(PbHeap(), 0, hString2) 
  hString = HeapAlloc_(PbHeap(), #Heap_Zero_Memory, sString1 + sString2 - 1) 
  CopyMemory(hString1, hString, sString1 - 1) 
  CopyMemory(hString2, hString + sString1 -1, sString2) 
  ProcedureReturn hString 
EndProcedure 

;Vergleicht zwei Strings miteinander 
;hString1.l [in] : Handle zum ersten String 
;hString2.l [in] : Handle zum zweiten String 
;RETURN : 0 = ungleich, 1 = gleich 
Procedure.l mCompareString(hString1.l, hString2.l) 
  Protected sString1.l, sString2.l 
  sString1 = HeapSize_(PbHeap(), 0, hString1) 
  sString2 = HeapSize_(PbHeap(), 0, hString2) 
  If sString1 = sString2 
    ProcedureReturn CompareMemory(hString1, hString2, sString1) 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 

;Sucht einen String in einem anderen 
;hString1.l [in] : Handle zum String, in dem gesucht werden soll 
;hString2.l [in] : Handle zum String, der gesucht werden soll 
;Begin.l [in] : Position, ab der gesucht werden soll 
;RETURN : Position des zweiten Strings im ersten 
Procedure.l mFindString(hString1.l, hString2.l, Begin.l) 
  Protected sString1.l, sString2.l, eString1.l, eString2.l 
  Protected *z1.BYTE, *z2.BYTE 
  sString1 = HeapSize_(PbHeap(), 0, hString1) 
  sString2 = HeapSize_(PbHeap(), 0, hString2) 
  If sString2 > sString1 Or sString2 = 0 
    ProcedureReturn 0 
  Else 
    eString1 = hString1 + sString1 - 1 
    eString2 = hString2 + sString2 - 1 
    For *z1 = hString1 + Begin - 1 To hString2 - sString2 
      *z2 = hString2 
      While *z1\b = *z2\b 
        *z1 + 1 
        *z2 + 1 
        If *z2 = eString2 
          ProcedureReturn *z1 - sString2 - hString1 + 2 
        EndIf 
      Wend 
    Next 
  EndIf 
EndProcedure 

;Gibt eine bestimmte Anzahl von Zeichen vom Anfang eines Strings als einen neuen String zurück 
;hString1.l [in] : Handle zum String 
;Length.l [in] : Anzahl der Zeichen 
;RETURN : Handle zum ausgeschnittenen String 
Procedure.l mLeft(hString1.l, Length.l) 
  Protected sString1.l, hString2.l 
  sString1 = HeapSize_(PbHeap(), 0, hString1) 
  If sString1 - 1 < Length 
    Length = sString1 - 1 
  EndIf 
  hString2 = HeapAlloc_(PbHeap(), #Heap_Zero_Memory, Length + 1) 
  CopyMemory(hString1, hString2, Length) 
  ProcedureReturn hString2 
EndProcedure 

;Vergleicht den Anfang des ersten Strings mit einem zweitenm String 
;hString1.l [in] : Handle zum ersten String 
;hString2.l [in] : Handle zum zweiten String 
;RETURN : 0 = ungleich, 1 = gleich 
Procedure.l mLeftCompare(hString1.l, hString2.l) 
  Protected sString1.l, sString2.l 
  sString1 = HeapSize_(PbHeap(), 0, hString1) 
  sString2 = HeapSize_(PbHeap(), 0, hString2) 
  If sString2 > sString1 
    ProcedureReturn #False 
  EndIf 
  ProcedureReturn CompareMemory(hString1, hString2, sString2 - 1) 
EndProcedure 

;Gibt eine bestimmte Anzahl von Zeichen vom Ende eines Strings als einen neuen String zurück 
;hString1.l [in] : Handle zum String 
;Length.l [in] : Anzahl der Zeichen 
;RETURN : Handle zum ausgeschnittenen String 
Procedure.l mRight(hString1.l, Length.l) 
  Protected sString1.l, hString2.l 
  sString1 = HeapSize_(PbHeap(), 0, hString1) 
  If sString1 - 1 < Length 
    Length = sString1 - 1 
  EndIf 
  hString2 = HeapAlloc_(PbHeap(), #Heap_Zero_Memory, Length + 1) 
  CopyMemory(hString1 + sString1 - Length - 1, hString2, Length) 
  ProcedureReturn hString2 
EndProcedure 

;Vergleicht das Ende des ersten Strings mit einem zweiten String 
;hString1.l [in] : Handle zum ersten String 
;hString2.l [in] : Handle zum zweiten String 
;RETURN : 0 = ungleich, 1 = gleich 
Procedure.l mRightCompare(hString1.l, hString2.l) 
  Protected sString1.l, sString2.l 
  sString1 = HeapSize_(PbHeap(), 0, hString1) 
  sString2 = HeapSize_(PbHeap(), 0, hString2) 
  If sString2 > sString1 
    ProcedureReturn #False 
  EndIf 
  ProcedureReturn CompareMemory(hString1 + sString1 - sString2, hString2, sString2) 
EndProcedure 

;Gibt eine bestimmte Anzahl von Zeichen aus der Mitte eines Strings als einen neuen String zurück 
;hString1.l [in] : Handle zum String 
;Position.l [in] : Position im String 
;Length.l [in] : Anzahl der Zeichen 
;RETURN : Handle zum ausgeschnittenen String 
Procedure.l mMid(hString1.l, Position.l, Length.l) 
  Protected sString1.l, hString2.l 
  sString1 = HeapSize_(PbHeap(), 0, hString1) 
  If sString1 < Length + Position 
    If sString1 - 1 < Position 
      hString2 = HeapAlloc_(PbHeap(), #Heap_Zero_Memory, 1) 
      ProcedureReturn hString2 
    EndIf 
    Length = sString1 - Position 
  EndIf 
  hString2 = HeapAlloc_(PbHeap(), #Heap_Zero_Memory, Length + 1) 
  CopyMemory(hString1 + Position - 1, hString2, Length) 
  ProcedureReturn hString2 
EndProcedure 

;Vergleicht die Mitte des ersten Strings mit einem zweiten String 
;hString1.l [in] : Handle zum ersten String 
;Position.l [in] : Position im ersten String 
;hString2.l [in] : Handle zum zweiten String 
;RETURN : 0 = ungleich, 1 = gleich 
Procedure.l mMidCompare(hString1.l, Position.l, hString2.l) 
  Protected sString1.l, sString2.l 
  sString1 = HeapSize_(PbHeap(), 0, hString1) 
  sString2 = HeapSize_(PbHeap(), 0, hString2) 
  If sString2 + Position - 1 > sString1 
    ProcedureReturn #False 
  EndIf 
  ProcedureReturn CompareMemory(hString1 + Position - 1, hString2, sString2 - 1) 
EndProcedure 

;Gibt alle Zeichen ab einer bestimmten Position im String als einen neuen String zurück 
;hString1.l [in] : Handle zum String 
;Position.l [in] : Position im String 
;RETURN : Handle zum ausgeschnittenen String 
Procedure.l mMidEnd(hString1.l, Position.l) 
  Protected sString1.l, hString2.l 
  sString1.l = HeapSize_(PbHeap(), 0, hString1) 
  If sString1 - 1 < Position 
    hString2 = HeapAlloc_(PbHeap(), #Heap_Zero_Memory, 1) 
    ProcedureReturn hString2 
  EndIf 
  hString2 = HeapAlloc_(PbHeap(), #Heap_Zero_Memory, sString1 - Position + 1) 
  CopyMemory(hString1 + Position - 1, hString2, sString1 - Position) 
  ProcedureReturn hString2 
EndProcedure 

;Gibt die Länge eines Strings zurück 
;hString.l [in] : Handle zum String 
;RETURN : Länge des Strings 
Procedure.l mLen(hString.l) 
  Protected sString.l 
  sString = HeapSize_(PbHeap(), 0, hString) 
  ProcedureReturn sString - 1 
EndProcedure 

;Gibt die Länge eines Strings bis zum Nullbyte zurück 
;hString.l [in] : Handle zum String 
;RETURN : Länge bis zum Nullbyte 
Procedure.l mLenZero(hString.l) 
  Protected *z.BYTE 
  *z = hString 
  While *z\b : *z + 1 : Wend 
  ProcedureReturn *z - hString 
EndProcedure 

;Gibt den ASCII-Code des ersten Zeichens eines Strings zurück 
;hString.l [in] : Handle zum String 
;RETURN : ASCII-Code des ersten Zeichens 
Procedure.l mAsc(hString.l) 
  Protected sString.l 
  sString = HeapSize_(PbHeap(), 0, hString) 
  If sString - 1 
    ProcedureReturn PeekB(hString) & $FF 
  EndIf 
  ProcedureReturn 0 
EndProcedure 

;Gibt den ASCII-Code eines bestimmten Zeichens im String zurück 
;hString.l [in] : Handle zum String 
;Position.l [in] : Zeichen im String 
;RETURN : ASCII-Code des Zeichens 
Procedure.l mAscPosition(hString.l, Position.l) 
  Protected sString.l 
  sString = HeapSize_(PbHeap(), 0, hString) 
  If Position > sString - 1 
    ProcedureReturn 0 
  EndIf 
  ProcedureReturn PeekB(hString + Position - 1) & $FF 
EndProcedure 

;Erstellt einen String mit einem Zeichen, das einen bestimmten ASCII-Codo hat 
;ASCII.l [in] : ASCII-Code 
;RETURN : Handle zum neuen String 
Procedure.l mChr(ASCII.l) 
  Protected hString.l 
  hString = HeapAlloc_(PbHeap(), #Heap_Zero_Memory, 2) 
  PokeB(hString, ASCII) 
  ProcedureReturn hString 
EndProcedure 

;Procedure um einen Speicherbereich zu füllen von Stefan Moebius (dt. Forum) 
Procedure MemLFill(Adr, AnzBytes, dword.l) 
  !CLD 
  !MOV Edi,[Esp+0] 
  !MOV EAX,[Esp+8] 
  !MOV Ecx,[Esp+4] 
  !SHR Ecx,2 
  !REP STOSD 
EndProcedure 

;Erstellt einen String mit einer bestimmten Anzahl an Leerzeichen 
;Length.l [in] : Anzahl an Leerzeichen 
;RETURN : Handle zum neuen String 
Procedure.l mSpace(Length.l) 
  Protected hString.l, *z.BYTE 
  hString = HeapAlloc_(PbHeap(), #Heap_Zero_Memory, Length + 1) 
  MemLFill(hString, Length, $20202020) 
  ProcedureReturn hString 
EndProcedure 

;Vergleicht den ASCII-Code eines bestimmten Zeichens mit dem gefragten 
;hString.l [in] : Handle zum String 
;Position.l [in] : Position im String 
;ASCII.l [in] : Zu vergleichender ASCII-Code 
;RETURN : 0 = ungleich, 1 = gleich 
Procedure.l mCompareChar(hString.l, Position.l, ASCII.l) 
  Protected sString.l, *z.BYTE 
  sString = HeapSize_(PbHeap(), 0, hString) 
  If sString - 1 < Position 
    ProcedureReturn #False 
  EndIf 
  *z = hString + Position - 1 
  If *z\b & $FF = ASCII 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 

;Gibt ein durch ein Trennzeichen getrenntes Feld in einem String an einer bestimmten Position 
;in einem neuen String zurück 
;hString1.l [in] : Handle zum Ausgangsstring 
;Index.l [in] : Feldindex 
;ASCII.l [in] : Trennzeichen als ASCII-Code 
;RETURN : Handle zum ausgeschnittenen String 
Procedure.l mStringField(hString1.l, Index.l, ASCII.l) 
  Protected aktIndex.l, *z.BYTE, Begin.l 
  Protected hString2.l, _Continue.l 
  aktIndex = 1 
  *z = hString1 
  Begin = hString1 - 1 
  _Continue = #True 
  While _Continue 
    If *z\b & $FF = ASCII 
      Begin = *z 
      aktIndex + 1 
    EndIf 
    *z + 1 
    If aktIndex = Index 
      If *z\b & $FF = ASCII Or *z\b = 0 
        _Continue = #False 
      EndIf 
     Else 
       If *z\b = 0 
         hString2 = HeapAlloc_(PbHeap(), #Heap_Zero_Memory, 1) 
         ProcedureReturn hString2 
       EndIf 
    EndIf 
  Wend 
  hString2 = HeapAlloc_(PbHeap(), #Heap_Zero_Memory, *z - Begin - 1) 
  CopyMemory(Begin + 1, hString2, *z - Begin - 1) 
  ProcedureReturn hString2 
EndProcedure 

;Löscht die Leerzeichen vom Anfang und vom Ende des Strings und gibt das Handle 
;des Strings zurück (dabei wird das Handle zum eingegangenen String ungültig) 
;hString1.l [in] : String, der getrimmt werden soll 
;RETURN : Handle zum getrimmten String 
Procedure.l mTrim(hString1.l) 
  Protected sString1.l, *z.BYTE, Begin.l, Ends.l 
  Protected hString2 
  sString1 = HeapSize_(PbHeap(), 0, hString1) 
  *z = hString1 
  While *z\b = 32 And *z\b 
    *z + 1 
  Wend 
  Begin = *z - hString1 
  *z = hString1 + sString1 - 2 
  While *z\b = 32 And *z >= hString1 
    *z - 1 
  Wend 
  Ends = hString1 + sString1 - 2 - *z 
  If Begin = Ends 
    If Begin = sString1 - 1 
      Ends = 0 
    EndIf 
  EndIf 
  hString2 = HeapAlloc_(PbHeap(), #Heap_Zero_Memory, sString1 - (Begin + Ends)) 
  HeapFree_(PbHeap(), 0, hString1) 
  CopyMemory(hString1 + Begin, hString2, sString1 - (Begin + Ends)) 
  ProcedureReturn hString2 
EndProcedure 

;Setzt hinter den angegebenen String soviele Zeichen mit einem bestimmten ASCII-Code, 
;sodass die gewünschte Länge erreicht ist (das Handle des eingegangenen Strings wird 
;ungültig) 
;hString1.l [in] : Handle zum String 
;Length.l [in] : Länge, die aufgefüllt werden muss 
;ASCII.l [in] : ASCII-Code für die Zeichen 
;RETURN : Handle zum formatierten String 
Procedure mLSet(hString1.l, Length.l, ASCII.l) 
  Protected sString1.l, *z.BYTE 
  sString1 = HeapSize_(PbHeap(), 0, hString1) 
  If sString1 - 1 > Length 
    hString2 = HeapAlloc_(PbHeap(), #Heap_Zero_Memory, Length + 1) 
    CopyMemory(hString1, hString2, Length) 
    HeapFree_(PbHeap(), 0, hString1) 
    ProcedureReturn hString2 
  Else 
    hString2 = HeapAlloc_(PbHeap(), #Heap_Zero_Memory, Length + 1) 
    CopyMemory(hString1, hString2, sString1 - 1) 
    HeapFree_(PbHeap(), 0, hString1) 
    For *z = hString2 + sString1 - 1 To hString2 + Length - 1 
      *z\b = ASCII 
    Next 
    ProcedureReturn hString2 
  EndIf 
EndProcedure 

;Setzt vor den angegebenen String soviele Zeichen mit einem bestimmten ASCII-Code, 
;sodass die gewünschte Länge erreicht ist (das Handle des eingegangenen Strings wird 
;ungültig) 
;hString1.l [in] : Handle zum String 
;Length.l [in] : Länge, die aufgefüllt werden muss 
;ASCII.l [in] : ASCII-Code für die Zeichen 
;RETURN : Handle zum formatierten String 
Procedure mRSet(hString1.l, Length.l, ASCII.l) 
  Protected sString1.l, *z.BYTE 
  sString1 = HeapSize_(PbHeap(), 0, hString1) 
  If sString1 - 1 > Length 
    hString2 = HeapAlloc_(PbHeap(), #Heap_Zero_Memory, Length + 1) 
    CopyMemory(hString1, hString2, Length) 
    HeapFree_(PbHeap(), 0, hString1) 
    ProcedureReturn hString2 
  Else 
    hString2 = HeapAlloc_(PbHeap(), #Heap_Zero_Memory, Length + 1) 
    CopyMemory(hString1, hString2 + Length - sString1 + 1, sString1 - 1) 
    HeapFree_(PbHeap(), 0, hString1) 
    For *z = hString2 To hString2 + Length - sString1 
      *z\b = ASCII 
    Next 
    ProcedureReturn hString2 
  EndIf 
EndProcedure 

;Setzt an einer bestimmten Position in einem String ein Zeichen 
;hString.l [in] : Handle zum String 
;Position.l [in] : Position des Zeichens im String 
;ASCII.l [in] : ASCII-Code des Zeichens 
;RETURN : #False = Position außerhalb des Bereichs, #True = Zeichen gesetzt 
Procedure mSetChar(hString.l, Position.l, ASCII.l) 
  Protected sString.l, *z.Byte 
  sString = HeapSize_(PbHeap(), 0, hString) 
  If sString - 1 < Position 
    ProcedureReturn #False 
  EndIf 
  *z = hString + Position - 1 
  *z\b = ASCII 
  ProcedureReturn #True 
EndProcedure 

;Sucht das nächste Nullbyte und setzt ein Zeichen an die Stelle, wenn es nicht 
;das letzte Nullbyte im reservierten String ist 
;hString.l [in] : Handle zum String 
;ASCII.l [in] : ASCII-Code des Zeichens 
;RETURN : #False = Letztes Zeichen ist erreicht, #True = Zeichen gesetzt 
Procedure mSetCharEx(hString.l, ASCII.l) 
  Protected *z.Byte, sString.l 
  sString = HeapSize_(PbHeap(), 0, hString) 
  *z = hString + lstrlen_(hString) - 1 
  If *z - hString = sString - 1 
    ProcedureReturn #False 
  EndIf 
  *z\b = ASCII 
  ProcedureReturn #True 
EndProcedure

; Procedure mRemoveString(hString1.l, hString2.l) 
;   Protected sString1.l, sString2.l, Begin.l, Ends.l, Quit.l 
;   sString1 = HeapSize_(PbHeap(), 0, hString1) 
;   sString2 = HeapSize_(PbHeap(), 0, hString2) 
;   If sString2 > sString1 
;     ProcedureReturn #False 
;   EndIf 
;   Repeat 
;     Begin = mFindString(hString1, hString2, Begin + 1) 
;     If Begin 
;     Else 
;        
;     EndIf 
;   Until Quit 
; EndProcedure 
; 
; Procedure mLCase(hString.l) 
; EndProcedure 
; 
; Procedure mUCase(hString.l) 
; EndProcedure 


; *** Thread-safe strings without the 64k limit ***
; Adding second string to first string
;Fügt den zweiten String an den ersten String 
;hString1.l [in] : Handle zum ersten String 
;hString2.l [in] : Handle zum zweiten String 
;RETURN : Handle zum ersten String (changed) 
Procedure.l mAddStringEx(hString1.l, hString2.l) 
  Protected sString1.l, sString2.l, hString.l 
  sString1 = HeapSize_(PbHeap(), 0, hString1) 
  sString2 = HeapSize_(PbHeap(), 0, hString2) 
  hString = HeapAlloc_(PbHeap(), #Heap_Zero_Memory, sString1 + sString2 - 1) 
  CopyMemory(hString1, hString, sString1 - 1) 
  CopyMemory(hString2, hString + sString1 - 1, sString2) 
  HeapFree_(PbHeap(), 0, hString1) 
  ProcedureReturn hString 
EndProcedure


Debug " -- String s1, s2 und s3 --" 
s1 = mNewString("abcdefghabcd") 
s2 = mNewString("abc") 
s3 = mNewString("Heute lernen wir das abc") 
Debug mValueString(s1) 
Debug mValueString(s2) 
Debug mValueString(s3) 

Debug " -- Position von s2 in s1 ab Pos 2 --" 
Debug mFindString(s1, s2, 2) 
Debug " -- Wert an Pos 9 mit Länge 4 in s1 --" 
Debug mValueString(mMid(s1, 9, 4)) 

Debug " (s2 in s4 kopieren)" 
;s4 = mNewString("") 
s4 = mCopyStringEx(s2) 

Debug " -- RSet(s2, 10, 45) --" 
s2 = mRSet(s2, 10, 45) ;45 = "-" 
Debug mValuestring(s2) 

Debug " -- 3.Wort in s3 --" 
Debug mValueString(mStringfield(s3, 3, 32)) 
Debug " -- Ist an Pos 6 in s3 = Leerzeichen? --" 
Debug mCompareChar(s3, 6, 32) ;32 = " " 
Debug " -- Ist an Pos 7 in s3 = L? --" 
Debug mCompareChar(s3, 7, 76) ;76 = "L" 
Debug " -- ASCII-Code an Pos 7 in s3 --" 
Debug mAscPosition(s3, 7) 
Debug " -- Ist rechter Teil von s3 = s4? --" 
Debug mRightCompare(s3, s4) 

Debug " -- s5 = s3 + s1 --" 
s5 = mAddString(s3, s1) 
Debug mValueString(s5) 

Debug " (s6 = 100 Zeichen reserviert)" 
s6 = mReserveString(100) 
Debug " -- Erstes Zeichen mit ASCII-Code 65 in s6 --" 
mSetChar(s6, 1, 65) 
Debug mValueString(s6) 
Debug " -- Zweites Zeichen mit ASCII-Code 98 --" 
mSetChar(s6, 2, 98) 
Debug mValueString(s6) 
Debug " -- Zeichen mit ASCII-Code 67 anhängen --" 
mSetCharEx(s6, 67) 
Debug mValueString(s6) 
Debug " -- Anzahl Zeichen von s6 bis Nullbyte --" 
Debug mLenZero(s6) 
Debug " -- Länge von s6 --" 
Debug mLen(s6)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ------
