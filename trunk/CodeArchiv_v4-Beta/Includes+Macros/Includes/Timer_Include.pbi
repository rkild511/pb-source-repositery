;*  Copyright (c) 2002-2005 by Danilo Krahn _
;* _
;* This library is free software; you can redistribute it and/or _
;* modify it under the terms of the GNU Lesser General Public _
;* License As published by the Free Software Foundation; either _
;* version 2.1 of the License, Or (at your option) any later version. _
;* _
;* This library is distributed in the hope that it will be useful, _
;* but WITHOUT ANY WARRANTY; without even the implied warranty of _
;* MERCHANTABILITY Or FITNESS For A PARTICULAR PURPOSE.  See the GNU _
;*    Lesser General Public License For more details. _
;* _
;* changed from C to PB by ts-soft _
;* _
;* Diese Include enthält alle Funktionen der PBOSL_Timer Lib von Danilo Krahn _
;* Die Funktionsnamen wurden angepaßt, um konflikte mit der UserLib zu vermeiden _
;* Desweiteren ist vor Verwendung der Funktionen Timer_Init() aufzurufen _
;* Am Ende dann Timer_End() _
;* _
;* StartTimer() = TimerStart() _
;* EndTimer() = TimerStop() _
;* GetMinTimerResolution() = TimerGetMinRes() _
;* GetMaxTimerResolution() = TimerGetMaxRes() _



Global TimerResolution.TIMECAPS

;** Timer_Init
Procedure Timer_Init();* Initialisiert die Timerfunctionen
  Global Dim TimerHandles.l(15)
  Global Dim TimerProcedures.l(15)

  Protected err.l = timeGetDevCaps_(@TimerResolution, SizeOf(TIMECAPS))

  If err = #TIMERR_NOERROR
    ProcedureReturn #True
  EndIf

  ProcedureReturn #False
EndProcedure

;** Timer_End
Procedure Timer_End();* Alle Timer beenden und freigeben
  Protected I.l

  timeEndPeriod_(TimerResolution\wPeriodMin)

  For I = 0 To 15
    If TimerHandles(I)
      timeKillEvent_(TimerHandles(I))
    EndIf
  Next

EndProcedure

Procedure Timer_Callback(TimerHandle, Message, TimerID, wParam, lParam)
  If TimerProcedures(TimerID)
    CallFunctionFast(TimerProcedures(TimerID))
  EndIf
EndProcedure

;** TimerStart
;** .TimerID: Id zwischen 0 und 15
;** .Delay: Millisekunden zwischen Timer Aufrufen
;** .ProcAddr: Timer Procedure
Procedure TimerStart(TimerID.l, Delay.l, ProcAddr.l)
  If TimerID > 15 Or TimerID < 0 : ProcedureReturn #False : EndIf

  If TimerHandles(TimerID)
    timeKillEvent_(TimerHandles(TimerID))
  EndIf

  TimerProcedures(TimerID) = ProcAddr
  TimerHandles(TimerID) = timeSetEvent_(Delay, 0, @Timer_Callback(), TimerID, #TIME_PERIODIC)

  ProcedureReturn TimerHandles(TimerID)
EndProcedure

;** TimerStop
;** .TimerID: ID des zu stoppenden Timers
Procedure TimerStop(TimerID.l)
  If TimerID > 15 Or TimerID < 0 : ProcedureReturn #False : EndIf

  If TimerHandles(TimerID)
    timeKillEvent_(TimerHandles(TimerID))

    ProcedureReturn #True
  EndIf

  ProcedureReturn #False
EndProcedure

;** TimerGetMaxRes
;* <b>Result: höchst mögliche TimerAuflösung
Procedure TimerGetMaxRes()
  ProcedureReturn TimerResolution\wPeriodMax
EndProcedure

;** TimerGetMinRes
;* <b>Result: kleinste mögliche TimerAuflösung
Procedure TimerGetMinRes()
  ProcedureReturn TimerResolution\wPeriodMin
EndProcedure


; IDE Options = PureBasic v4.00 (Windows - x86)
; CursorPosition = 101
; FirstLine = 37
; Folding = 5-
; EnableXP
; HideErrorLog