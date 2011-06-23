; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=4746&postdays=0&postorder=asc&start=20
; Author: sharkpeter (updated for PB 4.00 by Andre)
; Date: 03. August 2004
; OS: Windows
; Demo: No



; Ansteuerung einer PIO-E/A-Karte von Jens Haipeter 03.08.2004 Version 0.1-2004-08-03
; -----------------------------------------------------------------------------------
; Ein kleines Vorwort:
;
; Dieses Programm setzt zum einen Voraus, daß man die InpOut32.dll besitzt. Sie gehört
;  nach ..\Windows\System32\. Zu bekommen ist sie bei FALKO auf seiner Web-Site
; www.falko-pure.de als Link bzw. beim Erzeuger und MutterVater www.logix4u.net.
; Die andere Voraussetzung ist der Besitz einer Karte mit PIO-8255 z.B. von
; BMC-Messsysteme eine PIO-24-II oder PIO-48-II (ISA-Bus!).
;
; OS Grenzen gibt es für 9x/XP keine (NT/2000 weiß ich nicht, habe ich nicht), außer
; man hat keine ISA-Slots auf dem Board  .
; Für Tüftler: PIO selber bauen.
;
; Ausgangsbasis für die Adressierung ist die Grundkonfiguration der Karte PIO-xx-II
; von BMCM. Die 1. Adresse ist $210 = 528 im E/A-Bereich.
;
; Die Aufteilung der Adressen auf der Karte ist wie folgt gegeben:
; PORT A PIO1 $210 PIO2 $214
; PORT B PIO1 $211 PIO2 $215
; PORT C PIO1 $212 PIO2 $216
; Betriebsart-Steuerwort PIO1 $213 PIO2 $217
; Die PIO2 existiert nur bei PIO-II-48 sonst ist nur ein Baustein auf der Karte.
; Einschaltzustand ist Reset-Zustand, d.h. alle 24 Kanäle einer PIO sind Inputs.
;
; Ich bilde einen externen Bus nach, mit 8 Bit Adressen und 8 Bit Daten sowie der
; minimal möglichen Anzahl Steuerleitungen: IORQ, RD, WR und zusätzlich, da das
; System außen statisch ist, eine Leitung ADROK zur Übernahme der Adressen in einen
; externen Puffer (8282 u.a.). Die Invertierung zu L-Aktiv erfolgt auf einer externen
; Koppelbaugruppe (Systemkompatibilität zum Z-80-Bus).
;
; Hier eine Bemerkung, bevor unzählige Igit, Z80, Igit ankommen:
; Der Z80 war zu seiner Zeit ein wunderbarer Prozessor, in der DDR auch als U880D
; bekannt und in den seinerzeitigen KC-Computern eingebaut. Nun ist es so, ich habe
; damals damit angefangen und möchte nicht meine gesamte externe Hardware neu erstellen,
; weil die nämlich seit Jahren einwandfrei funktioniert, inzwischen auch schon eine
; ganze Weile an einem PC, jedoch noch unter DOS (QBasic). Außerdem ist dies hier nur
; ein Nutzungsvorschlag.
;
; Die Aufteilung der Port's ist wie folgt festgelegt:
; Port A - Adressbus
; Port B - Datenbus
; Port C - Systembus
; Daher ist es nur notwendig, die Betriebsart von Kanal B umzuschalten.
; Steuerwort B lesen: $82 - D 130
; Steuerwort B schreiben: $80 - D 128
;
; Die beiden anderen Kanäle sind fest auf schreiben. Achtung! Keine Speisung von Außen
; vornehmen, Ausgänge nicht kurzschließen Zerstörungsgefahr für PIO-Baustein! (Aber
; das brauche ich ja nicht erwähnen, sind ja nur Profis hier  )
;
; Alle anderen Steuerwortkombinationen bitte der Literatur entnehmen, das Ganze dient
; nur als Nutzungsbeispiel. Sinngleich gilt diese Aufteilung auch die 2.PIO auf der
; Karte, soweit vorhanden.
;
; BITTE UNBEDINGT SICHERSTELLEN, DASS DIE ADRESSEN RICHTIG SIND FÜR DIE HARDWARE!
; KOLLISIONS- UND BESCHÄDIGUNGSGEFAHR!!!
;
; Die Systembus-Signale sind nicht die des PC, sondern ein eigenes Software gesteuertes
; Abbild.
;
; An der externen Koppelbaugruppe sollte man die RD und WR Signale (XOR) verriegeln,
; sowie dafür Sorge tragen, daß nicht gegen einen Ausgang getrieben wird. Die PIO 8255
; kann maximal 1 mA je Ausgang treiben, so daß ohnehin ein zusätzlicher Treiberbaustein
; extern notwendig wird. Dort werden auch die Invertierungen der Systembussignale
; sinnvollerweise mit vorgenommen (8282,8283,8286,8287 je nach Aufgabe zwischenspeichernd,
; invertierendzwischenspeichernd, bidirektional, invertierendbidirektional). Freilich ist
; es auch möglich, sofort Low-aktive Systembus-Signale zu generieren, habe ich aber nicht
; getan, da bin ich bockig
;
; Benutzt für den Systembus wird das 1.Nibble, so man mag kann man z.B. auf das 2.Nibble
; noch MERQ und RESET legen und hat immer noch 2 Bit für weitere Funktionen frei. Möglich
; ist auch eine Word-Ausgabe, in dann notwendiger Weise sequentieller Form oder ganz was
; man sonst noch so mag, dies ist wie gesagt eine Anregung
;
; Bitfunktionen von Kanal C 1.Nibble
; Bit0 - ADROK Übernahmebit Registereintrag Adresse gültig
; Bit1 - IORQ E/A-Anforderungssignal
; Bit2 - WR schreiben der Daten in Register o.ä.
; Bit3 - RD lesen von Daten aus Register o.ä.
;
; Sinnvolle Werte für Kanal C sind daher (wenn nur 1.Nibble benutzt wird):
; 0 Systembus OFF
; 1 Adressübernahme
; 2 IORQ-Signal einzeln
; 4 WR-Signal einzeln
; 6 schreiben in externes Register oder auf externe Adresse (WR und IORQ gleichzeitig)
; 8 RD-Signal einzeln
; 10 lesen aus externem Register oder von externer Adresse (RD und IORQ gleichzeitig)
;
; Um sicherzustellen, daß, wenn das externe System dynamisch arbeiten soll, die Adressen
; und Daten korrekt geschrieben oder gelesen werden, kann es sinnvoll sein folgende Werte
; auszugeben (auf den Systembus; versetzt, mit einer kurzen Wartezeit z.B. 1 - 10ms):
;
; schreiben:
;
; 1 Adressübernahme
; 2 IORQ-Signal einzeln
; 4 WR-Signal einzeln
; 2 IORQ-Signal einzeln
; 0 Systembus OFF
;
; lesen:
;
; 1 Adressübernahme
; 2 IORQ-Signal einzeln
; 8 RD-Signal einzeln
; 2 IORQ-Signal einzeln
; 0 Systembus OFF
;
; Im allgemeinen reicht es jedoch aus, auf diesem Wege zu verfahren, jeweils mit einer
; kleinen Wartezeit zwischen den Vorgängen von 1 - 10ms, wo sinnvoll:
;
; schreiben:
;
; Kanal B auf schreiben setzen mit Steuerwort $80
; Adressebyte auf Kanal A ausgeben
; Adresse gültig setzen Kanal C auf 1
; Systembus OFF Kanal C auf 0 (muss nicht unbedingt sein)
; Datenbyte auf Kanal B ausgeben
; Datenbyte in externes Register eintragen mit Kanal C auf 6 (IORQ und WR)
; Systembus OFF Kanal C auf 0
; Kanal B wieder auf lesen mit Steuerwort $82
;
; lesen:
;
; Kanal B auf lesen setzen mit Steuerwort $82
; Adressebyte auf Kanal A ausgeben
; Adresse gültig setzen Kanal C auf 1
; Systembus OFF Kanal C auf 0 (muss nicht unbedingt sein)
; Datenbyte extern auf Bus legen mit Kanal C auf 10 (IORQ und RD)
; Datenbyte übernehmen in Kanal B
; Systembus OFF Kanal C auf 0
;
; So, nun viel Spaß all denen, die es interessiert. Laßt die Hardware heile, Sand ist auf
; eine einfachere Art zu gewinnen, ohne Umwege über Chip's!
;
;Programmcode PIO_E/A_V0.1 by Jens Haipeter 03.08.2004
;erstellt mit PB_V3.91 fullversion

;Konstanten
#WinName = "PIO-Port Ein-/Ausgabe by Jens Haipeter V0.1-2004-08-03"
#Lib_0    = 0
#Window_0 = 0
#Text_0   = "Wert Datenbyte :"
#Text_1   = "Wert Adressbyte:"
#Text_2   = "Datenbyte binär:"

;Buttonnummerierung
Enumeration
  #Button_0 : #Button_1 : #Button_2 : #Button_3 : #Button_4
  #String_0 : #String_1
  #TextGT_0 : #TextGT_1 : #TextGT_2
EndEnumeration

;Globale
Global _addr.l
Global _data.l
Global _datb.s
Global _RwSelect.s
Global _infotit.s
Global _infomsg.s

;Wertzuweisungen
_addr     = 256
_data     =-1
MessageID = 0
_infotit  = "INFORMATION"
_infomsg  = "no message"

;Proceduren
;Message Box
Procedure MessageBox()
  MessageRequester(_infotit,_infomsg,0)
  _infotit="INFORMATION"
  _infomsg="no message"
  MessageID=1
EndProcedure

;Button erzeugen
Procedure GadgetList()
  If CreateGadgetList(WindowID(#Window_0))
    ButtonGadget(#Button_0, 10,215,120, 25,"Datenbyte lesen")
    ButtonGadget(#Button_1,140,215,120, 25,"Datenbyte schreiben")
    ButtonGadget(#Button_2,270,215,120, 25,"verlassen")
    ButtonGadget(#Button_4, 10, 60,120, 25,"Datenbyte übernehmen")
    ButtonGadget(#Button_3,140, 60,120, 25,"Adressbyte übernehmen")
    StringGadget(#String_1, 10, 20,120, 25,"")
    StringGadget(#String_0,140, 20,120, 25,"")
    TextGadget  (#TextGT_0, 10,150,120, 50,#Text_0+Chr(13)+Chr(13)+Str(_data)+"/"+Hex(_data)+"H",#PB_Text_Center)
    TextGadget  (#TextGT_1,140,150,120, 50,#Text_1+Chr(13)+Chr(13)+Str(_addr)+"/"+Hex(_addr)+"H",#PB_Text_Center)
    TextGadget  (#TextGT_2,270,150,120, 50,#Text_2+Chr(13)+Chr(13)+_datb,#PB_Text_Center)
  EndIf
  DisableGadget(#String_0,1)
  DisableGadget(#Button_3,1)
  DisableGadget(#String_1,1)
  DisableGadget(#Button_4,1)
EndProcedure

;Dll laden
Procedure LoadDll()
  If OpenLibrary(#Lib_0,"inpout32.dll")
  Else
    MessageRequester("Fehler", "inpout32.dll konnte nicht geöffnet werden!")
    End ;Abbruch wenn nicht geladen
  EndIf
EndProcedure

;Grundzustand herstellen
Procedure PIOClear()
  ;PIO1
  CallFunction(#Lib_0,"Out32",$213,$82)       ;Kanal B auf lesen
  CallFunction(#Lib_0,"Out32",$212,$0)        ;Systembus auf 0
  CallFunction(#Lib_0,"Out32",$210,$FF)       ;Adressbus auf 255
  Delay(1)
  CallFunction(#Lib_0,"Out32",$212,$1)        ;Systembus auf 1, Adresse FFH setzen
  Delay(1)
  CallFunction(#Lib_0,"Out32",$212,$0)        ;Systembus auf 0
  ;PIO2
  CallFunction(#Lib_0,"Out32",$217,$82)       ;Kanal B auf lesen
  CallFunction(#Lib_0,"Out32",$216,$0)        ;Systembus auf 0
  CallFunction(#Lib_0,"Out32",$214,$FF)       ;Adressbus auf 255
  Delay(1)
  CallFunction(#Lib_0,"Out32",$216,$1)        ;Systembus auf 1, Adresse FFH setzen
  Delay(1)
  CallFunction(#Lib_0,"Out32",$216,$0)        ;Systembus auf 0
EndProcedure

;Datenkanal lesen PIO1
Procedure ReadPIO()
  _data=-1
  If _addr>-1 And _addr<256
    CallFunction(#Lib_0,"Out32",$213,$82)     ;Kanal B auf lesen
    CallFunction(#Lib_0,"Out32",$210,_addr)   ;Adresse setzen
    Delay(1)
    CallFunction(#Lib_0,"Out32",$212,$1)      ;Systembus auf 1, Adresse übernehmen
    Delay(1)
    CallFunction(#Lib_0,"Out32",$212,$0)      ;Systembus auf 0
    CallFunction(#Lib_0,"Out32",$212,$A)      ;IORQ und RD setzen
    Delay(1)
    _data=CallFunction(#Lib_0,"Inp32",$211)   ;Datenübernahme von aussen
    Delay(1)
    CallFunction(#Lib_0,"Out32",$212,$0)      ;Systembus auf 0
    CallFunction(#Lib_0,"Out32",$210,$FF)     ;Adressbus auf 255
    Delay(1)
    CallFunction(#Lib_0,"Out32",$212,$1)      ;Systembus auf 1, Adresse FFH setzen
    Delay(1)
    CallFunction(#Lib_0,"Out32",$212,$0)      ;Systembus auf 0
  Else
    _infomsg="Adressbyte falscher Wert"+Chr(13)+Chr(13)+"Adress-Wert :"+Hex(_addr)+"H"
    MessageBox()
  EndIf
  SetGadgetText(#TextGT_0,#Text_0+Chr(13)+Chr(13)+Str(_data)+"/"+Hex(_data)+"H")
  SetGadgetText(#TextGT_1,#Text_1+Chr(13)+Chr(13)+Str(_addr)+"/"+Hex(_addr)+"H")
EndProcedure

;Datenkanal schreiben PIO1
Procedure WritePIO()
  If _addr>-1 And _addr<256
    If _data>-1 And _data<256
      CallFunction(#Lib_0,"Out32",$213,$80)   ;Kanal B auf schreiben
      CallFunction(#Lib_0,"Out32",$210,_addr) ;Adresse setzen
      Delay(1)
      CallFunction(#Lib_0,"Out32",$212,$1)    ;Systembus auf 1, Adresse übernehmen
      Delay(1)
      CallFunction(#Lib_0,"Out32",$212,$0)    ;Systembus auf 0
      CallFunction(#Lib_0,"Out32",$211,_data) ;Datenübergabe nach aussen
      Delay(1)
      CallFunction(#Lib_0,"Out32",$212,$6)    ;IORQ und WR setzen
      Delay(1)
      CallFunction(#Lib_0,"Out32",$212,$0)    ;Systembus auf 0
      CallFunction(#Lib_0,"Out32",$213,$82)   ;Kanal B auf lesen
      CallFunction(#Lib_0,"Out32",$210,$FF)   ;Adressbus auf 255
      Delay(1)
      CallFunction(#Lib_0,"Out32",$212,$1)    ;Systembus auf 1, Adresse FFH setzen
      Delay(1)
      CallFunction(#Lib_0,"Out32",$212,$0)    ;Systembus auf 0
    Else
      _infomsg="Datenbyte falscher Wert"+Chr(13)+Chr(13)+"Daten-Wert :"+Hex(_data)+"H"
      MessageBox()
    EndIf
  Else
    _infomsg="Adressbyte falscher Wert"+Chr(13)+Chr(13)+"Adress-Wert :"+Hex(_addr)+"H"
    MessageBox()
  EndIf
  SetGadgetText(#TextGT_0,#Text_0+Chr(13)+Chr(13)+Str(_data)+"/"+Hex(_data)+"H")
  SetGadgetText(#TextGT_1,#Text_1+Chr(13)+Chr(13)+Str(_addr)+"/"+Hex(_addr)+"H")
EndProcedure

;Umsetzen in Bit-Schreibweise
Procedure ConvData()
  If _data>-1
    _datb="%"+Bin(_data)
    SetGadgetText(#TextGT_2,#Text_2+Chr(13)+Chr(13)+_datb)
  EndIf
EndProcedure

;Selection Ein-/Ausgabe
Procedure InOutSelect()
  If GetGadgetText(#String_0)=""
    SetGadgetText(#String_0,"256")
  EndIf
  If _RwSelect="read"
    _addr=Val(LTrim(GetGadgetText(#String_0)))
    ReadPIO()
    ConvData()
    _addr=256
    _data=-1
  EndIf
  If _RwSelect="write"
    If GetGadgetText(#String_1)=""
      SetGadgetText(#String_1,"-1")
    EndIf
    _addr=Val(LTrim(GetGadgetText(#String_0)))
    _data=Val(LTrim(GetGadgetText(#String_1)))
    WritePIO()
    ConvData()
    _addr=256
    _data=-1
  EndIf
  DisableGadget(#Button_0,0)
  DisableGadget(#Button_1,0)
  DisableGadget(#Button_3,1)
  DisableGadget(#String_0,1)
  DisableGadget(#Button_4,1)
  DisableGadget(#String_1,1)
  _RwSelect="Off"
EndProcedure

;Hauptschleife
If OpenWindow(#Window_0,200,200,400,250,#WinName,#PB_Window_TitleBar)
  GadgetList()
  LoadDll()
  PIOClear()
  _RwSelect="Off"
  Repeat
    EventID = WaitWindowEvent()
    If EventID = #PB_Event_Gadget
      Select EventGadget()
        Case #Button_0 ;lesen
          DisableGadget (#Button_0,1)
          DisableGadget (#Button_1,1)
          DisableGadget (#Button_3,0)
          DisableGadget (#String_0,0)
          SetGadgetText (#String_0,"")
          SetGadgetText (#String_1,"")
          SetActiveGadget(#String_0)
          _RwSelect="read"
        Case #Button_1 ;schreiben
          DisableGadget (#Button_0,1)
          DisableGadget (#Button_1,1)
          DisableGadget (#Button_3,1)
          DisableGadget (#String_0,1)
          DisableGadget (#String_1,0)
          DisableGadget (#Button_4,0)
          SetGadgetText (#String_0,"")
          SetGadgetText (#String_1,"")
          SetActiveGadget(#String_1)
          _RwSelect="write"
        Case #Button_2 ;verlassen
          EventID=#PB_Event_CloseWindow
        Case #Button_3 ;Adresse auswählen und setzen
          InOutSelect()
        Case #Button_4 ;Daten auswählen und setzen
          DisableGadget (#String_1,1)
          DisableGadget (#Button_4,1)
          DisableGadget (#String_0,0)
          DisableGadget (#Button_3,0)
          SetActiveGadget(#String_0)
      EndSelect
    EndIf
  Until EventID = #PB_Event_CloseWindow
EndIf
;kann auch wegbleiben, da eigentlich automatisch
;ich bin aber für saftyprocess
If CloseLibrary(#Lib_0)  :EndIf
If CloseWindow(#Window_0):EndIf
;Programmende
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP