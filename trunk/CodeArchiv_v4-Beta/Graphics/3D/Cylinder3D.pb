; www.PureArea.net
; Author: Comtois
; Date: 30. April 2006
; OS: Windows
; Demo: Yes


;Comtois 30/04/06 
;PB4.0 Beta 11 


Resultat = MessageRequester("Cylindre 3D","Full Screen ?",#PB_MessageRequester_YesNo) 
If Resultat = 6      
  FullScreen=1 
Else            
  FullScreen=0 
EndIf 

;- Initialisation 
If InitEngine3D() = 0 
   MessageRequester( "Erreur" , "Impossible d'initialiser la 3D , vérifiez la présence de engine3D.dll" , 0 ) 
   End 
ElseIf InitSprite() = 0 Or InitKeyboard() = 0 
   MessageRequester( "Erreur" , "Impossible d'initialiser DirectX 7 Ou plus" , 0 ) 
   End 
EndIf 

If Fullscreen  
  OpenScreen(800,600,32,"Cylindre 3D") 
Else 
  OpenWindow(0,0, 0, 800 , 600 ,"Cylindre 3D",#PB_Window_ScreenCentered) 
  OpenWindowedScreen(WindowID(0),0,0, 800 , 600,0,0,0) 
EndIf 

Macro MaCouleur(Rouge,Vert,Bleu) 
  Rouge << 16 + Vert << 8 + Bleu 
EndMacro 


Global Angle.f,Pas.f, CameraMode.l 
Global *VBuffer,*IBuffer 
Global meridien.l 
meridien=90 

Structure Vertex 
   px.f 
   py.f 
   pz.f 
   nx.f 
   ny.f 
   nz.f 
   Couleur.l 
   U.f 
   V.f 
EndStructure 

Structure FTriangle 
   f1.w 
    f2.w 
    f3.w 
EndStructure 

Procedure CreateMeshCylindre(m,h.f) 
   ;m = méridien 
   ;h = hauteur 
   ;Le rayon est égal à 1 . 
    
   If m<3 
      ProcedureReturn 0 
   EndIf 
    

   h2.f = h / 2.0 
   NbSommet = 4*(m+1)+2 
   *VBuffer = AllocateMemory(SizeOf(Vertex)*Nbsommet) 
   *PtrV.Vertex = *VBuffer 
    
   ;Sommet en bas du cylindre 
   Coul = $FF ; Pas utilisé dans cette démo 
   For i = 0 To m 
      theta.f =2*#PI*i/m 
        
       *PtrV\px = Cos(theta) 
      *PtrV\py = -h2 
      *PtrV\pz = Sin(theta) 
       *PtrV\nx = *PtrV\px 
      *PtrV\ny = 0 
      *PtrV\nz = *PtrV\pz 
      *PtrV\couleur = Coul 
      *PtrV\u = Theta / (2.0*#PI) 
      *PtrV\v = 0 
      *PtrV + SizeOf(Vertex) 
   Next i    
    
   ;Sommet en haut du cylindre 
   For i = 0 To m 
      theta.f =2*#PI*i/m 
        
       *PtrV\px = Cos(theta) 
      *PtrV\py = h2 
      *PtrV\pz = Sin(theta) 
      *PtrV\nx = *PtrV\px 
      *PtrV\ny = 0 
      *PtrV\nz = *PtrV\pz 
      *PtrV\couleur = Coul 
      *PtrV\u = Theta / (2.0*#PI) 
      *PtrV\v = 1 
      *PtrV + SizeOf(Vertex) 
   Next i 
       
   ;Sommet face bas du cylindre 
   For i = 0 To m 
      theta.f =2*#PI*i/m 
        
       *PtrV\px = Cos(theta) 
      *PtrV\py = -h2 
      *PtrV\pz = Sin(theta) 
      *PtrV\nx = 0 
      *PtrV\ny = -1 
      *PtrV\nz = 0 
      *PtrV\couleur = Coul 
      *PtrV\u = Theta / (2.0*#PI) 
      *PtrV\v = 1 
      *PtrV + SizeOf(Vertex) 
   Next i 
              
   ;Sommet face haut du cylindre 
   For i = 0 To m 
      theta.f =2*#PI*i/m 
        
       *PtrV\px = Cos(theta) 
      *PtrV\py = h2 
      *PtrV\pz = Sin(theta) 
      *PtrV\nx = 0 
      *PtrV\ny = 1 
      *PtrV\nz = 0 
      *PtrV\couleur = Coul 
      *PtrV\u = Theta / (2.0*#PI) 
      *PtrV\v = 1 
      *PtrV + SizeOf(Vertex) 
   Next i 
    
   ;Centre bas 
    *PtrV\px = 0 
   *PtrV\py = -h2 
   *PtrV\pz = 0 
   *PtrV\nx = 0 
   *PtrV\ny = -1 
   *PtrV\nz = 0 
   *PtrV\couleur = Coul 
   *PtrV\u = 0.5 
   *PtrV\v = 0.5 
   *PtrV + SizeOf(Vertex) 

   ;Centre haut 
    *PtrV\px = 0 
   *PtrV\py = h2 
   *PtrV\pz = 0 
   *PtrV\nx = 0 
   *PtrV\ny = 1 
   *PtrV\nz = 0 
   *PtrV\couleur = Coul 
   *PtrV\u = 0.5 
   *PtrV\v = 0.5 
    
    
   ;Les facettes 
   NbTriangle = 4*m 
   *IBuffer=AllocateMemory(SizeOf(FTriangle)*NbTriangle) 
   *PtrF.FTriangle=*IBuffer 
    
   For i=0 To m-1 
       
      *PtrF\f3=i 
      *PtrF\f2=i + 1 
      *PtrF\f1=m + i + 2 
      *PtrF + SizeOf(FTriangle) 
      *PtrF\f1=i  
      *PtrF\f3=m + i + 2 
      *PtrF\f2=m + i + 1 
      *PtrF + SizeOf(FTriangle) 
   Next i 
    
   ;Face bas 
   For i=0 To m-1 
      *PtrF\f1= 4 * m + 4 
      *PtrF\f2= 2 * m + 2 + i 
      *PtrF\f3= 2 * m + 3 + i 
      *PtrF + SizeOf(FTriangle) 
   Next i       
    
   ;Face Haut    
   For i=0 To m-1 
      *PtrF\f1= 4 * m + 5 
      *PtrF\f3= 3 * m + 3 + i 
      *PtrF\f2= 3 * m + 4 + i 
      *PtrF + SizeOf(FTriangle) 
   Next i       

 If CreateMesh(0,100) 
      Flag = #PB_Mesh_Vertex | #PB_Mesh_Normal | #PB_Mesh_UVCoordinate | #PB_Mesh_Color  
      SetMeshData(0,Flag         ,*VBuffer,NbSommet) 
      SetMeshData(0,#PB_Mesh_Face,*IBuffer,NbTriangle) 
      ProcedureReturn 1 
   Else 
      ProcedureReturn 0    
   EndIf 
    
EndProcedure    


;-Mesh 
CreateMeshCylindre(meridien,1) 

;-Texture 
CreateTexture(0,128, 128) 
StartDrawing(TextureOutput(0)) 
  Box(0, 0, 128, 128, $FFFF00) 
StopDrawing()  

;-Material 
CreateMaterial(0,TextureID(0)) 


;-Entity 
CreateEntity(0,MeshID(0),MaterialID(0)) 
ScaleEntity(0,30,120,30) 

;-Camera 
CreateCamera(0, 0, 0 , 100 , 100) 
MoveCamera(0,0,0,-200) 
CameraLookAt(0,EntityX(0),EntityY(0),EntityZ(0)) 


;-Light 
AmbientColor(RGB(105,105,105)) 
CreateLight(0,RGB(255,255,55),EntityX(0)+150,EntityY(0),EntityZ(0)) 
CreateLight(1,RGB(55,255,255),EntityX(0)-150,EntityY(0),EntityZ(0)) 
CreateLight(2,RGB(55,55,255),EntityX(0),EntityY(0)+150,EntityZ(0)) 
CreateLight(3,RGB(255,55,255),EntityX(0),EntityY(0)-150,EntityZ(0)) 
pas = 0.8 
Repeat 
   ;ClearScreen(0) 
   If fullscreen = 0 
      While WindowEvent() : Wend 
   EndIf  
   Angle + Pas 
   RotateEntity(0,angle,angle/2,-Angle) 

   If ExamineKeyboard() 
     If KeyboardReleased(#PB_Key_F1) 
       CameraMode=1-CameraMode 
       CameraRenderMode(0,CameraMode) 
     EndIf 
   EndIf 
  RenderWorld() 
  FlipBuffers() 
Until KeyboardPushed(#PB_Key_Escape) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -