; PB IRC Chat
; Author: DarkDragon (updated for PB 4.00 by Andre)
; Date: 22. May 2005
; OS: Windows
; Demo: No

#WM_CAP_START = #WM_USER

#WM_CAP_SET_CALLBACK_ERROR = #WM_CAP_START + 2
#WM_CAP_SET_CALLBACK_STATUS = #WM_CAP_START + 3
#WM_CAP_SET_CALLBACK_YIELD = #WM_CAP_START + 4
#WM_CAP_SET_CALLBACK_FRAME = #WM_CAP_START + 5
#WM_CAP_SET_CALLBACK_VIDEOSTREAM = #WM_CAP_START + 6
#WM_CAP_SET_CALLBACK_WAVESTREAM = #WM_CAP_START + 7

#WM_CAP_DRIVER_CONNECT        =  #WM_USER + 10
#WM_CAP_DRIVER_DISCONNECT     =  #WM_USER + 11
#WM_CAP_DRIVER_GET_CAPS = #WM_CAP_START + 14

#WM_CAP_DLG_VIDEOFORMAT = #WM_CAP_START + 41
#WM_CAP_DLG_VIDEOSOURCE = #WM_CAP_START + 42
#WM_CAP_DLG_VIDEODISPLAY = #WM_CAP_START + 43

#WM_CAP_SET_PREVIEW = #WM_CAP_START + 50
#WM_CAP_SET_PREVIEWRATE = #WM_CAP_START + 52
#WM_CAP_GET_STATUS = #WM_CAP_START + 54

#WM_CAP_FILE_SAVEDIB          =  #WM_USER + 25
#WM_CAP_SET_SCALE             =  #WM_USER + 53

#WM_CAP_SET_CALLBACK_CAPCONTROL = #WM_CAP_START + 85

Structure VIDEOHDR
  lpData.l
  dwBufferLength.l
  dwBytesUsed.l
  dwTimeCaptured.l
  dwUser.l
  dwFlags.l
  dwReserved.l[3]
EndStructure

Procedure FrameCallback(lwnd.l, *lpVHdr.VIDEOHDR)
  For k=0 To *lpVHdr\dwBufferLength-1
    Color = PeekB(*lpVHdr\lpData+k)
    PokeB(*lpVHdr\lpData+k, RGB(Blue(Color), Green(Color), Red(Color)))
  Next
EndProcedure

hWnd = OpenWindow(0, 0, 0, 400, 500, "WebCamTest", #PB_Window_SystemMenu)

CreateGadgetList(WindowID(0))

If OpenLibrary(0, "AVICAP32.DLL")

  hWebcam = CallFunction(0, "capCreateCaptureWindowA", "BLUBBER", #WS_VISIBLE + #WS_CHILD, 10, 10, 380, 380, hWnd, 0)

  CallFunction(0, "capSetCallbackOnFrame", hWebcam, @FrameCallback())

  SendMessage_(hWebcam, #WM_CAP_DRIVER_CONNECT          , 0 , 0)
  SendMessage_(hWebcam, #WM_CAP_SET_SCALE               , 1 , 0)
  SendMessage_(hWebcam, #WM_CAP_SET_PREVIEWRATE         , 50, 0)
  SendMessage_(hWebcam, #WM_CAP_SET_PREVIEW             , 1 , 0)

  SendMessage_(hWebcam, #WM_CAP_SET_CALLBACK_FRAME      , 0 , @FrameCallback())

  Repeat
    Event = WindowEvent()
    Select Event
      Case #PB_Event_CloseWindow
        Quit = 1
    EndSelect
  Until Quit = 1
  SendMessage_(hWebcam, #WM_CAP_SET_PREVIEW       , 0, 0)
  SendMessage_(hWebcam, #WM_CAP_DRIVER_DISCONNECT, "BLUBBER", 0)
  CloseWindow(0)
  CloseLibrary(0)
EndIf
;End
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -