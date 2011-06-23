; German forum: 
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 27. November 2002
; OS: Windows
; Demo: No

; Note by Andre, 11-Jan-2004:
; You need the FMod.dll for using this example, get the latest version
; with PB wrapper on www.PureArea.net !


#FMOD_DLL = 1

Procedure FMOD_SETMUSICVOLUME()
Shared hMusic, current_volume
   If hMusic
      CallFunction(#FMOD_DLL,"_FMUSIC_SetMasterVolume@8",hMusic,current_volume)
   EndIf
EndProcedure

Procedure FMOD_STOPMUSIC()
Shared hMusic
   If hMusic
      CallFunction(#FMOD_DLL,"_FMUSIC_FreeSong@4",hMusic)
      hMusic = 0
   EndIf
EndProcedure

Procedure FMOD_PLAYMUSIC(File$)
Shared hMusic
   FMOD_STOPMUSIC()
   If File$
      hMusic = CallFunction(#FMOD_DLL,"_FMUSIC_LoadSong@4", File$)
      If hMusic
         CallFunction(#FMOD_DLL,"_FMUSIC_PlaySong@4",hMusic)
         FMOD_SETMUSICVOLUME()
      Else
         MessageRequester("ERROR","Cant load song!",#MB_ICONERROR)
      EndIf
   EndIf
EndProcedure

Procedure FMOD_INIT(mixrate, maxsoftwarechannels, flags)
   If OpenLibrary(#FMOD_DLL,"FMOD.DLL")
      FMOD_INIT = CallFunction(#FMOD_DLL,"_FSOUND_Init@12",mixrate,maxsoftwarechannels,flags)
   Else
      FMOD_INIT = 0
   EndIf
   ProcedureReturn FMOD_INIT
EndProcedure

Procedure FMOD_SHUTDOWN()
   FMOD_STOPMUSIC()
   CallFunction(#FMOD_DLL,"_FSOUND_Close@0")
   CloseLibrary(#FMOD_DLL)
EndProcedure




If FMOD_INIT(44100, 32, 0)

   OpenWindow(1,200,200,150,100,"FMOD player",#PB_Window_SystemMenu)
      CreateGadgetList(WindowID(1))
      ButtonGadget(1,0, 0,150,20,"Load and Play")
      ButtonGadget(2,0,20,150,20,"Stop")
      ButtonGadget(3,0,40,150,20,"Quit")
      TextGadget(0,0,65,150,15,"Volume",#PB_Text_Center)
      TrackBarGadget(4,0,80,150,18,0,256)
        SetGadgetState(4,256): current_volume = 256

   Repeat
      Select WaitWindowEvent()
         Case #PB_Event_CloseWindow
              FMOD_SHUTDOWN(): End
         Case #PB_Event_Gadget
              Select EventGadget()
                 Case 1
                      File$ = OpenFileRequester("Choose music","","FMOD - MOD,S3M,XM,IT,MID,RMI,SGT | *.mod;*.s3m;*.xm;*.it;*.mid;*.rmi;*.sgt",0)
                      If File$
                         FMOD_PLAYMUSIC(File$)
                      EndIf
                 Case 2
                      FMOD_STOPMUSIC()
                 Case 3
                      FMOD_SHUTDOWN(): End
                 Case 4
                      current_volume = GetGadgetState(4)
                      FMOD_SETMUSICVOLUME()
              EndSelect
              SetFocus_(WindowID(1))
      EndSelect
   ForEver
Else
   MessageRequester("ERROR","Cant init FMOD.DLL",#MB_ICONERROR)
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -