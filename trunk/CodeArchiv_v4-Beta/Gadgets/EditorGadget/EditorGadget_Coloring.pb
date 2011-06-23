; German forum: http://www.purebasic.fr/german/viewtopic.php?t=636&highlight=
; Author: Falko (updated for PB 4.00 by Andre)
; Date: 28. October 2004
; OS: Windows
; Demo: 
; OS; Windows
; Demo: No


; Selektierte Buchstaben ersetzen bzw. färben.
; Codeschnipsel written by Falko
; --------------------------------------------
; Der source mit API-Funktionen ist soweit angepasst, sodass du
; damit Buchstaben, Sätze oder Wörter färben, austauschen oder sogar
; einen Font vergeben kannst. Ich hoffe du kannst es brauchen.

String$="Mein Test"
Buffer$=Space(255)
Global hdc
Global mychar.CHARFORMAT

;
;Ermittle die Anzahl Buchstaben der obrigen Zeile
;
Procedure.l GetCursorPos(YPos.l)
  Result = SendMessage_(hdc,#EM_LINEINDEX,YPos,0)
  ProcedureReturn Result
EndProcedure
;
; Farbe und Fontattribute setzen
Procedure SetCharFormat(Mask.l,Effects.l,Color.l)
  ;mychar.CHARFORMAT ; Sollte vorher als global deklariert werden.
  mychar\cbSize=SizeOf(CHARFORMAT)
  mychar\dwMask=Mask;#CFM_BOLD|#CFM_COLOR ; Fettschrift und Color setzen
  mychar\dwEffects=Effects
  mychar\yHeight=500
  mychar\crTextColor=Color
  mychar\bCharSet=0
  PokeS(@mychar\szFaceName, "Symbol")
EndProcedure


If OpenWindow(0,0,0,322,275,"StringGadget Flags",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
  hdc.l=EditorGadget (0,8,8,306,259,#PB_Container_Raised)
  AddGadgetItem(0,0,"Wie wäre es mit dieser Zeile, die wir ändern wollen.")
  AddGadgetItem(0,1,"Wie wäre es mit dieser Zeile, die wir ändern wollen.")
  AddGadgetItem(0,2,"Wie wäre es mit dieser Zeile, die wir ändern wollen.")
  ;
  ;In dieser Zeile ein Teilstring, Farbe und Fontattribut verändern
  ;
  Char=GetCursorPos(1)
  SendMessage_(hdc,#EM_SETSEL,Char+16,Char+28); markiere Textteil, der geändert werden soll
  SetCharFormat(#CFM_BOLD|#CFM_COLOR,1,$0000FF)
  SendMessage_(hdc,#EM_SETCHARFORMAT,#SCF_SELECTION,mychar); Setzen der Attribute auf selection
  SendMessage_(hdc,#EM_REPLACESEL,0,String$); Ersetze diesen Teil duch den String$
  ;
  ;Textteil Markieren und durch nur Farbe Blau und Fontattribute ersetzen
  ;

  Char=GetCursorPos(2)
  SendMessage_(hdc,#EM_SETSEL,Char+8,Char+8+8); markiere Textteil, der gefärbt werden soll
  SetCharFormat(#CFM_FACE | #CFM_SIZE | #CFM_COLOR,1,$FF0000)
  SendMessage_(hdc,#EM_SETCHARFORMAT,#SCF_SELECTION,mychar);Chare-Attribute setzen
  SendMessage_(hdc,#EM_GETSELTEXT,0,Buffer$); kopiere Selektieren Text in den Buffer
  SendMessage_(hdc,#EM_REPLACESEL,0,Buffer$); ersetze Text dann aus dem Buffer mit den Attributen


  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
