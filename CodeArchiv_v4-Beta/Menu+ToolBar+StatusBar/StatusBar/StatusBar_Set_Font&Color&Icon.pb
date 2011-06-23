; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13502
; Author: Nico (updated for PB 4.00 by Andre)
; Date: 27. December 2004
; OS: Windows
; Demo: No


;************** Path to icon must be adapted !!!!


; By Nico
; Pure Basic, Version:3.92
; le 26/12/04

;/ Structure allowing the posting of the text in the Status bar
;/ containing the different information which we are going to administer.

Structure Status_Draw
  Texte.s
  couleur.l
  Font.l
  Emplacement.l
EndStructure

Enumeration
  #Window_0
EndEnumeration

Enumeration
  #button
  #StatusBar
EndEnumeration

Global Hstatus

;/ Constants used to show the text
#DT_SINGLELINE  ; The text will be shown in a single line
#DT_TOP         ; The text will be aligned upward,
; The constant #DT_SINGLELINE Must be specified to use it
#DT_BOTTOM      ; The text will be aligned downward
; The constant #DT_SINGLELINE Must be specified to use it
#DT_VCENTER     ; The text will be centred vertically
; The constant #DT_SINGLELINE Must be specified to use it
#DT_CENTER      ; The text will be centred Horizontally
#DT_RIGHT       ; The text will be aligned to the Right
#DT_LEFT        ; The text will be aligned to the Left

;/ Constants used to show the icon
#SB_SETICON=(#WM_USER) +15

Procedure WindowCallback(WindowID, Message, wParam, lParam)
  result = #PB_ProcessPureBasicEvents
  Select Message
    Case #WM_DRAWITEM
      If wParam = GetDlgCtrlID_(Hstatus)
        *DrawItem.DRAWITEMSTRUCT = lParam
        *pointeur.Status_Draw=*DrawItem\itemData
        hFontOld = SelectObject_(*DrawItem\hDC,*pointeur\Font)
        SetBkMode_(*DrawItem\hDC, #TRANSPARENT)
        SetTextColor_(*DrawItem\hDC, *pointeur\couleur )
        DrawText_(*DrawItem\hDC, *pointeur\Texte, -1, *DrawItem\rcItem , *pointeur\Emplacement)
        ProcedureReturn #True
      EndIf
  EndSelect
  ProcedureReturn result
EndProcedure

If OpenWindow(0, 100, 150, 300, 100, "De la couleur dans la Status Bar", #PB_Window_SystemMenu | #PB_Window_SizeGadget)
  SetWindowCallback(@WindowCallback())

  If CreateGadgetList(WindowID(0))
    ButtonGadget(#button,10,10,280,20,"Changer le nom et la couleur du champ N°0 par Louis")
  EndIf

  Hstatus= CreateStatusBar(#StatusBar, WindowID(0))
  ;/ To adjust the height of Status Bar
  SendMessage_(Hstatus, #SB_SETMINHEIGHT, 40, 0)

  ;/ Necessities for the immediate rafraichissement of the new size
  SendMessage_(Hstatus, #WM_SIZE, 0,0)

  ;/ Creation of three Fields, 0 , 1, and 2
  If Hstatus
    AddStatusBarField(100)
    AddStatusBarField(50)
    AddStatusBarField(100)
  EndIf

  ;/ One fills structure for the field N°0 of Status Bar
  Champ_0.Status_Draw
  Champ_0\Texte="Pierre"
  Champ_0\couleur=RGB(255,0,0)
  Champ_0\Font=hFont=LoadFont (0, "Courier", 20)
  Champ_0\Emplacement=#DT_CENTER| #DT_VCENTER| #DT_SINGLELINE

  ;/ One fills structure for the field N°1 of Status Bar
  Champ_1.Status_Draw
  Champ_1\Texte="Paul"
  Champ_1\couleur=RGB(0,168,168)
  Champ_1\Font=hFont=LoadFont (1, "Courier", 8)
  Champ_1\Emplacement=#DT_LEFT| #DT_BOTTOM| #DT_SINGLELINE

  ;/ One fills structure for the field N°2 of Status Bar
  Champ_2.Status_Draw
  Champ_2\Texte="Nico"
  Champ_2\couleur=RGB(0,0,255)
  Champ_2\Font=hFont=LoadFont (2, "Arial", 16)
  Champ_2\Emplacement=#DT_TOP|#DT_RIGHT| #DT_SINGLELINE

  ;/ Pointer towards the Structure to be shown
  *pointeur_champ0.Status_Draw=@Champ_0
  *pointeur_champ1.Status_Draw=@Champ_1
  *pointeur_champ2.Status_Draw=@Champ_2

  ;/ One sends the different pointer to Status Bar
  SendMessage_(Hstatus, #SB_SETTEXT, 0 | #SBT_OWNERDRAW ,*pointeur_champ0)
  SendMessage_(Hstatus, #SB_SETTEXT, 1 | #SBT_OWNERDRAW ,*pointeur_champ1)
  SendMessage_(Hstatus, #SB_SETTEXT, 2 | #SBT_OWNERDRAW ,*pointeur_champ2)

  ;/ Add an icon in the field N°2
  Hicon=LoadImage(0, "..\..\Graphics\Gfx\rojo.ico")
  SendMessage_( Hstatus, #SB_SETICON, 2, Hicon)

  Repeat
    Event = WaitWindowEvent()
    Select Event
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #button
            ;/ Change of the Field N°0
            Champ_0.Status_Draw
            Champ_0\Texte="Louis"
            Champ_0\couleur=RGB(255,255,0)
            SendMessage_(Hstatus, #SB_SETTEXT, 0 | #SBT_OWNERDRAW ,*pointeur_champ0)
        EndSelect

      Case #WM_CLOSE
        FreeFont(0)
        FreeFont(1)
        FreeFont(2)
        Quit+1
    EndSelect
  Until Quit=1
EndIf
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP