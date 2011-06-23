; German forum: http://www.purebasic.fr/german/viewtopic.php?t=718&highlight=
; Author: Guido (corrected by Danilo, updated for PB 4.00 by Andre)
; Date: 06. November 2004
; OS: Windows
; Demo: No


; Traffic lights
; Ampel Grundgerüst

Procedure Ampelgrundgeruest() 
  ; zeichnet eine Ampel mit 3 grauen Kreisen 
  Box(0,63,50,142, RGB(0,2,0))        ; eine schwarze Box(x, y, Breite, Höhe [, Farbe]) 
  Circle(25, 27,20,RGB(155,155,155))  ; Circle(x, y, Radius [, Farbe]) ein grauer Kreis 
  Circle(25, 69,20,RGB(155,155,155))  ; Circle(x, y, Radius [, Farbe]) ein grauer Kreis 
  Circle(25,113,20,RGB(155,155,155))  ; Circle(x, y, Radius [, Farbe]) ein grner Kreis 
EndProcedure 

Procedure Gruen() 
  StartDrawing(ImageOutput(0)) 
    Ampelgrundgeruest() 
    Circle(25,113,20,RGB(0,155,0))  ; Circle(x, y, Radius [, Farbe]) ein grner Kreis 
  StopDrawing() ; This is absolutely needed when the drawing operations are finished !!! Never forget it ! 
  SetGadgetState(0,ImageID(0)) 
EndProcedure 

Procedure Rot() 
  StartDrawing(ImageOutput(0)) 
    Ampelgrundgeruest() 
    Circle(25,27,20,RGB(255,0,0))  ; Circle(x, y, Radius [, Farbe]) ein grauer Kreis 
  StopDrawing() ; This is absolutely needed when the drawing operations are finished !!! Never forget it ! 
  SetGadgetState(0,ImageID(0)) 
EndProcedure 

Procedure Rot_Gelb() 
  StartDrawing(ImageOutput(0)) 
    Ampelgrundgeruest() 
    Circle(25,27,20,RGB(255,0,0))  ; Circle(x, y, Radius [, Farbe]) ein grauer Kreis 
    Circle(25,69,20,RGB(255,255,0))  ; Circle(x, y, Radius [, Farbe]) ein grauer Kreis 
  StopDrawing() ; This is absolutely needed when the drawing operations are finished !!! Never forget it ! 
  SetGadgetState(0,ImageID(0)) 
EndProcedure 

Procedure Gelb() 
  StartDrawing(ImageOutput(0)) 
    Ampelgrundgeruest() 
    Circle(25,69,20,RGB(255,255,0))  ; Circle(x, y, Radius [, Farbe]) ein grauer Kreis 
  StopDrawing() ; This is absolutely needed when the drawing operations are finished !!! Never forget it ! 
  SetGadgetState(0,ImageID(0)) 
EndProcedure 

Procedure Grau() 
  StartDrawing(ImageOutput(0)) 
    Ampelgrundgeruest() 
  StopDrawing() ; This is absolutely needed when the drawing operations are finished !!! Never forget it ! 
  SetGadgetState(0,ImageID(0)) 
EndProcedure 




; Purebasic Ver. 3.30 
; öffnet ein Windowsfenster 
; WindowID = OpenWindow(#Window, x, y, InnereBreite, InnereHöhe, Flags, Titel$) 
; Mögliche Flags sind: 
; #PB_Window_SystemMenu     : Schaltet das System-Men in der Fenster-Titelzeile ein. 
; #PB_Window_MinimizeGadget : Fügt das Minimieren-Gadget der Fenster-Titelzeile hinzu. #PB_Window_System wird automatisch hinzugefügt. 
; #PB_Window_MaximizeGadget : Fügt das Maximieren-Gadget der Fenster-Titelzeile hinzu. #PB_Window_System wird automatisch hinzugefügt. 
; #PB_Window_SizeGadget     : Fügt das Größenänderungs-Gadget zum Fenster hinzu. 
; #PB_Window_Invisible      : Erstellt ein Fenster, zeigt es aber nicht an. Wird nicht unter AmigaOS unterstützt. 
; #PB_Window_TitleBar       : Erstellt ein Fenster mit einer Titelzeile. 
; #PB_Window_BorderLess     : Erstellt ein Fenster ohne jegliche Ränder. 


#ROT   = 1 
#GELB  = 2 
#GRUEN = 4 
#GRAU  = 8 

If CreateImage(0,50,142) 

  If OpenWindow(0, 100, 300, 300, 360, "Ampel", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
  
    If CreateGadgetList(WindowID(0)) 
      ImageGadget(0,50,63,50,142,ImageID(0)) 
      ButtonGadget(1,20,20,100,20,"Start");Knopf erstellen 
      ButtonGadget(2,130,20,110,20,"Stoppen");Knopf erstellen 
    EndIf 
  
    typ = 0     ; Entscheidungsschalter leeren 
    Grau()      ; leere Ampel 

    Repeat 
      Select WindowEvent() 
        Case #PB_Event_CloseWindow 
          quit = 1 
        Case #PB_Event_Gadget 
          Select EventGadget() 
          
            Case 1 
              typ = 1 : updaten = #True 
        
            Case 2 
              typ = 2 : updaten = #True 
            
          EndSelect 
        Case 0 ; kein Event 
          Delay(20) 
      EndSelect 

      sTime = GetTickCount_() 

      If (sTime >= oldTime + 2000) Or updaten ; wenn 2 sekunden verstrichen 
                                              ; oder button gedrückt wurde 
        oldTime = sTime 
        
        Beep_(800,50) ; nur zur überprüfung 

        If typ=1                    ;Schalter 1 
          If alteAnzeige = #ROT 
            Gruen()                   ; Ampel auf grün stellen 
            alteAnzeige  = #GRUEN 
          Else 
            Rot() 
            alteAnzeige  = #ROT 
          EndIf 
        ElseIf typ=2                ;Schalter 2 
          If alteAnzeige = #GRAU 
            Gelb()                   ; Ampel auf gelb stellen 
            alteAnzeige  = #GELB 
          Else 
            Grau() 
            alteAnzeige  = #GRAU 
          EndIf 
        EndIf 
        updaten = #False 
      EndIf 
      
    Until quit=1 
    
  EndIf 
  
EndIf                       ; endif des Fensterbefehles 

End   ; All the opened windows are closed automatically by PureBasic

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP