; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5095&postdays=0&postorder=asc&start=20
; Author: Getaway (corrected by glubschi90, updated for PB 4.00 by Andre)
; Date: 23. July 2004
; OS: Windows
; Demo: No

;######################################
;#     IK-Helper & Alli Manager       #
;#                                    #
;#                                    #
;######################################

;- Window Constants
;
Enumeration
  #Window_0
EndEnumeration

url$ = "http://www.aodhq.s1.cybton.com/ik/corenews2/shownews.php?password="

;- MenuBar Constants
;
Enumeration
  #MenuBar_0
EndEnumeration

Enumeration
  #MENU_7
  #MENU_6
  #MENU_5
EndEnumeration

;- Gadget Constants
;
Enumeration
  #Panel_0
  #Frame3D_0
  #Frame3D_1
  #String_0
  #Text_0
  #Frame3D_2
  #Frame3D_3
  #Text_1
  #String_2
  #Text_3
  #Frame3D_10
  #Text_5
  #String_3
  #Button_0
  #Frame3D_11
  #Button_1
  #Button_2
  #Button_3
  #Text_8
  #Frame3D_12
  #Frame3D_13
  #Web_3

EndEnumeration

;--- herausfinden des eigenen verzeichnisses "ExePath()"


Procedure.s ExePath()
  ExePath$ = Space(1024)
  GetModuleFileName_(0,@ExePath$,1024)
  ProcedureReturn GetPathPart(ExePath$)
EndProcedure

;-- Die Fensterdeklarierung

Procedure Open_Window_0()
  If OpenWindow(#Window_0, 233, 162, 800, 600, "[KaG] IK-Helper",  #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_SizeGadget | #PB_Window_TitleBar )
    If CreateMenu(#MenuBar_0, WindowID(#Window_0))
      MenuTitle("Datei")
      MenuItem(#MENU_7, "Beenden")
      MenuTitle("Tool")
      MenuTitle("Hilfe")
      MenuItem(#MENU_6, "Hilfe...")
      MenuItem(#MENU_5, "Über...")
    EndIf

    If CreateGadgetList(WindowID(#Window_0))

      ;- Panel0
      PanelGadget(#Panel_0, 10, 20, 780, 550)
      AddGadgetItem(#Panel_0, -1, "News - Übersicht")
      Frame3DGadget(#Frame3D_0, 8, -2, 760, 520, "")
      Frame3DGadget(#Frame3D_1, 578, -2, 190, 170, "")
      StringGadget(#String_0, 588, 28, 170, 120, "", #PB_String_ReadOnly)
      TextGadget(#Text_0, 598, 8, 150, 20, "Aktuelle NAP´s und Bündnisse")
      Frame3DGadget(#Frame3D_2, 8, -2, 570, 520, "")
      Frame3DGadget(#Frame3D_3, 578, 158, 190, 170, "")
      TextGadget(#Text_1, 18, 8, 550, 15, "News - Ankündigungen - Kriege - Übersicht - etc...", #PB_Text_Center)
      StringGadget(#String_2, 598, 188, 150, 20, "", #PB_String_ReadOnly)
      TextGadget(#Text_3, 588, 168, 170, 20, "Letzte Aktualisierung erfolgte :", #PB_Text_Center)
      Frame3DGadget(#Frame3D_10, 588, 218, 170, 10, "")
      TextGadget(#Text_5, 618, 238, 110, 20, "Aktuelles PW:", #PB_Text_Center)
      StringGadget(#String_3, 618, 258, 110, 20, "", #PB_String_Password)
      GadgetToolTip(#String_3, "Hier muss das Aktuelle Passwort eingegeben werden, damit die News etc... aktualisiert werden können.")
      ButtonGadget(#Button_0, 618, 288, 110, 20, "Aktualisieren")
      Frame3DGadget(#Frame3D_11, 578, 318, 190, 200, "")
      ButtonGadget(#Button_1, 618, 378, 110, 20, "Forum")
      ButtonGadget(#Button_2, 618, 398, 110, 20, "Kolotool")
      ButtonGadget(#Button_3, 618, 358, 110, 20, "Inselkampf")
      TextGadget(#Text_8, 598, 338, 150, 20, "Quick links", #PB_Text_Center)
      Frame3DGadget(#Frame3D_12, 578, 318, 190, 120, "")
      Frame3DGadget(#Frame3D_13, 18, 28, 550, 480, "")
      WebGadget(#Web_3, 23, 38, 540, 465,"http://www.purebasic.com") ;Hier das Anzeigen der URL in dem webgadget
      CloseGadgetList()

    EndIf
  EndIf
EndProcedure

;--- Ab hier beginnen die Funnktionen etc...
;
;


Open_Window_0()

Repeat

  EventID = WaitWindowEvent()

  ; Event menu einstellungen

  Select eventid

    Case #PB_Event_Menu

      Select EventMenu()

        Case #Menu_7
          quit = 1

        Case #Menu_6
          MessageRequester("Hilfe", "Die Hilfe ist noch nicht verfügbar", 0)

        Case #Menu_5
          MessageRequester("Über...", "IK-Helper (0.1) is written by Getaway for [KaG] new features will be added soon !", 0)

      EndSelect

    Case #PB_Event_Gadget
      Select EventGadget()

        ;-- Öffnen der News
        Case #Button_0
          If EventType() = #PB_EventType_LeftClick
            pw$ = GetGadgetText(#String_3)
            SetGadgetText(#web_3,url$+pw$)

          EndIf

          ;-- Die Links
          ;
          ;Inselkampf

        Case #Button_3
          If EventType() = #PB_EventType_LeftClick
            RunProgram("http://www.inselkampf.de")
          EndIf

          ;Forum

        Case #Button_1
          If EventType() = #PB_EventType_LeftClick
            RunProgram("http://ik-forum.master-of-disaster.li/portal.php")
          EndIf

          ;kolotool

        Case #Button_2
          If EventType() = #PB_EventType_LeftClick
            RunProgram("http://www.neo-solutions.goracer.de/kag/tool/index.php")
          EndIf




      EndSelect


    Case #WM_CLOSE
      Quit = 1

  EndSelect

Until quit = 1


;--Ende Links

End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP