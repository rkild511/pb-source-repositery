; German forum: http://www.purebasic.fr/german/viewtopic.php?t=694&highlight=
; Author: blbltheworm (updated for PB 4.00 by Andre)
; Date: 01. November 2004
; OS: Windows
; Demo: Yes

; Der folgende Code dient dazu, einen Text in ein Sprite einzugeben.
; Mit initDXKey() werden alle wichtigen Einstellung gesetzt.
; Mit GetText() wird dann das aktuelle Zeichen zum Text hinzugefügt.
; WICHTIG!!
; vor GetText() muss ExamineKeyboard() aufgerufen werden.
;
Structure sRGB
  R.w
  G.w
  b.w
EndStructure

#gfxText=194
Global IDFont.l
Global FontHeight.w
Global FontName.s
Global Flags.l
Global FontColor.sRGB
Global TransColor.sRGB
Global FullText.s
Global LengthText.w

Procedure initDXKey(iFontName.s,iHeight.w,MaxLength.w,iFlags.w,R.w,G.w,b.w, tR.w,tG.w,tB.w)
  Flags=iFlags
  FontHeight=iHeight
  FontName=iFontName
  LengthText=MaxLength ;Maximale Länge des Textes in Pixeln
  IDFont=LoadFont(#PB_Any,iFontName,iHeight,iFlags)
  FontColor\R=R
  FontColor\G=G
  FontColor\b=b
  TransColor\R=tR
  TransColor\G=tG
  TransColor\b=tB
  CreateSprite(#gfxText,LengthText,FontHeight*1.6,0) ;Funktioniert zwar, ist aber noch nicht ideal
  TransparentSpriteColor(#gfxText,RGB(tR,tG,tB))
EndProcedure


Procedure GetText()
  tmpChr.s
  Static Blink.b
  Static NextbTick.l
  ;      If KeyboardPushed(#PB_Key_All)
  tmpChr=KeyboardInkey()
  If  KeyboardPushed(#PB_Key_LeftShift) Or KeyboardPushed(#PB_Key_RightShift)
    tmpChr=ReplaceString(tmpChr,"^","°")
    tmpChr=ReplaceString(tmpChr,"1","!")
    tmpChr=ReplaceString(tmpChr,"2",Chr(34)) ;"
    tmpChr=ReplaceString(tmpChr,"3","§")
    tmpChr=ReplaceString(tmpChr,"4","$")
    tmpChr=ReplaceString(tmpChr,"5","%")
    tmpChr=ReplaceString(tmpChr,"6","&")
    tmpChr=ReplaceString(tmpChr,"7","/")
    tmpChr=ReplaceString(tmpChr,"8","(")
    tmpChr=ReplaceString(tmpChr,"9",")")
    tmpChr=ReplaceString(tmpChr,"0","=")
    tmpChr=ReplaceString(tmpChr,"ß","?")
    tmpChr=ReplaceString(tmpChr,"´","`")
    tmpChr=ReplaceString(tmpChr,"<",">")
    tmpChr=ReplaceString(tmpChr,",",";")
    tmpChr=ReplaceString(tmpChr,".",":")
    tmpChr=ReplaceString(tmpChr,"-","_")
    tmpChr=ReplaceString(tmpChr,"#","'")
    tmpChr=ReplaceString(tmpChr,"+","*")
    tmpChr=ReplaceString(tmpChr,"ä","Ä")
    tmpChr=ReplaceString(tmpChr,"ö","Ö")
    tmpChr=ReplaceString(tmpChr,"ü","Ü")
  ElseIf  KeyboardPushed(#PB_Key_RightAlt); [Alt Gr]
    tmpChr=ReplaceString(tmpChr,"<","|")
    tmpChr=ReplaceString(tmpChr,"2","²")
    tmpChr=ReplaceString(tmpChr,"3","³")
    tmpChr=ReplaceString(tmpChr,"7","{")
    tmpChr=ReplaceString(tmpChr,"8","[")
    tmpChr=ReplaceString(tmpChr,"9","]")
    tmpChr=ReplaceString(tmpChr,"0","}")
    tmpChr=ReplaceString(tmpChr,"ß","\")
    tmpChr=ReplaceString(tmpChr,"+","~")
    tmpChr=ReplaceString(tmpChr,"m","µ")
    tmpChr=ReplaceString(tmpChr,"q","@")
  EndIf

  If  KeyboardReleased(#PB_Key_LeftShift) Or KeyboardReleased(#PB_Key_RightShift) Or KeyboardReleased(#PB_Key_RightAlt)
    tmpChr=""
  EndIf

  FullText=FullText+tmpChr; fügt das nächste Zeichen zum aktuellen Text (sofern vorhanden) hinzu

  tmpChr=""
  ; Wenn wir die 'Backspace'-Taste drücken, löschen wir das letzte Zeichen
  ;
  If KeyboardReleased(#PB_Key_Back)
    FullText = Left(FullText, Len(FullText)-1)
  EndIf
  ;      Else
  ;        Delay(1)
  ;      EndIf

  ; Ergebnis darstellen
  ;
  If StartDrawing(SpriteOutput(#gfxText))
    ;CreateSprite(#gfxText,TextLength(FullText$),FontSize)

    Box(0,0,SpriteWidth(#gfxText),SpriteHeight(#gfxText),RGB(TransColor\R,TransColor\G,TransColor\b))
    DrawingMode(1)
    BackColor(RGB(TransColor\R,TransColor\G,TransColor\b))
    DrawingFont(FontID(IDFont))


    While TextWidth(FullText)>LengthText
      FullText = Left(FullText, Len(FullText)-1)
    Wend

    FrontColor(RGB(FontColor\R,FontColor\G,FontColor\b))
    DrawText(0,0,FullText)
    Box(TextWidth(FullText),2,3*Blink,(FontHeight*1.6-2)*Blink)

    If NextbTick<ElapsedMilliseconds()
      NextbTick=ElapsedMilliseconds()+500
      Blink=1-Blink
    EndIf

    StopDrawing()
  EndIf
EndProcedure



If InitSprite() And InitKeyboard() : Else : End : EndIf
ExamineDesktops()
If OpenScreen(DesktopWidth(0),DesktopHeight(0),DesktopDepth(0),"") : Else : End : EndIf

initDXKey("Arial",16,300,#PB_Font_Bold, 255, 50, 50, 100, 100, 200)

Repeat
  FlipBuffers()
  ClearScreen(RGB(0,0,0))
  ExamineKeyboard()
  GetText()
  DisplaySprite(#gfxText,20,20)
  If KeyboardPushed(#PB_Key_Escape)   ; drücken Sie Esc zum Beenden
    End
  EndIf
ForEver

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -