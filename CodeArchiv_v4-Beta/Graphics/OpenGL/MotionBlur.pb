; www.PureArea.net
; Author: jammin (updated for PB 4.00 by Andre)
; Date: 27. July 2003
; OS: Windows
; Demo: No


; OpenGL Motion Blur Demo
; Ported from Delphi to Purebasic by jammin/EchtZeit
;
;
; Based on OpenGL Demo by Phil Freeman
;
;
;

IncludeFile "..\..\Includes+Macros\Includes\OpenGL\OpenGL.pbi"

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


Procedure RenderScene(Fade.f);
  
  
  glColor3f_(0.0, 0.0, Fade);
  glTranslatef_(-0.5, 0.0, 0.0);
  RenderCube(0.1);
  
  glColor3f_(0.0, Fade, 0.0);
  glTranslatef_(1.0, 0.0, 0.0);
  RenderCube(0.1);
  
  glColor3f_(0.0, Fade, Fade);
  glTranslatef_(-0.5, 0.0, 0.5);
  RenderCube(0.1);
  
  glColor3f_(Fade, Fade, 0.0);
  glTranslatef_(0.0, 0.0, -1.0);
  RenderCube(0.1);
  
  glColor3f_(Fade, Fade / 2, 0.0);
  glTranslatef_(0.0, 0.5, 0.5);
  RenderCube(0.1);
  
  glColor3f_(Fade, 0.0, Fade);
  glTranslatef_(0.0, -1.0, 0.0);
  RenderCube(0.1);
  
  glColor3f_(Fade, 0.0, 0.0);
  glTranslatef_(0.0, 0.5, 0.0);
  RenderCube(0.2);
  
  EndProcedure;
  
  
  
  
  
  
Procedure DrawCube(hdc)
  
  glEnable_(#GL_LIGHT0);
  glEnable_(#GL_LIGHTING);
  glEnable_(#GL_COLOR_MATERIAL);
  glEnable_(#GL_DEPTH_TEST);
  glDepthFunc_(#GL_LEQUAL);
  
  glShadeModel_(#GL_SMOOTH)
  glClearColor_( 0.0, 0.0, 0.0, 0.0 )
  glClear_(#GL_COLOR_BUFFER_BIT);
  
  t1.f = GetTickCount_() / 1000;
  
  
  For i=0 To 15
    
    glClear_(#GL_DEPTH_BUFFER_BIT);
    
    t2.f = t1.f + i / 15 * 0.25;
    
    glLoadIdentity_();
    glRotatef_(t2.f * 70.0, 1.0, 0.0, 0.0);
    glRotatef_(t2.f * 80.0, 0.0, 1.0, 0.0);
    glRotatef_(t2.f * 90.0, 0.0, 0.0, 1.0);
    
    RenderScene(i / 15);
    
  Next i
  
  SwapBuffers_(hdc)
  
EndProcedure


Procedure HandleError (Result, Text$)
  If Result = 0
    MessageRequester("Error", Text$, 0)
    End
  EndIf
EndProcedure


pfd.PIXELFORMATDESCRIPTOR

FlatMode = 0 ; Enable Or disable the 'Flat' rendering

WindowWidth = 640 ; The window & GLViewport dimensions
WindowHeight = 480




hWnd = OpenWindow(0, 0, 0, WindowWidth, WindowHeight, "EchtZeit Motion Blur Demo", #PB_Window_SystemMenu)

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
; Folding = -
; DisableDebugger