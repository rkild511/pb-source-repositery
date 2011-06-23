; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7009&highlight=
; Author: Flype (updated for PB3.93 by Andre, updated for PB4.00 by blbltheworm)
; Date: 27. July 2003
; OS: Windows
; Demo: No


; Here is a program (by me) that shows how to capture audio under windows without using
; MCI functions. Raw sound is saved in a file... which can be loaded and listened thanx
; a software like SoundForge. 

; Raw format sound generated : 16bit, Mono, 44100Hz 

; You have to configure the Volume Control (use the volume systray icon) in order to select
; Stereo Mixer (Menu->Properties->Record...). You should also set the volume not too high... 


;*********************************************************************************** 
;- DECLARATIONS                                ; SOUND CAPTURE, Flype (26-juil-2002) 
;*********************************************************************************** 


Declare CAPTURE_Read( hWaveIn.l, lpWaveHdr.l ) 
Declare CAPTURE_Error( err.l ) 
Declare CAPTURE_Start() 
Declare CAPTURE_Stop() 
Declare CAPTURE_Draw() 
Declare CAPTURE_Now() 

Declare GUI_CallBack( hWnd.l, Message.l, wParam.l, lParam.l ) 
Declare GUI_Button( id.l, ico.l, tip.s ) 
Declare GUI_Init() 
Declare GUI_Main() 
Declare GUI_Resize() 

Declare FILE_Recording( state.b ) 
Declare FILE_Create() 
Declare FILE_Append() 
Declare FILE_Close() 


;*********************************************************************************** 
;- INIT CONFIGURABLE CONSTANTES 
;*********************************************************************************** 


#SOUND_NCHANNELS   = 1      ; This example only support Mono 
#SOUND_NBITS       = 16     ; This example only support 16bits 
#SOUND_NHERTZ      = 44100  ; Try 8000, 11050, 22100, 44100... 

#BUFFER_NUM        = 8      ; Number of buffer for capture 
#BUFFER_SIZE       = 512    ; Size of each buffer, should be x2 in Stereo 
#BUFFER_TICK       = 10     ; Wave redraw delay : SetTimer_ in CAPTURE_Start() 


;*********************************************************************************** 
;- INIT CONSTANTES 
;*********************************************************************************** 

#winMain=0

#gadRecord   =  0 
#gadStop     =  1 
#gadMode     =  2 

#StatusBar   =  0 
#StatusTime  =  0 
#StatusInfo  =  1 
#StatusFile  =  2 

#COLOR_RECBACK  = $000050 
#COLOR_RECLINE  = $000035 
#COLOR_RECWAVE  = $1010E0 
#COLOR_CAPBACK  = $004900 
#COLOR_CAPLINE  = $004000 
#COLOR_CAPWAVE  = $20E020 
#COLOR_VOLUME   = $00FFFF 

#STR_ERROR      = "Error" 
#STR_STOP       = "Stop" 
#STR_RECORD     = "Record" 
#STR_CLOSED     = "File saved" 
#STR_SAVEREQ    = "Choose a file..." 
#STR_MODE       = "Display mode" 
#STR_RECORDED   = " bytes recorded" 
#STR_PBFILE     = "Problem while creating file" 
#STR_NODEVICE   = "Audio device not found" 


;*********************************************************************************** 
;- INIT STRUCTURES 
;*********************************************************************************** 


Structure RECORD_INFO 
  x.l          ; Left 
  y.l          ; Top 
  w.l          ; Width 
  h.l          ; Height 
  m.l          ; YMiddle 
  cback.l      ; Back color 
  cline.l      ; Line color 
  cwave.l      ; Wave color 
  size.l       ; Wave buffer size 
  buffer.l     ; Wave buffer pointer 
  output.l     ; WindowOutput() 
  mode.b       ; Wave mode (line or plain) 
  wave.l       ; Address of waveform-audio input device 
  frame.b      ; Counter for back clearing 
  update.b     ; If true Wave have to be redrawn 
  recorded.l   ; Number of bytes recorded 
  recording.b  ; Record is running... 
  time.s       ; Store the time string 
EndStructure 

Structure WAVEFORMATEX 
  wFormatTag.w 
  nChannels.w 
  nSamplesPerSec.l 
  nAvgBytesPerSec.l 
  nBlockAlign.w 
  wBitsPerSample.w 
  cbSize.w 
EndStructure 

Global Dim inHdr.WAVEHDR( #BUFFER_NUM ) 
Global inHdr, rec.RECORD_INFO, now.SYSTEMTIME 
rec\time = Space(9) 


;*********************************************************************************** 
;- PROCS CAPTURE 
;*********************************************************************************** 


Procedure CAPTURE_Error( err.l ) 
  If err 
    text.s = Space( #MAXERRORLENGTH ) 
    waveInGetErrorText_( err, text, #MAXERRORLENGTH ) 
    MessageRequester( #STR_ERROR, text, #MB_ICONERROR ) 
    CAPTURE_Stop() 
    End 
  EndIf 
EndProcedure 

;============================================================================== 

Procedure CAPTURE_Now() 
  GetLocalTime_( @now ) 
  GetTimeFormat_(0, 0, @now, "HH:mm:ss:", @rec\time, 9 ) 
  StatusBarText( #StatusBar, #StatusTime, rec\time+Str(now\wMilliseconds) ) 
EndProcedure 

;============================================================================== 

Procedure CAPTURE_Draw() 
  If rec\update = #True 
    CAPTURE_Now() 
    StartDrawing( rec\output ) 
      ; Draw Background... 
      If rec\frame = 2 
        Box( rec\x, rec\y, rec\w, rec\h, rec\cback ) 
        shift = rec\h >> 2 
        Line( rec\x, rec\m - shift, rec\w, 0, rec\cline ) 
        Line( rec\x, rec\m + shift, rec\w, 0, rec\cline ) 
        rec\frame = 0 
      Else 
        rec\frame + 1 
      EndIf 
      ; Draw Wave Data 
      oldx = rec\x : oldy = 0 
      For i=0 To rec\size Step #Word 
        value = PeekW( rec\buffer + i ) 
        x = rec\x + ( i * rec\w-1 ) / rec\size 
        y = ( value * rec\h ) / $FFFF 
        If value > max : max = value : EndIf 
        If x <> oldx 
          Select rec\mode 
            Case #True  : LineXY(oldx,rec\m+oldy,x,rec\m+y,rec\cwave) 
            Case #False : LineXY(oldx,rec\m+oldy,x,rec\m-y,rec\cwave) 
          EndSelect 
          oldx=x : oldy=y 
        EndIf 
      Next 
      ; Draw Volume 
      Box(rec\x+1,rec\h+rec\y-5,(max*(rec\w-2))/$7FFF,2,#COLOR_VOLUME) 
    StopDrawing() 
    rec\update = #False 
  EndIf 
EndProcedure 

;============================================================================== 

Procedure.s CAPTURE_GetDevice() 
  Caps.WAVEINCAPS 
  For i=0 To waveInGetNumDevs_()-1 
    CAPTURE_Error( waveInGetDevCaps_( i, @Caps, SizeOf( WAVEINCAPS ) ) ) 
    If Caps\dwFormats & #WAVE_FORMAT_1S08 
      ProcedureReturn PeekS( @Caps\szPname, 32 ) 
    EndIf 
  Next 
  ProcedureReturn #STR_NODEVICE 
EndProcedure 

;============================================================================== 

Procedure CAPTURE_Start() 
  DeviceName.s = CAPTURE_GetDevice() 
  If DeviceName 
    SetWindowText_( WindowID(#winMain), DeviceName ) 
    format.WAVEFORMATEX 
    format\wFormatTag      = 1 
    format\nChannels       = #SOUND_NCHANNELS 
    format\wBitsPerSample  = #SOUND_NBITS 
    format\nSamplesPerSec  = #SOUND_NHERTZ 
    format\nBlockAlign     = #SOUND_NCHANNELS * (#SOUND_NBITS/8) 
    format\nAvgBytesPerSec = #SOUND_NHERTZ * format\nBlockAlign 
    format\cbSize          = 0 
    CAPTURE_Error(waveInOpen_( @rec\wave, #WAVE_MAPPER, @format, WindowID(0), #Null, #CALLBACK_WINDOW|#WAVE_FORMAT_DIRECT ) ) 
    For i = 0 To #BUFFER_NUM - 1 
      inHdr(i)\lpData         = AllocateMemory(#BUFFER_SIZE ) 
      inHdr(i)\dwBufferLength = #BUFFER_SIZE 
      CAPTURE_Error( waveInPrepareHeader_( rec\wave, inHdr(i), SizeOf( WAVEHDR ) ) ) 
      CAPTURE_Error( waveInAddBuffer_    ( rec\wave, inHdr(i), SizeOf( WAVEHDR ) ) ) 
    Next 
    CAPTURE_Error( waveInStart_( rec\wave ) ) 
    SetTimer_( WindowID(#winMain), 0, #BUFFER_TICK, 0 ) 
  EndIf 
EndProcedure 

;============================================================================== 

Procedure CAPTURE_Stop() 
  If rec\wave 
    CAPTURE_Error( waveInReset_( rec\wave ) ) 
    CAPTURE_Error( waveInStop_ ( rec\wave ) ) 
    For i = 0 To #BUFFER_NUM - 1 
      CAPTURE_Error( waveInUnprepareHeader_( rec\wave, inHdr(i), SizeOf( WAVEHDR ) ) ) 
    Next 
    CAPTURE_Error( waveInClose_( rec\wave ) ) 
  EndIf 
  KillTimer_( WindowID(#winMain), 0 ) 
EndProcedure 

;============================================================================== 

Procedure CAPTURE_Read( hWaveIn.l, lpWaveHdr.l ) 
  CAPTURE_Error( waveInAddBuffer_( hWaveIn, lpWaveHdr, SizeOf( WAVEHDR ) ) ) 
  rec\buffer  = PeekL( lpWaveHdr ) 
  rec\size    = PeekL( lpWaveHdr + 8 ) 
  rec\update  = #True 
  FILE_Append() 
EndProcedure 


;*********************************************************************************** 
;- PROCS FILE 
;*********************************************************************************** 


Procedure FILE_Create() 
  File.s = SaveFileRequester( #STR_SAVEREQ, "C:\test.raw", "Son brut|(*.raw)", 0 ) 
  If File 
    If CreateFile( 0, File ) 
      FILE_Recording( #True ) 
      StatusBarText( #StatusBar, #StatusFile, File ) 
    Else 
      MessageRequester( #STR_ERROR, #STR_PBFILE, #MB_ICONERROR ) 
    EndIf 
  EndIf 
EndProcedure 

;============================================================================== 

Procedure FILE_Append() 
  If rec\recording = #True 
    rec\recorded + rec\size 
    WriteData(0, rec\buffer, rec\size ) 
    StatusBarText( #StatusBar, #StatusInfo, Str(rec\recorded) + #STR_RECORDED ) 
  EndIf 
EndProcedure 

;============================================================================== 

Procedure FILE_Recording( state.b ) 
  If state = #True 
    rec\cback = #COLOR_RECBACK 
    rec\cline = #COLOR_RECLINE 
    rec\cwave = #COLOR_RECWAVE 
  Else 
    rec\cback = #COLOR_CAPBACK 
    rec\cline = #COLOR_CAPLINE 
    rec\cwave = #COLOR_CAPWAVE 
  EndIf 
  DisableToolBarButton(0, #gadRecord, state ) 
  DisableToolBarButton(0, #gadStop, #True-state ) 
  rec\recording = state 
  rec\recorded = 0 
EndProcedure 

;============================================================================== 

Procedure FILE_Close() 
  If rec\recording = #True 
    FILE_Recording( #False ) 
    CloseFile(0) 
    StatusBarText( #StatusBar, #StatusFile, #STR_CLOSED ) 
  EndIf 
EndProcedure 


;*********************************************************************************** 
;- PROCS GUI 
;*********************************************************************************** 


Procedure GUI_Button( id.l, ico.l, tip.s ) 
  ToolBarStandardButton( id, ico ) 
  ToolBarToolTip(0, id, tip ) 
EndProcedure 

;============================================================================== 

Procedure GUI_Init() 
  hFlags.l = #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered 
  If OpenWindow( #winMain, 0,0,320,160, "" , hFlags) = #Null 
    ProcedureReturn #False 
  EndIf 
  If CreateToolBar( 0, WindowID(#winMain) ) = #Null 
    ProcedureReturn #False 
  EndIf 
  If CreateGadgetList( WindowID(#winMain) ) = #Null 
    ProcedureReturn #False 
  EndIf 
  Frame3DGadget( 0, 0,0,0,0, "", #PB_Frame3D_Double ) 
  If CreateStatusBar( #StatusBar, WindowID(#winMain) ) = #Null 
    ProcedureReturn #False 
  EndIf 
  rec\output = WindowOutput(#winMain) 
  GUI_Button( #gadRecord, #PB_ToolBarIcon_Save,       #STR_RECORD ) 
  GUI_Button( #gadStop,   #PB_ToolBarIcon_Delete,     #STR_STOP   ) 
  GUI_Button( #gadMode,   #PB_ToolBarIcon_Properties, #STR_MODE   ) 
  AddStatusBarField(   80 ) 
  AddStatusBarField(  150 ) 
  AddStatusBarField( $FFF ) 
  ProcedureReturn #True 
EndProcedure 

;============================================================================== 

Procedure GUI_Resize() 
  rec\x = 2 
  rec\y = 30 
  rec\w = WindowWidth(#winMain)-4 
  rec\h = WindowHeight(#winMain)-52 
  rec\m = rec\y + rec\h / 2 
  ResizeGadget( 0, rec\x-2, rec\y-2, rec\w+4, rec\h+4 ) 
EndProcedure 

;============================================================================== 

Procedure GUI_CallBack( hWnd.l, uMsg.l, wParam.l, lParam.l ) 
  Result.l = #PB_ProcessPureBasicEvents 
  Select uMsg 
    Case #MM_WIM_DATA : CAPTURE_Read( wParam, lParam ) 
    Case #WM_TIMER    : CAPTURE_Draw() 
    Case #WM_SIZE     : GUI_Resize() 
    Case #WM_CLOSE    : Quit = #True 
    Case #WM_COMMAND 
      Select wParam 
        Case #gadRecord : FILE_Create() 
        Case #gadStop   : FILE_Close() 
        Case #gadMode   : rec\mode = #True-rec\mode 
      EndSelect 
  EndSelect 
  ProcedureReturn Result 
EndProcedure 

;============================================================================== 

Procedure GUI_Main() 
  If GUI_Init() 
    SetWindowCallback( @GUI_CallBack() ) 
    FILE_Recording( #False )  
    GUI_Resize() 
    CAPTURE_Start() 
    While WaitWindowEvent()<>#WM_CLOSE : Wend 
    CAPTURE_Stop() 
  EndIf 
EndProcedure 


;*********************************************************************************** 
;- START 
;*********************************************************************************** 


GUI_Main() 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ---
; EnableXP
; DisableDebugger
