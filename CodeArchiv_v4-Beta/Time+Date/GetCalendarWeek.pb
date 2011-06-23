; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2228&highlight=
; Author: Gezuppel
; Date: 07. September 2003
; OS: Windows
; Demo: Yes

; ---------------------------------------------------------------------  
; Funktion : GetKW - V1.0 vom 22.06.2003 
; V1.0.1 v. 03.08.2003 - Nur Namen der Uebergabeparameter geaendert. 
; ---------------------------------------------------------------------  
; Berechnung der KalenderWoche nach DIN EN28601. 
; Nach DIN beginnt eine KW immer mit Montag. 
; KW1 ist die Woche in der der 4. Januar liegt. 
; ---------------------------------------------------------------------  
; Jahr.w, Monat.b, Tag.b : Das Datum für das die KW berechnet werden 
; soll. 
; ---------------------------------------------------------------------  
Procedure.b GetKW(PJahr.w,PMonat.b,PTag.b) 
  ; Wochentag des 4. Januar (Mo.-So.). 
  WT4J.b = DayOfWeek(Date(PJahr.w,1,4,0,0,0)) 
  ; Montag = 1 Sonntag = 7. 
  If WT4J.b = 0 : WT4J.b = 7 : EndIf 
  
  ; MoKW1.b (Montag der KW1) ist der x'te Tag des Jahres 
  MoKW1.b = 4-WT4J.b 
  
  ; Wochentag des gesuchten Datums. 
  WTGD.b = DayOfWeek(Date(PJahr.w,PMonat.b,PTag.b,0,0,0)) 
  ; Montag = 1 Sonntag = 7. 
  If WTGD.b = 0 : WTGD.b = 7 : EndIf 

  ; Montag in der Kalenderwoche in der das gesuchte Datum liegt, 
  ; ist der x'te Tag des Jahres. 
  MoGD.w = DayOfYear(Date(PJahr.w,PMonat.b,PTag.b,0,0,0))-WTGD.b 
  
  ; Beide "Jahrestage" (jeweils Montag also erster KW-Tag) voneinander 
  ; abgezogen geteilt durch 7 + 1 ergibt die KW 
  KW.b = Int((MoGD.w-MoKW1.b)/7)+1 
  
  ; Es sei denn: Der gesuchte Tag ist einer der letzten Dezembertage. 
  ; Denn es kann sein, das die letzten Dezembertage in KW1 liegen. 
  ; Wenn es Dezember ist. 
  If PMonat.b = 12 
    ; Der "Jahrestag" des gesuchten Datums. 
    Week1Q.w = DayOfYear(Date(PJahr.w,PMonat.b,PTag.b,0,0,0)) 
    
    ; Der Wochentag des 4. Januar des Folgejahres. 
    WT4JNY.b = DayOfWeek(Date(PJahr.w+1,1,4,0,0,0)) 
    ; Montag = 1 Sonntag = 7. 
    If WT4JNY.b = 0 : WT4JNY.b = 7 : EndIf 
    
    ; Der letzte Tag des Jahres in dem der gesuchte Tag liegt (365 oder 366) 
    LastYDay.w = DayOfYear(Date(PJahr.w,12,31,0,0,0)) 

    ; Wenn der Tagesabstand vom gesuchten Tag zum Jahresende kleiner des 
    ; Abstandes des 4. Januar zum Montag der ersten Woche ist, dann liegt 
    ; der entsprechende Tag in der KW1 des Folgejahres. 
    If LastYDay.w - Week1Q.w < WT4JNY.b -4 
       KW.b = 1 
    EndIf 
  EndIf 
  
  ; Oder: Der gesuchte Tag ist der 1. bis 3. Januar, die koennen in der letzten 
  ; KW des vorjahres liegen, wenn der 4. Januar z.B. auf einem Montag liegt. 
  If PMonat.b = 1 And PTag.b < 4 
    If WT4J.b < WTGD.b 
      KW.b = GetKW(PJahr.w-1,12,31) 
    EndIf 
  EndIf 
  ProcedureReturn KW.b 
EndProcedure 

date.l = Date()
Debug "Heutiges Datum: " + FormatDate("%dd.%mm.%yyyy", date) 
kw=GetKW(Year(date),Month(date),Day(date))
Debug "Kalenderwoche:  " + Str(kw)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
