; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9616&highlight=
; Author: AlGonzalez
; Date: 03. March 2004
; OS: Windows
; Demo: Yes

; Here is another encoder/decoder using bitwise XOr: 

; Simple XOr encoder/decoder function 
Procedure.s XOREncode(text.s, key.s) 
    Protected result.s, textLen.l 

    textLen = Len(text) 
    If textLen 
        result = text 

        Protected keyLen.l 
        keyLen = Len(key) 

        If keyLen 
            Protected i.l 
            For i = 0 To (textLen - 1) 
                ; using modulo to determine which letter from key to use 
                PokeB(@result + i, PeekB(@result + i) ! (~PeekB(@key + (i % keyLen)))) 
            Next i 
        EndIf 
    EndIf    
    
    ProcedureReturn result 
EndProcedure 

;- Example:
If OpenConsole() 
    s.s = "Dude - where's my car!" 
    PrintN("Original Text:  " + s) 
    s = XOrEncode(s, "purebasic") 
    PrintN("XOr Encoded:    " + s) 
    s = XOrEncode(s, "purebasic") 
    PrintN("XOr Decoded:    " + s) 

    PrintN("") 
    PrintN("-- The alphabet") 
    s = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" 
    PrintN("Original Text:  " + s) 
    s = XOrEncode(s, "PureBasic") 
    PrintN("XOr Encoded:    " + s) 
    s = XOrEncode(s, "PureBasic") 
    PrintN("XOr Decoded:    " + s) 

    Print("Press a key when done... ") 
    Repeat : Until Inkey() 
    CloseConsole() 
EndIf 

End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger