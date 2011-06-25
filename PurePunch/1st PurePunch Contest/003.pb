;*****************************************************************************
;* PurePunch Contest 
;* http://www.purebasic.fr/english/viewtopic.php?p=256341#256341
;*
;* Author : idle
;* Date : Aug 26, 2008
;* Link : http://www.purebasic.fr/english/viewtopic.php?p=256518#256518
;*
;*****************************************************************************
#o=#PB_Compiler_OS:#w=#PB_OS_Windows:Structure ADt:X.l:Y.l:dx.l:dy.l:sr.S:c.l:EndStructure:Structure vec:X.l:Y.l:EndStructure:Global fps,ct,lt,ND,Xp,Yp,ZX.f=0,ZY.f=20,ZZ.f=22,DT.f=0.01,SN.f=5,SG.f=2.5,MS.f=1.32,GT.f=25,RR.f=15,SV.f=0.1,SA.f=0.1,DS.f=40
Global BE.f=1.25,i1,i2,Dim AD.ADt(1):If OpenWindow(0,0,0,800,600,"idle time",13565953):SetWindowColor(0,RGB(0,0,0)):CompilerIf#o=#w:ShowCursor_(0):CompilerEndIf:LoadFont(1,"Arial",24):i1=CreateImage(#PB_Any,800,600):i2=CreateImage(#PB_Any,800,600)
s.s="PB IDLE TIME":nD=Len(s):ReDim AD.ADt(nD+1):For i=0 To nD:AD(i)\X=400:AD(i)\Y=300:AD(i)\sr=Mid(s,i,1):AD(i)\c=RGB(255,255,255):Next:AD(0)\X=AD(1)\X:AD(0)\Y=AD(1)\Y-SN:CompilerIf#o=#w:SetCursorPos_(400+WindowX(0),300+WindowY(0)):CompilerEndIf
Repeat:EID=WindowEvent():Xp=WindowMouseX(0)-800/2:Yp=WindowMouseY(0)-600/2:ZX+(0.015*(-10*ZX+10*ZY)):ZY+(0.015*(28*ZX-ZY-ZX*ZZ)):ZZ+(0.015*(-8*ZZ/3+ZX*ZY)):x=(ZX*10)+400+Xp:y=(ZZ*10)+50+Yp:If StartDrawing(ImageOutput(i2))
Circle(x,y,ZZ,RGB(Random(255),Random(255),Random(255))):StopDrawing():EndIf:AD(0)\X=WindowMouseX(0):AD(0)\Y=WindowMouseY(0):For i=1 To nD:sp.vec:sp\x=0:sp\y=0:dx=AD(i-1)\X-AD(i)\X:dy=AD(i-1)\Y-AD(i)\Y:len.f=Sqr(dx*dx+dy*dy):If len>SN:t.f=SG*(len-SN)
sp\X+(dx/len)*t:sp\Y+(dy/len)*t:EndIf:rt.vec:rt\x=-AD(i)\dx*RR:rt\y=-AD(i)\dy*RR:ac.vec:ac\x=(sp\X+rt\X)/MS:ac\y=(sp\Y+rt\Y)/MS+GT:AD(i)\dx+(DT*ac\X):AD(i)\dy+(DT*ac\Y):If Abs(AD(i)\dx)<SV And Abs(AD(i)\dy)<SV And Abs(ac\X)<SA And Abs(ac\Y)<SA:AD(i)\dx=0
AD(i)\dy=0:EndIf:AD(i)\X+AD(i)\dx:AD(i)\Y+AD(i)\dy:If AD(i)\Y>=600-DS-1:If AD(i)\dy>0:AD(i)\dy=BE*-AD(i)\dy:EndIf:AD(i)\Y=600-DS-1:EndIf:If AD(i)\X>=800-DS:If AD(i)\dx>0:AD(i)\dx=BE*-AD(i)\dx:EndIf:AD(i)\X=800-DS-1:EndIf:If AD(i)\X<0:If AD(i)\dx < 0
AD(i)\dx=BE*-AD(i)\dx:EndIf:AD(i)\X=0:EndIf:If StartDrawing(ImageOutput(i1)):DrawingMode(1):DrawingFont(FontID(1)):DrawText(AD(i)\X,AD(i)\Y,AD(i)\Sr,AD(i)\c):StopDrawing():EndIf:Next:StartDrawing(ImageOutput(i1)):DrawingMode(2)
DrawImage(ImageID(i2),0,0,800,600):StopDrawing():StartDrawing(WindowOutput(0)):DrawImage(ImageID(i1),0,0,800,600):StopDrawing():FreeImage(i1):i1=CreateImage(#PB_Any,800,600):ct+1:If ElapsedMilliseconds()>lt:fps=ct:ct=0:lt=ElapsedMilliseconds()+1000:EndIf
CompilerIf#o=#w:If WindowMouseY(0) < 50:ShowCursor_(1):Else:ShowCursor_(0):EndIf:CompilerEndIf:SetWindowTitle(0,"Idle time (kinetic spring & lorenz strange attractor doodler) fps=" + Str(fps)):Delay(0):Until EID=16 Or GetAsyncKeyState_(#VK_ESCAPE):EndIf
