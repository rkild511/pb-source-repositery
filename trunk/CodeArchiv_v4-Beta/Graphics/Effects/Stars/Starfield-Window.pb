; www.purearea.net (Sourcecode collection by cnesm)
; Author: Shaun Raven (updated for PB4.00 by blbltheworm)
; Date: 09. December 2003
; OS: Windows
; Demo: Yes

; starfield
; (C) Shaun Raven, use freely 

;//////////////////////////////////////////////////////////////
;- Initialisation
;//////////////////////////////////////////////////////////////
;- Window Constants
;
#Window_0 = 0

;- Screen constants
#SCREEN_WIDTH = 640
#SCREEN_HEIGHT = 480

;- Window Title
Title$ = "Starfield Demo"

;////////////////////////////////////////////////////////////
;- Subroutines
;////////////////////////////////////////////////////////////
;-Constants: 

#NUM_STARS = 100
#PLANE_1 = 1
#PLANE_2 = 2
#PLANE_3 = 3

Global BLACK.l
Global WHITE.l
Global LT_GREY.l 
Global DK_GREY.l 

;-Structures
Structure star_type
  x.w       ;position of star - x
  y.w       ;position of star - y
  plane.b   ;plane of star
  colour.l  ;colour of star
EndStructure

;-Globals
Global Dim stars.star_type(#NUM_STARS)
Global velocity_1.b
Global velocity_2.b 
Global velocity_3.b 
Global done.b 

velocity_1 = 1
velocity_2 = 2
velocity_3 = 3
done = 0

BLACK = RGB(0,0,0)
WHITE = RGB(255,255,255)
LT_GREY = RGB(175,175,175)
DK_GREY = RGB(100,100,100)
Procedure Init_Stars()
  ;
  ; initialise stars
  ;
  For x = 0 To #NUM_STARS -1
    ; initialise star position
    stars(x)\x = Random(639)
    stars(x)\y = Random(479)
    ;initialise star plane & colour
    Select Random(2)
      Case 0
        stars(x)\plane = 1
        stars(x)\colour = DK_GREY
        
      Case 1
        stars(x)\plane = 2
        stars(x)\colour = LT_GREY
      
      Case 2
        stars(x)\plane = 3
        stars(x)\colour = WHITE
    EndSelect
         
  Next
 

EndProcedure



If InitSprite() = 0 Or InitKeyboard() = 0
  MessageRequester("Error","Can't open DirectX",0)
  End
EndIf

If OpenWindow(#Window_0, 216, 0, #SCREEN_WIDTH, #SCREEN_HEIGHT, Title$,  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered )
  
  ;If CreateGadgetList(WindowID())
  ;
  ;EndIf
EndIf

If OpenWindowedScreen(WindowID(#Window_0),0,0,#SCREEN_WIDTH, #SCREEN_HEIGHT,0,0,0)
    Init_Stars()

  ;//////////////////////////////////////////////////////////////
  ;- GAME LOOP
  ;//////////////////////////////////////////////////////////////
Repeat
    ClearScreen(RGB(0,0,0))
     
    ;///////////////////////////////////////////////////
    ;- Input
    ;///////////////////////////////////////////////////
    ;check keyboard For input
    ;if escape pressed, leave program,
    ;if + or - pressed, change speed of starfield
    ExamineKeyboard()
    If KeyboardPushed(#PB_Key_Escape) 
       done = 1
    EndIf
    If KeyboardPushed(#PB_Key_Equals)
      velocity_1 = velocity_1 + 1
      velocity_2 = velocity_2 + 2
      velocity_3 = velocity_3 + 3
        
    EndIf
    If KeyboardPushed(#PB_Key_Minus)
      velocity_1 = velocity_1 - 1
      velocity_2 = velocity_2 - 2
      velocity_3 = velocity_3 - 3
    EndIf
    
    Event = WindowEvent()
    If Event = #PB_Event_CloseWindow
      done = 1
    EndIf
    ;//////////////////////////////////////////////////////////////
    ;- Game logic,Transformations & Rendering      
    ;//////////////////////////////////////////////////////////////
    If StartDrawing(ScreenOutput())

        For i = 0 To #NUM_STARS - 1
          ; erase the star

          Plot(stars(i)\x  ,stars(i)\y  ,BLACK)
          
          ;move the star, and test for off-screen condition
          
          ;each star is on a different plane, so test which plane the star
          ;is in so that proper velocity can be used
          Select stars(i)\plane
            Case #PLANE_1 ;slowest plane
              stars(i)\x = stars(i)\x + velocity_1
              
            Case #PLANE_2 ;mid speed plane
              stars(i)\x = stars(i)\x + velocity_2
          
            Case #PLANE_3 ;high speed plane
              stars(i)\x = stars(i)\x + velocity_3

          
          EndSelect
          
          ; test If star has gone off screen
          If stars(i)\x > 639
            stars(i)\x = (stars(i)\x - 640)
          ElseIf stars(i)\x < 0 ; off left edge?
            stars(i)\x = (640 + stars(i)\x)
          EndIf
          
          Plot(stars(i)\x,stars(i)\y,stars(i)\colour)
          
        Next
        
        ; Draw instructions
        DrawText(0,460,"Press = or - to change speed")
        StopDrawing() 
        FlipBuffers()
      
        
      EndIf


  Until done = 1
EndIf
;///////////////////////////////////////////////////////
;- Tidy up here if required
;///////////////////////////////////////////////////////
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -