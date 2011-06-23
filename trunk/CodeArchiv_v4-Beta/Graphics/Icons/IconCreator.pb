; German forum: http://www.purebasic.fr/german/viewtopic.php?t=11194&postdays=0&postorder=asc&start=20
; Author: Thomas (improved by Scarabol)
; Date: 21. December 2006
; OS: Windows
; Demo: Yes

;#################################
;#                               #
;#  IconCreator Professional     #
;#                               #
;#    written by Thomas          #
;#    modded by Scarabol         #
;#                               #
;#################################

;*****-Initialisierung-*****
UsePNGImageDecoder()
UsePNGImageEncoder()
UseJPEGImageDecoder()
UseJPEGImageEncoder()
UseTGAImageDecoder()
UseTIFFImageDecoder()

;*****-Fenster-*****
Enumeration
  #HauptFenster
EndEnumeration

;*****-Bilder-*****
Enumeration
  #AuswahlImage
  #OrginalBitmap
  #Bitmap
  #Icon
EndEnumeration

;*****-Gadgets-*****
Enumeration
  #Frame3DGroesse
  #Frame3DTransparent
  #Frame3DVorschau
  #TextColorTransparent
  #TextChooseColorTransparent
  #Option16
  #Option24
  #Option32
  #Option48
  #CheckTransparent
  #ColorTransparent
  #ChooseColorTransparent
  #ImageBitmap
  #ButtonSpeichern
  #ButtonAbbrechen
  #ButtonImageOpenFile
  #ButtonOpenFile
EndEnumeration

;*****-Name der Andwendung-*****
#AndwendungName = "IconCreator Professional"

;*****-Varialben, Strings-*****
Global Bitmap$
Global SaveIcon$
Global TransparentColor.l = RGB(255,255,255)

;*****-Icon erstellen-*****
Procedure CreateIcon()

  If GetGadgetState(#Option16) <> 0
    Restore IconHeader_16
  ElseIf GetGadgetState(#Option24) <> 0
    Restore IconHeader_24
  ElseIf GetGadgetState(#Option32) <> 0
    Restore IconHeader_32
  ElseIf GetGadgetState(#Option48) <> 0
    Restore IconHeader_48
  Else ; ist zwar eigentlich unmöglich aber sicher ist sicher :-)
    ProcedureReturn 0
  EndIf

  ; neue Datei erstellen
  If CreateFile(#Icon, SaveIcon$+".ico") = 0 : ProcedureReturn 0 : EndIf

  ; Header in Datei schreiben
  For i=1 To 62 : Read ThisValue : WriteByte(#Icon,ThisValue) : Next i

  ; nur um ganz sicher zu gehen
  If IsImage(#Bitmap) = 0 : ProcedureReturn 0 : EndIf

  ; StartDrawing für die folgenden Zeichenoperationen
  StartDrawing(ImageOutput(#Bitmap))

  ;Erstellt eine Palette mit 256 Farben
  Dim UsedColors.l(255)
  UsedColors(0) = RGB(0,0,0)
  UsedColorCount.l = 1
  For y=31 To 0 Step -1
    For x=0 To 31 Step 1
      Farbe.l = Point(x,y)
      AddToList.l = 1
      For i=0 To UsedColorCount
        If Farbe = UsedColors(i)
          AddToList = 0
          i = UsedColorCount
        EndIf
      Next i
      If UsedColorCount=255 And AddToList
        MIN_I = 1
        MIN_DIF = 0
        For i=1 To UsedColorCount
          If Abs(Farbe-UsedColors(i)) < MIN_DIF Or i = 1
            MIN_I = i
            MIN_DIF = Abs(Farbe-UsedColors(i))
          EndIf
        Next i
        NEW_RED = (Red(Farbe)+Red(UsedColors(MIN_I)))/2
        NEW_GREEN = (Green(Farbe)+Green(UsedColors(MIN_I)))/2
        NEW_BLUE = (Blue(Farbe)+Blue(UsedColors(MIN_I)))/2
        UsedColors(MIN_I) = RGB(NEW_RED,NEW_GREEN,NEW_BLUE)
      ElseIf UsedColorCount <> 255 And AddToList
        UsedColors(UsedColorCount) = Farbe
        UsedColorCount+1
      EndIf
    Next x
  Next y

  ;Schreibt die Palette in die Datei
  For i=0 To UsedColorCount : WriteByte(#Icon,Blue(UsedColors(i))) : WriteByte(#Icon,Green(UsedColors(i))) : WriteByte(#Icon,Red(UsedColors(i))) : WriteByte(#Icon,0) : Next i

  ;Für alle freien Einträge wird die Farbe SCHWARZ eingefügt
  For i = UsedColorCount+1 To 255 : WriteLong(#Icon,0) : Next i

  ;Schreibt das Bild in die Datei
  For y=31 To 0 Step -1
    For x=0 To 31 Step 1
      Farbe.l = Point(x,y)
      If Farbe <> TransparentColor
        MIN_I = 0
        For i=0 To UsedColorCount
          If Abs(Farbe-UsedColors(i)) < MIN_DIF Or i = 0
            MIN_I = i
            MIN_DIF = Abs(Farbe-UsedColors(i))
          EndIf
        Next i
        Farbe = MIN_I
      Else
        Farbe = 0
      EndIf
      WriteByte(#Icon, Farbe)
    Next x
  Next y

  ;Schreibt am Ende eine Liste, damit der Computer weiß, welche Pixel transparent sind
  For y=31 To 0 Step -1
    For x=0 To 31 Step 8
      LastByte.l = 0
      For i=0 To 7
        Farbe.l = Point(X+I,Y)
        If Farbe = TransparentColor
          Select i
            Case 7 : OrVal=  1
            Case 6 : OrVal=  2
            Case 5 : OrVal=  4
            Case 4 : OrVal=  8
            Case 3 : OrVal= 16
            Case 2 : OrVal= 32
            Case 1 : OrVal= 64
            Case 0 : OrVal=128
          EndSelect
          LastByte|OrVal
        EndIf
      Next i
      WriteByte(#Icon, LastByte)
    Next x
  Next y

  ; Stopdrawing beenden
  StopDrawing()

  ; Fertig! Datei schließen
  CloseFile(#Icon)
  ProcedureReturn 1

  ;*****-Iconformate-*****
  DataSection
    IconHeader_16:
    Data.l $00, $00, $01, $00, $01, $00, $10, $10, $00, $00, $01, $00, $08, $00, $68, $05
    Data.l $00, $00, $16, $00, $00, $00, $28, $00, $00, $00, $10, $00, $00, $00, $20, $00
    Data.l $00, $00, $01, $00, $08, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00
    Data.l $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    IconHeader_24:
    Data.l $00, $00, $01, $00, $01, $00, $18, $18, $00, $00, $01, $00, $08, $00, $FF, $06
    Data.l $00, $00, $16, $00, $00, $00, $28, $00, $00, $00, $18, $00, $00, $00, $30, $00
    Data.l $00, $00, $01, $00, $08, $00, $00, $00, $00, $00, $40, $02, $00, $00, $00, $00
    Data.l $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    IconHeader_32: ;<--- Dieser Header funktioniert, die anderen leider nicht
    Data.l $00, $00, $01, $00, $01, $00, $20, $20, $00, $00, $00, $00, $00, $00, $A8, $08
    Data.l $00, $00, $16, $00, $00, $00, $28, $00, $00, $00, $20, $00, $00, $00, $40, $00
    Data.l $00, $00, $01, $00, $08, $00, $00, $00, $00, $00, $80, $04, $00, $00, $00, $00
    Data.l $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    IconHeader_48:
    Data.l $00, $00, $01, $00, $01, $00, $30, $30, $00, $00, $01, $00, $08, $00, $FF, $0E
    Data.l $00, $00, $16, $00, $00, $00, $28, $00, $00, $00, $30, $00, $00, $00, $60, $00
    Data.l $00, $00, $01, $00, $08, $00, $00, $00, $00, $00, $00, $09, $00, $00, $00, $00
    Data.l $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
  EndDataSection

EndProcedure


;*****-ProgramParameter verarbeiten-*****
Bitmap$ = ProgramParameter()
If Bitmap$
  If LoadImage(#OrginalBitmap, Bitmap$) = 0
    MessageRequester("Fehler", "Bitmap konnte nicht geladen werden!", #MB_ICONERROR)
    End
  EndIf
  CopyImage(#OrginalBitmap, #Bitmap)
  ResizeImage(#Bitmap, 32, 32)
EndIf


;*****-Hauptfenster öffnen-*****
If OpenWindow(#HauptFenster, 0, 0, 330, 290, #AndwendungName, #PB_Window_ScreenCentered | #PB_Window_SystemMenu)

  ;*****-Gadgetliste-*****
  If CreateGadgetList(WindowID(#HauptFenster))
    Frame3DGadget(#Frame3DGroesse, 10, 10,  140, 129, "Größe")
    OptionGadget(#Option16, 20, 30,  65,  24, "16 x 16")
    OptionGadget(#Option24, 20, 55,  65,  24, "24 x 24")
    OptionGadget(#Option32, 20, 80,  65,  24, "32 x 32")
    OptionGadget(#Option48, 20, 105, 65,  24, "48 x 48")
    SetGadgetState(#Option32, 1)

    Frame3DGadget(#Frame3DTransparent, 10, 150, 140, 129, "Transparents")
    CheckBoxGadget(#CheckTransparent, 20, 170, 120, 24, "Transparentes Icon")
    SetGadgetState(#CheckTransparent, 1)
    ContainerGadget(#ColorTransparent, 20, 205, 20, 20)
    SetGadgetColor(#ColorTransparent, #PB_Gadget_BackColor, RGB(255, 255, 255))
    CloseGadgetList()
    TextGadget(#TextColorTransparent, 50, 200, 70, 30, "Transparente Farbe")
    ButtonGadget(#ChooseColorTransparent, 20, 240, 20, 20, "")
    TextGadget(#TextChooseColorTransparent, 50, 235, 70, 30, "Transparente Farbe wählen")

    Frame3DGadget(#Frame3DVorschau, 170, 10, 150, 130, "Vorschau")
    ImageGadget(#ImageBitmap, 190, 40, 0, 0, 0, #PB_Image_Border)
    If Bitmap$ : SetGadgetState(#ImageBitmap, ImageID(#Bitmap)) : EndIf

    ButtonGadget(#ButtonSpeichern, 180, 209, 130, 30, "Als Icon speichern")
    ButtonGadget(#ButtonAbbrechen, 180, 249, 130, 30, "Beenden")
    ButtonImageGadget(#ButtonOpenFile, 180, 163, 130, 36, CatchImage(#ButtonImageOpenFile, ?OpenImageBinary))

    ; wegen fehlender Header werden einige Gadgets leider gesperrt
    DisableGadget(#Option16, 1)
    DisableGadget(#Option24, 1)
    ;    DisableGadget(#Option32, 1)  <---- hier ist ein funktionierender Header vorhanden
    DisableGadget(#Option48, 1)
  EndIf

  ;*****-Hauptschleife-*****
  Repeat

    EventID = WaitWindowEvent()

    ;*****-Gadgetabfrage-*****
    If EventID = #PB_Event_Gadget
      Select EventGadget()
        Case #Option16
          FreeImage(#Bitmap)
          CopyImage(#OrginalBitmap, #Bitmap)
          ResizeImage(#Bitmap, 16, 16)
          FreeGadget(#ImageBitmap)
          ImageGadget(#ImageBitmap, 190, 40, 0, 0, ImageID(#Bitmap), #PB_Image_Border)
        Case #Option24
          FreeImage(#Bitmap)
          CopyImage(#OrginalBitmap, #Bitmap)
          ResizeImage(#Bitmap, 24, 24)
          FreeGadget(#ImageBitmap)
          ImageGadget(#ImageBitmap, 190, 40, 0, 0, ImageID(#Bitmap), #PB_Image_Border)
        Case #Option32
          FreeImage(#Bitmap)
          CopyImage(#OrginalBitmap, #Bitmap)
          ResizeImage(#Bitmap, 32, 32)
          FreeGadget(#ImageBitmap)
          ImageGadget(#ImageBitmap, 190, 40, 0, 0, ImageID(#Bitmap), #PB_Image_Border)
        Case #Option48
          FreeImage(#Bitmap)
          CopyImage(#OrginalBitmap, #Bitmap)
          ResizeImage(#Bitmap, 48, 48)
          FreeGadget(#ImageBitmap)
          ImageGadget(#ImageBitmap, 190, 40, 0, 0, ImageID(#Bitmap), #PB_Image_Border)
        Case #ButtonSpeichern
          If SaveIcon$ = ""
            SaveIcon$ = SaveFileRequester("Icon Speichern als...", "", "Icon | *.ico", 0)
          EndIf
          If SaveIcon$ <> ""
            If GetGadgetState(#CheckTransparent) = 1
              TransparentColor = GetGadgetColor(#ColorTransparent, #PB_Gadget_BackColor)
            Else
              TransparentColor = -1
            EndIf
            IconCreateStatus = CreateIcon()
            If IconCreateStatus
              MessageRequester("Info", "Das Icon wurde erfolgreich erstellet!", #MB_ICONINFORMATION)
            Else
              MessageRequester("Error", "Das Icon konnte nicht erstellt werden!", #MB_ICONERROR)
            EndIf
          EndIf
          ; um wiederholtes Speichern zu ermöglichen
          SaveIcon$ = ""
        Case #ChooseColorTransparent
          ChooseNewColor = ColorRequester(RGB(255,255,255))
          If ChooseNewColor <> -1
            TransparentColor = ChooseNewColor
            SetGadgetColor(#ColorTransparent, #PB_Gadget_BackColor, TransparentColor)
          EndIf
        Case #ButtonOpenFile
          Bitmap$ = OpenFileRequester("Bitmap öffnen", "", "Alle Formate (*.bmp, *.png, *.jpeg, *.tiff, *.tga)|*.bmp;*.png;*.jpg;*.jpeg;*.tiff;*.tga", 0)
          If Bitmap$
            If LoadImage(#OrginalBitmap, Bitmap$) = 0
              MessageRequester("Fehler", "Bitmap konnte nicht geladen werden!", #MB_ICONERROR)
              End
            EndIf
            CopyImage(#OrginalBitmap, #Bitmap)
            ResizeImage(#Bitmap, 32, 32)
          EndIf
          If Bitmap$
            SetGadgetState(#ImageBitmap, ImageID(#Bitmap))
          EndIf
        Case #ButtonAbbrechen
          EventID = 16
      EndSelect
    EndIf

    If GetGadgetState(#CheckTransparent) = 1
      DisableGadget(#ChooseColorTransparent, 0)
      DisableGadget(#TextChooseColorTransparent, 0)
      DisableGadget(#TextColorTransparent, 0)
    Else
      DisableGadget(#ChooseColorTransparent, 1)
      DisableGadget(#TextChooseColorTransparent, 1)
      DisableGadget(#TextColorTransparent, 1)
    EndIf

  Until EventID = #PB_Event_CloseWindow

Else
  MessageRequester("Fehler", "Fenster konnte nicht geöffnet werden!", #MB_ICONERROR)
  End
EndIf

End

DataSection
  OpenImageBinary:
  IncludeBinary "..\gfx\disk.ico"
EndDataSection

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP