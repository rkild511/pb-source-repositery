; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9242&highlight=
; Author: fsw (updated for PB 4.00 by Andre)
; Date: 21. January 2004
; OS: Windows
; Demo: No


; OpenGL Demo in PureBasic 
; 
; This is a THREAD Version now the object is rotating even if you move the window! 
; 
; (c) 2004 - Franco aka FSW 
; 
; the base code is made by Mark1up 
; 'threading' and 'made it work with 3v81' by me 

XIncludeFile "..\..\Includes+Macros\Includes\OpenGL\OpenGL.pbi"


InitSprite() 
InitKeyboard() 

Structure WindowClass 
  wcstyle.b 
EndStructure 

wc.WindowClass 

wc\wcstyle = #CS_OWNDC 

RegisterClass_(wc) 

Procedure Go(hDC) 
  pfd.PixelFormatDescriptor 

  pfd\nSize = SizeOf(PixelFormatDescriptor) 
  pfd\nVersion = 1 
  pfd\dwFlags = #PFD_DRAW_TO_WINDOW | #PFD_SUPPORT_OPENGL | #PFD_DOUBLEBUFFER 
  pfd\iPixelType = #PFD_TYPE_RGBA 
  pfd\cColorBits = 24 
  pfd\cDepthBits = 16 
  pfd\iLayerType = #PFD_MAIN_PLANE 

  iFormat = ChoosePixelFormat_ (hDC, pfd) 
  SetPixelFormat_ (hDC, iFormat, pfd) 

  hRC.l = wglCreateContext_(hDC) 
  wglMakeCurrent_(hDC,hRC) 

  Theta.f = 0 

  WinEvt= WindowEvent() 
  While WinEvt <> #PB_Event_CloseWindow 
    WinEvt= WindowEvent() 

    glClearColor_( 0.0, 0.0, 0.0, 0.0 ) 
    glClear_( #GL_COLOR_BUFFER_BIT ) 
    
    glPushMatrix_() 
    glRotatef_( Theta, 0.0, 0.0, 1.0 ) 
    glBegin_( #GL_TRIANGLES ) 
    glColor3f_( 1.0, 0.0, 0.0 ) 
    glVertex2f_( 0.0, 1.0 ); 
    glColor3f_( 0.0, 1.0, 0.0 ) 
    glVertex2f_( 0.87, -0.5 ) 
    glColor3f_( 0.0, 0.0, 1.0 ) 
    glVertex2f_( -0.87, -0.5 ) 
    glEnd_() 
    glPopMatrix_() 
    
    SwapBuffers_( hDC ) 
    
    Theta = Theta + 1.0 
  Wend 
EndProcedure 

hWnd = OpenWindow(1, 20, 20, 600, 400, "OpenGL Demo", #PB_Window_SystemMenu) 
hDC.l = GetDC_(hWnd) 

thread = CreateThread(@Go(),hDC) 

WinEvt= WindowEvent() 
While WinEvt <> #PB_Event_CloseWindow 
  WinEvt= WindowEvent() 
  Delay(10) 
Wend 

; If IsThread(thread)
;   KillThread(thread)
; EndIf

wglMakeCurrent_(#Null,#Null) 
wglDeleteContext_(hRC) 
ReleaseDC_(hWnd, hDC) 
CloseWindow(1) 

End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -