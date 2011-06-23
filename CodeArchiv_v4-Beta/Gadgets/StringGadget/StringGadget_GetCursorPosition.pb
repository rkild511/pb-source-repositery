; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=862&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 04. May 2003
; OS: Windows
; Demo: No

; Allerdings bitte ich folgendes zu beachten: 
; Das updaten via Timer ist nicht gut, sondern wurde hier von mir 
; nur zu Demonstrationszwecken gewählt. 
; Normalerweise sitzen die UpdatePunkte im WindowCallback... 
; 
; Hier geht es nur darum die Funktion der Prozeduren 'StringGadgetCursorX/Y' zu zeigen...

; 
; by Danilo, 04.05.2003 - german forum 
; 
Procedure StringGadgetCursorX(Gadget) 
  SendMessage_(GadgetID(Gadget),#EM_GETSEL,@Min,@Max) 
  ProcedureReturn Max-SendMessage_(GadgetID(Gadget),#EM_LINEINDEX,SendMessage_(GadgetID(Gadget),#EM_LINEFROMCHAR,Min,0),0)+1 
EndProcedure 

Procedure StringGadgetCursorY(Gadget) 
  SendMessage_(GadgetID(Gadget),#EM_GETSEL,@Min,@Max) 
  ProcedureReturn SendMessage_(GadgetID(Gadget),#EM_LINEFROMCHAR,Min,0)+1 
EndProcedure 

;- Programm 

#STRINGGADGET1 = 1 

Procedure UpdateStringGadgetPos() 
  Shared UpdateStringGadgetPos_oldX, UpdateStringGadgetPos_oldY 
  x = StringGadgetCursorX(#STRINGGADGET1) 
  y = StringGadgetCursorY(#STRINGGADGET1) 
  If x<>UpdateStringGadgetPos_oldX Or y<>UpdateStringGadgetPos_oldY 
    SetGadgetText(2,"X: "+RSet(Str(x),5,"0")+"   Y: "+RSet(Str(y),5,"0")) 
    UpdateStringGadgetPos_oldX = x : UpdateStringGadgetPos_oldY = y 
    Beep_(800,10) 
  EndIf 
EndProcedure 


EOL.s = Chr(13)+Chr(10) 
For a = 1 To 100 
  A$+"Zeile "+RSet(Str(a),3,"0")+EOL 
Next a 
A$+"<< ENDE >>" 


OpenWindow(1,200,200,200,420,"",#PB_Window_SystemMenu) 
   CreateGadgetList(WindowID(1)) 
   StringGadget(#STRINGGADGET1,3,3,194,394,A$,#ES_NOHIDESEL|#ES_MULTILINE|#WS_VSCROLL|#WS_HSCROLL) 
   SetGadgetFont(#STRINGGADGET1,LoadFont(1,"Lucida Console",14)) 
   TextGadget(2,3,400,194,17,"") 

SetTimer_(WindowID(1),1,100,0) 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow: End 
    Case #WM_TIMER 
      UpdateStringGadgetPos() 
  EndSelect 
ForEver 
 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
