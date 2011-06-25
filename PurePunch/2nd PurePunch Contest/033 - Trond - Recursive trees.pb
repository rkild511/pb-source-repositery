;*******************************************************************************
;*
;* Name   : Recursive trees
;* Author : Trond
;* Date   : 18.06.2009
;* Notes  : Opens at desktop resolution, press any key to quit, v-synced
;*
;*******************************************************************************
Define.d:Global a=0.2*#PI,t=3,c=$FFFF:InitKeyboard():InitSprite()
ExamineDesktops():w=DesktopWidth(0):h=DesktopHeight(0):OpenScreen(w, h, 32, "")
CreateSprite(0, w, h):Procedure R(X,Y,d,e,s,n):z=X+s*d:q=Y+s*e:LineXY(X,Y,z,q,c)
If n:s/t:f=Cos(a)*d+Sin(a)*e:g=-Sin(a)*d+Cos(a)*e:r(z,q,f,g,s,n+1):
f=Cos(-a)*d+Sin(-a)*e:g=-Sin(-a)*d+Cos(-a)*e:r(z,q,f,g,s,n+1):EndIf:EndProcedure
StartDrawing(SpriteOutput(0)):Box(0, 0, w, h, $281400):StopDrawing():Repeat
If Int(ct/255)&1:c+256:Else:c-256:EndIf:ct+1:StartDrawing(SpriteOutput(0))
r(w/2,h-1,0,-1,h/2.3,-8):StopDrawing():DisplaySprite(0,0,0):FlipBuffers()
ExamineKeyboard():a+0.01:t-0.001:If t<0.86:t=3:EndIf:Until KeyboardInkey()
; One line to spare
; IDE Options = PureBasic 4.31 (Windows - x86)
; Folding = -
; DisableDebugger