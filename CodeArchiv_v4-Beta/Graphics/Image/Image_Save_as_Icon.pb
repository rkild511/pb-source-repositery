; German forum:
; Author: PureFan (updated for PB4.00 by blbltheworm)
; Date: 23. March 2003
; OS: Windows
; Demo: Yes

;"--------------------------------------------------------------------- 
;             Bilder als *.ICO und *.CUR - Datei abspeichern 
;"--------------------------------------------------------------------- 

;Verwenden sie diese Variable, wenn sie keine transparenz verwenden wollen! 
Global NoTransparent 
PokeB(@NoTransparent.l+3,1) 

;Schreibt ein Byte (0-255) in die aktuell geöffnete Datei 
Procedure.l WriteByte2(File.l,val.l) 
  WriteData(File,@val,1) 
EndProcedure 


;Speichert das Bild, auf dem gerade gezeichnet wird, in einer *.ICO 
;(HotspotX und HotspotY muss 0 sein!) oder in einer *.CUR-Datei! 
Procedure.l SaveIcon(FileName.s,TransparentColor.l,HotspotX.l,HotspotY.l) 

  ;Der Hotspot muss sich innerhalb des Bildes befinden! 
  If HotspotX>32:HotspotX=32:ElseIf HotspotX<0:HotspotX=0:EndIf 
  If HotspotY>32:HotspotY=32:ElseIf HotspotY<0:HotspotY=0:EndIf 
  
  ;Öffnet die Datei  
  If CreateFile(0,FileName)=0 
    ProcedureReturn 0 
  EndIf 
  
  ;Schreibt zuerst den HEADER für eine 32x32 Pixel große ICO-Datei 
  Restore ICON_HEADER_256_COLORS 
  For I=1 To 62 
    Read ThisValue 
    If I=$B 
      WriteByte2(0,HotspotX) 
    ElseIf I=$D 
      WriteByte2(0,HotspotY) 
    Else 
      WriteByte2(0,ThisValue) 
    EndIf 
  Next I 
  
  ;Erstellt eine Palette mit 256 Farben 
  Global Dim UsedColors.l(255) 
  UsedColors(0)=RGB(0,0,0) 
  UsedColorCnt.l=1 
  For Y=31 To 0 Step -1 
    For X=0 To 31 Step 1 
      Farbe.l=Point(X,Y) 
      AddToList.l=1 
      For I=0 To UsedColorCnt 
        If Farbe=UsedColors(I) 
          AddToList=0 
          I=UsedColorCnt 
        EndIf 
      Next I 
      If UsedColorCnt=255 And AddToList 
        MIN_I=1 
        MIN_DIF=0 
        For I=1 To UsedColorCnt 
          If Abs(Farbe-UsedColors(I))<MIN_DIF Or I=1 
            MIN_I=I 
            MIN_DIF=Abs(Farbe-UsedColors(I)) 
          EndIf 
        Next I 
        NEW_RED=(Red(Farbe)+Red(UsedColors(MIN_I)))/2 
        NEW_GREEN=(Green(Farbe)+Green(UsedColors(MIN_I)))/2 
        NEW_BLUE=(Blue(Farbe)+Blue(UsedColors(MIN_I)))/2 
        UsedColors(MIN_I)=RGB(NEW_RED,NEW_GREEN,NEW_BLUE) 
      ElseIf UsedColorCnt<>255 And AddToList 
        UsedColors(UsedColorCnt)=Farbe 
        UsedColorCnt+1 
      EndIf 
    Next X 
  Next Y 
  
  ;Schreibt die Palette in die Datei 
  For I=0 To UsedColorCnt 
    WriteByte(0,Blue(UsedColors(I))) 
    WriteByte(0,Green(UsedColors(I))) 
    WriteByte(0,Red(UsedColors(I))) 
    WriteByte(0,0) 
  Next I 
  
  ;Für alle freien Einträge wird die Farbe SCHWARZ eingefügt 
  For I=UsedColorCnt+1 To 255 
    WriteLong(0,0) 
  Next I 
  
  ;Schreibt das Bild in die Datei 
  For Y=31 To 0 Step -1 
    For X=0 To 31 Step 1 
      Farbe.l=Point(X,Y) 
      If Farbe<>TransparentColor 
        MIN_I=0 
        For I=0 To UsedColorCnt 
          If Abs(Farbe-UsedColors(I))<MIN_DIF Or I=0 
            MIN_I=I 
            MIN_DIF=Abs(Farbe-UsedColors(I)) 
          EndIf 
        Next I  
        Farbe=MIN_I      
      Else 
        Farbe=0 
      EndIf 
      WriteByte2(0,Farbe) 
    Next X 
  Next Y 
  
  ;Schreibt am Ende eine Liste, damit der Computer weiß, welche Pixel transparent sind 
  For Y=31 To 0 Step -1 
    For X=0 To 31 Step 8 
      LastByte.l=0 
      For I=0 To 7 
        Farbe.l=Point(X+I,Y) 
        If Farbe=TransparentColor 
          Select I 
            Case 7:OrVal=1 
            Case 6:OrVal=2 
            Case 5:OrVal=4 
            Case 4:OrVal=8 
            Case 3:OrVal=16 
            Case 2:OrVal=32 
            Case 1:OrVal=64 
            Case 0:OrVal=128 
          EndSelect 
          LastByte|OrVal 
        EndIf 
      Next I 
      WriteByte2(0,LastByte) 
    Next X 
  Next Y 
  
  ;Fertig! Schließt die Datei 
  CloseFile(0) 
  ProcedureReturn 1 
  
  ;Der HEADER für eine ICO-Datei 
  DataSection 
  ICON_HEADER_256_COLORS: 
    Data.l $00,$00,$01,$00,$01,$00,$20,$20,$00,$00,$00,$00,$00,$00,$A8,$08 
    Data.l $00,$00,$16,$00,$00,$00,$28,$00,$00,$00,$20,$00,$00,$00,$40,$00 
    Data.l $00,$00,$01,$00,$08,$00,$00,$00,$00,$00,$80,$04,$00,$00,$00,$00 
    Data.l $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 
  EndDataSection 

EndProcedure 




;"--------------------------------------------------------------------- 
;                                 BEISPIEL 
;"--------------------------------------------------------------------- 

MessageRequester("Bmp2Ico","Bitte wählen sie im folgenden Dialog das Bitmap aus, das in eine Ico umgewandelt werden soll!",0) 

BmpDatei.s=OpenFileRequester("BMP-Datei öffnen","","Bitmaps|*.bmp",0) 

If BmpDatei="" 
  End 
EndIf 

IcoDatei.s=SaveFileRequester("Speichern als ICO-Datei","","Icons|*.ico",0) 

If IcoDatei="" 
  End 
EndIf 

If LoadImage(0,BmpDatei)=0 
  MessageRequester("Fehler!","Ungültiges Dateiformat!",0) 
EndIf 

StartDrawing(ImageOutput(0)) 

SaveIcon(IcoDatei,NoTransparent,0,0)  ;Ico-Dateien haben keinen Hotspot 

StopDrawing() 

MessageRequester("Info!","Datei erfolgreich abgespeichert!",0) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -