; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7959&start=15
; Author: NoahPhense
; Date: 21. October 2003
; OS: Windows
; Demo: Yes

Define.s Data1 
;- CREATE 1K 
Data1 = LSet("", 1000, "a") 

Global NewList Memory.s() 

;- CREATE 64K 
For x = 1 To 6 
    Data1 = Data1 + Data1:; CREATING 64K 
Next x 

;- RUN CONSOLE 
If OpenConsole() 
    ConsoleTitle("Memory Loss v1.0") 
    Print("megs: ") 
    megs.s = Input() 
    megsNumber.w = Val(megs) 
    PrintN("") 
    If megsNumber = 0 
        Goto GetOut 
    EndIf 

    ;- CREATE 1024K 
    For x = 1 To megsNumber*16:; 64K X 16 = 1024000 
        AddElement(Memory()) 
            Memory() = Data1 
    Next x 

    PrintN("done..") 

    Repeat 
    Until Inkey()<>"" 
    GetOut: 
    CloseConsole() 
EndIf 

ClearList(Memory()) 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
