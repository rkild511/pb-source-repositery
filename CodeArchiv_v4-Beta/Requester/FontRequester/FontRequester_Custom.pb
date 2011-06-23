; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2976&highlight=
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 30. November 2003
; OS: Windows
; Demo: No

;Konstanten für Font-Dialog-Gadgethandles
;###########################################
#Control_Effects = 1072
#Control_Effects_Color_Strikeout = 1040
#Control_Effects_Color_Underline = 1041
#Control_Effects_Color_Static = 1091
#Control_Effects_Color_Dropdown =  1139
#Control_Script_Static = 1094
#Control_Script_Dropdown = 1140
#Control_Sample = 1073
#Control_S_Static = 1092
#Control_Fontname_Static = 1088
#Control_Fontname_Combo = 1136
#Control_Fontstyle_Static = 1089
#Control_Fontstyle_Combo = 1137
#Control_Fontweight_Static = 1090
#Control_Fontweight_Combo = 1138
#Control_Button_Ok = 1
#Control_Button_Cancel = 2
#Control_Button_Apply = 1026
#Control_Button_Help = 1038
;###########################################

#TextGadget = 0
#ButtonGadget = 1
#Font = 2

Global   lf.LOGFONT
Global   cf.CHOOSEFONT
Global   OldFont.l

Procedure CFHookProc(hdlg,uiMsg,wParam,lParam)
  ;hier wird der Font-Dialog manipuliert
  Result = 0
  Select uiMsg
  Case #WM_INITDIALOG
    CreateGadgetList(hdlg)
    ImageGadget(10, 370,140,32,32,LoadIcon_(0,#IDI_WINLOGO));ein eigenes Icon einfügen
    ;hier werden einige der Gadgets deaktiviert
    EnableWindow_(GetDlgItem_(hdlg,#Control_Effects_Color_Static),0)
    EnableWindow_(GetDlgItem_(hdlg,#Control_Effects_Color_Dropdown),0)
    EnableWindow_(GetDlgItem_(hdlg,#Control_Fontweight_Static),0)
    EnableWindow_(GetDlgItem_(hdlg,#Control_Fontweight_Combo),0)
    EnableWindow_(GetDlgItem_(hdlg,#Control_Script_Static),0)
    EnableWindow_(GetDlgItem_(hdlg,#Control_Script_Dropdown),0)
    SetWindowText_(hdlg,"My Own Font-Dialog")
    Result = #True
  Case #WM_COMMAND
    Select wParam & $FFFF;LoWord(wParam)
    Case #Control_Button_Help
      ;Hilfe-Button wurde gedrückt
      MessageRequester("Info","Hier gibt es keine Hilfe",#MB_ICONINFORMATION|#MB_SYSTEMMODAL)
      Result = #True
    Case #Control_Button_Apply
      ;Übernehmen-Button wurde gedrückt
      SendMessage_(hdlg,#WM_CHOOSEFONT_GETLOGFONT,0,lf1.LOGFONT)
      If lf1\lfUnderline > 0 : style|#PB_Font_Underline :EndIf
      If lf1\lfStrikeOut > 0 : style|#PB_Font_StrikeOut:EndIf
      If lf1\lfItalic = -1  : style|#PB_Font_Italic:EndIf
      If lf1\lfWeight > 400  : style|#PB_Font_Bold:EndIf
      LoadFont(#Font,PeekS(lf1+28), lf1\lfHeight,style)
      SendMessage_(GadgetID(Textgadget),#WM_SETFONT,FontID(#Font),1)
      Result = #True
    Case #Control_Button_Ok ;Übernehmen-Button wurde gedrückt
      SendMessage_(hdlg,#WM_CHOOSEFONT_GETLOGFONT,0,lf1.LOGFONT)
      If lf1\lfUnderline > 0 : style|#PB_Font_Underline :EndIf
      If lf1\lfStrikeOut > 0 : style|#PB_Font_StrikeOut:EndIf
      If lf1\lfItalic = -1  : style|#PB_Font_Italic:EndIf
      If lf1\lfWeight > 400  : style|#PB_Font_Bold:EndIf
      LoadFont(#Font,PeekS(lf1+28), lf1\lfHeight,style)
      SendMessage_(GadgetID(Textgadget),#WM_SETFONT,FontID(#Font),1)
      PostMessage_(hdlg,#WM_COMMAND,#IDABORT,0)
      Result = #True
    Case #Control_Button_Cancel ;Abbrechen-Button wurde gedrückt
      SendMessage_(GadgetID(Textgadget),#WM_SETFONT,OldFont,1)
      PostMessage_(hdlg,#WM_COMMAND,#IDABORT,0)
      Result = #True
    EndSelect
  EndSelect
  ProcedureReturn Result
EndProcedure

Procedure PBChooseFont()
  ;Strukturen mit ein paar Voreinstellugnen füllen
  lf\lfHeight = 1000/75 ;Fonthoehe = 10 ist voreingestellt
  PokeS(lf+28,"Arial") ;Arial ist voreingestellt
  
  cf\lStructSize = SizeOf(CHOOSEFONT)
  cf\hwndOwner = GetDesktopWindow_()
  cf\lpLogFont = @lf
  cf\flags = #CF_BOTH|#CF_INITTOLOGFONTSTRUCT|#CF_LIMITSIZE|#CF_ENABLEHOOK|#CF_EFFECTS|#CF_SHOWHELP|#CF_APPLY
  cf\rgbColors = RGB(0,0,0);Farbe vorgeben
  cf\nSizeMin = 8;minimale Fonthoehe
  cf\nSizeMax = 36;maximale Fonthoehe
  cf\lpfnHook = @CFHookProc();Hook-Procedur setzen
  ;Dialog aufrufen
  ChooseFont_(cf)
  
EndProcedure

If OpenWindow(0,0,0,270,220,"Choosefont-Sample",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
  TextGadget(#TextGadget, 10, 10,250,60,"TextGadget")
  OldFont = SendMessage_(GadgetID(#TextGadget),#WM_GETFONT,0,0);Font merken
  ButtonGadget(#ButtonGadget, 10, 180,80,20,"ChooseFont")
  Repeat
    EventID.l = WaitWindowEvent()
    If EventID = #PB_Event_Gadget
      Select EventGadget()
      Case 1
        PBChooseFont()
      EndSelect
    EndIf
  Until EventID = #PB_Event_CloseWindow
  FreeFont(#Font)
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
