;*****************************************************************************
;*
;* Summer 2010 PurePunch Demo contest
;* 200 lines of 80 chars, two months delay
;*
;* Name     : IdleArts Re-Nova Attractor Media Player) v1.3  
;* Author   : Idle
;* Date     : 28/7/10 
;* Purebasic  Version :4.50 
;*
;* Notes    : Windows only 
;*            
;*            Compile ThreadSafe 
;*            Set Recording source to "Wave out" or "Stereo Mix" (vista/windows7 you may need to dig around to enable it)  
;*
;             Drag And drop Folder With Mp3 Or Wma To Queue music 
;*                          
;*            Left Click on screen to pop up the Nova Controls 
;*            Right Click to Toggle Full Screen mode
;*            Space bar for random nova
;*            
;*            Retro led Panel visual
;*            visualize=on, blend=off, mode=6, size=Right, zoom=Right, gain=move up from left till screen fills   
;*
;*            Nova Attractor algorthim Copyright Andrew Ferguson 2009
;*****************************************************************************
Procedure ATS(v):Static ltm,pt.point:While 1:mouse_event_(1,1,0,0,0)
Delay(100):mouse_event_(1,-1,0,0,0):Delay(60000):Wend:EndProcedure 
Structure con:hWindow.i:size.i:buffer.i:wave.i:fm.WAVEFORMATEX:lBuf.i               
nBuf.i:nDev.i:nBit.i:nHertz.i:nChannel.i:EndStructure:Global con.con
Global Dim inHdr.WAVEHDR(16):Global mxv,akn:Global Dim rex.f(1025)
Global Dim imx.f(1025):Global Dim FFTOUT.f(2,1025):Global FFTWnd
Global FMUT = CreateMutex():con\fm\wFormatTag = #WAVE_FORMAT_PCM
Structure window:style.i:left.i:top.i:width.i:height.i:window.i:fg.i
title.s:EndStructure:Structure star:speed.f:x.f:y.f:EndStructure 
Global Dim stars.Star(3000):Global gr.f=1.0,gg.f=0.6,gb.f=0.2,ss=32,gRedo,aaa
Global gbl,gain.f=1.0,gvis,gReset,vGain.f=0.0021,fwd,fhd,scx,scy,mode,bbb,ccc
Global Width,Height,bFsc,Thread,Screen,wnd.window,WID,hwnd,screen,ddd,msf=64
Global fg,cflags,cWin,Controlthread,controlLoop,cflags=13107202,gsf.f=1.0
Global NewList que.s(),ts1,splay,spu,lbk,gPlay=1
Global bcl,bpause,sg,sg3,nx,gwidth,WID:Procedure.s dirlist(dir.s,bRec=0)
Static strFiles.s,ct1:mDir=ExamineDirectory(-1,dir,"*.*"):If mDir:
While NextDirectoryEntry(mDir):If DirectoryEntryType(mDir)=1
FN.s=DirectoryEntryName(mDir):
If FindString(FN,".mp3",1) Or FindString(FN,".wma",1):FFN.s=dir+"\"+FN
AddElement(que()):que()=FFN:Debug(ffn):ct1+1:EndIf:Else
td$=DirectoryEntryName(mDir):If td$<>"." And td$<>"..":If bRec=0
dirlist(Dir+"\"+td$):EndIf:EndIf:EndIf:Wend:FinishDirectory(mDir):EndIf
EndProcedure:Procedure Requeue(*pt.s):t$=*pt
If FindString(t$,".mp3",1) Or FindString(t$,".wma",1):t$=GetPathPart(t$):r=1
EndIf:If t$<>"":If ListSize(que()):*p=@que():LastElement(que()):EndIf
dirlist(t$,r):If *p:ChangeCurrentElement(que(),*p):Else:ResetList(que())
EndIf:EndIf:EndProcedure:Procedure playm():ww=WindowWidth(WID)
PlayMovie(0,hwnd):Delay(100):If IsSprite(sg):FreeSprite(sg):FreeSprite3D(sg3)
EndIf:If ww=0:ww=width:EndIf:sg=CreateSprite(-1,ww,30,4|8)
sg3=CreateSprite3D(-1,sg):t$=GetFilePart(que()):t$=Left(t$,Len(t$)-4)
StartDrawing(SpriteOutput(sg)):DrawText(0,5,t$,RGB(0,255,0)):StopDrawing()
nx=ww:EndProcedure:Procedure mxy(*pt.point):GetCursorPos_(*pt):
C=GetSystemMetrics_(4):Y=GetSystemMetrics_(6):X=GetSystemMetrics_(5)
*pt\y-(WindowY(WID)+c+Y):*pt\x-(WindowX(WID)+X):EndProcedure:
Procedure drawcontrols(ww,hh):Protected pt.point,rc.rect,j=66:mxy(@pt)
If gvis And gbl:ap=100:Else:ap=255:EndIf:If (gbl And gvis) Or gbl=0:Stop3D()
sxx=(ww*0.5)-160:If pt\y<100:dx=pt\x-sxx:If dx>0 And dx<64:
StartDrawing(ScreenOutput()):Circle(sxx+32,39,29,RGB(0,ap,0)):StopDrawing():
If bcl:FreeMovie(0):If Not PreviousElement(que()):LastElement(que()):EndIf
If LoadMovie(0,que()):PlayM():EndIf:EndIf:ElseIf dx>64 And dx<128
StartDrawing(ScreenOutput()):Circle(sxx+64+31,10+29,29,RGB(0,ap,0))
StopDrawing():If bcl And bPause:ResumeMovie(0):gPlay=1:ElseIf bcl 
PlayMovie(0,WindowID(WID)):gPlay=1:EndIf:ElseIf dx>128 And dx<192
StartDrawing(ScreenOutput()):Circle(sxx+128+32,10+29,29,RGB(0,ap,0))
StopDrawing():If bcl:PauseMovie(0):bPause=1:EndIf:ElseIf dx>192 And dx<256
StartDrawing(ScreenOutput()):Circle(sxx+192+32,10+29,29,RGB(0,ap,0))
StopDrawing():If bcl:StopMovie(0):gplay=0:EndIf:ElseIf dx>256 And dx<320  
StartDrawing(ScreenOutput()):Circle(sxx+256+32,10+29,29,RGB(0,ap,0))
StopDrawing():If bcl:FreeMovie(0):If Not NextElement(que()):FirstElement(que())
EndIf:If LoadMovie(0,que()):PlayM():EndIf:EndIf:EndIf:EndIf:
Start3D():Sprite3DBlendingMode(5,2):DisplaySprite3D(splay,sxx,10,ap)
Sprite3DBlendingMode(3,2):If IsSprite(sg):DisplaySprite3D(sg3,nx,hh-40,255)
nx-2:If Abs(nx)>(2*ww):nx=ww:EndIf:EndIf:EndIf:bcl=0:EndProcedure  
Procedure nxt(b,cw,ch):ls=ListSize(que()):If ls>0:If gplay:If Not IsMovie(0)
If Not NextElement(que()):ResetList(que()):EndIf:If LoadMovie(0,que()):playm()
Else:DeleteElement(que()):EndIf:ElseIf Not MovieStatus(0):DeleteElement(que())
FreeMovie(0):EndIf:EndIf:If b:Drawcontrols(cw,ch):EndIf:EndIf:EndProcedure  
Procedure RecS():con\fm\nChannels=1:con\fm\wBitsPerSample=16
con\fm\nSamplesPerSec=22500:con\lBuf=1024:con\nBuf=8:con\nBit=1
con\fm\nBlockAlign=(con\fm\nChannels*Con\fm\wBitsPerSample)/8
con\fm\nAvgBytesPerSec=con\fm\nSamplesPerSec*Con\fm\nBlockAlign
If 0=waveInOpen_(@Con\wave,-1+con\nDev,@Con\fm,con\hWindow,#Null,65544)
For i=0 To con\nBuf-1:inHdr(i)\lpData=AllocateMemory(con\lBuf)
inHdr(i)\dwBufferLength=con\lBuf
waveInPrepareHeader_(con\wave,inHdr(i),SizeOf(WAVEHDR))
waveInAddBuffer_(con\wave,inHdr(i),SizeOf(WAVEHDR)):Next:
If 0=waveInStart_(con\wave):SetTimer_(con\hWindow,0,1,0):EndIf:EndIf:
EndProcedure:Procedure RecR(hWaveIn.l,lpWaveHdr.l):*hWave.WAVEHDR=lpWaveHdr
con\buffer=*hWave\lpData:con\size=*hWave\dwBytesRecorded:
waveInAddBuffer_(hWaveIn,lpWaveHdr,SizeOf(WAVEHDR)):EndProcedure:
Procedure recF():Protected N.w,M.w,NM1.i,J.i,ND2.i,MM.i:If con\buffer=0
ProcedureReturn:EndIf:For pos=0 To 1024:rex(pos)=0:imx(pos)=0:Next:pos=0:
For i=0 To con\size Step 2:value=PeekW(con\buffer+i):rex(pos)=value/32767
imx(pos)=0:pos+1:Next:N=1024:NM1=N-1:ND2=N/2:MM=Int(Log(N)/0.69314718055994529)
J=ND2:For ii=1 To N-2:If ii<J:TR.f=REX(J):TI.f=IMX(J):REX(J)=REX(ii)
IMX(J)=IMX(ii):REX(ii)=TR:IMX(ii)=TI:EndIf:K=ND2:While K<=J:J-K:K/2:Wend:J+K
Next:For L=1 To MM:LE=Int(Pow(2, L)):LE2=LE>>1:UR.f=1:UI.f=0:SR.f=Cos(#PI/LE2)
SI.f=-Sin(#PI/LE2):For J=1 To LE2:JM1=J-1:For i=JM1 To NM1:IP=i+LE2
TR=REX(IP)*UR-IMX(IP)*UI:TI=REX(IP)*UI+IMX(IP)*UR:REX(IP)=REX(i)-TR
IMX(IP)=IMX(i)-TI:REX(i)=REX(i)+TR:IMX(i)=IMX(i)+TI:i+LE-1:Next i:TR=UR
UR=TR*SR-UI*SI:UI=TR*SI+UI*SR:Next J:Next L:LockMutex(FMUT):mxv=1
For cnt=1 To 512:FFTOUT(0,cnt)=(IMX(cnt)*IMX(cnt))+(REX(cnt)*REX(cnt))
FFTOUT(1,cnt)=ATan(IMX(cnt)/REX(cnt)):If (mxv<FFTOUT(0,cnt)):mxv=FFTOUT(0,cnt)
akn=cnt:EndIf:Next cnt:UnlockMutex(FMUT):Delay(0):EndProcedure
Procedure record_CallBack(h.i,M.i,wP.i,lP.i)
R=#PB_ProcessPureBasicEvents:Select M:Case 275:recF():Case 960:RecR(wP,lP)
EndSelect:ProcedureReturn R:EndProcedure:fg=13565953:
Procedure FullScreen():rc.rect:bFsc!1:If IsWindow(WID)
If bFsc=1:wnd\Style=GetWindowLong_(hwnd,-16):GetWindowRect_(hwnd,@rc)
wnd\left=rc\Left:wnd\top=rc\top:wnd\width=rc\right-rc\left
wnd\height=Rc\bottom-rc\top 
SetWindowLong_(hwnd,-16,#WS_POPUP):SetWindowPos_(hwnd,0,0,0,0,0,39)
ShowWindow_(hwnd,3):ElseIf bFsc=0:SetWindowLong_(hwnd,-16,wnd\style)
SetWindowPos_(hwnd,-2,wnd\left,wnd\top,wnd\width,wnd\height,32)
ShowWindow_(hwnd,#SW_NORMAL):EndIf:EndIf:EndProcedure:Procedure Controls(void)
cWin=OpenWindow(-1,0,0,220,250,"IdleArts Re-Nova",cflags,hwnd):Static lss
Protected EV.i,EvG.i,EVw.i,bClose.i,slz,slr,slg,slb,slv,chkB,sla,chkV,sm,ssf,si
sm = SpinGadget(-1, 40, 10, 40, 20, 0, 13,3):If Not lss: lss=ss: EndIf 
chkB = CheckBoxGadget(-1,90,10,60,20,"Blend")
chkV = CheckBoxGadget(-1,150,10,60,20,"Visualize")
slz=TrackBarGadget(-1,45,40,160,20,2,64)
slr=TrackBarGadget(-1,45,70,160,20,1,255) 
slg = TrackBarGadget(-1,45,100,160,20,1,255) 
slb = TrackBarGadget(-1,45,130,160,20,1,255) 
sla = TrackBarGadget(-1,45,160,160,20,1,255) 
slv = TrackBarGadget(-1,45,190,160,20,1,255)
ssf = TrackBarGadget(-1,45,220,160,20,1,10)
TextGadget(-1,10,14, 30, 20,"Mode"):TextGadget(-1,10,215,40,20,"zoom")
TextGadget(-1,10,40,40,20,"Size"):TextGadget(-1,10,65,40,20,"Red")
TextGadget(-1,10,95,40,20,"Green"):TextGadget(-1,10,125,40,20,"Blue")
TextGadget(-1,10,155,40,20,"alpha"):TextGadget(-1,10,185,40,20,"Gain")
SetGadgetState(slz,ss):SetGadgetState(slr,gr*255):SetGadgetState(slg,gg*255)
SetGadgetState(slb,gb*255):SetGadgetState(sla,255-gain):SetGadgetState(sm,mode)
SetGadgetState(chkB,gbl):SetGadgetState(ssf,5):SetGadgetState(chkV,gVis):Repeat
EV=WaitWindowEvent()
EVw=EventWindow():EvG=EventGadget():If EVw=cWin:Select EV:Case #PB_Event_Gadget
Select EvG:Case slz:ss=GetGadgetState(slz):lss=ss:gredo=1:Case slr
gr=GetGadgetState(slr)/255.0:gredo=1:Case slg:gg=GetGadgetState(slg)/255.0
gredo=1:Case slb:gb=GetGadgetState(slb)/255.0:gredo=1:Case chkB 
gbl=GetGadgetState(chkB)!0:If Not gbl:ss=lss:gredo=1:EndIf:Case chkV
gVis=GetGadgetState(chkV)!0:gReset=1:If gVis:gbl=1:SetGadgetState(chkB,1)
Else:gbl=GetGadgetState(chkB):EndIf:Case sla:gredo=1
gain=GetGadgetState(sla)*0.0039:Case slv
vgain=GetGadgetState(slv)*0.0001:Case ssf:msf=64:si=GetGadgetState(ssf)-5
If si<0:msf>>-sii:If msf<1:msf=1:EndIf:Else:msf<<si:EndIf:gsf=0.015625*msf 
Case sm:mode=GetGadgetState(sm):EndSelect:Case 16:bClose=1:EndSelect:EndIf
Until bClose=1:EndProcedure:Procedure Reset():c=0:While c<3000
stars(c)\x=Random(3000)+1:stars(c)\y=Random(3000)+1
stars(c)\speed=1/Sqr(stars(c)\x*stars(c)\x + stars(c)\y*stars(c)\y):c+1:Wend
bbb=Random(5)+1:ccc=Random(5)+1:ddd=Random(5)+1:aaa=Random(5)+1:EndProcedure
Procedure DrawScene():Static sP1,sPR,sP2,sPR1,ux,uy,uz
Static hc.i,ef.f=65.0,speed.f=3.0,lw,lh,cw,ch,ttt:Protected iy,ix,iyy.f,dr.f
Protected dx.f,dy.f,dz.f,cx,cy,mx.f,px.i,py.i,nt.i,cts:LockMutex(FMUT)
If GetWindowState(WID)=#PB_Window_Minimize:nxt(0,0,0):Else:If con\hwindow=0:
Con\hWindow=Hwnd:SetWindowCallback(@record_CallBack()):RecS():EndIf:
cw=WindowWidth(WID):ch=WindowHeight(WID):nt=akn*2+30:If GetAsyncKeyState_(32)&1
Reset():ef=(Random(1000)+1)-500:EndIf:t=ElapsedMilliseconds()
If gvis And t>ttt:aaa=Random(5)+1:bbb=Random(5)+1:ccc=Random(5)+1
ddd=Random(5)+1:ttt=t+Random(5000)+1000:EndIf 
If IsSprite(SP2) And cw<>lw Or ch<>lh:lw=cw:lh=ch:FreeSprite(sP2)
FreeSprite3D(sPR1):EndIf:If Not IsSprite(sP2):sP2=CreateSprite(-1,cw,ch,12)
sPR1=CreateSprite3D(-1,sP2):StartDrawing(SpriteOutput(sP2)):Box(0,0,cw,ch,0)
StopDrawing():EndIf:If Not IsSprite(sP1) Or gRedo Or gbl:gredo=0:If gbl
ux=1<<Random(5)+1:Else:ux=ss:EndIf:uz=ux/2:uy=256/ux:If IsSprite(sP1)
FreeSprite(sP1):FreeSprite3D(sPR):EndIf:sP1=CreateSprite(-1,ux,ux,12 )
sPR=CreateSprite3D(-1,sP1):StartDrawing(SpriteOutput(sP1)):For iy=-uz To uz
iyy=iY*iY:For ix=-uz To uz:dr=Sqr(ix*ix+iyy):If dr<uz:dr=(uz-dr) * uy
Plot(uz+ix,uz+iy,RGB(dr*gr*gain,dr*gg*gain,dr*gb*gain)):EndIf:Next:Next
StopDrawing():EndIf:If Not gbl:ClearScreen(0):EndIf:If Start3D():scx=cw*0.5
Sprite3DQuality(1):scy=ch*0.5:cx=scx-uz:cy=scy-uz:Sprite3DBlendingMode(3,2)
While cts<3000:dx=stars(cts)\x:dy=stars(cts)\y:dz=Sqr(dx*dx+dy*dy):If dz=0:dz=1
EndIf:tv.f=Abs(fftout(1,ct))*vgain:dx+tv:dy-tv:If ct>=500:ct=15:Else:ct+1:EndIf
mx=(stars(cts)\speed*speed*dz):Select mode:Case 0 
px=(cx+(Sin(dx)+Cos(dy))*mx):py=(cy+(Cos(dx)-Sin(dy))*mx):Case 1
px=(cx+(Sin(dx/aaa)*Cos(dy/bbb))*mx):py=(cy+(Cos(dx/ccc)*Sin(dy/DDd))*mx)
Case 2:px=Int(cx+Tan((Sin(dx)+Cos(dy)))*mx):py=Int(cy+(Cos(dx)-Sin(dy))*mx)
Case 3:px=cx+(Sin(dx)+Cos(dy))*mx:py=cy+Tan(Cos(dx)-Sin(dy))*mx:Case 4 
px=Int(cx+Tan(Sin(dx)+Cos(dy))*mx):py=Int(cy+Tan(Cos(dx)-Sin(dy))*mx):Case 5 
px=cx+Tan(Sin(dx)*Sin(dy))*mx:py=cy+Tan(Cos(dx)*Cos(dy))*mx:Case 6
px=Int(cx+Tan(Cos(dx))*mx):py=Int(cy+Tan(Sin(dy))*mx):Case 7
px=Int(cx+Sin(Cos(dx))*mx):py=Int(cy+Tan(Sin(dy))*mx):Case 8 
px=Int(cx+(Sin(dx))*mx):py=Int(cy+(Cos(dy))*mx):Case 9
px=cx+(Sin(mx)+Cos(dx))*mx:py=cy+(Cos(dx)-Sin(mx))*mx:Case 10  
px=(cx+(Cos(dx)+Cos(dy))*mx):py=(cy+(Cos(dx)-Cos(dy))*mx):Case 11 
px=cx+(Sin(mx)-Cos(dx))*mx:py=cy+(Cos(dx)+Sin(mx))*mx:Case 12   
px=(cx+(Sin(dx*aaa)+Cos(dy*bbb))*mx):py=(cy+(Cos(dx*ccc)-Sin(dy*DDd))*mx)   
Case 13:px=cx+(Sin(dx/aaa)/Cos(dy/bbb)*mx):py=cy+(Cos(dx/bbb)/Sin(dy/DDd)*mx)  
EndSelect:If gVis:ef=nt:speed=((mxv)*vgain)
stars(cts)\x+(px/ef):stars(cts)\y+(py/ef):stars(cts)\speed=1/dz:Else:speed=1.0
stars(cts)\x+(px/ef):stars(cts)\y+(py/ef):stars(cts)\speed+1/dz:EndIf 
If gsf<>1:px=(px*gsf)-(cx*gsf)+cx:py=(py*gsf)-(cy*gsf)+cy:EndIf
DisplaySprite3D(sPR,px,py,128):If px>cw*1.5 Or py>ch*1.5
stars(cts)\x=Random(cw)+1:stars(cts)\y=Random(ch)+1
stars(cts)\speed = 1/Sqr(stars(cts)\x*stars(cts)\x+stars(cts)\y*stars(cts)\y)
EndIf:cts+1:Wend:nxt(1,cw,ch):Sprite3DBlendingMode(3,12):If gbl And gVis
DisplaySprite3D(SPR1,0,0,170):ElseIf gbl:DisplaySprite3D(SPR1,0,0,255):EndIf
Stop3D():EndIf:UnlockMutex(FMUT):FlipBuffers():EndIf:Delay(0):EndProcedure
Procedure ScreenX(void):Protected EV.i,EVw.i,bclose.i
title.s = "IdleArts Re-Nova Attractor":pt.point
WID=OpenWindow(-1,0,0,Width,Height,title,fg,0):hwnd=WindowID(WID)
screen=OpenWindowedScreen(hwnd,0,0,fwd,fhd,0,0,0,2):OleInitialize_(0)
EnableWindowDrop(WID,15,4):UsePNGImageDecoder():ts1=LoadSprite(-1,"but.png",4|8)
splay=CreateSprite3D(-1,ts1):If hwnd And screen:Repeat:DrawScene():Repeat
If GetActiveWindow_()=hwnd:If GetAsyncKeyState_(#VK_ESCAPE)&1:gq=1:EndIf:EndIf       
EV=WindowEvent():EVw=EventWindow():If EVw=WID:Select EV:Case #WM_RBUTTONDOWN
FullScreen():Case #WM_LBUTTONDOWN:mxy(@pt)
If pt\y<100 And ElapsedMilliseconds()>lbk:bcl=1:lbk=ElapsedMilliseconds()+250
ElseIf Not IsThread(Controlthread):Controlthread=CreateThread(@Controls(),0)
EndIf:Case 16:screen=0:bclose=1:Case #PB_Event_WindowDrop:ps.s=EventDropFiles()
Requeue(@ps):gvis=1:gbl=1:EndSelect:EndIf:Until EV=0:Delay(20)
Until bclose=1 Or gq:EndIf:CloseScreen():EndProcedure:Procedure run():
If InitSprite() And InitSprite3D() And InitMovie():Protected timeout:
ExamineDesktops():fwd=DesktopWidth(0):fhd=DesktopHeight(0):Width=800:Height=600
CreateThread(@ats(),0):ScreenX(0):EndIf:EndProcedure:
CompilerIf #PB_Compiler_Thread:If FileSize("but.png")=-1:InitNetwork():
ReceiveHTTPFile("http://idlearts.com/but.png","but.png"):EndIf:reset():run()
CompilerElse:MessageRequester("Warning","Please set compiler to threadsafe")
CompilerEndIf
; IDE Options = PureBasic 4.51 RC 1 (Windows - x86)
; CursorPosition = 5
; Folding = ---