; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2786&highlight=
; Author: GPI (updated for PB4.00 by blbltheworm)
; Date: 09. November 2003
; OS: Windows
; Demo: No

;Info: MCI-MP3-Commands 
Enumeration 0 
  #MP3_Unknown 
  #MP3_Stopped 
  #MP3_Playing 
  #MP3_Paused 
EndEnumeration 
Procedure MP3_GetStatus(Nb) 
  Result=#MP3_Unknown 
  a$=Space(#MAX_PATH) 
  i=mciSendString_("status MP3_"+Str(Nb)+" mode",@a$,#MAX_PATH,0) 
  If i=0 
    Debug a$ 
    Select a$ 
      Case "stopped":Result=#MP3_Stopped 
      Case "playing":Result=#MP3_Playing 
      Case "paused":Result=#MP3_Paused 
    EndSelect 
  EndIf 
  ProcedureReturn Result 
EndProcedure 
Procedure MP3_Load(Nb,file.s) 
  ;i=mciSendString_("open Sequencer!"+Chr(34)+file+Chr(34)+" alias mid"+Str(Nb),0,0,0) 
  i=mciSendString_("OPEN "+Chr(34)+file+Chr(34)+" Type MPEGVIDEO ALIAS MP3_"+Str(Nb),0,0,0) 
  If i=0 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 
Procedure MP3_Play(Nb) 
  i=mciSendString_("play MP3_"+Str(Nb),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure MP3_PlayStart(Nb) 
  i=mciSendString_("play MP3_"+Str(Nb)+" from "+Str(0),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure MP3_PlayPart(Nb,Start,endPos) 
  i=mciSendString_("play MP3_"+Str(Nb)+" from "+Str(Start)+" to "+Str(endPos),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure MP3_Pause(Nb) 
  i=mciSendString_("pause MP3_"+Str(Nb),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure MP3_Resume(Nb) 
  i=mciSendString_("resume MP3_"+Str(Nb),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure MP3_Stop(Nb) 
  i=mciSendString_("stop MP3_"+Str(Nb),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure MP3_Free(Nb) 
  i=mciSendString_("close MP3_"+Str(Nb),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure MP3_SetVolume(Nb,volume) 
  i=mciSendString_("SetAudio MP3_"+Str(Nb)+" volume to "+Str(volume),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure MP3_GetVolume(Nb) 
  a$=Space(#MAX_PATH) 
  i=mciSendString_("status MP3_"+Str(Nb)+" volume",@a$,#MAX_PATH,0) 
  ProcedureReturn Val(a$) 
EndProcedure 


Procedure MP3_SetSpeed(Nb,Tempo) 
  i=mciSendString_("set MP3_"+Str(Nb)+" Speed "+Str(Tempo),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure MP3_GetSpeed(Nb) 
  a$=Space(#MAX_PATH) 
  i=mciSendString_("status MP3_"+Str(Nb)+" Speed",@a$,#MAX_PATH,0) 
  ProcedureReturn Val(a$) 
EndProcedure 
Procedure MP3_GetLength(Nb) 
  a$=Space(#MAX_PATH) 
  i=mciSendString_("status MP3_"+Str(Nb)+" length",@a$,#MAX_PATH,0) 
  ProcedureReturn Val(a$) 
EndProcedure 
Procedure MP3_GetPosition(Nb) 
  a$=Space(#MAX_PATH) 
  i=mciSendString_("status MP3_"+Str(Nb)+" position",@a$,#MAX_PATH,0) 
  ProcedureReturn Val(a$) 
EndProcedure 
Procedure MP3_Seek(Nb,pos) 
  i=mciSendString_("Seek MP3_"+Str(Nb)+" to "+Str(pos),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure.s MP3_TimeString(Time) 
  Time/1000 
  sek=Time%60:Time/60 
  min=Time%60:Time/60 
  ProcedureReturn RSet(Str(Time),2,"0")+":"+RSet(Str(min),2,"0")+":"+RSet(Str(sek),2,"0") 
EndProcedure 
;Example 

Enumeration 1 
  #gadget_File 
  #Gadget_VolumeTxt 
  #Gadget_Volume 
  #Gadget_SpeedTxt 
  #Gadget_Speed 
  #Gadget_PositionTxt 
  #Gadget_Position 
  #Gadget_Load 
  #Gadget_Play 
  #Gadget_Stop 
  #Gadget_Pause 
  #Gadget_Resume 
EndEnumeration 

Procedure SetVol(x) 
  SetGadgetText(#Gadget_VolumeTxt,"Volume:"+Str(x)) 
  SetGadgetState(#Gadget_Volume,x) 
EndProcedure 
Procedure SetSpeed(x) 
  SetGadgetText(#Gadget_SpeedTxt,"Speed:"+Str(x)) 
  SetGadgetState(#Gadget_Speed,x) 
EndProcedure 
Procedure SetPosition(x,max) 
  SetGadgetText(#Gadget_PositionTxt,"Position:"+MP3_TimeString(x)+" : "+MP3_TimeString(max)) 
  If max>0 
    SetGadgetState(#Gadget_Position,x*1000/max) 
  Else 
    SetGadgetState(#Gadget_Position,0) 
  EndIf 
EndProcedure 

If OpenWindow(0, 100, 200, 310,310, "Simple MP3-Player", #PB_Window_SystemMenu |#PB_Window_ScreenCentered) 
  If CreateGadgetList(WindowID(0)) 
    top=5 
    TextGadget    (#gadget_File       ,5,top,300,20,"File:"):top+25 
    TextGadget    (#Gadget_VolumeTxt,  5,top,300,20,"Volume"):top+20 
    TrackBarGadget(#Gadget_Volume     ,5,top,300,25,0,100):top+30 
    TextGadget    (#Gadget_SpeedTxt   ,5,top,300,20,"Speed"):top+20 
    TrackBarGadget(#Gadget_Speed      ,5,top,300,25,0,200):top+30 
    TextGadget    (#Gadget_PositionTxt,5,top,300,20,"Position"):top+20 
    TrackBarGadget(#Gadget_Position   ,5,top,300,25,0,1000):top+30 
    ButtonGadget  (#Gadget_Load       ,5,top,300,20,"Load"):top+25 
    ButtonGadget  (#Gadget_Play       ,5,top,300,20,"Play"):top+25 
    ButtonGadget  (#Gadget_Pause      ,5,top,300,20,"Pause"):top+25 
    ButtonGadget  (#Gadget_Resume     ,5,top,300,20,"Resume"):top+25 
    ButtonGadget  (#Gadget_Stop       ,5,top,300,20,"Stop"):top+25 
    loaded=#False 
    Quit=#False 
    
    Repeat 
      EventID.l = WindowEvent() 

      Select EventID 
        Case 0 
          If loaded And max>0 
            x=MP3_GetPosition(1) 
            If GetGadgetState(#Gadget_Position)<>x*1000/max 
              SetPosition(x,max) 
            EndIf 
          EndIf 
          Delay(100) 
        Case #PB_Event_CloseWindow ; If the user has pressed on the close button 
          Quit=#True 
        Case #PB_Event_Gadget 
          Select EventGadget() 
            Case #Gadget_Load 
              File$=OpenFileRequester("","","Media (Wave,MP3,OGG)|*.wav;*.ogg;*.mp3|Wave|*.wav|mp3|*.mp3|OGG|*.OGG|ALL|*.*",0) 
              If File$<>"" 
                If loaded 
                  MP3_Free(1) 
                  loaded=#False 
                EndIf 
                If MP3_Load(1,File$) 
                  max=MP3_GetLength(1) 
                  SetVol(MP3_GetVolume(1)/10) 
                  SetSpeed(MP3_GetSpeed(1)/10) 
                  SetPosition(0,max) 
                  loaded=#True 
                  SetGadgetText(#gadget_File,"File:"+File$) 
                Else 
                  SetGadgetText(#gadget_File,"File") 
                EndIf 
              EndIf 
            Case #Gadget_Resume 
              If loaded 
                MP3_Resume(1) 
              EndIf 
            Case #Gadget_Pause 
              If loaded 
                MP3_Pause(1) 
              EndIf 
            Case #Gadget_Play 
              If loaded 
                MP3_Play(1) 
              EndIf 
            Case #Gadget_Stop 
              If loaded 
                MP3_Stop(1) 
              EndIf 
            Case #Gadget_Position 
              If loaded And max>0 
                x=GetGadgetState(#Gadget_Position)*max/1000 
                SetPosition(x,max) 
                MP3_Seek(1,x) 
                MP3_Resume(1) 
              EndIf 
            Case #Gadget_Volume 
              If loaded 
                x=GetGadgetState(#Gadget_Volume) 
                SetVol(x) 
                MP3_SetVolume(1,x*10) 
              EndIf 
            Case #Gadget_Speed 
              If loaded 
                x=GetGadgetState(#Gadget_Speed) 
                SetSpeed(x) 
                MP3_SetSpeed(1,x*10) 
              EndIf 
          EndSelect 
      EndSelect 
      
    Until Quit 
    If loaded 
      MP3_Stop(1) 
      MP3_Free(1) 
    EndIf 
  EndIf 
EndIf 

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ----
; EnableXP
