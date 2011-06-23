; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14358&highlight=
; Author: ricardo (updated for PB 4.00 by Andre)
; Date: 13. March 2005
; OS: Windows
; Demo: No

; Insert a string at the end of an exe file and read it back again...
; This is done by adding some string that you can recognize as *separator*, 
; then is added some OpenFile(0...) to read the executable, goto to the 
; FileSeek that its equal to the exe compiled size (before adding the 
; string) and from there look your both separators and extract the string. 

MessageRequester("","First write the message oin the executable") 
Filez$ = SaveFileRequester("Compile", "C:\file.exe", "All files|*.*", 1) 
Separator$ = "###" 
If OpenFile(0,Filez$) 
    SizeOfFile = Lof(0) 
    *Mem = AllocateMemory(SizeOfFile) 
    ReadData(0, *Mem,SizeOfFile) 
    CloseFile(0) 
    If CreateFile(1,Filez$ +"1.exe");create a copy for security 
        WriteData(1, *Mem,SizeOfFile) 
        TextMessage$ = InputRequester("instructions","chosee a text To add To the executable","Test" + Str(Random(1000))) 
        WriteString(1, Separator$ + TextMessage$ + Separator$) 
        CloseFile(1) 
    EndIf 
EndIf 

MessageRequester("","Now we will read the message oin the executable") 
        
If ReadFile(2,Filez$ +"1.exe") 
    FileSeek(2, SizeOfFile) 
    Text$ = ReadString(2) 
    MessageRequester("Text found",Text$) 
    CloseFile(2) 
EndIf 

DeleteFile(Filez$ +"1.exe") 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; Executable = testttt.exe