; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=4902&highlight=
; Author: DarkDragon (updated for PB 4.00 by Andre)
; Date: 04. August 2004
; OS: Windows
; Demo: No


; OpenGL-TextureLoader mit ImageLibrary

ProcedureDLL SF3DLoadTexture(Filename.s, TexFilter.l) ; Returns the texture for an OpenGL application 
  If LCase(GetExtensionPart(Filename.s)) = "jpg" 
    UseJPEGImageDecoder() 
  ElseIf LCase(GetExtensionPart(Filename.s)) = "png" 
    UsePNGImageDecoder() 
  EndIf 
  img = LoadImage(#PB_Any, Filename.s) 
  Width.l=ImageWidth(img) 
  Height.l=ImageHeight(img)  
  Size.l=Width * Height 
  
  Dim ImageData.b(Size*3) 
  
  StartDrawing(ImageOutput(img)) 
  For Y=0 To Height-1 
    For X=0 To Width-1 
      
      Color = Point(X,Y) 
      ImageData(i)=Red(Color) 
      i+1 
      ImageData(i)=Green(Color) 
      i+1 
      ImageData(i)=Blue(Color) 
      i+1 
    
    Next 
  Next 
  StopDrawing() 
  
  glGenTextures_(1, @Tex) ;Textur speichern 
  If TexFilter = 0 ;versch. Textur-Filter 
    glBindTexture_($0DE1, Tex) 
    glTexParameteri_($0DE1, $2800, $2600) 
    glTexParameteri_($0DE1, $2801, $2600) 
    glTexImage2D_($0DE1, 0, 6407, Width, Height, 0, 6407, $1401, @ImageData()) 
  ElseIf TexFilter = 1 
    glBindTexture_($0DE1, Tex) 
    glTexParameteri_($0DE1, $2800, $2601) 
    glTexParameteri_($0DE1, $2801, $2601) 
    glTexImage2D_($0DE1, 0, 6407, Width, Height, 0, 6407, $1401, @ImageData()) 
  ElseIf TexFilter = 2 
    glBindTexture_($0DE1, Tex) 
    glTexParameteri_($0DE1, $2800, $2601) 
    glTexParameteri_($0DE1, $2801, $2701) 
    gluBuild2DMipmaps_($0DE1, 3, Width, Height, 6407, $1401, @ImageData()) 
  EndIf 
  FreeImage(img) 
  ProcedureReturn Tex 
EndProcedure 

ProcedureDLL SF3DCatchTexture(*Memory, TexFilter.l) ; Returns the texture for an OpenGL application 
  img = CatchImage(#PB_Any, *Memory) 
  Width.l=ImageWidth(img) 
  Height.l=ImageHeight(img)  
  Size.l=Width * Height 
  
  Dim ImageData.b(Size*3) 
  
  StartDrawing(ImageOutput(img)) 
  For Y=0 To Height-1 
    For X=0 To Width-1 
      
      Color = Point(X,Y) 
      ImageData(i)=Red(Color) 
      i+1 
      ImageData(i)=Green(Color) 
      i+1 
      ImageData(i)=Blue(Color) 
      i+1 
    
    Next 
  Next 
  StopDrawing() 
  
  glGenTextures_(1, @Tex) ;Textur speichern 
  If TexFilter = 0 ;versch. Textur-Filter 
    glBindTexture_($0DE1, Tex) 
    glTexParameteri_($0DE1, $2800, $2600) 
    glTexParameteri_($0DE1, $2801, $2600) 
    glTexImage2D_($0DE1, 0, 6407, Width, Height, 0, 6407, $1401, @ImageData()) 
  ElseIf TexFilter = 1 
    glBindTexture_($0DE1, Tex) 
    glTexParameteri_($0DE1, $2800, $2601) 
    glTexParameteri_($0DE1, $2801, $2601) 
    glTexImage2D_($0DE1, 0, 6407, Width, Height, 0, 6407, $1401, @ImageData()) 
  ElseIf TexFilter = 2 
    glBindTexture_($0DE1, Tex) 
    glTexParameteri_($0DE1, $2800, $2601) 
    glTexParameteri_($0DE1, $2801, $2701) 
    gluBuild2DMipmaps_($0DE1, 3, Width, Height, 6407, $1401, @ImageData()) 
  EndIf 
  FreeImage(img) 
  ProcedureReturn Tex 
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -