; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2318&highlight=
; Author: Andreas
; Date: 18. September 2003
; OS: Windows
; Demo: No


; Frage:
;   Welche Vorraussetzungen sind nötig, damit ein Programm in der Systemsteuerung angezeigt wird ?
; Antwort:
;   In der Systemsteuerung werden die CPL-Dateien die sich im Systemordner befinden angezeigt.
;   CPL-Dateien sind nichts anderes als DLL's mit einer exportierten Funktion. Die Funktion
;   heisst CPIApplet und niemals anders. 
;   Was Du also machen musst ist folgendes:
;   In PB die Dll erstellen, umbenennen in CPL und in die Windows-System-Ordner kopieren. 

;   Beispiel : 

;###################### 
;CPIApplet-Grundgerüst 
;###################### 
;Author : Andreas 
;###################### 
;Compiler-Option: DLL 
;nach Erstellen in CPL umbenennen und in 
;den Windows System-Ordner kopieren 
;Danach erscheint das icon in der Systemsteuerung 
;###################### 
;Das Beispiel öffnet lediglich Notepad und zeigt die 
;Autoexec.bat an. 
;###################### 


ProcedureDLL.l CPlApplet(hwndCPI.l,uMsg.l,lParam1.l,lParam2.l) 
  Shared Name.s,Info.s 
  
  #CPL_DBLCLK  = 5 
  #CPL_EXIT = 7 
  #CPL_GETCOUNT = 2 
  #CPL_INIT = 1 
  #CPL_INQUIRE = 3 
  #CPL_STOP = 6 
  #CPL_NEWINQUIRE = 8 
  
  Structure NEWCPLINFO 
    dwSize.l 
    dwFlags.l 
    dwHelpContext.l 
    lData.l 
    hIcon.l 
    szName.b[32] 
    szInfo.b[64] 
    szHelpFile.b[128] 
  EndStructure 
  
  Select uMsg 
    Case #CPL_INIT 
      ;beim Initieren die Variablen füllen 
      Name = "Das ist der Name";Name der unter dem Icon erscheint (max. 32) 
      Info = "Das ist die Info";Info die in der Statusbar erscheint (max. 64) 
      result = 1 
    Case #CPL_GETCOUNT 
      result = 1 ;1 Icon 
    Case #CPL_NEWINQUIRE 
      ;Informationen setzen 
      *cp.NEWCPLINFO = lParam2 
      *cp\dwSize = SizeOf(NEWCPLINFO) 
      *cp\hIcon = ExtractIcon_(0,"Notepad.exe",0) 
      PokeS(@*cp\szName[0], Name) 
      PokeS(@*cp\szInfo[0], Info) 
      result = 0 
    Case  #CPL_DBLCLK 
      ;hier passiert alles was beim Doppelklick auf das Icon passieren soll 
      ;in diesem Fall wird Notepad gestartet 
      RunProgram("Notepad.exe","c:\autoexec.bat", "c:\", 0) 
      result = 0 
    Case #CPL_STOP 
      result = 0 
    Case #CPL_EXIT 
      result = 0 
  EndSelect 
  ProcedureReturn result 
EndProcedure  


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
