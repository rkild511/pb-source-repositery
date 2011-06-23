; www.purebasic.com
; Author: Dominique Bodin (updated for PB4.00 by blbltheworm)
; Date: 14. January 2003
; OS: Windows
; Demo: No
;
; ------------------------------------------------------------
;
;                      PureBasic
;              - MP3 Player example file -
;             Also able to play: .wav, .mid
;
;          (c) 2003 - Dominique Bodin
;              bodind@club-internet.fr
;
; ------------------------------------------------------------
;
;
;  My first program made with PureBasic and the help of the language créator
;                             Frederic Laboureur
;
;  A real pleasure to finaly find a so powerfull language !
;
;  Not realy optimised but next release will be better !
;  with Shuffle and Sorted combobox.
;
; ************************************************************
;
;How to:
;
;  Just select the directory where your MP3 are, then OK.
;  Make your sélections:
;    * PlayAll: will play all MP3 contained in the selected directory.
;    * Always: if PlayAll is selected, the same song will be played again & again . . .
;              else all songs will be played and back to the first one, go on again  . ;
;


Global MciReponse.s, MessErreur.s, Buffer.s, TimeLeft.l, TotalTime.l, NbSongs.l, SongPlaying.l
Global PauseActif.b, *Resultat.l, Rep.s

Rep = "c:\"


; Some constants to make easier the Gadget's recognition.
  #GADGET_Play         = 0
  #GADGET_Stop         = 1
  #GADGET_ChampRep     = 2
  #GADGET_ListMP3      = 3
  #GADGET_ChoixRep     = 4
  #GADGET_ToPlay       = 5
  #GADGET_Rest         = 6
  #GADGET_TotalToPlay  = 7
  #GADGET_TotalRest    = 8
  #GADGET_PlayAll      = 9
  #GADGET_Always       = 11
  #GADGET_Pause        = 12


; Processing of text instructions to be send to the Window's MCI API.
Procedure.l Mci(Cde.s)  
  Retour.l = mciSendString_(Cde, *Resultat, 256, 0)
  MciReponse = PeekS(*Resultat)
  ProcedureReturn Retour
EndProcedure


; Transform Time results from MCI instructions into useable forms.
Procedure.s GetHourFormat(LengthInSeconds)
  Minutes.l = LengthInSeconds / 60
  Seconds.l = LengthInSeconds - Minutes*60
  If Seconds < 10  ; Then seconds will be written as 01, 02, or 03 instead of 1, 2, or 3
    Null$ = "0"
  Else
    Null$ = ""
  EndIf

  ProcedureReturn Str(Minutes)+":"+Null$+Str(Seconds)
EndProcedure


Procedure PlayMCI(ToPlay.s)
  If Mci("open " + Chr(34) + GetGadgetText(#GADGET_ChampRep) + ToPlay + Chr(34) + " alias Morceau") <> 0
    MessageRequester("MP3 Error", "Error openning MP3 File !", #MB_ICONERROR)
      
  Else
    DisableGadget(#GADGET_Play, 1)
    DisableGadget(#GADGET_Stop, 0)
    DisableGadget(#GADGET_Pause, 0)
    DisableGadget(#GADGET_ChoixRep, 1)
    DisableGadget(#GADGET_ListMP3, 1)
    
    Mci("set Morceau time format ms")
    
    Mci("seek Morceau to end wait")      ; Go to the end of Song
    Mci("status Morceau position wait")  ; Remember the end's position
    TotalTime = Val(MciReponse)
    SetGadgetText (#GADGET_TotalRest, GetHourFormat(TotalTime/1000))
    
    Mci("seek Morceau to start")
    Mci("play Morceau from 1 notify")
    
  EndIf
EndProcedure


;
; Now, open a window, and do some stuff with it...
;

If OpenWindow(0, 100, 100, 315, 125, "MP3 Player with - PureBasic -", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget)
  
  *Resultat = GlobalAlloc_(#GMEM_FIXED, 256)  ; We get a handle on an allocated memory zone.
  
  ResizeWindow(0,400,300,#PB_Ignore,#PB_Ignore)   ; Move the window to the coordinate 400,300

  If CreateGadgetList(WindowID(0))
    StringGadget(#GADGET_ChampRep, 10, 10, 225, 20, "")
    SetGadgetText(#GADGET_ChampRep, "C:\")

    ButtonGadget(#GADGET_ChoixRep, 245, 8,  60 , 24, "Select Dir")
    ButtonGadget(#GADGET_Play   ,  10,  70,  60 , 24, "Play")
    ButtonGadget(#GADGET_Pause  ,  92,  70,  60 , 24, "Pause")
    ButtonGadget(#GADGET_Stop   ,  174, 70,  60 , 24, "Stop")
    
    CheckBoxGadget(#GADGET_PlayAll,245, 35, 60 , 24, "Play All")
    CheckBoxGadget(#GADGET_Always, 245, 56, 60 , 24, "Always")
    
    ComboBoxGadget(#GADGET_ListMP3,10, 40,  225, 100)
    TextGadget(#GADGET_ToPlay,     10, 105, 60,  24, "Playing :")
    TextGadget(#GADGET_Rest,       60, 105, 30,  24, "")
    
    TextGadget(#GADGET_TotalToPlay,100, 105, 70, 24, "Total to Play :")
    TextGadget(#GADGET_TotalRest,  180, 105, 70, 24, "")

  EndIf
  
  DisableGadget(#GADGET_Play, 1)
  DisableGadget(#GADGET_Pause, 1)
  DisableGadget(#GADGET_Stop, 1)
  DisableGadget(#GADGET_ChampRep, 1)
  DisableGadget(#GADGET_ListMP3, 1)
  SetGadgetState(#GADGET_PlayAll, 1)
  SetGadgetText(#GADGET_TotalRest, "0:00.")  ; The '.' is needed for the end's détection.
  
  ;
  ; This is the 'event loop'. All the user actions are processed here.
  ; It's very easy to understand: when an action occurs, the EventID
  ; isn't 0 and we just have to see what have happened...
  ;
  Repeat  ; Go on until the user decide to Quit.
    
    Repeat  ; Waiting for an event's coming.
      EventID.l = WindowEvent()
      
      If EventID = 0  ; We wait only when nothing is being done
        Sleep_(20)
      EndIf
      
    ; To see what the time is.
      Mci("status Morceau position")
      TimeLeft = Val(MciReponse)
      SetGadgetText (#GADGET_Rest, GetHourFormat(TimeLeft/1000))
      
    ; If we are at the end.
      If GetGadgetText(#GADGET_Rest) = GetGadgetText(#GADGET_TotalRest)
        Mci("close Morceau")
        
      ; When the checbox 'Play All songs' is selected.
        If GetGadgetState(#GADGET_PlayAll)
          SongPlaying = GetGadgetState(#GADGET_ListMP3) + 1  ; We will play the next one.
          
        ; If there is another song to play, we continue.
          If SongPlaying < NbSongs
            SetGadgetState(#GADGET_ListMP3, SongPlaying )
            CurrentMP3.s = GetGadgetText(#GADGET_ListMP3)
            PlayMCI(CurrentMP3)
          EndIf
          
          If SongPlaying = NbSongs And GetGadgetState(#GADGET_Always)
            SetGadgetState(#GADGET_ListMP3, 0)
            CurrentMP3 = GetGadgetText(#GADGET_ListMP3)
            PlayMCI(CurrentMP3)
          Else
            If SongPlaying = NbSongs
              DisableGadget(#GADGET_Play, 0)
              DisableGadget(#GADGET_Pause, 0)
              DisableGadget(#GADGET_Stop, 1)
              DisableGadget(#GADGET_ChoixRep, 0)
              DisableGadget(#GADGET_ListMP3, 0)
            EndIf
          EndIf
          
          
        Else
          If GetGadgetState(#GADGET_Always)
            CurrentMP3 = GetGadgetText(#GADGET_ListMP3)
            PlayMCI(CurrentMP3)
          Else
            DisableGadget(#GADGET_Play, 0)
            DisableGadget(#GADGET_Stop, 1)
            DisableGadget(#GADGET_Pause, 1)
            DisableGadget(#GADGET_ChoixRep, 0)
            DisableGadget(#GADGET_ListMP3, 0)
          EndIf
        EndIf
      EndIf

    Until EventID <> 0
    
    
    Select EventID  ; One action for each event.
      Case #PB_Event_Gadget  ; The user clicked on a Gadget.
        
        Select EventGadget()
          Case #GADGET_ChoixRep
            NbSongs = 0
            
          ; After the first sélection done, the next will begin from the same one.
            Rep = PathRequester("Select the Directory that contains the Songs files you want to listen :", Rep)
    
            If Rep
              SetGadgetText(#GADGET_ChampRep, GetPathPart(Rep))
            EndIf

            ClearGadgetItemList(#GADGET_ListMP3)  ; Clear all the items found in the ListView
            
          ; We're searching for MP3, WAV or MID if any.
            If ExamineDirectory(0, GetGadgetText(#GADGET_ChampRep), "*.*")
              Repeat
                FileType = NextDirectoryEntry(0)
                If FileType
                  FileName$ = DirectoryEntryName(0)
                  If FileName$ <> "." And FileName$ <> ".."
                    Ext$ = LCase(Right(FileName$,4)) ; Only need ".mp3", ".wav", ".mid"
                    If Ext$ = ".wav" Or Ext$ = ".mp3" Or Ext$ = ".mid"
                        AddGadgetItem(#GADGET_ListMP3, -1, FileName$)
                        NbSongs = NbSongs + 1
                    EndIf
                  EndIf
                EndIf

              Until FileType = 0
              
              DisableGadget(#GADGET_Stop, 1)
              DisableGadget(#GADGET_Pause, 1)
              DisableGadget(#GADGET_ListMP3, 0)
              DisableGadget(#GADGET_Play, 0)
              SetGadgetState(#GADGET_ListMP3, 0)

            Else
              MessageRequester("Error","Can't examine this directory: " + GetGadgetText(#GADGET_ChampRep),0)
            EndIf

          Case #GADGET_Play
            SongPlaying = 0  ; We begin with the first song in the listview.
            CurrentMP3 = GetGadgetText(#GADGET_ListMP3)
            PlayMCI(CurrentMP3)
            
          Case #GADGET_Pause
            If PauseActif = 0
              PauseActif = 1
              Mci("pause Morceau wait")
            Else
              PauseActif = 0
              Mci("play Morceau from " + Str(TimeLeft))
            EndIf
            
                                                      
          Case #GADGET_Stop
            PauseActif = 0
            Mci("close Morceau")
            SetGadgetText(#GADGET_TotalRest, "0:00.")  ; The '.' is needed for the end's détection.
            DisableGadget(#GADGET_Play, 0)
            DisableGadget(#GADGET_Pause, 1)
            DisableGadget(#GADGET_Stop, 1)
            DisableGadget(#GADGET_ChoixRep, 0)
            DisableGadget(#GADGET_ListMP3, 0)
                          
          Case #GADGET_ListMP3
            DisableGadget(#GADGET_PlayAll, 0)
            DisableGadget(#GADGET_Always, 0)
            ;DisableGadget(#GADGET_Shuffle, 0)

        EndSelect
      
      Case #PB_Event_CloseWindow
        Quit = 1

    EndSelect

  Until Quit = 1


EndIf  ; End OpenWindow

GlobalFree_(*Resultat)  ; Don't forget to Free the buffer !

End   ; All the opened windows are closed automatically by PureBasic


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; Executable = C:\PureBasic\MesExemples\PlayMP3\PlayMP3.Exe
; DisableDebugger