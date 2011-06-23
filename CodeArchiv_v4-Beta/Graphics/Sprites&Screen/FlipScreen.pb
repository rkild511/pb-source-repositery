; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2205&postdays=0&postorder=asc&start=60 
; Author: Stefan Moebius (updated for PB 4.00 by Stefan)
; Date: 14. September 2003 
; OS: Windows
; Demo: No

; Alternative for PB command FlipBuffers(), which doesn't depend on the refresh-rate of the monitor 

; Ersatzbefehl für Flipbuffers() ,der nicht von der Refreshrate des Monitors abhängig ist. 

;Funktioniert nur im Fullscreenmodus. 
#DDBLTFAST_WAIT=16 
  
Procedure GetBackDDS() 
  !extrn _PB_DirectX_BackBuffer 
  !MOV Eax,[_PB_DirectX_BackBuffer] 
  ProcedureReturn 
EndProcedure 

Procedure GetPrimaryDDS() 
  !extrn _PB_DirectX_PrimaryBuffer 
  !MOV Eax,[_PB_DirectX_PrimaryBuffer] 
  ProcedureReturn 
EndProcedure 

Procedure FlipScreen() 
  *DDS.IDirectDrawSurface7=GetPrimaryDDS() 
  While PeekMessage_(msg.MSG,0,0,0,#PM_REMOVE) 
    TranslateMessage_(msg) 
    DispatchMessage_(msg) 
  Wend 
  *DDS\BltFast(0,0,GetBackDDS(),0,#DDBLTFAST_WAIT) 
EndProcedure 


; Note: this ASM code works only with an example using it. Else the sprite isn't used...
InitSprite() 
OpenScreen(800,600,32,"Test") 

ClearScreen(#Red) 
FlipScreen() 
Delay(1000)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
