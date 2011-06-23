; www.PureArea.net 
; Author: Falko
; Date: 03. November 2004
; OS: Windows
; Demo: Yes


; Piecework calculator
; Akkord-Rechner


;- Window Constants 
; 
Enumeration 
  #Window_0 
EndEnumeration 

;- Gadget Constants 
; 
Enumeration 
  #Text_0 
  #Text_1 
  #String_0 
  #Text_2 
  #String_1 
  #String_2 
  #Text_4 
  #CheckBox_0 
  #Text_5 
  #Text_6 
  #String_3 
  #Button_1 
  #Button_2 
  #Text_7 
  #Text_8 
  #Text_9 
  #String_4 
  #Text_10 
EndEnumeration 

;- Fonts 
; 
Global FontID1 
FontID1 = LoadFont(1, "Arial", 14) 
Global FontID2 
FontID2 = LoadFont(2, "Arial", 8, #PB_Font_Bold) 
Global VorgabeZeit.f 
Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 360, 19, 351, 262, "Akkordberechnung created by Falko", #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
    If CreateGadgetList(WindowID(#Window_0)) 
      TextGadget(#Text_0, 80, 10, 190, 29, "Akkordrechner", #PB_Text_Center | #PB_Text_Border) 
      SetGadgetFont(#Text_0, FontID1) 
      TextGadget(#Text_1, 30, 60, 68, 20, "Vorgabezeit") 
      SetGadgetFont(#Text_1, FontID2) 
      StringGadget(#String_0, 38, 80, 50, 20, "") 
      TextGadget(#Text_2, 140, 60, 58, 14, "Anz. Teile") 
      SetGadgetFont(#Text_2, FontID2) 
      StringGadget(#String_1, 135, 80, 60, 20, "") 
      StringGadget(#String_2, 230, 80, 32, 20, "75") 
      TextGadget(#Text_4, 230, 59, 82, 14, "Akkord-Faktor") 
      SetGadgetFont(#Text_4, FontID2) 
      CheckBoxGadget(#CheckBox_0, 91, 111, 14, 15, "") 
      TextGadget(#Text_5, 40, 111, 41, 13, "Rüsten") 
      SetGadgetFont(#Text_5, FontID2) 
      TextGadget(#Text_6, 32, 150, 227, 14, "Ausgabe in std. bei 75 min. Verrechnung:") 
      SetGadgetFont(#Text_6, FontID2) 
      StringGadget(#String_3, 264, 147, 46, 20, "") 
      ButtonGadget(#Button_1, 40, 180, 120, 50, "Berechnen") 
      SetGadgetFont(#Button_1, FontID1) 
      ButtonGadget(#Button_2, 200, 180, 110, 50, "Beenden") 
      SetGadgetFont(#Button_2, FontID1) 
      TextGadget(#Text_7, 93, 88, 20, 13, "min.") 
      TextGadget(#Text_8, 270, 87, 19, 13, "min.") 
      TextGadget(#Text_9, 166, 111, 47, 15, "Rüstzeit") 
      SetGadgetFont(#Text_9, FontID2) 
      StringGadget(#String_4, 220, 104, 42, 20, "") 
      TextGadget(#Text_10, 270, 110, 19, 14, "min.") 
      
    EndIf 
  EndIf 
EndProcedure 

Procedure.s rechne(Vorgabe.f, Anz_Teile, Faktor, Ruestzeit,Checked) 
   If Checked=0 
      Ergebnis.f=(Vorgabe*Anz_Teile)/Faktor 
      Debug Ergebnis 
   Else 
      Ergebnis.f=((Vorgabe*Anz_Teile)+Ruestzeit)/Faktor 
   EndIf 
   ProcedureReturn StrF(Ergebnis,2) 
EndProcedure 

;------- Mainfile 
Open_Window_0() 

Repeat 
  
  Event = WaitWindowEvent() 
  
  If Event = #PB_Event_Gadget 
    
    ;Debug "WindowID: " + Str(EventWindowID()) 
    
    GadgetID = EventGadget() 
    
    If GadgetID = #String_0 
      ;Debug "GadgetID: #String_0" 
      VorgabeZeit = ValF(GetGadgetText(#String_0)) 
    ElseIf GadgetID = #String_1 
      ;Debug "GadgetID: #String_1" 
      Anz_Teile = Val(GetGadgetText(#String_1)) 
    ElseIf GadgetID = #String_2 
      ;Debug "GadgetID: #String_2" 
      Faktor = Val(GetGadgetText(#String_2)) 
    ElseIf GadgetID = #CheckBox_0 
      ;Debug "GadgetID: #CheckBox_0" 
      If GetGadgetState(#Checkbox_0)=1 
         Checked=1 
      Else 
         checked=0 
      EndIf 
    ElseIf GadgetID = #String_3 ; Da dieses nur für die Ausgabe ist bleibt es hier offen 
      ;Debug "GadgetID: #String_3" 
      
    ElseIf GadgetID = #Button_1 
      ;Debug "GadgetID: #Button_1" 
     SetGadgetText(#String_3,rechne(VorgabeZeit, Anz_Teile, Faktor, Ruestzeit,Checked)) 
    ElseIf GadgetID = #Button_2 
      ;Debug "GadgetID: #Button_2" 
      End ; Beenden 
    ElseIf GadgetID = #String_4 
      ;Debug "GadgetID: #String_4" 
      Ruestzeit = Val(GetGadgetText(#String_4)) 
    EndIf 
    
  EndIf 
  
Until Event = #PB_Event_CloseWindow 

End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP