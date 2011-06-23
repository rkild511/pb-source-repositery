; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14262
; Author: blueznl (updated for PB 4.00 by Andre)
; Date: 04. March 2005
; OS: Windows
; Demo: No


; Computer speed independent programming 
; Programmierung unabhängig von der Computer-Geschwindigkeit

; Note by Andre: instead of the WinAPI command GetTickCount_() you can now 
; use the native PB command ElapsedMilliseconds() too!


; purebasic survival guide - pb3.93 
; timer_1.pb - 03.03.2004 ejn (blueznl) 
; http://www.xs4all.nl/~bluez/datatalk/pure1.htm 
; 
; - how to make games run at the same speed on different machines 
; - GetTickCount_() 
; 
; 
; GetTickCount_() returns a counter in milliseconds, since the system started 
; it's limited to 49.7 days, so it wraps around after that... 
; we've also got this 'signed/unsigned' thingy going on in purebasic... 
; 
; t1 = GetTickCount_()      ; there is however no guarantee that t2 is bigger than t1, as there 
; t2 = GetTickCount_()      ; could be a wrap, or there could be a sign change 
; 
; to see how much time has passed, we could do: 
; 
; td = t2-t1 
; if td > ... 
; 
; so we'd start at 0, count up to 2^31-1 = 2147483647, then from -2147483647 to -1, then 0 etc. 
; but... at the moment of a sign change, t2 will be smaller than t1, and... at the moment of a wrap, 
; td will be smaller than 0 (makes the brain hurt) 
; 
; an easy way around this is simply filter out unlikely values and live with it :-) so although we have 
; 2 times a mistake during the 49.7 days, at least the program will not crash out or wait unneccessary long 
; 
; td = t2-t1 
; if td < 0 or td > ... 
; 
w_main_nr = 1 
w_main_h = OpenWindow(w_main_nr,0,0,400,400,"test",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
; 
interval = 500000                                 ; interval frequency of 1 second 
ticks = interval/1000                           ; regular counter has an accuracy of millisecs 
; 
Debug "low performance counter GetTickCount_()" 
; 
t1 = 0 
t2 = 0 
td = 0 
; 
Repeat 
  event = WindowEvent() 
  t2 = GetTickCount_() 
  td = t2-t1 
  If td < 0 Or td >= ticks                      ; check if enough time passed or a wrap took place 
    t1 = t2 
    ; 
    n = n+1                            
    Debug Str(n)+" - "+Str(t2)+" - "+FormatDate("%SS",Date()) 
    ; 
  Else 
    Delay(20)                                   ; so we don't overload the cpu while doing nothing 
  EndIf 
Until event = 513 Or event = #PB_Event_CloseWindow 
; 
; GetTickCount_() does return a timer in milliseconds, if we would like to run at a clip of 60 frames 
; per second, we would have to use an interval of 1000 / 60 = 16.6 = 17 ticks... hmm... 
; 
; there's a high performance counter in windows as well, unfortunately purebasic does not support 
; 64 bits variables yet so we will have to do a little detour using floats (brrrr) 
; 
Debug "" 
Debug "high performance counter" 
; 
hf_q.LARGE_INTEGER 
ht_q.LARGE_INTEGER 
ht1.f = 0 
ht2.f = 0 
htd.f = 0 
; 
If QueryPerformanceFrequency_(@hf_q) = 0 
  Debug "no support" 
EndIf 
; 
; every second it has hf_q.highpart * 2^32 + hf_q.lowpart ticks... that's a lot :-) 
; i don't like floats, but without 64 bit support :-( 
; 
hf.f = hf_q\highpart*Pow(2,32)+hf_q\lowpart 
hticks.f = hf*interval/1000000                  ; ticks on the high performance counter per interval 
; 
Repeat 
  event = WindowEvent() 
  QueryPerformanceCounter_(@ht_q) 
  ht1 = ht_q\highpart*Pow(2,32)+ht_q\lowpart 
  htd = ht1-ht2 
  If htd < 0 Or htd >= hticks                   ; check if enough time passed or a wrap took place 
    ht2 = ht1 
    ; 
    n = n+1                            
    Debug Str(n)+" - "+Str(t2)+" - "+FormatDate("%SS",Date()) 
    ; 
  Else 
    Delay(20)                                   ; so we don't overload the cpu while doing nothing 
  EndIf 
Until event = 513 Or event = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -