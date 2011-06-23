; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2786&highlight=
; Author: GPI (updated for PB4.00 by blbltheworm)
; Date: 09. November 2003
; OS: Windows
; Demo: No

; Code für OGG/WAV/MP3. 
; Beachtet, dass man auch die Lautstärke und die Geschwindigkeit ändern kann.
; Letzteres ist für Spiele mit Zeitlimit intresannt, wo man nochmals druck machen will... 

Procedure OGG_Load(Nb,file.s) 
  ;i=mciSendString_("open Sequencer!"+Chr(34)+file+Chr(34)+" alias mid"+Str(Nb),0,0,0) 
  i=mciSendString_("OPEN "+Chr(34)+file+Chr(34)+" Type MPEGVIDEO ALIAS OGG"+Str(Nb),0,0,0) 
  If i=0 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 
Procedure OGG_Play(Nb) 
  i=mciSendString_("play OGG"+Str(Nb)+" from "+Str(0),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure OGG_Pause(Nb) 
  i=mciSendString_("pause OGG"+Str(Nb),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure OGG_Resume(Nb) 
  i=mciSendString_("resume OGG"+Str(Nb),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure OGG_Stop(Nb) 
  i=mciSendString_("stop OGG"+Str(Nb),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure OGG_Free(Nb) 
  i=mciSendString_("close OGG"+Str(Nb),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure OGG_SetVolume(Nb,volume) 
  i=mciSendString_("SetAudio OGG"+Str(Nb)+" volume to "+Str(volume),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure OGG_GetVolume(Nb) 
  a$=Space(#MAX_PATH) 
  i=mciSendString_("status OGG"+Str(Nb)+" volume",@a$,#MAX_PATH,0) 
  ProcedureReturn Val(a$) 
EndProcedure 
Procedure OGG_PlayPart(Nb,Start,endPos) 
  i=mciSendString_("play OGG"+Str(Nb)+" from "+Str(Start)+" to "+Str(endPos),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure OGG_SetSpeed(Nb,Tempo) 
  i=mciSendString_("set OGG"+Str(Nb)+" Speed "+Str(Tempo),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure OGG_GetSpeed(Nb) 
  a$=Space(#MAX_PATH) 
  i=mciSendString_("status OGG"+Str(Nb)+" Speed",@a$,#MAX_PATH,0) 
  ProcedureReturn Val(a$) 
EndProcedure 
Procedure OGG_GetLength(Nb) 
  a$=Space(#MAX_PATH) 
  i=mciSendString_("status OGG"+Str(Nb)+" length",@a$,#MAX_PATH,0) 
  ProcedureReturn Val(a$) 
EndProcedure 
Procedure OGG_GetPosition(Nb) 
  a$=Space(#MAX_PATH) 
  i=mciSendString_("status OGG"+Str(Nb)+" position",@a$,#MAX_PATH,0) 
  ProcedureReturn Val(a$) 
EndProcedure 
Procedure OGG_IsPlaying(Nb) 
  a$=Space(#MAX_PATH) 
  i=mciSendString_("status OGG"+Str(Nb)+" mode",@a$,#MAX_PATH,0) 
  If a$="playing" 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 
Procedure OGG_IsPaused(Nb) 
  a$=Space(#MAX_PATH) 
  i=mciSendString_("status OGG"+Str(Nb)+" mode",@a$,#MAX_PATH,0) 
  If a$="paused" 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 
Procedure OGG_IsReady(Nb) 
  a$=Space(#MAX_PATH) 
  i=mciSendString_("status OGG"+Str(Nb)+" mode",@a$,#MAX_PATH,0) 
  Debug a$ 
  If a$="not ready" 
    ProcedureReturn #False 
  Else 
    ProcedureReturn #True 
  EndIf 
EndProcedure 
Procedure OGG_Seek(Nb,pos) 
  If OGG_IsPlaying(Nb) 
    ok=#True 
    OGG_Stop(Nb) 
  EndIf 
  i=mciSendString_("Seek OGG"+Str(Nb)+" to "+Str(pos),0,0,0) 
  If ok 
    mciSendString_("play OGG"+Str(Nb),0,0,0) 
  EndIf 
  ProcedureReturn i 
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
  SetGadgetText(#Gadget_PositionTxt,"Position:"+Str(x)+" : "+Str(max)) 
  If max>0 
    SetGadgetState(#Gadget_Position,x*1000/max) 
  Else 
    SetGadgetState(#Gadget_Position,0) 
  EndIf 
EndProcedure 
If OpenWindow(0, 100, 200, 310, 255+5+25, "Beispiel: OGG Abspielen", #PB_Window_SystemMenu |#PB_Window_ScreenCentered) 
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
    ButtonGadget  (#Gadget_Stop       ,5,top,300,20,"Stop"):top+25 
    loaded=#False 
    Quit=#False 
    
    Repeat 
      EventID.l = WindowEvent() 
      
      Select EventID 
        Case 0 
          If loaded And max>0 
            x=OGG_GetPosition(1) 
            If GetGadgetState(#Gadget_Position)<>x*1000/max 
              SetPosition(x,max) 
            EndIf 
          EndIf 
          Delay(10) 
        Case #PB_Event_CloseWindow ; If the user has pressed on the close button 
          Quit=#True 
        Case #PB_Event_Gadget 
          Select EventGadget() 
            Case #Gadget_Load 
              File$=OpenFileRequester("","","Media (Wave,MP3,OGG)|*.wav;*.ogg;*.mp3|Wave|*.wav|mp3|*.mp3|OGG|*.OGG|ALL|*.*",0) 
              If File$<>"" 
                If loaded 
                  OGG_Free(1) 
                  loaded=#False 
                EndIf 
                If OGG_Load(1,File$) 
                  max=OGG_GetLength(1) 
                  SetVol(100) 
                  SetSpeed(100) 
                  SetPosition(0,max) 
                  loaded=#True 
                  SetGadgetText(#gadget_File,"File:"+File$) 
                Else 
                  SetGadgetText(#gadget_File,"File") 
                EndIf 
              EndIf 
            Case #Gadget_Pause 
              If loaded 
                If OGG_IsPaused(1) 
                  OGG_Resume(1) 
                Else 
                  OGG_Pause(1) 
                EndIf 
              EndIf 
            Case #Gadget_Play 
              If loaded 
                OGG_Play(1) 
              EndIf 
            Case #Gadget_Stop 
              If loaded 
                OGG_Stop(1) 
              EndIf 
            Case #Gadget_Position 
              If loaded And max>0 
                x=GetGadgetState(#Gadget_Position)*max/1000 
                SetPosition(x,max) 
                OGG_Seek(1,x) 
                OGG_Resume(1) 
              EndIf 
            Case #Gadget_Volume 
              If loaded 
                x=GetGadgetState(#Gadget_Volume) 
                SetVol(x) 
                OGG_SetVolume(1,x*10) 
              EndIf 
            Case #Gadget_Speed 
              If loaded 
                x=GetGadgetState(#Gadget_Speed) 
                SetSpeed(x) 
                OGG_SetSpeed(1,x*10) 
              EndIf 
          EndSelect 
      EndSelect 
      
    Until Quit 
    If loaded 
      OGG_Stop(1) 
      OGG_Free(1) 
    EndIf 
  EndIf 
EndIf 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ----
; EnableXP
; DisableDebugger
