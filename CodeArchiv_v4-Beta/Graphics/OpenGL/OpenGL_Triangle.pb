; English forum: 
; Author: Lance Jepsen (updated for PB 4.00 by Andre)
; Date: 31. December 2002
; OS: Windows
; Demo: No


;
; OpenGL Triangle
; by Lance Jepsen
;
;
; Based on OpenGL Test by Fantaisie Software
;
;
;

XIncludeFile "..\..\Includes+Macros\Includes\OpenGL\OpenGL.pbi"

Global theta.f
theta = 5
Procedure DrawCube(hdc)
  glPushMatrix_() ; Save the original Matrix coordinates
  glMatrixMode_(#GL_MODELVIEW)
  glRotatef_( theta, 0,0,1.0);
  glRotatef_ (theta, 1.0, 0, 0) ; rotate around X axis
  glRotatef_ (theta, 0, 1.0, 0) ; rotate around Y axis
  glRotatef_ (theta, 0, 0, 1.0) ; rotate around Z axis
  glClearColor_( 0.0, 0.0, 0.0, 0.0 )
  glClear_ (#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT)
  
  glBegin_(#GL_TRIANGLES );
  glColor3f_(1.0, 0.0, 0.0 )
  glVertex2f_( 0.0, 1.0 )
  glColor3f_( 0.0, 1.0, 0.0 )
  glVertex2f_( 0.87, -0.5 );
  glColor3f_( 0.0, 0.0, 1.0 )
  glVertex2f_( -0.87, -0.5 );
  glEnd_()
  
  theta = theta + 1
  
  glPopMatrix_()
  glFinish_()
  
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

WindowWidth = 800 ; The window & GLViewport dimensions
WindowHeight = 600

hWnd = OpenWindow(0, 0, 0, WindowWidth, WindowHeight, "OpenGL Triangle", #PB_Window_SystemMenu)

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

HandleError( glViewport_ (0, 0, WindowWidth-30, WindowHeight-30), "GLViewPort()") ; A rectangle which define the OpenGL output zone

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