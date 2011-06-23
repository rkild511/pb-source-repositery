; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9261
; Author: Iria
; Date: 22. January 2004
; OS: Windows
; Demo: Yes

; Note: these procedures are Windows only, for platform-independent versions look
;       at IsAlpha&IsNumeric.pb !

; *************************************************************************
;   Procedure to determine if all the characters within a string
;   are alpha chars, useful for validating user input, or
;   passing to Windows API's etc...
;
;   Input:    Expects a Null terminated string - All Purebasic strings
;             are null terminated,  which is handy
;   Returns : 0 - success i.e. no numerics were found, or XX where XX
;             is an offset value pointing to the first numeric value
;             found in the string
;
;   NOTE: An input string of ZERO length will return 0 i.e. it hasnt failed
;         validation - but may not be what you expected!
;
; *************************************************************************

Procedure.l IsAlpha(String$)
  
  Shared is_non_alpha_in_this_string.s
  Shared non_alpha_pointer.l
  is_non_alpha_in_this_string = String$
  non_alpha_pointer = 0                     ; assume we will not find any numberics
  
  ! CLD                                       ; Clear Direction - ensure we are incrementing
  ! MOV ESI, [v_is_non_alpha_in_this_string]  ; Point ESI to our null terminated string in memory
  non_alpha_loop:                           ; start loop
  ! lodsb                                   ; Move byte into AL and inc ESI
  ! TEST al, al                               ; check next byte
  ! JZ  l_is_alpha_null                       ; is it a null/0 i.e. end of string, jump out
  ! CMP al, $30                               ; Ascii 48
  ! JB l_non_alpha_loop                       ; this is less than 48 ascii ok try next one
  ! CMP  al, $39                              ; Ascii 58
  ! JA l_non_alpha_loop                       ; this is more than 58 ascii ok try next one
  ; ok were in between lets find out where and report
  ! SUB ESI, [v_is_non_alpha_in_this_string]  ; take original mem location away from current location to get
  ; position within string where numberic was found
  ! MOV [v_non_alpha_pointer], ESI            ; then slap it in the return value
  is_alpha_null:                            ; program end
  
  ProcedureReturn non_alpha_pointer         ; dont forget the ESI pointer was incremented anyway
  
EndProcedure

; *************************************************************************
;   Procedure to determine if all the characters within a string
;   are numerical, useful for later converting to numerical types, or
;   passing to Windows API's etc...
;
;   Input:    Expects a Null terminated string - All Purebasic strings
;             are null terminated,  which is handy
;   Returns : 0 - success i.e. no alpha chars were found, or XX where XX
;             is an offset value pointing to the first alpha char value
;             found in the string
;
;   NOTE: An input string of ZERO length will return 0 i.e. it hasnt failed
;         validation - but may not be what you expected!
;
; *************************************************************************

Procedure.l IsNumeric(String$)
  
  
  Shared is_non_numeric_in_this_string.s
  Shared non_numeric_pointer.l
  is_non_numeric_in_this_string = String$
  non_numeric_pointer = 0                     ; assume we will not find any alpha chars
  
  ! CLD                                         ; Clear Direction - ensure we are incrementing
  ! MOV ESI, [v_is_non_numeric_in_this_string]  ; Point ESI to our null terminated string in memory
  is_numeric_loop:                            ; start loop
  ! lodsb                                     ; Move first byte into AL and inc ESI
  ! TEST al, al                                 ; check next byte is not a null/0 i.e. end of string
  ! JZ  l_is_numeric_null                       ; end the loop when a null is found
  ! CMP al, $39                                 ; Ascii 57
  ! JA l_non_numeric_found                      ; Jump if above ascii 57 (i.e. higher than number 9)
  ! CMP  al, $30                                ; Ascii 48
  ! JB l_non_numeric_found                      ; Jump if bellow ascii 48 (i.e. lower than number 0)
  ! JMP l_is_numeric_loop                       ; ok try next byte
  non_numeric_found:                          ; if we find an alpha char!
  !SUB ESI, [v_is_non_numeric_in_this_string]                   ; take original mem location away from current location to get
  ; position within string where numberic was found
  !MOV [v_non_numeric_pointer], ESI              ; then slap it in the return value
  is_numeric_null:                            ; program end
  
  ProcedureReturn non_numeric_pointer         ; ok output where (if at all!) we found a non numberic char
  
EndProcedure


Debug IsAlpha("")
Debug IsAlpha("aBcDeF")
Debug IsAlpha("abc1")
Debug "---"
Debug IsNumeric("")
Debug IsNumeric("0123456789")
Debug IsNumeric("1234a")

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -