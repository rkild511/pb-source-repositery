; German forum: http://www.purebasic.fr/german/viewtopic.php?t=856&start=10
; Author: Kekskiller (updated for PB 4.00 by Andre)
; Date: 13. November 2004
; OS: Windows
; Demo: Yes


;  Funktion, mit welcher man sich das ständige Laden von Einzelbildern ersparen kann. 
; Man gibt eine Konstante an, Dateiname und Maskierung und kann danach die einzelnen 
; Bilder per #Konstante + nächstes Bild an. #Konstante + 0 (also nur die Konstante) 
; ist das erste Bild, und je nachdem, wie viel man zuaddiert, bekommt man die anderen, 
; naja. Es lädt alle Bilder aus dem Bild, daher sollte man sich vergewissern, wie 
; viele Bilder enthalten sind, um die anderen Konstanten entsprechend auszurichten: 

#TMP_AnimSprite = 0

Procedure.b LoadAnimSprite(AnimSprite.l,FileName$, TileWidth.l,TileHeight.l, Mode.l, MaskRed.l,MaskGreen.l,MaskBlue.l) 
  If FileSize(FileName$) >= 0 
    LoadSprite(#TMP_AnimSprite, FileName$, 0) 
    widthtiles = SpriteWidth(#TMP_AnimSprite) / TileWidth 
    heighttiles =SpriteHeight(#TMP_AnimSprite) / TileHeight 
    UseBuffer(#TMP_AnimSprite) 
    For zy = 1 To heighttiles 
      For zx = 1 To widthtiles 
        GrabSprite(AnimSprite + z, (zx-1)*TileWidth,(zy-1)*TileHeight, TileWidth,TileHeight, Mode) 
        TransparentSpriteColor(AnimSprite + z, RGB(MaskRed,MaskGreen,MaskBlue))
        z = z + 1 
      Next 
    Next 
    ReturnCode = 1 
    FreeSprite(#TMP_AnimSprite) 
    UseBuffer(-1) 
  Else 
    ReturnCode =  0 
  EndIf 
  ProcedureReturn ReturnCode 
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -