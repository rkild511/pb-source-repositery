;*****************************************************************************
;* PurePunch Contest 
;* http://www.purebasic.fr/english/viewtopic.php?p=256341#256341
;*
;* Author : gildev
;* Date : Sat Aug 30, 2008
;* Link : http://www.purebasic.fr/english/viewtopic.php?p=257048#257048
;*
;*****************************************************************************
InitSprite():InitKeyboard():OpenScreen(640,480,32,"PB"):For i=0 To 7:CreateSprite(i,1,1):StartDrawing(SpriteOutput(i)):Plot(0,0,RGB((i+1)*24+31,(i+1)*24+31,(i+1)*24+31)):StopDrawing():Next i:CreateSprite(8,16,16):StartDrawing(SpriteOutput(8))
Box(0,0,16,16,RGB(127,127,63)):LineXY(0,0,14,0,RGB(200,200,100)):LineXY(0,1,13,1,RGB(200,200,100)):LineXY(0,0,0,14,RGB(200,200,100)):LineXY(1,0,1,13,RGB(200,200,100)):LineXY(1,15,15,15,RGB(63,63,31)):LineXY(2,14,14,14,RGB(63,63,31))
LineXY(15,1,15,15,RGB(63,63,31)):LineXY(14,2,14,15,RGB(63,63,31)):StopDrawing():Dim x.w(400):Dim y.w(400):Dim z.w(400):For i=1 To 400:x(i)=Random(639):y(i)=Random(479):z(i)=Random(7)+1:Next i:c.f=0.0174532925:Repeat:ClearScreen(0)
ExamineKeyboard():StartDrawing(ScreenOutput()):For i=0 To 97:Box(0,i*5,640,5,i*65536):Next i:StopDrawing():For i=1 To 400:DisplaySprite(z(i)-1,x(i),y(i)):If x(i)<640:x(i)=x(i)+z(i):Else:x(i)=0:y(i)=Random(479):EndIf:Next i:b=b+2:If b>=180:b=0
EndIf:Restore D:For k=0 To 3:For j=0 To 4:For i=0 To 3:Read a:If a=1:DisplaySprite(8,160+(i+5*k)*16,300+j*16+100*Sin((b+180+i)*c.f)):EndIf:Next i:Next j:Next k:FlipBuffers():Until KeyboardPushed(#PB_Key_Escape):End
DataSection:D:Data.l 1,1,1,0,1,0,0,1,1,1,1,0,1,0,0,0,1,0,0,0,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,0,1,1,0,1,1,1,0,1,0,0,1,1,1,1,0,1,0,0,1,1,0,0,1,1,1,1,1,1,0,0,0,1,1,1,0,1,0,0,0,1,1,1,1:EndDataSection
