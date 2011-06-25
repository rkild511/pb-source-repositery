;*****************************************************************************
;* PurePunch Contest 
;* http://www.purebasic.fr/english/viewtopic.php?p=256341#256341
;*
;* Author : gildev
;* Date : Sat Aug 30, 2008
;* Link : http://www.purebasic.fr/english/viewtopic.php?p=257048#257048
;*
;*****************************************************************************
InitSprite():InitKeyboard():OpenScreen(640,480,32,"PB"):x=640:t$="PUREBASIC IS THE BEST PROGRAMING LANGUAGE IN THE WORLD!!!":LoadFont(1,"Arial",24):c.f=0.0174532925:xo=320:yo=260:Repeat:FlipBuffers():ClearScreen(RGB(0,0,0)):ExamineKeyboard()
StartDrawing(ScreenOutput()):For i=0 To 24:LineXY(0,i,639,i,RGB(0,120-i*5,0)):Next i:DrawingMode(#PB_2DDrawing_Transparent):DrawingFont(FontID(1)):DrawText(x,-6,t$,RGB(255,255,191)):DrawText(x-1,-5,t$,RGB(255,255,191))
DrawText(x+1,-5,t$,RGB(63,63,31)):DrawText(x,-4,t$,RGB(63,63,31)):DrawText(x,-5,t$,RGB(191,191,127)):a=0-TextWidth(t$):For i=0 To 63:LineXY(0,yo-i,639,yo-i,RGB(0,64-i,0)):LineXY(0,yo+i,639,yo+i,RGB(0,64-i,0)):Next i:For j=0 To 40
If j=40:FrontColor(RGB(255,63,0)):Else:FrontColor(RGB(j*5+10,0,0)):EndIf:Restore DS:x1=-30:y1=-100:For i=1 To 16:Read x2:Read y2:LineXY(xo+x1*Cos((b+j)*c.f),yo+y1*Sin((b+j)*c.f),xo+x2*Cos((b+j)*c.f),yo+y2*Sin((b+j)*c.f)):x1=x2:y1=y2:Next i
Next j:b=b+1:If b>=360:b=0:EndIf:StopDrawing():If x>a:x=x-2:Else:x=640:EndIf:For i=0 To 25:GrabSprite(i+1,0,i,640,1,#PB_Sprite_Memory):Next i:For i=0 To 25:DisplayTranslucentSprite(i+1,0,48-i,i*5):Next i:
Until KeyboardPushed(#PB_Key_Escape):End:DataSection:DS:Data.l 10,-140,150,-140,30,-20,90,-20,50,20,-10,20,-90,100,150,100,110,140,-150,140,-30,20,-90,20,-50,-20,10,-20,90,-100,-30,-100:EndDataSection
