; German forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 19. November 2003
; OS: Windows
; Demo: Yes

Procedure.w Mod(a.w,b.w) 
    ;Modulo (Ganzzahliger Restwert) bestimmen 
    Ret.w = a - ((a/b)*b) 
    ProcedureReturn Ret 
EndProcedure 

Procedure.w IsLeapyear(Jahr.w) 
    ;Schaltjahr bestimmen 
    ;Rueckgabe = 1 wenn Schaltjahr, sonst Null 
    Result.w =0 
    If (Mod(Jahr,4)=0 And Mod(Jahr,100)<>0) Or (Mod(Jahr,400)=0) 
        Result = 1 
    EndIf 
    ProcedureReturn Result 
EndProcedure 

Procedure.w GetMonthOfDays(Jahr.w,day.w) 
    ;Rueckgabe = Monat 
    month.w = 0 
    Alle.w = 0 
    Plus.w = 0 
    Global Dim MyArray3.w(11) 
    MyArray3(0) = 31 
    MyArray3(1) = 28 + IsLeapyear(Jahr) 
    MyArray3(2) = 31 
    MyArray3(3) = 30 
    MyArray3(4) = 31 
    MyArray3(5) = 30 
    MyArray3(6) = 31 
    MyArray3(7) = 31 
    MyArray3(8) = 30 
    MyArray3(9) = 31 
    MyArray3(10) = 30 
    MyArray3(11) = 31 
    While day >= Alle 
        Alle = Alle + MyArray3(Plus) 
        month = month +1 
        Plus = Plus + 1 
    Wend 
    ProcedureReturn month 
EndProcedure 

Procedure.w GetDayOfMonth(Jahr.w,day.w) 
    ;Rueckgabe Tag des Monats 
    month.w = GetMonthOfDays(Jahr,day) 
    DaysBefore.w = 0 
    i.w = 0 
    Plus.w = 0 
    Global Dim MyArray2.w(11) 
    MyArray2(0) = 31 
    MyArray2(1) = 28 + IsLeapyear(Jahr) 
    MyArray2(2) = 31 
    MyArray2(3) = 30 
    MyArray2(4) = 31 
    MyArray2(5) = 30 
    MyArray2(6) = 31 
    MyArray2(7) = 31 
    MyArray2(8) = 30 
    MyArray2(9) = 31 
    MyArray2(10) = 30 
    MyArray2(11) = 31 
    For i = 0 To month - 2 
        DaysBefore = DaysBefore + MyArray2(i) 
    Next i 
    DayOfMonth = day - DaysBefore + 1 
    ProcedureReturn DayOfMonth 
EndProcedure 

Procedure.w GetDayFromGauss(Jahr.w) 
    ;Rueckgabe Tag des Ostersonntags des Jahres 
    ;gültig von 1583 bis 8702 nach Gauss 
    Define.w a,b,c,d,e,f,g,h,i,j,Ostersonnatg 
    a = Mod(Jahr,19) 
    b  = Mod(Jahr,4) 
    c = Mod(Jahr,7) 
    d =  ( ( (Jahr/100) * 8 ) + 13 )/25 - 2 
    e =  (Jahr/100) - (Jahr/400) - 2 
    f  = Mod((15 + e - d),30) 
    g =  Mod((6 + e),7) 
    h = Mod((19 * a + f),30) 
    i =  h 
    If (h = 29) 
        i = 28 
    EndIf 
    If ( (h = 28) And (a > 10) ) 
        i = 27 
    EndIf 
    j = Mod( ( (2 * b) + (4 * c) + (6 * i) + g ),7) 
    Result.w = i + j + 22 
    Ostersonntag = Result + 58 + IsLeapyear(Jahr) 
    ProcedureReturn Ostersonntag 
EndProcedure 


Procedure.s GetDOW1Januar(Jahr.w) 
    ;Rueckgabe = Wochentag des 1. Januar 
    Define.w CC,YY,CCDoomday,YYDoomday 
    Global Dim MyArray.w(3) 
    MyArray(0) = 5 
    MyArray(1) = 4 
    MyArray(2) = 2 
    MyArray(3) = 0 
    Global Dim Weekdays.s(6) 
    Weekdays(0) = "Sonntag" 
    Weekdays(1) = "Montag" 
    Weekdays(2) = "Dienstag" 
    Weekdays(3) = "Mittwoch" 
    Weekdays(4) = "Donnerstag" 
    Weekdays(5) = "Freitag" 
    Weekdays(6) = "Samstag" 
    CC = Jahr/100 
    YY = Mod(Jahr,100) 
    CCDoomday = MyArray(Mod(CC,4)) 
    YYDoomday = 0 
    If YY = 0 
        YYDoomday = CCDoomday 
    ElseIf Mod(YY,12) = 0 
        YYDoomday = Mod((CCDoomday + YY/12 - 1),7) 
    ElseIf YY <> 0 
        YYDoomday = Mod((CCDoomday + YY/12 + (Mod(YY,12)) + (Mod((YY-1),12)/4)),7) 
    EndIf 
    If Mod(CC,4)=0 And  YY <> 0 
        YYDoomday = Mod((YYDoomday +1),7) 
    EndIf 
    ProcedureReturn Weekdays(YYDoomday) 
EndProcedure 

Procedure.w DOY(tag.w,monat.w,Jahr.w) 
    ;Rueckgabe = Tag des Jahres 
    Global Dim MyArray1.w(11) 
    MyArray1(0) = 31 
    MyArray1(1) = 28 + IsLeapyear(Jahr) 
    MyArray1(2) = 31 
    MyArray1(3) = 30 
    MyArray1(4) = 31 
    MyArray1(5) = 30 
    MyArray1(6) = 31 
    MyArray1(7) = 31 
    MyArray1(8) = 30 
    MyArray1(9) = 31 
    MyArray1(10) = 30 
    MyArray1(11) = 31 
    Tage.w = 0 
    If tag <= MyArray1(monat-1) 
        For i = 0 To (monat-1)-1 
            Tage = Tage + MyArray1(i) 
        Next i 
        Tage=Tage+tag 
    EndIf 
    ProcedureReturn Tage 
EndProcedure 

DayOfYear = DOY(1,2,2002) 
MonthOfDays = GetMonthOfDays(2003,32) 
FirstDay$ = GetDOW1Januar(2003) 
Ostern$ = Str(GetDayOfMonth(2003,GetDayFromGauss(2003)))+"."+Str(GetMonthOfDays(2003,GetDayFromGauss(2003)))+"."

MessageRequester("Tag des Jahres 1.2.2003",Str(DayOfYear),0) 
MessageRequester("Monat des Jahrestages 32 2003",Str(MonthOfDays),0) 
MessageRequester("Wochentag des 1.Januar 2003",FirstDay$,0) 
MessageRequester("Ostersonntag 2003",Ostern$,0) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --