; German forum: http://www.purebasic.fr/german/viewtopic.php?t=3199&highlight=
; Author: Lukaso (updated for PB 4.00 by Andre)
; Date: 29. April 2005
; OS: Windows
; Demo: No


; ###################################### 
; # Name: ASCII-Pic Generator          # 
; # Author: Lukas 'Lukaso' Niewalda    # 
; # Website: http://www.lukaso.org     # 
; # Kontakt: lukaso@lukaso.org         # 
; ###################################### 

Global CustomTextLength, Offset, FontID, BackgroundColor 

; ### Options ######################### 
  #CutomTextMode = #False ; Eigener Text ? 
  CustomText.s = "PUREBASIC RULZ! " ; Hier kommt der eigene Text hin 
  Offset = 2 ; Zwischenabstand verringern 
  FontID = LoadFont(1, "Arial", 6, #PB_Font_Bold) ; Schriftart und Größe 
  BackgroundColor = $000000 ; Hintergrundfarbe in Hex 
; ##################################### 

If #CutomTextMode = #True 
  CustomTextLength = Len(CustomText) 
  Global Dim Text.s(CustomTextLength - 1) 
  For i = 1 To CustomTextLength 
    Text(i-1) = Mid(CustomText, i, 1) 
  Next 
EndIf 

Procedure GetColorArea(image, startx, endx, starty, endy) 
  For X2 = 1 To endx - startx 
    For y2 = 1 To endy - starty 
      clr = Point(startx + X2, starty + y2) 
      num + 1 
      red + Red(clr) 
      green + Green(clr) 
      blue + Blue(clr) 
    Next 
  Next 
  red = red / num 
  green = green / num 
  blue = blue / num 
  FrontColor(RGB(red, green, blue))
EndProcedure 

Procedure GetTextHeight(hdc) ; <-- Procedure by GPI 
  tm.textmetric 
  PrevMapMode = SetMapMode_(hdc, #MM_TEXT) 
  GetTextMetrics_(hdc, tm) 
  If prevmapmode 
    SetMapMode_(hdc, prevmapmode) 
  EndIf 
  ProcedureReturn tm\tmHeight 
EndProcedure 

Procedure ASCII_Filter(image) 
  If IsImage(image) 
    Width = ImageWidth(image) 
    Height = ImageHeight(image) 
  
    CreateImage(2, Width, Height) 
    hdc = StartDrawing(ImageOutput(2))
    BackColor(BackgroundColor)
    DrawingFont(FontID) 
    space = GetTextHeight(hdc) - Offset 
    DrawImage(ImageID(image), 0, 0) 
    Repeat 
      text.s = "" 
      Repeat 
        If #CutomTextMode = #True 
          If TextPosition > CustomTextLength - 1 
            TextPosition = 0 
          EndIf 
          new.s = Text(TextPosition) 
          TextPosition + 1 
        Else 
          new.s = Chr(Random(25) + 65) 
        EndIf 
        
        GetColorArea(1, TextWidth(text), TextWidth(text) + TextWidth(new), y * space, y * space + space) 
        DrawText(TextWidth(text), y * space - 2, new) 
        text = text + new 
      Until TextWidth(text) >= Width 
      y + 1 
      If #CutomTextMode = #True 
        TextPosition = Random(CustomTextLength - 1) 
      EndIf 
    Until y * space >= Height 
    StopDrawing() 
    HideGadget(0, 1) 
    ResizeWindow(0, #PB_Ignore, #PB_Ignore, Width, Height) 
    HideGadget(1, 0) 
    SetGadgetState(1, ImageID(2)) 
    Delay(1000) 
    Select MessageRequester("Save Image", "Do you want to save the created image?", #MB_YESNO) 
      Case #IDYES 
        savefile$ = SaveFileRequester("Save image","ascii-pic.bmp","Bitmap|*.bmp", 0) 
        If savefile$ 
          If Mid(savefile$, Len(savefile$) - 3, 4) <> ".bmp" 
            savefile$ = savefile$ + ".bmp" 
          EndIf 
          If FileSize(savefile$) > 0 
            DeleteFile(savefile$) 
          EndIf 
          SaveImage(2, savefile$, #PB_ImagePlugin_BMP) 
        EndIf 
    EndSelect 
  Else 
    MessageRequester("Error", "Image not loaded successful!") 
    End 
  EndIf 
EndProcedure 

UseJPEGImageDecoder() 
UsePNGImageDecoder() 

FileName$ = OpenFileRequester("Open image","","Images|*.bmp;*.jpg;*.jpeg;*.png", 0) 

If FileName$ 
  LoadImage(1, FileName$) 
  If OpenWindow(0, 0, 0, 200, 19, "|ASCII-Pic Generator| by Lukaso", #PB_Window_SystemMenu | #PB_Window_TitleBar) 
    If CreateGadgetList(WindowID(0)) 
      TextGadget(0, 2, 2, 196, 15, "Generating image") 
      ImageGadget(1, 0, 0, 0, 0, 0) 
      HideGadget(1, 1) 
    EndIf 
  EndIf 
  CreateThread(@ASCII_Filter(), 1) 
  Repeat 
    Delay(20) 
  Until WaitWindowEvent() = #PB_Event_CloseWindow 
EndIf 
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -