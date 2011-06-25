;*****************************************************************************
;*
;* Name   :Fractale
;* Author : Z@ph0d
;* Date   : 07/06/09
;* Notes  :
;*
;*****************************************************************************

Procedure f(x.f,y.f,l.f,a.f)
 Protected ll.f, aa.f, l4.f , s.f, c.f
If l>1:f(x,y,l/4,a):aa=a:l4=l/4:s=Sin(a):c=Cos(a):x+s*l4:y+c*l4:a-#PI/2
f(x,y,l4,a):x+Sin(a)*l4:y+Cos(a)*l4:a+#PI/2+#PI/4:ll=l/2*Sqr(2)
f(x,y,ll,a):x+Sin(a)*ll:y+Cos(a)*ll
f(x,y,l4,a-#PI/1.33):f(x + Sin(a-#PI/1.33)*l4,y+Cos(a-#PI/1.33)*l4,l4,aa)
Else:StartDrawing(WindowOutput(0)):Plot(x,y,#Blue):StopDrawing():EndIf
EndProcedure
If OpenWindow(0,10,10,800,500,"Fractale",13107200|1|12582912)
f(10,250,750,#PI/2):Repeat:EventID=WaitWindowEvent():Until EventID=16:EndIf

; IDE Options = PureBasic 4.31 (Windows - x86)
; Folding = -
; DisableDebugger