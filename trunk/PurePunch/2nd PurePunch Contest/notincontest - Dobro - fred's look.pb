;*****************************************************************************
;*
;* Name   : Fred's look
;* Author : dobro
;* Date   : 06/20/2009
;* Notes  : -
;*
;***************************************************************************** 
Macro M:Macro:EndMacro: M ed:EndIf:End#m:M ds:DisplayTransparent:End#m
M sp:sprite:End#m:M w:window:End#m:M O:output:End#m:M dw:drawing:End#m
M Q:circle:End#m:M ows:OpenWindowedScreen:End#m::Init#sp():EX =1024:z=10:
p=65535:Open#W(1,0,0,100,50,"Fred",$C80000):Resize#W(1,EX-360,0,-p,-p):
OWS(WindowID(1),0,0,100,50,1,0,0):Create#sp(1,20, 20):Create#sp(2,20, 20):
Start#dw(sprite#O(1)):Q(z,z,z,z):Stop#dw():Start#dw(sprite#O(2)):Q(z,z,z,z):
Stop#dw():A1=15:B1=15:A2=115:B2=15:Repeat:EV=WindowEvent():Start#dw(Screen#O())
Q(25,25,20,$FFC800):Q(75,25,20,$FFC800 ):Stop#dw():ds#Sp(1,A1,B1):ds#Sp(2,A2,B2):
GetCursorPos_(c.POINT):mx=c\x:my=c\Y:xn=WindowX(1):yn=WindowY(1):A1=mx-xn-11:
A2=mx-xn-11:B1=my-yn-25:B2=my-yn-25:If A1<5:A1=5:ed:If A1>25:A1=25:ed:If A2<55:
A2=55:ed:If A2>75:A2=75:ed:If B1<5:B1=5:ed:If B1>25:B1=25:ed:If B2<5:B2=5:ed:
If B2>25:B2=25:ed:FlipBuffers():Until EV=16

; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 12
; Folding = -
; DisableDebugger