;*****************************************************************************
;*
;* Name   :SETI Finally finds evidence of ET
;* Author :idle - andrew ferguson
;* Date   :29/06/2009
;* Notes  :windows only tested on XP!!!!
;*****************************************************************************
Structure WTF:T.w:c.w:ns.l:ab.l:nb.w:bs.w:cb.w:EndStructure
Global FP,wf.WTF,wh.WAVEHDR,hw.i,sz=44100*300,*w=AllocateMemory(sz),t2.i   
Procedure WOP(h,u,d,a,b):If u=#WOM_DONE:FP=1:EndIf:EndProcedure
wf\T=1:wf\C=2:wf\bs=16:wf\nS=44100:wf\nb=2:wf\ab=176400:wh\lpData=*w
wh\dwBufferLength=sz:waveOutOpen_(@hW,-1,wf,@WOP(),0,$30000):FP=0:ft=1000
waveOutPrepareHeader_(hw,wh,SizeOf(wh)):While i<sz/9:v+ft:v%32767:PokeW(*w+i,v)
Ft+Tan(i):i+2:Wend:t1=GetTickCount_():While i<sz-2:t2=GetTickCount_()-t1
t=i%((t2%2700)+700):v=Sin(t)*ft:v%32767:PokeW(*w+i,v):Ft+Tan(i*3)
i+2:Wend:waveOutWrite_(hw,wh,SizeOf(wh)):While Not FP:Delay(10):Wend
waveOutUnprepareHeader_(hw,wh,SizeOf(wh)):waveOutClose_(hw):FreeMemory(*w) 
; IDE Options = PureBasic 4.31 (Windows - x86)
; Folding = -
; DisableDebugger