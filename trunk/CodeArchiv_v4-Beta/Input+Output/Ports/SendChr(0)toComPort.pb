; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2838&highlight=
; Author: Topsoft
; Date: 18. November 2003
; OS: Windows
; Demo: No

Declare   ResetDTR(hCom.l) 
Declare   SetDTR(hCom.l) 
Declare   ResetRTS(hCom.l) 
Declare   SetRTS(hCom.l) 
Declare   ResetTXD(hCom) 
Declare   SetTXD(hCom.l) 
Declare.l GetCTS(hCom.l) 
Declare.l GetDSR(hCom.l) 
Declare.l GetRING(hCom.l) 
Declare.l GetRLSD(hCom.l) 
Declare   SendChar(hCom.l, Wert.l) 
Declare.l ReadChar(hCom.l) 
Declare.l OpenCom(Nr.l, Baud.l, Bits.b, Stop.b, Parity.b) 
Declare   CloseCom(hCom.l) 

Structure ComDCB 
     DCBlength.l 
     BaudRate.l 
     fBinary.l 
     fParity.l 
     fOutxCtsFlow.l 
     fOutxDsrFlow.l 
     fDtrControl.l 
     fDsrSensitivity.l 
     fTXContinueOnXoff.l 
     fOutX.l 
     fInX.l 
     fErrorChar.l 
     fNull.l 
     fRtsControl.l 
     fAbortOnError.l 
     fDummy2.l 
     wReserved.w 
     XonLim.w 
     XoffLim.w 
     ByteSize.b 
     Parity.b 
     StopBits.b 
     XonChar.b 
     XoffChar.b 
     ErrorChar.b 
     EofChar.b 
     EvtChar.b 
     wReserved1.w 
EndStructure 

Name.s = "Com1" 

hCom.l = OpenCom(1,9600,8,#ONESTOPBIT, #NOPARITY) 
If hCom > #INVALID_HANDLE_VALUE 
     ResetDtR(hCom) 
     SetRTS(hCom) 
     Delay(1000) 
     ResetRTS(hCom) 
     Delay(1000) 
          Text.s = "" 
          Zeichen.l = ReadChar(hCom) 
          While zeichen > - 1 
               temp.s = Hex(Zeichen) 
               If Len(temp) < 2 
                    text + "0" + temp + " " 
               Else 
                    text + temp + " " 
               EndIf 
               Zeichen = ReadChar(hCom) 
          Wend 
          Debug text 
     CloseHandle_(hCom) 
EndIf 
End 

Procedure ResetDTR(hCom.l) 
     Status.l = #CLRDTR 
     EscapeCommFunction_ (hCom, Status) 
EndProcedure 

Procedure SetDTR(hCom.l) 
     Status.l = #SETDTR 
     EscapeCommFunction_ (hCom, Status) 
EndProcedure 

Procedure ResetRTS(hCom.l) 
     Status.l = #CLRRTS 
     EscapeCommFunction_ (hCom, Status) 
EndProcedure 

Procedure SetRTS(hCom.l) 
     Status.l = #SETRTS 
     EscapeCommFunction_ (hCom, Status) 
EndProcedure 

Procedure ResetTXD(hCom.l) 
     Status.l = #CLRBREAK 
     EscapeCommFunction_ (hCom, Status) 
EndProcedure 

Procedure SetTXD(hCom.l) 
     Status.l = #SETBREAK 
     EscapeCommFunction_ (hCom, Status) 
EndProcedure 

Procedure.l GetCTS(hCom.l) 
     ModemStatus.l = 0 
     GetCommModemStatus_ (hCom, @ModemStatus) 
     If ModemStatus & #MS_CTS_ON = #MS_CTS_ON 
          ProcedureReturn 1 
     Else 
          ProcedureReturn 0 
     EndIf 
EndProcedure 

Procedure.l GetDSR(hCom.l) 
     ModemStatus.l = 0 
     GetCommModemStatus_ (hCom, @ModemStatus) 
     If ModemStatus & #MS_DSR_ON = #MS_DSR_ON 
          ProcedureReturn 1 
     Else 
          ProcedureReturn 0 
     EndIf 
EndProcedure 

Procedure.l GetRING(hCom.l) 
     ModemStatus.l = 0 
     GetCommModemStatus_ (hCom, @ModemStatus) 
     If ModemStatus & #MS_RING_ON = #MS_RING_ON 
          ProcedureReturn 1 
     Else 
          ProcedureReturn 0 
     EndIf 
EndProcedure 

Procedure.l GetRLSD(hCom.l) 
     ModemStatus.l = 0 
     GetCommModemStatus_ (hCom, @ModemStatus) 
     If ModemStatus & #MS_RLSD_ON = #MS_RLSD_ON 
          ProcedureReturn 1 
     Else 
          ProcedureReturn 0 
     EndIf 
EndProcedure 

Procedure SendChar(hCom.l, Wert.l) 
     Anzahl.l = 0 
     Menge.l = 1 
     WriteFile_ (hCom, @Wert, Menge, @Anzahl, 0) 
     ProcedureReturn Anzahl 
EndProcedure 

Procedure.l ReadChar(hCom.l) 
     Wert.l = 0 
     Anzahl.l = 0 
     Status.l = 0 
     GetCommMask_ (hCom, @Status) 
     If Status And #EV_RXCHAR = #EV_RXCHAR 
          ReadFile_ (hCom, @Wert, 1, @Anzahl, 0) 
          If Anzahl 
               ProcedureReturn Wert 
          Else 
               ProcedureReturn -1 
          EndIf 
     Else 
          ProcedureReturn -1 
     EndIf 
EndProcedure 

Procedure.l OpenCom(Nr.l, Baud.l, Bits.b, Stop.b, Parity.b) 
     MyDCB.ComDCB 
     Name.s = "Com" + StrU(Nr,#Byte) 
     MyDCB\DCBlength = SizeOf(ComDCB) 
     MyDCB\BaudRate = Baud 
     MyDCB\fBinary = #True 
     MyDCB\fParity = #False 
     MyDCB\fOutxCtsFlow = #False 
     MyDCB\fOutxDsrFlow = #False 
     MyDCB\fDtrControl = #DTR_CONTROL_DISABLE 
     MyDCB\fDsrSensitivity = #False 
     MyDCB\fTXContinueOnXoff = #True 
     MyDCB\fOutX = #False 
     MyDCB\fInX = #False 
     MyDCB\fErrorChar = 0 
     MyDCB\fNull = #False 
     MyDCB\fRtsControl = #RTS_CONTROL_DISABLE 
     MyDCB\fAbortOnError = #False 
     MyDCB\XonLim = 4096 
     MyDCB\XoffLim = 4096 
     MyDCB\ByteSize = Bits 
     MyDCB\Parity = Parity 
     MyDCB\StopBits = Stop 
     MyDCB\XoffChar = $3F 
     MyDCB\ErrorChar = 0 
     MyDCB\EofChar = 0 
     MyDCB\EvtChar = 0 
     hCom.l = CreateFile_ (@Name, #GENERIC_READ | #GENERIC_WRITE, 0, 0, #OPEN_EXISTING, 0, 0) 
     If hCom = #INVALID_HANDLE_VALUE 
          ProcedureReturn -1 
     EndIf 
     If GetCommState_(hCom, @MyDCB) = 0 
          ProcedureReturn -1 
     EndIf 
     If SetupComm_ (hCom, 4096, 4096) = 0 
          ProcedureReturn -1 
     EndIf 
     If SetCommState_ (hCom, @MyDCB) = 0 
          ProcedureReturn -1 
     EndIf 
     Status.l = #EV_CTS | #EV_DSR | #EV_RING | #EV_RLSD | #EV_RXCHAR 
     If SetCommMask_ (hCom, Status) = 0 
          ProcedureReturn -1 
     EndIf 
     ProcedureReturn hCom 
EndProcedure 

Procedure CloseCom(hCom.l) 
     CloseHandle_(hCom) 
EndProcedure
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ---
