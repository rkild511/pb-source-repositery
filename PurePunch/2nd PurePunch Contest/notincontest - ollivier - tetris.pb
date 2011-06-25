;*****************************************************************************
;*
;* Name   : Tetris
;* Author : ollivier
;* Date   : 06/11/2009
;* Notes  : -
;*
;***************************************************************************** 
Macro BL(X):For I=0 To 3:X:Next:EndMacro:Dim G(14,28):Dim G2(14,28):Dim C(1);##
Macro IT:X+PX(PC,I,Rt),Y+PY(PC,I,Rt):EndMacro:Dim PX(6,3,3):Dim PY(6,3,3);#####
Macro F(X,Y):For X=0 To Y:EndMacro:Macro N:Next:EndMacro:Macro Q:EndIf:EndMacro
F(I,28):G(1,I)=1:G(13,I)=1:G(I%13,27)=1:N:F(Pe,6):eC=0:F(Eg,1):F(PL,3);########
If Val("$"+Mid("33F06336747172",2*Pe+1+Eg,1))&(1<<PL):F(Ag,3):Y=1-PL:A=1.57*Ag;
C=Cos(A):S=Sin(A):PX(Pe,eC,Ag)=C*Eg-S*Y:PY(Pe,eC,Ag)=S*Eg+C*Y:N:eC+1:Q:N:N:N;##
Macro K0:AddKeyboardShortcut:EndMacro:OpenWindow(0,0,0,208,432,"",$CF0001);####
K0(0,37,10):K0(0,40,32):K0(0,39,12):K0(0,38,16):X=7:Y=2:D=1000:C(0)=$FFFFFF;###
C(1)=$1:Ok=1:Repeat:Delay(1):Et=WindowEvent():StartDrawing(WindowOutput(0));###
F(A,28):F(B,14):Box(B*16-16,(A-1)*16,16,16,C(G(B,A)|G2(B,A))):N:N:StopDrawing()
If Ok:BL(G2(IT)=0):MN=0:If Et=13101:MN=EventMenu():If MN=32:CH!1:Q:Q;#######
EL=ElapsedMilliseconds():If EL>T Or CH:T=EL+D:Y+1:Q:CA=0:F(I,3):If G(IT):CA=1:Q
N:If CA:Y-1:CH=0:MN=0:BL(G(IT)=1):X=7:Y=2:SC+1:If D>100:D-10:Q:DY=0;###########
For Y3=26 To 0 Step -1:CM=1:For X3=1 To 12:If G(X3,Y3)=0:CM=0:Q;###############
G(X3,Y3+DY)=G(X3,Y3):N:If CM:DY+1:Q:If Y3-DY<=0:Break:Q:N:SC+(DY*(DY+1));######
SetWindowTitle(0,Str(SC)):PC=Random(6):Rt=Random(3):Ok=1:F(I,3):If G(IT):Ok=0:Q
N:Else:BL(G2(IT)=1):Q:BL(G2(IT)=0):NS=0:If MN&8:NS=MN-11:Q:If NS:X+NS:Q:C0=0;##
F(I,3):If G(IT):C0=1:Q:N:If C0:X-NS:Q:If MN&16:Rt+1:Rt&3:Q:C3=0:F(I,3):If G(IT)
C3=1:Q:N:If C3:Rt-1:Rt&3:Q:BL(G2(IT)=1):Q:Until Et=16;#########################
; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 4
; Folding = -
; DisableDebugger