; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=355&start=10
; Author: paolo
; Date: 26. June 2003
; OS: Windows
; Demo: No

; Example for using the serial port to communicate with a micro-controller
; by paolo (E-Mail: pinco_palla@web.de)

; Programmers statement (german):
; Ich habe mir Teile der Code aus PureFrog geholt und für meine Zwecke angepasst,
; ich verwende es um mit einem MicroController zu kommunizieren. 

; Der uC erwartet die Commands mit CR am Ende, 
; und sendet die Antwort mit CR/LF die tue ich dann in eine Liste 
; und gebe dann die Liste aus. 
; Ich mußte für meine Zwecke die Port, die BaudRate, die Flags(brauch ich nicht)
; und die COMMTIMEOUTS Werte anpassen. 

;-------------------------------------------
; uC ist ein 80C537
; 537-Light-Board aus Elektor 1/2000
;Befehle  zu uC : bytes+CR
;Antwort von uC : bytes+CR+LF
;-------------------------------------------
; OS: Win98
; PureBasic V. 3.70
;-------------------------------------------


;------------------------------------------------------------------------------------- 
; Aus dem original Code: Danke Jungs!!!  :D 
;------------------------------------------------------------------------------------- 
; 
;                       PureFrog 
;                       -------- 
; 
;    The FroggyHome sensor monitor written in PureBasic. 
; 
;         Written by: 
; 
;             - Frederic 'AlphaSND' Laboureur 
;             - Chaumontet 'snip' Sebastien 
; 
;         Based on the 'frogd' linux client by Regis 'Redge' Barbier 
;         http://www.redge.net/frogd/fr/ 

; ------------------------------------------------------------------------------------------------------------------------ 
; ------------------------------------------------------------------------------------------------------------------------ 
; Code von mir angepasst (noch nicht fertig aber funktioniert schon)  :)
; Info, Kritik, Lob, usw. nehme ich gerne entgegen pinco_palla@web.de
; ------------------------------------------------------------------------------------------------------------------------ 
; ------------------------------------------------------------------------------------------------------------------------ 
Global *File                                          ; File = COM Port 
Global NewList SerData.s()                                   ; List der Empfangene Daten
; ------------------------------------------------------------------------------------------------------------------------ 
Structure DCB2                                        ;
  DCBlength.l                                         ; sizeof(DCB) 
  BaudRate.l                                          ; current baud rate 
  Flags.l                                             ; Info darüber in Win32 Help
  wReserved.w                                         ; not currently used 
  XonLim.w                                            ; transmit XON threshold 
  XoffLim.w                                           ; transmit XOFF threshold 
  ByteSize.b                                          ; number of bits/byte, 4-8 
  Parity.b                                            ; 0-4=no,odd,even,mark,space 
  StopBits.b                                          ; 0,1,2 = 1, 1.5, 2 
  XonChar.b                                           ; Tx and Rx XON character 
  XoffChar.b                                          ; Tx and Rx XOFF character 
  ErrorChar.b                                         ; error replacement character 
  EofChar.b                                           ; end of input character 
  EvtChar.b                                           ; received event character 
  wReserved1.w                                        ; reserved; do not use 
EndStructure                                          ;
; ------------------------------------------------------------------------------------------------------------------------ 
Procedure InitIt()                                    ; Initzialisiert die Serielle Schnittstelle
  port.s="COM3:"                                      ; Hier wird die COM3 verwendet da ich ein USB2Serial Adapter verwende
  *File = OpenComPort(0, port   )                     ; Öffnet die Serielle Schnittstelle
  If *File                                            ; Wenn geöffnet
    If GetCommState_(*File, @PortConfig.DCB2)         ; 
      SetupComm_(*File, 1024, 1024)                   ; Input / Output Buffer Größe
      ct.COMMTIMEOUTS                                 ; Info darüber in Win32 Help
      ct\ReadIntervalTimeout         = 10             ; <<==   Anpassen an die Bedurfnisse
      ct\ReadTotalTimeoutMultiplier  = 5              ; <<==   der angeschlossene Gerät
      ct\ReadTotalTimeoutConstant    = 5              ; <<==   eventuell durch experimentieren
      ct\WriteTotalTimeoutMultiplier = 5              ; <<==   z.B. wenn weniger Bytes empfangen
      ct\WriteTotalTimeoutConstant   = 5              ; <<==        werden als erwartet
      SetCommTimeouts_(*File, ct)                     ;
      dcb.DCB2;                                       ;
      GetCommState_(*File, @dcb)                      ;
      dcb\BaudRate  = #CBR_9600;                      ; ==>> Baudrate <<==
      dcb\Parity    = #NOPARITY;                      ; ==>> Parity   <<==
      dcb\StopBits  = #ONESTOPBIT;                    ; ==>> StopBits <<==
      dcb\ByteSize  = 8                               ; ==>> ByteSize <<==
      dcb\Flags     = 0                               ; Info darüber in Win32 Help
      SetCommState_(*File, @dcb)                      ;
      ; Hard Reset                                    ;
      ;EscapeCommFunction_(*File,#SETDTR)             ; Von mir nicht verwendet
      ;EscapeCommFunction_(*File,#CLRRTS)             ;   aber in das PureFrog Original Code
      ;EscapeCommFunction_(*File,#CLRDTR)             ;   zum Resetten der PureFrog-Sensor
      ;EscapeCommFunction_(*File,#SETRTS)             ;
    EndIf                                             ;
  Else                                                ; Öffnen der Serielle Schnittstelle fehlgeschlagen
    MessageRequester("SerTest","Can't open the following port: "+port+Chr(10)+"This port is may be in use", #MB_ICONERROR) 
    End                                               ;
  EndIf                                               ;
EndProcedure                                          ;
; ------------------------------------------------------------------------------------------------------------------------ 
Procedure ShowList()                                  ; Zeigt das Inhalt der Listbox in der Console
  For i=0 To CountList(SerData())-1                   ; Geht die Item des Listbox durch   
    SelectElement(SerData(), i)                       ;
    PrintN(RSet(Str(i+1),2,"0")+":"+SerData())        ; Ausgabe in der Form: ZeileNr:Empfangene Zeile
  Next                                                ;
EndProcedure                                          ;
; ------------------------------------------------------------------------------------------------------------------------ 
; Procedure zum lesen der Daten aus der Serielle Schnittstelle 
;   Command$ ist das Befehl zum uC
;   Empfangene Daten werden in ein Listbox untergebracht und dann in der Console ausgegeben
; ------------------------------------------------------------------------------------------------------------------------ 
Procedure GetSerialData(Command$)                     ;
   ; File = COM-Port aus welche gelesen wird
   PurgeComm_(*File, #PURGE_TXCLEAR | #PURGE_RXCLEAR) ; Löscht Input und Output Buffer
   WriteString(0,Command$+Chr(13))                      ; Sendet Befehl an der uC und fügt CR hinzu 
   rd.b                                               ; Gelesene Byte aus der uC
   String$ = ""                                       ; String die in das Listbox hinzugefügt wird
   ClearList(SerData())                               ; Löscht/Initializiert das Listbox 
   While ReadData(0,@rd, 1)                             ; Liest ein Byte aus der Serielle Schnittstelle
                                                      ;   ==>> IN rd IST DAS GELESEN BYTE AUS DER SCHNITTSTELLE <<==
     If rd=10                                         ; Wenn LF 
       SerData()=String$                              ;   dann fügt String in Listbox hinzu
       String$=""                                     ;   löscht Inhalt der String
     ElseIf rd=13                                     ; Wenn CR
       AddElement(SerData())                          ;   Bereitet neue Eintrag für Listbox
     ElseIf Chr(rd)="#"                               ; Das uC signialisiert das ende der Sendung mit #
       AddElement(SerData()) 
       SerData()=Chr(rd) 
     Else                                             ; Sonst ist ein Charachter empfangen worden
       String$+Chr(rd)                                ;   fügt es der String hinzu
     EndIf                                            ;

   Wend                                               ; Wenn kein Charachter mehr empfangen ( Timeout )
   ShowList()                                         ;   dann zeigt das Inhalt der Listbox in der Console
EndProcedure                                          ;
; ------------------------------------------------------------------------------------------------------------------------ 
OpenConsole()                                         ; Augabe erfolg in eine Console
;-----------------------------------------------------;
InitIt()                                              ; Initializiert die Serielle Schnittstelle
GetSerialData("help")                                 ; Sendet das Befehl "help" an das uC
GetSerialData("dc 0 F")                               ; Sendet Befehl "dc" (Display Programm Memory) an das uC
GetSerialData("a 0")                                  ; usw.
GetSerialData("nop")                                  ; 
GetSerialData(".")                                    ; 
GetSerialData("U 0 3")                                ; 
;-----------------------------------------------------;
Input()                                               ; Enter für beenden
CloseConsole()                                        ; Schliesst die Console
End                                                   ;
; ------------------------------------------------------------------------------------------------------------------------ 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
