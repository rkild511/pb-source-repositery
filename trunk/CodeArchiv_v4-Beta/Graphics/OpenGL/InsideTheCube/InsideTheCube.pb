; www.PureArea.net 
; Author: jammin (updated for PB 4.00 by hardfalcon)
; Date: 01. August 2003 
; OS: Windows
; Demo: No

;Inside the cube 
;programmed with Purebasic by jammin 
;24 bit loadBMPTextureMem Function by traumatic (a little bit changed :) ) 

;Remark by hardfalcon: Needs traumatic's glWrapper userlib! 

Global start.b 
Global sstart.b 
Global rueck.b 
Global timer.f 
Global blend.f 
Global t1.f 
Global opengl.l 
Global background.l 
IncludeFile "..\..\..\Includes+Macros\Includes\OpenGL\OpenGL.pbi"

Procedure DrawCube() 
  
  glBegin_(#GL_Quads) 
  glColor3f_(0.0,0.0,0.0) 
  glVertex3f_( -1.0,-0.1, 1.0 ) 
  glVertex3f_(  3.5,-0.1, 1.0 ) 
  glVertex3f_(  3.5, 1.0, 1.0 ) 
  glVertex3f_( -1.0, 1.0, 1.0 ) 
  glEnd_() 
  
EndProcedure 

Procedure DrawCube2() 
  
  glBegin_(#GL_Quads) 
  
  One.f = 1.0 
  Null.f = 0.0 
  Minus.f = -1.0 
  One1.f = 1.0 
  Minus1.f = -1.0 
  
  glNormal3f_( minus, null, null ) 
  glTexCoord2f_( null, null ) : glVertex3f_( minus1,minus1, one1 ) 
  glTexCoord2f_( one, null ) : glVertex3f_(  one1,minus1, one1 ) 
  glTexCoord2f_( one, one ) : glVertex3f_(  one1, one1, one1 ) 
  glTexCoord2f_( null, one ) : glVertex3f_( minus1, one1, one1 ) 
  glEnd_() 
  
EndProcedure 



Procedure _CreateTexture(pData.l, mode.s, mipmapping.b, bmpWidth.l, bmpHeight.l) 
  
  If pData = 0 
    MessageBox_(0, "unable to load texture", ":textureLib", #MB_OK | #MB_ICONERROR) 
  Else 
    
    glGenTextures_(1, @texture) 
    glBindTexture_(#GL_TEXTURE_2D, texture) 
    ;glTexEnvi_(#GL_TEXTURE_ENV, #GL_TEXTURE_ENV_MODE, #GL_MODULATE)       ; Texture blends with object background 
    glTexEnvi_(#GL_TEXTURE_ENV, #GL_TEXTURE_ENV_MODE, #GL_DECAL)         ; Texture does NOT blend with object background 
    
    ; Select a filtering type. BiLinear filtering produces very good results with little performance impact 
    ;   #GL_NEAREST               - Basic texture (grainy looking texture) 
    ;   #GL_LINEAR                - BiLinear filtering 
    ;   #GL_LINEAR_MIPMAP_NEAREST - Basic mipmapped texture 
    ;   #GL_LINEAR_MIPMAP_LINEAR  - BiLinear Mipmapped texture 
    
    ;glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MAG_FILTER, #GL_LINEAR)  ; only first two can be used 
    
    If mipmapping = 1 
      glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MIN_FILTER, #GL_LINEAR_MIPMAP_LINEAR)  ; all of the above can be used 
    Else 
      glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MIN_FILTER, #GL_LINEAR)  ; all of the above can be used 
    EndIf 
    
    
    Select mode 
    Case LCase("rgb") 
      If mipmapping = 1 
        gluBuild2DMipmaps_(#GL_TEXTURE_2D, #GL_RGB, bmpWidth, bmpHeight, #GL_RGB, #GL_UNSIGNED_BYTE, pData): 
      Else 
        glTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGB, bmpWidth, bmpHeight, 0, #GL_RGB, #GL_UNSIGNED_BYTE, pData)   ; Use when not wanting mipmaps to be built by openGL 
      EndIf 
      
    Case LCase("rgba") 
      If mipmapping = 1 
        gluBuild2DMipmaps_(#GL_TEXTURE_2D, #GL_RGBA, bmpWidth, bmpHeight, #GL_RGBA, #GL_UNSIGNED_BYTE, pData)   ; 
      Else 
        glTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGBA, bmpWidth, bmpHeight, 0, #GL_RGBA, #GL_UNSIGNED_BYTE, pData)   ; Use when not wanting mipmaps to be built by openGL 
      EndIf 
      
    Case LCase("luminance") 
      If mipmapping = 1 
        gluBuild2DMipmaps_(#GL_TEXTURE_2D, #GL_LUMINANCE, bmpWidth, bmpHeight, #GL_LUMINANCE, #GL_UNSIGNED_BYTE, pData) 
      Else 
        glTexImage2D_(#GL_TEXTURE_2D, 0, #GL_LUMINANCE, bmpWidth, bmpHeight, 0, #GL_LUMINANCE, #GL_UNSIGNED_BYTE, pData)   ; Use when not wanting mipmaps to be built by openGL 
      EndIf 
      
    EndSelect 
    
  EndIf 
  ProcedureReturn texture 
EndProcedure 


Procedure loadBMPTextureMem(memloc.l, mode.s, depth.b, mipmapping.b) 
  FileHeader.BITMAPFILEHEADER 
  InfoHeader.BITMAPINFOHEADER 
  
  ; read the bitmap file header 
  FileHeader\bfType                 = PeekW(memloc +0) ;2 
  FileHeader\bfSize                 = PeekL(memloc +2) ;4 
  FileHeader\bfReserved1            = PeekW(memloc +6) ;2 
  FileHeader\bfReserved2            = PeekW(memloc +8) ;2 
  FileHeader\bfOffBits              = PeekL(memloc+10) ;4 
  
  ; check if it's a valid bmp-file 
  If FileHeader\bfType <> $4D42 
    MessageBox_(0, "invalid bmpfile @"+Str(memlocation), "error?!", #MB_OK) 
    ProcedureReturn 0 
  EndIf 
  
  
  ; read the bitmap information header 
  InfoHeader\biSize          = PeekL(memloc+14) ;4 
  InfoHeader\biWidth         = PeekL(memloc+18) ;4 
  InfoHeader\biHeight        = PeekL(memloc+22) ;4 
  InfoHeader\biPlanes        = PeekW(memloc+26) ;2 
  InfoHeader\biBitCount      = PeekW(memloc+28) ;2 
  InfoHeader\biCompression   = PeekL(memloc+30) ;4 
  InfoHeader\biSizeImage     = PeekL(memloc+34) ;4 
  InfoHeader\biXPelsPerMeter = PeekL(memloc+38) ;4 
  InfoHeader\biYPelsPerMeter = PeekL(memloc+42) ;4 
  InfoHeader\biClrUsed       = PeekL(memloc+46) ;4 
  InfoHeader\biClrImportant  = PeekL(memloc+50) ;4 
  
  
  
  
  If InfoHeader\biSizeImage = 0 
    InfoHeader\biSizeImage = (InfoHeader\biWidth * InfoHeader\biHeight * InfoHeader\biBitCount / 8)+64 
  EndIf 
  
  ; allocate enough mem to store the bitmap 
  Dim bitmapImage.b (InfoHeader\biSizeImage +64) 
  
  ; read in the bitmap image data 
  For i.l=FileHeader\bfOffBits To (InfoHeader\biSizeImage +64) 
    
    bitmapImage(i2) = PeekB(memloc+i) 
    i2.l+1 
    
  Next 
  
  If depth>8 
    ; swap BGR to RGB 
    For i.l=0 To InfoHeader\biSizeImage Step 3 
      
      tempRGB.l = bitmapImage(i) 
      
      bitmapImage(i) = bitmapImage(i+2) 
      bitmapImage(i+2) = tempRGB 
      
    Next 
  EndIf 
  
  ; create texture 
  texture = _CreateTexture(bitmapImage(), mode.s, mipmapping.b, InfoHeader\biWidth, InfoHeader\biHeight) 
  
  
  ;  FreeMemory(0) 
  Dim bitmapImage.b(0) 
  
  ProcedureReturn texture 
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
    gluPerspective__(45.0, 640.0/480.0, 1.0, 100.0) 
    glMatrixMode_(#GL_MODELVIEW) 
    
    opengl= LoadBMPTextureMem(?opengl, "rgb", 24,0) 
    background=loadBMPTextureMem(?background,"rgb",24,0) 
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
  
  
  t1.f = GetTickCount_() /300 
  
  If sstart=0 
    
    timer.f=GetTickCount_() 
    sstart=1 
    
  EndIf 
  
  If rueck=0 
    
    blend.f=blend.f+0.0011 
    
  EndIf 
  
  If rueck=1 
    
    blend.f=blend.f-0.0011 
    
  EndIf 
  
  
  If blend.f > 1.0 
    
    rueck=1 
    
  EndIf 
  
  If blend.f <0.0 
    
    sstart=0 
    rueck=0 
    
  EndIf 
  
  
  If rueck=0 
    
    blend.f=blend.f+0.0081 
    
  EndIf 
  
  If rueck=1 
    
    blend.f=blend.f-0.0081 
    
  EndIf 
  
  
  If blend.f > 1.0 
    
    rueck=1 
    
  EndIf 
  
  If blend.f <0.0 
    
    sstart=0 
    rueck=0 
    
  EndIf 
  
  glTranslatef_(-1.20, 1.0, -5.0); 
  
  
  drawcube() 
  
  glTranslatef_(0.0,-2.9,0.0) 
  
  drawcube() 
  
  
  glEnable_(#GL_TEXTURE_2D) 
  
  
  glPushMatrix_(); 
  glRotatef_(25.0*t1.f,1.0,0.0,0.0); 
  glRotatef_(45.0*t1.f,0.0,1.0,0.0); 
  
  glScalef_(5.0, 5.0,5.0); 
  glBindTexture_(#GL_TEXTURE_2D, background); 
  glBegin_(#GL_QUADS); 
  
  ; // Front Face 
  glNormal3f_( 0.0, 0.0, 1.0); 
  glTexCoord2f_(0.0, 0.0): glVertex3f_(-1.0, -1.0,  1.0); 
  glTexCoord2f_(1.0, 0.0): glVertex3f_( 1.0, -1.0,  1.0); 
  glTexCoord2f_(1.0, 1.0) :glVertex3f_( 1.0,  1.0,  1.0); 
  glTexCoord2f_(0.0, 1.0) :glVertex3f_(-1.0,  1.0,  1.0); 
  ;// Back Face 
  glNormal3f_( 0.0, 0.0,-1.0); 
  glTexCoord2f_(1.0, 0.0) :glVertex3f_(-1.0, -1.0, -1.0); 
  glTexCoord2f_(1.0, 1.0) :glVertex3f_(-1.0,  1.0, -1.0); 
  glTexCoord2f_(0.0, 1.0) :glVertex3f_( 1.0,  1.0, -1.0); 
  glTexCoord2f_(0.0, 0.0) :glVertex3f_( 1.0, -1.0, -1.0); 
  ;// Top Face 
  glNormal3f_( 0.0, 1.0, 0.0); 
  glTexCoord2f_(0.0, 1.0) :glVertex3f_(-1.0,  1.0, -1.0); 
  glTexCoord2f_(0.0, 0.0) :glVertex3f_(-1.0,  1.0,  1.0); 
  glTexCoord2f_(1.0, 0.0) :glVertex3f_( 1.0,  1.0,  1.0); 
  glTexCoord2f_(1.0, 1.0) :glVertex3f_( 1.0,  1.0, -1.0); 
  ;// Bottom Face 
  glNormal3f_( 0.0,-1.0, 0.0); 
  glTexCoord2f_(1.0, 1.0) :glVertex3f_(-1.0, -1.0, -1.0); 
  glTexCoord2f_(0.0, 1.0) :glVertex3f_( 1.0, -1.0, -1.0); 
  glTexCoord2f_(0.0, 0.0) :glVertex3f_( 1.0, -1.0,  1.0); 
  glTexCoord2f_(1.0, 0.0) :glVertex3f_(-1.0, -1.0,  1.0); 
  ;// Right face 
  glNormal3f_( 1.0, 0.0, 0.0); 
  glTexCoord2f_(1.0, 0.0) :glVertex3f_( 1.0, -1.0, -1.0); 
  glTexCoord2f_(1.0, 1.0) :glVertex3f_( 1.0,  1.0, -1.0); 
  glTexCoord2f_(0.0, 1.0) :glVertex3f_( 1.0,  1.0,  1.0); 
  glTexCoord2f_(0.0, 0.0) :glVertex3f_( 1.0, -1.0,  1.0); 
  ;// Left Face 
  glNormal3f_(-1.0, 0.0, 0.0); 
  glTexCoord2f_(0.0, 0.0) :glVertex3f_(-1.0, -1.0, -1.0); 
  glTexCoord2f_(1.0, 0.0) :glVertex3f_(-1.0, -1.0,  1.0); 
  glTexCoord2f_(1.0, 1.0) :glVertex3f_(-1.0,  1.0,  1.0); 
  glTexCoord2f_(0.0, 1.0) :glVertex3f_(-1.0,  1.0, -1.0); 
  glEnd_(); 
  glPopMatrix_(); 
  
  
  glEnable_(#GL_BLEND) 
  glBlendFunc_ (#GL_SRC_ALPHA, #GL_ONE) 
  glColor4f_(0.0,0.0,0.0,blend.f) 
  glTranslatef_(1.2,1.7,0.0) 
  glBindTexture_(#GL_TEXTURE_2D, opengl) 
  
  drawcube2() 
  
  glDisable_(#GL_BLEND) 
  glDisable_(#GL_TEXTURE_2D) 
  
  
  SwapBuffers_(hdc) 
  
EndProcedure 

pfd.PIXELFORMATDESCRIPTOR 

FlatMode = 0 ; Enable Or disable the 'Flat' rendering 

WindowWidth = 640 ; The window & GLViewport dimensions 
WindowHeight = 480 




hWnd = OpenWindow(0, 0, 0, WindowWidth, WindowHeight, "EchtZeit Textur Blending Demo", #PB_Window_SystemMenu) 

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
IncludeBinary "opengldemo.bmp" 

background: 
IncludeBinary "background.bmp" 

EndDataSection 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; DisableDebugger