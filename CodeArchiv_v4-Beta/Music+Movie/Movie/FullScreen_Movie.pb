; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8975&highlight=
; Author: boop64 (updated for PB4.00 by blbltheworm)
; Date: 02. January 2004
; OS: Windows
; Demo: No


; There are two window id's you can use in this example to play a movie on.
; The first one is 'hDesk' this plays the video directly to your desktop
; giving you a fullscreen video w/o much effort. The second is 'hTray' this
; one really has no use but it's pretty funny, it will render the video over
; your tray window. 'hTray' could be used if you wanted to play a joke on a
; friend or something. Anyway thanks for listening.


; Be carefully when disabling the Debugger, you can't stop the movie then...!
hDesk = GetDesktopWindow_()
hTray = FindWindow_("Shell_traywnd", "")
If InitMovie() = 0
  MessageRequester("Error", "Can't initialize movie playback !", 0)
  End
EndIf

MovieName$ = OpenFileRequester("Choose the movie to play", "", "Movie/Audio files|*.avi;*.mpg;*.asf;*.mp3;*.wav|All Files|*.*", 0)

If MovieName$
  If LoadMovie(0, MovieName$)
    ResizeMovie(0, 0, 0, GetSystemMetrics_(#SM_CXSCREEN), GetSystemMetrics_(#SM_CYSCREEN))
    PlayMovie(0, hDesk)
    
    Repeat
      Delay(1)
    ForEver
  EndIf
EndIf
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
