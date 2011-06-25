;*****************************************************************************
;* PurePunch Contest 
;* http://www.purebasic.fr/english/viewtopic.php?p=256341#256341
;*
;* Author : djes
;* Date : Fri Aug 29, 2008
;* Link : http://www.purebasic.fr/english/viewtopic.php?p=256993#256993
;*
;*****************************************************************************
Macro st : StartDrawing(ScreenOutput()) : EndMacro : Macro ds(m) : DisplaySprite3D(0, 512 - w*5 + x*10 + 20*Sin(i.f + x/20 + y/20), y*10 + 20*Cos(i + x/20 + y/20) + m, y*10) : EndMacro : Goto p
ct: ClearScreen(0) : st: w = TextWidth(t$) : h = TextHeight(t$) : Dim m1(w, h) : DrawText(0, 0, t$, $FF, 0) : For y = 0 To h : For x = 0 To w : m1(x, y) = Point(x, y) : Next x : Next y : Circle(100, 100, 8, $5588FF) : StopDrawing() : Return
p: InitSprite() : InitSprite3D() : InitKeyboard() : OpenScreen(1024, 768, 32, "") : t2$="BIENVENUE" : t$="ALEXANDRE" : Gosub ct : Dim m2(w, h) : Swap t$, t2$ : Swap m1(), m2() : Swap h2, h : Swap w2, w : Gosub ct
GrabSprite(0, 92, 92, 16, 16, #PB_Sprite_Texture) : CreateSprite3D(0, 0) : ClearScreen(0) : st : For y = 0 To 64 : Box( 0,       y, 1024, 128 - y*2, RGB(y*4, 0, 0) ) : Box( 0, 128 + y, 1024, 128 - y*2, RGB(0, y*4, 0) )
Box( 0, 256 + y, 1024, 128 - y*2, RGB(0, 0, y*4) ) : Next y : StopDrawing() : GrabSprite(1, 0,   0, 1024, 128, #PB_Sprite_Texture) : GrabSprite(2, 0, 128, 1024, 128, #PB_Sprite_Texture) : GrabSprite(3, 0, 256, 1024, 128, #PB_Sprite_Texture)
CreateSprite3D(1, 1) : CreateSprite3D(2, 2) : CreateSprite3D(3, 3) : Repeat : ExamineKeyboard() : k ! Asc(KeyboardInkey()) : ClearScreen( RGB(0, 0, k*100) ) : Start3D() : Sprite3DBlendingMode(5, 7) : DisplaySprite3D(1, 0, 320 + 256*Sin(i.f))
DisplaySprite3D(2, 0, 320 + 256*Sin(i + 1.57)) :  DisplaySprite3D(3, 0, 320 + 256*Sin(i + 3.14)) : For y = 0 To h : For x = 0 To w : If m1(x, y)<>0 : ds(64) : EndIf : Next x : Next y : For y = 0 To h2 : For x = 0 To w2 : If m2(x, y)<>0 : ds( h*10 + 96)
EndIf : Next x : Next y : Stop3D() : i+0.075 : FlipBuffers(1) : Until KeyboardPushed(#PB_Key_Escape) : CloseScreen() : End
