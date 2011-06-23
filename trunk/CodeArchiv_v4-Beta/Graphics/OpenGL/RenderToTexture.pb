; www.PureArea.net
; Author: jammin (updated for PB 4.00 by Andre)
; Date: 17. August 2003
; OS: Windows
; Demo: No

;render to texture demo
;programmed by jammin 2003
;saw this effect in a demo by UNIK


IncludeFile "..\..\Includes+Macros\Includes\OpenGL\OpenGL.pbi"
Global start.b
Global textu.l
Global Dim rot.l(4)
Global Dim gelb.l(4)
Global Dim blau.l(4)
Global Dim gruen.l(4)

Procedure _CreateTexture(pData.l,  mipmapping.b, bmpWidth.l, bmpHeight.l)
  mode.s="rgb"
  If pData = 0
    MessageBox_(0, "unable to load texture", ":textureLib", #MB_OK | #MB_ICONERROR)
  Else
    
    glGenTextures_(1, @textu)
    glBindTexture_(#GL_TEXTURE_2D, textu)
    glTexEnvi_(#GL_TEXTURE_ENV, #GL_TEXTURE_ENV_MODE, #GL_MODULATE)       ; Texture blends with object background
    
    
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
  ProcedureReturn textu
  
EndProcedure




Procedure loadBMPTextureMem()
  
  
  Dim bitmapImage.b (12188)
  
  
  For i.l=0 To 12188
    
    
    bitmapImage(i) = 0
    
  Next
  
  
  ; create texture
  textu = _CreateTexture(bitmapImage(),  0, 64, 64)
  
  
  ;  FreeMemory(0)
  Dim bitmapImage.b(0)
  
  ProcedureReturn textu
EndProcedure













Procedure Rendercube(Size.f)
  
  
  glBegin_(#GL_QUADS);
  
  glNormal3f_( -1.0,  0.0,  0.0);
  glVertex3f_( Size, -Size, -Size);
  glVertex3f_( Size,  Size, -Size);
  glVertex3f_( Size,  Size,  Size);
  glVertex3f_( Size, -Size,  Size);
  
  glNormal3f_(1.0,  0.0,  0.0);
  glVertex3f_(-Size, -Size,  Size);
  glVertex3f_(-Size, -Size, -Size);
  glVertex3f_(-Size,  Size, -Size);
  glVertex3f_(-Size,  Size,  Size);
  
  glNormal3f_( 0.0,  0.0, 1.0);
  glVertex3f_(-Size,  Size, -Size);
  glVertex3f_( Size,  Size, -Size);
  glVertex3f_( Size, -Size, -Size);
  glVertex3f_(-Size, -Size, -Size);
  
  glNormal3f_( 0.0,  0.0,  -1.0);
  glVertex3f_(-Size, -Size,  Size);
  glVertex3f_(-Size,  Size,  Size);
  glVertex3f_( Size,  Size,  Size);
  glVertex3f_( Size, -Size,  Size);
  
  glNormal3f_( 0.0,  -1.0,  0.0);
  glVertex3f_( Size,  Size, -Size);
  glVertex3f_( Size,  Size,  Size);
  glVertex3f_(-Size,  Size,  Size);
  glVertex3f_(-Size,  Size, -Size);
  
  glNormal3f_( 0.0, 1.0,  0.0);
  glVertex3f_( Size, -Size,  Size);
  glVertex3f_(-Size, -Size,  Size);
  glVertex3f_(-Size, -Size, -Size);
  glVertex3f_( Size, -Size, -Size);
  
  glEnd_();
  
EndProcedure

Procedure DrawCube2()
  
  glBegin_(#GL_Quads)
  
  
  
  
  One.f = 1.0
  Null.f = 0.0
  Minus.f = -0.0045
  One1.f = 0.0
  Minus1.f = -0.25
  glColor3f_(1.0,1.0,1.0)
  glNormal3f_( 0.0, 0.0, 1.0 )
  glTexCoord2f_( 0.0, 0.0 ) : glVertex3f_( minus1,minus1, 1.0 )
  glTexCoord2f_( 1.0, 0.0 ) : glVertex3f_(  0.0,minus1, 1.0 )
  glTexCoord2f_( 1.0, 1.0 ) : glVertex3f_(  0.0, 0.0, 1.0 )
  glTexCoord2f_( 0.0, 1.0 ) : glVertex3f_( minus1, 0.0, 1.0 )
  glEnd_()
  
  
EndProcedure




Procedure RenderScene(colorr.f,colorg.f,colorb.f);
  
  
  glColor3f_(colorr.f, colorg.f, colorb.f);
  RenderCube(0.1);
  glTranslatef_(0.25,0.0,0.0)
  
  RenderCube(0.1);
  glTranslatef_(0.25,0.0,0.0)
  RenderCube(0.1);
  glTranslatef_(0.25,0.0,0.0)
  RenderCube(0.1);
  glTranslatef_(-1.0,0.0,0.0)
  RenderCube(0.1);
  glTranslatef_(-0.25,0.0,0.0)
  RenderCube(0.1);
  glTranslatef_(-0.25,0.0,0.0)
  RenderCube(0.1);
  
  
  EndProcedure;
  
  
  
  
Procedure DrawCube(hdc)
  
  If start=0
    
    glMatrixMode_(#GL_PROJECTION);					// Select Projection
    glPushMatrix_();							// Push The Matrix
    glLoadIdentity_();						// Reset The Matrix
    glOrtho_( 0, 640 , 480 ,0,-100,100,0,0,0,0,0,0);				// Select Ortho Mode (640x480)
    glMatrixMode_(#GL_MODELVIEW);					// Select Modelview Matrix
    glPushMatrix_();							// Push The Matrix
    glLoadIdentity_();	
    
    
    ;speicher für texturen erstellen
    
    For i=1 To 4
      
      rot(i)=loadbmptexturemem()
      gelb(i)=loadbmptexturemem()
      blau(i)=loadbmptexturemem()
      gruen(i)=loadbmptexturemem()
      
    Next
    
    
    
    
    
    
    
    
    start=1
    
  EndIf
  
  
  glEnable_(#GL_LIGHT0);
  glEnable_(#GL_LIGHTING);
  glEnable_(#GL_COLOR_MATERIAL);
  glEnable_(#GL_DEPTH_TEST);
  glEnable_(#GL_TEXTURE_2D)
  glDepthFunc_(#GL_LEQUAL);
  
  glShadeModel_(#GL_SMOOTH)
  glClearColor_( 1.0, 1.0, 1.0, 0.0 )
  glClear_(#GL_COLOR_BUFFER_BIT);
  glViewport_(0, 0, 256, 256)
  t1.f = GetTickCount_() / 1000;
  
  
  
  
  glClear_(#GL_DEPTH_BUFFER_BIT);
  
  t2.f = t1.f + i / 15 * 0.25;
  
  glLoadIdentity_();
  ;glPolygonMode_(#GL_FRONT, #GL_LINE);
  ;glPolygonMode_(#GL_BACK, #GL_LINE);
  
  glPushMatrix_()
  glRotatef_(t2.f * 70.0, 1.0, 0.0, 0.0);
  glRotatef_(t2.f * 80.0, 0.0, 1.0, 0.0);
  glRotatef_(t2.f * 90.0, 0.0, 0.0, 1.0);
  ;erste scene als textur kopieren -> rendertex
  
  glPolygonMode_(#GL_FRONT, #GL_LINE);
  glPolygonMode_(#GL_BACK, #GL_LINE);
  
  glDisable_(#GL_LIGHTING);
  RenderScene(0.0,0.0,0.0);
  up=0
  For i= 1 To 4
    
    glBindTexture_(#GL_TEXTURE_2D, rot(i));
    glCopyTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGB, 0, 0+up, 64,64, 0);
    up=up+64
    
  Next
  glEnable_(#GL_LIGHTING);
  glPopMatrix_()
  
  ;erste scene löschen u. 2. rendern
  glClear_(#GL_COLOR_BUFFER_BIT);
  glClear_(#GL_DEPTH_BUFFER_BIT);
  ;glPolygonMode_(#GL_FRONT, #GL_FILL);
  ;glPolygonMode_(#GL_BACK, #GL_FILL);
  
  
  ;glLoadIdentity_();
  glPushMatrix_()
  glRotatef_(t2.f * 70.0, 1.0, 0.0, 0.0);
  glRotatef_(t2.f * 80.0, 0.0, 1.0, 0.0);
  glRotatef_(t2.f * 90.0, 0.0, 0.0, 1.0);
  glPolygonMode_(#GL_FRONT, #GL_FILL);
  glPolygonMode_(#GL_BACK, #GL_FILL);
  ;glDisable_(#GL_COLOR_MATERIAL);
  
  
  
  RenderScene(0.8,0.8,0.8);
  
  glBindTexture_(#GL_TEXTURE_2D, gelb(1));
  glCopyTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGB, 64, 192, 64,64, 0);
  glBindTexture_(#GL_TEXTURE_2D, gelb(2));
  glCopyTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGB, 128, 192, 64,64, 0);
  glBindTexture_(#GL_TEXTURE_2D, gelb(3));
  glCopyTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGB, 64, 128, 64,64, 0);
  glBindTexture_(#GL_TEXTURE_2D, gelb(4));
  glCopyTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGB, 128, 128, 64,64, 0);
  
  glPopMatrix_()
  
  ;zweite scene löschen u. 3. rendern
  
  glClear_(#GL_COLOR_BUFFER_BIT);
  glClear_(#GL_DEPTH_BUFFER_BIT);
  ;glLoadIdentity_();
  ;glClearColor_( 1.0, 1.0, 1.0, 0.0 )
  ;glEnable_(#GL_COLOR_MATERIAL);
  
  glPushMatrix_()
  glRotatef_(t2.f * 70.0, 1.0, 0.0, 0.0);
  glRotatef_(t2.f * 80.0, 0.0, 1.0, 0.0);
  glRotatef_(t2.f * 90.0, 0.0, 0.0, 1.0);
  
  RenderScene(0.5,0.5,0.5);
  
  glBindTexture_(#GL_TEXTURE_2D, blau(1));
  glCopyTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGB, 64, 64, 64,64, 0);
  glBindTexture_(#GL_TEXTURE_2D, blau(2));
  glCopyTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGB, 128, 64, 64,64, 0);
  glBindTexture_(#GL_TEXTURE_2D, blau(3));
  glCopyTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGB, 64, 0, 64,64, 0);
  glBindTexture_(#GL_TEXTURE_2D, blau(4));
  glCopyTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGB, 128, 0, 64,64, 0);
  
  
  glPopMatrix_()
  
  
  
  
  ;dritte scene löschen u. 4. rendern
  glClear_(#GL_COLOR_BUFFER_BIT);
  glClear_(#GL_DEPTH_BUFFER_BIT);
  
  ;glLoadIdentity_();
  glPushMatrix_()
  glRotatef_(t2.f * 70.0, 1.0, 0.0, 0.0);
  glRotatef_(t2.f * 80.0, 0.0, 1.0, 0.0);
  glRotatef_(t2.f * 90.0, 0.0, 0.0, 1.0);
  glPolygonMode_(#GL_FRONT, #GL_LINE);
  glPolygonMode_(#GL_BACK, #GL_LINE);
  
  glDisable_(#GL_LIGHTING);
  RenderScene(0.0,0.0,0.0);
  
  up=0
  For i= 1 To 4
    
    glBindTexture_(#GL_TEXTURE_2D, gruen(i));
    glCopyTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGB, 192, 0+up, 64,64, 0);
    up=up+64
    
  Next
  
  glPopMatrix_()
  
  glEnable_(#GL_LIGHTING);
  
  
  
  
  glViewport_(150, 0, 640, 480)
  glClear_(#GL_COLOR_BUFFER_BIT);
  glClear_(#GL_DEPTH_BUFFER_BIT);
  
  
  glTranslatef_(-0.75,-0.55,0.0)
  glPushMatrix_()  ;glBindTexture_(#GL_TEXTURE_2D, rendertex3);
  For i=1 To 4
    glTranslatef_(0.0,0.25,0.0)
    glBindTexture_(#GL_TEXTURE_2D, rot(i))
    glPolygonMode_(#GL_FRONT, #GL_FILL);
    glPolygonMode_(#GL_BACK, #GL_FILL);
    
    
    
    drawcube2()
    
  Next
  glPopMatrix_()
  
  glTranslatef_(0.95,1.0,0.0)
  glPushMatrix_()
  glTranslatef_(-0.695,0.0,0.0)
  glBindTexture_(#GL_TEXTURE_2D, gelb(1))
  drawcube2()
  glTranslatef_(0.244,0.0,0.0)
  glBindTexture_(#GL_TEXTURE_2D, gelb(2))
  drawcube2()
  glTranslatef_(-0.244,-0.249,0.0)
  glBindTexture_(#GL_TEXTURE_2D, gelb(3))
  drawcube2()
  glTranslatef_(0.244,0.0,0.0)
  glBindTexture_(#GL_TEXTURE_2D, gelb(4))
  drawcube2()
  glPopMatrix_()
  
  
  
  
  glTranslatef_(-0.695,-0.50,0.0)
  glPushMatrix_()
  glBindTexture_(#GL_TEXTURE_2D, blau(1))
  drawcube2()
  glTranslatef_(0.244,0.0,0.0)
  glBindTexture_(#GL_TEXTURE_2D, blau(2))
  drawcube2()
  glTranslatef_(-0.244,-0.25,0.0)
  glBindTexture_(#GL_TEXTURE_2D, blau(3))
  drawcube2()
  glTranslatef_(0.244,0.0,0.0)
  glBindTexture_(#GL_TEXTURE_2D, blau(4))
  drawcube2()
  glPopMatrix_()
  
  
  ;glDisable_(#GL_TEXTURE_2D)
  glTranslatef_(0.5,-0.5,0.0)
  
  glPushMatrix_()
  
  
  For i=1 To 4
    glTranslatef_(0.0,0.25,0.0)
    glBindTexture_(#GL_TEXTURE_2D, gruen(i))
    
    drawcube2()
    
  Next
  glPopMatrix_()
  
  glDisable_(#GL_TEXTURE_2D)
  
  
  
  
  ; // draw a square border sothat you can see where the square is
  
  
  
  
  
  glPolygonMode_(#GL_FRONT, #GL_LINE);
  glPolygonMode_(#GL_BACK, #GL_LINE);
  
  glTranslatef_(-0.5,0.0,0.0)
  
  glLineWidth_(1.0);         // set a thick line for square border
  glColor3f_(0.0, 0.0, 0.0);     // draw a black boder
  glBegin_(#GL_QUADS);      // draw the square borders
  ;
  glVertex3f_(-0.244 , -0.0,  0.0);
  glVertex3f_( 0.244, -0.0 ,  0.0);
  glVertex3f_( 0.244 ,0.495,  0.0);
  glVertex3f_(-0.244 ,  0.495 ,  0.0);
  glEnd_();
  
  
  glTranslatef_(0.0,0.5,0.0)
  
  glLineWidth_(1.0);         // set a thick line for square border
  glColor3f_(0.0, 0.0, 0.0);     // draw a black boder
  glBegin_(#GL_QUADS);      // draw the square borders
  ;
  glVertex3f_(-0.244 , 0.005,  0.0);
  glVertex3f_( 0.244, 0.005 ,  0.0);
  glVertex3f_( 0.244 ,0.495,  0.0);
  glVertex3f_(-0.244 ,  0.495 ,  0.0);
  glEnd_();
  
  glTranslatef_(-0.4,0.0,0.0)
  
  glLineWidth_(1.0);         // set a thick line for square border
  glColor3f_(0.0, 0.0, 0.0);     // draw a black boder
  glBegin_(#GL_QUADS);      // draw the square borders
  ;
  glVertex3f_(-0.1 , -0.5,  0.0);
  glVertex3f_( 0.144, -0.5 ,  0.0);
  glVertex3f_( 0.144 ,0.495,  0.0);
  glVertex3f_(-0.1 ,  0.495 ,  0.0);
  glEnd_();
  
  glTranslatef_(0.755,0.0,0.0)
  
  glLineWidth_(1.0);         // set a thick line for square border
  glColor3f_(0.0, 0.0, 0.0);     // draw a black boder
  glBegin_(#GL_QUADS);      // draw the square borders
  ;
  glVertex3f_(-0.1 , -0.5,  0.0);
  glVertex3f_( 0.144, -0.5 ,  0.0);
  glVertex3f_( 0.144 ,0.495,  0.0);
  glVertex3f_(-0.1 ,  0.495 ,  0.0);
  glEnd_();
  
  
  
  glPolygonMode_(#GL_FRONT, #GL_FILL);
  glPolygonMode_(#GL_BACK, #GL_FILL);
  
  
  
  glTranslatef_(-0.105,0.0,0.0)
  
  glLineWidth_(1.0);         // set a thick line for square border
  glColor3f_(1.0, 1.0, 1.0);     // draw a black boder
  glBegin_(#GL_QUADS);      // draw the square borders
  ;
  glVertex3f_(-0.0020 , -0.5,  0.0);
  glVertex3f_( 0.004, -0.5 ,  0.0);
  glVertex3f_( 0.004 ,0.495,  0.0);
  glVertex3f_(-0.0020 ,  0.495 ,  0.0);
  glEnd_();
  
  glTranslatef_(-0.5,0.0,0.0)
  
  glLineWidth_(1.0);         // set a thick line for square border
  glColor3f_(1.0, 1.0, 1.0);     // draw a black boder
  glBegin_(#GL_QUADS);      // draw the square borders
  ;
  glVertex3f_(-0.0020 , -0.5,  0.0);
  glVertex3f_( 0.004, -0.5 ,  0.0);
  glVertex3f_( 0.004 ,0.495,  0.0);
  glVertex3f_(-0.0020 ,  0.495 ,  0.0);
  glEnd_();
  
  glTranslatef_(-0.0,0.0,0.0)
  
  glLineWidth_(1.0);         // set a thick line for square border
  glColor3f_(1.0, 1.0, 1.0);     // draw a black boder
  glBegin_(#GL_QUADS);      // draw the square borders
  ;
  glVertex3f_(0.5 , -0.00480,  0.0);
  glVertex3f_( 0.0, -0.00480 ,  0.0);
  glVertex3f_( 0.0 ,0.005,  0.0);
  glVertex3f_(0.5 ,  0.005 ,  0.0);
  glEnd_();
  
  
  
  
  
  ;
  
  
  SwapBuffers_(hdc)
  
EndProcedure


Procedure HandleError (Result, Text$)
  If Result = 0
    MessageRequester("Error", Text$, 0)
    End
  EndIf
EndProcedure


pfd.PIXELFORMATDESCRIPTOR

FlatMode = 0

WindowWidth = 640
WindowHeight = 480




hWnd = OpenWindow(0, 0, 0, WindowWidth, WindowHeight, "Render to texture demo", #PB_Window_SystemMenu)

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

HandleError( glViewport_ (0, 0, WindowWidth, WindowHeight), "GLViewPort()") ; A rectangle which define the OpenGL output zone

While Quit = 0
  
  Repeat
    EventID = WindowEvent()
    
    Select EventID
    Case #PB_Event_CloseWindow
      Quit = 1
    EndSelect
    
  Until EventID = 0
  
  DrawCube(hdc)
Wend


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; DisableDebugger