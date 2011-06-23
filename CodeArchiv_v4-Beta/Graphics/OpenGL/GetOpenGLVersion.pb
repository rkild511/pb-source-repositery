; German forum: http://www.purebasic.fr/german/viewtopic.php?t=45&postdays=0&postorder=asc&start=10
; Author: DarkDragon (updated for PB 4.00 by Andre)
; Date: 10. September 2004
; OS: Windows
; Demo: No

; Ermitteln der OpenGL-Version
; Wenn die Version kleiner als 1.5 ist würde ich mal nach nem neuen GraKa-Treiber schauen.

#WindowWidth = 1
#WindowHeight = 1
#WindowFlags = #PB_Window_Invisible

Global hWnd.l, Event

If OpenWindow(0, 0, 0, #WindowWidth, #WindowHeight, "", #WindowFlags)

  hWnd = WindowID(0)
  hDC = GetDC_(hWnd)

  ;Initialize OpenGL
  pfd.PIXELFORMATDESCRIPTOR
  pfd\nSize        = SizeOf(PIXELFORMATDESCRIPTOR)
  pfd\nVersion     = 1
  pfd\dwFlags      = #PFD_SUPPORT_OPENGL | #PFD_DOUBLEBUFFER | #PFD_DRAW_TO_WINDOW
  pfd\iLayerType   = #PFD_MAIN_PLANE
  pfd\iPixelType   = #PFD_TYPE_RGBA
  pfd\cColorBits   = 24
  pfd\cDepthBits   = 32
  pixformat = ChoosePixelFormat_(hDC, pfd)
  SetPixelFormat_(hDC, pixformat, pfd)
  hrc = wglCreateContext_(hDC)
  wglMakeCurrent_(hDC, hrc)

  SwapBuffers_(hDC)

  MessageRequester("OpenGL-Version", PeekS(glGetString_($1F02)))
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -