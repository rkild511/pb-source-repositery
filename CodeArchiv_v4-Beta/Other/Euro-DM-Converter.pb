; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1622&highlight=
; Author: roboehler (updated for PB 4.00 by Andre)
; Date: 12. January 2005
; OS: Windows
; Demo: Yes


;eurokalk7cb - Vorlage erstellt mit Purebasic Visual IDE
;und später von Hand verfeinert!
;----------------Constants (WINDOW1)
#berechneDM=1
#dm=2
#euro=3
#text=4
#text0=5
#text2=6
#wertdm=7
#berechneEuro=8
#dm1=9
#euro1=10
#text1=11
#werteuro=12
#W1Image1 = 13
#W1Image2 = 14
#W1Text3 = 15
#W1Text4 = 16
#ende = 17
#W1Btn3 = 18
#Window1 =19
#euro3=20
#help=21
;----------------Constants (WINDOW2)
#Window2 = 1
#W2Btn1 = 2
#W2Text1 = 3
#W2Text2 = 4
#W2Text3 = 5
#W2Text4 = 6
#W2Text5 = 7
#Font = 8

;----------------Flags (WINDOW2)
#Window2Flags = #PB_Event_CloseWindow | #PB_Window_MinimizeGadget

#Window1Flags = #PB_Window_SystemMenu  | #PB_Window_SizeGadget
;FontID.l = LoadFont(#Font, Name$, Höhe [, Flags])
FontID.l = LoadFont(#Font, "Arial", 30 ,1)


new:
LoadFont (1, "Arial", 30)              ; Load Arial Font, Size 30

If OpenWindow(#Window1 ,200,150,320,350,"Euro-Kalkulator",#Window1Flags)
  If CreateGadgetList(WindowID(#Window1))
    
    ImageGadget(#W1Image2,4,7 ,100,62, Picture2)
    StringGadget(#euro,20,60,60,20,"")
    TextGadget  (#text0, 90, 60, 100, 24, "Eingabe Euro")
    ButtonGadget(#berechneDM,200,60,90,20,"Berechne DM")
    
    StringGadget(#dm,20,90,60,20,"1.95583",#PB_String_ReadOnly   )
    TextGadget  (#text, 90, 90, 150, 24, "Umtauschwert Euro in DM")
    
    TextGadget  (#wertdm, 20, 120, 250, 24, "")
    
    StringGadget(#dm1,20,145,60,20,"")
    TextGadget  (#text2, 90, 145, 100, 24, "Eingabe DM")
    ButtonGadget(#berechneEURO,200,145,90,20,"Berechne EURO")
    
    StringGadget(#euro1,20,175,60,20,"0.51129",#PB_String_ReadOnly   )
    TextGadget  (#text1, 90,175, 150, 15, "Umtauschwert DM in EURO")
    
    ;Ergebnis = TextGadget(#Gadget, x, y, Breite, Höhe, Text$ [, Flags])
    StringGadget(#euro3,10,220,295,20,"")

    ButtonGadget(#help,200,253,90,25,"Hilfe")
    ButtonGadget(#W1Btn3,200,280 ,90,25,"about")
    ButtonGadget(#ende,200,307,90,25,"ENDE")
    
    ;TextGadget  (#werteuro, 20, 205, 150, 24, "")
    ImageGadget(#W1Image1,63,250 ,100,62, Picture1)
    TextGadget(#W1Text3, 32, 315 ,161,17,"c) Robert Böhler 2005", #PB_Text_Center)
    TextGadget(#W1Text4, 79, 330 ,100,15," FREEWARE ")
  EndIf
  Repeat
    StartDrawing(WindowOutput(#Window1))
    DrawingMode(0)                          ;TextBackground deckend= 0 Transparent =1
    
    
    DrawingFont(FontID(1))                  ; Use the Arial font
    BackColor(RGB(123, 156, 191))
    FrontColor(RGB(211, 19, 223))
    DrawText(3, 7, " Euro-Umrechner ")      ; Set x,y position and Print our text
    
    StopDrawing()     ; This is absolutely needed when the drawing operations are
    ; finished !!! Never forget it !
    
    EventID = WaitWindowEvent()
    If EventID = #PB_Event_CloseWindow
      Quit = 1
    EndIf
    
    If EventID = #PB_Event_Gadget
      If EventGadget()=#berechneDM
        
        SetGadgetText(#dm1, ""+StrF(ValF(GetGadgetText(#euro))*ValF(GetGadgetText(#dm)))+"" )
        SetGadgetText(#euro3,""+GetGadgetText(#euro)+" E das waren "+StrF(ValF(GetGadgetText(#euro))*ValF(GetGadgetText(#dm)))+" DM" )
        
      EndIf
      If EventGadget()=#berechneEuro
        SetGadgetText(#euro, ""+StrF(ValF(GetGadgetText(#dm1))*ValF(GetGadgetText(#euro1)))+"" )
        SetGadgetText(#euro3, ""+GetGadgetText(#dm1)+" DM das sind "+StrF(ValF(GetGadgetText(#dm1))*ValF(GetGadgetText(#euro1)))+" E" )
        
      EndIf
      If EventGadget()=#ende
        End
      EndIf
      Select EventID;we check which window event are we receiving
        
      Case #PB_Event_Gadget
        
        Select EventGadget();in case its the event from our gadgets
          
        Case #W1Btn3 ;----------Code; the user click the button
          
        EndSelect
        
        Select EventID
          
        Case #PB_Event_Gadget
          
          Select EventGadget()
          Case #W1Btn3 ;----------Code zurück
            MessageRequester("INFO ","made with Purebasic 3.92"+Chr(13)+"von ' Robert Böhler '"+Chr(13)+"         Leibbrandstr.8"+Chr(13)+"D 78713 Schramberg"+Chr(13)+"Tel.:07422/23668"+Chr(13)+"E-Mail: roboehler@gmx.de"+Chr(13)+"            roboehler@web.de"+Chr(13)+Chr(13)+"This is Freeware!",0)
          Case #help ;----------Code zurück
            ;+ Chr(10)oder Chr(13)  ; Chr(10) wird nur für den Zeilenumbruch benötigt
            MessageRequester("Hilfe ","Geben Sie einfach den < DM oder Euro-Betrag > in das weiße"+Chr(10)+"Eingabefeld bei < Eingabe DM > oder < Eingabe Euro > ein."+Chr(10)+"Drücken Sie dann < Berechne DM > oder < Berechne Euro >"+Chr(10)+"und das berechnete Umwandlungsergebnis wird angezeigt."+Chr(10)+"Bei wiederholter Eingabe den Text im Eingabefeld einfach"+Chr(13)+ "blau markieren und überschreiben."+Chr(10)+Chr(10)+"Für Zahlen mit Komma - Punkt statt Kommastrich verwenden!"+Chr(10)+Chr(10)+"            c) Robert Böhler - 2005 -This is Freeware!",0)
            
            
          EndSelect
          
        EndSelect
      EndSelect
    EndIf
  Until Quit=1
EndIf
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger