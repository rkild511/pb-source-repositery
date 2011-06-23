; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7217&highlight=
; Author: LJ (updated for PB4.00 by benny)
; Date: 14. August 2003
; OS: Windows
; Demo: Yes

; Older threads are here:
; .MESH Editor Open Source version 0.01+ (http://purebasic.myforums.net/viewtopic.php?t=7182&highlight=)
; .MESH Editor version 1                 (http://purebasic.myforums.net/viewtopic.php?t=7209&highlight=)
 
; *** Must be copied to directory "PureBasic\Examples\Sources\" to find all include and image files!!!! ***
 
; ------------------------------------------------------------ 
; 
;   .MESH  Editor version 2 
;   Open Source 
;   8/13/03 
;   Programmer: 
;   Lance Jepsen 
;   (c) 2003 
; ------------------------------------------------------------ 
; Feel free to add on and improve. 
; INSTRUCTIONS: Select a vertice letter to edit, then select 
; a value. 


UseJPEGImageDecoder()
 
#CameraSpeed = 5 
 

Procedure DrawScreen() 
  ClearScreen(RGB(0, 0, 0))
  Shared b()
  RenderWorld() 
  
  StartDrawing(ScreenOutput()) 
  DrawingMode(1) 
  FrontColor(RGB(255,255,255))
  ;Locate(0, 0) 
  DrawText(0,0,"Vertices: ") 
  Dim a.f(24) 
  Restore CubeVertices 
  For t = 1 To 24 
    Read a(t) 
  Next 
  Global Dim b.s(24) 
  For t = 1 To 24 
    b(t)=Str(a(t)) 
  Next 
  DrawText(0, 15,"A = "+b(1)+", B = "+b(2)+", C = "+b(3)) 
  DrawText(0, 30,"D = "+b(4)+", E = "+b(5)+", F = "+b(6)) 
  DrawText(0, 45,"G = "+b(7)+", H = "+b(8)+", I = "+b(9)) 
  DrawText(0, 60,"J = "+b(10)+", K = "+b(11)+", L = "+b(12)) 
  DrawText(0, 75,"M = "+b(13)+", N = "+b(14)+", O = "+b(15)) 
  DrawText(0, 90,"P = "+b(16)+", Q = "+b(17)+", R = "+b(18)) 
  DrawText(0,105,"S = "+b(19)+", T = "+b(20)+", U = "+b(21)) 
  DrawText(0,120,"V = "+b(22)+", W = "+b(23)+", X = "+b(24)) 
  StopDrawing() 
  
  FlipBuffers() 

EndProcedure 
 

Define.f KeyX, KeyY, MouseX, MouseY
 
     
If InitEngine3D() 
  
  InitSprite() 
 
  If OpenWindow(0, 256, 0, 544, 600,"", #PB_Window_BorderLess) 
    If OpenWindowedScreen(WindowID(0), 0, 0, 540, 600, 0, 0, 0) 
       OpenWindow(2,0,0,250,590,".Mesh Editor version 1 by Lance Jepsen",#PB_Window_TitleBar) 
          CreateGadgetList(WindowID(2))    
           ComboBoxGadget(1,10,50,200,100) 
            AddGadgetItem(1,-1,"Select Vertice") 
            AddGadgetItem(1,-1,"A") 
            AddGadgetItem(1,-1,"B") 
            AddGadgetItem(1,-1,"C") 
            AddGadgetItem(1,-1,"D") 
            AddGadgetItem(1,-1,"E") 
            AddGadgetItem(1,-1,"F") 
            AddGadgetItem(1,-1,"G") 
            AddGadgetItem(1,-1,"H") 
            AddGadgetItem(1,-1,"I") 
            AddGadgetItem(1,-1,"J") 
            AddGadgetItem(1,-1,"K") 
            AddGadgetItem(1,-1,"L") 
            AddGadgetItem(1,-1,"M") 
            AddGadgetItem(1,-1,"N") 
            AddGadgetItem(1,-1,"O") 
            AddGadgetItem(1,-1,"P") 
            AddGadgetItem(1,-1,"Q") 
            AddGadgetItem(1,-1,"R") 
            AddGadgetItem(1,-1,"S") 
            AddGadgetItem(1,-1,"T") 
            AddGadgetItem(1,-1,"U") 
            AddGadgetItem(1,-1,"V") 
            AddGadgetItem(1,-1,"W") 
            AddGadgetItem(1,-1,"X") 
            
            SetGadgetState(1,0) 
           SpinGadget(2,10, 150, 100, 30, 0, 10) 
           SetGadgetText(2,"0")   ; set initial value 
            
           ButtonGadget(4, 10, 30, 200, 20, "Quit") 
           ButtonGadget(5, 10, 200, 200, 20, "Rotate Left") 
           ButtonGadget(6, 10, 230, 200, 20, "Rotate Right") 
           ButtonGadget(7, 10, 260, 200, 20, "Rotate Up") 
           ButtonGadget(8, 10, 290, 200, 20, "Rotate Down") 
           ButtonGadget(9, 10, 320, 200, 20, "Zoom In") 
           ButtonGadget(10, 10,350,200,20,"Zoom Out") 
           ButtonGadget(11, 10,380,200,20,"Move Up") 
           ButtonGadget(12, 10,410,200,20,"Move Down") 
           ButtonGadget(13, 10,440,200,20,"Export to PB Code") 
            
 
    CreateMesh(0, 10000) 
    SetMeshData(0, 0, ?CubeVertices          , 8) 
    SetMeshData(0, 1, ?CubeFacesIndexes      , 12) 
    SetMeshData(0, 2, ?CubeTextureCoordinates, 8) 
 
    CreateEntity(0, MeshID(0), CreateMaterial(0, LoadTexture(0, "Data/clouds.jpg"))) 
    
    ScaleEntity(0, 3, 3, 3) 
    
    CreateCamera(0, 0, 0, 100, 100) 
    CameraLocate(0,0,0,20) 
    CameraRenderMode(0, #PB_Camera_Wireframe) 
    
    Repeat 
      EventID = WaitWindowEvent() 
      If EventID = #PB_Event_Gadget 
        Select EventGadget() 
          Case 1 ; Set spin gadget to value of vertice 
            vert$ = GetGadgetText(1) 
            targ$= GetGadgetText(2) 
            If vert$ = "A" 
              temp.b = 0 
            EndIf 
            If vert$ = "B" 
              temp.b = 4 
            EndIf 
            If vert$ = "C" 
              temp.b = 8 
            EndIf 
            If vert$ = "D" 
              temp.b = 12 
            EndIf 
            If vert$ = "E" 
              temp.b = 16 
            EndIf 
            If vert$ = "F" 
              temp.b = 20 
            EndIf 
            If vert$ = "G" 
              temp.b = 24 
            EndIf 
            If vert$ = "H" 
              temp.b = 28 
            EndIf 
            If vert$ = "I" 
              temp.b = 32 
            EndIf 
            If vert$ = "J" 
              temp.b = 36 
            EndIf 
            If vert$ = "K" 
              temp.b = 40 
            EndIf 
            If vert$ = "L" 
              temp.b = 44 
            EndIf 
            If vert$ = "M" 
              temp.b = 48 
            EndIf 
            If vert$ = "N" 
              temp.b = 52 
            EndIf 
            If vert$ = "O" 
              temp.b = 56 
            EndIf 
            If vert$ = "P" 
              temp.b = 60 
            EndIf 
            If vert$ = "Q" 
              temp.b = 64 
            EndIf 
            If vert$ = "R" 
              temp.b = 68 
            EndIf 
            If vert$ = "S" 
              temp.b = 72 
            EndIf 
            If vert$ = "T" 
              temp.b = 76 
            EndIf 
            If vert$ = "U" 
              temp.b = 80 
            EndIf 
            If vert$ = "V" 
              temp.b = 84 
            EndIf 
            If vert$ = "W" 
              temp.b = 88 
            EndIf 
            If vert$ = "X" 
              temp.b = 92 
            EndIf 
            flag.f = PeekF(?CubeVertices+temp)  
            SetGadgetState(2,flag) 
            flag$=Str(flag) 
            SetGadgetText(2,flag$) 
      
          Case 13 
            StandardFile$ = "C:\"   ; set initial file+path to display 
            ; With next string we will set the search patterns ("|" as separator) for file displaying: 
            ;  1st: "Text (*.txt)" as name, ".txt" and ".bat" as allowed extension
            ;  2nd: "PureBasic (*.pb)" as name, ".pb" as allowed extension 
            ;  3rd: "All files (*.*) as name, "*.*" as allowed extension, valid for all files 
            Pattern$ = "PureBasic (*.pb)|*.pb|All files (*.*)|*.*" 
            Pattern = 0    ; use the first of the three possible patterns as standard 
            File$ = SaveFileRequester("Please choose file to save", StandardFile$, Pattern$, Pattern) 
            If UCase(Right(File$,4)) <> ".PB" 
              File$+".pb" 
            EndIf 
       
            OpenFile(1, File$) 
              WriteStringN(1,"#CameraSpeed = 5") 
              WriteStringN(1,"IncludeFile "+Chr(34)+"Screen3DRequester.pb"+Chr(34))
              WriteStringN(1,"DefType.f KeyX, KeyY, MouseX, MouseY") 
              WriteStringN(1,"If InitEngine3D()") 
              WriteStringN(1,"  Add3DArchive("+Chr(34)+"Data\"+Chr(34)+"          , #PB_3DArchive_FileSystem)") 
              WriteStringN(1,"  Add3DArchive("+Chr(34)+"Data\Skybox.zip"+Chr(34)+", #PB_3DArchive_Zip)") 
              WriteStringN(1,"  InitSprite()") 
              WriteStringN(1,"InitKeyboard()") 
              WriteStringN(1,"InitMouse()") 
              WriteStringN(1," If Screen3DRequester()") 
              WriteStringN(1," CreateMesh(0)") 
              WriteStringN(1,"    SetMeshData(0, 0, ?CubeVertices          , 8)") 
              WriteStringN(1,"   SetMeshData(0, 1, ?CubeFacesIndexes      , 12)") 
              WriteStringN(1,"    SetMeshData(0, 2, ?CubeTextureCoordinates, 8)") 
              WriteStringN(1,"    CreateEntity(0, MeshID(0), CreateMaterial(0, LoadTexture(0, "+Chr(34)+"Data/clouds.jpg"+Chr(34)+")))") 
              WriteStringN(1,"   ScrollMaterial(0, 0.2, 0.2, 1)") 
              WriteStringN(1,"   ScaleEntity(0, 3, 3, 3)") 
              WriteStringN(1,"   CreateCamera(0, 0, 0, 100, 100)") 
              WriteStringN(1,"    CameraLocate(0,0,0,20)") 
              WriteStringN(1,"    Repeat") 
              WriteStringN(1,"      Screen3DEvents()") 
              WriteStringN(1,"      ClearScreen(0, 0, 0)") 
              WriteStringN(1,"      If ExamineKeyboard()") 
              WriteStringN(1,"        If KeyboardPushed(#PB_Key_Left)") 
              WriteStringN(1,"          KeyX = -#CameraSpeed ") 
              WriteStringN(1,"        ElseIf KeyboardPushed(#PB_Key_Right)") 
              WriteStringN(1,"          KeyX = #CameraSpeed ") 
              WriteStringN(1,"        Else") 
              WriteStringN(1,"         KeyX = 0") 
              WriteStringN(1,"        EndIf") 
              WriteStringN(1,"        If KeyboardPushed(#PB_Key_Up)") 
              WriteStringN(1,"          KeyY = -#CameraSpeed") 
              WriteStringN(1,"        ElseIf KeyboardPushed(#PB_Key_Down)") 
              WriteStringN(1,"          KeyY = #CameraSpeed ") 
              WriteStringN(1,"        Else") 
              WriteStringN(1,"          KeyY = 0") 
              WriteStringN(1,"        EndIf") 
              WriteStringN(1,"      EndIf") 
              WriteStringN(1,"      If ExamineMouse()") 
              WriteStringN(1,"      MouseX = -(MouseDeltaX()/10)*#CameraSpeed/2") 
              WriteStringN(1,"       MouseY = -(MouseDeltaY()/10)*#CameraSpeed/2") 
              WriteStringN(1,"      EndIf") 
              WriteStringN(1,"      RotateEntity(0, 1, 1, 1)") 
              WriteStringN(1,"      RotateCamera(0, MouseX, MouseY, RollZ)") 
              WriteStringN(1,"      MoveCamera  (0, KeyX, 0, KeyY)") 
              WriteStringN(1,"      RenderWorld()") 
              WriteStringN(1,"      Screen3DStats()")    
              WriteStringN(1,"      FlipBuffers()") 
              WriteStringN(1,"    Until KeyboardPushed(#PB_Key_Escape) Or Quit = 1")
              WriteStringN(1,"  EndIf") 
              WriteStringN(1," Else") 
              WriteStringN(1,"  MessageRequester("+Chr(34)+"Error"+Chr(34)+", "+Chr(34)+"The 3D Engine can't be initialized"+Chr(34)+",0)") 
              WriteStringN(1," EndIf") 
              WriteStringN(1," End") 
              WriteStringN(1,"DataSection") 
              WriteStringN(1,"") 
              WriteStringN(1,"CubeVertices:") 
              WriteStringN(1,"Data.f "+b(1)+", "+b(2)+", "+b(3)) 
              WriteStringN(1,"Data.f "+b(4)+", "+b(5)+", "+b(6)) 
              WriteStringN(1,"Data.f "+b(7)+", "+b(8)+", "+b(9)) 
              WriteStringN(1,"Data.f "+b(10)+", "+b(11)+", "+b(12)) 
              WriteStringN(1,"Data.f "+b(13)+", "+b(14)+", "+b(15)) 
              WriteStringN(1,"Data.f "+b(16)+", "+b(17)+", "+b(18)) 
              WriteStringN(1,"Data.f "+b(19)+", "+b(20)+", "+b(21)) 
              WriteStringN(1,"Data.f "+b(22)+", "+b(23)+", "+b(24))            
              WriteStringN(1," CubeFacesIndexes:") 
              WriteStringN(1," Data.w 0, 1, 2 ; bottom face (clockwise as it's reversed...)") 
              WriteStringN(1," Data.w 2, 3, 0 ") 
              WriteStringN(1," Data.w 6, 5, 4 ; top face") 
              WriteStringN(1," Data.w 4, 7, 6") 
              WriteStringN(1," Data.w 1, 5, 6 ; right face") 
              WriteStringN(1," Data.w 6, 2, 1") 
              WriteStringN(1," Data.w 7, 4, 0 ; left face") 
              WriteStringN(1," Data.w 0, 3, 7") 
              WriteStringN(1," Data.w 5, 1, 0 ; back face") 
              WriteStringN(1," Data.w 0, 4, 5") 
              WriteStringN(1," Data.w 2, 6, 7 ; front face") 
              WriteStringN(1," Data.w 7, 3, 2") 
              WriteStringN(1," CubeTextureCoordinates:") 
              WriteStringN(1," Data.f 0   , 0.33 ; Vertex 0") 
              WriteStringN(1," Data.f 0.33, 0.33 ; Vertex 1") 
              WriteStringN(1," Data.f 0.33, 0    ; Vertex 2") 
              WriteStringN(1," Data.f 0,    0    ; Vertex 3") 
              WriteStringN(1," Data.f 0.66, 1    ; Vertex 4") 
              WriteStringN(1," Data.f 1,  1   ; Vertex 5") 
              WriteStringN(1," Data.f 1,    0.66 ; Vertex 6") 
              WriteStringN(1," Data.f 0.66, 0.66 ; Vertex 7") 
              WriteStringN(1," EndDataSection") 
                
              CloseFile(1) 
                
            
          Case 12 
            MoveCamera  (0, 0, 0.1, 0)    
            DrawScreen()          
            
            
          Case 11 
            MoveCamera  (0, 0, -0.1, 0)    
            DrawScreen() 
            
          Case 10 
            MoveCamera  (0, 0, 0,0.2) 
            DrawScreen() 
        
                
          Case 9 
            MoveCamera  (0, 0, 0,-0.2) 
            DrawScreen() 
          
                
          Case 8 
            RotateEntity(0, 0, 1, 0) 
            DrawScreen()      
                
          Case 7 
            RotateEntity(0, 0, -1, 0) 
            DrawScreen() 
                    
          Case 6 
            RotateEntity(0, 1, 0, 0) 
            DrawScreen()      
                
          Case 5 
            RotateEntity(0, -1, 0, 0) 
            DrawScreen() 
                
                
          Case 4 
            End 
                
                
          Case 2 
            SetGadgetText(2,Str(GetGadgetState(2))) 
            WindowEvent() 
            vert$ = GetGadgetText(1) 
            targ$= GetGadgetText(2) 
            target.f = Val(targ$) 
            PokeF(?CubeVertices+temp, target) 
            SetMeshData(0, 0, ?CubeVertices          , 8) 
            DrawScreen() 
     
            
              
        EndSelect 
      EndIf 
    Until EventID = #PB_Event_CloseWindow 
    End 
      
      
    EndIf 
  EndIf 
EndIf 
 
  
End 
 

DataSection 
 
  CubeVertices: 
    Data.f 0, 0, 0 ; Vertex index 0 
    Data.f 1, 0, 0 ; Vertex index 1 
    Data.f 1, 0, 1 ; Vertex index 2 
    Data.f 0, 0, 1 ; Vertex index 3 
 
    Data.f 0, 1, 0 ; Vertex index 4 - Note: exactly the same as above, but with 'y' 
    Data.f 1, 1, 0 ; Vertex index 5 
    Data.f 1, 1, 1 ; Vertex index 6 
    Data.f 0, 1, 1 ; Vertex index 7 
 
  CubeFacesIndexes: 
    Data.w 0, 1, 2 ; bottom face (clockwise as it's reversed...) 
    Data.w 2, 3, 0 
    Data.w 6, 5, 4 ; top face 
    Data.w 4, 7, 6 
    Data.w 1, 5, 6 ; right face 
    Data.w 6, 2, 1 
    Data.w 7, 4, 0 ; left face 
    Data.w 0, 3, 7 
    Data.w 5, 1, 0 ; back face 
    Data.w 0, 4, 5 
    Data.w 2, 6, 7 ; front face 
    Data.w 7, 3, 2 
 
  CubeTextureCoordinates: 
    Data.f 0   , 0.33 ; Vertex 0 
    Data.f 0.33, 0.33 ; Vertex 1 
    Data.f 0.33, 0    ; Vertex 2 
    Data.f 0,    0    ; Vertex 3 
 
    Data.f 0.66, 1    ; Vertex 4 
    Data.f 1,    1    ; Vertex 5 
    Data.f 1,    0.66 ; Vertex 6 
    Data.f 0.66, 0.66 ; Vertex 7 
      
EndDataSection 
 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
