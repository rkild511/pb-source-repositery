; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6787&highlight=
; Author: naw (updated for PB3.93 by Andre, updated for PB4.00 by blbltheworm)
; Date: 06. July 2003
; OS: Windows
; Demo: No


; Hi, My little attempt at an MP3 Hands Free DJ tool... 

; I DJ at dance events sometimes but hate DJing, much rather have a boogie, so this lets
; me have the best of both worlds.

; Basically, tracks can be loaded/appended from individual MP3 files or collectively via
; M3U files through the "PlayList Manager" 

; Tracks are played from the "Track Manager", you can skip forward, back, next / previous
; track, pause Or stop etc - The tracks' progress is displayed via a Slider Gadget and 
; you can set the Volume / Fade In / FadeOut for individual tracks and *record* those
; settings using the "O" Button, the entry is recorded into a PlayerTracks.db file. 

; "Volume" and "Balance" are set using two miniature Sliders. 

; The "TrackList Manager" lets you do some rudimentary / simple reordering of the "PlayList"
; using the "A" And "V" Buttons. 

; You can insert a "STOP" using the "!" button And delete individual tracks (including any
; "STOPs" you insert with "X". 

; The PlayerTracks.db file is seperate from any *.M3U files so individual Volume / FadeIn /
; FadeOut settings may apply to *.MP3 files that are common accross many *.M3U files. 

; If you create an icons directory, the "Text" buttons will be replaced by graphical buttons.
; The files are: 
; back.ico, delete.ico, fwd.ico, next.ico, pause.ico, play.ico, prev.ico, record.ico, stop.ico. 

; email me And I'll send the icons I created  


; Things To do: 
; I'd like to add some ID3 Tag Reading functionality to get Artist, Tempo etc but have struggled
; to find a library or function that reliably extracts that info. 
; I'd really like to add some facility to alter the Pitch / Tempo of a track - but suspect that
; is way beyond my ability (can anyone out there help?) 


;- Code
; PureBasic Visual Designer v3.62 


;- MenuBar Constants 
; 
#MenuBar_9 = 0 
#MENU_1 = 1 
#MENU_2 = 2 
#MENU_3 = 3 
#MENU_6 = 4 
#MENU_4 = 5 

;- Gadget Constants 
; 
#STATUS=0 
#B_PLAYLIST = 1 
#LOAD = 2 
#SAVE = 3 
#DELETE_ = 4 
#PROGRESS = 5 
#FADEIN = 6 
#FADEOUT = 7 
#VOLUME = 8 
#T_PROGRESS = 9 
#T_START = 10 
#T_STOP = 11 
#BALANCE = 12 
#PLAYLIST_FILE = 13 
#B_TRACKLIST = 14 
#TRACKINFO = 15 
#REW = 16 
#FF_ = 17 
#PAUSE = 18 
#PLAY = 19 
#STOP = 20 
#PREV = 23 
#NEXT = 24 
#TRACKLIST = 25 
#PLAYLIST = 26 
#RECORD = 29 

;-PlayList AutoNav* 
#PL_MOVEDN = 21 
#PL_MOVEUP = 22 
#PL_DELTRK =27 
#PL_STOP=28 

#IMG_STOP=9 

#IMG_PLAY=1 
#IMG_PAUSE=2 
#IMG_FWD=3 
#IMG_REW=4 
#IMG_PREV=5 
#IMG_NEXT=6 
#IMG_DEL=7 
#IMG_REC=8 

;- StatusBar Constants 
; 
#StatusBar_11 = 0 

;- Other Stuff 

Define.l 
#FRAMEDIV=1000000000 
#DEBUG=1 
#DELAY=10 
Global TRACKCTR 
TRACKCTR=0 

Global MovieID.l



Procedure.s ReadINI(section.s,key.s,empty.s,inifile.s) 
  result.s=Space(255) 
  GetPrivateProfileString_(section,key,empty,@result,255,inifile) 
  ProcedureReturn result.s 
EndProcedure 


Procedure.l WriteINI(section.s,key.s,value.s,inifile.s) 
  ProcedureReturn WritePrivateProfileString_(section,key,value,inifile) 
EndProcedure 


Procedure Open_Window_0() 
  If OpenWindow(0, 343, 80, 614, 349, "New window ( 0 )", #PB_Window_Invisible | #PB_Window_SystemMenu |#PB_Window_TitleBar | #PB_Window_BorderLess | #PB_Window_ScreenCentered ) 
    SetWindowPos_(WindowID(0),#HWND_TOPMOST,200,200,0,0,#SWP_NOMOVE|#SWP_NOSIZE) 
    ; If CreateMenu(#MenuBar_9, WindowID()) 
    ; MenuTitle("File") 
    ; MenuItem(#MENU_1, "Open") 
    ; MenuItem(#MENU_2, "Save") 
    ; MenuItem(#MENU_3, "Save As") 
    ; MenuItem(#MENU_6, "New") 
    ; MenuBar() 
    ; MenuItem(#MENU_4, "Quit") 
    ; MenuTitle("Help") 
    ; EndIf 


    ; If CreateStatusBar(#StatusBar_11, WindowID()): EndIf 

    If CreateGadgetList(WindowID(0)) 
      ComboBoxGadget(#PLAYLIST, 20, 30, 220, 240, #PB_ComboBox_Editable): AddGadgetItem(#PLAYLIST,0,"Recent Playlists:") 
      Frame3DGadget(#B_PLAYLIST, 10, 10, 600, 51, "Playlist Manager") 
      ButtonGadget(#LOAD, 250, 30, 40, 20, "Load") 
      ; ButtonGadget(#SAVE, 290, 30, 40, 20, "Save") 
      ; ButtonGadget(#DELETE_, 560, 30, 40, 20, "Delete") 
      TrackBarGadget(#PROGRESS, 190, 70, 370, 20, 0, 10000) 
      TrackBarGadget(#FADEIN, 190, 90, 370, 20, 0, 10000): SetGadgetState(#FADEIN,0) 
      TrackBarGadget(#FADEOUT, 190, 110, 370, 20, 0, 10000): SetGadgetState(#FADEOUT,10000) 
      TrackBarGadget(#VOLUME, 70, 75, 100, 15, 0, 100): SetGadgetState(#VOLUME,100) 
      TextGadget(#T_PROGRESS, 560, 70, 50, 20, "Progress") 
      TextGadget(#T_START, 560, 90, 50, 20, "FadeIn") 
      TextGadget(#T_STOP, 560, 110, 50, 20, "FadeOut") 
      TrackBarGadget(#BALANCE, 70, 115, 100, 15, 0, 200): SetGadgetState(#BALANCE,100) 
      StringGadget(#PLAYLIST_FILE, 300, 30, 300, 20, "") 
      Frame3DGadget(#B_TRACKLIST, 10, 53, 600, 95, "Track Manager") 
      Frame3DGadget(#B_TRACKLIST, 10, 140, 600, 190, "TrackList Manager") 
      ListViewGadget(#TRACKINFO, 420, 160, 180, 150): AddGadgetItem(#TRACKINFO,0,"");: AddGadgetColumn(#TRACKINFO,1,"Value",86) 
      ListViewGadget(#TRACKLIST, 40, 160,380,150) 
      TextGadget(#STATUS,550,312,55,12,"STATUS") 
      If (LoadImage(#IMG_REW, "./icons/back.ico")): ButtonImageGadget(#REW, 30, 90, 20, 20, ImageID(#IMG_REW)): Else: ButtonGadget(#REW,30,90,20,20,"<<"): EndIf 
      If (LoadImage(#IMG_FWD, "./icons/fwd.ico")): ButtonImageGadget(#FF_, 70, 90, 20, 20, ImageID(#IMG_FWD)): Else: ButtonGadget(#FF_,70,90,20,20,">>"): EndIf 
      If (LoadImage(#IMG_PAUSE, "./icons/pause.ico")): ButtonImageGadget(#PAUSE, 140, 90, 20, 20, ImageID(#IMG_PAUSE)): Else: ButtonGadget(#PAUSE,140,90,20,20,"||"): EndIf 
      If (LoadImage(#IMG_PLAY, "./icons/play.ico")): ButtonImageGadget(#PLAY, 50, 90, 20, 20, ImageID(#IMG_PLAY)): Else: ButtonGadget(#PLAY,50,90,20,20,">"): EndIf 
      If (LoadImage(#IMG_STOP, "./icons/stop.ico")): ButtonImageGadget(#STOP, 120, 90, 20, 20, ImageID(#IMG_STOP)): Else: ButtonGadget(#STOP,120,90,20,20,"!"): EndIf 
      If (LoadImage(#IMG_REC, "./icons/record.ico")): ButtonImageGadget(#RECORD, 95, 90, 20, 20, ImageID(#IMG_REC)): Else: ButtonGadget(#RECORD,95,90,20,20,"O"): EndIf 
      If (LoadImage(#IMG_PREV, "./icons/prev.ico")): ButtonImageGadget(#PREV, 50, 70, 20, 20, ImageID(#IMG_PREV)): Else: ButtonGadget(#PREV,50,70,20,20,"A"): EndIf 
      If (LoadImage(#IMG_NEXT, "./icons/next.ico")): ButtonImageGadget(#NEXT, 50, 110, 20, 20, ImageID(#IMG_NEXT)): Else: ButtonGadget(#NEXT,50,110,20,20,"V"): EndIf 
      If (LoadImage(#IMG_DEL, "./icons/delete.ico")): ButtonImageGadget(#PL_DELTRK,16,160,20,20,ImageID(#IMG_DEL)): Else: ButtonGadget(#PL_DELTRK,16,160,20,20,"X"): EndIf 
      If (LoadImage(#IMG_PREV, "./icons/prev.ico")): ButtonImageGadget(#PL_MOVEUP,16, 180, 20, 20, ImageID(#IMG_PREV)): Else: ButtonGadget(#PL_MOVEUP,16,180,20,20,"A"): EndIf 
      If (LoadImage(#IMG_NEXT, "./icons/next.ico")): ButtonImageGadget(#PL_MOVEDN,16, 200, 20, 20, ImageID(#IMG_NEXT)): Else: ButtonGadget(#PL_MOVEDN,16,200,20,20,"V"): EndIf 
      If (LoadImage(#IMG_STOP, "./icons/stop.ico")): ButtonImageGadget(#PL_STOP,16, 220, 20, 20, ImageID(#IMG_STOP)): Else:ButtonGadget(#PL_STOP,16,220,20,20,"!"): EndIf 
    EndIf 
    While WindowEvent() : Wend
    HideWindow(0,0)
  EndIf 
EndProcedure 



Procedure.s LoadPlayList() 
  _index=0 
  _pl$=OpenFileRequester("Load Playlist","C:\My Music\*.m3u","PlayList|*.m3u|Track|*.mp3",1, #PB_Requester_MultiSelection) 
  _seek=0 

  ;- Load Tracks from M3U File(s) 

  If (GetExtensionPart(_pl$)="m3u") 
    If (ReadFile(_file, _pl$)) 
      SetGadgetText(#PLAYLIST_FILE,_pl$) 
      AddGadgetItem(#PLAYLIST,-1,_pl$) 
      Repeat
        _track$=ReadString(_file)
        If (FileSize(_track$)>1000)
          MovieID=LoadMovie(#PB_Any,_track$)
          If (MovieLength(MovieID)>0)
            _index=_index+1 
            AddGadgetItem(#TRACKLIST,-1,_track$)
            TRACKCTR=TRACKCTR+1
          EndIf
        EndIf 
      Until Eof(_file) 
    EndIf 
  EndIf 

  ;- Load Tracks from MP3 File(s) 

  If ( GetExtensionPart(_pl$)="mp3") 
    SetGadgetText(#PLAYLIST_FILE,"Multiple MP3 Selection") 
    _track$=_pl$ 
    Repeat
      If (FileSize(_track$)>1000)
        MovieID=LoadMovie(#PB_Any,_track$)
        If (MovieLength(MovieID)>0)
          _index=_index+1
          AddGadgetItem(#TRACKLIST, -1, _track$)
          TRACKCTR=TRACKCTR+1
        EndIf
      EndIf 
      _track$=NextSelectedFileName() 
    Until _track$="" 
  EndIf 
  AddGadgetItem(#TRACKLIST,-1," - END OF PLAYLIST -") 
  ProcedureReturn _pl$ 
EndProcedure 



Procedure$ PlayTrack(_track$,_index) 

  _vol$=ReadINI(_track$,"VOL","100","./PlayerTracks.db") 
  _fadein$=ReadINI(_track$,"FADEIN","0","./PlayerTracks.db") 
  _fadeout$=ReadINI(_track$,"FADEOUT","10000","./PlayerTracks.db") 

  SetGadgetState(#VOLUME,Val(_vol$)) 

  If (_track$=" - STOP -"): StopMovie(MovieID): ProcedureReturn("READY"): EndIf 

  If (CheckFilename(_track$) Or FileSize(_track$)<1000 ): ProcedureReturn("BAD FILE"): EndIf 

  LoadMovie(1,_track$) 

  If (MovieLength(1)<0)
    ProcedureReturn("BAD FILE") 
  Else
    SetGadgetState(#TRACKLIST,GetGadgetState(#TRACKLIST)): 
    LoadMovie(1,_track$): PlayMovie(1,0) 
    ; FreeGadget(#PROGRESS): TrackBarGadget(#PROGRESS, 190, 70, 370, 20, 0, 10000) 
    ; FreeGadget(#FADEIN): TrackBarGadget(#FADEIN, 190, 90, 370, 20, 0, 10000) 
    ; FreeGadget(#FADEOUT): TrackBarGadget(#FADEOUT, 190, 110, 370, 20, 0, 10000): 
    ; SetGadgetState(#FADEOUT,MovieLength()/#FRAMEDIV) 

    SetGadgetState(#FADEIN,Val(_fadein$)) 
    SetGadgetState(#FADEOUT,Val(_fadeout$)) 


    MovieSeek(1,GetGadgetState(#FADEIN) * (MovieLength(MovieID)/10000)) 

    RemoveGadgetItem(#TRACKINFO,1): AddGadgetItem(#TRACKINFO,1,"FileName"+Space(10)+GetFilePart(_track$)) 
    RemoveGadgetItem(#TRACKINFO,2): AddGadgetItem(#TRACKINFO,2,"FileSize "+Space(10)+Str(FileSize(_track$))+" Bytes") 
    RemoveGadgetItem(#TRACKINFO,3): AddGadgetItem(#TRACKINFO,3,"# Frames"+Space(10)+Str(MovieLength(1)/10000)+" Frames") 
    ProcedureReturn("PLAYING") 

    Debug "MovieLength: "+Str(MovieLength(MovieID)),#DEBUG 
    Debug "FRAMEDIV: "+Str(#FRAMEDIV),#DEBUG 
    Debug "xxx: "+Str(MovieLength(MovieID)/#FRAMEDIV),#DEBUG 

  EndIf 

EndProcedure 



Procedure RecordTrackSettings(_track$,_vol,_fadein,_fadeout) 
  ; 
  ; writeINI(section.s,key.s,value.s,inifile.s) 
  ; 
  WriteINI(_track$,"VOL",Str(_vol),"./PlayerTracks.db") 
  WriteINI(_track$,"FADEIN",Str(_fadein),"./PlayerTracks.db") 
  ProcedureReturn WriteINI(_track$,"FADEOUT",Str(_fadeout),"./PlayerTracks.db") 

EndProcedure 




;-MAIN####################################### 



If (InitMovie()): Else: MessageRequester("Fatal Error","Can't Initialise Movie Player",1): EndIf 

LOOPCTR=0 

Open_Window_0() 
;AdvancedGadgetEvents(#True) 
STATUS$="READY": reps=0 
_vol=100: bal=0 

Repeat
  EventID = WindowEvent()
  Delay(#DELAY) 

  reps=reps+1 
  SetGadgetText(#STATUS,STATUS$) 

  If (STATUS$="PLAYING"); And reps=1) 
    RemoveGadgetItem(#TRACKINFO,4): AddGadgetItem(#TRACKINFO,4,"Position"+Space(10)+Str(MovieStatus(MovieID)/10000)) 
    RemoveGadgetItem(#TRACKINFO,5): AddGadgetItem(#TRACKINFO,5,"Fadein "+Space(10)+Str(GetGadgetState(#FADEIN)*(MovieLength(MovieID)/10000)/10000)) 
    RemoveGadgetItem(#TRACKINFO,6): AddGadgetItem(#TRACKINFO,6,"Fadeout"+Space(10)+Str(GetGadgetState(#FADEOUT) * (MovieLength(MovieID)/10000)/10000)) 
    RemoveGadgetItem(#TRACKINFO,7): AddGadgetItem(#TRACKINFO,7,"# Tracks"+Space(10)+Str(TRACKCTR)) 
    SetGadgetState(#PROGRESS,MovieStatus(MovieID)/(MovieLength(MovieID)/10000)): 
  EndIf 

  If (reps=1): SetGadgetText(#STATUS,STATUS$) : EndIf 
  If (STATUS$="SEEK") 
    _divfactor.f=MovieLength(MovieID)/10000 
    _seek.f=GetGadgetState(#PROGRESS)*_divfactor.f 
    RemoveGadgetItem(#TRACKINFO,4): AddGadgetItem(#TRACKINFO,4,"Position"+Space(10)+Str(MovieStatus(MovieID)/10000)): 
    MovieSeek(MovieID,_seek.f) 
  EndIf 

  If (GetGadgetState(#PROGRESS)>GetGadgetState(#FADEOUT)+1 And STATUS$<>"STOPPED" ); And reps=1): 
    _vol=_vol-1: MovieAudio(MovieID,_vol,_bal): SetGadgetState(#VOLUME,_vol) 
    If (_vol=0)
      _vol=100
      SetGadgetState(#TRACKLIST,GetGadgetState(#TRACKLIST)+1)
      STATUS$=PlayTrack(GetGadgetText(#TRACKLIST),GetGadgetState(#TRACKLIST))
    EndIf 
  EndIf 

  If (GetGadgetState(#PROGRESS)>=9997) 
    SetGadgetState(#TRACKLIST,GetGadgetState(#TRACKLIST)+1): STATUS$=PlayTrack(GetGadgetText(#TRACKLIST),GetGadgetState(#TRACKLIST)) 
  EndIf 

  If (GetGadgetText(#TRACKLIST)=" - END OF PLAYLIST -"): STATUS$="READY": StopMovie(MovieID): EndIf 

  If (reps>=300): reps=0: EndIf 

  If (GetGadgetState(#FADEIN)<0 Or GetGadgetState(#FADEOUT)<0): STATUS$="BAD FILE": EndIf 

  Select EventID
    Case #PB_Event_Gadget: 
      Select EventGadget(): 
        Case #PLAYLIST
          GID=0 
        Case #TRACKLIST
          Select EventType()
            Case #PB_EventType_LeftDoubleClick
              STATUS$=PlayTrack(GetGadgetText(#TRACKLIST),GetGadgetState(#TRACKLIST)) 
          EndSelect 
        Case #LOAD: PLAYLIST$=LoadPlayList() 
        Case #SAVE: GID=0 
        Case #DELETE: GID=0 
        Case #REW: MovieSeek(MovieID,MovieStatus(MovieID)-9999999) 
        Case #FF_: MovieSeek(MovieID,MovieStatus(MovieID)+9999999) 
        Case #PAUSE: PauseMovie(MovieID): STATUS$="PAUSED" 
        Case #PLAY
          Select STATUS$ 
            Case "SEEK": STATUS$="RESUME" 
            Case "PAUSED" : ResumeMovie(MovieID): STATUS$="PLAYING" 
            Case "PLAYING": STATUS$=PlayTrack(GetGadgetText(#TRACKLIST),GetGadgetState(#TRACKLIST)) 
            Case "STOPPED": STATUS$=PlayTrack(GetGadgetText(#TRACKLIST),GetGadgetState(#TRACKLIST)) 
            Case "READY": STATUS$=PlayTrack(GetGadgetText(#TRACKLIST),GetGadgetState(#TRACKLIST)) 
          EndSelect 
        Case #STOP: StopMovie(MovieID): STATUS$="STOPPED" 
        Case #PREV: SetGadgetState(#TRACKLIST,GetGadgetState(#TRACKLIST)-1): STATUS$=PlayTrack(GetGadgetText(#TRACKLIST),GetGadgetState(#TRACKLIST)) 
        Case #NEXT: SetGadgetState(#TRACKLIST,GetGadgetState(#TRACKLIST)+1): STATUS$=PlayTrack(GetGadgetText(#TRACKLIST),GetGadgetState(#TRACKLIST)) 
        Case #PROGRESS: STATUS$="SEEK": 
        Case #VOLUME: MovieAudio(MovieID,GetGadgetState(#VOLUME), GetGadgetState(#BALANCE)-100): _vol=GetGadgetState(#VOLUME) 
        Case #BALANCE: MovieAudio(MovieID,GetGadgetState(#VOLUME), GetGadgetState(#BALANCE)-100): _bal=GetGadgetState(#BALANCE)-100 
        Case #PL_DELTRK: RemoveGadgetItem(#TRACKLIST,GetGadgetState(#TRACKLIST)): SetGadgetState(#TRACKLIST,GetGadgetState(#TRACKLIST)) 
        Case #PL_MOVEUP
          _tmppos=GetGadgetState(#TRACKLIST)
          _tmpitem$=GetGadgetText(#TRACKLIST) 
          If (_tmppos>0)
            RemoveGadgetItem(#TRACKLIST,GetGadgetState(#TRACKLIST))
            AddGadgetItem(#TRACKLIST,_tmppos-1,_tmpitem$)
            SetGadgetState(#TRACKLIST,_tmppos-1) 
          EndIf 
        Case #PL_MOVEDN
          _tmppos=GetGadgetState(#TRACKLIST)
          _tmpitem$=GetGadgetText(#TRACKLIST)
          If (_tmppos<TRACKCTR-1) 
            RemoveGadgetItem(#TRACKLIST,GetGadgetState(#TRACKLIST)): 
            AddGadgetItem(#TRACKLIST,_tmppos+1,_tmpitem$): 
            SetGadgetState(#TRACKLIST,_tmppos+1) 
          EndIf 
        Case #PL_STOP
          _tmppos=GetGadgetState(#TRACKLIST)
          AddGadgetItem(#TRACKLIST,_tmppos," - STOP -") 
          SetGadgetState(#TRACKLIST,_tmppos): 
        Case #RECORD
          OSTATUS$=STATUS$
          STATUS$="RECORD"
          SetGadgetText(#STATUS,STATUS$) 
          _result=RecordTrackSettings(GetGadgetText(#TRACKLIST),GetGadgetState(#VOLUME),GetGadgetState(#FADEIN),GetGadgetState(#FADEOUT)) 
      EndSelect 
    Case #PB_Event_Menu: 
    Case #PB_Event_CloseWindow: Exit=1 
    Case #PB_Event_Repaint: 
    Case #PB_Event_MoveWindow 
  EndSelect 
  Delay(#DELAY) 
  Select STATUS$: 
    Case "RESUME": STATUS$="PLAYING" 
    Case "BAD FILE"
      SetGadgetText(#STATUS,STATUS$)
      Delay(#DELAY*1)
      SetGadgetState(#TRACKLIST,GetGadgetState(#TRACKLIST)+1)
      STATUS$=PlayTrack(GetGadgetText(#TRACKLIST),GetGadgetState(#TRACKLIST)): 
    Case "RECORD": Delay(#DELAY*30): STATUS$=OSTATUS$: SetGadgetText(#STATUS,STATUS$) 
  EndSelect 

Until Exit=1

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; EnableXP
; DisableDebugger
