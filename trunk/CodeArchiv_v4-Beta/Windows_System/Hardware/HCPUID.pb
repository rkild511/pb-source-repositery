; www.PureArea.net
; Author: Helle
; Date: 22. October 2006
; OS: Windows
; Demo: Yes

; Detecting of several processor characteristics

;- Ermittlung einiger Prozessor-Eigenschaften, "Helle" Klaus Helbing, 22.10.2006, PB4.00

Global mmx.c   = $2d         ;erstmal auf "-" setzen für nicht vorhanden
Global dnow.c  = $2d
Global ednow.c = $2d
Global cmov.c  = $2d
Global sse.c   = $2d
Global sse2.c  = $2d
Global sse3.c  = $2d
Global ssse3.c = $2d

Global Bit0.l  = $1          ;für SSE3
Global Bit9.l  = $200        ;für SSSE3
Global Bit15.l = $8000       ;für CMOVcc
Global Bit21.l = $200000     ;für EFlag
Global Bit23.l = $800000     ;für MMX 
Global Bit25.l = $2000000    ;für SSE
Global Bit26.l = $4000000    ;für SSE2
Global Bit30.l = $40000000   ;für extended 3DNow!
Global Bit31.l = $80000000   ;für 3DNow!

Global Name$   = "Der getestete Prozessor unterstützt :"
Global MMX$    = "MMX :            "
Global DNOW$   = "3DNow! :       "
Global EDNOW$  = "ext3DNow! :  "
Global CMOV$   = "CMOVcc :      "
Global SSE$    = "SSE :             "
Global SSE2$   = "SSE2 :           "
Global SSE3$   = "SSE3 :           "
Global SSSE3$  = "SSSE3 :         "

;-------- Test, ob der CPUID-Befehl überhaupt vom Prozessor verarbeitet werden kann
;-------- ist möglich, wenn Bit21 des EFlag-Registers verändert werden kann
    !pushfd                  ;das EFlag-Register (32-Bit) auf den Stack
    !pop eax                 ;rein in EAX
    !mov edx,eax             ;EAX unverändert lassen
    !xor edx,[v_Bit21]       ;Bit21 kippen 
    !push edx                          
    !popfd                   ;in EFlag schreiben
    !pushfd                  ;wieder auf Stack
    !pop edx
    !push eax                ;der Ordnung halber alten Wert wieder herstellen
    !popfd   
    !cmp eax,edx
    !jne l_iscpuid           ;sind nicht gleich -> CPUID ist möglich

 MessageRequester("Status", "Der getestete Prozessor unterstützt den CPUID-Befehl nicht und somit weder MMX oder SSE !")
End  

IsCPUID:
;------------------------------------------------------------------------------

;-------- Test auf MMX, SSE, SSE2, SSE3 und SSSE3
;-------- vorhanden, wenn im Rückgaberegister EDX bzw. ECX die entsprechenden Bits gesetzt sind
    !mov eax,1h
    !cpuid
    !test edx,[v_Bit23]      ;MMX
    !jz l_nommx
    !mov [v_mmx],2bh         ;"+" für vorhanden 
NOMMX:
    !test edx,[v_Bit25]      ;SSE  
    !jz l_nosse
    !mov [v_sse],2bh
NOSSE:
    !test edx,[v_Bit26]      ;SSE2  
    !jz l_nosse2
    !mov [v_sse2],2bh
NOSSE2:
    !test ecx,[v_Bit0]       ;SSE3
    !jz l_nosse3
    !mov [v_sse3],2bh    
NOSSE3:
    !test ecx,[v_Bit9]       ;SSSE3, vorher auch SSE4 genannt (s.a. c´t 22/2006, S.30)
    !jz l_nossse3
    !mov [v_ssse3],2bh 
NOSSSE3:
 ;-------- Test auf CMOVcc (bedingtes Kopieren)
    !test edx,[v_Bit15]    
    !jz l_nocmov
    !mov [v_cmov],2bh
NOCMOV:       
;------------------------------------------------------------------------------    

;-------- Anzahl der vorhandenen extended levels ermitteln als Vorstufe für 3DNow!-Test
;-------- Rückgabewert in EAX (-80000000h) gibt Anzahl der extended level an
    !mov eax,80000000h
    !cpuid
    !cmp eax,80000000h       ;hat nichts mit einem Bit zu tun!
    !jbe l_noext             ;keine extended levels, 3DNow! überspringen
;------------------------------------------------------------------------------
    
;-------- Test auf 3DNow! und extended 3DNow! (auch DSP=Digital Signal Processing genannt)
;-------- vorhanden, wenn im Rückgaberegister EDX das Bit31 bzw. Bit30 gesetzt ist
;-------- ext.3DNow! (DSP) sind 5 Befehle: PF2IW, PFNACC, PFPNACC, PI2FW und PSWAPD
;-------- 3DNow! steht nur auf AMD-Prozessoren ab dem K6-2 zur Verfügung 
    !mov eax,80000001h       ;80000001h ist praktisch das erste extended level, dieser wird von Intel-Prozessoren nicht unterstützt!
    !cpuid                   ;Intel-Prozessoren liefern hier EAX=0 zurück
    !or eax,eax
    !je l_noext              ;ist Intel-Prozessor
    !test edx,[v_Bit31]      ;3DNow! 
    !jz l_noext
    !mov [v_dnow],2bh
    !test edx,[v_Bit30]      ;extended 3DNow!  
    !jz l_noext
    !mov [v_ednow],2bh
NOEXT:    
;------------------------------------------------------------------------------
   
 MessageRequester(Name$,MMX$+Chr(mmx)+Chr(10)+DNOW$+Chr(dnow)+Chr(10)+EDNOW$+Chr(ednow)+Chr(10)+CMOV$+Chr(cmov)+Chr(10)+SSE$+Chr(sse)+Chr(10)+SSE2$+Chr(sse2)+Chr(10)+SSE3$+Chr(sse3)+Chr(10)+SSSE3$+Chr(ssse3))
End        
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableAsm
; DisableDebugger