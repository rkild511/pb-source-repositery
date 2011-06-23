; German forum: http://www.purebasic.fr/german/viewtopic.php?t=9638&highlight=
; Author: Helle
; Date: 20. August 2006
; OS: Windows
; Demo: Yes

;Beispiel für Nutzung der 80-Bit-Rechengenauigkeit der FPU. 
;Zeigt auch den Umgang mit FAsm´s tword. 
;Das Rechenergebnis wird hier als gepackte BCD-Zahl in den 
;Speicher geschrieben. 
;Brauchbar z.B. wenn bei Eingabe von Gleitkomma-Zahlen als 
;Ergebnis eine (genaue, max.18-stellige) Ganzzahl o.K.ist. 
;Auf Sicherung der Umgebung wurde für diese Demo verzichtet!!! 
;"Helle" Klaus Helbing 20.08.2006  PB4.0 

Global x.b 

Memory.l = AllocateMemory(20)     ;20 Bytes für 2 twords 
  !mov esi,[v_Memory] 

  !Macro writetw value            ;schreibt ein tword in den Speicher 
  !{virtual at 0                  ;virtual ist eine FAsm-Direktive! 
  !  dt value 
  !  local lo, mi, hi 
  !  load lo dword from 0 
  !  load mi dword from 4 
  !  load hi word from 8 
  ! End virtual 
  !mov dword[esi],lo 
  !mov dword[esi+4],mi 
  !mov word[esi+8],hi} 
    
  !writetw 123456789012345678.0   ;1.Wert übergeben 
  !add esi,10            
  !writetw 234567890123456789.0   ;2.Wert 
                                  ;es können auch Nachkomma-Stellen 
                                  ;angegeben werden! Das Ergebnis wird 
                                  ;ganzzahlig gerundet 
  !fninit                        
  !fld tword[esi-10] 
  !fld tword[esi] 
  !faddp                          ;oder andere Berechnungen, hier Addition 
  !fbstp tword[esi]               ;Abspeicherung als gepackte BCD-Zahl 
                                  ;ergibt eine Ganzzahl mit 18 Stellen 
  !mov edi,8                      ;9 ist Byte für Vorzeichen, hier für 
Noch:                             ;Beispiel uninteressant 
  !mov bl,[esi+edi]               ;die Ziffern auslesen 
  !mov bh,bl 
  !and bh,0f0h 
  !shr bh,4 
  !mov [v_x],bh 
 Z$=Z$+Str(x) 
  !and bl,0fh 
  !mov [v_x],bl  
 Z$=Z$+Str(x)      
  !dec edi 
  !jns l_noch 

MessageRequester("80-Bit-BCD","   123456789012345678.0"+#CRLF$+"+ 234567890123456789.0"+#CRLF$+"= "+Z$+#CRLF$+"Im Gegensatz zu allen anderen Floating-Point-"+#CRLF$+"Berechnungs-Möglichkeiten stimmt hier das Ergebnis!") 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP