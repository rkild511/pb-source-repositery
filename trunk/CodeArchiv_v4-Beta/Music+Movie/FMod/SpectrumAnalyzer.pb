; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1621&highlight=
; Author: Froggerprogger (updated for PB4.00 by blbltheworm)
; Date: 06. July 2003
; OS: Windows
; Demo: Yes


; Note by Andre, 11-Jan-2004:
; You need the FMod.dll for using this example, get the latest version
; with PB wrapper on www.PureArea.net !


; Spectrum-Analyzer
; by Froggerprogger 06.07.03 
; 
; needs the PB-FMOD-Import or higher and the fmod.dll 3.61 or higher. 

; Hinweise:
; Die Userlib gibts auf fmod.de im Downloadsbereich, genannt 
; 'FMOD-DLL-Import für PureBasic inkl. der FMOD.DLL 3.74 mit 'stdcall' - Callbacks ' 
; Du mußt die UserLib einfach nur in Dein Userlib-Verzeichnis kopieren. 
; Die fmod.dll muss sich im Purebasic\Compiler - Verzeichnis befinden und/oder
; später im selben Verzeichnis wie die Exe. 


; Hier mal ein alter Code von mir, der das Spektrum direkt so wie es von Fmod zurückgeliefert wird 
; anzeigt. Zur Optimierung könntest Du auch lediglich die Werte 0-255 anzeigen (also nur bis etwa 11kHz). 
;
; Generell ist da das Problem, das die x-Achse lieber logarithmisch visualisiert sein sollte, da ja eine
; Oktave eine Verdopplung der Frequenz bedeutet und man somit einen gleichwertigen und vernünftigeren
; Überblick hätte. 
; Die FFT kann jedoch nur linear arbeiten. D.h. für das Intervall von z.B. 20Hz - 1280 Hz (6 Oktaven) 
; erhalten wir genausoviele Testergebnisse, wie für den Bereich 10020 Hz - 11280 (ca. 1 Halbton). 
; Diese Ergebnisse mußt Du auf der x-Achse also noch dementsprechend stauchen und ggf. interpolieren. 

Declare updateFFT(value) 

If InitSprite() = 0 
    MessageRequester("","Problem with InitSprite()",0):End 
EndIf 

If FSOUND_Init(44100, 32, 0) = 0 
    MessageRequester("","Problem with FSOUND_Init()",0) : End 
EndIf

hwnd=OpenWindow(1,0,0,520,264, "FMOD FFT-Spectrum Visualization by Froggerprogger 0.3",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 

OpenWindowedScreen(hwnd,4,60,512,200,0,0,0) 

;initialisation and declarations 
CreateSprite(1,512,200,0) 

Structure fftarray 
value.f[512] 
EndStructure 

soundfile.s="" 
Global logscale.b, resume.b, visual.b 
logscale = 1  
visual = 1 

;create menu + gadgets 
FSOUND_SetBufferSize(125) 
If hwnd <> 0 And FSOUND_Init(44100, 32, 0) And CreateMenu(1,hwnd) And CreateGadgetList(hwnd) 


  MenuItem(1, "open") 
  MenuItem(2, "play") 
  MenuItem(3,"stop") 
  MenuItem(4, "info") 
  MenuTitle("options") 
  MenuItem(5, "toggle y-scale and -6dB lines") 
  SetMenuItemState(1,5,logscale) 
  MenuItem(6, "toggle visualization style") 
  SetMenuItemState(1,6,visual) 

  resume=1 

  TextGadget(1,5,10,512,20,"Music-File:   "+soundfile,0)  
  
EndIf 

;main loop 
hthread=CreateThread(@updateFFT(),0) 

While resume 
  Event = WindowEvent() 
  If Event 
   Select Event 

    Case #PB_Event_Menu 
      Select EventMenu() 
        Case 1 ;(Open) 
          temp_filename.s = OpenFileRequester("","","PCM-MusicFiles (*.mp3, *.wav, *.mp2, *.ogg, *.raw)|*.mp3;*.wav;*.mp2;*.ogg;*.raw|*.*|*.*",0,0) 
          If temp_filename  
              soundfile.s = temp_filename  
              SetGadgetText(1,soundfile)  
          EndIf 

        Case 2 ;(Play) 
         hstream = FSOUND_Stream_Open(soundfile,0,0,0) ;open the soundfile 
         If hstream <> 0 
             FSOUND_DSP_SetActive(FSOUND_DSP_GetFFTUnit(), #True) ;activate the FastFourierTransformation-DSP-Unit 
             FSOUND_Stream_Play(1,hstream) ;play the stream on channel 1 
             IsSoundPlaying = 1 
         EndIf 
          
        Case 3 ;(Stop) 
            For i=255 To 0 Step -1 ;a small fast fade-out to prevent a clipping-sound 
              FSOUND_SetVolume(1,i) 
            Next 
            FSOUND_Stream_Stop(hstream) ;stop playing the stream 
            FSOUND_SetVolume(1,255) ;reset volume to max 
            IsSoundPlaying = 0 

        Case 4 ;(Info) 
            lf.s = Chr(13) + Chr(10)    
            row1.s = "FMOD BufferSize :  " + Str(FSOUND_DSP_GetBufferLengthTotal()) + " Samples"+ lf 
            temp_drivernamepointer = FSOUND_GetDriverName(FSOUND_GetDriver()) 
            temp_drivername.s = Space(255) 
            CopyMemory(temp_drivernamepointer, @temp_drivername, 255) 
            row2.s = "Drivername :   " + temp_drivername + lf 
            row3.s = "Samplingrate :   " + Str(FSOUND_GetOutputRate()) + " Hz" + lf 
            
            message.s=row1+row2+row3 
            MessageRequester("info", message, 0) 
            
        Case 5 ;(options|logarithmic y-scale) 
          logscale!1 
          SetMenuItemState(1,5,logscale) 
        
        Case 6 ;(options|toggle style) 
          visual!1 
          SetMenuItemState(1,6,visual) 
  
          
      EndSelect 

    Case #PB_Event_CloseWindow ;(close window & exit) 
      resume=0 : WaitThread(hthread) 
      FSOUND_Stream_Stop(hstream) ;stop playing the stream 
      FSOUND_DSP_SetActive(FSOUND_DSP_GetFFTUnit(), #False) ;set the FFT-DSP-Unit inactive 
      FSOUND_Close() ;shut down FSOUND 
    Default 

   EndSelect 
  Else 
   Delay(1) 
  EndIf 
  cpuusage.s="CPU: "+StrF(FSOUND_GetCPUUsage(),1)+" %" 
Wend 

;The following procedure is called as a thread and updates the fft-visualisation 
Procedure updateFFT(value) 
    Shared logscale, resume, visual 
    Shared resume, cpuusage, IsSoundPlaying 

        While resume 

            If FSOUND_DSP_GetActive(FSOUND_DSP_GetFFTUnit()) 
                CopyMemory(FSOUND_DSP_GetSpectrum(), hfft.fftarray, 4*512) 
            EndIf 
            
            StartDrawing(SpriteOutput(1)) 

                If visual = 1 
                    Box(0,0,512,200,$000000) 
                    For actscale=1 To 25 
                        If logscale = 1 
                            actdBline_y.f = Pow(0.0000001, 1 / actscale) * 199 
                        Else 
                            actdBline_y.f = 199-199/actscale 
                        EndIf    
                          Box(0,actdBline_y,511,1,RGB(150-actscale*6,150-actscale*6,150-actscale*6)) 
                        Next 
                Else 
                    Box(0,0,512,200,$CCFFFF) 
                EndIf            

                


              Select visual 
                Case 0 
                     If IsSoundPlaying 

                        For i=0 To 511 
                            If logscale = 1 
                                actfftvalue.f = Pow(0.0000001, hfft\value[i]) * 199 
                            Else 
                                actfftvalue.f = 199-hfft\value[i]*199 
                            EndIf    
                            Box(i,0,1,1+actfftvalue,$000000+actfftvalue) 
                        Next 
                     EndIf 
                Case 1 
                     If IsSoundPlaying 
                        For i=0 To 511 
                            If logscale = 1 
                                actfftvalue.f = 199-Pow(0.0000001, hfft\value[i]) * 199 
                            Else 
                                actfftvalue.f = hfft\value[i]*199 
                            EndIf    
                            Box(i,200,1,-1-actfftvalue, (255-actfftvalue) * $000100 + actfftvalue * $000001) 
                        Next 
                     EndIf 
              EndSelect 

              DrawingMode(1) 
              FrontColor(RGB(255,255,255)) 
              DrawText(420 , 4,CpuUsage) 

            StopDrawing()    
            FlipBuffers() 
            DisplaySprite(1,0,0) 
            Delay(20) 

        Wend 
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
