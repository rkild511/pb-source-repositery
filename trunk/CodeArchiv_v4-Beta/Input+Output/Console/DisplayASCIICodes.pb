; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8060&highlight=
; Author: Kale
; Date: 26. October 2003
; OS: Windows
; Demo: Yes

UnitsPosX = 2 
TensPosX = 1 
HundredsPosX = 0 

PosY = 0 

If OpenConsole() 

    For z=0 To 9 
        ConsoleLocate(UnitsPosX , PosY) 
        Print(Str(z)+":"+Chr(z)) 
        If UnitsPosX = 65 
            UnitsPosX = 2 
            PosY + 1 
        Else 
            UnitsPosX + 7 
        EndIf 
    Next z 

    For y=10 To 99 
        ConsoleLocate(TensPosX , PosY) 
        Print(Str(y)+":"+Chr(y)) 
        If TensPosX = 64 
            TensPosX = 1 
            PosY + 1 
        Else 
            TensPosX + 7 
        EndIf 
    Next y 

    For x=100 To 255 
        ConsoleLocate(HundredsPosX , PosY) 
        Print(Str(x)+":"+Chr(x)) 
        If HundredsPosX = 63 
            HundredsPosX = 0 
            PosY + 1 
        Else 
            HundredsPosX + 7 
        EndIf 
    Next x 

    Input() 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
