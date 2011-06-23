; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3129&highlight=
; Author: MPERLE (updated for PB 4.00 by Andre)
; Date: 13. December 2003
; OS: Windows
; Demo: No


; Programm TeeUhr - Erstes Programm in Purebasic 

If InitSound() = 0 
  MessageRequester("Fehler", "Fehler beim Soundinitialisieren!") 
  End 
EndIf 
 
; Activate this piece of code, if you have a proper sound file to load
;If LoadSound(1, "erinner.wav") = 0 
;  MessageRequester("Fehler", "Fehler beim Soundladen!") 
;  End 
;EndIf 
 
SoundVolume(1, 50) 


If OpenWindow(0,100,100,300,190,"Die Teeuhr",#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_ScreenCentered) 
  

  If CreateGadgetList(WindowID(0)) 
    ButtonGadget(1,10,160,80,20,"Start") 
    ButtonGadget(2,110,160,80,20,"Stop") 
    ButtonGadget(3,210,160,80,20,"Beenden") 
    SpinGadget  (4,20,20,50,26,1,30) 
    SetGadgetState (4,1) 
    SetGadgetText(4,"1") 
    TextGadget(5,80,20,200,26,"Wieviele Minuten soll Ihr Tee ziehen? (1-30 Minuten)") 
    If LoadImage(11, "TeeUhr.bmp") 
      ImageGadget(7,100,60,100,83,ImageID(11)) 
    EndIf 
    If LoadImage(12, "Teetasse.bmp") 
      ImageGadget(7,10,60,100,83,ImageID(12)) 
    EndIf 
    TextGadget(8,140,110,100,20,"Countdown wartet ...",#PB_Text_Center) 
    Frame3DGadget(0,10,5,280,50,"") 
    Frame3DGadget(0,10,55,280,100,"") 
  EndIf 
  
  Repeat 
    EventID = WaitWindowEvent()                                   ;Fenster-Events abfragen 
    If EventID = #PB_Event_CloseWindow                            ;Wenn ... 
      Quit = 1 
    EndIf 
    HideGadget(2,1) 
    If EventID = #PB_Event_Gadget                                 ;Gadget-Events abfragen 
      If EventGadget()=1                                        ;Button "Start" gedrückt 
        HideGadget(1,1) 
        HideGadget(3,1) 
        HideGadget(2,0) 
        CountDown = GetGadgetState(4) *60 
        ProgressBarGadget(9,100,130,180,15,1,CountDown,#PB_ProgressBar_Smooth) 
        
        SendMessage_(GadgetID(9),#CCM_SETBKCOLOR,0,RGB(60,50,0))  ;  Hintergrundfarbe im ProgressBarGadget ändern 
        SendMessage_(GadgetID(9),#WM_USER+9,0,RGB(181,49,16)) 
        SetGadgetState(9,CountDown) 
         time = GetTickCount_() + CountDown * 1000 
        Repeat 
          WindowEvent() 
          If (time - GetTickCount_()) / 1000 < CountDown 
            CountDown - 1 
            SetGadgetText(8,FormatDate("%ii:%ss",CountDown)+ " Minuten") 
            SetGadgetState(9,CountDown) 
            SetWindowText_(WindowID(0),GetGadgetText(8)) 
          EndIf 
        Until CountDown = 0 Or EventGadget()=2 
        ; Meldung anzeigen 
        PlaySound(1, 0) 
        MessageRequester("Die Teeuhr","It's Teatime!",0) 
        SetGadgetText(8,"Countdown wartet ...") 
        SetGadgetState (4,1) 
        SetGadgetText(4,"1") 
        HideGadget(9,1) 
        SetGadgetState(9,0) 
        HideGadget(1,0) 
        HideGadget(3,0) 
        SetWindowText_(WindowID(0),"Die Teeuhr") 
      EndIf 
       If EventGadget()=3            ;Button "Beenden" gedrückt 
        Quit=1 
      EndIf 
      If EventGadget()=4 
        SetGadgetText(4,Str(GetGadgetState(4))) 
        WindowEvent()      
      EndIf 
    EndIf 
    
  Until Quit = 1 
EndIf 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
