; English forum: 
; Author: Kale
; Date: 31. December 2002
; OS: Windows
; Demo: No

;===========================================================================
; CONSTANTS
;===========================================================================

;window
#APP_NAME = "Xmas Card"
#ROOT_WINDOW = 1
#ROOT_WINDOW_WIDTH = 320
#ROOT_WINDOW_HEIGHT = 400
#ROOT_WINDOW_FLAGS = #PB_Window_SystemMenu | #PB_Window_WindowCentered

;flakes
#NUMBER_OF_FLAKES = 20

;image
#MAIN_IMAGE = #NUMBER_OF_FLAKES+1

;===========================================================================
; GLOBAL VARIABLES / STRUCTURES / ARRAYS
;===========================================================================

Structure flake
    xPos.f
    yPos.f
    amplitude.f
    xStep.f
    yStep.f
    xCoord.f
EndStructure
Global Dim flakes.flake(#NUMBER_OF_FLAKES)

;===========================================================================
; FUNCTIONS
;===========================================================================

;initalise values for all flakes
Procedure initFlakes()
    For x = 0 To #NUMBER_OF_FLAKES-1
        flakes(x)\xPos = Random(#ROOT_WINDOW_WIDTH)
        flakes(x)\yPos = Random(#ROOT_WINDOW_HEIGHT)
        flakes(x)\amplitude = Random(3)
        flakes(x)\xStep = 0.02 + Random(1)/10
        flakes(x)\yStep = 1+Random(2)
        flakes(x)\xCoord = 0
    Next x
EndProcedure

;move flakes on the y axis
Procedure yMoveFlakes()
    For x = 0 To #NUMBER_OF_FLAKES-1
        flakes(x)\yPos+flakes(x)\yStep
        If flakes(x)\yPos > #ROOT_WINDOW_HEIGHT+12
            flakes(x)\yPos = -12
            flakes(x)\xPos = Random(#ROOT_WINDOW_WIDTH)
        EndIf
    Next x
EndProcedure

;move flakes on the x axis
Procedure xMoveFlakes()
    For x = 0 To #NUMBER_OF_FLAKES-1
        flakes(x)\xCoord+flakes(x)\xStep
        flakes(x)\xPos+flakes(x)\amplitude*Sin(flakes(x)\xCoord)
        If flakes(x)\xPos > #ROOT_WINDOW_WIDTH+12
            flakes(x)\xPos = -12
        EndIf
        If flakes(x)\xPos < -12
            flakes(x)\xPos = #ROOT_WINDOW_WIDTH+12
        EndIf
    Next x
EndProcedure

;extract and play song
Procedure playSong()
    If CreateFile(1, "song.mid")
        length = ?SongEnd-?Song
        WriteData(1,?Song, length)
        CloseFile(1)
        InitMovie()
        If LoadMovie(0, "song.mid")
            PlayMovie(0, ScreenID())
            Else
            Beep_(200, 300)
        EndIf
    EndIf
EndProcedure

Procedure stopSong()
    If FileSize("song.mid") > 0
        DeleteFile("song.mid")
    EndIf
EndProcedure

;===========================================================================
; GEOMETRY
;===========================================================================

If InitSprite()
    If OpenWindow(#ROOT_WINDOW, 200, 200, #ROOT_WINDOW_WIDTH, #ROOT_WINDOW_HEIGHT, #APP_NAME, #ROOT_WINDOW_FLAGS)
        If OpenWindowedScreen(WindowID(#ROOT_WINDOW), 0, 0, #ROOT_WINDOW_WIDTH, #ROOT_WINDOW_HEIGHT, 0, 0, 0) : SetFrameRate(60)
            
            GetAsyncKeyState_(#VK_ESCAPE)

            CatchSprite(#MAIN_IMAGE, ?MainImage, 0)
            
            For x = 0 To #NUMBER_OF_FLAKES-1
                CatchSprite(x, ?FlakeImage, 0)
                TransparentSpriteColor(x,RGB( 255, 0, 255))
            Next x

            initFlakes()
            playSong()
            SetFrameRate(60)

;===========================================================================
; MAIN LOOP
;===========================================================================
            
            Repeat

                FlipBuffers()
                ClearScreen(RGB(255, 255, 255))
                
                ;main image
                DisplaySprite(#MAIN_IMAGE, 0, 0)

                For x = 0 To #NUMBER_OF_FLAKES-1
                    DisplayTransparentSprite(x, flakes(x)\xPos, flakes(x)\yPos)
                Next x

                xMoveFlakes()
                yMoveFlakes()
              
                Select WindowEvent()
                    ;sleep_(1)
                    Case #PB_Event_CloseWindow
                        quit = 1
                    Case #WM_CLOSE
                        quit = 1
                EndSelect
                EscapeKey = GetAsyncKeyState_(#VK_ESCAPE)
            Until EscapeKey = -32767 Or quit = 1

            stopSong()

        EndIf
    EndIf
EndIf
End

;===========================================================================
; BINARY INCLUDES
;===========================================================================

MainImage:
IncludeBinary "front.bmp"

FlakeImage:
IncludeBinary "flake.bmp"

Song:
IncludeBinary "12days.mid"
SongEnd: 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; UseIcon = D:\__PureBasic__\Xmas Card\Santa.ico
; Executable = D:\__PureBasic__\Xmas Card\Xmas Card.exe