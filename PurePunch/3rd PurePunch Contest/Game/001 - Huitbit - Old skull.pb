;*****************************************************************************
;*
;* PurePunch Contest #3
;*
;* Name     : "Old skull" game
;* Author   : Huitbit
;* Category : Game
;* Date     : 12 / 07 / 09
;* Notes    : "Purepunched" with the help of  the french coder Ollivier
;*
;*****************************************************************************
Macro D:Macro:EndMacro:D K:End:End#D:Dim C(4):Dim N(4):Dim O(4):InitSprite()
D Q:EndIf:K#D:D R:Random:K#D:D F:DisplaySprite:K#D:L=640:H=480:Dim B(4):a=1
D P:Next:K#D:D S(A,B,C):For A=B To C:K#D:InitKeyboard():D U:StopDrawing():K#D
S(I,1,4):D T(A,B,C):CreateSprite(A,B,C):StartDrawing(SpriteOutput(A)):K#D:P
OpenWindowedScreen(OpenWindow(0,0,0,L,H,"Old skull !"),0,0,L,H,0,0,0):T(0,L,99)
Box(0,0,L,99,$EFCF10):U:T(1,16,16):S(J,1,8):S(I,1,8)
If Mid(RSet(Bin(Asc(Mid("|þË‰þþU",J,1))),8,"0"),I,1)="1"
Box(i*2-2,j*2-2,2,2,$FF):Q:P:P:U:T(2,16,16):Circle(8,8,8,$227CE9):U
T(3,48,H):Ellipse(24,0,24,360,$FCFBEB):U:G::s=0:x=4:y=0:w=0:C(0)=240:N(0)=R(L)
O(0)=-R(L):S(I,1,4):B(i)=B(i-1)+128+R(32):C(i)=160+R(160):N(i)=R(L):O(i)=-R(L)
P:Repeat:FlipBuffers():ClearScreen(0):S(I,0,4):If O(i)>440:N(i)=r(L):O(i)=-r(L)
C(i)+10:Q:If SpriteCollision(1,x,y,2,N(i),O(i)):N(i)=R(624):O(i)=-r(L):S+1:Q
F(2,N(i),O(i)):O(i)=O(i)+1:P:S(I,0,4):F(3,B(i),C(i)):P:F(1,x,y):F(0,0,440)
S(I,0,4):If SpriteCollision(1,x+v,y+w,3,B(i),C(i)):If y<=C(i)-15:Z=C(i)-16:Q
I=4:Else:Z=0:Q:P:If SpriteCollision(1,x,y,0,0,440):If s>m:m=s:Q
MessageRequester("","S:"+Str(s)+Chr(13)+"H:"+Str(m)):Goto G:Q:ExamineKeyboard()
If KeyboardPushed(200):If z:w=-24:a=1:Q:Q:If KeyboardPushed(203) And x>3:v=-3
ElseIf KeyboardPushed(205) And x<621:v=3:Else:v=0:Q:If z=0:If y<=424:x+v:w+a
y+w:Q:Else:x+v:y=z:Q:Delay(1):Until WindowEvent()=16
; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 18
; Folding = -
; DisableDebugger