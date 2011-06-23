; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13427&highlight=
; Author: Sparkie (updated for PB 4.00 by Andre)
; Date: 19. December 2004
; OS: Windows
; Demo: No

#CFM_BACKCOLOR = $4000000 
#SCF_ALL = 4 
; --> Structure for formatting EditorGadget 
Structure myCHARFORMAT2 
  cbSize.l 
  dwMask.l 
  dwEffects.l 
  yHeight.l 
  yOffset.l 
  crTextColor.l 
  bCharSet.b 
  bPitchAndFamily.b 
  szFaceName.b[#LF_FACESIZE] 
  nullPad.w 
  wWeight.w 
  sSpacing.w 
  crBackColor.l 
  LCID.l 
  dwReserved.l 
  sStyle.w 
  wKerning.w 
  bUnderlineType.b 
  bAnimation.b 
  bRevAuthor.b 
  bReserved1.b 
EndStructure 
; --> Find text from start to end of text 
Global editFind.FINDTEXT 
editFind\chrg\cpMin = 0  ; this will change in procedure as text is found 
editFind\chrg\cpMax = -1 
; --> Our found text background 
Global editFormat.myCHARFORMAT2 
editFormat\cbSize = SizeOf(myCHARFORMAT2) 
editFormat\dwMask = #CFM_BACKCOLOR 
editFormat\crBackColor = RGB(128, 200, 200) 
; --> Our default EditorGdaget background color 
Global defaultFormat.myCHARFORMAT2 
defaultFormat\cbSize = SizeOf(myCHARFORMAT2) 
defaultFormat\dwMask = #CFM_BACKCOLOR 
defaultFormat\crBackColor = RGB(255, 255, 223) 


Procedure findtext(textToFind$) 
  ; --> Reset search to beginnng 
  SendMessage_(GadgetID(0), #EM_SETSEL, 0, 0) 
  ; --> For resetting to default text 
  SendMessage_(GadgetID(0), #EM_SETCHARFORMAT, #SCF_ALL, defaultFormat) 
  ; --> Split the seaarch words 
  spaces = CountString(textToFind$, " ")  
  For i = 1 To spaces+1 
    editFind\chrg\cpMin = 0 
    thisFind$ = StringField(textToFind$, i, " ") 
    editFind\lpstrText = @thisFind$ 
    Repeat 
      found = SendMessage_(GadgetID(0), #EM_FINDTEXT, #FR_DOWN, editFind) 
      If found > -1 
        editFind\chrg\cpMin = found+1 
        ; --> Set the selection to colorize 
        SendMessage_(GadgetID(0), #EM_SETSEL, found, found + Len(thisFind$))  
        ; --> Colorize selection background 
        SendMessage_(GadgetID(0), #EM_SETCHARFORMAT, #SCF_SELECTION | #SCF_WORD, editFormat) 
      EndIf 
    Until found = -1 
  Next i 
  SendMessage_(GadgetID(0), #EM_SETSEL, 0, 0) 
EndProcedure 

If OpenWindow(0, 0, 0, 300, 150, "EditorGadget Find Text", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
  EditorGadget (0, 0, 40, 300, 120) 
  StringGadget(1, 10, 10, 150, 20, "of three") 
  ButtonGadget(2, 170, 10, 50, 20, "Find") 
  AddGadgetItem(0, -1, "Line one of three") 
  AddGadgetItem(0, -1, "This is the next line of three.") 
  AddGadgetItem(0, -1, "End line is here") 
  CreatePopupMenu(0) 
  MenuItem(1, "Copy") 
  MenuBar() 
  MenuItem(2, "Select All") 
  SetActiveGadget(0) 
  SendMessage_(GadgetID(0), #EM_SETREADONLY, 1, 0) 
  SendMessage_(GadgetID(0), #EM_SETBKGNDCOLOR, 0, RGB(255, 255, 223)) 
  Repeat 
    event = WaitWindowEvent() 
    Select event 
      Case #PB_Event_Gadget 
        Select EventGadget() 
          Case 2 
            SetActiveGadget(0) 
            findtext(GetGadgetText(1)) 
            SetActiveGadget(1) 
        EndSelect 
      Case #WM_RBUTTONDOWN 
        If EventGadget() = 0 
          selStart = 0 
          selEnd = 0 
          SendMessage_(GadgetID(0), #EM_GETSEL, @selStart, @selEnd) 
          If selStart = selEnd 
            DisableMenuItem(0, 1,1) 
          Else 
            DisableMenuItem(0, 1,0) 
          EndIf 
          GetCursorPos_(mouseP.POINT) 
          DisplayPopupMenu(0,WindowID(0),mouseP\x, mouseP\y) 
        EndIf 
      Case #PB_Event_Menu 
        Select EventMenu()     ; get the clicked menu item... 
          Case 1 
            SendMessage_(GadgetID(0), #WM_COPY, 0, 0) 
            SendMessage_(GadgetID(0), #EM_SETSEL, -1, 0) 
          Case 2 
            editSel.CHARRANGE\cpMin = 0 
            editSel.CHARRANGE\cpMax = -1 
            SendMessage_(GadgetID(0), #EM_EXSETSEL, 0, @editSel) 
        EndSelect 
    EndSelect 
  Until event = #PB_Event_CloseWindow 
EndIf 
End
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP