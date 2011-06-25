;*****************************************************************************
;*
;* Summer 2010 PurePunch Demo contest
;* 200 lines of 80 chars, two months delay
;*
;* Name     : tiny netPong
;* Author   : Nituvious
;* Date     : August 12th, 2010
;* Purebasic Version : 4.50
;* Notes    : Requires 2 players over a network (or two opened games on the same computer)
;* Controls = Up / Down
;* Type text to chat(around 25 character limit)
;* Change game interface color with the command: /recolor # # # (eg, type /recolor 0 100 255 and hit enter while playing)
;*
;*****************************************************************************
InitSprite():InitKeyboard():InitMouse():InitNetwork()
Enumeration:#mw:#sd:EndEnumeration
Global g,i$,z,c,v.l=-1,n,m,a$,d.l,s$,f,o,h,j=0,k,q=0,w$,e$,r$,t$,y$,cr=10,cg=255
Global cb=25,tb=ElapsedMilliseconds()+150,ta=ElapsedMilliseconds() + 50
Global ts=ElapsedMilliseconds()+10,td=ElapsedMilliseconds()+10:Structure P:ID.l
X.l:Y.l:W.l:H.l:S.l:EndStructure:Structure O:X.l:Y.l:R.l:S.l:D1.l:D2.l
EndStructure:Global *ps=AllocateMemory(26),*pr=AllocateMemory(26),Dim U.P(1)
Global Dim B.O(0):U(0)\ID=0:U(0)\X=15:U(0)\Y=245:U(0)\W=15:U(0)\H=100:U(1)\ID=0
U(1)\X=770:U(1)\Y=245:U(1)\W=15:U(1)\H=100:B(0)\X=395:B(0)\Y=245:B(0)\R=5
B(0)\S=5:B(0)\D1=1:B(0)\D2=1:OpenWindow(#mw,0,0,800,600,"netPong",1|13107200)
OpenWindowedScreen(WindowID(#mw),0,0,800,600,1,0,0)
Procedure D():If g=4:StartDrawing(ScreenOutput()):DrawingMode(1)
DrawText(365,115,Str(U(0)\S),RGB(cr,cg,cb)):Box(5,5,790,110,RGB(cr,cg,cb))
DrawText(415,115,Str(U(1)\S),RGB(cr,cg,cb)):Box(6,6,788,89,RGB(0,0,0))
Box(6,96,788,18,RGB(0,0,0)):DrawText(10,71,y$):DrawText(10,11,w$)
DrawText(10,26,e$):DrawText(10,41,r$):DrawText(10,56,t$)
DrawText(10,97,"> "+i$,RGB(200,200,255)):Box(5,130,791,465,RGB(cr,cg,cb))
Box(6,131,789,463,RGB(0,0,0)):Box(U(0)\X,U(0)\Y,U(0)\W,U(0)\H,RGB(cr,cg,cb))
Box(U(1)\X,U(1)\Y,U(1)\W,U(1)\H,RGB(cr,cg,cb))
Circle(B(0)\X,B(0)\Y,B(0)\R,RGB(cr,cg,cb)):If v=0:B(0)\X+B(0)\D1:B(0)\Y+B(0)\D2
If B(0)\X>=789:B(0)\D1=-B(0)\S:U(0)\S+1:EndIf:If B(0)\X<=11:B(0)\D1=B(0)\S
U(1)\S+1:EndIf:If B(0)\Y>=588:B(0)\D2=-B(0)\S:EndIf:If B(0)\Y<136:B(0)\D2=B(0)\S
EndIf:Macro a_:((B(0)\X+B(0)\R>=U(0)\X) And (B(0)\Y+B(0)\R>=U(0)\Y)):EndMacro
Macro s_:((B(0)\X-B(0)\R<=U(0)\W+U(0)\X) And (B(0)\Y-B(0)\R<=U(0)\H+U(0)\Y))
EndMacro:Macro d_:((B(0)\X+B(0)\R>=U(1)\X) And (B(0)\Y+B(0)\R>=U(1)\Y))
EndMacro:Macro f_:
((B(0)\X-B(0)\R<=U(1)\W+U(1)\X) And (B(0)\Y-B(0)\R<=U(1)\H+U(1)\Y)):EndMacro
If a_ And s_:B(0)\D1=B(0)\S:EndIf:If d_ And f_:B(0)\D1=-B(0)\S:EndIf:EndIf
StopDrawing():EndIf:EndProcedure:Procedure M():If g=0:ExamineMouse()
ms$="PurePunch netPong game":md$="PurePunch 2010"
StartDrawing(ScreenOutput()):RoundBox(50,75,100,25,5,10,RGB(120,175,60))
RoundBox(55,105,100,25,5,10,RGB(120,175,60)):DrawingMode(1)
FrontColor(RGB(255,255,255)):DrawText(75,80,"Join"):DrawText(80,110,"Host")
If MouseX()>=50 And MouseX()<=150 And MouseY()>=75 And MouseY()<=100
FrontColor(RGB(255,0,0)):DrawText(75,80,"Join"):If MouseButton(1):g=1:EndIf:
EndIf:If MouseX()>=55 And MouseX()<=155 And MouseY()>=105 And MouseY()<=135
FrontColor(RGB(255,0,0)):DrawText(80,110,"Host"):If MouseButton(1):g=2:EndIf
EndIf:Circle(MouseX(),MouseY(),2,RGB(0,255,100)):If td<ElapsedMilliseconds():c+2
td=ElapsedMilliseconds()+10:EndIf:If c>800:c=-600:EndIf
DrawText(c,565,ms$,RGB(0,100,255)):DrawText(c+35,580,md$,RGB(0,100,255))
StopDrawing():EndIf:If g=1:ExamineMouse():ExamineKeyboard()
StartDrawing(ScreenOutput()):DrawText(0,0,"Server: "+i$,RGB(0,100,255))
DrawText(0,20,"IP: "+a$+" Port: "+Str(d),RGB(0,100,255)):i$+KeyboardInkey()
If KeyboardPushed(14):If tb < ElapsedMilliseconds():i$ = Left(i$,Len(i$)-1)
tb=ElapsedMilliseconds()+150:EndIf:EndIf:If KeyboardReleased(28)
locPort=FindString(i$,":",0):If locPort<>0:s$=Mid(i$,locPort+1)
a$=Mid(i$,0,Len(i$)-Len(s$)-1):d=Val(s$):n=OpenNetworkConnection(a$,d,2)
PokeS(*ps,"challenge"):SendNetworkData(n,*ps,26)
waitAcknowledge::m=NetworkClientEvent(n):If m:Select m:Case 2
rcv=ReceiveNetworkData(n,*pr,26)
If rcv<>0:If PeekS(*pr)="acknowledge":v=1:g=4:EndIf:EndIf:EndSelect:Else:z+1
Delay(10):If z>100:z=0:g=0:Else:Goto waitAcknowledge:EndIf:EndIf:EndIf:i$=""
EndIf:Circle(MouseX(),MouseY(),2,RGB(0,255,100)):StopDrawing():EndIf:If g=2
ExamineMouse():ExamineKeyboard():StartDrawing(ScreenOutput())
DrawText(0,0,"Port: "+i$,RGB(0,100,255)):DrawText(0,20,"Port: "+Str(d),$0009FF)
i$+KeyboardInkey():If KeyboardPushed(14):If tb<ElapsedMilliseconds()
i$=Left(i$,Len(i$)-1):tb = ElapsedMilliseconds() + 150:EndIf:EndIf
If KeyboardReleased(28):d=Val(i$):If d<>0:If CreateNetworkServer(#sd,d,2):v=0
EndIf:EndIf:i$="":EndIf:Circle(MouseX(),MouseY(),2,RGB(0,255,100)):StopDrawing()
EndIf:EndProcedure:Procedure E(*xd):Delay(1):If ExamineKeyboard()
If KeyboardPushed(1):CloseScreen():End:EndIf:If g=4:i$+KeyboardInkey()
If KeyboardPushed(14):If tb<ElapsedMilliseconds():i$=Left(i$,Len(i$)-1)
tb=ElapsedMilliseconds()+150:EndIf:EndIf:If KeyboardReleased(28)
If FindString(UCase(i$),UCase("/recolor "),0):cr=Val(StringField(i$, 2, " "))
cg=Val(StringField(i$, 3, " ")):cb=Val(StringField(i$, 4, " ")):i$="":EndIf
If (Len(i$)<25) And (Len(i$)<>0):k=1:EndIf:EndIf:If KeyboardPushed(200)
If U(v)\Y>=138:If v=0:U(0)\Y-2:EndIf:If v=1:PokeS(*ps,"p2up"):j=1:EndIf:EndIf
EndIf:If KeyboardPushed(208):If U(v)\Y<=488:If v=0:U(0)\Y+2:EndIf:If v=1
PokeS(*ps,"p2down"):j=1:EndIf:EndIf:EndIf:EndIf:EndIf:EndProcedure
Procedure NR(*xa):Delay(1):If v=0:f=NetworkServerEvent():If f:o=EventClient()
Select f:Case 2:recvLenS=ReceiveNetworkData(o,*pr,26):If recvLenS <> 0
If PeekS(*pr)="challenge":U(1)\ID=o:PokeS(*ps,"acknowledge")
SendNetworkData(U(1)\ID,*ps,26):Delay(100):PokeS(*pr,""):g=4:EndIf
If PeekS(*pr)="p2up":U(1)\Y-2:EndIf:If PeekS(*pr)="p2down":U(1)\Y+2:EndIf
If PeekS(*pr)="msg":q+1:If q=1:w$="Player2: "+PeekS(*pr+4)
ElseIf q=2:e$="Player2: "+PeekS(*pr+4):ElseIf q=3:r$="Player2: "+PeekS(*pr+4)
ElseIf q=4:t$="Player2: "+PeekS(*pr+4):ElseIf q=5:y$="Player2: "+PeekS(*pr+4)
q=0:EndIf:PokeS(*pr,"",1):EndIf:EndIf:EndSelect:EndIf:EndIf:If v=1
h=NetworkClientEvent(n):If h:Select h:Case 2:rcv=ReceiveNetworkData(n,*pr,26)
If rcv<>0:If PeekS(*pr)="sv":U(0)\Y=PeekL(*pr+4):U(1)\Y=PeekL(*pr+8)
B(0)\X=PeekL(*pr+12):B(0)\Y=PeekL(*pr+16):U(0)\S=PeekL(*pr+20)
U(1)\S=PeekL(*pr+24):EndIf:If PeekS(*pr)="msg":q+1:If q=1
w$="Player1: "+PeekS(*pr+4):ElseIf q=2:e$="Player1: "+PeekS(*pr+4):ElseIf q=3
r$="Player1: "+PeekS(*pr+4):ElseIf q=4:t$="Player1: "+PeekS(*pr+4):ElseIf q=5
y$="Player1: "+PeekS(*pr+4):q=0:EndIf:PokeS(*pr,"",1):EndIf:EndIf:EndSelect
EndIf:EndIf:EndProcedure:Procedure NS(*xb):Delay(1):If v=0:If g=4
If ta<ElapsedMilliseconds():If k=0:PokeS(*ps,"sv"):PokeL(*ps+4,U(0)\Y)
PokeL(*ps+8,U(1)\Y):PokeL(*ps+12,B(0)\X):PokeL(*ps+16,B(0)\Y)
PokeL(*ps+20,U(0)\S):PokeL(*ps+24,U(1)\S):SendNetworkData(U(1)\ID,*ps,26)
ta=ElapsedMilliseconds()+50:ElseIf k=1:PokeS(*ps,"msg"):PokeS(*ps+4,i$)
SendNetworkData(U(1)\ID,*ps,26):PokeS(*ps,"",1):i$="":k=0:EndIf:EndIf:EndIf
EndIf:If v=1:If g=4:If k=0:If j=1:If ts<ElapsedMilliseconds()
SendNetworkData(n,*ps,26):PokeS(*ps,""):ts=ElapsedMilliseconds()+10:j=0:EndIf
EndIf:ElseIf k=1:PokeS(*ps,"msg"):PokeS(*ps+4,i$):SendNetworkData(n,*ps,26)
PokeS(*ps,"",1):i$="":k=0:EndIf:EndIf:EndIf:EndProcedure
Repeat:Delay(1):WaitWindowEvent(10):FlipBuffers():ClearScreen(RGB(0,0,0))
CreateThread(@NR(),0):CreateThread(@NS(),0):M():CreateThread(@E(),0):D():ForEver
; IDE Options = PureBasic 4.51 RC 1 (Windows - x86)
; CursorPosition = 5
; Folding = --