;*****************************************************************************
;*
;* Name   : RayCasting 640x480
;* Author : Cpl.Bator
;* Date   : 3/06/2009
;* Notes  : Tested on linux , program quit automatically
;*
;*****************************************************************************
w=1024:x=360:px=9*w:py=11*w:st=5:he=0:tr=1:Fc=$FFFFFF:Macro rnd(v):Random(v);##
EndMacro:Macro ef:EndIf:EndMacro:Dim L(20,20):For c=0 To 11:L(C,12)=rnd(Fc);###
b=540:L(C,0)=rnd(Fc):L(12,C)=rnd(Fc):L(0,C)=rnd(Fc):L(rnd(11),rnd(11))=rnd(Fc);
Next:Dim t(b):For i=0 To b:t(i) = (Cos((i*0.0174))*w)/10:Next:InitSprite():u=91
OpenScreen(640,480,32,""):Repeat:x1=0:y1=0:x2=0:y2=0:tm+1:q=100:If t<tm:t=tm+10
he=(he+tr)%x:ef:StartDrawing(ScreenOutput()):gl=he-44%x:If gl<0:gl=gl+x:ef;####
For a=gl To gl+89:xx=px:yy=py:tx=t(a+u):ty=t(a+1):l=0:While 1:xx=xx-tx:yy=yy-ty
l=l+1:O=(xx/w)%12:Li=(yy/w)%12:If L(Li,O)!0:Break:ef:Wend:h=900/l:y1=q-h:y2=q+h
x2=x1+3:Box(x1*2,y1*2,12,h*6,L(Li,O)):x1 = x2+1:Next:StopDrawing();############
FlipBuffers(2):ClearScreen(0):Until tm>10000;##################################
; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 13
; Folding = -
; DisableDebugger