; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2212&highlight=
; Author: dige
; Date: 06. October 2003
; OS: Windows
; Demo: No


; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Note: This code example is now for demonstration only,
;       because PB v4 supports Unicode now natively.
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

; Convert PB strings to Unicode strings...

; Wer für API Aufrufe Unicode Strings benötigt ( zum Bsp. für die NetAPI ) 
; kann diese mit folgendem Workaraound umwandeln: 

; PB-String To Unicode 
; by DiGe 09/2003 

Procedure StringToUnicode ( pbstrptr.l, ucstrptr.l )    ; ANSI Strings nach Unicode codieren 
  MultiByteToWideChar_ ( #CP_ACP, 0, pbstrptr, Len(PeekS(pbstrptr)), ucstrptr, Len(PeekS(ucstrptr)) ) 
  PokeL ( ucstrptr  + Len(PeekS(pbstrptr))*2, 0 ) 
EndProcedure 

; Anwendungsbeispiel: 

  UserName.s = "dige" 
  UserName_uc.s = Space ( 255 ) 

  StringToUnicode ( @UserName, @UserName_uc ) 
   

; Wichtig, PureBasic kann Unicode Strings nicht verabeiten, d.h. wenn 
; der Unicode-Text in der Variblen uc_txt.s ausgelesen oder weiter ver- 
; arbeitet werden soll, kann dies nur mit Peek und Poke über die Adresse 
; der Variablen @uc_txt geschehen. 
; Denn für die PureBasic String Routinen ist der String auf grund der 
; Nullbytes nur 1 Zeichen lang. 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
