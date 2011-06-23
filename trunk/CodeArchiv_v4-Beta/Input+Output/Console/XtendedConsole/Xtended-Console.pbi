; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2577&highlight= 
; Author: NoOneKnows (updated for PB 4.00 by Leonhard)
; Date: 17. October 2003 
; OS: Windows
; Demo: No

;/***************************************************/; 
;/**         Xtended Console Version 1.1.0         **/; 
;/**  (c) 2003 by NoOneKnows <NoOneKnows@Gmx.de>   **/; 
;/***************************************************/; 

#XTENDEDCONSOLE_MAXINPUTCHARS       = 400 
#XTENDEDCONSOLE_LIBRARY             = 900 

Global gStdOut.l 
Global gStdIn.l 

Structure COORDEX 
    StructureUnion 
        Value.l 
        coord.COORD 
    EndStructureUnion 
EndStructure 

Structure INPUT_RECORD 
    wEventType.w 
    StructureUnion 
        KeyEvent.KEY_EVENT_RECORD 
        MouseEvent.MOUSE_EVENT_RECORD 
        WindowBufferSizeEvent.WINDOW_BUFFER_SIZE_RECORD 
        MenuEvent.MENU_EVENT_RECORD 
        FocusEvent.FOCUS_EVENT_RECORD 
    EndStructureUnion 
EndStructure 

#CONSOLE_FULLSCREEN_MODE = 1 ; Vollbild-Konsole 
#CONSOLE_WINDOWED_MODE = 2 ; Windows-Fester-Konsole 
Prototype.b SetConsoleDisplayMode(hConsoleOutput.l, dwFlags.l, *lpNewScreenBufferDimensions.COORD) 

OpenLibrary(1, "kernel32.dll") 
Global SetConsoleDisplayMode.SetConsoleDisplayMode = GetFunction(1, "SetConsoleDisplayMode") 

;-Allgemeines 
;* alle Funktionen die mit "Ex" enden haben die gleiche Funktionalität wie 
;  die originalen PureBasic funktionen... 
;* bei Vergrößerung der Konsole kann diese niemals größer werden als ihr Buffer 
;* größter Vorteil dieser manuellen Konsole ist, das sie scrollbar ist im 
;  Gegensatz zur PureBasic-StandardKonsole 
;* hiermit lassen sich auch mehr 80 Zeichen per Input einlesen, 
;  also auch Zeilenübergreifend (evtl. MAXINPUTCHARS anpassen) 

;-Funktions-Beschreibung 

Declare     PrintNEx(text$) 
;siehe PureBasic-Hilfe 

Declare     PrintEx(text$) 
;siehe PureBasic-Hilfe 

Declare.l   OpenConsoleEx() 
;siehe PureBasic-Hilfe. Das AllocConsole_() kann in der Funktion durch 
;OpenConsole() ersetzt werden. Dadurch funktionieren auch die 
;PureBasic-Standardfunktionen kann unter Umständen aber zu Problemen führen 

Declare.s   InputN() 
;siehe PureBasic-Hilfe, jedoch mit dem Zusatz, das ein Zeilenumbruch stattfindet 

Declare.s   InputEx() 
;siehe PureBasic-Hilfe 

Declare.s   InkeyEx() 
;siehe PureBasic-Hilfe 

Declare     GetConsoleWindowPosition(*rect.RECT) 
;gibt die Position des Konsolen-Fensters als RECT referenziert zurück 

Declare.l   GetConsoleWindowCharSize(*windowSize.COORD) 
;gibt referenziert die größe des Fensters der Konsole in Konsolen-Zeichen an 

Declare.l   GetConsoleWindowCharArea(*windowArea.SMALL_RECT) 
;gibt referenziert den aktuellen Ausschnitt der Konsole in Konsolen-Zeichen an 

Declare.s   GetConsoleTitle() 
;gibt den ConsolenTitel zurück 

Declare.l   GetConsoleCursorLocation(*cursorPos.COORD) 
;gibt die Position des Cursors als COORD referenziert zurück 

Declare.w   GetCursorY() 
;gibt die Y-Position des Cursors zurück 

Declare.w   GetCursorX() 
;gibt die X-Position des Cursors zurück 

Declare     ConsoleWindowSize(width.l, height.l) 
;ändert die Breite und die Höhe der Konsole (Angabe in Pixel) 

Declare     ConsoleWindowShow() 
;holt das Fenster aus dem minimierten Zustand zurück und zeigt es an 

Declare     ConsoleWindowPosition(x.l, y.l, width.l, height.l) 
;ändert Position und Größe der Konsole (Angabe in Pixel) 

Declare     ConsoleWindowOnTop() 
;das Konsolenfenster wird in den Vordergrund gerückt 

Declare     ConsoleWindowMove(x.l, y.l) 
;ändert die X(Y-Position des Konsolenfensters (Angabe in Pixel) 

Declare     ConsoleWindowMaximize() 
;maximiert die Konsole entsprechend der Buffer- bzw. Bildschirmgröße. 
;ist der Bildschirm größer als der Buffer, so gilt der Buffer als Maß, 
;andernfalls der Bildschirm 

Declare     ConsoleWindowCharSize(characterWidth.l, characterHeight.l) 
;#ndert die Breite und Höhe der Konsole (Angabe in Konsolen-Zeichen) 

Declare     ConsoleTitleEx(title$) 
;siehe PureBasic-Hilfe 

Declare     ConsoleMoveLocation(x.l, y.l) 
;bewegt den Cursor relativ zur aktuellen Position 

Declare     ConsoleLocateEx(x.l, y.l) 
;siehe PureBasic-Hilfe 

Declare     ConsoleFullScreen(fullscreen.b) 
;setzt die Konsole in den Fullscreen-Modus. 
;da die Funtkion von Microsoft aus net dokumentiert ist, weiß ich nicht 
;ob sie wirklich von alle Windows-Betriebssystemen unterstützt wird 
;1 ist fullscreen an und 0 bedeutetd fullscrenn aus 

Declare     ConsoleFlash(times.l) 
;lässt die Konsole ein paar mal aufblinken (je nach times) 

Declare     ConsoleCursorEx(height.l) 
;siehe PureBasic-Hilfe 

Declare     ConsoleColorBuffer(characterColor.l, backgroundColor.l) 
;färbt die gesamte Konsole mit einschlißlich dem gesamten Buffer 
;in der angegebenen Farbkombination 

Declare     ConsoleColorEx(characterColor.l, backgroundColor.l) 
;siehe PureBasic-Hilfe 

Declare     ConsoleBufferSize(characterWidth.l, characterHeight.l) 
;legt die Größe des Buffers fest (Angabe in Konsolen-Zeichen) 

Declare     CloseConsoleEx() 
;siehe PureBasic-Hilfe 

Declare     ClearConsoleEx() 
;siehe PureBasic-Hilfe 


;nur intern 
Declare.l   GetConsoleWindowHandle() 
Declare     GetColorValue(foreColor.l, backColor.l) 
Declare.l   GetConsoleLocationDirect() 
Declare     FlashConsoleWindow(hwnd.l) 

;-Intern Funktionen 

Procedure FlashConsoleWindow(hwnd.l) 
    Shared sharedTimes.l 

    For J.l = 1 To sharedTimes 
        FlashWindow_(hwnd, 1) 
        Delay(1500) 
    Next J 
EndProcedure 

Procedure.l GetConsoleLocationDirect() 
    consoleInfo.CONSOLE_SCREEN_BUFFER_INFO 
    GetConsoleScreenBufferInfo_(gStdOut, @consoleInfo) 
    ProcedureReturn consoleInfo\dwCursorPosition\x + consoleInfo\dwCursorPosition\y * 65536 
EndProcedure 

Procedure GetColorValue(foreColor.l, backColor.l) 
    Select foreColor 
        Case 0 
            foreColor = 0 
        Case 1 
            foreColor = #FOREGROUND_BLUE 
        Case 2 
            foreColor = #FOREGROUND_GREEN 
        Case 3 
            foreColor = #FOREGROUND_GREEN | #FOREGROUND_BLUE 
        Case 4 
            foreColor = #FOREGROUND_RED 
        Case 5 
            foreColor = #FOREGROUND_RED | #FOREGROUND_BLUE 
        Case 6 
            foreColor = #FOREGROUND_RED | #FOREGROUND_GREEN 
        Case 7 
            foreColor = #FOREGROUND_RED | #FOREGROUND_GREEN | #FOREGROUND_BLUE 
        Case 8 
            foreColor = #FOREGROUND_INTENSITY 
        Case 9 
            foreColor = #FOREGROUND_BLUE | #FOREGROUND_INTENSITY 
        Case 10 
            foreColor = #FOREGROUND_GREEN | #FOREGROUND_INTENSITY 
        Case 11 
            foreColor = #FOREGROUND_GREEN | #FOREGROUND_BLUE | #FOREGROUND_INTENSITY 
        Case 12 
            foreColor = #FOREGROUND_RED | #FOREGROUND_INTENSITY 
        Case 13 
            foreColor = #FOREGROUND_RED | #FOREGROUND_BLUE | #FOREGROUND_INTENSITY 
        Case 14 
            foreColor = #FOREGROUND_RED | #FOREGROUND_GREEN | #FOREGROUND_INTENSITY 
        Case 15 
            foreColor = #FOREGROUND_RED | #FOREGROUND_GREEN | #FOREGROUND_BLUE | #FOREGROUND_INTENSITY 
    EndSelect 

    Select backColor 
        Case 0 
            backColor = 0 
        Case 1 
            backColor = #BACKGROUND_BLUE 
        Case 2 
            backColor = #BACKGROUND_GREEN 
        Case 3 
            backColor = #BACKGROUND_GREEN | #BACKGROUND_BLUE 
        Case 4 
            backColor = #BACKGROUND_RED 
        Case 5 
            backColor = #BACKGROUND_RED | #BACKGROUND_BLUE 
        Case 6 
            backColor = #BACKGROUND_RED | #BACKGROUND_GREEN 
        Case 7 
            backColor = #BACKGROUND_RED | #BACKGROUND_GREEN | #BACKGROUND_BLUE 
        Case 8 
            backColor = #BACKGROUND_INTENSITY 
        Case 9 
            backColor = #BACKGROUND_BLUE | #BACKGROUND_INTENSITY 
        Case 10 
            backColor = #BACKGROUND_GREEN | #BACKGROUND_INTENSITY 
        Case 11 
            backColor = #BACKGROUND_GREEN | #BACKGROUND_BLUE | #BACKGROUND_INTENSITY 
        Case 12 
            backColor = #BACKGROUND_RED | #BACKGROUND_INTENSITY 
        Case 13 
            backColor = #BACKGROUND_RED | #BACKGROUND_BLUE | #BACKGROUND_INTENSITY 
        Case 14 
            backColor = #BACKGROUND_RED | #BACKGROUND_GREEN | #BACKGROUND_INTENSITY 
        Case 15 
            backColor = #BACKGROUND_RED | #BACKGROUND_GREEN | #BACKGROUND_BLUE | #BACKGROUND_INTENSITY 
    EndSelect 

    ProcedureReturn foreColor | backColor 
EndProcedure 

Procedure.l GetConsoleWindowHandle() 
    If OSVersion() = #PB_OS_Windows_2000 Or OSVersion() = #PB_OS_Windows_XP 
        OpenLibrary(#XTENDEDCONSOLE_LIBRARY, "kernel32.dll") 
        hwnd = CallFunction(#XTENDEDCONSOLE_LIBRARY, "GetConsoleWindow") 
        CloseLibrary(#XTENDEDCONSOLE_LIBRARY) 
        ProcedureReturn hwnd 
    Else 
        title$ = GetConsoleTitle() 
        currentProcessID.l = GetCurrentProcessId_() 
    
        hwnd.l = FindWindow_(#Null, title$) 
        GetWindowThreadProcessId_(hwnd, @processID.l) 
        If processID = currentProcessID 
            ProcedureReturn hwnd 
        Else 
            first.l = GetWindow_(hwnd, #GW_HWNDFIRST) 
            GetWindowThreadProcessId_(first, @processID.l) 
            If processID = currentProcessID 
                Debug first 
                ProcedureReturn first 
            EndIf 
            
            hwnd = first 
            Repeat 
                hwnd = GetWindow_(hwnd, #GW_HWNDNEXT) 
                GetWindowThreadProcessId_(first, @processID.l) 
                If processID = currentProcessID 
                    Debug hwnd 
                    ProcedureReturn hwnd 
                EndIf 
            Until hwnd = first Or hwnd = 0 
        EndIf 
    EndIf 

    ProcedureReturn 0 
EndProcedure 

;-Externe Funktionen 

Procedure ClearConsoleEx() 
    consoleInfo.CONSOLE_SCREEN_BUFFER_INFO 
    GetConsoleScreenBufferInfo_(gStdOut, @consoleInfo) 
    size.l = consoleInfo\dwSize\x * consoleInfo\dwSize\y 

    FillConsoleOutputCharacter_(gStdOut, 32, size, #Null, @written.l) 

    GetConsoleScreenBufferInfo_(gStdOut, @consoleInfo) 
    size.l = consoleInfo\dwSize\x * consoleInfo\dwSize\y 
    
    FillConsoleOutputAttribute_(gStdOut, consoleInfo\wAttributes, size, #Null, @written.l) 
    
    SetConsoleCursorPosition_(gStdOut, #Null) 
EndProcedure 

Procedure CloseConsoleEx() 
    CloseHandle_(gStdOut) 
    CloseHandle_(gStdIn) 
    FreeConsole_() 
EndProcedure 

Procedure ConsoleBufferSize(characterWidth.l, characterHeight.l) 
    GetConsoleScreenBufferInfo_(gStdOut, @consoleInfo.CONSOLE_SCREEN_BUFFER_INFO) 
    
    Debug consoleInfo\dwSize\x 
    Debug consoleInfo\dwSize\y 
    If characterWidth < consoleInfo\dwSize\x Or characterHeight < consoleInfo\dwSize\y 
        rect.SMALL_RECT 
        If characterWidth < 13 ;kleinere Buzffer-Breite geht scheinbar net 
            rect\right = 13 - 1 
            characterWidth = 13 
        ElseIf characterWidth < consoleInfo\dwSize\x 
            rect\right = characterWidth - 1 
        Else 
            rect\right = consoleInfo\dwSize\x - 1 
        EndIf 
        
        If characterHeight <= 0 
            rect\bottom = 1 - 1 
            characterHeight = 1 
        ElseIf characterHeight < consoleInfo\dwSize\y 
            rect\bottom = characterHeight - 1 
        Else 
            rect\bottom = consoleInfo\dwSize\y - 1 
        EndIf 
        
        Debug rect\right 
        Debug rect\bottom 
        SetConsoleWindowInfo_(gStdOut, 1, @rect) 
    EndIf 
    

    SetConsoleScreenBufferSize_(gStdOut, characterWidth + (65536 * characterHeight)) 
EndProcedure 

Procedure ConsoleColorEx(characterColor.l, backgroundColor.l) 
    SetConsoleTextAttribute_(gStdOut, GetColorValue(characterColor, backgroundColor)) 
EndProcedure 

Procedure ConsoleColorBuffer(characterColor.l, backgroundColor.l) 
    GetConsoleScreenBufferInfo_(gStdOut, @consoleInfo.CONSOLE_SCREEN_BUFFER_INFO) 
    size.l = consoleInfo\dwSize\x * consoleInfo\dwSize\y 
    consoleInfo\wAttributes = GetColorValue(characterColor, backgroundColor) 
    
    FillConsoleOutputAttribute_(gStdOut, consoleInfo\wAttributes, size, #Null, @written.l) 
EndProcedure 

Procedure ConsoleCursorEx(height.l) 
    cursorInfo.CONSOLE_CURSOR_INFO 
    If height <= 0 
        cursorInfo\bVisible = 0 
        height = 1 
    ElseIf height > 10 
        cursorInfo\bVisible = 1 
        height = 10 
    Else 
        cursorInfo\bVisible = 1 
    EndIf 
    
    cursorInfo\dwSize = height * 10 
    SetConsoleCursorInfo_(gStdOut, @cursorInfo) 
EndProcedure 

Procedure ConsoleFlash(times.l) 
    Shared sharedTimes.l 

    hwnd.l = GetConsoleWindowHandle() 
    If hwnd 
        If times <= 1 
            FlashWindow_(hwnd, 1) 
        Else 
            sharedTimes = times 
            CreateThread(@FlashConsoleWindow(), hwnd) 
        EndIf 
    EndIf 
EndProcedure 

Procedure ConsoleFullScreen(fullscreen.b) 
    If fullscreen 
        SetConsoleDisplayMode(gStdOut, 1, @oldMode.l) 
    Else 
        SetConsoleDisplayMode(gStdOut, 0, @oldMode.l) 
    EndIf 
EndProcedure 

Procedure ConsoleLocateEx(x.l, y.l) 
    SetConsoleCursorPosition_(gStdOut, x + (65536 * y)) 
EndProcedure 

Procedure ConsoleMoveLocation(x.l, y.l) 
    GetConsoleCursorLocation(@cursorPos.COORD) 
    SetConsoleCursorPosition_(gStdOut, (cursorPos\x + x) + (65536 * (cursorPos\y + y))) 
EndProcedure 

Procedure ConsoleTitleEx(title$) 
    SetConsoleTitle_(title$) 
EndProcedure 

Procedure ConsoleWindowCharSize(characterWidth.l, characterHeight.l) 
    consoleInfo.CONSOLE_SCREEN_BUFFER_INFO 
    GetConsoleScreenBufferInfo_(gStdOut, @consoleInfo) 

    rect.SMALL_RECT 
    rect\bottom = characterHeight - 1 
    rect\right = characterWidth - 1 

    If rect\bottom > consoleInfo\dwSize\y 
        rect\bottom = consoleInfo\dwSize\y - 1 
    EndIf 
    If rect\right > consoleInfo\dwSize\x 
        rect\right = consoleInfo\dwSize\x - 1 
    EndIf 
    SetConsoleWindowInfo_(gStdOut, 1, @rect) 
EndProcedure 

Procedure ConsoleWindowMaximize() 
    maxSize.COORDEX\Value = GetLargestConsoleWindowSize_(gStdOut) 
    ConsoleWindowCharSize(maxSize\coord\x, maxSize\coord\y) 
EndProcedure 

Procedure ConsoleWindowMinimize() 
    hwnd.l = GetConsoleWindowHandle() 
    If hwnd 
        ShowWindow_(hwnd, #SW_MINIMIZE) 
    EndIf 
EndProcedure 

Procedure ConsoleWindowMove(x.l, y.l) 
    hwnd.l = GetConsoleWindowHandle() 
    If hwnd 
        SetWindowPos_(hwnd, 0, x, y, 0, 0, #SWP_NOSIZE) 
    EndIf 
EndProcedure 

Procedure ConsoleWindowOnTop() 
    hwnd.l = GetConsoleWindowHandle() 
    If hwnd 
        SetWindowPos_(hwnd, #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE | #SWP_NOSIZE | #SWP_SHOWWINDOW) 
    EndIf 
EndProcedure 

Procedure ConsoleWindowPosition(x.l, y.l, width.l, height.l) 
    hwnd.l = GetConsoleWindowHandle() 
    If hwnd 
        MoveWindow_(hwnd, x, y, width, height, 1) 
    EndIf 
EndProcedure 

Procedure ConsoleWindowShow() 
    hwnd.l = GetConsoleWindowHandle() 
    If hwnd 
        ShowWindow_(hwnd, #SW_SHOWNORMAL) 
    EndIf 
EndProcedure 

Procedure ConsoleWindowSize(width.l, height.l) 
    hwnd.l = GetConsoleWindowHandle() 
    If hwnd 
        SetWindowPos_(hwnd, #HWND_TOP, 0, 0, width, height, #SWP_NOMOVE) 
    EndIf 
EndProcedure 

Procedure.l GetConsoleCursorLocation(*cursorPos.COORD) 
    consoleInfo.CONSOLE_SCREEN_BUFFER_INFO 
    GetConsoleScreenBufferInfo_(gStdOut, @consoleInfo) 
    *cursorPos\x = consoleInfo\dwCursorPosition\x 
    *cursorPos\y = consoleInfo\dwCursorPosition\y 
EndProcedure 

Procedure.s GetConsoleTitle() 
    title$ = LSet("", 150, Chr(0)) 
    GetConsoleTitle_(@title$, 150) 
    ProcedureReturn title$ 
EndProcedure 

Procedure.l GetConsoleWindowCharArea(*windowArea.SMALL_RECT) 
    consoleInfo.CONSOLE_SCREEN_BUFFER_INFO 
    GetConsoleScreenBufferInfo_(gStdOut, @consoleInfo) 
    CopyMemory(consoleInfo\srWindow, *windowArea, 8) 
EndProcedure 

Procedure.l GetConsoleWindowCharSize(*windowSize.COORD) 
    consoleInfo.CONSOLE_SCREEN_BUFFER_INFO 
    GetConsoleScreenBufferInfo_(gStdOut, @consoleInfo) 
    CopyMemory(consoleInfo\dwSize, *windowSize, 8) 
EndProcedure 

Procedure GetConsoleWindowPosition(*rect.RECT) 
    hwnd = GetConsoleWindowHandle() 
    If hwnd 
        placement.WINDOWPLACEMENT\Length = SizeOf(WINDOWPLACEMENT) 
        GetWindowPlacement_(hwnd, @placement) 
        CopyMemory(@placement\rcNormalPosition, *rect, 16) 
    EndIf 
EndProcedure 

Procedure.w GetCursorX() 
    consoleInfo.CONSOLE_SCREEN_BUFFER_INFO 
    GetConsoleScreenBufferInfo_(gStdOut, @consoleInfo) 
    ProcedureReturn consoleInfo\dwCursorPosition\x 
EndProcedure 

Procedure.w GetCursorY() 
    consoleInfo.CONSOLE_SCREEN_BUFFER_INFO 
    GetConsoleScreenBufferInfo_(gStdOut, @consoleInfo) 
    ProcedureReturn consoleInfo\dwCursorPosition\y 
EndProcedure 

Procedure.s InkeyEx() 
    inputRecord.INPUT_RECORD 
    PeekConsoleInput_(gStdIn, @inputRecord, 1, @readed.l) 
    
    If inputRecord\wEventType = #KEY_EVENT 
        ReadConsoleInput_(gStdIn, @inputRecord, 1, @readed.l) 
        If PeekB(@inputRecord\KeyEvent\bKeyDown + 2) 
            Char.b = (inputRecord\KeyEvent\wVirtualScanCode | inputRecord\KeyEvent\dwControlKeyState) & inputRecord\KeyEvent\dwControlKeyState 
            ;aus Kompatibilität zu PureBasic-Inkey() 
            If Char = 0 : Char = 255 : EndIf 
            ProcedureReturn Chr(Char) + Chr(inputRecord\KeyEvent\uChar) 
        EndIf 
    ElseIf inputRecord\wEventType > 0 
        ReadConsoleInput_(gStdIn, @inputRecord, 1, @readed.l) 
    EndIf 

    ProcedureReturn "" 
EndProcedure 

Procedure.s InputEx() 
    GetConsoleCursorLocation(@cursorPos.COORD) 

    GetConsoleScreenBufferInfo_(gStdOut, @consoleInfo.CONSOLE_SCREEN_BUFFER_INFO) 

    inputBuffer$ = LSet("", #XTENDEDCONSOLE_MAXINPUTCHARS, Chr(0)) 
    ReadConsole_(gStdIn, @inputBuffer$, #XTENDEDCONSOLE_MAXINPUTCHARS, @readed.l, #Null) 
    ;CRLF nicht zurückgeben 
    If Mid(inputBuffer$, readed, 1) = Chr(10) 
        readed - 1 
    EndIf 
    If Mid(inputBuffer$, readed, 1) = Chr(13) 
        readed - 1 
    EndIf 
    
    y.l = cursorPos\y + (cursorPos\x + readed) / consoleInfo\dwSize\x 
    x.l = (cursorPos\x + readed) % consoleInfo\dwSize\x 
    ConsoleLocateEx(x, y) 
    
    ProcedureReturn Left(inputBuffer$, readed) 
EndProcedure 

Procedure.s InputN() 
    inputBuffer$ = LSet("", #XTENDEDCONSOLE_MAXINPUTCHARS, Chr(0)) 
    ReadConsole_(gStdIn, @inputBuffer$, #XTENDEDCONSOLE_MAXINPUTCHARS, @readed.l, #Null) 
    ;CRLF nicht zurückgeben 
    If Mid(inputBuffer$, readed, 1) = Chr(10) 
        readed - 1 
    EndIf 
    If Mid(inputBuffer$, readed, 1) = Chr(13) 
        readed - 1 
    EndIf 
    
    ProcedureReturn Left(inputBuffer$, readed) 
EndProcedure 

Procedure.l OpenConsoleEx() 
    AllocConsole_() 
    ;Alternativ auch möglich um die Standardfunktionen zu nutzen 
    ;kann jedoch zu verschiedenen Fehlern führen 
    ;OpenConsole() 
    
    gStdOut.l = GetStdHandle_(#STD_OUTPUT_HANDLE) 
    gStdIn.l = GetStdHandle_(#STD_INPUT_HANDLE) 

    If gStdIn = #INVALID_HANDLE_VALUE Or gStdOut = #INVALID_HANDLE_VALUE 
        ProcedureReturn 0 
    Else 
        ProcedureReturn 1 
    EndIf 
EndProcedure 

Procedure PrintEx(text$) 
    WriteConsole_(gStdOut, @text$, Len(text$), @written.l, #Null) 
EndProcedure 

Procedure PrintNEx(text$) 
    text$ + Chr(13) + Chr(10) 
    WriteConsole_(gStdOut, @text$, Len(text$), @written.l, #Null) 
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -------
