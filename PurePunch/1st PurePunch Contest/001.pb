;*****************************************************************************
;* PurePunch Contest 
;* http://www.purebasic.fr/english/viewtopic.php?p=256341#256341
;*
;* Author : Kaeru Gaman
;* Date : Sun Aug 24, 2008
;* Link : http://www.purebasic.fr/english/viewtopic.php?p=256342#256342
;*
;*****************************************************************************
Macro C: Circle:EndMacro:#pf=3.14159265/180:Procedure Flower(x.l,y.l):For i=0 To 5:C(x+12*Sin(i*60*#pf),y+12*Cos(i*60*#pf),8,RGB(128,0,48)):C(x+12*Sin(i*60*#pf),y+12*Cos(i*60*#pf),7,RGB(255,0,96)):Next
C(x,y,6,RGB(255,0,96)):C(x,y,5,RGB(255,240,32)):EndProcedure:Procedure Bee(x.l,y.l,f.l):For i=-2 To 1:C(x,y-2+4*i,6,RGB(255,240,0))
C(x,y+4*i,6,RGB(32,32,0)):Next:C(x,y+6,5,RGB(255,192,0)):C(x+3,y+5,2,RGB(64,128,255)):C(x-3,y+5,2,RGB(64,128,255)):C(x-12,y-4-f,8,RGB(240,240,255))
C(x+12,y-4-f,8,RGB(240,240,255)):EndProcedure:Procedure Fly(x.l,y.l,f.l):For i=0 To 3:C(x+f*Sin((45+i*90)*#pf),y+f*Cos((45+i*90)*#pf),7,RGB(16,160,255)):C(x+2*f*Sin((45+i*90)*#pf),y+2*f*Cos((45+i*90)*#pf),7,RGB(16,160,255))
C(x+f*Sin((45+i*90)*#pf),y+f*Cos((45+i*90)*#pf),4,RGB(255,240,32)):C(x+2*f*Sin((45+i*90)*#pf),y+2*f*Cos((45+i*90)*#pf),4,RGB(255,240,32)):Next:C(x,y-6,3,RGB(128,96,0)):Box(x-3,y-6,6,12,RGB(128,96,0)):C(x,y+6,3,RGB(128,96,0))
Line(x-1,y-9,-6,-11,RGB(16,200,255)):Line(x,y-9,5,-11,RGB(16,200,255)):C(x,y-9,3,RGB(255,96,0)):EndProcedure:If InitSprite() And InitKeyboard() And OpenScreen(800,600,16,"SV"):SetFrameRate(60)
Dim PX(600):Dim FP(4):For n=1 To 600:PX(n)=Random(799):Next:LV=4:Repeat:FX=400:FY=500:LV-1:NW=0:Repeat:ExamineKeyboard():ClearScreen(0):If KeyboardPushed(200):FY-2:EndIf:If KeyboardPushed(203):FX-2:EndIf:If KeyboardPushed(205):FX+2:EndIf:If KeyboardPushed(208)
FY+2:EndIf:StartDrawing(ScreenOutput()):DrawingMode(1):PX(0)=Random(799):For n=600 To 1 Step -1:PX(n)=PX(n-1):Box(PX(n),n-1,2,1,RGB(0,192,0)):Next:For n=0 To 4:If Abs(FP(n)-100-FX)<16 And Abs(c+150*n-50-FY)<16:FP(n)=0
SC+10:EndIf:Flower(FP(n)-100,c+150*n-50):Next:DrawText(270,10,"Bubu Butterfly's Spring Vacation"):DrawText(270,580,"Score: "+Right("000000"+Str(SC),6)+" . . . . . Lifes: "+Str(LV)):Fly(FX-DI,FY,6+3*Sin(c/8)):Bee(BX+400+100*Sin(c/20),c*4,4*Sin(c)):If Abs(BX+400+100*Sin(c/20)-(FX-DI))<24 And Abs(c*4-FY)<24:DI=10000
EndIf:c+1:If c>149:For n=4 To 1 Step -1:FP(n)=FP(n-1):Next:FP(0)=150+Random(700):BX=Random(600)-300:If DI=10000:NW=1:DI=0:EndIf:c=0:EndIf:StopDrawing():Delay(8):If KeyboardPushed(1) Or LV<0:EX=1:EndIf:FlipBuffers():Until EX=1 Or NW=1:Until EX=1:EndIf:End
