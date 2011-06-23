; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1619&highlight=
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 06. July 2003
; OS: Windows
; Demo: No

;################### 
;Feiertage berechnen 
;################### 
;Author : Andreas 
;################### 

Global Tage.w,Monate.w,Jahre.w 

Global Rosenmontag.w,Aschermittwoch.w 
Global Karfreitag.w,Ostersonntag.w,Ostermontag.w 
Global Himmelfahrt.w 
Global Pfingstsonntag.w,Pfingstmontag.w 
Global Fronleichnam.w 

Global Dim DayArray.s(6) 
DayArray(0) ="Montag" 
DayArray(1) ="Dienstag" 
DayArray(2) ="Mittwoch" 
DayArray(3) ="Donnerstag" 
DayArray(4) ="Freitag" 
DayArray(5) ="Samstag" 
DayArray(6) ="Sonntag" 


Procedure.w amod(a.w,b.w) 
    ;Modulo (Ganzzahliger Restwert) bestimmen 
    Ret.w = a - ((a/b)*b) 
    ProcedureReturn Ret 
EndProcedure 


Procedure.w IsLeapyear(Jahr.w) 
    ;Schaltjahr bestimmen 
    ;Rueckgabe = 1 wenn Schaltjahr, sonst Null 
    Result.w =0 
    If (amod(Jahr,4)=0 And amod(Jahr,100)<>0) Or (amod(Jahr,400)=0) 
        Result = 1 
    EndIf 
    ProcedureReturn Result 
EndProcedure 


Procedure.w GetDaysFromGauss(jahr.w) 
    ;gültig von 1583 bis 8702 
    Define.w a,b,c,d,e,f,g,h,i,j 
    a = amod(jahr,19) 
    b  = amod(jahr,4) 
    c = amod(jahr,7) 
    d =  ( ( (jahr/100) * 8 ) + 13 )/25 - 2 
    e =  (jahr/100) - (jahr/400) - 2 
    f  = amod((15 + e - d),30) 
    g =  amod((6 + e),7) 
    h = amod((19 * a + f),30) 
    i =  h 
    If (h = 29) 
        i = 28 
    EndIf 
    If ( (h = 28) And (a > 10) ) 
        i = 27 
    EndIf 
    j = amod( ( (2 * b) + (4 * c) + (6 * i) + g ),7) 
    Result.w = i + j + 22 
    Ostersonntag = Result + 58 + IsLeapyear(jahr) 
    Ostermontag = Ostersonntag + 1 
    Karfreitag = Ostersonntag - 2 
    Rosenmontag = Ostersonntag - 48 
    Aschermittwoch = Rosenmontag + 2 
    Himmelfahrt = Ostersonntag + 39 
    Pfingstsonntag = Ostersonntag + 49 
    Pfingstmontag = Ostersonntag + 50 
    Fronleichnam = Ostersonntag +  60 
    ProcedureReturn 1 
EndProcedure 

Procedure.w GetMonthOfDays(Jahr.w,Day.w) 
    Month.w = 0 
    Alle.w = 0 
    Plus.w = 0 
    Global Dim MyArray3.w(11) 
    MyArray3(0) = 31 
    MyArray3(1) = 28 + IsLeapYear(jahr) 
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
    
    While Day >= Alle 
        Alle = Alle + MyArray3(Plus) 
        Month = Month +1 
        Plus = Plus + 1 
    Wend 
    ProcedureReturn Month 
EndProcedure 


Procedure.w GetDayOfMonth(Jahr.w,Day.w) 
    Month.w = GetMonthOfDays(Jahr,Day) 
    DaysBefore.w = 0 
    i.w = 0 
    Plus.w = 0 
    Global Dim MyArray2.w(11) 
    MyArray2(0) = 31 
    MyArray2(1) = 28 + IsLeapYear(jahr) 
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
    For i = 0 To Month - 2 
        DaysBefore = DaysBefore + MyArray2(i) 
    Next i 
    DayOfMonth = Day - DaysBefore + 1 
    ProcedureReturn DayOfMonth 
EndProcedure 

Procedure.w GetDOW1Januar(jahr.w) 
    Define.w CC,YY,CCDoomday,YYDoomday 
    Global Dim MyArray.w(3) 
    MyArray(0) = 5 
    MyArray(1) = 4 
    MyArray(2) = 2 
    MyArray(3) = 0 
    CC = Jahr/100 
    YY = amod(Jahr,100) 
    CCDoomday = MyArray(amod(CC,4)) 
    YYDoomday = 0 
    If YY = 0 
        YYDoomday = CCDoomday 
    ElseIf amod(YY,12) = 0 
        YYDoomday = amod((CCDoomday + YY/12 - 1),7) 
    ElseIf YY <> 0 
        YYDoomday = amod((CCDoomday + YY/12 + (amod(YY,12)) + (amod((YY-1),12)/4)),7) 
    EndIf 
    If amod(CC,4)=0 And  YY <> 0 
        YYDoomday = amod((YYDoomday +1),7) 
    EndIf 
    ProcedureReturn YYDoomday 
EndProcedure 

Procedure.w DOY(tag.w,monat.w,jahr.w) 
    Global Dim MyArray1.w(11) 
    MyArray1(0) = 31 
    MyArray1(1) = 28 + IsLeapYear(jahr) 
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
    If Tag <= MyArray1(monat-1) 
        For i = 0 To (monat-1)-1 
            Tage = Tage + MyArray1(i) 
        Next i 
        Tage=Tage+Tag 
    EndIf 
    ProcedureReturn Tage 
EndProcedure 


Procedure.w GetWeekday(tag.w,monat.w,jahr.w) 
    WchTag1Jan.w = GetDOW1Januar(jahr) 
    Tage = DOY(tag,monat,jahr)-1 
    Wochentag = amod((WchTag1Jan + amod(Tage,7)),7) 
    ProcedureReturn Wochentag 
EndProcedure 


Procedure Updates(Jahr.w) 
    GetDaysFromGauss(Jahr) 
    Protected Message.s 
    ClearGadgetItemList(0) 
    
    AddGadgetItem(0, -1,"") 
    Message = DayArray(GetWeekday(1,1,Jahr)) 
    SetGadgetItemText(0, 0, Message, 0) 
    Message = "1.1" 
    SetGadgetItemText(0, 0, Message, 1) 
    SetGadgetItemText(0, 0, "Neujahr", 2) 
    
    AddGadgetItem(0, -1,"") 
    Message = DayArray(GetWeekday(GetDayOfMonth(Jahr,Rosenmontag),GetMonthOfDays(Jahr,Rosenmontag),Jahr)) 
    SetGadgetItemText(0, 1, Message, 0) 
    Message = Str(GetDayOfMonth(Jahr,Rosenmontag)) 
    Message + "."+Str(GetMonthOfDays(Jahr,Rosenmontag)) 
    SetGadgetItemText(0, 1, Message, 1) 
    SetGadgetItemText(0, 1, "Rosenmontag", 2) 
    
    AddGadgetItem(0, -1,"") 
    Message = DayArray(GetWeekday(GetDayOfMonth(Jahr,Aschermittwoch),GetMonthOfDays(Jahr,Aschermittwoch),Jahr)) 
    SetGadgetItemText(0, 2, Message, 0) 
    Message = Str(GetDayOfMonth(Jahr,Aschermittwoch)) 
    Message + "."+Str(GetMonthOfDays(Jahr,Aschermittwoch)) 
    SetGadgetItemText(0, 2, Message, 1) 
    SetGadgetItemText(0, 2, "Aschermittwoch", 2) 
    
    AddGadgetItem(0, -1,"") 
    Message = DayArray(GetWeekday(GetDayOfMonth(Jahr,Karfreitag),GetMonthOfDays(Jahr,Karfreitag),Jahr)) 
    SetGadgetItemText(0, 3, Message, 0) 
    Message = Str(GetDayOfMonth(Jahr,Karfreitag)) 
    Message + "."+Str(GetMonthOfDays(Jahr,Karfreitag)) 
    SetGadgetItemText(0, 3, Message, 1) 
    SetGadgetItemText(0, 3, "Karfreitag", 2) 
    
    
    AddGadgetItem(0, -1,"") 
    Message = DayArray(GetWeekday(GetDayOfMonth(Jahr,Ostersonntag),GetMonthOfDays(Jahr,Ostersonntag),Jahr)) 
    SetGadgetItemText(0, 4, Message, 0) 
    Message = Str(GetDayOfMonth(Jahr,Ostersonntag)) 
    Message + "."+Str(GetMonthOfDays(Jahr,Ostersonntag)) 
    SetGadgetItemText(0, 4, Message, 1) 
    SetGadgetItemText(0, 4, "Ostersonntag", 2) 
    
    AddGadgetItem(0, -1,"") 
    Message = DayArray(GetWeekday(GetDayOfMonth(Jahr,Ostermontag),GetMonthOfDays(Jahr,Ostermontag),Jahr)) 
    SetGadgetItemText(0, 5, Message, 0) 
    Message = Str(GetDayOfMonth(Jahr,Ostermontag)) 
    Message + "."+Str(GetMonthOfDays(Jahr,Ostermontag)) 
    SetGadgetItemText(0, 5, Message, 1) 
    SetGadgetItemText(0, 5, "Ostermontag", 2) 
    
    
    ;Dazwischen noch der 1.Mai 
    AddGadgetItem(0, -1,"") 
    If Jahr > 1889 
        Message = DayArray(GetWeekday(1,5,Jahr)) 
        SetGadgetItemText(0, 6, Message, 0) 
        Message = "1.5" 
        SetGadgetItemText(0, 6, Message, 1) 
        SetGadgetItemText(0, 6, "Tag der Arbeit", 2) 
    Else 
        SetGadgetItemText(0, 6, "Kein Tag der Arbeit", 2) 
    EndIf 
    
    AddGadgetItem(0, -1,"") 
    Message = DayArray(GetWeekday(GetDayOfMonth(Jahr,Himmelfahrt),GetMonthOfDays(Jahr,Himmelfahrt),Jahr)) 
    SetGadgetItemText(0, 7, Message, 0) 
    Message = Str(GetDayOfMonth(Jahr,Himmelfahrt)) 
    Message + "."+Str(GetMonthOfDays(Jahr,Himmelfahrt)) 
    SetGadgetItemText(0, 7, Message, 1) 
    SetGadgetItemText(0, 7, "Himmelfahrt", 2) 
    
    AddGadgetItem(0, -1,"") 
    bt.w = GetWeekday(1,5,Jahr) 
    muta.w = 7 
    If bt >  0 
        muta = 14 - bt 
    EndIf 
    If muta = GetDayOfMonth(Jahr,Pfingstsonntag) 
        muta = muta - 7 
    EndIf 
    Message = DayArray(GetWeekday(muta,5,Jahr)) 
    SetGadgetItemText(0, 8, Message, 0) 
    Message = Str(muta)+".5" 
    SetGadgetItemText(0, 8, Message, 1) 
    SetGadgetItemText(0, 8, "Muttertag", 2) 
    
    AddGadgetItem(0, -1,"") 
    Message = DayArray(GetWeekday(GetDayOfMonth(Jahr,Pfingstsonntag),GetMonthOfDays(Jahr,Pfingstsonntag),Jahr)) 
    SetGadgetItemText(0, 9, Message, 0) 
    Message = Str(GetDayOfMonth(Jahr,Pfingstsonntag)) 
    Message + "."+Str(GetMonthOfDays(Jahr,Pfingstsonntag)) 
    SetGadgetItemText(0, 9, Message, 1) 
    SetGadgetItemText(0, 9, "Pfingstsonntag", 2) 
    
    AddGadgetItem(0, -1,"") 
    Message = DayArray(GetWeekday(GetDayOfMonth(Jahr,Pfingstmontag),GetMonthOfDays(Jahr,Pfingstmontag),Jahr)) 
    SetGadgetItemText(0, 10, Message, 0) 
    Message = Str(GetDayOfMonth(Jahr,Pfingstmontag)) 
    Message + "."+Str(GetMonthOfDays(Jahr,Pfingstmontag)) 
    SetGadgetItemText(0, 10, Message, 1) 
    SetGadgetItemText(0, 10, "Pfingstmontag", 2) 
    
    AddGadgetItem(0, -1,"") 
    Message = DayArray(GetWeekday(GetDayOfMonth(Jahr,Fronleichnam),GetMonthOfDays(Jahr,Fronleichnam),Jahr)) 
    SetGadgetItemText(0, 11, Message, 0) 
    Message = Str(GetDayOfMonth(Jahr,Fronleichnam)) 
    Message + "."+Str(GetMonthOfDays(Jahr,Fronleichnam)) 
    SetGadgetItemText(0, 11, Message, 1) 
    SetGadgetItemText(0, 11, "Fronleichnam", 2) 
    
    AddGadgetItem(0, -1,"") 
    ;von 1954 bis 1989 Tag d. d. Einheit am 17.6 
    ;von 1990 3.10 
    If Jahr > 1953 And jahr < 1990 
        Message = DayArray(GetWeekday(17,6,Jahr)) 
        SetGadgetItemText(0, 12, Message, 0) 
        Message = "17.6" 
        SetGadgetItemText(0, 12, Message, 1) 
        SetGadgetItemText(0, 12, "Tag der deutschen Einheit", 2) 
    ElseIf Jahr > 1989 
        Message = DayArray(GetWeekday(3,10,Jahr)) 
        SetGadgetItemText(0, 12, Message, 0) 
        Message = "3.10" 
        SetGadgetItemText(0, 12, Message, 1) 
        SetGadgetItemText(0, 12, "Tag der deutschen Einheit", 2) 
    Else 
        SetGadgetItemText(0, 12, "Kein Tag der deutschen Einheit", 2) 
    EndIf 
    
    AddGadgetItem(0, -1,"") 
    Message = DayArray(GetWeekday(1,11,Jahr)) 
    SetGadgetItemText(0, 13, Message, 0) 
    Message = "1.11" 
    SetGadgetItemText(0, 13, Message, 1) 
    SetGadgetItemText(0, 13, "Allerheiligen", 2) 
    
    AddGadgetItem(0, -1,"") 
    bt.w = GetWeekday(31,12,Jahr) 
    bt = 21-bt 
    If Jahr <= 2001 
    Message = DayArray(GetWeekday(bt,11,Jahr)) 
    SetGadgetItemText(0, 14, Message, 0) 
    Message = Str(bt)+".11" 
    SetGadgetItemText(0, 14, Message, 1) 
    SetGadgetItemText(0, 14, "Buß-und Bettag", 2) 
    Else 
    SetGadgetItemText(0, 14, "kein Buß-und Bettag", 2) 
    EndIf 
    
    AddGadgetItem(0, -1,"") 
    bt.w = GetWeekday(31,12,Jahr) 
    bt = 32 - bt 
    If bt > 30 
        bt = bt -30 
        Message = DayArray(GetWeekday(bt,12,Jahr)) 
    Else 
        Message = DayArray(GetWeekday(bt,11,Jahr)) 
    EndIf 
    SetGadgetItemText(0, 15, Message, 0) 
    bt.w = GetWeekday(31,12,Jahr) 
    bt = 32 - bt 
    If bt > 30 
        bt = bt -30 
        Message = Str(bt)+".12" 
    Else 
        Message = Str(bt)+".11" 
    EndIf 
    SetGadgetItemText(0, 15, Message, 1) 
    SetGadgetItemText(0, 15, "1. Advent", 2) 
    
    AddGadgetItem(0, -1,"") 
    Message = DayArray(GetWeekday(24,12,Jahr)) 
    SetGadgetItemText(0, 16, Message, 0) 
    Message = "24.12" 
    SetGadgetItemText(0, 16, Message, 1) 
    SetGadgetItemText(0, 16, "Heiligabend", 2) 
    
    AddGadgetItem(0, -1,"") 
    Message = DayArray(GetWeekday(25,12,Jahr)) 
    SetGadgetItemText(0, 17, Message, 0) 
    Message = "25.12" 
    SetGadgetItemText(0, 17, Message, 1) 
    SetGadgetItemText(0, 17, "1. Weihnachtstag", 2) 
    
    AddGadgetItem(0, -1,"") 
    Message = DayArray(GetWeekday(26,12,Jahr)) 
    SetGadgetItemText(0, 18, Message, 0) 
    Message = "26.12" 
    SetGadgetItemText(0, 18, Message, 1) 
    SetGadgetItemText(0, 18, "2. Weihnachtstag", 2) 
    
    AddGadgetItem(0, -1,"") 
    Message = DayArray(GetWeekday(31,12,Jahr)) 
    SetGadgetItemText(0, 19, Message, 0) 
    Message = "31.12" 
    SetGadgetItemText(0, 19, Message, 1) 
    SetGadgetItemText(0, 19, "Sylvester", 2) 
    
    ProcedureReturn 1 
EndProcedure 


st1.SYSTEMTIME 
GetLocalTime_(st1);INFO's holen 
OldYear.w = st1\wYear 
OldMonth.w = st1\wMonth 
OldDay.w = st1\wDay 

HWND = OpenWindow(0, 100, 100, 400, 350, "Feiertage...", #PB_Window_SystemMenu|#PB_Window_Invisible|#PB_Window_ScreenCentered) 
If CreateGadgetList(WindowID(0)) 
    LII = ListIconGadget(0, 0,30,400,310,"Wochentag",80,#PB_ListIcon_FullRowSelect) 
    SendMessage_(lii,#LVM_SETBKCOLOR,0,$D5FFFF) 
    SendMessage_(lii,#LVM_SETTEXTBKCOLOR,0,$D5FFFF) 
    SendMessage_(lii,#LVM_SETTEXTCOLOR,0,RGB(0,0,196)) 
    AddGadgetColumn(0,1,"Tag.Monat",80) 
    AddGadgetColumn(0,2,"Beschreibung",236) 
    shwn = StringGadget(1,0,0,60,24,Str(OldYear)) 
    uhwn = CreateUpDownControl_($560000A6,62,0,80,24,WindowID(0),1,GetModuleHandle_(#Null),shwn,8000,1583,OldYear) 
EndIf 
Updates(SendMessage_(uhwn,1128,0,0)) 
ShowWindow_(hwnd,#SW_SHOWNORMAL) 

Repeat 
    EventID.l = WaitWindowEvent() 
    If EventID = #PB_Event_CloseWindow 
        Quit = 1 
    EndIf 
    If EventID = #PB_Event_Gadget 
        Select EventGadget() 
        Case 1 
            Updates(SendMessage_(uhwn,1128,0,0)) 
        EndSelect 
    EndIf 
Until Quit = 1 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; EnableXP
