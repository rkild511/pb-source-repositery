; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14451&highlight=
; Author: Kale (updated for PB 4.00 by Andre)
; Date: 19. March 2005
; OS: Windows
; Demo: No


; Select an application, launch it and make a screenshot after a selected time


;===========================================================================
;-CONSTANTS
;===========================================================================

#APP_NAME = "Delayed Screenshot taker v1.0"

Enumeration
  #WINDOW_ROOT
  #STRING_EXE
  #BUTTON_SELECTEXE
  #SPIN_TIME
  #TEXT_SECONDS
  #BUTTON_LAUNCH
  #TIMER_MAIN
EndEnumeration

;===========================================================================
;-GLOBAL FLAGS / VARIABLES / STRUCTURES / ARRAYS
;===========================================================================

Global ExeName.s

;===========================================================================
;-PROCEDURES
;===========================================================================

;Handle an error
Procedure HandleError(Result, Text.s)
  If Result = 0 : MessageRequester("Error", Text, #PB_MessageRequester_Ok) : End : EndIf
EndProcedure

;capture the screen
Procedure.l CaptureScreen()
  ScreenWidth = GetSystemMetrics_(#SM_CXSCREEN)
  ScreenHeight = GetSystemMetrics_(#SM_CYSCREEN)
  dm.DEVMODE
  BMPHandle.l
  srcDC = CreateDC_("DISPLAY", "", "", dm)
  trgDC = CreateCompatibleDC_(srcDC)
  BMPHandle = CreateCompatibleBitmap_(srcDC, ScreenWidth, ScreenHeight)
  SelectObject_( trgDC, BMPHandle)
  BitBlt_(trgDC, 0, 0, ScreenWidth, ScreenHeight, srcDC, 0, 0, #SRCCOPY)
  DeleteDC_(trgDC)
  ReleaseDC_(BMPHandle, srcDC)
  CreateImage(0, ScreenWidth, ScreenHeight)
  StartDrawing(ImageOutput(0))
  DrawImage(BMPHandle, 0, 0)
  StopDrawing()
  UseJPEGImageEncoder()
  SaveImage(0, "Screenshot.jpg", #PB_ImagePlugin_JPEG)
  End
EndProcedure

;===========================================================================
;-GEOMETRY
;===========================================================================

HandleError(OpenWindow(#WINDOW_ROOT, 0, 0, 400, 55, #APP_NAME, #PB_Window_SystemMenu | #PB_Window_ScreenCentered), "Main window could not be created.")
HandleError(CreateGadgetList(WindowID(#WINDOW_ROOT)), "Gadget list for the main window could not be created.")
StringGadget(#STRING_EXE, 5, 5, 285, 21, "")
ButtonGadget(#BUTTON_SELECTEXE, 295, 5, 100, 21, "Select Program...")
SpinGadget(#SPIN_TIME, 5, 30, 50, 21, 1, 1000)
SetGadgetState(#SPIN_TIME, 60) : SetGadgetText(#SPIN_TIME,"60")
TextGadget(#TEXT_SECONDS, 60, 33, 140, 21, "Seconds until screenshot.")
ButtonGadget(#BUTTON_LAUNCH, 295, 30, 100, 21, "Launch")

;===========================================================================
;-MAIN LOOP
;===========================================================================

Repeat
  EventID.l = WaitWindowEvent()
  Select EventID
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #BUTTON_LAUNCH
          If ExeName
            RunProgram(ExeName)
            Delay(GetGadgetState(#SPIN_TIME) * 1000)
            CaptureScreen()
          Else
            MessageRequester("Error", "Select a program first!")
          EndIf
        Case #BUTTON_SELECTEXE
          ExeName = OpenFileRequester(#APP_NAME, "", "Executable (*.exe) | *.exe", 0)
          SetGadgetText(#STRING_EXE, ExeName)
        Case #SPIN_TIME
          SetGadgetText(#SPIN_TIME, Str(GetGadgetState(#SPIN_TIME)))
      EndSelect
  EndSelect
Until EventID = #PB_Event_CloseWindow
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP