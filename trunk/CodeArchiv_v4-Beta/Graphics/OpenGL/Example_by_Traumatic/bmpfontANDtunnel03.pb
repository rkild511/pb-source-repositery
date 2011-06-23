; English forum: 
; Author: traumatic (updated for PB 4.00 by traumatic)
; Date: 20. June 2002
; OS: Windows
; Demo: No

;..................................................................................
;
; tiny purebasic-opengl example | traumatic!2002 [traumatic@connection-refused.org]
;
;..................................................................................
;
;
;
;
; 20.06.2002  - displays text using a bitmap font and draws a tunnel in the background
;
;               filesize: 32.800 bytes (upx-compressed)
;
; 27.06.2002  - filesize is now 16.928 bytes (upx-compressed)
;               due to texture-generation (->initPlasma())
;
; 28.06.2002  - added three different 'texture-generation-modes' can be toggled
;               by passing "-1", "-2" or "-3" as parameters
;
;               guess all bugs are gone now (screenresolution-switching)
;               glScissor-problem on some cards
;
;
; 12.12.2006 -  converted to pb4 on public demand - omg, what an ugly code... *sigh*
;               do yourself a favour and DON'T (read: DO NOT!) take this to learn from it!
;
;               note: I let "procedure modulo()" in as this is just meant to be
;                     compileable in pb4, not nice.
;

; opengl headers
XIncludeFile "pfd.pbh"
XIncludeFile "gl.pbh"
XIncludeFile "glu.pbh"

; windows headers
XIncludeFile "wingdi.pbh"
XIncludeFile "winuser.pbh"


Import "opengl32.lib"
  gluPerspective(a.d, b.d, c.d, e.d)
  glOrtho(a.d, b.d, c.d, d.d, e.d, f.d)
EndImport


#WNDTITLE = ""  ; App-Title
#FPS_TIMER = 1                    ; Timer to calculate FramesPerSecond
#FPS_INTERVAL = 1000              ; Calculate FPS every 1000 ms

ProgParam$ = ProgramParameter()

;
; variables
;


ElapsedTime.l     ; Elapsed time between frames

Global h_Wnd.l  ; global window handle
Global h_DC.l   ; global device context
Global h_RC.l   ; OpenGL rendering context

WndProcMsg.MSG


#appWidth = 640
#appHeight = 480


; tunnel
Structure TCoord  ; Texture Coordinates
  u.f
  v.f
EndStructure

Structure PCoord  ; Polygon Coordinates
  x.f
  y.f
  z.f
EndStructure

Global Dim imgArray.PCoord(32,32)
Global Dim texcord.TCoord(32,32)


; bmpfont
#fntSize = 32



;------------------------------------------------------------------
;  taken from glLibOnly2.pb
;
Procedure.l WndProc(hWnd,Msg,wParam,lParam)
  Shared quit
 
  If Msg=#WM_KEYDOWN  ; Set the pressed key (wparam) To equal true so we can check If its pressed
    quit=1
    ProcedureReturn 0
  EndIf


  If Msg=#WM_SYSCOMMAND   ; Intercept System Commands
  ; screensaver trying to start? monitor trying to enter powersaving?
    If wParam=#SC_SCREENSAVE ;Or wParam=#SC_MONITORPOWER ; (0F170h - winuser.h)
      ProcedureReturn 0   ; Prevent From Happening
    EndIf
  EndIf

  ProcedureReturn DefWindowProc_(hWnd, Msg, wParam, lParam)
EndProcedure

; ------------------------------------------------------------------
; Properly destroys the window created at startup (no memory leaks)
; ------------------------------------------------------------------
Procedure glKillWnd(FullscreenFlag.b);
  If FullscreenFlag = 1 ;  Change back To non fullscreen
    ChangeDisplaySettings_(0, 0)
    ShowCursor_(1)
  EndIf
 
  ; Makes current rendering context not current and releases the device
  ; context that is used by the rendering context.
  If wglMakeCurrent_(h_DC, 0) = 0
    MessageBox_(0, "Release of DC And RC failed!", "error?!", #MB_OK | #MB_ICONERROR)
  EndIf

  ; Attempts to delete the rendering context
  If wglDeleteContext_(h_RC) = 0
    MessageBox_(0, "Release of rendering context failed!", "error?!", #MB_OK | #MB_ICONERROR)
    h_RC = 0
  EndIf
 
  ; Attempts to release the device context
  If (h_DC = 1) And (ReleaseDC_(h_Wnd, h_DC) <> 0)
    MessageBox_(0, "Release of device context failed!", "error?!", #MB_OK | #MB_ICONERROR)
    h_DC = 0
  EndIf
 
  ; Attempts to destroy the window
  If (h_Wnd <> 0) And (DestroyWindow_(h_Wnd) = 0)
    MessageBox_(0, "Unable To destroy window!", "error?!", #MB_OK | #MB_ICONERROR)
    h_Wnd = 0
  EndIf

  ; Attempts to unregister the window class
  If UnregisterClass_("OpenGL", h_Instance) = 0
    MessageBox_(0, "Unable To unregister window class!", "error?!", #MB_OK | #MB_ICONERROR)
    h_Instance = 0
  EndIf
EndProcedure


;
; Creates the window and attaches an OpenGL rendering context to it
;
Procedure glCreateWnd(wWidth.l, wHeight.l, PixelDepth.b, FullscreenFlag.b)

  ClassName.s = "OpenGL"

  wndClass.WNDCLASS         ; Window class

  dwStyle.l                 ; Window styles
  dwExStyle.l               ; Extended window styles
  dmScreenSettings.DEVMODE  ; Screen settings (fullscreen, etc...)
  PixelFormat.l             ; Settings For the OpenGL rendering
  h_Instance.l               ; Current instance
  pfd.PIXELFORMATDESCRIPTOR ; Settings for the OpenGL window

  h_Instance = GetModuleHandle_(0);       Grab An Instance For Our Window
 
  ; Set up the window class
    wndClass\style         = #CS_HREDRAW | #CS_VREDRAW | #CS_OWNDC               
    ;                        CS_HREDRAW -> Redraws entire window If length changes
    ;                        CS_VREDRAW -> Redraws entire window If height changes
    ;                        CS_OWNDC   -> Unique device context For the window

    wndClass\hIcon         = LoadIcon_(0,#IDI_WINLOGO)
    wndClass\lpfnWndProc   = @WndProc() ; Set the window procedure to our func WndProc
    wndClass\hInstance     = h_Instance;
    wndClass\hCursor       = LoadCursor_(0, #IDC_ARROW);
    wndCLass\lpszClassName = @ClassName

  If RegisterClass_(wndClass) = 0 ; Attempt To register the window class
    MessageBox_(0, "Failed To register the window class!", "error?!", #MB_OK | #MB_ICONERROR)
    ProcedureReturn 0
  EndIf
 
  ; change to fullscreen if desired
  If FullscreenFlag = 1
    ; Set parameters For the screen setting
      dmScreenSettings\dmSize = SizeOf(DEVMODE)
      dmScreenSettings\dmPelsWidth  = wWidth       ; Window width
      dmScreenSettings\dmPelsHeight = wHeight      ; Window height
      dmScreenSettings\dmBitsPerPel = PixelDepth  ; Window color depth
      dmScreenSettings\dmFields     = #DM_PELSWIDTH | #DM_PELSHEIGHT | #DM_BITSPERPEL

   ; try to change screen mode to fullscreen
   If ChangeDisplaySettings_(dmScreenSettings, #CDS_FULLSCREEN) = #DISP_CHANGE_FAILED
      MessageBox_(0, "unable To switch to fullscreen!", "error?!", #MB_OK | #MB_ICONERROR)
      FullscreenFlag = 0
    EndIf
  EndIf


  ; If we are still in fullscreen then
  If FullscreenFlag = 1
    ; Creates a popup window | Doesn't draw within child windows | Doesn't draw within sibling windows
    dwStyle = #WS_POPUP | #WS_CLIPCHILDREN | #WS_CLIPSIBLINGS
    dwExStyle = #WS_EX_APPWINDOW   ; Top level window
    ShowCursor_(0)                 ; Turn of the cursor (gets in the way)
  Else
    ; Creates an overlapping window | Doesn't draw within child windows | Doesn't draw within sibling windows
    dwStyle = #WS_OVERLAPPEDWINDOW | #WS_CLIPCHILDREN | #WS_CLIPSIBLINGS
    ;  Top level window | Border with a raised edge
    dwExStyle = #WS_EX_APPWINDOW | #WS_EX_WINDOWEDGE
  EndIf

  ; Attempt To create the actual window
 
  ; given Parameters are as follows:
  ; Extended window styles , Class name , Window title (caption) , Window styles
  ; Window position , Size of window , No parent window , No menu , Instance , Pass nothing To WM_CREATE
 
  h_Wnd = CreateWindowEx_(dwExStyle, "OpenGL", #WNDTITLE, dwStyle, 0, 0, wWidth, wHeight, 0, 0, h_Instance, 0)

  If h_Wnd = 0
    MessageBox_(0, "Unable To create window!", "error?!", #MB_OK | #MB_ICONERROR)
    glKillWnd(FullscreenFlag)  ; Undo all the settings we've changed
    ProcedureReturn 0
  EndIf

  ; Try To get a device context
  h_DC = GetDC_(h_Wnd)
 
  If h_DC = 0
    glKillWnd(FullscreenFlag)
    MessageBox_(0, "Unable to get device context!", "error?!", #MB_OK | #MB_ICONERROR)
    ProcedureReturn 0
  EndIf

  ; Settings For the OpenGL window
  pfd\nSize           = SizeOf(PIXELFORMATDESCRIPTOR) ; Size Of This Pixel Format Descriptor
  pfd\nVersion        = 1                    ; The version of this data structure
                      ; Buffer supports drawing To window | Buffer supports OpenGL drawing | Supports double buffering
  pfd\dwFlags         = #PFD_DRAW_TO_WINDOW | #PFD_SUPPORT_OPENGL | #PFD_DOUBLEBUFFER
  pfd\iPixelType      = #PFD_TYPE_RGBA        ; RGBA color format
  pfd\cColorBits      = PixelDepth;           ; OpenGL color depth
  pfd\cRedBits        = 0;                    ; Number of red bitplanes
  pfd\cRedShift       = 0;                    ; Shift count for red bitplanes
  pfd\cGreenBits      = 0;                    ; Number of green bitplanes
  pfd\cGreenShift     = 0;                    ; Shift count for green bitplanes
  pfd\cBlueBits       = 0;                    ; Number of blue bitplanes
  pfd\cBlueShift      = 0;                    ; Shift count for blue bitplanes
  pfd\cAlphaBits      = 0;                    ; Not supported
  pfd\cAlphaShift     = 0;                    ; Not supported
  pfd\cAccumBits      = 0;                    ; No accumulation buffer
  pfd\cAccumRedBits   = 0;                    ; Number of red bits in a-buffer
  pfd\cAccumGreenBits = 0;                    ; Number of green bits in a-buffer
  pfd\cAccumBlueBits  = 0;                    ; Number of blue bits in a-buffer
  pfd\cAccumAlphaBits = 0;                    ; Number of alpha bits in a-buffer
  pfd\cDepthBits      = 16;                   ; Specifies the depth of the depth buffer
  pfd\cStencilBits    = 0;                    ; Turn off stencil buffer
  pfd\cAuxBuffers     = 0;                    ; Not supported
  pfd\iLayerType      = #PFD_MAIN_PLANE;      ; Ignored
  pfd\bReserved       = 0;                    ; Number of overlay and underlay planes
  pfd\dwLayerMask     = 0;                    ; Ignored
  pfd\dwVisibleMask   = 0;                    ; Transparent color of underlay plane
  pfd\dwDamageMask    = 0;                    ; Ignored

  ; Attempts To find the pixel format supported by a device context that
  ; is the best match To a given pixel format specification.
  PixelFormat = ChoosePixelFormat_(h_DC, @pfd)
  If PixelFormat = 0
    glKillWnd(FullscreenFlag)
    MessageBox_(0, "Unable To find a suitable pixel format", "error?!", #MB_OK | #MB_ICONERROR)
    ProcedureReturn 0
  EndIf

  ; Sets the specified device context's pixel format To the format specified by the PixelFormat.
  If SetPixelFormat_(h_DC, PixelFormat, @pfd) = 0
    glKillWnd(FullscreenFlag);
    MessageBox_(0, "Unable To set required pixel format", "error?!", #MB_OK | #MB_ICONERROR)
    ProcedureReturn 0
  EndIf

  ; Create a OpenGL rendering context
  h_RC = wglCreateContext_(h_DC)
 
  If h_RC = 0
    glKillWnd(FullscreenFlag)
    MessageBox_(0, "Unable To create an OpenGL rendering context", "error?!", #MB_OK | #MB_ICONERROR)
    ProcedureReturn 0
  EndIf

  ; Makes the specified OpenGL rendering context the calling thread's current rendering context
  If wglMakeCurrent_(h_DC, h_RC) = 0
    glKillWnd(FullscreenFlag);
    MessageBox_(0, "Unable To activate OpenGL rendering context", "error?!", #MB_OK | #MB_ICONERROR)
    ProcedureReturn 0
  EndIf

  ; Settings To ensure that the window is the topmost window
  ShowWindow_(h_Wnd, #SW_SHOW)
  SetForegroundWindow_(h_Wnd)
  SetFocus_(h_Wnd)

  ProcedureReturn 1
EndProcedure


;------------------------------------------------------------------


;
; anyone knows why pb doesn't have % ?
;
Procedure.l modulo(x,y)
  ; x % y ~ x - (x / y) * y
  ProcedureReturn x-(x/y)*y
EndProcedure

;
;
;
Procedure drawTunnelNew(ElapsedTime.f, wireframe)
  Shared tunnelTex, plasmaTex
 
  glDisable_(#GL_FOG)

  glEnable_(#GL_CULL_FACE)                             ; do not calculate inside of poly's
  glDisable_(#GL_BLEND)
  glDisable_(#GL_LIGHTING)

  glClear_(#GL_COLOR_BUFFER_BIT | #GL_DEPTH_BUFFER_BIT);     Clear The Screen And The Depth Buffer
  glLoadIdentity_()
 
   glTranslatef_(0.0, 0.0, -4.2)

 
   glPolygonMode_(#GL_FRONT, #GL_FILL)
   glPolygonMode_(#GL_BACK, #GL_FILL)

 ; 'ElapsedTime' is used as the angle here
 For i.b=0 To 32
  For j.b=0 To 32
    ; precalc texture-coordinates (this way only works for 24bit images)
    texcord(i,j)\u = (i / 32.0 + Cos(((ElapsedTime*3) + 8 * j) / 60.0) / 2)
    texcord(i,j)\v = (j / 32.0 + ((ElapsedTime*3) + j) / 120)
 
    ; setup tunnel
    imgArray(i,j)\x = (3.0 - j/12.0)*(Cos(2.0*#PI/32*i)+ 2*Sin((ElapsedTime+2*j)/29) + Cos((ElapsedTime+2*j)/13) - 2*Sin(ElapsedTime/29) - Cos(ElapsedTime/13))
    imgArray(i,j)\y = (3.0 - j/12.0)*(Sin(2.0*#PI/32*i)+ 2*Cos((ElapsedTime+2*j)/33) + Sin((ElapsedTime+2*j)/17) - 2*Cos(ElapsedTime/33) - Sin(ElapsedTime/17))
    imgArray(i,j)\z = -j
  Next
 Next


 glColor3f_(0.8, 1.0, 0.9)
 glEnable_(#GL_TEXTURE_2D)
 glBindTexture_(#GL_TEXTURE_2D, plasmaTex)


  ; draw cylinder for tunnel
  For xl.b=0 To 31
   glBegin_(#GL_QUADS)
    For yl.b=0 To 31
 
     glTexCoord2f_(texcord(xl,yl)\u, texcord(xl,yl)\v)
     glVertex3f_(imgArray(xl,yl)\x, imgArray(xl,yl)\y, imgArray(xl,yl)\z)

     glTexCoord2f_(texcord(xl+1,yl)\u, texcord(xl+1,yl)\v)
     glVertex3f_(imgArray(xl+1,yl)\x, imgArray(xl+1,yl)\y, imgArray(xl,yl)\z)

     glTexCoord2f_(texcord(xl+1,yl+1)\u, texcord(xl+1,yl+1)\v)
     glVertex3f_(imgArray(xl+1,yl+1)\x, imgArray(xl+1,yl+1)\y, imgArray(xl,yl+1)\z)

     glTexCoord2f_(texcord(xl,yl+1)\u, texcord(xl,yl+1)\v)
     glVertex3f_(imgArray(xl,yl+1)\x, imgArray(xl,yl+1)\y, imgArray(xl,yl+1)\z)

    Next
   glEnd_()
  Next 

  glMatrixMode_(#GL_PROJECTION)   ; Switch to projection matrix
  glPopMatrix_()                  ; Restore the old projection matrix
  glMatrixMode_(#GL_MODELVIEW)    ; Return to modelview matrix
  glPopMatrix_()                  ; Restore old modelview matrix
  glDisable_(#GL_TEXTURE_2D)      ; Turn on textures, don't want our text textured
  glPopAttrib_()                  ; Restore depth testing     

  glEnable_(#GL_BLEND)
  glDisable_(#GL_CULL_FACE)
  glEnable_(#GL_FOG)
  glEnable_(#GL_LIGHTING)
  glEnable_(#GL_DEPTH_TEST)
EndProcedure

;
; create textures
;
Procedure _CreateTexture(pData.l, mode.s, mipmapping.b, bmpWidth.l, bmpHeight.l)

  If pData = 0
    MessageBox_(0, "unable to load texture", ":textureLib", #MB_OK | #MB_ICONERROR)
  Else

  glGenTextures_(1, @texture)
  glBindTexture_(#GL_TEXTURE_2D, texture)
  glTexEnvi_(#GL_TEXTURE_ENV, #GL_TEXTURE_ENV_MODE, #GL_MODULATE)       ; Texture blends with object background
  glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MAG_FILTER, #GL_LINEAR)  ; only first two can be used
 
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

;
; load BMPs from memory-locations (IncludeBinary)
; loads 8, 16 and 24bit bmps
;
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
    ; MessageBox_(0, "invalid bmpfile @"+Str(memlocation), "error?!", #MB_OK)
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
    InfoHeader\biSizeImage = (InfoHeader\biWidth * InfoHeader\biHeight * InfoHeader\biBitCount / 8)
  EndIf

  ; allocate enough mem to store the bitmap
  Dim bitmapImage.b (InfoHeader\biSizeImage)

;  bitmapImage = AllocateMemory(0,InfoHeader\biSizeImage,0)

  ; read in the bitmap image data
  For i.l=FileHeader\bfOffBits To InfoHeader\biSizeImage
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

  ; cleanup
;  FreeMemory(0)
  Dim bitmapImage.b(0)

  ProcedureReturn texture
EndProcedure


;
; generates a plasma-like-texture
;
Procedure initPlasma(size.b, mode.s)
  Dim plasma.b(size*size*3)

  For i=0 To size*size*3 Step 3
    Temp = 114 * #PI * i/512
    val  = Sin(temp/2) * 128 + 8
    PokeB(@plasma(i), val)
  Next

  For i=1 To size*size*3 Step 3
    Temp =4 * #PI * i/512
    val  = Sin(temp/2) * 128 + 8
    PokeB(@plasma(i), val)
  Next

  For i=2 To size*size*3 Step 3
    Temp = 16 * #PI * i/512
    val  = Sin(temp/2) * 128 + 8
    PokeB(@plasma(i), val)
  Next

 
  Shared plasmaTex
  plasmaTex = _CreateTexture(plasma(), mode.s, 1, size, size)  ; this looks good ;)

  ; clean up
  Dim plasma.b(0)
EndProcedure


;
; this is due to problems with the real glScissors
; doh! what a waste...
;
Procedure drawScissor(y.f)
  ; render a blank quad
  glLoadIdentity_()
  x.f=-2.5
  z.f=-3.0

  glDisable_(#GL_FOG)
  glDisable_(#GL_BLEND)
  glDisable_(#GL_LIGHTING)
 
  glColor3f_(0, 0, 0.1)

  glTranslatef_(x.f, y, z)
 
  glBegin_(#GL_QUADS)
    glVertex2f_(0.0,0.0)
    glVertex2f_(0.0,0.5)
    glVertex2f_(5.0,0.5)
    glVertex2f_(5.0,0.0)
  glEnd_()

  glEnable_(#GL_LIGHTING)
  glEnable_(#GL_BLEND)
  glEnable_(#GL_FOG)
EndProcedure

;------------------------------------------------------------------

;
; build the font displaylists
;
Procedure BuildFont()
  Shared base.l, fontTex
  base.l = glGenLists_(128)                       ; Creating 256 Display Lists

  glBindTexture_(#GL_TEXTURE_2D, fontTex)         ; Select Our Font Texture

  For loop.l = 0 To 128                           ; Loop Through All 256 Lists
    cx.f = ( modulo(loop, 16) ) / 16               ; X Position Of Current Character
    cy.f = ( Round(loop/16,0) ) / 8               ; Y Position Of Current Character
 
    glNewList_(base+loop, #GL_COMPILE)            ; Start Building A List
    glBegin_(#GL_QUADS)                           ; Use A Quad For Each Character
      glTexCoord2f_(cx, 1.0 - cy.f - 0.0625*2)                     ; Texture Coord (Bottom Left)
      glVertex2i_(0, 0)                           ; Vertex Coord (Bottom Left)
      glTexCoord2f_(cx + 0.0625, 1.0 - cy.f - 0.0625*2) ; Texture Coord (Bottom Right)
      glVertex2i_(#fntSize, 0)                           ; Vertex Coord (Bottom Right)
      glTexCoord2f_(cx + 0.0625, 1.0 - cy)    ; Texture Coord (Top Right)
      glVertex2i_(#fntSize, #fntSize)                          ; Vertex Coord (Top Right)
      glTexCoord2f_(cx, 1.0 - cy)               ; Texture Coord (Top Left)
      glVertex2i_(0, #fntSize)                           ; Vertex Coord (Top Left)
    glEnd_()                                      ; Done Building Our Quad (Character)

    glTranslatef_(#fntSize-(#fntSize/3), 0.0, 0.0)
    glEndList_()                                  ; Done Building The Display List
  Next                                            ; Loop Until All 256 Are Built
EndProcedure

;
; delete the font displaylists from mem
;
Procedure KillFont()
  glDeleteLists_(base, 128) ; Delete All 256 Display Lists
EndProcedure
 
;
; print a single char
;
Procedure glPrintChar(x.f, y.f, alpha.f, scale.f, char.s)
  Shared base, fontTex

  glPolygonMode_(#GL_BACK,#GL_FILL)
  glPolygonMode_(#GL_FRONT,#GL_FILL)
  glDisable_(#GL_LIGHTING)

  glEnable_(#GL_TEXTURE_2D)
  glEnable_(#GL_BLEND)
  glBindTexture_(#GL_TEXTURE_2D, fontTex);          Select Our Font Texture
  glDisable_(#GL_DEPTH_TEST);                Disables Depth Testing
  glMatrixMode_(#GL_PROJECTION);                Select The Projection Matrix
  glPushMatrix_();                   Store The Projection Matrix
  glLoadIdentity_();                   Reset The Projection Matrix
  glOrtho(0, #appWidth, 0, #appHeight, -100, 100);             Set Up An Ortho Screen
  glMatrixMode_(#GL_MODELVIEW);                Select The Modelview Matrix
  glPushMatrix_();                   Store The Modelview Matrix
  glLoadIdentity_();                   Reset The Modelview Matrix
  glTranslatef_(x, y, 0)
  glColor3f_(alpha.f, alpha.f, alpha.f)
  glScalef_(scale.f, scale.f, 1.0)

  glCallList_(Asc(char)-31);          Write The Text To The Screen
  glMatrixMode_(#GL_PROJECTION);                Select The Projection Matrix
  glPopMatrix_();                   Restore The Old Projection Matrix
  glMatrixMode_(#GL_MODELVIEW);                Select The Modelview Matrix
  glPopMatrix_();                   Restore The Old Projection Matrix
  glEnable_(#GL_DEPTH_TEST);                Enables Depth Testing
  glDisable_(#GL_BLEND)
  glDisable_(#GL_TEXTURE_2D)
 
  glEnable_(#GL_LIGHTING)
EndProcedure

;
;
;
Procedure glResizeWnd2()
 
  glViewport_(0, 0, #appWidth, #appHeight);     Set the viewport for the OpenGL window
  glMatrixMode_(#GL_PROJECTION);         Change Matrix Mode to Projection
  glLoadIdentity_();                    Reset View

  gluPerspective(45.0, #appWidth/#appHeight, 1.0, 100.0);   Do the perspective calculations. Last value = max clipping depth

  glMatrixMode_(#GL_MODELVIEW);          Return to the modelview matrix
  glLoadIdentity_();                    Reset View
EndProcedure


;------------------------------------------------------------------
;  Initialise OpenGL                                               
;------------------------------------------------------------------
Procedure glInit2()
  glShadeModel_(#GL_SMOOTH);                  Enables Smooth Color Shading
  glEnable_(#GL_DEPTH_TEST);                  Enable Depth Buffer
  glDepthFunc_(#GL_LESS);                  The Type Of Depth Test To Do
  glBlendFunc_(#GL_SRC_ALPHA, #GL_ONE)

  glHint_(#GL_PERSPECTIVE_CORRECTION_HINT, #GL_NICEST);   Realy Nice perspective calculations

  glEnable_(#GL_TEXTURE_2D);                      Enable Texture Mapping

  Shared fontTex
  fontTex = LoadBMPTextureMem(?fonttex, "luminance", 8, 0)
;  tunnelTex= LoadBMPTextureMem(?tunneltex, "rgb", 24, 0) 
  BuildFont()
EndProcedure

;------------------------------------------------------------------

; main
;If MessageBox_(0, "run fullscreen?", "[100% PureBasic]", #MB_YESNO | #MB_ICONQUESTION) = 6
;  FullscreenFlag = 1
;Else
  FullscreenFlag = 0
;EndIf

; open screen
If glCreateWnd(#appWidth, #appHeight, 32, FullscreenFlag) = 0
  End
EndIf

; generate different textures based on parameter
If ProgParam$ = "-1" Or ProgParam$ = ""
  initPlasma(16, "luminance")
EndIf

If ProgParam$ = "-2"
  initPlasma(32, "rgb")
EndIf

If ProgParam$ = "-3"
  initPlasma(48, "luminance")
EndIf
 
glInit2()

AppStart = GetTickCount_() ; get starttime of app


  ; resize window
; glViewport_(0,0,#appWidth,#appHeight);                                  Reset The Current Viewport
                   
 glMatrixMode_(#GL_PROJECTION);                                  Select The Projection Matrix
 glLoadIdentity_();                                           Reset The Projection Matrix

 gluPerspective(45.0, #appWidth/#appHeight, 1.0, 100.0)

 glMatrixMode_(#GL_MODELVIEW);                                     Select The Modelview Matrix
 glLoadIdentity_();   

;
;
;
Procedure readText2(delay)
  Shared txt$, txt2$, al.f;, sl.f,kk.f

  ; using threads and delay() lets me don't care about anything ;)
  Repeat

    Read txt$
    Read tmd$
         
    al.f = 0  ; 'alpha' 
   
    ; single letters
;    If txt$<>"+++"
      For lc=1 To Len(txt$)
        txt2$ = Mid(txt$, 1, lc)

;          If Mid(txt$,lc,1) = "§"
;            yl+50
;          EndIf

        sl.f+0.05
             
        ; 'fade-in'
        If al.f<0.7
          al.f+0.06
        EndIf
       
       
        ; only delay if letter isn't a [space]   

        If Mid(txt$, lc, 1) <> " "
          Delay(delay)
;        kk+0.01
        EndIf

      Next
;    EndIf


    ; reset text
    If txt$ = "###"
      Restore txtdata
      txt2$ = txt$
    EndIf
 
   
   
    Delay(Val(tmd$))
  ForEver
EndProcedure



CreateThread(@readText2(), 20) ; variable is the delay-time

;
; MAIN - LOOP
;
Repeat

;  ExamineKeyboard()
     
  If PeekMessage_(@WndProcMsg, 0, 0, 0, #PM_REMOVE)  ; Check If there is a message For this window
    ;translate And dispatch the message To this window
    TranslateMessage_(@WndProcMsg)
    DispatchMessage_(@WndProcMsg)
  EndIf
   
  FPSCount+1    ; Increment FPS Counter

  LastTime = ElapsedTime
  ElapsedTime = GetTickCount_() - AppStart     ; Calculate Elapsed Time
  ElapsedTime = (LastTime + ElapsedTime) / 2 ; Average it out for smoother movement

    drawTunnelNew(ElapsedTime*0.02, 0)
 
    If txt2$<>"###"
   
      i2.f=ElapsedTime*0.003
     
      x3l.w = 0 : y3l.w = 0
     
      For i = 1 To Len(txt$)
        txt3$ = Mid(txt2$, i, 1)

        ; waveblur
;        glPrintChar(32 + x3l*22+Sin(i2+i/4+sl)*4, 345-y3l, 0.4, 1.0 + Sin(i2+i/4+sl)*0.03, txt3$)
;        glPrintChar(32 + x3l*22+Cos(i2+i/4+sl)*0.5, 345-y3l, 0.9, 1.0 + Sin(i2+i/4+sl)*0.03, txt3$)

        glPrintChar(32 + x3l*22+Cos(i2+i/4+sl)*0.5, 345-y3l, 0.2, 1.0 + Sin(i2+i/4+sl)*0.03, txt3$)
        glPrintChar(32 + x3l*22+Sin(i2+i/4+sl)*4, 345-y3l, 0.6, 1.0 + Sin(i2+i/4+sl)*0.03, txt3$)

        ; oldskool - sin movement
;        glPrintChar(x3l*20, 280+Sin(i2+i/4+sl)*15 - y3l, 0.1+Sin(i2+i/4+sl)*0.5, 1, txt3$)
;        glPrintChar(52 + x3l*22, 345+Sin(i2+i/4+sl)*15 - y3l - 30, 0.1+Sin(i2+i/4+sl)*0.4, 0.9, txt3$)

        ; new line
        If txt3$="§"
          x3l=0
          y3l+30
        Else
          x3l+1
        EndIf 
         
      Next
     
    EndIf

  ; draw 'tv-screen'
  drawScissor(0.8)
  drawScissor(-1.3)
 
  ; display the scene (flipscreens)
  SwapBuffers_(h_DC)

  Delay(2)    ; don't lock up cpu

Until quit=1


;
; quit app
;
glKillWnd(FullscreenFlag)
End


;
;------------------------------------------------------------------
;
DataSection
  fonttex:
  IncludeBinary "font.bmp"
  ;IncludeBinary "20thCentury_8bit_sm2.bmp"

  txtdata:
  ; "text", "time" - § means new line
  Data.s "+++++++++++++++++++++++++§+                       +§+        WELCOME        +§+     TO THIS SMALL     +§+     DEMONSTRATION     +§+       in 100 %        +§+      PUREBASIC!!      +§+                       +§+++++++++++++++++++++++++§", "6000"
  Data.s "+++++++++++++++++++++++++§+                       +§+                       +§+ FOR MORE INFORMATION  +§+     PLEASE VISIT      +§+   www.purebasic.com   +§+                       +§+                       +§+++++++++++++++++++++++++§", "6000"
  Data.s "###"    ; end of text
EndDataSection 

; IDE Options = PureBasic v4.01 (Windows - x86)
; Folding = ---
; Executable = D:\Dokumente und Einstellungen\Musik\Desktop\pbtest2.exe
; DisableDebugger