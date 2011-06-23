; German forum: http://www.purebasic.fr/german/viewtopic.php?t=830
; Author: MVXA
; Date: 09. November 2004
; OS: Windows
; Demo: Yes

Procedure CPrint(pText.s) 
    Define.l i 
    Define.s Color, tmpChar 
    
    For i = 1 To Len(pText) 
        If Mid(pText, i, 1) = "^" 
            Color = UCase(Mid(pText, i + 1, 1)) 
            
            Select Color 
                Case "0": Color = "0"  ; 0   Schwarz -_- 
                Case "1": Color = "1"  ; 1   Blau 
                Case "2": Color = "2"  ; 2   Grün 
                Case "3": Color = "3"  ; 3   Türkis 
                Case "4": Color = "4"  ; 4   Rot 
                Case "5": Color = "5"  ; 5   Magenta 
                Case "6": Color = "6"  ; 6   Braun 
                Case "7": Color = "7"  ; 7   Hellgrau (Std.) 
                Case "8": Color = "8"  ; 8   Dunkelgrau 
                Case "9": Color = "9"  ; 9   Hellblau 
                Case "A": Color = "10" ; 10  Hellgrün 
                Case "B": Color = "11" ; 11  Cyan 
                Case "C": Color = "12" ; 12  Hellrot 
                Case "D": Color = "13" ; 13  Helles Magenta 
                Case "E": Color = "14" ; 14  Gelb 
                Case "F": Color = "15" ; 15  Weiß 
            EndSelect 
            
            ConsoleColor(Val(Color), 0) 
            i = i + 1 
        ElseIf Mid(pText, i, 1) = "#" 
            PrintN("") 
        Else 
            tmpChar = Mid(pText, i, 1): CharToOem_(@tmpChar, @tmpChar): Print(tmpChar) 
        EndIf 
        ;Delay(1) 
    Next 
    ConsoleColor(7, 0) 
EndProcedure 

OpenConsole()
CPrint("^CHallo#^9Welt") 

Input()
CloseConsole()
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -