;*****************************************************************************
;*
;* Name   : iFX - Simple tool to adjust RGB channel-values of an image (Win32)
;* Author : Thorsten Will - aka 'Mr.Vain of Secretly!'
;* Date   : 28.06.2009
;* Notes  : Entry for the PurePunch Contest #2
;*          The rule is to code something in max 10 lines, each row max 80 chars!
;*          This time i tried to code a simple graphic tool for this contest! 
;*          Win32 API has been used - so it works on Windows only - Sorry!.
;*
;*          I M P O R T A N T :
;*          ~~~~~~~~~~~~~~~~~~~
;*          Please load ONLY BITMAP (*.bmp) IMAGES in 32Bit format, else
;*          this application does not works or may crash, because their was
;*          not enough space for error-handling nor supporting 24 bit bitmaps!
;*
;*          P L E A S E   D I S A B L E   T H E   D E B U G G E R  !!!
;*
;*****************************************************************************
MessageBox_(0,"Entry by Thorsten Will aka va!n '2009","PureContest #2 - iFX",64)
w=800:Macro m(t,d):Macro t:d:EndMacr:EndMacro:m(C,Gadget)o:m(L,For i=0 To 2)o
OpenWindow(0,0,0,w,400,"iFX",$C80001):h=600:z=13100:w=600:n=255:Dim c(3):z=13100
UseJPEGImageDecoder():t$="Load":L:TrackBar#C(i,w+120-(i*30),95,20,n,1,n,2):Next
Button#C(3,w+50,40,100,20,t$):Repeat:e=WindowEvent():If e=z:t=Event#C():If t=3
f$=OpenFileRequester("BMP Image","","",0):m(P,etGadgetState)o:If LoadImage(0,f$)
v=ResizeImage(0,h,400,1):Image#C(5,0,0,h,w,v):EndIf:Else:L:c(i)=G#P(i):Dim R(3)
Next:d=CopyImage(0,1):GetObject_(d,SizeOf(BITMAP),m.BITMAP):*p.point=m\bmBits
s=*p+$EA5FC:Repeat:c=*p\x:j=0:L:R(i)=c>>(i*8)&n:u.f=(R(i)/n)*c(i):R(i)=u:q=i<<3
j+(R(i)<<q):Next:*p\x=j:*p+4:Until *p>s:S#P(5,d):EndIf:EndIf:Until e=16:End

; IDE Options = PureBasic 4.31 (Windows - x86)
; Folding = -
; DisableDebugger