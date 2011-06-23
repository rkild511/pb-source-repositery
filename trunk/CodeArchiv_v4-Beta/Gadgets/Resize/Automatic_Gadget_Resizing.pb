; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2101&start=10
; Author: NicTheQuick
; Date: 23. August 2003
; OS: Windows
; Demo: Yes

#I2S_Window = 2
#Main_Window = 1
#I2S_GOffset = 100    ;Gadget-Nummern-Offset im I2S_Window

#Border = 5     ;Abstand zwischen zwei Gadgets
#HText = 18     ;Höhe eines TextGadget
#HButton = 20   ;Höhe eines ButtonGadget
#HComboR = 20   ;wirkliche Höhe einer ComboBox


Procedure Einstellungen()
  Protected a.l, b.l, c,l
  Protected Width.l, Height.l, HCombo.l, WOK.l

  Width = 400       ;Fensterbreite
  Height = 400      ;Fensterhöhe
  WEreignis = 200   ;Breite des linken ListIconGadgets
  WOK = 100         ;Breite von OK und Abbrechen
  HCombo = 300      ;Ausklappgröße der ComboBox

  If OpenWindow(#I2S_Window, 0, 0, Width, Height, "Einstellungen", #PB_Window_SystemMenu|#PB_Window_WindowCentered, WindowID(#Main_Window))
    If CreateGadgetList(WindowID(#I2S_Window))
      ;Ereignisse
      TextGadget(#I2S_GOffset + 1, #Border, #Border, WEreignis, #HText, "Ereignisse", #PB_Text_Border | #PB_Text_Center)
      ListIconGadget(#I2S_GOffset + 2, #Border, #Border + #HText, WEreignis, Height - (#HText + #Border * 4 + #HButton * 2), "Name", 150, #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection | #PB_ListIcon_CheckBoxes)
      AddGadgetColumn(#I2S_GOffset + 2, 1, "Gerät", 110)
      AddGadgetColumn(#I2S_GOffset + 2, 2, "Kanal", 40)
      AddGadgetColumn(#I2S_GOffset + 2, 3, "Bank", 50)
      AddGadgetColumn(#I2S_GOffset + 2, 4, "Instrument", 120)
      AddGadgetColumn(#I2S_GOffset + 2, 5, "Note", 40)
      ButtonGadget(#I2S_GOffset + 3, #Border, Height - #Border * 2 - #HButton * 2, WEreignis, #HButton, "Umbenennen")
      ButtonGadget(#I2S_GOffset + 4, #Border, Height - #Border - #HButton, WEreignis, #HButton, "Löschen")

      ;OK, Abbrechen
      a = Width - WEreignis - #Border * 4
      b = (a - #Border) / 2
      ButtonGadget(#I2S_GOffset + 5, Width - (#Border + WOK) * 2, Height - #Border - #HButton, WOK, #HButton, "OK", #PB_Button_Default)
      ButtonGadget(#I2S_GOffset + 6, Width - WOK - #Border, Height - #Border - #HButton, WOK, #HButton, "Abbrechen")

      ;Input-Ereignis
      a = #Border * 2 + WEreignis
      Frame3DGadget(#I2S_GOffset + 7, a, #Border, Width - #Border - a, #Border * 5 + #HText + #HButton + 20, "Input-Ereignis")
      c = 5                                       ;Anzahl an ComboBoxen
      b = (Width - #Border * (4 + c) - WEreignis) / c   ;Breite der ComboBoxen und TextGadgets
      a = a + #Border                             ;x-Pos des erstes TextGadgets
      c = #Border * 4                             ;y-Pos des ersten TextGadgets
      TextGadget(#I2S_GOffset + 8, a, c, b, #HText, "Gerät", #PB_Text_Border | #PB_Text_Center)
      ComboBoxGadget(#I2S_GOffset + 9, a, c + #HText, b, HCombo)

      TextGadget(#I2S_GOffset + 10, a + b + #Border, c, b, #HText, "Kanal (1-16)", #PB_Text_Border | #PB_Text_Center)
      ComboBoxGadget(#I2S_GOffset + 11, a + b + #Border, c + #HText, b, HCombo)

      TextGadget(#I2S_GOffset + 12, a + (b + #Border) * 2, c, b, #HText, "Bank (0-?)", #PB_Text_Border | #PB_Text_Center)
      ComboBoxGadget(#I2S_GOffset + 13, a + (b + #Border) * 2, c + #HText, b, HCombo, #PB_ComboBox_Editable)

      TextGadget(#I2S_GOffset + 14, a + (b + #Border) * 3, c, b, #HText, "Instrument (1-128)", #PB_Text_Border | #PB_Text_Center)
      ComboBoxGadget(#I2S_GOffset + 15, a + (b + #Border) * 3, c + #HText, b, HCombo)

      TextGadget(#I2S_GOffset + 16, a + (b + #Border) * 4, c, b, #HText, "Note", #PB_Text_Border | #PB_Text_Center)
      ComboBoxGadget(#I2S_GOffset + 17, a + (b + #Border) * 4, c + #HText, b, HCombo, #PB_ComboBox_Editable)

      ;Buttons
      c = c + #HText + 20 + #Border
      b = (Width - #Border * 8 - WEreignis) / 4
      ButtonGadget(#I2S_GOffset + 18, a, c, b, #HButton, "Erstellen")
      ButtonGadget(#I2S_GOffset + 19, a + b + #Border, c, b, #HButton, "Erkennen")
      ButtonGadget(#I2S_GOffset + 20, a + (b + #Border) * 2, c, b, #HButton, "Zurücksetzen")
      ButtonGadget(#I2S_GOffset + 21, a + (b + #Border) * 3, c, b, #HButton, "Übernehmen")

      ;Output-Verknüpfungen
      a = #Border * 2 + WEreignis
      b = #Border * 7 + 20 + #HText + #HButton
      Frame3DGadget(#I2S_GOffset + 22, a, b, Width - #Border - a, Height - b - #Border * 2 - #HButton, "Output-Zuweisung")
      a + #Border
      c = 5
      b = (Width - #Border * (4 + c) - WEreignis) / c
      c = #Border * 10 + 20 + #HText + #HButton
      TextGadget(#I2S_GOffset + 24, a, c, b, #HText, "Gerät", #PB_Text_Border | #PB_Text_Center)
      ComboBoxGadget(#I2S_GOffset + 25, a, c + #HText, b, HCombo)
      ButtonGadget(#I2S_GOffset + 34, a, c + #HText + #Border + #HComboR, b, #HButton, "Sound")

      TextGadget(#I2S_GOffset + 26, a + b + #Border, c, b, #HText, "Kanal", #PB_Text_Border | #PB_Text_Center)
      ComboBoxGadget(#I2S_GOffset + 27, a + b + #Border, c + #HText, b, HCombo)
      ButtonGadget(#I2S_GOffset + 35, a + b + #Border, c + #HText + #Border + #HComboR, b, #HButton, "Patch")

      TextGadget(#I2S_GOffset + 28, a + (b + #Border) * 2, c, b, #HText, "Bank", #PB_Text_Border | #PB_Text_Center)
      ComboBoxGadget(#I2S_GOffset + 29, a + (b + #Border) * 2, c + #HText, b, HCombo, #PB_ComboBox_Editable)
      ButtonGadget(#I2S_GOffset + 36, a + (b + #Border) * 2, c + #HText + #Border + #HComboR, b, #HButton, "Patch")

      TextGadget(#I2S_GOffset + 30, a + (b + #Border) * 3, c, b, #HText, "Instrument", #PB_Text_Border | #PB_Text_Center)
      ComboBoxGadget(#I2S_GOffset + 31, a + (b + #Border) * 3, c + #HText, b, HCombo)
      ButtonGadget(#I2S_GOffset + 37, a + (b + #Border) * 3, c + #HText + #Border + #HComboR, b, #HButton, "Patch")

      TextGadget(#I2S_GOffset + 32, a + (b + #Border) * 4, c, b, #HText, "Note", #PB_Text_Border | #PB_Text_Center)
      ComboBoxGadget(#I2S_GOffset + 33, a + (b + #Border) * 4, c + #HText, b, HCombo, #PB_ComboBox_Editable)
      ButtonGadget(#I2S_GOffset + 38, a + (b + #Border) * 4, c + #HText + #Border + #HComboR, b, #HButton, "Patch")

      b = Width - #Border * 5 - WEreignis
      c = c + #HText + #HComboR + #HButton + #Border * 2
      ListIconGadget(#I2S_GOffset + 39, a, c, b, Height - c - #Border * 4 - #HButton * 2, "Gerät", 110, #PB_ListIcon_AlwaysShowSelection | #PB_ListIcon_FullRowSelect)
      AddGadgetColumn(#I2S_GOffset + 39, 1, "Kanal", 40)
      AddGadgetColumn(#I2S_GOffset + 39, 2, "Bank", 50)
      AddGadgetColumn(#I2S_GOffset + 39, 3, "Instrument", 120)
      AddGadgetColumn(#I2S_GOffset + 39, 4, "Note", 40)

      b = (b - #Border) / 2
      c = Height - #Border * 3 - #HButton * 2
      ButtonGadget(#I2S_GOffset + 40, a, c, b, #HButton, "Erstellen")
      ButtonGadget(#I2S_GOffset + 41, a + b + #Border, c, b, #HButton, "Löschen")

    EndIf
  EndIf
EndProcedure


If OpenWindow(#Main_Window, 0, 0, 500, 300, "Hauptfenster", #PB_Window_ScreenCentered)

  Einstellungen()

  Repeat
  Until WaitWindowEvent() = #PB_Event_CloseWindow

EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP