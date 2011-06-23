; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2062&highlight=
; Author: Kaeru Gaman (updated for PB 4.00 by Andre)
; Date: 13. February 2005
; OS: Windows
; Demo: Yes

 
; *** 
; *** Bubu Butterfly's Spring Vacation
; *** 
; *** by Kaeru Gaman (c) 2005-02-13
; *** 
; *** for the 20-liner contest
; *** formatted & commended version
; *** 

#pf=3.14159265/180    ; factor Deg -> Rad

Procedure Flower(x.l,y.l)       ; draw flower
    For i=0 To 5                                                        ; 6 blossom-leaves
        Circle(x+12*Sin(i*60*#pf),y+12*Cos(i*60*#pf),8,RGB(128,0,48))   ; darker border
        Circle(x+12*Sin(i*60*#pf),y+12*Cos(i*60*#pf),7,RGB(255,0,96))   ; fill color
    Next
    Circle(x,y,6,RGB(255,0,96))     ; center backgrnd
    Circle(x,y,5,RGB(255,240,32))   ; yello center
EndProcedure

Procedure Bee(x.l,y.l,f.l)                  ; the Bee-Enemy
    For i=-2 To 1                           ; striped
        Circle(x,y-2+4*i,6,RGB(255,240,0))  ; in yello
        Circle(x,y+4*i,6,RGB(32,32,0))      ; and 'black'
    Next
    Circle(x,y+6,5,RGB(255,192,0))          ; head
    Circle(x+3,y+5,2,RGB(64,128,255))       ; eyes
    Circle(x-3,y+5,2,RGB(64,128,255))
    Circle(x-12,y-4-f,8,RGB(240,240,255))   ; wings, animated by the 'f'
    Circle(x+12,y-4-f,8,RGB(240,240,255))
EndProcedure

Procedure Fly(x.l,y.l,f.l)                  ; the player-butterfly
    For i=0 To 3                            ; 4 wings animated by the 'f'
        Circle(x+f*Sin((45+i*90)*#pf),y+f*Cos((45+i*90)*#pf),7,RGB(16,160,255))
        Circle(x+2*f*Sin((45+i*90)*#pf),y+2*f*Cos((45+i*90)*#pf),7,RGB(16,160,255))
        Circle(x+f*Sin((45+i*90)*#pf),y+f*Cos((45+i*90)*#pf),4,RGB(255,240,32))
        Circle(x+2*f*Sin((45+i*90)*#pf),y+2*f*Cos((45+i*90)*#pf),4,RGB(255,240,32))
    Next
    Circle(x,y-6,3,RGB(128,96,0))           ; body: upper end
    Box(x-3,y-6,6,12,RGB(128,96,0))         ; and middle
    Circle(x,y+6,3,RGB(128,96,0))           ; and lower end
    Line(x-1,y-9,-6,-11,RGB(16,200,255))    ; two feelers
    Line(x,y-9,5,-11,RGB(16,200,255))
    Circle(x,y-9,3,RGB(255,96,0))           ; and a head
EndProcedure

; alternate init for window-mode
;If InitSprite() And InitKeyboard() And OpenWindow(1,0,0,800,600,13107201,"SV") And OpenWindowedScreen(WindowID(),0,0,800,600,0,0,0)

; init
If InitSprite() And InitKeyboard() And OpenScreen(800,600,16,"SV")

SetFrameRate(60)

Dim PX(600)     ; background-dots-coordinate
Dim FP(4)       ; five flowers

For n=1 To 600          ; set start-coor for the background-dots
    PX(n)=Random(799)
Next

LV=4    ; initial no. of lifes

Repeat      ; this will be executed when new life

    FX=400  ; Butterfly starting position
    FY=500
    LV-1    ; decrement lifes
    NW=0    ; reset next-life-flag

    Repeat  ; this will be executed until new life

        ExamineKeyboard()
        ClearScreen(RGB(0,128,0))

        ; cursor-keys check
        If KeyboardPushed(200)  ; UP
            FY-2
        EndIf
        If KeyboardPushed(203)  ; LEFT
            FX-2
        EndIf
        If KeyboardPushed(205)  ; RIGHT
            FX+2
        EndIf
        If KeyboardPushed(208)  ; DOWN
            FY+2
        EndIf

        StartDrawing(ScreenOutput())

            DrawingMode(1)      ; transparent background for text

            PX(0)=Random(799)                   ; new dot
            For n=600 To 1 Step -1              ; all dots
                PX(n)=PX(n-1)                   ; scroll them
                Box(PX(n),n-1,2,1,RGB(0,192,0)) ; draw them
            Next

            For n=0 To 4                                            ; all flowers
                If Abs(FP(n)-100-FX)<16 And Abs(c+150*n-50-FY)<16   ; collision check
                    FP(n)=0                                         ; hide flower
                    SC+10                                           ; add score
                EndIf
                Flower(FP(n)-100,c+150*n-50)            ; draw flower scrolled by counter
            Next

            DrawText(270, 10, "Bubu Butterfly's Spring Vacation")  ; show the title

            DrawText(270, 580, "Score: "+Right("000000"+Str(SC),6)+"           Lifes: "+Str(LV))  ; show score and lifes


            Fly(FX-DI,FY,6+3*Sin(c/8))              ; draw butterfly with anim wings

            Bee(BX+400+100*Sin(c/20),c*4,4*Sin(c))  ; draw bee with anim wings


            If Abs(BX+400+100*Sin(c/20)-(FX-DI))<24 And Abs(c*4-FY)<24  ; Bee-collision
                DI=10000 ; hide the Butterfly
            EndIf

            c+1                          ; counter
            If c>149                    ; next phase
                For n=4 To 1 Step -1    ; set flowers 1 further
                    FP(n)=FP(n-1)
                Next
                FP(0)=150+Random(700)   ; new flower
                BX=Random(600)-300      ; new bee
                If DI=10000             ; butterfly hidden?
                    NW=1                ; next life
                    DI=0                ; unhide butterfly
                EndIf
                c=0                     ; reset counter
            EndIf
        StopDrawing()

        Delay(8)    ; don't occupy CPU to 100%
        
        ; alternate check for window-mode
        ;If KeyboardPushed(1) Or LV<0 Or WindowEvent() = #PB_Event_CloseWindow
        
        ; check ESC and lives
        If KeyboardPushed(1) Or LV<0
            EX=1    ; set exit-flag, if ESC or Win-Close or zero lifes
        EndIf
        
        FlipBuffers()

    Until EX=1 Or NW=1  ;leave inner loop when EXIT or next life

Until EX=1          ; leave program only when EXIT

EndIf           ; the ENDIF of the INIT: whole prog will only be executed when INIT succeeds

End         ; huahuahua that's all folks

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger