; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2156&highlight=
; Author: lefaje
; Date: 31. August 2003
; OS: Windows
; Demo: Yes


; Access to the serial port with PureBasic
; ----------------------------------------
; You need the DLL port.dll from:
; http://www.lefaje.de/download/dl_start.htm


;         Ansteuerung einer Seriellen Schnittstelle 
;                    mit PORT.DLL 
; 
;Neben dem Schreib- Lesezugriff auf fast alle Hardware-Ports, Steuerung 
;der Soundkarte und Abfrage des Joysticks enthält die PORT.DLL einige 
;Funktionen zur Steuerung des COM-Ports. 
; 
;OPENCOM öffnet die Seriell Schnittstelle mit den übergebenen Parametern 
;COM-Nr, Baudrate, Parität, Datenbits, Stopbits. 
; 
;SENDBYTE sendet ein Byte an die Schnittstelle 
; 
;READBYTE liest von der Schnittstelle 
; 
;CLOSECOM schliesst den Port 
; 
;Zusätzlich gibt es Funktionen die Leitungen RTS, DTR und TxD zu schalten, 
;ebenso lassen sich die Zustände der Leitungen CTS, DSR, DCD und RI abfragen. 
; 
;Das Code-Beispiel kann die Leitung DTR ein/ausschalten. Ist ein Modem an die 
;Schnittstelle angeschlossen, kann über den entsprechenden AT-Befehl die Firm- 
;ware-Info abgefragt werden. 


; Daten (AT-Befehle) zu externem Modem an COM2 schicken 
; Antworten lesen 
; AT   schaltet Modem in Befehlsmodus und antwortet mit OK 
; ATI  gibt Firmware-Info zurück 



#RandLinks=50:#RandOben=50:#FensterBreite=800:#Fensterhoehe=499:#Titel="Modemtest" 
If OpenWindow(0,#RandLinks,#RandOben,#FensterBreite,#FensterHoehe,#Titel,#PB_Window_MinimizeGadget) 
      
       If OpenLibrary(0, "PORT.DLL") 
        *com_open = GetFunction (0,"OPENCOM") ;"COM2: baud=9600 data=8 parity=N stop=1" Rückgabe bei fehler=0 
        *com_close = GetFunction(0,"CLOSECOM") ; keine Parameter 
        *com_read = GetFunction(0,"READBYTE") ; -1 bei Fehler, sonst Byte 
        *com_write = GetFunction(0,"SENDBYTE") ; Byte als Zahl Typ.b 
        *com_dtr = GetFunction(0,"DTR") ; Ein/Aus 1/0 als Byte 
            ;es gibt noch mehr Befehle für den COM-Port 
            ;sie sind in der Beschreibung zu PORT.DLL zu finden 
            ;Beispiele sind für VB, lassen sich aber einfach nach PB umsetzen 
          
        libok=1 
       Else 
        MessageRequester("PORT","Bibliothek PORT konnte nicht geöffnet werden",#PB_MessageRequester_Ok) 
       EndIf 
        
       If libok=1 
       com$="COM2: baud=9600 data=8 parity=N stop=1"  ;COM2 Parameter 
       open = CallFunctionFast(*com_open,com$)        ;COM2 öffnen 
       EndIf 
        
       If open 
       CreateGadgetList(WindowID(0)) 
       Gosub Startbild ;Gadgets erzeugen 
        
        
        Repeat 
           Select WindowEvent() 
              Case #PB_Event_CloseWindow:CloseLibrary(0):End 
              Case #PB_Event_Gadget 
                Select EventGadget() 
                  Case 1 
                    Gosub lesen 
                  Case 4  
                    Gosub schreiben 
                  Case 5 
                    CallFunctionFast(*com_dtr,1) 
                  Case 6 
                    CallFunctionFast(*com_dtr,0) 

                EndSelect 
           EndSelect 
        Delay(10) 
        ForEver 
        
      Else 
        MessageRequester("COM","COM-PORT konnte nicht geöffnet werden",#PB_MessageRequester_Ok) 
    
         Repeat 
           Select WindowEvent() 
              Case #PB_Event_CloseWindow:CloseLibrary(0):End 
         EndSelect 
        Delay(10) 
        ForEver 

      EndIf 

Else 
End 
EndIf 

Startbild: 
      ButtonGadget(1,150,280,60,40,"COM lesen",#PB_Button_MultiLine) 
      StringGadget(2,100,250,160,20,inbyte$) 
      StringGadget(3,270,250,150,20,"") 
      ButtonGadget(4,310,280,60,40,"COM schreiben",#PB_Button_MultiLine) 
      ButtonGadget(5,310,350,60,20,"DTR Ein") 
      ButtonGadget(6,310,380,60,20,"DTR Aus") 
Return 


schreiben: 
      outbyte$=GetGadgetText(3)           ;Übernimmt String (AT) und sendet 
      lang=Len(outbyte$)                  ;ihn Byte für Byte an COM-Port 
      For n=1 To lang 
      outbyte=Asc(Mid(outbyte$,n,1)) 
      CallFunctionFast(*com_write,outbyte) 
      Next n 
      CallFunctionFast(*com_write,13)     ;Abschluss 
      Delay(100) 

lesen: 

      inbyte$="" 
      Repeat      
      inbyte = CallFunctionFast(*com_read);Byte lesen und zu      
      If inbyte=>0                        ;String zusammensetzen 
      inbyte$=inbyte$+Chr(inbyte) 
      EndIf 
      Until inbyte= -1                    ;Bis Puffer leer 
      SetGadgetText(2,inbyte$) 
Return 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
