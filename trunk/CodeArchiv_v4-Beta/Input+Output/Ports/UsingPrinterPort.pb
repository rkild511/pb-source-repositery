; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2156&highlight=
; Author: lefaje
; Date: 31. August 2003
; OS: Windows
; Demo: Yes


; Access to external relais with PureBasic via printer port
; ---------------------------------------------------------
; You need the DLL inpout.dll from:
; http://www.lefaje.de/download/dl_start.htm


;         Ansteuerung externer Schaltungen über Drucker-Port 
;                    mit INPOUT32.DLL 
; 
;Mit ein paar externen Bauteilen und etwas Phantasie kann man über den 
;Druckerport beliebig viele Ein- und Ausgänge steuern. 
; 
;Der Standard-Drucker-Port hat 8 Datenleitungen, 4 Control-Leitungen und 
;5 Status-Leitungen. 
; 
;Alle Leitungen haben TTL-Pegel, Control-Leitungen sind "OpenCollector". 
; 
;Mit den Daten-Leitungen werden die Daten zum Drucker übertragen. Die 
;heutigen Druckerschnittstellen sind bidirektional, d.h. es können auch 
;8-Bit-Daten vom Drucker empfangen werden. 
; 
;Die Control-Leitungen steuern die Funktionen des Druckers. 
; 
;Über die Status-Leitungen erhält der PC Informationen über den Drucker- 
;zustand. 
; 
;Ein Drucker benutzt 3 Port-Register. Das erste Register ist das Daten- 
;Register, das zweite das Status-Register und das dritte ist das Control- 
;Register. 
; 
;Je nach Rechner wird eine der folgenden Port-Gruppen benutzt: 
;      0378 - 037A 0278 - 027A 03BC - 03BE 
; 
;Z U O R D N U N G     R E G I S T E R  -  L E I T U N G E N 
; 
;Reg  In/Out  Funktion  Pin    Signal-Pegel 
; 
;D-Reg 
; D0   In/Out Daten     2     Bit=0: L-Pegel  Bit=1: H-Pegel 
; D1   In/Out Daten     3     Bit=0: L-Pegel  Bit=1: H-Pegel 
; D2   In/Out Daten     4     Bit=0: L-Pegel  Bit=1: H-Pegel 
; D3   In/Out Daten     5     Bit=0: L-Pegel  Bit=1: H-Pegel 
; D4   In/Out Daten     6     Bit=0: L-Pegel  Bit=1: H-Pegel 
; D5   In/Out Daten     7     Bit=0: L-Pegel  Bit=1: H-Pegel 
; D6   In/Out Daten     8     Bit=0: L-Pegel  Bit=1: H-Pegel 
; D7   In/Out Daten     9     Bit=0: L-Pegel  Bit=1: H-Pegel 
; 
;S-Reg 
; S0   intern 
; S1   intern 
; S2   intern 
; S3   In     Error     15    L-Pegel : Bit=0  H-Pegel : Bit=1 
; S4   In     Selected  13    L-Pegel : Bit=0  H-Pegel : Bit=1 
; S5   In     PaperOut  12    L-Pegel : Bit=0  H-Pegel : Bit=1 
; S6   In     Acknowl.  10    L-Pegel : Bit=0  H-Pegel : Bit=1 
; S7   In     Busy      11    L-Pegel : Bit=1  H-Pegel : Bit=0 
; 
;C-Reg 
; C0   Out    Strobe    1     Bit=0: hochohmig Bit=1: L-Pegel 
; C1   Out    AutoFeed  14    Bit=0: hochohmig Bit=1: L-Pegel 
; C2   Out    Init      16    Bit=0: L-Pegel  Bit=1: hochohmig 
; C3   Out    Select    17    Bit=0: hochohmig Bit=1: L-Pegel 
; C4   intern IRQ enable 
; C5   intern OUT / IN        Bit=0: D-Port > OUT Bit=1: IN > D-Port    




port=$378 ;Druckerport 
d_reg=port:s_reg=port+1:c_reg=port+2 
inwert.w=0:outwert.w=0 

#RandLinks=50:#RandOben=50:#FensterBreite=800:#Fensterhoehe=499:#Titel="Druckerport" 
If OpenWindow(0,#RandLinks,#RandOben,#FensterBreite,#FensterHoehe,#Titel,#PB_Window_MinimizeGadget) 
      
       If OpenLibrary(0, "INPOUT32.DLL") 
        *out = GetFunction (0,"Out32") 
        *inp = GetFunction (0,"Inp32") 
          If  *out And *inp 
            libok=1 
          Else 
            CloseLibrary(0) 
            MessageRequester("IN_OUT","Bibliothek INPOUT32.DLL konnte nicht geöffnet werden",#PB_MessageRequester_Ok) 
            End
          EndIf 
       Else
         MessageRequester("IN_OUT","Bibliothek INPOUT32.DLL konnte nicht geöffnet werden",#PB_MessageRequester_Ok) 
         End
       EndIf 
        
       If libok=1 
       CreateGadgetList(WindowID(0)) 
       Gosub Startbild 
       EndIf 
        
        Repeat 
           Select WindowEvent() 
              Case #PB_Event_CloseWindow:CloseLibrary(0):End 
              Case #PB_Event_Gadget 
                Select EventGadget() 
                  Case 1 
                    Gosub lesen 
                  Case 2  
                    Gosub schreiben 
                EndSelect 
           EndSelect 
        Delay(10) 
        ForEver 
        
Else 
  End 
EndIf 

Startbild: 
      ButtonGadget(1,100,280,60,40,"Port lesen",#PB_Button_MultiLine) 

      ButtonGadget(2,200,280,60,40,"Port schreiben",#PB_Button_MultiLine) 
      StringGadget(3,200,250,50,20,"",#PB_String_Numeric) 
      StringGadget(4,100,250,50,20,"")        
Return 

lesen: 
      inwert = CallFunctionFast(*inp,s_reg)     ;Wert lesen von Status-Port 
      inwert$=Str(inwert)                       ;in String wandeln 
      SetGadgetText(4,inwert$)                  ;ausgeben 
Return                                         ;Wert ändert sich mit/ohne Papier 

schreiben: 
      outwert$=GetGadgetText(3)                 ;Wert aus Gadget lesen 
      outwert=Val(outwert$)                     ;in Zahl wandeln 
      CallFunctionFast(*out,d_reg,outwert)      ;senden an Daten-Port 
Return                

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
