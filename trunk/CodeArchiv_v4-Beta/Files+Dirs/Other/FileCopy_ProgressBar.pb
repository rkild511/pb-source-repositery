; German forum: http://www.purebasic.fr/german/viewtopic.php?t=373&highlight=
; Author: isidoro (updated for PB 4.00 by Andre)
; Date: 07. October 2004
; OS: Windows
; Demo: No

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
     ;                                       ; 
     ;    FileCopy Routine mit Progressbar   ; 
     ;                                       ; 
     ;    © copyright Isidoro Okt.2004       ; 
     ;                                       ; 
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;        
; 
; 
; CopyFileEx_ Konstanten 
#PROGRESS_CONTINUE        = 0 
#PROGRESS_CANCEL          = 1 
#PROGRESS_STOP            = 2 
#PROGRESS_QUIET           = 3 
#COPY_FILE_FAIL_IF_EXISTS = 1 
#COPY_FILE_RESTARTABLE    = 2 

#ProgressWnd = 0 
Enumeration 
#CopyProgressBar 
#CopyProgressText 
#CopyProgressCancel 
EndEnumeration 


Procedure.l CopyProgressCallback(TotalFileSize , TotalBytesTransferred , StreamSize , StreamBytesTransferred , dwStreamNumber.l , dwCallbackReason.l , hSourceFile.l ); keine Ahnung Tschüss...>, hDestinationFile.l , lpData.l ) 
;##################################################################################################################################################################### 
    TotalFileSize_ = (TotalFileSize>>16) &$FFFFFFFF 
    StreamSize_    = 100 * (StreamSize>>16) &$FFFFFFFF 
    If TotalFileSize_ > 0 And StreamSize_ > 0 
      Prozent = 100 * (StreamSize>>16) &$FFFFFFFF / (TotalFileSize>>16) &$FFFFFFFF 
    Else 
      Prozent = 100 
    EndIf 
    SetGadgetState(#CopyProgressBar  , Prozent ) 
    SetGadgetText (#CopyProgressText , "Orginal: " + Str(TotalFileSize)+ " Bytes     " + Str(StreamSize)+" Bytes transfered" ) 
    If Prozent = 100 : SetGadgetText (#CopyProgressText , "Orginal: " + Str(TotalFileSize)+ " Bytes     " + Str(StreamSize)+" Bytes  finished!" ) : EndIf 
  ProcedureReturn #PROGRESS_CONTINUE 
EndProcedure 

Procedure.b CopyFileWithProgress( ExistingFileName.s , NewFileName.s , flag.b ) 
;############################################################################## 
  ProgressWndFlags = #PB_Window_TitleBar | #PB_Window_WindowCentered|#WS_POPUP 
  If flag 
    If flag = 2 : ProgressWndFlags| #PB_Window_SystemMenu | #PB_Window_SizeGadget : EndIf 
    If OpenWindow(#ProgressWnd, 216, 0, 320, 80, " Filecopy Progress ", ProgressWndFlags) 
      If CreateGadgetList(WindowID(#ProgressWnd)) 
        ProgressBar = ProgressBarGadget(#CopyProgressBar , 10 , 15 , 300 , 20 , 0 , 100 , #PB_ProgressBar_Smooth) 
        SendMessage_( ProgressBar , #CCM_SETBKCOLOR , 0 , $174B0E );  Hintergrundfarbe 
        SendMessage_( ProgressBar , #WM_USER + 9    , 0 , $43D629 );  Balkenfarbe 
        TextGadget(#CopyProgressText , 11 , 54 , 280 , 20, "") 
      EndIf 
    EndIf 
    res = CopyFileEx_( @ExistingFileName.s , @NewFileName.s , @CopyProgressCallback() , 0 , cancel , 0) 
    If flag = 2 
      Repeat 
        event = WaitWindowEvent() 
        Select event 
          Case #PB_Event_Gadget 
          Case #PB_Event_CloseWindow : Quit = 1 
        EndSelect  
      Until Quit = 1 
    EndIf 
    CloseWindow(#ProgressWnd) 
    ProcedureReturn res 
  Else 
    ProcedureReturn CopyFileEx_( @ExistingFileName.s , @NewFileName.s , 0 , 0 , 0 , 0) 
  EndIf 
EndProcedure 
  
; 
; CopyFileWithProgress( CopyFrom.s , CopyTo.s , flags.b)      
; 
; Pfade müssen angepasst werden 
; Flags: 0 = Unsichtbar - Kein Fenster geht auf, Copy im Hintergrund. 
;        1 = Fenster geht auf und schließt sich automatisch nach Beendigung. 
;        2 = Fenster bleibt offen stehen und muss vom Benutzer geschlossen werden. 


CopyReady = CopyFileWithProgress( "c:\test2.avi" , "d:\test2.bak" , 2) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -