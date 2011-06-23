; German forum: http://www.purebasic.fr/german/viewtopic.php?t=11579&highlight=
; Author: bax
; Date: 10. January 2007
; OS: Windows
; Demo: Yes


; Bax - 01|07 
; PB 4.02 

If OpenWindow(0, 0, 0, 178, 590, "Pokerhilfe", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered) 

  ; Konstanten für die vier Farben 
  Enumeration 
    #Pik 
    #Karo 
    #Kreuz 
    #Herz 
  EndEnumeration 

  Global NewList cards.l()   ; Liste der ausgewählten Karten 
  Global result.l            ; Bewertungsergebnis 

  ;{ Images für die vier Farben 
  CreateImage(#Karo, 32, 32) 
    StartDrawing(ImageOutput(#Karo)) 
      Box(0, 0, 32, 32, $D8E9E9) 
      LineXY(16,  0, 32, 16, $0000FF) 
      LineXY(32, 16, 16, 32, $0000FF) 
      LineXY(16, 32,  0, 16, $0000FF) 
      LineXY( 0, 16, 16,  0, $0000FF) 
      FillArea(16, 16, $0000FF, $0000FF) 
    StopDrawing() 
  CreateImage(#Herz, 32, 32) 
    StartDrawing(ImageOutput(#Herz)) 
      Box(0, 0, 32, 32, $D8E9E9) 
      Circle(9, 9, 8, $0000FF) 
      Circle(23, 9, 8, $0000FF) 
      LineXY(0, 8, 16, 30, $0000FF) 
      LineXY(32, 8, 16, 30, $0000FF) 
      FillArea(16, 24, $0000FF, $0000FF) 
    StopDrawing() 
  CreateImage(#Pik, 32, 32) 
    StartDrawing(ImageOutput(#Pik)) 
      Box(0, 0, 32, 32, $D8E9E9) 
      Circle(9, 16, 7, $000000) 
      Circle(23, 16, 7, $000000) 
      Box(15, 16, 2, 16, $000000) 
      LineXY(3, 13, 16, 0, $000000) 
      LineXY(29, 13, 16, 0, $000000) 
      Circle(16, 32, 6, $000000) 
      FillArea(16, 8, $000000, $000000) 
    StopDrawing() 
  CreateImage(#Kreuz, 32, 32) 
    StartDrawing(ImageOutput(#Kreuz)) 
      Box(0, 0, 32, 32, $D8E9E9) 
      Circle(8, 16, 5, $000000) 
      Circle(16, 8, 5, $000000) 
      Circle(24, 16, 5, $000000) 
      Box(8, 15, 16, 2, $000000) 
      Box(15, 8, 2, 24, $000000) 
      Circle(16, 32, 5) 
    StopDrawing() 
  ;} 

  CreateGadgetList(WindowID(0)) 
    ; Kartenauswahl für jede Farbe (x) 
    For x=0 To 3 
      ImageGadget(x*14, 10 + x*42, 10, 32, 32, ImageID(x)) 
      For y=2 To 10 
        ButtonGadget(x*14 + (y-1), 10 + x*42, 36 + (y-1)*24, 32, 24, Str(y), #PB_Button_Toggle) 
      Next 
      ButtonGadget(x*14 + 10, 10 + x*42, 286, 32, 24, "J", #PB_Button_Toggle) 
      ButtonGadget(x*14 + 11, 10 + x*42, 310, 32, 24, "Q", #PB_Button_Toggle) 
      ButtonGadget(x*14 + 12, 10 + x*42, 334, 32, 24, "K", #PB_Button_Toggle) 
      ButtonGadget(x*14 + 13, 10 + x*42, 368, 32, 24, "A", #PB_Button_Toggle) 
    Next 
    
    ; Position des Spielers 
    OptionGadget(56,  10, 402, 53, 20, "First")  :  SetGadgetState(56, #True) 
    OptionGadget(57,  63, 402, 53, 20, "Middle") 
    OptionGadget(58, 116, 402, 52, 20, "Last") 

    ; Besonderheiten 
    CheckBoxGadget(60, 10, 432, 158, 20, "suited") 
    CheckBoxGadget(61, 10, 452, 158, 20, "pair") 
    CheckBoxGadget(62, 10, 472, 158, 20, "straight chance") 

    ; Ausrechnen 
    ButtonGadget(  59, 10, 502, 158, 24, "Berechnen")  :  DisableGadget(59, #True) 
    TextGadget(    63, 50, 526,  79, 20, "", #PB_Text_Center|#PB_Text_Border) 

    ; Zurücksetzen 
    ButtonGadget(64, 10, 556, 158, 24, "Zurücksetzen") 



  Repeat 
    Select WaitWindowEvent() 
      Case #PB_Event_CloseWindow 
        Break 
      Case #PB_Event_Gadget 

        ; Karte auswählen / aus Auswahl entfernen 
        If (EventGadget() < 56) And (EventGadget() % 14) 
          If GetGadgetState(EventGadget()) 
            AddElement(cards())  :  cards() = EventGadget() 
          Else 
            ForEach cards()   ; die richtige Karte löschen 
              If cards() = EventGadget() 
                DeleteElement(cards()) 
                Break 
              EndIf 
            Next 
          EndIf 
          ; Berechnen möglich / unmöglich: 
          If CountList(cards()) = 2  :  DisableGadget(59, #False)  :  Else  :  DisableGadget(59, #True)  :  EndIf 


        ; Berechnen: 
        ElseIf EventGadget() = 59 
          result = 0 
        
          SelectElement(cards(), 0)  :  card_1 = cards() 
          SelectElement(cards(), 1)  :  card_2 = cards() 

          If (card_1 / 14) = (card_2 / 14) Or GetGadgetState(60)  :  result + 4  :  EndIf   ; gleiche Farbe 
          If (card_1 % 14) = (card_2 % 14) Or GetGadgetState(61)  :  result + 4  :  EndIf   ; Paar 
          If GetGadgetState(62)                                   :  result + 3  :  EndIf   ; Chance auf eine Straße 
          
          If GetGadgetState(57)       ; Mitte 
            result + 3 
          ElseIf GetGadgetState(58)   ; hinten 
            result + 5 
          EndIf 
          
          ForEach cards() 
            If (cards() % 14) < 9           ; 2-9 
              result + (cards() % 14) + 1 
            ElseIf (cards() % 14) < 13      ; 10 / B-D-K 
              result + (cards() % 14) + 2 
            Else                            ; Ass 
              result + 16 
            EndIf 
          Next 
          
          SetGadgetText(63, Str(result)) 

      
        ; Zurücksetzen: 
        ElseIf EventGadget() = 64 
          For i=0 To 55 
            If (i%14) = 0  :  Continue  :  EndIf   ; Images überspringen 
            SetGadgetState(i, #False) 
          Next 
          SetGadgetState(56, #True) 
          DisableGadget(59, #True) 
          For i=60 To 62  :  SetGadgetState(i, #False)  :  Next 
          SetGadgetText(63, "") 
          
          ClearList(cards()) 


        EndIf 
        
    EndSelect 
  ForEver 

EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP