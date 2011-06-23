; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2577&highlight=
; Author: NoOneKnows
; Date: 17. October 2003
; OS: Windows
; Demo: No

XIncludeFile "Xtended-Console.pbi" 

OpenConsoleEx() 

PrintNEx(GetConsoleTitle()) 
ConsoleTitleEx("Xtended-Console") 

ConsoleBufferSize(100, 60) 
ConsoleWindowCharSize(100, 20) 
ConsoleWindowMove(50, 150) 
;ConsoleWindowSize(200, 200) 
;ConsoleWindowPosition(50, 150, 200, 200) 


ConsoleColorBuffer(0, 15) 
ConsoleColorEx(0, 15) 


ConsoleLocateEx(5, 3) 
ConsoleMoveLocation(10, -1) 
;GetConsoleCursorLocation(@cur.COORD) 
;PrintEx("Cursor-Pos was " + Str(cur\x) + "/" + Str(cur\y)) 
PrintEx("Cursor-Pos was " + Str(GetCursorX()) + "/" + Str(GetCursorY())) 

ConsoleLocateEx(0, 5) 
GetConsoleWindowCharArea(@sr.SMALL_RECT) 
PrintNEx(Str(sr\left) + "/" + Str(sr\top) + " to " + Str(sr\right) + "/" + Str(sr\bottom)) 

ConsoleLocateEx(0, 7) 
PrintNEx("Press 'q' to continue...") 
ConsoleColorEx(12, 15) 
Repeat 
    inkey$ = InkeyEx() 
    If inkey$ <> "" 
        ConsoleLocateEx(0, 8) : PrintEx(inkey$) 
    EndIf 
    Delay(20) 
Until Asc(inkey$) = 113 
ConsoleMoveLocation(-2, 2) 

ConsoleColorEx(9, 15) 

PrintNEx(InputN()) 
PrintNEx(" : " + InputEx()) 

ConsoleColorEx(10, 1) 
For i.l = 1 To 30 
    Delay(100) 
    PrintNEx("Buffer-Test " + Str(i)) 
Next i 

ConsoleCursorEx(0) 

;scoll up 
GetConsoleCursorLocation(@cur.COORD) 
ConsoleLocateEx(0, 0) 
Delay(3000) 
;scroll down 
ConsoleLocateEx(cur\x, cur\y) 

ConsoleCursorEx(2) 

ConsoleColorEx(9, 15) 
PrintEx("Ende...") 
InputN() 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
