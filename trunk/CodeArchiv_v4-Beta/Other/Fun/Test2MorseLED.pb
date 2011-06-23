; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2781&highlight=
; Author: Rob (updated for PB 4.00 by Andre)
; Date: 09. November 2003
; OS: Windows
; Demo: No


; Display text as morse code via keyboard LEDs...

; Text als Morsezeichen über die Tastatur-LEDs ausgeben 
; Das sonst ziemlich nutzlose ScrollLock-LED leuchtet auf...  getestet auf WinXP
;
; Für eigene Programme braucht man nur die Funktion (ohne Buchstabenmarkierung)
; und das Morsecode-Array. 

Global sg 

Global Dim code.s(38,2) 

code(1,1) = "a" : code(1,2) = ".-" 
code(2,1) = "b" : code(2,2) = "-..." 
code(3,1) = "c" : code(3,2) = "-.-." 
code(4,1) = "d" : code(4,2) = "-.." 
code(5,1) = "e" : code(5,2) = "." 
code(6,1) = "f" : code(6,2) = "..-." 
code(7,1) = "g" : code(7,2) = "--." 
code(8,1) = "h" : code(8,2) = "...." 
code(9,1) = "i" : code(9,2) = ".." 
code(10,1) = "j" : code(10,2) = ".---" 
code(11,1) = "k" : code(11,2) = "-.-" 
code(12,1) = "l" : code(12,2) = ".-.." 
code(13,1) = "m" : code(13,2) = "--" 
code(14,1) = "n" : code(14,2) = "-." 
code(15,1) = "o" : code(15,2) = "---" 
code(16,1) = "p" : code(16,2) = ".--." 
code(17,1) = "q" : code(17,2) = "--.-" 
code(18,1) = "r" : code(18,2) = ".-." 
code(19,1) = "s" : code(19,2) = "..." 
code(20,1) = "t" : code(20,2) = "-" 
code(21,1) = "u" : code(21,2) = "..-" 
code(22,1) = "v" : code(22,2) = "...-" 
code(23,1) = "w" : code(23,2) = ".--" 
code(24,1) = "x" : code(24,2) = "-..-" 
code(25,1) = "y" : code(25,2) = "-.--" 
code(26,1) = "z" : code(26,2) = "--.." 
code(27,1) = "1" : code(27,2) = ".----" 
code(28,1) = "2" : code(28,2) = "..---" 
code(29,1) = "3" : code(29,2) = "...--" 
code(30,1) = "4" : code(30,2) = "....-" 
code(31,1) = "5" : code(31,2) = "....." 
code(32,1) = "6" : code(32,2) = "-...." 
code(33,1) = "7" : code(33,2) = "--..." 
code(34,1) = "8" : code(34,2) = "---.." 
code(35,1) = "9" : code(35,2) = "----." 
code(36,1) = "0" : code(36,2) = "-----" 
code(37,1) = "." : code(37,2) = ".-.-.-" 
code(38,1) = "," : code(38,2) = "--..--" 


Procedure text2morseled(text.s,speed.f) 
  
  
  ; LED ausschalten 
  If GetKeyState_(#VK_SCROLL) = 1 
    keybd_event_(#VK_SCROLL,0,#KEYEVENTF_EXTENDEDKEY | 0,0) 
    keybd_event_(#VK_SCROLL,0,#KEYEVENTF_EXTENDEDKEY | #KEYEVENTF_KEYUP,0) 
  EndIf 
  
  bswait = 400/speed    ; Zeit zwischen Buchstaben in Millisekunden 
  beepwait = 200/speed  ; Zeit zwischen zwei Morsezeichen 
  shortbeep = 100/speed ; Zeit eines kurzen Morsezeichen 
  longbeep = 400/speed  ; Und Zeit eines langen 
    
  text = LCase(text) 
  l = Len(text) 
    
  Repeat 
    If GetTickCount_() - bstime >= bswait 
    
      ; Einen Buchstaben extrahieren 
      i+1 
      bs.s = Mid(text,i,1) 
      ; Den Morsecode dazu ermitteln 
      ms.s = "" 
      For ibs = 1 To 38 
        If code(ibs,1) = bs : ms = code(ibs,2) : EndIf 
      Next 
      
; (Buchstabe im StringGadget markieren) 
SendMessage_(sg,#EM_SETSEL,i-1,i) 
      
      
      ; Den Morsecode ausgeben 
      For ims = 1 To Len(ms) 
        ; LED an 
        keybd_event_(#VK_SCROLL,0,#KEYEVENTF_EXTENDEDKEY | 0,0) 
        keybd_event_(#VK_SCROLL,0,#KEYEVENTF_EXTENDEDKEY | #KEYEVENTF_KEYUP,0) 
        
        If Mid(ms,ims,1) = "." : bwait=shortbeep : Else : bwait = longbeep : EndIf 
        mstime = GetTickCount_() 
        Repeat : Until GetTickCount_()-mstime >= bwait 
        
        ; LED aus 
        keybd_event_(#VK_SCROLL,0,#KEYEVENTF_EXTENDEDKEY | 0,0) 
        keybd_event_(#VK_SCROLL,0,#KEYEVENTF_EXTENDEDKEY | #KEYEVENTF_KEYUP,0) 
        
        ; beepwait-Millisekunden warten 
        bwtime = GetTickCount_() 
        Repeat :  Until GetTickCount_() - bwtime >= beepwait 
        
      Next 
    
      bstime = GetTickCount_() 
    EndIf 
  Until i=l 
EndProcedure 

win=OpenWindow(0,0,0,200,45,"Text2MorseLED",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
CreateGadgetList(win) 
sg=StringGadget(0,0,0,200,20,"SOS",#ES_NOHIDESEL) 
ButtonGadget(1,0,22,40,22,"Go") 
TrackBarGadget(2,45,22,155,22,1,20) 
SetGadgetState(2,10) 
GadgetToolTip(2,"Speed: " + StrF(GetGadgetState(2)/10,1)) 

Repeat 
  eventid=WaitWindowEvent() 
  If eventid = #PB_Event_Gadget 
    If EventGadget() = 1 
      text.s = GetGadgetText(0) 
      speed.f = GetGadgetState(2)/10 
      text2morseled(text,speed) 
      SendMessage_(sg,#EM_SETSEL,0,0) 
    ElseIf EventGadget() = 2 
      GadgetToolTip(2,"Speed: " + StrF(GetGadgetState(2)/10,1)) 
    EndIf 
  EndIf 
Until eventid = #PB_Event_CloseWindow
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
