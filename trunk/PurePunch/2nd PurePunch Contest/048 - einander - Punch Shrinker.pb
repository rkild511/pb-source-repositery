;*****************************************************************************
;*
;* Name   :Punch Shrinker
;* Author :einander
;* Date   :june 3 - 2009
;* Notes  :Concatenate lines, strip comments and validate Pure Punch files.
;*         New file named as original + "_S.PB"
;*****************************************************************************
F.s="Punch Shrinker":OpenWindow(0,0,0,600,400,F,$1CF0000):b.s:#R=Chr(34):T.s
F=OpenFileRequester("Load file","","PB|*.pb|All|*.*",0):SP.s=Chr(32):S2.s=SP+SP
#C=Chr(58):#M=Chr(10):If ReadFile(0,F):While Eof(0)=0:A.s=Trim(ReadString(0))
While FindString(A,S2,1):A=ReplaceString(A,S2,SP):Wend:P=FindString(A,Chr(59),1)
If P:P1=FindString(A,#R,1):If P1=0 Or P<P1 Or P>FindString(A,#R,P1+1)
A=Trim(Left(A,P-1)):EndIf:EndIf:L=Len(A):If L:If L>80 Or n>10
MessageRequester("Stop at "+Str(n),T,0):End:ElseIf Len(b+A)>80:T+b:b=#M+A:n+1
ElseIf A<>#C:If b:b+#C+A:Else:b=A:EndIf:EndIf:EndIf:Wend:CloseFile(0)
If CreateFile(0,F+"_SHRINK.PB"):If b:T+b:EndIf:WriteData(0, @T, Len(T))
MessageRequester("Saved "+F+"_SHRINK.PB-"+Str(n+1)+" Lines",T,0):EndIf:EndIf:End
; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 17