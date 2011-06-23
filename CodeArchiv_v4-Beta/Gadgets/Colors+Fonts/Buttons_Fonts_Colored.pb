; English forum:
; Author: Fweil (updated for PB4.00 by blbltheworm)
; Date: 11. November 2002
; OS: Windows
; Demo: No

; Updated for PB3.70+ 09 June 2003 by Andre Beer
;
; F.Weil - 20021111
;
; This program shows how to interact for selecting colors and fonts and display colored and labeled two states buttons.
; Use the background and foreground colors selection buttons to define the right side two states button colors
; and the two states button itself to select a font by giving its attributes when selecting it or by checking
; appropriate checkboxes.
;
; The final touch was possible to support embeded characters thanks to Danilo's sample code for managing
; fonts with attributes. I did not implement strikeout attribute.
;
; This part of a larger program is free of use for PureBasic community.

;
; Gadgets numbers defined using constants for readability
;
#Gadget_Color1 = 105
#Gadget_Color2 = 106
#Gadget_Bold = 111
#Gadget_Italic = 112
#Gadget_CellHeight = 122
#Gadget_CellWidth = 123
#Gadget_TextColor1 = 131
#Gadget_TextColor2 = 132
#Gadget_2StateButton1 = 133
#Gadget_2StateButton2 = 134

#FONT_NORMAL = %00000000
#FONT_BOLD = %00000001
#FONT_ITALIC = %00000010
#FONT_UNDERLINE = %00000100
#FONT_STRIKEOUT = %00001000
#True=1:#False=0
;
; onMouseOver2StateButton is a signal set to #TRUE when the mouse passes over the 2 states button
;
Global onMouseOver2StateButton.l

Procedure.l IMin(a.l, b.l)
  If a < b
      ProcedureReturn a
    Else
      ProcedureReturn b
  EndIf
EndProcedure

Procedure.l IMax(a.l, b.l)
  If a > b
      ProcedureReturn a
    Else
      ProcedureReturn b
  EndIf
EndProcedure

;
; RGB2DecList returns the R, G, B list corresponding to Color in a string
;
Procedure.s RGB2DecList(Color.l)
  ProcedureReturn Str(Red(Color)) + "," + Str(Green(Color)) + "," + Str(Blue(Color))
EndProcedure

;
; The callback just manages the onMouseOver feature for the 2 states button
;
Procedure MyWindowCallback(WindowID.l, Message.l, wParam.l, lParam.l)
  Result.l = #PB_ProcessPureBasicEvents
  If Message = #WM_SETCURSOR And wParam = GadgetID(#Gadget_2StateButton1)
      HideGadget(#Gadget_2StateButton1, 1)
      HideGadget(#Gadget_2StateButton2, 0)
      onMouseOver2StateButton = #True
  EndIf
  If onMouseOver2StateButton And Message = #WM_NCHITTEST And wParam = 0
      onMouseOver2StateButton = #False
      HideGadget(#Gadget_2StateButton1, 0)
      HideGadget(#Gadget_2StateButton2, 1)
  EndIf
  ProcedureReturn Result
EndProcedure

;
; MyColorRequester is there to return unchanged color when leaving the ColorRequester without
; selecting a new color
;
Procedure.l MyColorRequester(Color.l)
  Result.l = ColorRequester()
  If Result = -1
      ProcedureReturn Color
    Else
      ProcedureReturn Result
  EndIf
EndProcedure

Procedure CreateFont(Name$,Size,Style)
  If (Style & #FONT_BOLD)
      bold = 700
  EndIf
  If (Style & #FONT_ITALIC)
      italic = 1
  EndIf
  If (Style & #FONT_UNDERLINE)
      underline = 1
  EndIf
  If (Style & #FONT_STRIKEOUT)
      strikeout = 1
  EndIf
  ProcedureReturn CreateFont_(Size,0,0,0,bold,italic,underline,strikeout,0,0,0,0,0,Name$)
EndProcedure

Procedure.l MyLabeledImage(ImageNumber.l, Width.l, Height.l, Color.l, TColor.l, Label.s, Font.s, Bold.l, Italic.l, FontSize.l)
  Attributes = #FONT_NORMAL
  If Bold
      Attributes = Attributes | #FONT_BOLD
  EndIf
  If Italic
      Attributes = Attributes | #FONT_ITALIC
  EndIf
  Normal = CreateFont(Font, FontSize, #FONT_NORMAL)
  Bold = CreateFont(Font, FontSize, #FONT_BOLD)
  Italic = CreateFont(Font, FontSize, #FONT_ITALIC)
  Bold_Italic = CreateFont(Font, FontSize, #FONT_BOLD | #FONT_ITALIC)
  Select Attributes
    Case #FONT_NORMAL
      FontToUse = Normal
    Case #FONT_BOLD
      FontToUse = Bold
    Case #FONT_ITALIC
      FontToUse = Italic
    Case #FONT_BOLD | #FONT_ITALIC
      FontToUse = Bold_Italic
    Default
  EndSelect

  ImageID.l = CreateImage(ImageNumber, Width, Height)
  StartDrawing(ImageOutput(ImageNumber))
    Box(0, 0, Width, Height, Color)
    FrontColor(RGB(Red(TColor),Green(TColor),Blue(TColor)))
    DrawingFont(FontToUse)
    DrawingMode(1)
    If TextWidth(Label) < Width
        XPos.l = (Width - TextWidth(Label)) / 2
      Else
        XPos.l = 4
    EndIf
    If TextWidth("M") < Height
        YPos.l = (Height - TextWidth("M")) / 2 - 2
      Else
        YPos.l = 0
    EndIf
    DrawText(XPos, YPos,Label)
  StopDrawing()
  ProcedureReturn ImageID
EndProcedure

;
; Refresh2StateButton changes the two buttons with modified colors and label
;
Procedure Refresh2StateButton(CellWidth.l, CellHeight.l, Color1.l, TextColor1.l, Color2.l, TextColor2.l, CellFont.s, CellFontSize, CellFontBold.l, CellFontItalic.l)
  Bold.s = ""
  Italic.s = ""
  If CellFontBold
      Bold.s = " Bold"
  EndIf
  If CellFontItalic
      Italic.s = " Italic"
  EndIf
  MaxWidth.l = 110
  MaxHeight.l = 35
  FreeGadget(#Gadget_2StateButton1)
  
  If MaxWidth - IMin(CellHeight, MaxHeight) / 2 > 0
    ButtonImageGadget(#Gadget_2StateButton1, 480 - IMin(CellWidth, MaxWidth) / 2, MaxWidth - IMin(CellHeight, MaxHeight) / 2, IMin(CellWidth, MaxWidth), IMin(CellHeight, MaxHeight), MyLabeledImage(5, IMin(CellWidth, MaxWidth), IMin(CellHeight, MaxHeight), Color1, TextColor1, "Text font", CellFont, CellFontBold, CellFontItalic, CellFontSize))
  EndIf
  
  GadgetToolTip(#Gadget_2StateButton1, "Click here to change text font (actually " + CellFont + Bold + Italic + " " + Str(CellFontSize) + ")")
  FreeGadget(#Gadget_2StateButton2)
  ButtonImageGadget(#Gadget_2StateButton2, 480 - IMin(CellWidth, MaxWidth) / 2, MaxWidth - IMin(CellHeight, MaxHeight) / 2, IMin(CellWidth, MaxWidth), IMin(CellHeight, MaxHeight), MyLabeledImage(6, IMin(CellWidth, MaxWidth), IMin(CellHeight, MaxHeight), Color2, TextColor2, "Text font", CellFont, CellFontBold, CellFontItalic, CellFontSize))
  GadgetToolTip(#Gadget_2StateButton2, "Click here to change text font (actually " + CellFont + Bold + Italic + " " + Str(CellFontSize) + ")")
  HideGadget(#Gadget_2StateButton2, 1)
EndProcedure

;
; Main starts here
;

  Quit.l = #False

  WindowXSize.l = 640
  WindowYSize.l = 280
  Color1.l = $804000
  Color2.l = $007D7D
  TextColor1.l = $80FFFF
  TextColor2.l = $FF0000
  CellHeight.l = 30
  Centered.l = #True
  CellWidth.l = 160
  CellFont.s = "Verdana"
  CellFontSize.l = 12
  
  hWnd.l = OpenWindow(0, 200, 200, WindowXSize, WindowYSize, "F.Weil - Font selection and decorated buttons", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_TitleBar)
  If hWnd
      AddKeyboardShortcut(0, #PB_Shortcut_Escape, 99)
      
      LoadFont(0, "Verdana", 8)
      
      If CreateGadgetList(WindowID(0))

          SetGadgetFont(#PB_Default,FontID(0))
          
          CheckBoxGadget(#Gadget_Bold, 430, 160, 50, 20, "Bold")
          GadgetToolTip(#Gadget_Bold, "Check this to use bold labels")
          
          CheckBoxGadget(#Gadget_Italic, 510, 160, 50, 20, "Italic")
          GadgetToolTip(#Gadget_Italic, "Check this to use italic labels")

          Frame3DGadget(#Gadget_CellHeight + 100, 340, 10, 100, 60, "CellHeight", 0)
          StringGadget(#Gadget_CellHeight, 360, 30, 60, 20, Str(CellHeight))
          GadgetToolTip(#Gadget_CellHeight, "Enter subcells minimum height")

          Frame3DGadget(#Gadget_CellWidth + 100, 450, 10, 100, 60, "CellWidth", 0)
          StringGadget(#Gadget_CellWidth, 470, 30, 60, 20, Str(CellWidth))
          GadgetToolTip(#Gadget_CellWidth, "Enter cells width")

          Frame3DGadget(#Gadget_Color1 + 100, 100, 80, 80, 60, "BG1", 0)
          ButtonImageGadget(#Gadget_Color1, 120, 100, 40, 20, MyLabeledImage(1, 40, 20, Color1, 0, "", "", 0, 0, 0))
          GadgetToolTip(#Gadget_Color1, "Click here to change first background color (actually" + RGB2DecList(Color1) + ")")

          Frame3DGadget(#Gadget_Color2 + 100, 180, 80, 80, 60, "BG2", 0)
          ButtonImageGadget(#Gadget_Color2, 200, 100, 40, 20, MyLabeledImage(2, 40, 20, Color2, 0, "", "", 0, 0, 0))
          GadgetToolTip(#Gadget_Color2, "Click here to change second background color (actually" + RGB2DecList(Color2) + ")")

          Frame3DGadget(#Gadget_TextColor1 + 100, 260, 80, 80, 60, "TC1", 0)
          ButtonImageGadget(#Gadget_TextColor1, 280, 100, 40, 20, MyLabeledImage(3, 40, 20, TextColor1, 0, "", "", 0, 0, 0))
          GadgetToolTip(#Gadget_TextColor1, "Click here to change first text color (actually" + RGB2DecList(TextColor1) + ")")

          Frame3DGadget(#Gadget_TextColor2 + 100, 340, 80, 80, 60, "TC2", 0)
          ButtonImageGadget(#Gadget_TextColor2, 360, 100, 40, 20, MyLabeledImage(4, 40, 20, TextColor2, 0, "", "", 0, 0, 0))
          GadgetToolTip(#Gadget_TextColor2, "Click here to change second text color (actually" + RGB2DecList(TextColor2) + ")")
          
          Frame3DGadget(#Gadget_2StateButton1 + 100, 420, 80, 120, 60, "Font", 0)
          ButtonImageGadget(#Gadget_2StateButton1, 430, 95, 100, 30, MyLabeledImage(5, 100, 30, Color1, TextColor1, "Text font", CellFont, CellFontBold, CellFontItalic, CellFontSize))
          GadgetToolTip(#Gadget_2StateButton1, "Click here to change text font (actually " + CellFont + " " + Str(CellFontSize) + ")")

          Frame3DGadget(#Gadget_2StateButton2 + 100, 420, 80, 120, 60, "Font", 0)
          ButtonImageGadget(#Gadget_2StateButton2, 430, 95, 100, 30, MyLabeledImage(6, 100, 30, Color2, TextColor2, "Text font", CellFont, CellFontBold, CellFontItalic, CellFontSize))
          GadgetToolTip(#Gadget_2StateButton2, "Click here to change text font (actually " + CellFont + " " + Str(CellFontSize) + ")")
          
          HideGadget(#Gadget_2StateButton2, 1)

      EndIf
      
      SetWindowCallback(@MyWindowCallback())

      Repeat
        Select WaitWindowEvent()
          Case #PB_Event_CloseWindow
            Quit = #True
          Case #PB_Event_Menu
            Select EventMenu()
              Case 99
                Quit = #True
            EndSelect
          Case #PB_Event_Gadget
            Select EventGadget()
              Case #Gadget_Color1                                              ; First background color
                FreeGadget(#Gadget_Color1)
                Color1 = MyColorRequester(Color1)
                ButtonImageGadget(#Gadget_Color1, 120, 100, 40, 20, MyLabeledImage(1, 40, 20, Color1, 0, "", "", 0, 0, 0))
                GadgetToolTip(#Gadget_Color1, "Click here to change first background color (actually" + RGB2DecList(Color1) + ")")
              Case #Gadget_Color2                                              ; Second background color
                FreeGadget(#Gadget_Color2)
                Color2 = MyColorRequester(Color2)
                ButtonImageGadget(#Gadget_Color2, 200, 100, 40, 20, MyLabeledImage(2, 40, 20, Color2, 0, "", "", 0, 0, 0))
                GadgetToolTip(#Gadget_Color2, "Click here to change second background color (actually" + RGB2DecList(Color2) + ")")
              Case #Gadget_Bold                                                ; Bold CheckBox
                CellFontBold = GetGadgetState(#Gadget_Bold)
              Case #Gadget_Italic                                              ; Italic CheckBox
                CellFontItalic = GetGadgetState(#Gadget_Italic)
              Case #Gadget_CellHeight                                          ; CellHeight StringGadget
                CellHeight = IMax(Val(GetGadgetText(#Gadget_CellHeight)), 1)
              Case #Gadget_CellWidth                                           ; CellWidth StringGadget
                CellWidth = IMax(Val(GetGadgetText(#Gadget_CellWidth)), 1)
              Case #Gadget_TextColor1                                          ; First Text Color
                FreeGadget(#Gadget_TextColor1)
                TextColor1 = MyColorRequester(TextColor1)
                ButtonImageGadget(#Gadget_TextColor1, 280, 100, 40, 20, MyLabeledImage(3, 40, 20, TextColor1, 0, "", "", 0, 0, 0))
                GadgetToolTip(#Gadget_TextColor1, "Click here to change first text color (actually" + RGB2DecList(TextColor1) + ")")
              Case #Gadget_TextColor2                                          ; Second Text Color
                FreeGadget(#Gadget_TextColor2)
                TextColor2 = MyColorRequester(TextColor2)
                ButtonImageGadget(#Gadget_TextColor2, 360, 100, 40, 20, MyLabeledImage(4, 40, 20, TextColor2, 0, "", "", 0, 0, 0))
                GadgetToolTip(#Gadget_TextColor2, "Click here to change first text color (actually" + RGB2DecList(TextColor2) + ")")
              Case #Gadget_2StateButton2                                       ; Font selector
                Result = FontRequester(CellFont, CellFontSize, 0)
                If SelectedFontStyle() & #PB_Font_Bold
                    CellFontBold = #True
                    CellFont = CellFont + " Bold"
                    SetGadgetState(#Gadget_Bold, CellFontBold)
                  Else
                    CellFontBold = #False
                    SetGadgetState(#Gadget_Bold, CellFontBold)
                EndIf
                If SelectedFontStyle() & #PB_Font_Italic
                    CellFontItalic = #True
                    CellFont = CellFont + " Italic"
                    SetGadgetState(#Gadget_Italic, CellFontItalic)
                  Else
                    CellFontItalic = #False
                    SetGadgetState(#Gadget_Italic, CellFontItalic)
                EndIf
                CellFont = SelectedFontName()
                CellFontSize = SelectedFontSize()
            EndSelect
            Refresh2StateButton(CellWidth, CellHeight, Color1, TextColor1, Color2, TextColor2, CellFont, CellFontSize, CellFontBold, CellFontItalic)
        EndSelect
      Until Quit
  EndIf
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; EnableXP