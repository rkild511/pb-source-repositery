; www.PureArea.net 
; Author: jammin (updated for PB 4.00 by Deeem2031)
; Date: 26. November 2003 
; OS: Windows
; Demo: No

;Texturdemo 
;quick and dirty hacked version 
;programmed with Purebasic by jammin 
;load textures with the buildin decoders of Purebasic :) ) 
;for the moment all textures must have the size of 2^n * 2^n ! 
;email : tmpa@gmx.de 
Global width.l 
Global height.l 
Global start.b 
Global opengl.l 
IncludeFile "..\..\..\Includes+Macros\Includes\OpenGL\OpenGL.pbi"

UseJPEGImageDecoder() 

;try the other formats! 

;UsePNGImageDecoder() 
;UseTIFFImageDecoder() 
;UseTGAImageDecoder() 

Procedure DrawCube2() 
  
 glBegin_(#GL_Quads) 
  
        One.f = 1.0 
        Null.f = 0.0 
        Minus.f = -1.0 
        One1.f = 1.50 
        Minus1.f = -1.0 
        
        glNormal3f_( minus, null, null ) 
        glTexCoord2f_( null, null ) : glVertex3f_( minus1,minus1, one1 ) 
        glTexCoord2f_( one, null ) : glVertex3f_(  one1,minus1, one1 ) 
        glTexCoord2f_( one, one ) : glVertex3f_(  one1, one1, one1 ) 
        glTexCoord2f_( null, one ) : glVertex3f_( minus1, one1, one1 ) 
        
 glEnd_() 
  
EndProcedure 



Procedure _CreateTexture(pData.l) 


  If pData = 0 
    MessageBox_(0, "unable to load texture", ":textureLib", #MB_OK | #MB_ICONERROR) 
  Else 

    glGenTextures_(1, @texture) 
    glBindTexture_(#GL_TEXTURE_2D, texture) 
    glTexEnvi_(#GL_TEXTURE_ENV, #GL_TEXTURE_ENV_MODE, #GL_DECAL) 
    glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MIN_FILTER, #GL_LINEAR)  ; all of the above can be used 
  
  EndIf 


  glTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGB, width, height, 0, #GL_RGB, #GL_UNSIGNED_BYTE, pData)   ; Use when not wanting mipmaps to be built by openGL 


 ProcedureReturn texture 

EndProcedure 


Procedure loadTextureMem(memloc.l) 
  
  img=CatchImage(0, ?opengl) 

  width.l=ImageWidth(0) 
  height.l=ImageWidth(0)  
  size.l=ImageWidth(0) * ImageHeight(0) 

  Dim bitmapImage.b (size.l*3) ;memorysize for rgb colors 


  CreateImage(1,width ,height ) 

  StartDrawing(ImageOutput(0)) 
  DrawImage(img,0,0)  


   For y=0 To height-1 
      For x=0 To width-1 
        
        color=Point(x,y)    
        bitmapImage(i)=Red(color) 
        i=i+1 
        bitmapImage(i)=Green(color) 
        i=i+1 
        bitmapImage(i)=Blue(color) 
        i=i+1 
      
      Next 
    Next 
  
   StopDrawing() 
  
  ; create texture 
  texture = _CreateTexture(bitmapImage()) 

  

  ProcedureReturn texture 

  ;clear memory 
  FreeImage(img) 
  Dim bitmapImage.b(0) 

EndProcedure 



Procedure HandleError (Result, Text$) 
 If Result = 0 
   MessageRequester("Error", Text$, 0) 
   End 
 EndIf 
EndProcedure 

Procedure DrawScene(hdc) 
  
   If start=0 
  
    glMatrixMode_(#GL_PROJECTION) 
    glLoadIdentity_() 
    ;gluPerspective_(45.0, 640.0/480.0, 1.0, 100.0) 
    p1.d = 45.0 
    p2.d = 640.0/480.0 
    p3.d = 1.0 
    p4.d = 100.0 
    gluPerspective_(p1,PeekF(@p1+4), p2,PeekF(@p2+4) ,p3,PeekF(@p3+4), p4,PeekF(@p4+4)) 
    glMatrixMode_(#GL_MODELVIEW) 

    opengl= LoadTextureMem(?opengl) 
    
    start=1 
  
   EndIf 
  

  glEnable_(#GL_DEPTH_TEST); 
  glDepthFunc_(#GL_LEQUAL); 
  glShadeModel_(#GL_SMOOTH) 
  glClearColor_( 0.0, 0.0, 0.0, 0.0 ) 
  glClear_(#GL_COLOR_BUFFER_BIT); 
  glClear_(#GL_DEPTH_BUFFER_BIT) 
  glMatrixMode_(#GL_MODELVIEW) 
  glLoadIdentity_();            
    
  glEnable_(#GL_TEXTURE_2D) 

      glTranslatef_(-0.3,-0.20,-6.0) 
      glBindTexture_(#GL_TEXTURE_2D, opengl) 
    
      drawcube2() 
  
      glDisable_(#GL_TEXTURE_2D) 
  
  SwapBuffers_(hdc) 
  
EndProcedure 

pfd.PIXELFORMATDESCRIPTOR 

FlatMode = 0 ; Enable Or disable the 'Flat' rendering 

WindowWidth = 640 ; The window & GLViewport dimensions 
WindowHeight = 480 


hWnd = OpenWindow(0, 0, 0, WindowWidth, WindowHeight, "EchtZeit Texturdemo", #PB_Window_SystemMenu) 

hdc = GetDC_(hWnd) 

pfd\nSize = SizeOf(PIXELFORMATDESCRIPTOR) 
pfd\nVersion = 1 
pfd\dwFlags = #PFD_SUPPORT_OPENGL | #PFD_DOUBLEBUFFER | #PFD_DRAW_TO_WINDOW 
pfd\dwLayerMask = #PFD_MAIN_PLANE 
pfd\iPixelType = #PFD_TYPE_RGBA 
pfd\cColorBits = 24 
pfd\cDepthBits = 16 

pixformat = ChoosePixelFormat_(hdc, pfd) 

HandleError( SetPixelFormat_(hdc, pixformat, pfd), "SetPixelFormat()") 

hrc = wglCreateContext_(hdc) 

HandleError( wglMakeCurrent_(hdc,hrc), "vglMakeCurrent()") 

HandleError( glViewport_ (0, 0, WindowWidth, WindowHeight), "GLViewPort()") 

While Quit = 0 
  
  Repeat 
    EventID = WindowEvent() 
    
    Select EventID 
      Case #PB_Event_CloseWindow 
        Quit = 1 
    EndSelect 
  
  Until EventID = 0 
  
  DrawScene(hdc) 
Wend 

DataSection 
opengl: 
  IncludeBinary "texture6.jpg"
EndDataSection
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger