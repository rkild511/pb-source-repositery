; English forum: 
; Author: Alberto Gonzalez (updated for PB 4.00 by Andre)
; Date: 22. February 2004
; OS: Windows
; Demo: Yes

XIncludeFile "nsConstants.pbi"

;=================================================================
; PureBasic routines to manipulate strings
;
;
; Version 1.0 	2004 Feb 20      initial release for PureBasic
;
; EMail: support@nomscon.com
; URL: http://www.nomscon.com
;
;-- License/Terms and Conditions --------------------------------
; This code is free for all to use without acknowledging the
; author, Alberto Gonzalez. Use this code as you see fit. By
; using or compiling this code or derivative thereof, you are
; consenting to hold the author, Alberto Gonzalez, harmless
; for all effects or side-effects of its use.
;
; In other words, this code works for me, but you are using it
; at your own risk.
;
; All support of this code will be provided (or not provided)
; at the discretion of the author and with no guarantee as to
; the accuracy or timeliness of any response. But I'll do my
; best.
;
;-- Change Log ---------------------------------------------------
; 2004 Feb 22 
;   - Added ASCII versions of the nsStrIs... functions
;   - WordCount now uses pointers to speed things up
;=================================================================

Procedure.s nsStrDelete(s.s, index.l, count.l)
    ; remove a given number of characters, starting at a given index from a string
    Protected result.s

    If (index < 1) Or (index > Len(s)) Or (count < 1)
        result = s
    Else
        If index = 1
            result = Mid(s, (index + count), Len(s))
        Else
            result = Left(s, index - 1) + Mid(s, (index + count), Len(s))
        EndIf
    EndIf

    ProcedureReturn result
EndProcedure

Procedure.s nsStrInsert(s.s, index.l, insStr.s)
    ; insert a string at a given index of another string
    ; string is expanded to accomodate the new insertion
    Protected result.s

    If Len(insStr) = 0
        result = s
    ElseIf (index <= 1)
        ; prepend
        result = insStr + s
    ElseIf (index > Len(s))
        ; append
        result = s + insStr
    Else
        result = Left(s, index - 1) + insStr + Mid(s, index, Len(s))
    EndIf

    ProcedureReturn result
EndProcedure

Procedure.s nsStrReplace(s.s, find.s, repl.s, count.l)
    ; locate a substring inside of a string and replace with another substring
    ; will replace upto (count) instances of substring
    ; count of zero will replace all instances
    Protected result.s

    If (Len(s) > 0) And (Len(find) > 0)
        Protected pos.l, hits.l

        pos = 1
        hits = 0
        While (pos > 0) And ((hits < count) Or (count <= 0))
            pos = FindString(result, find, pos)
            If pos > 0
                result = nsStrDelete(result, pos, Len(find))
                If Len(repl) > 0 : result = nsStrInsert(result, pos, repl) : EndIf
                hits = hits + 1
                pos = pos + Len(repl)
            EndIf
        Wend
    Else
        result = s
    EndIf

    ProcedureReturn result
EndProcedure

Procedure.l nsStrCount(s.s, find.s)
    ; Return the number of instances of a substring in a string
    Protected result.l

    result = 0
    If (Len(s) > 0) And (Len(find) > 0)
        Protected pos.l

        pos = 1
        While (pos > 0)
            pos = FindString(s, find, pos)
            If pos > 0
                result = result + 1
                pos = pos + Len(find)
            EndIf
        Wend
    EndIf

    ProcedureReturn result
EndProcedure

Procedure.s nsStrRepeat(s.s, multiplier.l)
    ; will repeat string a given number of times
    Protected result.s

    If multiplier > 0
        Protected sLen.l, newLen.l, i.l
        Protected *pResult

        sLen = Len(s)
        newLen = multiplier * sLen

        result = Space(newLen)
        *pResult = @result

        For i = 1 To multiplier
            PokeS(*pResult, s)
            If i < Multiplier : *pResult = *pResult + sLen : EndIf
        Next i
    Else
        result = ""
    EndIf

    ProcedureReturn result
EndProcedure
 
Procedure.s nsStrReverse(s.s)
    ; will reverse the characters in a string
    Protected result.s, sLen.l
    
    sLen= Len(s)
    If strLen > 0
        Protected i.l, c.b 
        Protected *pResult
        
        result = Space(sLen)
        *pResult = @result
        
        For i = sLen To 1 Step -1
            c = Asc(Mid(s, i, 1))
            PokeB(*pResult, c)
            If i > 1 : *pResult = *pResult + 1 : EndIf
        Next i
    EndIf
    
    ProcedureReturn result
EndProcedure

Procedure.s nsStrLPadChar(s.s, width.l, padChar.s)
    ; adds (padChar) to front of string (s) till string length is (width)
    Protected result.s
    
    If (Len(s) < width) And (Len(padChar) > 0)
        result = RSet(s, (width - Len(s)), padChar)
    Else
        result = s
    EndIf

    ProcedureReturn result
EndProcedure

Procedure.s nsStrLPad(s.s, width.l)
    ; adds spaces to front of string (s) till string length is (width)
    ProcedureReturn RSet(s, width)
EndProcedure

Procedure.s nsStrRPadChar(s.s, width.l, padChar.s)
    ; adds (padChar) to end of string (s) till string length is (width)
    Protected result.s
    
    If (Len(s) < width) And (Len(padChar) > 0)
        result = LSet(s, (width - Len(s)), padChar)
    Else
        result = s
    EndIf

    ProcedureReturn result
EndProcedure

Procedure.s nsStrRPad(s.s, width.l)
    ; adds spaces to end of string (s) till string length is (width)
    ProcedureReturn LSet(s, width)
EndProcedure

Procedure.s nsStrCPadChar(s.s, width.l, padChar.s)
    ; adds (padChar) to front and end of string (s) till string
    ; length is (width) - biased towards odd extra space at end
    Protected result.s

    If (Len(s) < width) And (Len(padChar) > 0)
        Protected padWidth.l

        padWidth = (width - Len(s))
        If (padWidth > 1)
            result = nsStrLPadChar(s, Width - (padWidth/2), padChar)
        EndIf
        result = nsStrRPadChar(s, width, padChar)
    Else
        result = s
    EndIf

    ProcedureReturn result
EndProcedure

Procedure.s nsStrCPad(s.s, width.l)
    ; adds spaces to front and end of string till string (s) length is (width)
    ProcedureReturn nsStrCPadChar(s, width, " ")
EndProcedure

Procedure.s nsStrStretchPadChar(s.s, padCharCount.l, ch.s)
    ; adds (padCharCount) of (ch) in between
    ; characters to expand the string (s)
    Protected result.s, sLen.l
    
    sLen = Len(s)
    If (sLen > 0) And (padCharCount > 0) And (Len(ch) > 0)
        Protected newWidth.l
        Protected *pResult
        Protected pos.l, i.l

        newWidth = sLen + ((sLen * padCharCount) - padCharCount)

        ; reserve space for new string
        result = LSet("", newWidth, ch)
        *pResult = @result

        pos = 0
        For i = 1 To sLen
            PokeB(*pResult, Asc(Mid(s, i, 1)))
            If i < sLen : *pResult = *pResult + padCharCount + 1 : EndIf
        Next i
    Else
        result = s
    EndIf

    ProcedureReturn result
EndProcedure
 
Procedure.s nsStrStretchPad(s.s, padCharCount.l)
    ; adds (padCharCount) spaces in between
    ; characters to expand the string (s)
    ProcedureReturn nsStrStretchPadChar(s, padCharCount, " ")
EndProcedure

Procedure.b nsStrIsWhiteSpaceAsc(ch.l)
    ; determine if the given character ascii value is a whitespace character
    ; whitespace characters include bell, tab, linefeed, formfeed, 
    ; carriage return and space
    If (ch = 8) Or (ch = 9) Or (ch = 10) Or (ch = 12) Or (ch = 13) Or (ch = 32)
        ProcedureReturn #True
    Else
        ProcedureReturn #False
    EndIf
EndProcedure

Procedure.b nsStrIsWhiteSpace(ch.s)
    ; determine if the first character of the string is a whitespace character
    ; whitespace characters include bell, tab, linefeed, formfeed, 
    ; carriage return and space
    Protected result.b

    result = #False
    If Len(ch) > 0
        result = nsStrIsWhiteSpaceAsc(Asc(Mid(ch,1,1)))
    EndIf

    ProcedureReturn result
EndProcedure

Procedure.b nsStrIsAlphaAsc(ch.l)
    ; determine if the given character ascii value is an alphabet character [A-Za-z]
    If ((ch >= 65) And (ch <= 90)) Or ((ch >= 97) And (ch <= 122))
        ProcedureReturn #True
    Else
        ProcedureReturn #False
    EndIf
EndProcedure

Procedure.b nsStrIsAlpha(ch.s)
    ; determine if the first character of the string is an alphabet character [A-Za-z]
    Protected result.b

    result = #False
    If Len(ch) > 0
        result = nsStrIsAlphaAsc(Asc(Mid(ch, 1, 1)))
    EndIf

    ProcedureReturn result
EndProcedure

Procedure.b nsStrIsNumericAsc(ch.l)
    ; determine if the given character ascii value is a number character [0-9]
    If (c >= 48) And (c <= 57)
        ProcedureReturn #True
    Else
        ProcedureReturn #False
    EndIf
EndProcedure

Procedure.b nsStrIsNumeric(ch.s)
    ; determine if the first character of the string is a number character [0-9]
    Protected result.b

    result = #False
    If Len(ch) > 0
        result = nsStrIsNumericAsc(Asc(Mid(ch, 1, 1)))
    EndIf

    ProcedureReturn result
EndProcedure

Procedure.b nsStrIsAlphaNumericAsc(ch.l)
    ; determine if the given character ascii values is an alphanumeric character [A-Za-z0-9]
    Protected result.b

    result = #False
    If nsStrIsNumericAsc(ch) 
        If nsStrIsAlphaAsc(ch)
            result = #True
        EndIf
    EndIf
    
    ProcedureReturn result
EndProcedure

Procedure.b nsStrIsAlphaNumeric(ch.s)
    ; determine if the first character of the string is an alphanumeric character [A-Za-z0-9]
    Protected result.b

    result = #False
    If Len(ch) > 0
        result = nsStrIsAlphaNumericAsc(Asc(Mid(ch, 1, 1)))
    EndIf
    
    ProcedureReturn result
EndProcedure

Procedure.s nsStrCompressWhiteSpace(s.s)
    ; trim all leading and trailing white space
    ; ProcedureReturn with all words delimited by only one space
    Protected result.s, sLen.l

    s = Trim(s)
    sLen = Len(s)
    If sLen > 0
        Protected *pResult
        Protected i.l, curPos.l, wsFlag.b
        
        result = Space(sLen)
        *pResult = @result
        curPos = 0
        wsFlag = #False
        For i = 1 To sLen
            If nsStrIsWhiteSpaceAsc(Asc(Mid(s, i + 1, 1)))
                If wsFlag = #False
                    PokeB(*pResult, Asc(Mid(s, i, 1)))
                    If i < sLen : *pResult = *pResult + 1 : EndIf
                    wsFlag = #True
                EndIf
            Else
                wsFlag = #False
                PokeB(*pResult, Asc(Mid(s, i, 1)))
                If i < sLen : *pResult = *pResult + 1 : EndIf
            EndIf
        Next i
    EndIf

    ProcedureReturn RTrim(result)
EndProcedure

Procedure.b nsStrCompare(s1.s, s2.s, ignoreCase.l)
    ; compare two strings with or without case sensitivity
    Protected result.b

    result = #False
    If ignoreCase
        If (LCase(s1) = LCase(s2)) : result = #True : EndIf
    Else
        If (s1 = s2) : result = #True : EndIf
    EndIf
    
    ProcedureReturn result
EndProcedure

Procedure.l nsStrWordCount(s.s)
    ; ProcedureReturn number of words in a string
    Protected count.l, sLen.l

    count = 0
    sLen = Len(s)
    If sLen > 0
        Protected *pStr, i.l

        s = nsStrCompressWhiteSpace(s)
        *pStr = @s
        count = 1
        For i = 1 To sLen
            If nsStrIsWhiteSpaceAsc(PeekB(*pStr))
                count = count + 1
            EndIf
            If i < sLen : *pStr = *pStr + 1 : EndIf
        Next i
    EndIf
    
    ProcedureReturn count
EndProcedure

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -----