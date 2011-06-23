; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6544&highlight=
; Author: Rings
; Date: 13. June 2003
; OS: Windows
; Demo: No


; Redirect the output from a compiler ....


; Redirect Outputs into Memory
; coded by Siegfried Rings march 2002
; redirected the pipes
;
;see http://support.microsoft.com/default.aspx?scid=kb;EN-US;q173085
;

mCommand.s="ping"

;Structure used by the CreateProcessA function
;another then that Fred implemented !
Structure MySTARTUPINFO
  cb.l
  lpReserved.l
  lpDesktop.l
  lpTitle.l
  dwX.l
  dwY.l
  dwXSize.l
  dwYSize.l
  dwXCountChars.l
  dwYCountChars.l
  dwFillAttribute.l
  dwFlags.l
  wShowWindow.w
  cbReserved2.w
  lpReserved2.l
  hStdInput.l
  hStdOutput.l
  hStdError.l
EndStructure

proc.PROCESS_INFORMATION ;Process info filled by CreateProcessA
ret.l ;long variable For get the Return value of the
start.MySTARTUPINFO ;StartUp Info passed To the CreateProceeeA
sa.SECURITY_ATTRIBUTES ;Security Attributes passeed To the
hReadPipe.l ;Read Pipe handle created by CreatePipe
hWritePipe.l ;Write Pite handle created by CreatePipe
lngBytesread.l ;Amount of byte Read from the Read Pipe handle
strBuff.s=Space(256) ;String buffer reading the Pipe

;Consts For functions
#NORMAL_PRIORITY_CLASS = $20
#STARTF_USESTDHANDLES = $100
#STARTF_USESHOWWINDOW = $1

;Create the Pipe
sa\nLength =SizeOf(SECURITY_ATTRIBUTES) ;Len(sa)
sa\bInheritHandle = 1
sa\lpSecurityDescriptor = 0
ret = CreatePipe_(@hReadPipe, @hWritePipe, @sa, 0)
If ret = 0
  ;If an error occur during the Pipe creation exit
  MessageRequester("info", "CreatePipe failed. Error: ",0)
  End
EndIf


start\cb = SizeOf(MySTARTUPINFO)
start\dwFlags = #STARTF_USESHOWWINDOW | #STARTF_USESTDHANDLES

;set the StdOutput And the StdError output To the same Write Pipe handle
start\hStdOutput = hWritePipe
start\hStdError = hWritePipe

;Execute the command
ret = CreateProcess_(0, mCommand, sa, sa, 1, #NORMAL_PRIORITY_CLASS, 0, 0, @start, @proc)

If ret <> 1
  MessageRequester("Info","File Or command not found", 0)
  End
Else
  ;MessageRequester("Info","PRG started..:",0)
EndIf


;Now We can ... must close the hWritePipe
ret = CloseHandle_(hWritePipe)

mOutputs.s = ""

;Read the ReadPipe handle
While ret<>0
  ret = ReadFile_(hReadPipe, strBuff, 255, @lngBytesread, 0)
  If lngBytesread>0
    mOutputs = mOutputs + Left(strBuff, lngBytesread)
  EndIf
Wend

;Close the opened handles
ret = CloseHandle_(proc\hProcess)
ret = CloseHandle_(proc\hThread)
ret = CloseHandle_(hReadPipe)
;ret=CloseHandle_(hWritePipe)

;Return the Outputs property with the entire DOS output
MessageRequester("Info",mOutputs,0)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
