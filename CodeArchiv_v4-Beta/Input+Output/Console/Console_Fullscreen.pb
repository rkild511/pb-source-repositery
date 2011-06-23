; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1390&highlight= 
; Author: Rings (new written for PB 4.00 by Leonhard)
; Date: 17. June 2003 
; OS: Windows
; Demo: No

; Switch console to Full Screen Mode 
; Windows only 

CompilerIf #PB_Compiler_OS <> #PB_OS_Windows 
  CompilerError "The Code 'Console in Fullscreen' is only for Windows" 
CompilerEndIf 


;/!!! 
;/!!! Die kernel32.lib -Lib wurde nicht für PB4 optimiert 
;/!!! The kernel32.lib -Lib was not optimized for PB4. 
;/!!! 
;Import "kernel32.lib" 
;  SetConsoleDisplayMode(hConsoleOutput.l, dwFlags.l, *lpNewScreenBufferDimensions.COORD) 
;EndImport 

#CONSOLE_FULLSCREEN_MODE = 1 ; Vollbild-Konsole 
#CONSOLE_WINDOWED_MODE = 2 ; Windows-Fester-Konsole 
Prototype.b SetConsoleDisplayMode(hConsoleOutput.l, dwFlags.l, *lpNewScreenBufferDimensions.COORD) 

OpenLibrary(1, "kernel32.dll") 
SetConsoleDisplayMode.SetConsoleDisplayMode = GetFunction(1, "SetConsoleDisplayMode") 

OpenConsole() 
  dwOldMode.COORD 
  Result=GetConsoleDisplayMode_(@dwOldMode) 
  hOut=GetStdHandle_(#STD_OUTPUT_HANDLE) 
  SetConsoleDisplayMode(hOut, #CONSOLE_FULLSCREEN_MODE, @dwOldMode) 
  
  ConsoleColor(14,3) 
  ConsoleLocate(10,10) 
  Print("FULL SCREENMODE ! - Press RETURN") 
  Input() 
  
  SetConsoleDisplayMode(hOut, #CONSOLE_WINDOWED_MODE, @dwOldMode) 
  
  ClearConsole() 
  ConsoleColor(10,2) 
  ConsoleLocate(10,10) 
  Print("Windowed MODE ! - Press RETURN") 
  
  Input() 
CloseConsole() 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
