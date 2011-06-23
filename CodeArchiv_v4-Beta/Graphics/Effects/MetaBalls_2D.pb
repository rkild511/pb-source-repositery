; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9265
; Author: Shopro (updated for PB 4.00 by Andre)
; Date: 23. January 2004
; OS: Windows
; Demo: Yes

Declare Generate_Texture() 
Declare Init_Palette() 
Declare Render_Blob(Blob_Pos_X, Blob_Pos_Y) 
Declare Render_Screen_Buffer() 
Declare Render_Screen_Clear() 

; Constants 
#General_Title$ = "2d metaballs demo" 
#General_Version$ = "v0.5" 
#General_Author$ = "Kenji Gunn" 
#General_Date$ = "2004/01/23" 

#Window_Size_X = 639 
#Window_Size_Y = 479 

#Blob_Size_X = 255 
#Blob_Size_Y = 255 

; Variables 
Global Event_ID.l 

Global Render_Line_X.w 

; Dimensions 
Global Dim Texture.w(255, 255) 
Global Dim Pal_Blob.l(255) 
Global Dim Screen_Buffer(#Window_Size_X, #Window_Size_Y) 

InitSprite() 
InitKeyboard() 
InitMouse() 

OpenWindow(0, 0, 0, #Window_Size_X + 1, #Window_Size_Y + 1, #General_Title$ + " " + #General_Version$, #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
OpenWindowedScreen(WindowID(0), 0, 0, #Window_Size_X + 1, #Window_Size_Y + 1, 1, 0, 0) 

Init_Palette() 
Generate_Texture() 

Repeat 
  Event_ID = WindowEvent() 
  ExamineKeyboard() 
  ExamineMouse() 
  
  Render_Blob(320, 240) 
  Render_Blob(MouseX(), MouseY()) 
  Render_Screen_Buffer() 

  FlipBuffers() 
  
  Render_Screen_Clear() 
Until KeyboardPushed(#PB_Key_Escape) Or Event_ID = #PB_Event_CloseWindow 

Procedure Generate_Texture() 
  Protected x, y 
  Protected d.f, c.l 
  
  For x = -128 To 127 Step 1 
    For y = -128 To 127 Step 1 
      d = Sqr(x * x + y * y) 
      If d <= 128 
        c = 160 * Cos(d * 3.14159 / 128) + 160 
        If c > 255 
          c = 255 
        EndIf 
        Texture(x + 128, y + 128) = c 
      EndIf 
    Next 
  Next 
EndProcedure 

Procedure Init_Palette() 
  Protected Init_Palette 
  
  For Init_Palette = 0 To 63 
    Pal_Blob(Init_Palette) = RGB(0, 0, 0) 
  Next 
  For Init_Palette = 0 To 63 
    Pal_Blob(Init_Palette + 64) = RGB(0, 0, Int(255 / 64 * Init_Palette)) 
  Next 
  For Init_Palette = 0 To 127 
    Pal_Blob(Init_Palette + 64 + 64) = RGB(Int(255 / 127 * Init_Palette), Int(255 / 127 * Init_Palette), 250) 
  Next 
  
  Pal_Blob(255) = RGB(255,255,255) 
EndProcedure 

Procedure Render_Blob(Blob_Pos_X, Blob_Pos_Y) 
  Protected Render_Blob_X.w, Render_Blob_Y.w 
  Protected Render_Blob_Start_X.w, Render_Blob_Start_Y.w 
  Protected Render_Blob_End_X.w, Render_Blob_End_Y.w 
  Protected Render_Blob_Color.w 
  
  If Blob_Pos_X < 0 
    Render_Blob_Start_X = -Blob_Pos_X 
  ElseIf Blob_Pos_X + #Blob_Size_X > #Window_Size_X 
    Render_Blob_End_X = #Window_Size_X - Blob_Pos_X 
  Else 
    Render_Blob_End_X = 255 
  EndIf 
  If Blob_Pos_Y < 0 
    Render_Blob_Start_Y = -Blob_Pos_Y 
  ElseIf Blob_Pos_Y + #Blob_Size_Y > #Window_Size_Y 
    Render_Blob_End_Y = #Window_Size_Y - Blob_Pos_Y 
  Else 
    Render_Blob_End_Y = 255 
  EndIf 
  
  For Render_Blob_Y = Render_Blob_Start_Y To Render_Blob_End_Y 
    For Render_Blob_X = Render_Blob_Start_X To Render_Blob_End_X 
      Render_Blob_Color = Screen_Buffer(Blob_Pos_X + Render_Blob_X, Blob_Pos_Y + Render_Blob_Y) + Texture(Render_Blob_X, Render_Blob_Y) 
      If Render_Blob_Color > 255 
        Render_Blob_Color = 255 
      EndIf 
      Screen_Buffer(Blob_Pos_X + Render_Blob_X, Blob_Pos_Y + Render_Blob_Y) = Render_Blob_Color 
    Next 
  Next 
EndProcedure 

Procedure Render_Screen_Buffer() 
  Protected Render_Screen_Buffer_X.w, Render_Screen_Buffer_Y.w 
  
  StartDrawing(ScreenOutput()) 
  For Render_Screen_Buffer_Y = 0 To #Window_Size_Y 
    For Render_Screen_Buffer_X = 0 To #Window_Size_X 
      Plot(Render_Screen_Buffer_X, Render_Screen_Buffer_Y, Pal_Blob(Screen_Buffer(Render_Screen_Buffer_X, Render_Screen_Buffer_Y))) 
    Next 
  Next 
  StopDrawing() 
EndProcedure 

Procedure Render_Screen_Clear() 
  Dim Screen_Buffer(#Window_Size_X, #Window_Size_Y) 
EndProcedure 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger