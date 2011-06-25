;
; ------------------------------------------------------------
;
;   PureBasic - Common 3D functions
;
;    (c) 2003 - Fantaisie Software
;
; ------------------------------------------------------------
;

#WINDOW_Screen3DRequester = 0

#GADGET_FullScreen        = 1
#GADGET_Windowed          = 2
#GADGET_ScreenModesLabel  = 3
#GADGET_WindowedModes     = 4
#GADGET_Launch            = 5
#GADGET_Cancel            = 6
#GADGET_Logo              = 7
#GADGET_Frame             = 8
#GADGET_ScreenModes       = 9

Global Screen3DRequester_FullScreen, Screen3DRequester_ShowStats

Procedure Screen3DRequester()

  OpenPreferences("Demos3D.prefs")
    FullScreen          = ReadPreferenceLong  ("FullScreen"        , 1)
    FullScreenMode$     = ReadPreferenceString("FullScreenMode"    , "640x480")
    WindowedScreenMode$ = ReadPreferenceString("WindowedScreenMode", "512x384")


  If OpenWindow(#WINDOW_Screen3DRequester, 0, 0, 396, 205, "PureBasic - 3D Demos", #PB_Window_ScreenCentered | #PB_Window_SystemMenu | #PB_Window_Invisible)
    
    Top = 6
    
    ImageGadget  (#GADGET_Logo, 6, Top, 0, 0, LoadImage(0,"Data/PureBasicLogo.bmp"), #PB_Image_Border) : Top+76
    
    Frame3DGadget(#GADGET_Frame, 6, Top, 384, 80, "", 0) : Top+20
    
    OptionGadget(#GADGET_FullScreen, 70, Top, 100, 20, "Fullscreen") : Top+25
    OptionGadget(#GADGET_Windowed  , 70, Top, 100, 20, "Windowed")   : Top-25
   
    ComboBoxGadget (#GADGET_ScreenModes  , 190, Top, 150, 21) : Top+25
    ComboBoxGadget (#GADGET_WindowedModes, 190, Top, 150, 21) : Top+45
   
    ButtonGadget (#GADGET_Launch,   6, Top, 180, 25, "Launch", #PB_Button_Default)
    ButtonGadget (#GADGET_Cancel, 200, Top, 190, 25, "Cancel")
    
    If ExamineScreenModes()
      Debug "ok"
      
      While NextScreenMode()
      
        Width  = ScreenModeWidth()
        Height = ScreenModeHeight()
        Depth  = ScreenModeDepth()
        
        If Depth > 8
          AddGadgetItem(#GADGET_ScreenModes, -1, Str(Width)+"x"+Str(Height)+"x"+Str(Depth))
        EndIf
       
      Wend        
      
    EndIf
    
    DesktopWidth  = 1024 ; GetSystemMetrics_(#SM_CXSCREEN)
    DesktopHeight = 768  ; GetSystemMetrics_(#SM_CYSCREEN)
    NbScreenModes = 7
    
    Restore WindowedScreenDimensions

    Repeat      
      Read.l CurrentWidth
      Read.l CurrentHeight
      
      If CurrentWidth < DesktopWidth And CurrentHeight < DesktopHeight
        AddGadgetItem(#GADGET_WindowedModes, -1, Str(CurrentWidth)+ "x"+Str(CurrentHeight))
        NbScreenModes - 1
      Else
        NbScreenModes = 0
      EndIf
      
    Until NbScreenModes = 0
    
    SetGadgetState(#GADGET_FullScreen, FullScreen)
    SetGadgetState(#GADGET_Windowed  , 1-FullScreen)

    SetGadgetText (#GADGET_ScreenModes  , FullScreenMode$)
    SetGadgetText (#GADGET_WindowedModes, WindowedScreenMode$)
    
    DisableGadget (#GADGET_ScreenModes  , 1-FullScreen)
    DisableGadget (#GADGET_WindowedModes, FullScreen)
    
    HideWindow(#WINDOW_Screen3DRequester, 0)
    
    Repeat
      
      Event = WaitWindowEvent()
      
      Select Event
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
          
        Case #GADGET_Launch
          Quit = 2
          
        Case #GADGET_Cancel
          Quit = 1
          
        Case #GADGET_FullScreen
          DisableGadget(#GADGET_ScreenModes  , 0)
          DisableGadget(#GADGET_WindowedModes, 1)
        
        Case #GADGET_Windowed
          DisableGadget(#GADGET_ScreenModes  , 1)
          DisableGadget(#GADGET_WindowedModes, 0)
                 
        EndSelect
        
      Case #PB_Event_CloseWindow
        Quit = 1
        
      EndSelect
      
    Until Quit > 0
    
    FullScreen          = GetGadgetState(#GADGET_FullScreen)
    FullScreenMode$     = GetGadgetText (#GADGET_ScreenModes)
    WindowedScreenMode$ = GetGadgetText (#GADGET_WindowedModes)
    
    CloseWindow(#WINDOW_Screen3DRequester)
      
  EndIf
  
  If Quit = 2 ; Launch button has been pressed
  
    CreatePreferences("Demos3D.prefs")
      WritePreferenceLong  ("FullScreen"        , FullScreen)          
      WritePreferenceString("FullScreenMode"    , FullScreenMode$)     
      WritePreferenceString("WindowedScreenMode", WindowedScreenMode$) 

    If FullScreen
      ScreenMode$ = FullScreenMode$
    Else
      ScreenMode$ = WindowedScreenMode$
    EndIf
    
    ScreenWidth  = Val(StringField(ScreenMode$, 1, "x"))
    ScreenHeight = Val(StringField(ScreenMode$, 2, "x"))
    ScreenDepth  = Val(StringField(ScreenMode$, 3, "x"))
    
    Screen3DRequester_FullScreen = FullScreen ; Global variable, for the Screen3DEvents
    
    If FullScreen
      Result = OpenScreen(ScreenWidth, ScreenHeight, ScreenDepth, "3D Demos")
    Else
      If OpenWindow(0, 0, 0, ScreenWidth, ScreenHeight+MenuHeight(), "PureBasic - 3D Demos", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
      
        CreateMenu(0, WindowID(#WINDOW_Screen3DRequester))
          MenuTitle("Project")
          MenuItem(0, "Quit")
    
          MenuTitle("About")
          MenuItem(1, "About...")
              
        Result = OpenWindowedScreen(WindowID(#WINDOW_Screen3DRequester), 0, 0, ScreenWidth, ScreenHeight, 0, 0, 0)
      EndIf
    EndIf
  EndIf
     
  ProcedureReturn Result
EndProcedure


Procedure Screen3DEvents()

  If Screen3DRequester_FullScreen = 0 ; Handle all the events relatives to the window..
  
    Repeat
      Event = WindowEvent()
      
      Select Event
      
        Case #PB_Event_Menu
          Select EventMenu()
          
            Case 0
              Quit = 1
          
            Case 2
              MessageRequester("Info", "Windowed 3D in PureBasic !", 0)
              
          EndSelect
             
        Case #PB_Event_CloseWindow
          Quit = 1
        
      EndSelect
      
      If Quit = 1 : End : EndIf  ; Quit the app immediately
    Until Event = 0
    
  EndIf
  
  If ExamineKeyboard()
    If KeyboardReleased(#PB_Key_F1)
      Screen3DRequester_ShowStats = 1-Screen3DRequester_ShowStats ; Switch the ShowStats on/off
    EndIf
  EndIf
          
EndProcedure


Procedure Screen3DStats()
  If Screen3DRequester_ShowStats
    If StartDrawing(ScreenOutput())
      FrontColor(RGB(255, 255, 255))
      DrawingMode(1)
      DrawText(0, 0, StrF(Engine3DFrameRate(0),1)+" FPS")
      DrawText(0, 20, Str(CountRenderedTriangles())+" Triangles")
      StopDrawing()
    EndIf
  EndIf
EndProcedure

        


DataSection
  WindowedScreenDimensions:
    Data.l  320, 240
    Data.l  512, 384      
    Data.l  640, 480
    Data.l  800, 600      
    Data.l 1024, 768
    Data.l 1280, 1024
    Data.l 1600, 1200
EndDataSection
    
; IDE Options = PureBasic 4.30 Beta 1 (Linux - x86)
; CursorPosition = 36
; Folding = -