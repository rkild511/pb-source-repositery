; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2528&highlight=
; Author: NicTheQuick (updated for PB 4.00 by Andre)
; Date: 21. March 2005
; OS: Windows
; Demo: Yes


; Drive of stepper motors 
; ------------------------
; Need the "InpOut32.dll" !!!!

; Ansteuerung von Schrittmotoren
; -------------------------------
; Ich habe hier auch zwei Schrittmotoren, die ich mit PureBasic ansteuere. 
; Die haben vier Anschlüsse, wovon zwei davon jeweils negiert zu den anderen 
; zwei sind. Da ich aber noch keine NOT-Gatter hier habe, brauche ich 4 Bits 
; pro Motor, d.h. ich kann am LPT nur zwei Schrittmotoren ansteuern, was aber 
; tadellos funktioniert. Die Motoren machen 100 Schritte pro Umdrehung, also 
; 3.6° pro Schritt, was bei minimal 2 ms Umschaltzeit funktioniert. Wenn ich 
; auf 1 ms pro Schritt gehe, fehlen einige Schritte und das ganze läuft nicht 
; rund. Schade eigentlich. 
; 
; Hier ist mein Code dafür, falls ihn jemand braucht: 


#InpOut_ID = 1 

Global InpOut32Aktiv.l 
Procedure OpenInpOut32() 
  Protected Result.l 
  Result = OpenLibrary(#InpOut_ID, "InpOut32.dll") 
  If Result = #False 
    InpOut32Aktiv = #False 
    MessageRequester("ERROR", "InpOut32.dll wurde nicht gefunden oder ist korrupt.", #MB_ICONERROR) 
    End 
  Else 
    InpOut32Aktiv = #True 
  EndIf 
  ProcedureReturn Result 
EndProcedure 

Procedure CloseInpOut32() 
  CloseLibrary(#InpOut_ID) 
  InpOut32Aktiv = #False 
EndProcedure 

Procedure SetBits(Value.l) 
  Protected Address.l 
  Address = $378 
  ProcedureReturn CallFunction(#InpOut_ID, "Out32", Address, Value) 
EndProcedure 

Procedure.l GetBits() 
  Protected Address.l, Value.l 
  Address = $379 
  Value = CallFunction(#InpOut_ID, "Inp32", Address) 
  ProcedureReturn Value 
EndProcedure 

Procedure.l Inp32(Address.l) 
  Protected Value.l 
  Value = CallFunction(#InpOut_ID, "Inp32", Address) 
  ProcedureReturn Value 
EndProcedure 

Procedure Out32(Address.l, Value.l) 
  ProcedureReturn CallFunction(#InpOut_ID, "Out32", Address, Value) 
EndProcedure 

Procedure CheckInpOut32Functions() 
  Protected FunctionName.s 
  If InpOut32Aktiv 
    Restore CheckInpOut32FunctionsData 
    For a.l = 1 To 2 
      Read FunctionName 
      If GetFunction(#InpOut_ID, FunctionName) = #False 
        MessageRequester("ERROR", "Die Funktion " + Chr(34) + FunctionName + Chr(34) +" wurde nicht gefunden", #MB_ICONERROR) 
        ProcedureReturn #False 
      EndIf 
    Next 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
  
  DataSection 
    CheckInpOut32FunctionsData: 
    Data.s "Inp32", "Out32" 
  EndDataSection 
EndProcedure 

Dim Motor.b(3) 
Motor(0) = %1001 
Motor(1) = %1100 
Motor(2) = %0110 
Motor(3) = %0011 
MaxMotorSchritt.l = 4   ; Bits pro Motor 

MaxPos.l = 400          ; Schritte für das Trackbargadget 

Pos1.l = 0              ; Startposition von Motor 1 
NewPos1.l = 0 
Pos2.l = 0              ; Startposition von Motor 2 
NewPos2.l = 0 

t_delta.l = 2           ; Umschaltzeit pro Schritt 
t_old.l = ElapsedMilliseconds() 

If OpenInpOut32() 
  Win_Main.l = OpenWindow(#PB_Any, 0, 0, 402, 40, "Schrittmotor", #PB_Window_ScreenCentered | #PB_Window_SystemMenu) 
  If Win_Main 
    If CreateGadgetList(WindowID(Win_Main)) 
      Gad_Track1.l = TrackBarGadget(#PB_Any, 1,  1, 400, 18, 0, MaxPos) 
      Gad_Track2.l = TrackBarGadget(#PB_Any, 1, 21, 400, 18, 0, MaxPos) 
      
      Repeat 
        EventID.l = WindowEvent() 
        Select EventID 
          Case #PB_Event_CloseWindow 
            Break 
          
          Case #PB_Event_Gadget 
            Select EventGadget() 
              Case Gad_Track1 
                NewPos1 = GetGadgetState(Gad_Track1) 
              Case Gad_Track2 
                NewPos2 = GetGadgetState(Gad_Track2) 
            EndSelect 
            
          Case 0 
            Delay(1) 
        EndSelect 
        
        If t_old + t_delta < ElapsedMilliseconds() 
          If Pos1 > NewPos1 : Pos1 - 1 : ElseIf Pos1 < NewPos1 : Pos1 + 1 : EndIf 
          If Pos2 > NewPos2 : Pos2 - 1 : ElseIf Pos2 < NewPos2 : Pos2 + 1 : EndIf 
          
          SetBits(Motor(Pos1 % MaxMotorSchritt) + Motor(Pos2 % MaxMotorSchritt) << MaxMotorSchritt) 
          
          t_old = ElapsedMilliseconds() 
        EndIf 
      ForEver 
    EndIf 
    CloseWindow(Win_Main) 
  EndIf 
  SetBits(0) 
  CloseInpOut32() 
EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP