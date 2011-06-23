; English forum:
; Author: MrVain^SCL aka Thorsten Will (updated for PB4.00 by blbltheworm)
; Date: 31. December 2002
; OS: Windows
; Demo: No

; -----------------------------------------------------------------------------------------------------------------------
;
;   PureBasic Line() - Newskool Budbrain Effect - Example File v1.0
;
;   by MrVain^SCL aka Thorsten Will - (c) 2002 - Fantaisie Software
;
; -----------------------------------------------------------------------------------------------------------------------

    Info.SYSTEMTIME                           ; Init Win32 System Structure for SystemTime

    #scrw = 640                               ; Screenwidth
    #scrh = 480                               ; Screenhigh
    #scrd = 16                                ; Screendepth (16/24/32 bit)

    title$ = "PureBasic Line() - Newskool Budbrain Effect v1.0"

; -----------------------------------------------------------------------------------------------------------------------
; D E F I N E   V A R I A B L E S + V A L U E
; -----------------------------------------------------------------------------------------------------------------------
;- DefineVars
    
    cax  = 320
    cay  = 240
    cbx  = 320
    cby  = 240
    a.f  = 0
    b.f  = 8
    r1.f = 200
    r2.f = 100
    sl.f = 8
    sc.f = 4

; -----------------------------------------------------------------------------------------------------------------------
; P R O C E D U R E S
; -----------------------------------------------------------------------------------------------------------------------
;- Procedures

; -----------------------------------
; PROC - MyGSin()                                            
; -----------------------------------

    Procedure.f MyGSin(winkel.f) 
        result.f = Sin(winkel*0.01745329)               ; (2*3.14159265/360)) 
        ProcedureReturn result 
    EndProcedure 

; -----------------------------------
; PROC - MyGCos()                                            
; -----------------------------------

    Procedure.f MyGCos(winkel.f) 
        result.f = Cos(winkel*0.01745329)               ; (2*3.14159265/360)) 
        ProcedureReturn result 
    EndProcedure 

; -----------------------------------------------------------------------------------------------------------------------
; I N I T - S T A R T U P 
; -----------------------------------------------------------------------------------------------------------------------

    SetPriorityClass_(GetCurrentProcess_(), 13 )      ; Set our task to high priority (13)

    If LoadFont (0,"Arial",32) = 0
       MessageBox_ (0,"Can't open Arial Font", title$, #MB_ICONINFORMATION|#MB_OK)
    EndIf
  
    setup_mode = MessageBox_(0,"Do you wish to run in Fullscreen?", title$, #MB_YESNOCANCEL) 

; -----------------------------------------------------------------------------------------------------------------------
; I N I T   S Y S T E M - S T U F F 
; -----------------------------------------------------------------------------------------------------------------------
;- InitSystemStuff

    If InitSprite() = 0 Or InitKeyboard() = 0 Or InitSprite3D() = 0
       MessageBox_ (0,"Can't open DirectX 7 or later", title$, #MB_ICONINFORMATION|#MB_OK)
       End
    EndIf

    ; -------- Check Display Mode -------
   
    Select setup_mode                         ; 6 = yes (FullScreen) | 7 = no (WindowedMode)
        Case 6                                         
          If OpenScreen(#scrw,#scrh,#scrd, title$) = 0  
            MessageBox_ (0,"Could not open 640x480x"+Str(#scrd)+"screen", title$, #MB_ICONINFORMATION|#MB_OK) 
            End                                                                                     
          EndIf
          ;                   
        Case 7  
          If OpenWindow(0,(GetSystemMetrics_(#SM_CXSCREEN)-#scrw)/2,(GetSystemMetrics_(#SM_CYSCREEN)-#scrh)/2,#scrw,#scrh, title$,#PB_Window_MinimizeGadget) = 0
            MessageBox_ (0,"Could not open Window", title$, #MB_ICONINFORMATION|#MB_OK) 
            End                                                                                     
          EndIf
          ;                
          If OpenWindowedScreen(WindowID(0),0,0,#scrw,#scrh,0,0,0) = 0
            MessageBox_ (0,"Could not open 640x480x"+Str(#scrd)+"screen", title$, #MB_ICONINFORMATION|#MB_OK) 
            End                                                                                     
          EndIf
          ;
          setup_mode = 1                      ; TestVal, when running in WindowedMode we have to check WindowEvents!
          GetForegroundWindow_()              ; Set to get Window in forground!
        Case 2
          End                                 ; Setup aborted to quit
    EndSelect

; -----------------------------------------------------------------------------------------------------------------------

    Gosub SUB_CreateBG                        ; Sprite 0 - Create Background 
    CreateSprite(1,320,64,0)                  ; Sprite 1 - Create Sprite for Timer Display

    LoadSprite(4,"..\Gfx\LightCircle.bmp",#PB_Sprite_Texture)
    ; CatchSprite(4,?Inc_Light,#PB_Sprite_Texture) 
    CreateSprite3D(4,4)                       ; Create Lighting Circle for end of lines

; -----------------------------------------------------------------------------------------------------------------------
; M A I N L O O P        
; -----------------------------------------------------------------------------------------------------------------------
;- MainLoop

    Repeat 
        DisplaySprite(0,0,0)                          ; Display Background 
        DisplayTransparentSprite(1,0,400)             ; Display Timer
        ;
        ; -------- Check for Events when running in WindowedMode --------
        ;
        If setup_mode = 1                             ; Check only when in WindowedMode
          Event = WindowEvent()                       ; Get Events and check...
          ;
          Select Event
            Case #PB_Event_CloseWindow                ; Window was closed
                quit = 1                              ; Quit Demonstration         
          EndSelect
          ;
        EndIf 
        ;
        ; -------- 
        ;
        Gosub SUB_GetTime                             ; Get actual time
        col.l = 16                                    ; Set color value
        ;
        ; -------- Draw Lines with Circles at every point --------
        ;         
        For n = 0 To 360 Step 8 
          a = b + n       
          ;
          pointa.f = cax + r1 * MyGCos(a)
          pointb.f = cay + r1 * MyGSin(a) / 2
          pointc.f = cbx - r2 * MyGCos(a) / 1.5
          pointd.f = cby - r2 * MyGSin(a)
          ;   
          StartDrawing(ScreenOutput())   
              LineXY (pointa, pointb, pointc, pointd, RGB(col,col+32,col+48))    
;             Circle (pointa, pointb, n/64)         ; Display Example 1
;             Circle (pointc, pointd, n/64)         ; Display Example 1
;             Circle (pointa, pointb, 3)            ; Display Example 2
;             Circle (pointc, pointd, 3)            ; Display Example 2
       
       
   
       
       
          StopDrawing()
          ;
          col + sc
        Next 
        ;
        

        
        ; -------- Start 3D Drawings --------
        ; 
        For n = 0 To 360 Step 8 
          a = b + n
          ;            
          vaina.f = cax + r1 * MyGCos(a)
          vainb.f = cay + r1 * MyGSin(a)/2
          vainc.f = cbx - r2 * MyGCos(a)/1.5
          vaind.f = cby - r2 * MyGSin(a)
          ;
          Start3D()
              Sprite3DBlendingMode( 3,2)  
              ZoomSprite3D(4,40,40)
              DisplaySprite3D(4,vaina-20,vainb-20,10)
              DisplaySprite3D(4,vainc-20,vaind-20,10)
          Stop3D() 
          ;
          c+sc
        Next
        ;
        
                StartDrawing(ScreenOutput())
                      Gosub SUB_FPS
            ;          
            DrawingMode(1) 
            FrontColor(RGB(255,255,255)) 
            DrawText(1,1,"FPS: "+fps$)    
        
        
        StopDrawing()
        
        ; -------- Change vals to get moving object --------
        ;          
        b + 1
        cax = 320 + 90 * MyGCos (b   / 1.2)
        cby = 240 + 80 * MyGSin (1.3 * b)
        cbx = 320 - 90 * MyGSin (b   * 1.4)
        cay = 240 - 80 * MyGCos (b   / 1.2)
        ; 
        ; -------- FlipBuffers and Check for EscapeKey --------
        ;
        FlipBuffers()
        ExamineKeyboard()
        ; 
    Until KeyboardPushed(#PB_Key_Escape) Or quit=1   
End

; -----------------------------------------------------------------------------------------------------------------------
; S U B R O U T I N E S                                       
; -----------------------------------------------------------------------------------------------------------------------

; -----------------------------------
; SUB - Create Background Graphic                                            
; -----------------------------------
;- SUB_CreateBG



SUB_FPS:                                            ; Found on forum, optimize this soon!
 
    If Val(FormatDate("%ss", Date()))=sek 
      fps+1 
    Else 
      fps$=Str(fps) 
      fps=0 
    EndIf 
    ;
    sek=Val(FormatDate("%ss", Date())) 
    ;
Return 

SUB_CreateBG:
  
    CreateSprite(0,640,480,0)               ; Sprite 0 - Reserved for Background Graphic
    ;
    StartDrawing(SpriteOutput(0))           ; Draw the Background as Sprite 
        ;
        cv = 640/32 
        ;
        Box (0,0,640,480,RGB(0,30,40))      ; Fill Background in needed color       
        ;
        ; -------- Create Background Circle Graphic --------
        ;
        For iv = 0  To 32  
          For jv = 0 To 48
            Circle (iv*cv+kv/2+jv, jv*cv+kv/2 +4, 1+iv,  RGB(0,40,60))
          Next
        Next         
        ;                  
        For iv = 0  To 32  
          For jv = 0 To 48
           ; Circle (280+iv*cv+kv/2+jv, jv*cv+kv/2 +4, 1+iv,  RGB(0,30,40))
          Box (280+iv*cv+kv/2+jv, jv*cv+kv/2 +4, 10,10,  RGB(0,30,40))


          Next
        Next                   
        ;      
        ; -------- Draw Dezign Lines --------    
        ;
        Line (0,420,640-1,0,RGB(255,255,255))      
        Line (0,430,640-1,0,RGB(255,255,255))
        ;    
    StopDrawing()

Return

; -----------------------------------
; SUB - Get actual time as sprite                                           
; -----------------------------------
;- SUB_GetTime

SUB_GetTime:                                  ; Not optimized 

    GetLocalTime_(Info)
    newsec = Info\wSecond
    ;
    ; -------- If actual time <> oldtime, we will create a new sprite + actual timer -------
    ;
    If oldsec <> newsec
      ;
      ; -------- Get actual Hour --------
      ;
      If Info\wHour < 10 
        text$ = "0"+Str(Info\wHour) +":" 
      Else 
        text$ = Str(Info\wHour) +":"
      EndIf    
      ;
      ; -------- Get actual Minute --------
      ;
      If Info\wMinute < 10 
        text$ = text$ + "0"+Str(Info\wMinute) +":" 
      Else 
        text$ = text$ + Str(Info\wMinute) +":"
      EndIf    
      ;
      ; -------- Get actual Seconds --------
      ;
      If Info\wSecond < 10 
        text$ = text$ + "0"+Str(Info\wSecond) 
      Else 
        text$ = text$ + Str(Info\wSecond)
      EndIf  
      ;
      ; --------
      ;
      StartDrawing(SpriteOutput(1))
          Box (0,0,320,45)
          ;
          DrawingFont(FontID(0))   
          FrontColor (RGB(8,8,8)) 
          DrawingMode(1)
          ;           
          For tx = -3 To 3
            For ty = -3 To 3
              DrawText (40+tx,ty,text$)
            Next  
          Next
         ;
          FrontColor(RGB(255,255,255))      
          DrawText (40,0,text$)                              
         ;
      StopDrawing()
      ;
    EndIf
    ;
    ; -------- End of creating new sprite --------
    ; 
    oldsec = Info\wSecond
    ;
Return

; -----------------------------------------------------------------------------------------------------------------------

; DataSection
;   Inc_Light:
;       IncludeBinary "Gfx/LightCircle.bmp"
; 
; EndDataSection


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; Executable = D:\4Fred\Example_BudbrainBeta.exe
; DisableDebugger