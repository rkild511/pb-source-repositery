; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2769
; Author: Ypser (updated for PB4.00 by blbltheworm)
; Date: 08. November 2003
; OS: Windows
; Demo: No


;        GeTtHeCoLoR v1.0 
;        (ColorPicker) 
Enumeration 
  #Gadget_0 
  #Gadget_1 
  #Gadget_2 
  #Gadget_3 
  #RGB_Anzeige 
  #Hex_Anzeige 
  #Dez_Anzeige 
  #RGB_Check 
  #Hex_Check 
  #Dez_Check 
  #Show1 
  #Show2 
  #Info 
EndEnumeration 

#Event_Merken = 20 

Global Dim hw.s (5) 
Global Dim ActPixelColor (10, 8) 

InitKeyboard() 

If OpenWindow (0, 0, 0, 155, 110, "GtC v1.0",  #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered ) 
  SetWindowPos_(WindowID(0), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE | #SWP_NOSIZE) 

  If CreateGadgetList(WindowID(0)) 
    TextGadget (#Gadget_0, 5, 8, 25, 15, "RGB:") 
    TextGadget (#Gadget_1, 5, 30, 25, 15, "Hex:") 
    TextGadget (#Gadget_2, 5, 53, 25, 15, "Dez:") 
    TextGadget (#Gadget_3, 5, 85, 32, 15, "Farbe:") 

    StringGadget (#RGB_Anzeige, 40, 5, 80, 18, "0, 0, 0", 0) 
    StringGadget (#Hex_Anzeige, 75, 28, 45, 18, "000000", 0) 
    StringGadget (#Dez_Anzeige, 40, 51, 80, 18, "0", 0) 
    OptionGadget (#RGB_Check, 135, 7, 20, 18, "") 
    OptionGadget (#Hex_Check, 135, 29, 20, 18, "") 
    OptionGadget (#Dez_Check, 135, 51, 20, 18, "") 
    ImageGadget (#Show1, 40, 75, 35, 29, 0, #PB_Image_Border) 
    ImageGadget (#Show2, 85, 75, 35, 29, 0, #PB_Image_Border) 
    ButtonGadget (#Info, 125, 85, 25, 15, "Info") 
    SetGadgetState (#Hex_Check, 1) 
  EndIf 
EndIf 

hdc = GetDC_(0) 
AddKeyboardShortcut (0, #PB_Shortcut_Space, #Event_Merken) 

ZU.s = Chr(13) + Chr(10) 
InfoText.s = "GeTtHeCoLoR v1.0" + ZU + "_______________________________________" + ZU + ZU 

InfoText + "Bedienung: Einfach den MouseCursor bewegen." + ZU 
InfoText + "Im linken Bild erscheint ein Auschnitt von dem," + ZU 
InfoText + "was unterm Cursor ist, im rechten die Farbe" + ZU 
InfoText + "GENAU unter dem Cursor." + ZU + ZU 
InfoText + "Oben steht der Farbwert in RGB, Hexadezimal" + ZU + "und Dezimal." + ZU 
InfoText + "Wenn man [Space] drückt, wird der Wert, hinter" + ZU 
InfoText + "dem das Häkchen gesetzt ist, in die Zwischen-" + ZU 
InfoText + "ablage gespeichert." + ZU + ZU 
InfoText + "(c) Ypser (F.H.), Nov. '03" 


While WindowEvent(): Wend 
CreateImage (0, 33, 27) 
CreateImage (1, 33, 27) 

ActHex.s = "" 

Repeat 
  ActMouseX = (WindowMouseX(0)) 
  ActMouseY = (WindowMouseY(0)) 
  

  Select WindowEvent() 
    
    Case #PB_Event_CloseWindow 
      
      Quit = 1 
    
    Case #PB_Event_Gadget 
      
      Select EventGadget() 
        Case #Info 
          MessageRequester("GeTtHeCoLoR Info", InfoText, 0) 
      EndSelect 
    
    Case #PB_Event_Menu 
      
      If EventMenu() = #Event_Merken 
        
        If GetGadgetState(#RGB_Check) = 1 
          SetClipboardText (GetGadgetText (#RGB_Anzeige)) 
        EndIf 
        
        If GetGadgetState(#Hex_Check) = 1 
          SetClipboardText (GetGadgetText (#Hex_Anzeige)) 
        EndIf 
        
        If GetGadgetState(#Dez_Check) = 1 
          SetClipboardText (GetGadgetText (#Dez_Anzeige)) 
        EndIf 
      
      EndIf 
  
  EndSelect 


  
  Delay(1) 
  
If (OldMouseX <> ActMouseX) Or (OldMouseY <> ActMouseY) 
  For Y = 0 To 8 
    For X = 0 To 10 
      ActPixelColor (X, Y) = GetPixel_(hdc, ActMouseX - 5 + X, ActMouseY - 4 + Y) 
    Next 
  Next 
  ActRed = Red (ActPixelColor (5, 4)) 
  ActGreen = Green (ActPixelColor (5, 4)) 
  ActBlue = Blue (ActPixelColor (5, 4)) 
  
  StartDrawing (ImageOutput(0)) 
    For Y = 0 To 8 
      For X = 0 To 10 
        Box (X * 3, Y * 3, 3, 3, ActPixelColor(X, Y)) 
      Next 
    Next 
  StopDrawing() 
  



  SetGadgetState (#Show1, ImageID(0)) 
  
  If OldColor <> ActPixelColor (5, 4) 
    Gosub HexColor 
    StartDrawing (ImageOutput(1)) 
    Box (0, 0, 33, 27, ActPixelColor(5, 4)) 
    StopDrawing() 
    
    SetGadgetState (#Show2, ImageID(1)) 

    SetGadgetText (#RGB_Anzeige, Str(ActRed) + ", " + Str(ActGreen) + ", " +Str(ActBlue)) 
    SetGadgetText (#Hex_Anzeige, ActHex) 
    SetGadgetText (#Dez_Anzeige, Str(ActPixelColor (5, 4))) 
  OldColor = ActPixelColor(5, 4) 
  EndIf 
  OldMouseX = ActMouseX 
  OldMouseY = ActMouseY 
EndIf 
;While WindowEvent(): Wend 
Until Quit 
ReleaseDC_(0, hdc);WindowID(35), hdc) 
End 



HexColor: 

  R1 = Int (ActRed / 16) 
  R2 = Int (ActRed - ( R1 * 16)) 
  hw (0) = Str (R1)  
  hw (1) = Str (R2) 
  
  G1 = Int (ActGreen / 16) 
  G2 = Int (ActGreen - ( G1 * 16)) 
  hw (2) = Str (G1)  
  hw (3) = Str (G2) 
  
  B1 = Int (ActBlue / 16) 
  B2 = Int (ActBlue - ( B1 * 16)) 
  hw (4) = Str (B1)  
  hw (5) = Str (B2) 
  

  ActHex = "" 

  For I = 0 To 5 
    Select hw (I) 
      Case "10" 
        hw (I) = "A" 
      Case "11" 
        hw (I) = "B" 
      Case "12" 
        hw (I) = "C" 
      Case "13" 
        hw (I) = "D" 
      Case "14" 
        hw (I) = "E" 
      Case "15" 
        hw (I) = "F" 
    EndSelect 
    ActHex + hw (I) 
  Next 
Return

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
