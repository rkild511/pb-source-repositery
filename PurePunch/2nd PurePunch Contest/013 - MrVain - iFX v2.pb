;*****************************************************************************
;*
;* Name   : iFX v2 - Simple tool to adjust RGB channel-values of an image (Win32)
;* Author : Thorsten Will - aka 'Mr.Vain of Secretly!'
;* Date   : 28.06.2009
;* Notes  : Entry for the PurePunch Contest #2
;*          The rule is to code something in max 10 lines, each row max 80 chars!
;*          This time i tried to code a simple graphic tool for this contest! 
;*          Win32 API has been used - so it works on Windows only - Sorry!.
;*
;*          F I X E D   v 2 :
;*          ~~~~~~~~~~~~~~~~~
;*          + Should work now with all BMP and JPG images (8,16,24,32 bit)
;*          + Does not crash when moving slider before loaded an image.
;*          + Fixed problem when loading a new image and aborted the requester.
;*          - On 24 bit images the BLUE channel adjustment dont work atm! But
;*            i will try to find the bug and fix it if possible. Any idea? ^^
;*
;*          P L E A S E   D I S A B L E   T H E   D E B U G G E R  !!!
;*
;*****************************************************************************
w=800:Macro m(t,d):Macro t:d:EndMacr:EndMacro:m(C,Gadget)o:m(L,For i=0 To 2)o
OpenWindow(0,0,0,w,400,"iFX v2",$C80001):z=13100:w=600:n=255:Dim c(3):x=m.BITMAP
UseJPEGImageDecoder():t$="Load":L:TrackBar#C(i,w+120-(i*30),95,20,n,1,n,2):Next
Button#C(3,w+50,40,100,20,t$):Repeat:e=WindowEvent():If e=z:t=Event#C():If t=3
f$=OpenFileRequester("Load Img","","",0):m(P,etGadgetState)o:Dim R(3):If f$<>""
If LoadImage(0,f$):v=ResizeImage(0,w,400,1):Image#C(5,0,0,w,w,v):EndIf:a=1:EndIf
ElseIf a:L:c(i)=G#P(i):Next:d=CopyImage(0,1):GetObject_(d,SizeOf(BITMAP),x)
*p.point=m\bmBits:f=m\bmBitsPixel/8:s=*p+$3A980*f-r:Repeat:c=*p\x:j=0:L:o=(i<<3)
R(i)=c>>o&n:u.f=(R(i)/n)*c(i):R(i)=u:q=i<<3:j+(R(i)<<q):Next:*p\x=j:*p+f
Until *p>s:S#P(5,d):EndIf:EndIf:Until e=16:End

; IDE Options = PureBasic 4.31 (Windows - x86)
; Folding = -
; DisableDebugger