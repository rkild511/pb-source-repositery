; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1063&highlight=
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 19. May 2003
; OS: Windows
; Demo: No

Procedure.s GetTimeString(Picker.l) 
    SendMessage_(Picker,4097,0,@s.SYSTEMTIME) 
    Hour$ = Str(s\wHour) 
    Minute$ = Str(s\wMinute) 
    Second$ = Str(s\wSecond) 
    If Len(Hour$) = 1 : Hour$ = "0"+Hour$:EndIf 
    If Len(Minute$) = 1 : Minute$ = "0"+Minute$:EndIf 
    If Len(Second$) = 1 : Second$ = "0"+Second$:EndIf 
    Time$ = Hour$+":"+Minute$+":"+Second$+" " 
    ProcedureReturn Time$ 
EndProcedure 


Procedure.s GetDateString(Picker.l) 
    SendMessage_(Picker,4097,0,@s.SYSTEMTIME) 
    Month$ = Str(s\wMonth) 
    Day$ = Str(s\wDay) 
    If Len(Month$) = 1 : Month$ = "0"+Month$:EndIf 
    If Len(Day$) = 1 : Day$ = "0"+Day$:EndIf 
    Date$ = Day$+"."+Month$+"."+Str(s\wYear) 
    ProcedureReturn Date$ 
EndProcedure 

Procedure SetDate(Picker.l,y,m,d) 
SendMessage_(Picker,4097,0,@s.SYSTEMTIME) 
s\wYear = y 
s\wMonth = m 
s\wDay = d 
SendMessage_(Picker,4098,0,s) 
EndProcedure 

Procedure SetTime(Picker.l,h,m,s) 
SendMessage_(Picker,4097,0,@st.SYSTEMTIME) 
st.SYSTEMTIME 
st\wHour = h 
st\wMinute = m 
st\wSecond = s 
SendMessage_(Picker,4098,0,st) 
EndProcedure 

Structure ICC_S 
a.l 
b.l 
EndStructure 


If OpenWindow(0, 10, 200, 300, 200, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
SetForegroundWindow_(WindowID(0)) 
Global Dim ICC.ICC_S(0) 
ICC(0)\a = SizeOf(ICC_S) 
ICC(0)\b = $FFF 
InitCommonControlsEx_(ICC(0)) 
DatePicker.l = CreateWindowEx_(0,"SysDateTimePick32","",$56000000,10,10,120,20,WindowID(0),0,GetModuleHandle_(0),0) 
TimePicker.l = CreateWindowEx_(0,"SysDateTimePick32","",$56000009,130,10,120,20,WindowID(0),0,GetModuleHandle_(0),0) 

If CreateGadgetList(WindowID(0)) 
    ButtonGadget(1, 10, 40,  80, 24, "Datum") 
    ButtonGadget(4, 100, 40,  180, 24, "Datum und Zeit setzen") 
    TextGadget(2, 10, 70,  120, 24, "Datum") 
    TextGadget(3, 10, 100,  120, 24, "Zeit") 
EndIf 
Repeat 
    EventID.l = WaitWindowEvent() 
    If EventID = #PB_Event_CloseWindow 
        Quit = 1 
    EndIf 
    If EventID = #PB_Event_Gadget 
        Select EventGadget() 
        Case 1 
            SetGadgetText(2,GetDateString(DatePicker)) 
            SetGadgetText(3,GetTimeString(TimePicker)) 
        Case 4 
            SetDate(DatePicker,2004,12,24) 
            SetTime(TimePicker,11,55,00) 
        EndSelect 
    EndIf 
Until Quit = 1 

EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
