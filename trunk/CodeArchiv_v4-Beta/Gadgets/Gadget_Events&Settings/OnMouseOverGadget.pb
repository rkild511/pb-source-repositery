; German forum: http://www.purebasic.fr/german/viewtopic.php?t=3219&highlight=
; Author: PAMKKKKK (updated for PB 4.00 by Andre)
; Date: 01. May 2005
; OS: Windows, Linux
; Demo: Yes


; OnMouseOver event for gadgets
; (it's by the side also a joke program)

; OnMouseOver Event für Gadgets
; (ist nebenbei auch ein Scherzprogramm)

;****************************************************************************** 
; On mouse Over Demo 
; Peter Kriegel http://www.network-gui.de 30.April.2005 
; as the code is selfexplaining in englisch, i  use the German explanation only 
; 
; Demonstrate how you get easy an "on Mouse over" event from a Gadget 
; only for Gadgets wich are rectangular 
; Demonstriert wie man leicht ein On Mouse Over ereignis (event) von einem Gadget bekommt 
; nur für Gadgets die rechteckige werte liefern 
;****************************************************************************** 

;Procedure delivers 1 if the Mouse is ove the Gadget and 0 if is not 
;Prozedur liefert 1 wenn die Maus über dem Gadget ist und 0 wenn nicht 
;****************************************************************************** 
Procedure.b onMouseOver(WindowNr, GadgedNr) 
  X = GadgetX(GadgedNr) ; queries Gadget X erfragen 
  Y = GadgetY(GadgedNr) ; queries Gadget Y erfragen 
  Mx = WindowMouseX(WindowNr) ; queries Mouse X erfragen 
  My =WindowMouseY(WindowNr) ; queries Mouse Y erfragen 
  ; in the if, i do the rectangular calculation and the compare with the Mousecoordinates 
  ; in der if abfrage wird das Rechteckberechnet und mit den Mausekoordinaten verglichen 
  ; GadgetWidth(GadgedNr) Gadget Breite erfragen / GadgetHeight(GadgedNr) Gadget Höhe erfragen 
  If Mx > X And Mx < (X + GadgetWidth(GadgedNr)) And My > Y And My < (Y + GadgetHeight(GadgedNr) ) 
    ProcedureReturn 1 ; Mouse is over the Gadget ; Maus ist über dem Gadget 
  EndIf 
  ProcedureReturn 0 ; Mouse is not over the Gadget ; Maus ist nicht über dem Gadget 
EndProcedure 
;****************************************************************************** 
; begin Create Window and Gadgets ; Beginn Fenster und Gadgets erstellen 
If OpenWindow(1, 216, 0, 260, 135, "On Mouse over Demo", #PB_Window_TitleBar | #PB_Window_ScreenCentered | #PB_Window_Invisible) 
  If CreateGadgetList(WindowID(1)) 
    ButtonGadget(1, 30, 80, 50, 25, "No") 
    ; Paint first Image vor the Yes Button ; Das erste Bild für den Yes Knopf malen 
    If CreateImage(1, 45, 20) 
      If StartDrawing(ImageOutput(1)) ; das malen Starten 
        DrawingMode(1) 
        Box(0, 0, 45, 20 ,RGB($EC,$E9,$D8)) 
        DrawText(10, 3, "Yes") 
        StopDrawing(); dont forget !!  ; das malen Stoppen nicht vergessen !! 
      EndIf 
      ; Paint second Image vor the Yes Button ; Das zweite Bild für den Yes Knopf malen 
      If CreateImage(2, 45, 20) 
        If StartDrawing(ImageOutput(2)) ; das malen Starten 
          DrawingMode(1) 
          Box(0, 0, 45, 20 ,RGB($0,$80,$FF)) 
          DrawText(5, 3, "Sure?") 
          StopDrawing(); dont forget !!  ; das malen Stoppen nicht vergessen !! 
        EndIf 
      EndIf 
    ButtonImageGadget(2, 100, 80, 50, 25, ImageID(1))  ; the Yes Button ; Der Yes Knopf 
    EndIf 
    TextGadget(3,30,20,200,20,"Haben Sie einen kleinen Penis ?",#PB_Text_Center) 
    TextGadget(4,30,50,200,20,"Do you have a tiny dick ?",#PB_Text_Center) 
  EndIf 
EndIf 
HideWindow(1,0) 
; end Window stuff + Gadget ; Ende Fenster + Gadget  
;****************************************************************************** 
toggle = 0 ; Position switch Variable for Jumping Button ; Position Schalt Variable für den Springenden Knopf 
  Repeat 
    EventID = WaitWindowEvent() 
    If EventID <> 0 ; is true every Window event ; wird bei jedem Fensterereignis ausgeführt 
      If onMouseOver(1, 1) ; If the Mouse is over the Gadget1  then .... ; Wenn die Mause über dem Gadget1 ist dann .... 
        If toggle ; .... let the button1 jump ; .... lass den Knopf1 springen 
          ResizeGadget(1,GadgetX(1) - 140 , #PB_Ignore, #PB_Ignore, #PB_Ignore) ; move the Button in X - 200 ; verschiebe den Knopf in X - 200 
          ;UpdateWindow_(WindowID(1)) ; winAPI perhapst needed, on winXP not ; winAPI vieleicht nötig, auf winXP nicht 
          toggle = 0 
        Else 
          ResizeGadget(1,GadgetX(1) + 140 , #PB_Ignore, #PB_Ignore, #PB_Ignore); move the Button in X + 200 ; verschiebe den Knopf in X + 200 
          ;UpdateWindow_(WindowID(1)) ; winAPI perhapst needed, on winXP not ; winAPI vieleicht nötig, auf winXP nicht 
          toggle = 1        
        EndIf 
      EndIf 
      If onMouseOver(1, 2) ; If the Mouse is over the Gadget2  then .... ; Wenn die Mause über dem Gadget2 ist dann .... 
        SetGadgetState(2,ImageID(2)) ; .... use Image2 for the button2 .... ; .... benutze das Image2 für den Knopf2.... 
      Else 
        SetGadgetState(2,ImageID(1))  ; .... else use Image1 for the button2 ; .... sonnst benutze das Image1 für den Knopf2 
      EndIf 
    EndIf 
    Select EventID ; remainig Window event ; die restlichen Fensterereignisse 
    Case #PB_Event_CloseWindow 
      ;End ; The Window doesn´t close on this event !!; Das Fenster wird hier nicht geschlossen!! 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case 2 ; if Button Yes is Pressed ; Wenn der Yes Knopf gedrückt wurde 
          MessageRequester("Poor Boy!!", "Armer Junge!!", #MB_OK|#MB_ICONWARNING) 
          End ; here ends all ;Und alles zuende 
      EndSelect 
  EndSelect 
ForEver 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -