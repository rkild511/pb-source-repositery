; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6882&highlight=
; Author: Doobrey (updated for PB4.00 by blbltheworm)
; Date: 12. July 2003
; OS: Windows
; Demo: No


; Here ya go... just a simple small example of how to write a visual plugin for
; Winamp 2.x <--- Note...NOT V3 !! that might come later 

; It should be pretty straightforward, I commented all the important bits 
; Just compile this to a DLL, and put the DLL in \Winamp\plugins and fire up Winamp. 


;## Winamp 2.x Vis Plugin example by Doobrey. 
;## No asm was harmed in the making of this program. 

#VIS_HDRVER =$101 
Structure winampVisModule 
    description.l   ;## Pointer to plugin description string 
    
    hwndParent.l    ;## This lot is filled by Winamp . 
    hDllInstance.l 
    sRate.l 
    nCh.l 
    
    latencyMs.l    ;## Set these 2 to time the calls to render() 
    delayMs.l 
    
    spectrumNch.l   ;## Set these to what your render() needs 
    waveformNch.l   ;## either 0,1 or 2 ..but I get wierd results on 1 :( 
    
    ;## Winamp fills these 2 every render(), depending on what was set above ^^^^ 
    spectrumData.b[1152] ;(2*576)    
    waveformData.b[1152] ;## 8 bit samples 
    
    Config.l   ;## These 4 are the pointers to your routines. 
    Init.l 
    Render.l 
    Quit.l 
    
    UserData.l  ;## pfffff?? 

EndStructure 

Structure winampVisHeader 
  version.l      ;## **MUST** always be #VIS_HDRVER 
  description.l  ;## Addr of module title string 
  getmodule.l    ;## Addr of your getmodule() proc 
EndStructure 


Structure tmpspec 
specdata.b[106] 
EndStructure 



Global  hdr.winampVisHeader
Global  Mod0.winampVisModule
Global  Mod1.winampVisModule

Global imgnumber.l,rendercount.l,oldtitle.s,winamphwnd.l 
Global Mem1.l,Mem2.l,Mem3.l,count.l,oldspec.tmpspec 

Procedure.s GetSongTitle() ;## RETURNS NULL IF SAME TITLE, OTHERWISE NEW TITLE 
;## Full list of the usercodes on the Winamp2 dev forums. 
If winamphwnd 
  songindex.l=SendMessage_(winamphwnd,#WM_USER,0,125) 
  titlepointer.l=SendMessage_(winamphwnd,#WM_USER,songindex,212) 
  If titlepointer 
   title.s=PeekS(titlepointer) 
   If title<>oldtitle 
    ProcedureReturn title 
   EndIf 
  EndIf 
EndIf 

EndProcedure 

;## This little proc gets asked by winamp for the address of the winampVisModule struct 
;## for every module you write. Return 0 to tell it there`s no more! 

ProcedureCDLL .l  getModule(modnum.l) 
pr.l=0 
Select modnum  ;## ONCE CASE PER MODULE 
  Case 0 
   pr= @Mod0 
  Case 1 
   pr= @Mod1 
  ;Case 2          
  ;pr= @anothermod  -- just an example 
  
EndSelect 
ProcedureReturn pr 
EndProcedure 

;## Put any user config  stuff in this routine. 
Procedure Config(*this_mod.winampVisModule) 
MessageBox_(*this_mod\hwndParent,"Powered by PureBasic !","Config",#MB_OK) 
EndProcedure 

;## Init for the windowed mode.. I know it`s yucky.. 
;## But double buffering using 2 images seemed the easiest way for a window test ! 
;## Return 0 for InitOK, or 1 for error. 
Procedure Init1(*this_mod.winampVisModule) 
wintitle.s=Str(*this_mod\hwndParent) 
winamphwnd=*this_mod\hwndParent 
If OpenWindow(0,0,0,288,128,"PB Winamp Test",0,winamphwnd) ;## REALLY NEED TO ADD WINAMP PARENT WINDOW ! 
   CreateGadgetList(WindowID(0)) 
   CreateImage(0,288,128) 
   CreateImage(1,288,128) 
   StartDrawing(ImageOutput(0)) 
    Box(0,0,288,128,0) 
   StopDrawing() 
   ImageGadget(0,0,0,288,128,ImageID(0),0) 
   imagenumber=1 
   rendercount=0 
  ProcedureReturn 0 
Else 
;## Should really add an error msg here 
  ProcedureReturn 1 
EndIf 
EndProcedure 

;## The render routines must return 0 for OK, or 1=Error 
;## Beware, spectrumdata is in a linear scale..2*576 bytes 
;## **MUST be CDLL ** or welcome to crashville! 
ProcedureCDLL.l Render1(*this_mod.winampVisModule) 
pr.l=1 
If ImageID(imagenumber) 
  StartDrawing(ImageOutput(imagenumber)) 
   Box(0,0,288,128,0) 
     For a.l=0 To 71 ;## Same as 0 to 287 step ..average out the bands. 
       w.l=0 
       For b=0 To 3 
         v.l=(*this_mod\spectrumData[(a*4)+b]&$FF) 
         w+v ;## I got wierd results doing w=w+(*this_mod\spectrumdata[(a*4)+b]&$FF) 
       Next 
       w=w>>4 
       w=(Sqr(w)*16) 
       ;## Simple /2 average with old data 
       tmp.l=((w+oldspec\specdata[a])>>1) 
       oldspec\specdata[a]=tmp 
       ;## Get a funky colour 
       col.l=RGB(111+(a*2),255-(a*2),tmp) 
    
       Box(a*4,128,4,-tmp,col) 
     Next 
StopDrawing() 
SetGadgetState(0,ImageID(imagenumber)) 
imagenumber=1-imagenumber 
rendercount+1 

If rendercount>7 
  title.s=GetSongTitle() 
  If title 
   SetWindowText_(WindowID(0),@title) 
   oldtitle=title 
  EndIf 
rendercount=0 
EndIf 
pr=0 
EndIf 
ProcedureReturn pr 
EndProcedure 

;## Must cleanup any resources that Init created...no return val. 
Procedure Quit1(*this_mod.winampVisModule) 
CloseWindow(0) 
FreeImage(0) 
FreeImage(1) 
EndProcedure 

;##-- Now for another module --## 

;## Init for fullscreen-o-rama 
Procedure.l Init0(*this_mod.winampVisModule) 
pr.l=1 
If InitSprite() And InitKeyboard() 
If OpenScreen(640,480,32,"PB Winamp test") 

;## CLEAR OLD SPECTRUM DATA ARRAY 
  For a=0 To 105 
   oldspec\specdata[a]=0 
  Next 
  pr=0 
EndIf 
EndIf 

ProcedureReturn pr 
EndProcedure 

;## The full screen render routine.. 
ProcedureCDLL.l Render0(*this_mod.winampVisModule) 
pr.l=0 

If IsScreenActive() 
FlipBuffers() 
ClearScreen(RGB(0,0,0)) 

StartDrawing(ScreenOutput()) 
  addr.w=0 
  For a.l=0 To 105 
    w.f=0 
    For b=0 To 3 
     v.l=(*this_mod\spectrumData[addr]&$FF) ;#left channel 
     w+v 
     addr+1 
    Next 
    
    ;## Just an attempt to boost the high end spectrum 
    w=(Sqr(w/4)*8) 
    v=w*((a/25)+1) 
    
    ;## AVERAGE IT OUT WITH OLD DATA 
    tmp.l=((v+oldspec\specdata[a])/2)&$FFFF 
    oldspec\specdata[a]=tmp 
    
    Box(a*6,480,6,-4*tmp,RGB(2*a,255-(2*a),tmp)) 
    
  Next 

  ;## Now to piddle about with the waveform 
  lx.l=0:ly=128:nx.l=0 
  For a.l=0 To 105 
   ny.l=128-*this_mod\waveformData[a*4] 
   nx+6 
   LineXY(lx,ly,nx,ny,RGB(ny,255-ny,180)) 
   ly=ny:lx=nx 
  Next 

StopDrawing() 

;## Better just check to see if escape has been pressed ! 
ExamineKeyboard() 
  If KeyboardPushed(#PB_Key_Escape) 
   pr=1 
  EndIf 
  
EndIf 

ProcedureReturn pr 
EndProcedure 

;## Cleanup after Init0 
Procedure Quit0(*this_mod.winampVisModule) 
CloseScreen() 
EndProcedure 



;## This is called by winamp to examine all available plugin modes 
;## Don`t init anything here, just return the address of the header structure! 
ProcedureDLL.l winampVisGetHeader() 
;## GENERAL HEADER STUFF 
hdr\version=#VIS_HDRVER 
hdr\description=?desc_label 
hdr\getmodule=@getModule() 

;## MODULE STUFF ..fill out one of these for each module in the plugin. 
;## MODULE 0..FULL SCREEN 
Mod0\description=?mod0_label 
Mod0\latencyMs=25 
Mod0\delayMs=25 
Mod0\spectrumNch=2 ;# Gimme one of each 
Mod0\waveformNch=2 ;# Wierd results when using 1 ! 
Mod0\Config=@Config() 
Mod0\Init=@Init0() 
Mod0\Render=@Render0() 
Mod0\Quit=@Quit0() 

;## MODULE 1..WINDOW MODE 
Mod1\description=?mod1_label 
Mod1\latencyMs=25 
Mod1\delayMs=25 
Mod1\spectrumNch=1 ;# Just one spectrum in window 
Mod1\waveformNch=0 
Mod1\Config=@Config() 
Mod1\Init=@Init1() 
Mod1\Render=@Render1() 
Mod1\Quit=@Quit1() 

ProcedureReturn @hdr 
EndProcedure 


;## Quick and easy static strings 
DataSection 
  desc_label: 
  Data.s "Doobreys PB Plugathlon" 
  mod0_label: 
  Data.s "Full Screen ( escape to stop)" 
  mod1_label: 
  Data.s "Windowed mode" 
EndDataSection 
 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
