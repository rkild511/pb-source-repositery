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
#MAIN_IMAGE = #NUMBER_OF_FLAKES+1
#SPRITE = #NUMBER_OF_FLAKES+2

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
    alpha.f
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
        flakes(x)\alpha= 255
    Next x
EndProcedure

;move flakes on the y axis
Procedure yMoveFlakes()
    For x = 0 To #NUMBER_OF_FLAKES-1
        flakes(x)\yPos+flakes(x)\yStep
        If flakes(x)\yPos > #ROOT_WINDOW_HEIGHT+12
            flakes(x)\yPos = -12
            flakes(x)\xPos = Random(#ROOT_WINDOW_WIDTH)
            flakes(x)\alpha = 255
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

Procedure calculateAlpha()
    For x = 0 To #NUMBER_OF_FLAKES-1
        flakes(x)\alpha = 255 - flakes(x)\yPos + 100
        If flakes(x)\alpha < 0
            flakes(x)\alpha = 0
        EndIf
        If flakes(x)\alpha > 255
            flakes(x)\alpha = 255
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
    If OpenWindow(#ROOT_WINDOW, 200, 200,  #ROOT_WINDOW_WIDTH, #ROOT_WINDOW_HEIGHT,#APP_NAME, #ROOT_WINDOW_FLAGS)
        If OpenWindowedScreen(WindowID(#ROOT_WINDOW), 0, 0, #ROOT_WINDOW_WIDTH, #ROOT_WINDOW_HEIGHT, 0, 0, 0) : SetFrameRate(60)
            
            GetAsyncKeyState_(#VK_ESCAPE)

            CatchSprite(#MAIN_IMAGE, ?MainImage, 0)
            
            CatchSprite(#SPRITE, ?FlakeImage, #PB_Sprite_Texture)
            TransparentSpriteColor(#SPRITE,RGB( 255, 0, 255))
            
            If InitSprite3D()
            
                Sprite3DQuality(1)
                For x = 0 To #NUMBER_OF_FLAKES-1
                    CreateSprite3D(x, #SPRITE)
                    ;ZoomSprite3D(x, 64, 64)
                Next x

                initFlakes()
                playSong()
                SetFrameRate(60)
                If Start3D()

;===========================================================================
; MAIN LOOP
;===========================================================================
                    Repeat

                        FlipBuffers()
                        ClearScreen(RGB(255, 255, 255))
                        
                        ;main image
                        DisplaySprite(#MAIN_IMAGE, 0, 0)

                        ;If angle > 360
                            ;angle = 1
                        ;Else
                            ;angle+1
                        ;EndIf

                        calculateAlpha()

                        For x = 0 To #NUMBER_OF_FLAKES-1
                            DisplaySprite3D(x, flakes(x)\xPos, flakes(x)\yPos, flakes(x)\alpha)
                            ;RotateSprite3D(x, angle , 0)
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

                    Stop3D()
                    stopSong()
                Else
                    MessageRequester("Error...", "Start3D() Failed!", #PB_MessageRequester_Ok)
                EndIf
            Else
                MessageRequester("Error...", "InitSprite3D() Failed!", #PB_MessageRequester_Ok)
            EndIf
        Else
            MessageRequester("Error...", "OpenWindowedScreen() Failed!", #PB_MessageRequester_Ok)
        EndIf
    Else
        MessageRequester("Error...", "OpenWindow() Failed!", #PB_MessageRequester_Ok)
    EndIf
Else
    MessageRequester("Error...", "InitSprite() Failed!", #PB_MessageRequester_Ok)
EndIf
End

;===========================================================================
; BINARY INCLUDES
;===========================================================================

MainImage:
IncludeBinary "front.bmp"

FlakeImage:
IncludeBinary "flake3D.bmp"

Song:
IncludeBinary "12days.mid"
SongEnd: 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; UseIcon = D:\__PureBasic__\Xmas Card\Santa.ico
; Executable = D:\__PureBasic__\Xmas Card\Xmas Card.exe