; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6276&highlight=
; Author: paulr
; Date: 27. September 2003
; OS: Windows
; Demo: No


; The following program sends a quick message to the COM1 port, and waits
; 5 secs for a response. I've used it to communicate with a Palm IIIe PDA
; running 'ptelnet' - a terminal program. 

Port$ = "COM1:" 
*File = OpenComPort(0, Port$) 

If *File 

  SetupComm_(*File, 4096, 4096) ; Set i/o buffers 

  ; Change timeout settings: 

  ct.COMMTIMEOUTS 
  ct\ReadIntervalTimeout         = #MAXDWORD 
  ct\ReadTotalTimeoutMultiplier  = 0 
  ct\ReadTotalTimeoutConstant    = 0 
  ct\WriteTotalTimeoutMultiplier = 0 
  ct\WriteTotalTimeoutConstant   = 0 

  SetCommTimeouts_(*File, ct) 

  ; Get protocol settings: 
  
  dcb.DCB 
  GetCommState_(*File, @dcb) 
  
  ; Change protocol settings: 
  
  dcb\BaudRate  = #CBR_9600 
  dcb\Parity    = #NOPARITY 
  dcb\StopBits  = #ONESTOPBIT 
  dcb\ByteSize  = 8 
  dcb\Fbits     = %1000010000011 ; Flags copied from PureFrog (see Microsoft dev site for details) 

  SetCommState_(*File, @dcb) 

  ; Send message to serial port: 

  WriteString(0,"Serial output") 
  
  a$ = " " 
  String$ = "" 

  Delay(5000) 

  While ReadData(0,@a$, 1) 
    String$ + a$ 
  Wend 

  Debug "String is: "+String$ 
  
Else 

  Debug "Can't open COM port." 

EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
