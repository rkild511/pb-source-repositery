; English forum: 
; Author: Alberto Gonzalez
; Date: 22. February 2004
; OS: Windows
; Demo: Yes

XIncludeFile "nsConstants.pbi"

;=================================================================
; PureBasic routines for console based applications
;
;
; Version 1.0 	2004 Feb 22 initial release for PureBasic
;
; EMail: support@nomscon.com
; URL: http://www.nomscon.com
;
; -- License/Terms And Conditions --------------------------------
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
;=================================================================

; -- Console Routines
Procedure Cls()
    ; shorthand version to clear the screen
    ClearConsole()
EndProcedure

Procedure ClsColor(fgColor.l, bgColor.l)
    ; shorthand version to clear the screen in a given color
    ConsoleColor(fgColor, bgColor)
    ClearConsole()
EndProcedure

Procedure NL()
    ; shorthand to print a newline
    PrintN("")
EndProcedure

Procedure Say(text.s)
    ; write out text To console window at current location
    ; does not add End of line character(s)
    Protected textLen.l, start.l
    textLen = Len(text)
    start = 1
    
    ; overcome 250 character limitation of Print by
    ; printing 250 character chunks
    Repeat
        Print(Mid(text, start, #MAXPRINTLEN))
        start = start + #MAXPRINTLEN
    Until start > textLen
EndProcedure

Procedure SayColor(text.s, fgColor.l, bgColor.l)
    ; write out text to console window at current location in a given color
    ; does not add end of line character(s)
    ConsoleColor(fgColor,bgColor)
    Say(text)
EndProcedure

Procedure SayN(text.s)
    ; write out text To console window at current location
    ; does not add End of line character(s)
    Say(text)
    NL()
EndProcedure

Procedure SayNColor(text.s, fgColor.l, bgColor.l)
    ; write out text to console window at current location in a given color
    ; does not add end of line character(s)
    ConsoleColor(fgColor,bgColor)
    SayN(text)
EndProcedure

Procedure SayAt(text.s, row.l, col.l)
    ; write out text to console window at given location
    ; does not add end of line character(s)
    ConsoleLocate(col, row)
    Say(text)
EndProcedure

Procedure SayColorAt(text.s, fgColor.l, bgColor.l, row.l, col.l)
    ; write out text to console window at given location in a given color
    ; does not add end of line character(s)
    ConsoleColor(fgColor, bgColor)
    SayAt(text, row, col)
EndProcedure

Procedure SayNAt(text.s, row.l, col.l)
    ; write out text to console window at given location
    ; adds an end of line character(s)
    ConsoleLocate(col, row)
    SayN(text)
EndProcedure

Procedure SayNColorAt(text.s, fgColor.l, bgColor.l, row.l, col.l)
    ; write out text to console window at given location in a given color
    ; adds an end of line character(s)
    ConsoleColor(fgColor, bgColor)
    SayNAt(text, row, col)
EndProcedure

Procedure.s Ask(prompt.s)
    ; alias for the input command
    If Len(prompt) > 0: Say(prompt) : EndIf
    ProcedureReturn Input()
EndProcedure

Procedure.s AskColor(prompt.s, fgColor.l, bgColor.l)
    ; prompt user at the current location in a given color
    ConsoleColor(fgColor, bgColor)
    ProcedureReturn Ask(prompt)
EndProcedure

Procedure.s AskAt(prompt.s, row.l, col.l)
    ; prompt user at a given location
    ConsoleLocate(col, row)
    ProcedureReturn Ask(prompt)
EndProcedure

Procedure.s AskColorAt(prompt.s, fgColor.l, bgColor.l, row.l, col.l)
    ; prompt user at given location in a given color
    ConsoleColor(fgColor, bgColor)
    ProcedureReturn AskAt(prompt, row, col)
EndProcedure

Procedure.s AskChar(prompt.s)
    ; prompt user for a single character at current location
    Protected result.s

    Say(prompt)
    Repeat
        result = Inkey()
    Until Len(result) > 0
    result = Left(result, 1)    ; trim raw keycode in the second character
    Print(result)               ; echo character pressed
    
    ProcedureReturn result
EndProcedure

Procedure.b AskYN(prompt.s)
    ; prompts the user for a Y or N character at current location
    ; returns 1 if user enters Y else return 0
    Protected key.s
    Protected result.b

    key = AskChar(prompt + " (Y/N)")
    If LCase(key) = "y" : result = #True : EndIf
    ProcedureReturn result
EndProcedure

Procedure.b AskYNColor(prompt.s, fgColor.l, bgColor.l)
    ; prompts the user for a Y or N character at current location in a given color
    ; returns 1 if user enters Y else return 0

    ConsoleColor(fgColor, bgColor)
    ProcedureReturn AskYN(prompt)
EndProcedure

Procedure.b AskYNAt(prompt.s, row.l, col.l)
    ; prompts the user for a Y or N character at a given location
    ; returns 1 if user enters Y else return 0
    ConsoleLocate(col, row)
    ProcedureReturn AskYN(prompt)
EndProcedure

Procedure.b AskYNColorAt(prompt.s, fgColor.l, bgColor.l, row.l, col.l)
    ; prompts the user for a Y or N character at a given location in a given color
    ; returns 1 if user enters Y else return 0
    ConsoleColor(fgColor, bgColor)
    ProcedureReturn AskYNAt(prompt, row, col)
EndProcedure

Procedure.s AskCharColor(prompt.s, fgColor.l, bgColor.l)
    ; prompt user for a single character at current location in a given color
    ConsoleColor(fgColor, bgColor)
    ProcedureReturn AskChar(prompt)
EndProcedure

Procedure.s AskCharAt(prompt.s, row.l, col.l)
    ; prompt user for a single character at a given location
    ConsoleLocate(col, row)
    ProcedureReturn AskChar(prompt)
EndProcedure

Procedure.s AskCharColorAt(prompt.s, fgColor.l, bgColor.l, row.l, col.l)
    ; prompt user for a single character at a given location in a given color
    ConsoleColor(fgColor, bgColor)
    ProcedureReturn AskCharAt(prompt, row, col)
EndProcedure

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ----