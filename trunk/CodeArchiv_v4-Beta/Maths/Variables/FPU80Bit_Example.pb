; German forum: http://www.purebasic.fr/german/viewtopic.php?t=9638&highlight=
; Author: Helle
; Date: 09. September 2006
; OS: Windows
; Demo: Yes

; Using of the 80 bit FPU - version with complete display and small example (calculation of the globe surface).
; Nutzung der 80 Bit FPU - Version mit kompletter Anzeige und kleinem Beispiel (Berechnung der Erdoberfläche). 

;-----------------------------------------------------------------------
;Rechnen mit 80-Bit-Float (das was die FPU hergibt) 
;Dazu: Konvertierung von 80-Bit-Float-Zahlen (Hex) in einen PB-String 
;Aufbau der 80-Bit: Bit  79    : Vorzeichen s, gesetzt = Minus 
;                   Bits 78-64 : Exponent e        
;                   Bit  63    : Kennung i      
;                   Bits 62-0  : Mantisse m 
;0, wenn i=0 und e=0 und m=0 
;z=(-1)^s*(i.m)*2^(e-16383) 
;"Helle" Klaus Helbing, 09.09.2006, PB4.0 
; 
;Da es in PB (noch) keine 10-Byte-Variablen gibt wird hier mit Zeigern auf die eigentlichen 
;Variablen-Adressen gearbeitet. ZW4 z.B. zeigt auf die Adresse, ab der das TWord W4 im 
;von PB reservierten Speicher liegt. ZW4 zeigt also nicht auf die FAsm-Variable W4! Die wird 
;z.B. zur einfachen Wert-Belegung benötigt. 
;ZW4 usw. werden global im PB-Code definiert, W4 usw. werden in der data-section (unten) 
;definiert, wenn sie mit einen Startwert belegt werden sollen. 

Global X1.b 
Global MH.l             ;Mantisse High 
Global ML.l             ;Mantisse Low 
Global MLL.l            ;Mantisse Low Low (für Exponent <0) 
Global Convert$ 
Global Memory.l 
Global Convert.l        ;Memory-Zeiger für Konvertierung 80-Bit-Float zu Dezimal 
Global Dummyt1.l        ;Parameter für 80-Bit-Operationen 
Global Dummyt2.l 
Global Dummyt3.l 
Global X4.l 
Global Nachkomma.l      ;begrenzt die Ziffern-Anzahl 
Global Vorkomma.q       ;nimmt die Vorkomma-Ziffern auf 

;-------- frei wählbare Variablen-Namen, aber Werte wie hier gezeigt 
;hier sind alle verwendeten Variablen (genauer: Zeiger darauf) zu deklarieren 
;Namen sind wie üblich frei wählbar, siehe Rechenbeispiel unten 
Global ZPI.l=128        ;sind Zeiger in Memory, Aus Alignment-Gründen 16 Bytes (benötigt 
Global ZW4.l=144        ;werden ja nur 10) 
Global ZE1.l=160        
Global ZE2.l=176 
Global ZRE.l=192 
Global ZOE.l=208 

;usw. für weitere Variablen 

;-------- Programm-Beginn 
Memory = AllocateMemory(1000)     ;die ersten 128 Bytes für Procedure FPUtoDec. Wert anpassen! 

;-------- Variablen mit Startwert initialisieren (wenn benötigt) ----  
  !mov esi,[v_Memory] 
  !fninit 

  !mov edi,[v_ZW4]      ;über Zeiger ZW4 den Wert von W4 einlesen 
  !fld [W4] 
  !fstp tword[esi+edi]  ;schreibt den Wert des FAsm-TWords W4 der FAsm-Data-Section in das von PB 
                        ;bereitgestellte Memory    
  !mov edi,[v_ZRE] 
  !fld [RE] 
  !fstp tword[esi+edi] 

;-------------------------------------------------------------------- 

Procedure FPUtoDec(Convert) 
;- Dient nur zur Bildschirm-Ausgabe, hat mit Berechnungen nichts zu tun! 
 Convert$="" 
  !mov [v_Nachkomma],22 
  !mov esi,[v_Memory] 

;-------- Clear Memory 128 Byte komplett! Nicht nur Summenwerte! 
  !mov ecx,32 
  !xor eax,eax 
  !mov ebx,eax 
CLMEM:  
  !mov [esi+ebx],eax 
  !add ebx,4 
  !dec ecx 
  !jnz l_clmem 
  
  !mov edi,[esp+4]      ;Adresse des zu konvertierenden Wertes einlesen 
  
;-------- Vorzeichen und Exponent 
  !mov cx,[esi+edi+8]   ;Vorzeichen und Exponent            
  !and cx,cx            ;Test, ob MSB (Bit15) gesetzt ist 
  !jns l_w00            ;nein, Vorzeichen ist plus 
  !push ecx 
 Convert$=Convert$+"-" 
  !pop ecx 
  !inc [v_Nachkomma] 
  !and cx,7fffh         ;Vorzeichen-Bit löschen 
W00:  
  !sub cx,16383         ;Bias ("Versatz") subtrahieren, um "echten" 
                        ;Exponenten (auf Zweier-Basis) zu erhalten 
  !cmp cx,64 
  !jl l_egut 
  !cmp cx,-64 
  !jg l_egut  

;------------------------------------------------ 
MessageRequester("Fehler!","Ergebnis ausserhalb des Darstellungsbereiches!") 

End 
;------------------------------------------------ 

;-------- Die 64-Bit-Mantisse einlesen  
EGUT: 
  !mov ebx,[esi+edi] 
  !mov [v_ML],ebx       ;Mantisse Low-Anteil 
  !mov eax,[esi+edi+4] 
  !mov [v_MH],eax       ;Mantisse High-Anteil 

;-------- Auswertung  
;-------- Test,ob Exponent = -16383, d.h. von FPU als Null zurückgegeben 
  !cmp cx,-16383        ;Exponent 
  !jne l_w01 
  !or eax,eax           ;MH  da der Sinn nicht die Exponential-Darstellung ist könnte auch hier abgebrochen werden 
  !jnz l_w01            ;d.h. Wert auch Null  
  !cmp [v_ML],0 
  !jnz l_w01 
 Convert$="0.0"         ;Ergebnis ist Null 
  !jmp l_w9             ;Ende 
;------------------------------------------------ 

W01: 
  !and cx,cx 
  !jns l_wnn            ;Exponent nicht negativ 

;-------- Exponent <0 
  !pushad 
Convert$=Convert$+"0." 
  !popad 
  !cmp cx,-1 
  !jne l_w06 
  !mov byte[esi+65],5 
  !jmp l_w03            ;Edit: Dieser Sprung war verlustig gegangen! 9.9.2006    
W06: 
  !neg cx 

;-------- Versuch, eine vernünftige Ziffernanzahl für die Darstellung zu bestimmen 
  !push ecx 
  !mov edi,ecx 
  !bsr edx,ecx 
  !mov ecx,edx 
  !shr edi,cl 
  !dec cl 
  !shl edi,cl 
  !pop ecx 
  !dec edi 

  !add [v_Nachkomma],edi 

;------------------------ 
  !dec cx 
  !xor edx,edx 
W07: 
  !shr edx,1 
  !shr ebx,1 
  !jnc l_w010 
  !or edi,80000000h 
W010: 
  !shr eax,1 
  !jnc l_w09 
  !or ebx,80000000h 
W09: 
  !dec cx 
  !jnz l_w07 

  !mov [v_MH],eax 
  !mov [v_ML],ebx 
  !mov [v_MLL],edx 

  !jmp l_w10 

;-------- Exponent >=0 
WNN:  
  !xor edx,edx 
  !mov edi,edx 
W04: 
  !shl edi,1 
  !shl edx,1 
  !adc edi,0  
  !shl eax,1 
  !adc edx,0 
W05:  
  !shl ebx,1 
  !adc eax,0 
  !dec cx 
  !jns l_w04 

  !mov [v_MH],eax 
  !mov [v_ML],ebx 

  !mov dword[v_Vorkomma],edx 
  !mov dword[v_Vorkomma+4],edi 
  
  !and eax,eax 
  !jns l_w02 
  !mov byte[esi+65],5 
W02: 
Convert$=Convert$+StrU(Vorkomma,4)+"." 

W03:                    ;Einsprung von neg.Exponent    
 X4=Len(Convert$) 
  !mov eax,[v_X4] 
  !sub [v_Nachkomma],eax 
W10: 
  !mov byte[esi+1],5    ;Startwert für Mantissenberechnung (0.5 für 2^-1) 
  
;-------- Berechnung des Mantissen-Wertes und Darstellung im Dezimal-Format 
;- Als Zahlenwerte werden ungepackte BCD´s verwendet (1 Byte = eine Dezimal-Ziffer) 
;- Die dezimale Division durch 2 wird als Addition mit Stellenverschiebung nach rechts realisiert 
  !mov edx,1           ;zeigt auf die 5 als Startwert 
W1: 
  !xor ah,ah 
  !mov edi,edx 
W2: 
  !mov ecx,4 
  !mov al,[esi+edi] 
  !mov bl,al 
  !add al,ah 
  !xor ah,ah 
W3:  
  !add al,bl 
  !aaa                  ;korrigiert bei Wert grösser 9 al und inkrementiert dann ah 
  !dec ecx 
  !jnz l_w3 
  !mov [esi+edi+1],al 
  !dec edi 
  !jnz l_w2 
  !mov [esi+edi+1],ah   ;im Bereich von 1-63 steht der jeweilige (2^minus n) Wert 
;-------- Überprüfung, ob Wert zuaddiert werden soll 
  !mov eax,[v_MH]       ;Mantisse High-Anteil 
  !shl eax,1 

  !mov ebx,[v_ML] 
  !shl ebx,1 
  !adc eax,0 

  !mov ecx,[v_MLL] 
  !shl ecx,1 
  !adc ebx,0 
  
  !mov [v_MLL],ecx 
  !mov [v_ML],ebx 
  !mov [v_MH],eax 
  
  !and eax,eax 
  !jns l_w5 

  !xor ah,ah 
  !mov edi,63           ;lässt sich auch noch verfeinern 
W4:  
  !mov bl,[esi+edi] 
  !mov al,[esi+edi+64] 
  !add al,bl 
  !aaa 
  !mov [esi+edi+64],al 
  !add [esi+edi+63],ah 
  !xor ah,ah 
  !dec edi 
  !jnz l_w4 
W5: 
  !inc edx 
  !cmp edx,64 
  !jb l_w1 
    
;-------- Ziffern für Ausgabe in String schreiben 
AUSGABE: 
  !mov edi,1            ;um die "Hilfsnull" zu überspringen 
W8: 
  !mov al,[esi+edi+64]  ;Summe 
  !mov [v_X1],al 
 Convert$=Convert$+Str(X1) 
  !inc edi 
  !cmp edi,[v_Nachkomma] 
  !jb l_w8 

W9:                     ;Einsprung für alles Null    
EndProcedure 
;-------- 

;-------- Addition ---------- 
Procedure Addt(Dummyt1,Dummyt2,Dummyt3) 
  !mov esi,[v_Memory] 
  !fninit                        
  !mov edi,[esp+4] 
  !fld tword[esi+edi]            
  !mov edi,[esp+8]  
  !fld tword[esi+edi]  
  !faddp st1,st0 
  !mov edi,[esp+12] 
  !fstp tword[esi+edi]  ;Ergebnis 
EndProcedure 
;---------------------------- 

;-------- Cosinus ----------- 
Procedure Cost(Dummyt1,Dummyt2) 
  !mov esi,[v_Memory] 
  !fninit                        
  !mov edi,[esp+4]  
  !fld tword[esi+edi]  
  !fcos 
  !mov edi,[esp+8] 
  !fstp tword[esi+edi]  ;Ergebnis 
EndProcedure 
;---------------------------- 

;-------- Division ---------- 
Procedure Divt(Dummyt1,Dummyt2,Dummyt3) 
  !mov esi,[v_Memory] 
  !fninit                        
  !mov edi,[esp+4] 
  !fld tword[esi+edi]            
  !mov edi,[esp+8]  
  !fld tword[esi+edi]  
  !fdivp st1,st0 
  !mov edi,[esp+12] 
  !fstp tword[esi+edi]  ;Ergebnis 
EndProcedure 
;---------------------------- 

;-------- Multiplikation ---- 
Procedure Mult(Dummyt1,Dummyt2,Dummyt3) 
  !mov esi,[v_Memory] 
  !fninit                        
  !mov edi,[esp+4] 
  !fld tword[esi+edi]            
  !mov edi,[esp+8]    
  !fld tword[esi+edi]  
  !fmulp st1,st0 
  !mov edi,[esp+12] 
  !fstp tword[esi+edi]  ;Ergebnis 
EndProcedure 
;---------------------------- 

;-------- Pi ---------------- 
Procedure Pit(Dummyt1) 
  !mov esi,[v_Memory] 
  !fninit                        
  !fldpi 
  !mov edi,[esp+4] 
  !fstp tword[esi+edi]  ;Ergebnis 
EndProcedure 
;---------------------------- 

;-------- Quadratwurzel ----- 
Procedure Sqrtt(Dummyt1,Dummyt2) 
  !mov esi,[v_Memory] 
  !fninit                        
  !mov edi,[esp+4]  
  !fld tword[esi+edi]  
  !fsqrt 
  !mov edi,[esp+8] 
  !fstp tword[esi+edi]  ;Ergebnis 
EndProcedure 
;---------------------------- 

;-------- Sinus ------------- 
Procedure Sint(Dummyt1,Dummyt2) 
  !mov esi,[v_Memory] 
  !fninit                        
  !mov edi,[esp+4]  
  !fld tword[esi+edi]  
  !fsin 
  !mov edi,[esp+8] 
  !fstp tword[esi+edi]  ;Ergebnis 
EndProcedure 
;---------------------------- 

;-------- Subtraktion ------- 
Procedure Subt(Dummyt1,Dummyt2,Dummyt3) 
  !mov esi,[v_Memory] 
  !fninit                        
  !mov edi,[esp+4] 
  !fld tword[esi+edi]            
  !mov edi,[esp+8]  
  !fld tword[esi+edi]  
  !fsubp st1,st0 
  !mov edi,[esp+12] 
  !fstp tword[esi+edi]  ;Ergebnis 
EndProcedure 
;---------------------------- 

;---------------------------- 
;usw.usf. 
;------------------------------------------------------------------------- 

;-------- Rechenbeispiel 
;Es soll die Oberfläche der Erde in m² berechnet werden 
;Kugeloberfläche = 4*Pi*R*R 

Pit(ZPI)                ;Wert von Pi laden 
Mult(ZW4,ZPI,ZE1)       ;4*Pi in E1 speichern 
Mult(ZRE,ZRE,ZE2)       ;Re*Re in E2 speichern 
Mult(ZE1,ZE2,ZOE)       ;E1 mit E2 multipliziert ergibt das Ergebnis 

FPUtoDec(ZOE)           ;liefert für die Bildschirm-Ausgabe das Ergebnis als String (Convert$) 
MessageRequester("80-Bit Berechnung","Erdoberfläche in m² :  " + Convert$) 


End 

;-------- hier sind einfach 80-Bit-Variablen mit Werten zu belegen 
!section '.data' Data readable writeable 

!W4 dt 4.0              ;W4 bekommt Wert 4.0 
!RE dt 6371007.176      ;Radius der Erde in Meter für flächengleiche Kugel (GRS 80-Ellipsoid) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP