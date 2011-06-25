;*****************************************************************************
;*
;* PurePunch Contest #4
;*
;* Name     :  HTTP-Time Sync
;* Author   : coder/FreakyBytes
;* Category : Utility
;* Date     : 16th September 2009
;* Notes    : A little Tool to sync your pc-time with a webserver
;*            The code to parse a HTTP-Date is written by AND51, so special thanks to him!
;*            Don't enter á hostname without port, because the app doesn't work, if input only a hostname!
;*
;*****************************************************************************

Procedure.s ReplaceStrings(String$, StringsToFind$, StringsToReplace$, Seperator$="|")
		Protected n.l
		For n=1 To CountString(StringsToFind$, Seperator$)+1
			String$=ReplaceString(String$, StringField(StringsToFind$, n, Seperator$), StringField(StringsToReplace$, n, Seperator$))
		Next
		ProcedureReturn String$
EndProcedure
Define.q stime, rtime, ctime, frq
If Not InitNetwork()
	End
EndIf
ip$ = ProgramParameter()
If Not ip$
	ip$ = InputRequester("HTTP-Time", "Please input a ip or hostname on which runs a webserver! (hostname:port)", "127.0.0.1:80")
EndIf
Con = OpenNetworkConnection(StringField(ip$, 1, ":"), Val(StringField(ip$, 2, ":")))
If Not Con
	End
EndIf
QueryPerformanceFrequency_(@frq)
QueryPerformanceCounter_(@stime)
SendNetworkString(Con, "HEAD / HTTP/1.1"+#CRLF$+"Connection: Close"+#CRLF$+#CRLF$)
Repeat
	If NetworkClientEvent(Con) = #PB_NetworkEvent_Data
		QueryPerformanceCounter_(@rtime)
		Mem = AllocateMemory(2048)
		Len = ReceiveNetworkData(Con, Mem, 2048)
		recv$ = PeekS(Mem, Len)
		Break
	EndIf
	QueryPerformanceCounter_(@ctime)
Until ((ctime-stime)*1000/frq)/1000 >= 10000  ;TimeOut after 10s
If recv$
	CloseNetworkConnection(Con)
	start = FindString(recv$, "Date:", 1)
	ende = FindString(recv$, #CRLF$, start)
	time$ = Mid(recv$, start+6, ende-start-6)
	time$ = Trim(ReplaceStrings(time$, "Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec", "01|02|03|04|05|06|07|08|09|10|11|12"))
	t = ParseDate("Day, %dd %mm %yyyy %hh:%ii:%ss GMT", time$)-(((ctime-stime)*1000/frq)/1000)
		date.SYSTEMTIME\wYear=Year(t) 
		date.SYSTEMTIME\wMonth=Month(t) 
		date.SYSTEMTIME\wDay=Day(t) 
		date.SYSTEMTIME\wDayOfWeek=DayOfWeek(t) 
		date.SYSTEMTIME\wHour=Hour(t) 
		date.SYSTEMTIME\wMinute=Minute(t) 
		date.SYSTEMTIME\wSecond=Second(t)
		SetSystemTime_(date)
	MessageRequester("New Time", "New Time is set!"+#CRLF$+FormatDate("%yyyy-%mm-%dd  %hh:%ii:%ss GMT", t)+#CRLF$+"Pingtime: "+StrD((rtime-stime)*1000/frq,2)+"ms")
EndIf
;Debug recv$
; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 4
; Folding = -