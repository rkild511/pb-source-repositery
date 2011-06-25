;*****************************************************************************
;*
;* Name   : Pure Punch Expander
;* Author : einander
;* Date   : june 3 - 2009
;* Notes  : Complementary for Pure Punch Shrinker
;*          Replace double quotes for Line feeds
;*
;*****************************************************************************
#C=Chr(58):#L=Chr(10):OpenWindow(0,0,0,600,400,"PB Line Shrinker",$1CF0000)
F.s= OpenFileRequester("Load PB file","","PB|*.pb|All(*.*)|*.*",0)
If ReadFile(0,F):While Eof(0) = 0:A$=Trim(ReadString(0))
P=FindString(A$,Chr(59),1):If P:P1=FindString(A$,Chr(34),1)
If P1=0 Or P<P1 Or P>FindString(A$,Chr(34),P1+1):A$=Trim(Left(A$,P-1)):EndIf
EndIf:L=Len(A$):If L>80 Or n>9:MessageRequester("Stop at "+Str(n+1),T$+B$,0)
End:ElseIf Len(B$+A$)>79:T$+B$:B$=#L+A$:n+1:ElseIf L And A$<>#C:If B$:B$+#C+A$
Else:B$=A$:EndIf:EndIf:Wend:CloseFile(0):If CreateFile(0,F+"_SHRINKED.PB" )
T$+B$:WriteData(0, @T$, Len(T$)):CloseFile(0)
MessageRequester("File OK: Saved "+Str(n+1)+" Lines",T$,0):EndIf:EndIf:End


; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 19