;*****************************************************************************
;*
;* PurePunch Contest #4
;*
;* Name     :  Snake
;* Author   :  Martin Guttmann (STARGÅTE)
;* Category :  Game
;* Date     :  9/15/2009
;* Notes    :  The famous Snake game in 20 lines. 
;*             Navigation With arrow keys. 
;*             Objective: To feed the orange squares,
;*                        While Not push against walls Or yourself. 
;*             Special feature: The snake drop sam walls.
;*
;*****************************************************************************
;
InitSprite():InitKeyboard():Macro Q(v,w):(v\x=w\x And v\y=w\y):EndMacro: a.Point
Macro EM:ElapsedMilliseconds():EndMacro:Macro LS:ListSize(S()):EndMacro:#b=#Gray
Macro B(x,y,C,u=1):Box(x*25+u,y*25+u,25-u*2,25-u*2,C):EndMacro:NewList G.Point()
OpenWindowedScreen(OpenWindow(0,0,0,800,600,"Snake",13107201),0,0,800,800,0,0,0)
Macro K(k,v,w):If KeyboardPushed(k):a\x=v:a\y=w:EndIf:EndMacro:NewList S.Point()
A:Delay(dt):Gosub Z:ClearList(S()):j.Point\x=10:j\y=9:a\x=1:a\y=0 : For i=5 To 9
AddElement(S()):S()\x=i:S()\y=9:Next : *S.Point=@S() : Repeat :ExamineKeyboard()
K(200,0,-1):K(208,0,1):K(203,-1,0):K(205,1,0) : If Em-T>200-ListSize(S()) : T=EM
AddElement(S()):S()\x=*S\x+a\x:S()\y=*S\y+a\y:*S=@S():If Q(j,S()): Repeat : OK=1
j\x=Random(29)+1:j\y=Random(20)+2:ForEach S():If Q(S(),j):OK=0:Break:EndIf: Next
ForEach G():If Q(G(),j):OK=0:Break:EndIf:Next:Until OK : Else: FirstElement(S())
If LS > ListSize(G())*5+10 : AddElement(G()) : G()\x=S()\x : G()\y=S()\y : EndIf
DeleteElement(S()):EndIf:ForEach S():ForEach G():If Q(S(),G()):Goto A:EndIf:Next
If (@S()<>*S And Q(S(),*S)) Or (*S\x<1 Or *S\y<2 Or *S\x>30 Or *S\y>22) : Goto A
EndIf:Next:EndIf: ClearScreen(0) : StartDrawing(ScreenOutput()) : DrawingMode(1)
For i = 0 To 32 : B(0,i,#b):B(31,i,#b):B(i,1,#b):B(i,23,#b) : Next : ForEach S()
LI = ListIndex(S()) : B(S()\x,S()\y,RGB(0,128-Sin(LI)*64,191-Sin(LI)*64)) : Next
B(J\x,j\y,$00A0F0):ForEach G():B(G()\x,G()\y,#b): Next : Text$="Length:"+Str(LS)
DrawText(100,5,Text$+" Speed:"+StrF(1000/(200-LS),3)+"Hz",#White): StopDrawing()
FlipBuffers():Until WindowEvent()=16:End: Z: ClearList(G()):T=EM:dt=1500: Return
; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 10
; Folding = -