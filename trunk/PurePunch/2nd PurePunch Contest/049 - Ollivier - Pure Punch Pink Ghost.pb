;*****************************************************************************
;*
;* Name : Pure Punch Pink Ghost
;* Author : Ollivier
;* Date : 05.06.09
;* Notes : Add DIRECTX9 option in compiler options if problem
;*
;*****************************************************************************
a.F:Macro P(C):Particle#C:EndMacro:UsePNGImageEncoder():InitEngine3D():v.F
InitSprite():InitKeyboard():Add3DArchive("\",0):OpenScreen(1024,768,32,"")
CreateImage(1,256,256):StartDrawing(ImageOutput(1)):For i=0 To 127:c=i*i*i/7850
Circle(128,128,127-i,RGB(c,c,c)):Next:StopDrawing():SaveImage(1,"PP",$474E50)
LoadTexture(0,"PP"):CreateMaterial(0,TextureID(0)):DisableMaterialLighting(0,1)
MaterialBlendingMode(0,1):Create#P(Emitter)(0,10,1,1,0):P(EmissionRate)(0,100);
P(Size)(0,256,256):P(Material)(0,MaterialID(0)):P(TimeToLive)(0,2,8)
P(Velocity)(0,1,300):F=100:P(ColorRange)(0,$FF0000,$FF):CreateCamera(0,0,0,F,F)
CameraLocate(0,0,0,2000):Repeat:P(EmitterDirection)(0,Cos(a),Sin(a),0):a+1.246
FlipBuffers():ExamineKeyboard():RenderWorld():Until KeyboardPushed(1)
; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 17
; Folding = -
; DisableDebugger