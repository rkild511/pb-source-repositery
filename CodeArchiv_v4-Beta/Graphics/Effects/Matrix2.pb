; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8367&highlight=
; Author: Psychophanta (based on original example by Comtois, updated for PB 4.00 by Comtois)
; Date: 19. November 2003
; OS: Windows
; Demo: No

;******************************************* 
;** Comtois ** 15/11/03 ** Matrice / Vagues  ** 
;******************************************* 
;Modifications and additions by Psychophanta on 19-Nov-2003

;/SnapShot 
#Img_SnapShot = 0 
ExamineDesktops() 
hBitmap = CreateImage(#Img_SnapShot, DesktopWidth(0), DesktopHeight(0)) 
hdc = StartDrawing(ImageOutput(#Img_SnapShot)) 
SelectObject_(hdc, hBitmap) 
BitBlt_(hdc, 0, 0, DesktopWidth(0), DesktopHeight(0), GetDC_(GetDesktopWindow_()), 0, 0, #SRCCOPY) 
StopDrawing() 
DeleteDC_(hdc) 

;-Initialisation 
bitplanes.b=32:RX.w=1024:RY.w=768 
If InitEngine3D()=0 Or InitSprite()=0 Or InitKeyboard()=0 
  MessageRequester("Error","Something fails to open Screen for 3D. This requires Engine3D.dll",0) 
  End 
EndIf 
While OpenScreen(RX.w,RY.w,bitplanes.b,"DemoMatrice")=0 
  If bitplanes.b>16:bitplanes.b-8 
  ElseIf RY.w>600:RX.w=800:RY.w=600 
  ElseIf RY.w>480:RX.w=640:RY.w=480 
  ElseIf RY.w>400:RX.w=640:RY.w=400 
  ElseIf RY.w>240:RX.w=320:RY.w=240 
  ElseIf RY.w>200:RX.w=320:RY.w=200 
  Else:MessageRequester("VGA limitation","Can't open Screen!",0):End 
  EndIf 
Wend 
Structure  Vecteur 
x.f 
y.f 
z.f 
EndStructure 
Structure Vertex 
x.f 
y.f 
z.f 
Nx.f 
Ny.f 
Nz.f 
u.f 
v.f 
EndStructure 

Structure DoubleFace 
f1.w 
f2.w 
f3.w 

f4.w 
f5.w 
f6.w 

f7.w 
f8.w 
f9.w 

f10.w 
f11.w 
f12.w 
EndStructure 

;-Constantes 
#NbX=30 ; nombre de facettes 
#NbZ=30 ; nombre de facettes 
#DegConv=3.14159265/180 

    
;-Variables Globales 
Global AngleVague.f,WaveFrequency.f,WavePeriodX.f,WavePeriodZ.f,WaveAmplitude.f 
Global xrot.f,yrot.f,zrot.f,xprot.f,yprot.f,zprot.f 
Global CamLocateX.l,CamLocateY.l,CamLocateZ.l,CamLookAtX.l,CamLookAtY.l,CamLookAtZ.l 
Global Mode.b 
circle.l=360 
AngleVague=Random(circle) 
WaveFrequency=3;=waves/second 
WavePeriodX=5;=1/Wave lenght 
WavePeriodZ=9;=1/Wave lenght 
WaveAmplitude=2 
xprot=-0.3:yprot=-0.4:zprot=0.2 
CamLocateX.l=0:CamLocateY.l=0:CamLocateZ.l=50 
CamLookAtX.l=0:CamLookAtY.l=0:CamLookAtZ.l=0 

;-Procédures 
Procedure Matrice(*Vertex.Vertex,*Face.DoubleFace,FX.l,FZ.l) 
  *Ptr.Vertex=*Vertex 
   FX2=FX/2 
   FZ2=FZ/2 
  For b=0 To FZ 
    For a=0 To FX 
      *Ptr\x= a-FX2 
      *Ptr\y=0 
      *Ptr\z=b-FZ2 
      *Ptr\u=a/FX 
      *Ptr\v=b/FZ 
      *Ptr + SizeOf(Vertex) 
    Next a 
  Next b 

  *PtrF.DoubleFace=*Face 
  Nb=FX+1 
  For b=0 To FZ-1 
    For a=0 To FX-1 
      P1=a+(b*Nb) 
      P2=P1+1 
      P3=a+(b+1)*Nb 
      P4=P3+1 
      ;Face 1 
      *PtrF\f1=P3 : *PtrF\f2=P2 : *PtrF\f3=P1 
      *PtrF\f4=P2 : *PtrF\f5=P3 : *PtrF\f6=P4 
      ;Face 2 
      *PtrF\f7=P1 : *PtrF\f8=P2 : *PtrF\f9=P3    
      *PtrF\f10=P4 : *PtrF\f11=P3 : *PtrF\f12=P2 
      *PtrF + SizeOf(DoubleFace) 
    Next 
  Next 


EndProcedure 


Procedure MakeNormale(*Vertex.Vertex,*Face.DoubleFace,Fx,Fz) 
     Protected *Ptr.Vertex, *PtrF.DoubleFace, *PtrN.Vecteur, Temp.Vecteur 
    Protected  Vecteur1.Vecteur,  Vecteur2.Vecteur,  P1.Vecteur,  P2.Vecteur,  P3.Vecteur ,*N.Vecteur 
    
     *N=AllocateMemory((Fx+1)*(Fz+1)*SizeOf(Vecteur)) 
  
    *PtrF=*Face 
     For b=0 To FZ-1 
       For a=0 To FX-1 
          ;{ Calcule la normale du premier triangle 

          ;Avec les 3 vertices qui composent le triangle, on détermine deux vecteurs 

            *Ptr=*Vertex + *PtrF\f1 * SizeOf(Vertex) 
           P1\x = *Ptr\x 
         P1\y = *Ptr\y 
          P1\z = *Ptr\z 
        
           *Ptr=*Vertex + *PtrF\f2 * SizeOf(Vertex) 
            P2\x = *Ptr\x 
           P2\y = *Ptr\y 
           P2\z = *Ptr\z 
        
           *Ptr=*Vertex + *PtrF\f3 * SizeOf(Vertex) 
            P3\x = *Ptr\x 
           P3\y = *Ptr\y 
           P3\z = *Ptr\z 
        
           Vecteur1\x = (P1\x - P2\x) 
           Vecteur1\y = (P1\y - P2\y) 
           Vecteur1\z = (P1\z - P2\z) 
        
           Vecteur2\x = (P1\x - P3\x) 
           Vecteur2\y = (P1\y - P3\y) 
           Vecteur2\z = (P1\z - P3\z) 
            
         ;Calcule la normale du premier triangle 
           Temp\x = ((Vecteur1\y * Vecteur2\z) - (Vecteur1\z * Vecteur2\y)) 
           Temp\y = ((Vecteur1\z * Vecteur2\x) - (Vecteur1\x * Vecteur2\z)) 
           Temp\z = ((Vecteur1\x * Vecteur2\y) - (Vecteur1\y * Vecteur2\x)) 
            
           ;Et affecte cette normale aux vertices composants le premier triangle 
           *PtrN=*N + *PtrF\f1 * SizeOf(Vecteur) 
           *PtrN\x + Temp\x 
           *PtrN\y + Temp\y 
           *PtrN\z + Temp\z 

           *PtrN=*N + *PtrF\f2 * SizeOf(Vecteur) 
           *PtrN\x + Temp\x 
           *PtrN\y + Temp\y 
           *PtrN\z + Temp\z 
            
           *PtrN=*N + *PtrF\f3 * SizeOf(Vecteur) 
           *PtrN\x + Temp\x 
           *PtrN\y + Temp\y 
           *PtrN\z + Temp\z 
          ;} 
          
         ;{ Calcule la normale du second triangle 

          ;Avec les 3 vertices qui composent le triangle, on détermine deux vecteurs 

            *Ptr=*Vertex + *PtrF\f4 * SizeOf(Vertex) 
           P1\x = *Ptr\x 
         P1\y = *Ptr\y 
          P1\z = *Ptr\z 
        
           *Ptr=*Vertex + *PtrF\f5 * SizeOf(Vertex) 
            P2\x = *Ptr\x 
           P2\y = *Ptr\y 
           P2\z = *Ptr\z 
        
           *Ptr=*Vertex + *PtrF\f6 * SizeOf(Vertex) 
            P3\x = *Ptr\x 
           P3\y = *Ptr\y 
           P3\z = *Ptr\z 
        
           Vecteur1\x = (P1\x - P2\x) 
           Vecteur1\y = (P1\y - P2\y) 
           Vecteur1\z = (P1\z - P2\z) 
        
           Vecteur2\x = (P1\x - P3\x) 
           Vecteur2\y = (P1\y - P3\y) 
           Vecteur2\z = (P1\z - P3\z) 
            
         ;Calcule la normale du second triangle 
           Temp\x = ((Vecteur1\y * Vecteur2\z) - (Vecteur1\z * Vecteur2\y)) 
           Temp\y = ((Vecteur1\z * Vecteur2\x) - (Vecteur1\x * Vecteur2\z)) 
           Temp\z = ((Vecteur1\x * Vecteur2\y) - (Vecteur1\y * Vecteur2\x)) 
            
           ;Et affecte cette normale aux vertices composants le second triangle 
           *PtrN=*N + *PtrF\f4 * SizeOf(Vecteur) 
           *PtrN\x + Temp\x 
           *PtrN\y + Temp\y 
           *PtrN\z + Temp\z 

           *PtrN=*N + *PtrF\f5 * SizeOf(Vecteur) 
           *PtrN\x + Temp\x 
           *PtrN\y + Temp\y 
           *PtrN\z + Temp\z 
            
           *PtrN=*N + *PtrF\f6 * SizeOf(Vecteur) 
           *PtrN\x + Temp\x 
           *PtrN\y + Temp\y 
           *PtrN\z + Temp\z 
          ;} 
          
         ;Face suivante 
         *PtrF + SizeOf(DoubleFace) 
        Next a 
     Next b 
   ;Norme et affecte la normale de chaque Vertex 
   *PtrN=*N 
   *Ptr=*Vertex 
   For b=0 To FZ 
       For a=0 To FX 
          Norme=Sqr(*PtrN\x * *PtrN\x + *PtrN\y * *PtrN\y + *PtrN\z * *PtrN\z) 
         If norme = 0 
               *Ptr\Nx = 0 
               *Ptr\Ny = 0 
               *Ptr\Nz = 0 
          Else 
               *Ptr\Nx = *PtrN\x / Norme 
               *Ptr\Ny = *PtrN\y / Norme 
               *Ptr\Nz = *PtrN\z / Norme 
          EndIf          
          *Ptr + SizeOf(Vertex) 
          *PtrN + SizeOf(Vecteur) 
       Next a 
     Next b 

   FreeMemory(*N) 
EndProcedure 

Procedure vagues(*Vertex.Vertex,*Face.DoubleFace) 
 ; Modification sur l'axe des Y 
  *Ptr.Vertex=*Vertex 
  For z=0 To #NbZ 
    For x=0 To #NbX 
        *Ptr\y=Sin(#DegConv*(AngleVague+x*WavePeriodX+z*WavePeriodZ))*WaveAmplitude 
      *Ptr + SizeOf(Vertex) 
    Next 
  Next 
  MakeNormale(*Vertex.Vertex,*Face.DoubleFace,#NbX,#NbZ) 
  SetMeshData(0,#PB_Mesh_Vertex | #PB_Mesh_Normal | #PB_Mesh_UVCoordinate,*Vertex,(#NbX+1)*(#NbZ+1)) 
EndProcedure 

Procedure.b ShowTextAndKeyTest(hidetext.b) 
  If hidetext.b=0 
    StartDrawing(ScreenOutput()) 
    DrawingMode(1) 
    FrontColor(RGB(20,180,115)) 
    DrawText(0,0,"[F1] => Toggle Mode affichage") 
    DrawText(0,20,"[PageUp] / [PageDown] => Wave Amplitude : "+StrF(WaveAmplitude)) 
    DrawText(0,40,"[Up Arrow] / [Down Arrow] => Wave Period on Z axis : "+Str(WavePeriodZ)) 
    DrawText(0,60,"[Right Arrow] / [Left Arrow] => Wave Period on X axis : "+Str(WavePeriodX)) 
    DrawText(0,80,"[Home key] / [End key] => Wave speed : "+Str(WaveFrequency)) 
    DrawText(0,100,"[F2] / [Shift+F2] => X rotation speed : "+StrF(xprot)) 
    DrawText(0,120,"[F3] / [Shift+F3] => Y rotation speed : "+StrF(yprot)) 
    DrawText(0,140,"[F4] / [Shift+F4] => Z rotation speed : "+StrF(zprot)) 
    DrawText(0,160,"[F5] / [Shift+F5] => X Camera location : "+Str(CamLocateX)) 
    DrawText(0,180,"[F6] / [Shift+F6] => Y Camera location : "+Str(CamLocateY)) 
    DrawText(0,200,"[F7] / [Shift+F7] => Z Camera location : "+Str(CamLocateZ)) 
    DrawText(0,220,"[F8] / [Shift+F8] => X Camera look at : "+Str(CamLookAtX)) 
    DrawText(0,240,"[F9] / [Shift+F9] => Y Camera look at : "+Str(CamLookAtY)) 
    DrawText(0,260,"[F10] / [Shift+F10] => Z Camera look at : "+Str(CamLookAtZ)) 
    DrawText(0,280,"[F11] => Show or hide text") 
    DrawText(0,300,"[Space] => Halt") 
    StopDrawing() 
  EndIf 
  If KeyboardReleased(#PB_Key_F1) 
    If Mode.b:Mode=0:CameraRenderMode(0,#PB_Camera_Textured):Else:Mode=1:CameraRenderMode(0,#PB_Camera_Wireframe):EndIf 
  EndIf 
  If KeyboardReleased(#PB_Key_PageUp):WaveAmplitude+0.1:EndIf 
  If KeyboardReleased(#PB_Key_PageDown):WaveAmplitude-0.1:EndIf 
  If KeyboardReleased(#PB_Key_Up):WavePeriodZ+1:EndIf 
  If KeyboardReleased(#PB_Key_Down):WavePeriodZ-1:EndIf 
  If KeyboardReleased(#PB_Key_Left):WavePeriodX-1:EndIf 
  If KeyboardReleased(#PB_Key_Right):WavePeriodX+1:EndIf 
  If KeyboardReleased(#PB_Key_Home):WaveFrequency+1:EndIf 
  If KeyboardReleased(#PB_Key_End):WaveFrequency-1:EndIf 
  
  If KeyboardReleased(#PB_Key_F2) 
    If KeyboardPushed(#PB_Key_LeftShift) Or KeyboardPushed(#PB_Key_RightShift):xprot-0.1:Else:xprot+0.1:EndIf 
  EndIf 
  If KeyboardReleased(#PB_Key_F3) 
    If KeyboardPushed(#PB_Key_LeftShift) Or KeyboardPushed(#PB_Key_RightShift):yprot-0.1:Else:yprot+0.1:EndIf 
  EndIf 
  If KeyboardReleased(#PB_Key_F4) 
    If KeyboardPushed(#PB_Key_LeftShift) Or KeyboardPushed(#PB_Key_RightShift):zprot-0.1:Else:zprot+0.1:EndIf 
  EndIf 

  If KeyboardPushed(#PB_Key_F5) 
    If KeyboardPushed(#PB_Key_LeftShift) Or KeyboardPushed(#PB_Key_RightShift):CamLocateX-1:Else:CamLocateX+1:EndIf 
  EndIf 
  If KeyboardPushed(#PB_Key_F6) 
    If KeyboardPushed(#PB_Key_LeftShift) Or KeyboardPushed(#PB_Key_RightShift):CamLocateY-1:Else:CamLocateY+1:EndIf 
  EndIf 
  If KeyboardPushed(#PB_Key_F7) 
    If KeyboardPushed(#PB_Key_LeftShift) Or KeyboardPushed(#PB_Key_RightShift):CamLocateZ-1:Else:CamLocateZ+1:EndIf 
  EndIf 

  If KeyboardPushed(#PB_Key_F8) 
    If KeyboardPushed(#PB_Key_LeftShift) Or KeyboardPushed(#PB_Key_RightShift):CamLookAtX-1:Else:CamLookAtX+1:EndIf 
  EndIf 
  If KeyboardPushed(#PB_Key_F9) 
    If KeyboardPushed(#PB_Key_LeftShift) Or KeyboardPushed(#PB_Key_RightShift):CamLookAtY-1:Else:CamLookAtY+1:EndIf 
  EndIf 
  If KeyboardPushed(#PB_Key_F10) 
    If KeyboardPushed(#PB_Key_LeftShift) Or KeyboardPushed(#PB_Key_RightShift):CamLookAtZ-1:Else:CamLookAtZ+1:EndIf 
  EndIf 
  If KeyboardReleased(#PB_Key_F11):hidetext.b!1:EndIf 
  While KeyboardPushed(#PB_Key_Space):ExamineKeyboard():Wend 
  ProcedureReturn hidetext.b 
EndProcedure 

;-Mémoires Mesh 
*VertexID=AllocateMemory((#NbX+1)*(#NbZ+1)*SizeOf(vertex)) 
*FaceID=AllocateMemory(#NbX*#NbZ*4*SizeOf(DoubleFace)) 
Matrice(*VertexID,*FaceID,#NbX,#NbZ) 

;-Mesh 

CreateMesh(0,100) 
SetMeshData(0,#PB_Mesh_Vertex | #PB_Mesh_Normal | #PB_Mesh_UVCoordinate,*VertexID,(#NbX+1)*(#NbZ+1)) 
SetMeshData(0,#PB_Mesh_Face,*FaceID,(#NbX)*(#NbZ)*4) 

;-Texture 
CreateTexture(0, 256, 256) 
StartDrawing(TextureOutput(0)) 
DrawImage(ImageID(#Img_SnapShot),0,0) 
StopDrawing() 

;- MAterial 
CreateMaterial(0, TextureID(0)) ; Material 
MaterialShadingMode(0, #PB_Material_Phong) 
MaterialBlendingMode(0, #PB_Material_AlphaBlend) 
MaterialAmbientColor(0, RGB(255,55,55)) 
MaterialDiffuseColor(0, RGB(255,255,128)) 
MaterialSpecularColor(0,RGB(255,0,0)) 

;-Entity 
 CreateEntity(0,MeshID(0),MaterialID(0)) 

;-Camera 
CreateCamera(0,0,0,100,100) 
AmbientColor(RGB(95,95,95));<- Essential for clarity 

;Light 
CreateLight(0,RGB(255,255,128)) 
LightLocate(0,EntityX(0)/2,EntityY(0)+800,EntityZ(0)/2) 
;-Boucle principale 
Repeat 
  ClearScreen(0) 
  ExamineKeyboard() 
  
  CameraLocate(0,CamLocateX,CamLocateY,CamLocateZ) 
  CameraLookAt(0,CamLookAtX,CamLookAtY,CamLookAtZ) 

  ;Calculate (AngleVague+WaveFrequency)%360: (coz % operand doesn't accept floats) 
  !fild dword[v_circle] 
  !fld dword[v_AngleVague] 
  !fadd dword[v_WaveFrequency] 
  !fprem 
  !fstp dword[v_AngleVague] 
  !fstp st1 
  
  vagues(*VertexID,*FaceID) 
  xrot + xprot 
  yrot + yprot 
  zrot + zprot 
  RotateEntity(0,xrot,yrot,zrot) 
  RenderWorld() 
  hidetext.b=ShowTextAndKeyTest(hidetext.b) 
  FlipBuffers():Delay(7) 
Until KeyboardPushed(#PB_Key_Escape)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; DisableDebugger
