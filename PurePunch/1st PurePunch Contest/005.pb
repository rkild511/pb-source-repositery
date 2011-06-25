;*****************************************************************************
;* PurePunch Contest 
;* http://www.purebasic.fr/english/viewtopic.php?p=256341#256341
;*
;* Author : HeX0R
;* Date : Tue Aug 26, 2008
;* Link : http://www.purebasic.fr/english/viewtopic.php?p=256614#256614
;*
;*****************************************************************************
InitSprite():InitMouse():InitKeyboard():OpenWindowedScreen(OpenWindow(0,0,0,800,600,""),0,0,800,600,0,0,0):CreateSprite(0,128,24):StartDrawing(SpriteOutput(0)):For i=0 To 127:LineXY(i,0,i,23,$FFFFFF-(i<<16)):Next:StopDrawing():m=$FFFFFF
For j=1 To 3:CreateSprite(j,64,32):StartDrawing(SpriteOutput(j)):For i=0 To 63:LineXY(i,0,i,31,(255-i*3)<<((j-1)*8)):Next:StopDrawing():Next:CreateSprite(4,32,32):StartDrawing(SpriteOutput(4)):For i=0 To 15:Circle(16,16,16-i,$BB-i*6):Next
StopDrawing():Dim S.l(8,5):While 1:For i=0 To 8:For j=0 To 5:S(i,j)=Random(2)+1:Next:Next:x=300:y=500:a=300:b=550:w.f=Random(100)+50:f=4*Sin(w/64):g=4*Cos(w/64):h=3:p.f=4:u=0:While 1:   While 1:Select WindowEvent():Case 16:End:Case 0:Delay(2)
Break:EndSelect:Wend:ExamineKeyboard():If KeyboardPushed(1):End:ElseIf KeyboardPushed(203):a-5:If a<0:a=0:EndIf:ElseIf KeyboardPushed(205):a+5:If a>671:a=671:EndIf:ElseIf h=0 And KeyboardReleased(59):Break:EndIf:ClearScreen(0):c=1
For i=0 To 8:For j=0 To 5:If S(i,j):r=100+i*65:s=50+j*33:If c And SpriteCollision(S(i,j),r,s,4,x,y):If x<r+2 Or x>r+62:g=-g:Else:f=-f:EndIf:u+S(i,j):S(i,j)=0:c=0:p+0.2:Else:DisplaySprite(S(i,j),r,s):EndIf:EndIf:Next:Next
DisplayTransparentSprite(4,x,y):DisplaySprite(0,a,b):StartDrawing(ScreenOutput()):DrawText(65,11,"1 Point",m,0):DrawText(186,11,"2 Points",m,0):DrawText(306,11,"3 Points",m,0):If h:DrawText(500,11,"Points: "+Str(u)+" Lives: "+Str(h),m,0):Else
DrawText(500,11,"Game over! Points:"+Str(u)+" Press F1 to restart",m,0):EndIf:StopDrawing():DisplaySprite(1,0,5):DisplaySprite(2,120,5):DisplaySprite(3,240,5):FlipBuffers():If h:y-f:x+g:If y+32>=b:If x+16>a And x-112<a:w=(64-x+a)+100
f=p*Sin(w/64):g=p*Cos(w/64):Else:h-1:w=Random(100)+50:x=a+60:f=p*Sin(w/64):g=p*Cos(w/64):EndIf:ElseIf x>=768 Or x<=0:g=-g:ElseIf y<=0:f=-f:EndIf:EndIf:Wend:Wend
