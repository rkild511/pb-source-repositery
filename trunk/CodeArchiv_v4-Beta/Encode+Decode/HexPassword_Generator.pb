; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=4796&postdays=0&postorder=asc&start=20
; Author: Froggerprogger (based on an idea by The_Pharao, updated for PB 4.00 by Andre)
; Date: 16. June 2004
; OS: Windows
; Demo: Yes


; Generierte Passwörter bleiben immer gleich lang.
; Verwendbare Sonderzeichen können im Zeichenpool-String nach eigenen Wünschen geändert werden.

Enumeration
  #Window
  #Text_0
  #String_PW
  #String_Hex
  #Text_1
  #Button_Copy
  #Button_Ende
EndEnumeration


Zeichenpool.s = "0,.-!;:1_/2?q3aywsxed4cr5fvtgbz6hnu78jmikolp9,.-!;:_0/?QA1YW2SX3EDCRFVT45GBZHNUJ6MIKO7LP,8.-!;:_9/?"
lenZ = Len(Zeichenpool)

If OpenWindow(#Window, 395, 299, 279, 174, "Hex-Passwort Generator", #PB_Window_SizeGadget | #PB_Window_TitleBar)
  If CreateGadgetList(WindowID(#Window))
    TextGadget(#Text_0, 10, 10, 110, 20, "Passwort eingeben:")
    StringGadget(#String_PW, 10, 30, 260, 20, "", #PB_String_Password)
    StringGadget(#String_Hex, 10, 90, 260, 20, "", #PB_String_ReadOnly)
    TextGadget(#Text_1, 10, 70, 260, 20, "Hex-Zeichenfolge:")
    ButtonGadget(#Button_Copy, 10, 130, 110, 40, "Zwischenablage")
    ButtonGadget(#Button_Ende, 160, 130, 110, 40, "Ende")

    Repeat

      event = WaitWindowEvent()

      Select event
        Case #PB_Event_Gadget
          Select EventGadget()
            Case #Button_Ende : SetClipboardText("") : End
            Case #Button_Copy : SetClipboardText(GetGadgetText(#String_Hex))
            Case #String_PW
              SetGadgetText(#String_Hex, "")

              passwort.s = GetGadgetText(#String_PW)
              hexstring.s = ""
              lenP = Len(passwort)
              For n = 1 To lenP
                asc=Asc(Mid(passwort, n, 1))
                hexstring = hexstring + Mid(Zeichenpool, (lenP * asc) % lenZ + 1, 1)
              Next

              SetGadgetText(#String_Hex, hexstring)
              hexstring ="": passwort = ""
          EndSelect
      EndSelect

    Until event = #PB_Event_CloseWindow

  EndIf
EndIf

End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger