; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1628&highlight=
; Author: Lebostein (updated for PB 4.00 by Andre)
; Date: 13. January 2005
; OS: Windows
; Demo: Yes


; Neue Keyboard-Funktion: KeyboardTyping(KeyID)
; ---------------------------------------------
; In PureBasic gibt es ja die zwei Funktionen KeyboardPushed() und 
; KeyboardReleased(). F�r eine Men�f�hrung beispielsweise, w�rde 
; KeyboardPushed() nicht viel n�tzen, da diese Funktion immer einen 
; Wert zur�ckgibt, solange die Taste gedr�ckt ist. KeyboardReleased() 
; ist hier schon besser, da die Funktion immer genau dann den Wert 
; zur�ckgibt, wenn die Taste losgelassen wurde, also einmalig. 

; Wem das nicht gef�llt, wenn eine Reaktion erst nach dem Loslassen 
; erfolgt, kann die kleine Include-Datei hier unten einbinden. 
; Mit dem Befehl KeyboardTyping() wird dann ein einmaliges Ereignis 
; genau beim Dr�cken der Taste ausgel�st, so wie man es bei vielen 
; Spielen/Programmen gewohnt ist: 


;************************************************************** 
;* INCLUDE FOR PUREBASIC 3.92 
;************************************************************** 
;* Titel: KeyboardTyping 
;* Autor: Lebostein 
;* Datum: 13.01.2005 
;************************************************************** 

;============================================================== 
; Variablen und Konstanten der Include-Datei 
;============================================================== 

Global NewList PushedKeys.l() 

;============================================================== 
; Entfernt Eintr�ge von Tasten, die losgelassen wurden 
;============================================================== 

Procedure ExamineKeyboardTyping() 

  ForEach PushedKeys(): If KeyboardPushed(PushedKeys()) = 0: DeleteElement(PushedKeys()): EndIf: Next 

EndProcedure 

;============================================================== 
; Gibt einmalig 1 zur�ck, wenn Taste niedergedr�ckt wird 
;============================================================== 

Procedure KeyboardTyping(code) 

  If KeyboardPushed(code) = 0: ProcedureReturn: EndIf 
  ForEach PushedKeys(): If PushedKeys() = code: exist = 1: EndIf: Next 
  If exist = 0: AddElement(PushedKeys()): PushedKeys() = code: ProcedureReturn 1: EndIf 

EndProcedure 

;============================================================== 
; Ende der Include-Datei 
;============================================================== 



;---------------------------- Schnitt ---------------------------------- 

; Hier ein kleines Beispiel: 

InitSprite() 
InitKeyboard() 

ExamineDesktops()
Screenwidth  = DesktopWidth(0)
Screenheight = DesktopHeight(0)

OpenScreen(Screenwidth,Screenheight,16,"KeyboardTyping") 

status = 1 

Repeat 

ExamineKeyboard() 
ExamineKeyboardTyping() 

If KeyboardTyping(#PB_Key_Up)   And status > 1: status - 1: EndIf 
If KeyboardTyping(#PB_Key_Down) And status < 6: status + 1: EndIf 

ClearScreen(RGB(0,0,0))
StartDrawing(ScreenOutput()) 
  DrawingMode(1) 
  For eintrag = 1 To 6 
  If eintrag = status: FrontColor(RGB(255,0,0)): Else: FrontColor(RGB(255,255,255)): EndIf 
  Select eintrag 
  Case 1: DrawText(100, eintrag * 20, "Spiel starten") 
  Case 2: DrawText(100, eintrag * 20, "Einstellungen") 
  Case 3: DrawText(100, eintrag * 20, "Credits") 
  Case 4: DrawText(100, eintrag * 20, "Handbuch lesen") 
  Case 5: DrawText(100, eintrag * 20, "Leveleditor starten") 
  Case 6: DrawText(100, eintrag * 20, "Spiel verlassen") 
  EndSelect 
  Next eintrag 
StopDrawing() 
FlipBuffers() 

Until KeyboardTyping(#PB_Key_Escape) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -