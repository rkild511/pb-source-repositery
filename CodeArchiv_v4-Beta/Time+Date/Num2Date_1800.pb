; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1771&postdays=0&postorder=asc&start=10
; Author: Freak
; Date: 22. July 2003
; OS: Windows
; Demo: Yes

; Procedure for using the date base *** 1.1.1800 *** in PureBasic
; Prozedur zum Verwenden der Datumsbasis *** 1.1.1800 *** in PureBasic
Procedure.s NUM2DATE(argument.l, mode.l) 
  Protected PBDate.l, Result.s 
  PBDate = AddDate(Date(1800, 1, 1, 0, 0, 0), #PB_Date_Day, argument) 
  
  Select mode 
    Case 0: Result = FormatDate("%mm%dd%yyyy", PBDate) 
    Case 1: Result = FormatDate("%dd%mm%yyyy", PBDate) 
    Case 2: Result = FormatDate("%yyyy%mm%dd", PBDate) 
    Case 3: Result = FormatDate("%yyyy%dd%mm", PBDate) 
    Case 4 
      PBDate = Date() 
      Select DayOfWeek(PBDate) 
        Case 0 : Result = "Sun" 
        Case 1 : Result = "Mon" 
        Case 2 : Result = "Tue" 
        Case 3 : Result = "Wen" 
        Case 4 : Result = "Thu" 
        Case 5 : Result = "Fri" 
        Case 6 : Result = "Sat" 
      EndSelect 
      Result + FormatDate(", %dd-", PBDate) 
      Select Month(PBDate) 
        Case 1: Result + "Jan" 
        Case 2: Result + "Feb" 
        Case 3: Result + "Mar" 
        Case 4: Result + "Apr" 
        Case 5: Result + "May" 
        Case 6: Result + "Jun" 
        Case 7: Result + "Jul" 
        Case 8: Result + "Aug" 
        Case 9: Result + "Sep" 
        Case 10: Result + "Oct" 
        Case 11: Result + "Nov" 
        Case 12: Result + "Dec"        
      EndSelect 
      Result + FormatDate("-%yyyy %hh:%ii:%ss GMT", PBDate) 
  EndSelect 
  ProcedureReturn Result 
EndProcedure 

Debug NUM2DATE(321, 0) 
Debug NUM2DATE(0, 4) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
