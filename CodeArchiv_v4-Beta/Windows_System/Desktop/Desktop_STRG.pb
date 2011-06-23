; www.PureArea.net
; Author: DNA
; Date: 14. December 2006
; OS: Windows
; Demo: No


; Written and tested on WinXP Home
; 
; Nutzung des Codes auf eigene Gefahr
; Autor haften nicht bei Schäden
; 
; Code darf nicht für Viren oder andere schädliche Programme genutzt werden
; Ebenso nicht für kommerziellen Dingen, ansonsten steht der Code jedem frei

; der folgende Code ist ein Beispiel zum erstellen eines Eigenen Desktops,
; aber VORSICHT!!!! Wenn Desktop erstellt wird, ist kein TaskManager mehr sichtbar
; und Desktop ist auch leer und besitzt keine ShortCuts. Diese sind alle nur
; im alten Desktop vorhanden.

; aus diesem Grund muss ein Prozess zum neu erstellten Desktop geladen werden und
; sobald dieser erstellte Prozess beendet wird, wird auch sein Desktop beendet
; und kehrt anschließend zum vorherigen Desktop zurück

; mit CDesktop wird das Erstellen von beliebigen Desktops realisiert,
; Ich hab es als OOP geschrieben und mit PB4.01 unter WinXP (Home) getestet

IncludeFile "CDesktop.pbi"

; mit newDesktop wird ein neues Desktop erstellt
; zu dem neu erstellten Desktop wird jeweils ein Explorer und der DesktopSwitch gestartet.
; Es muss mindestens ein Prozess gestartet werden, da sonst kein Desktop erstellt wird
; und sobal alle Anwendungen auf dem Desktop beendet werden, wird automatisch der
; jeweilige Desktop beendet

Procedure newDesktop(Nummer)
  Shared Mutex

  Protected newDesktop.I_Desktop
  
  LockMutex(Mutex)
    newDesktop.I_Desktop = createObject()
    newDesktop\CreateDesktop("Desktop " + Str(Nummer))
  UnlockMutex(Mutex)
  
  newDesktop\StartProcess("DeskSwitch.exe")
  newDesktop\StartProcess("Explorer.exe")
EndProcedure

; Hier werden als Beispiel 3 neue Desktops erstellt
; und anschliesend, für diesen Desktop das Hilfstool "DesktopSwitch" gestartet

Mutex = CreateMutex()
newDesktop(1)
newDesktop(2)
newDesktop(3)

RunProgram("DeskSwitch.exe")
; nachdem ein paar neue Desktops erstellt wurden kann gemacht werden was man will,
; oder die Software beenden lassen

; Um ein neues Desktop beenden zu können müssen alle seine Prozesse beendet werden
; also wie in meinem Beilspiel hier, jeweils Explorer und DesktopSwitch
; Daraufhin wird das Desktop beendet und zum Vorherigen gewechselt.

End
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -