; German forum: http://www.purebasic.fr/german/viewtopic.php?t=3822&highlight=
; Author: dllfreak2001 (updated for PB 4.00 by Andre)
; Date: 28. June 2005
; OS: Windows
; Demo: Yes


; *** Funny Ball ***
; Here is a funny ball, which can be moved by pressing the left mouse button.
; It hangs on something like an elastic.

; *** Blöder Ball ***
; Hier ist ein blöder Ball, den man per Druck auf die Linke Maustaste 
; an eine Art Gummiband hängt. Dann kann man den Ball werfen und er dreht sich auch. 
; Blöder Ball ist für alle die programmierten Schwachsinn mögen: 

InitSprite() 
InitMouse() 
InitKeyboard() 
ExamineDesktops() 
Global sw.l, sh.l 
sw = DesktopWidth(0) 
sh = DesktopHeight(0) 

OpenScreen(sw,sh,32,"BloederBall_v1.0") 

Global ballx.f, bally.f, ballxm.f, ballym.f, pw.l, tempx.f, tempy.f, rot.f,rotm.f , pi.f 
pi = 3.141592 
ballx = 640 
bally = 512 
ballxm = 11 
pw = 2000 

CreateSprite(0,sw,sh,0) 
StartDrawing(SpriteOutput(0)) 
    For x = 0 To 9000 
        Box(Random(sw),Random(sh),16,16,RGB(0,Random(50),0)) 
    Next 
    
StopDrawing() 

Repeat 
    DisplaySprite(0,0,0) 
    ExamineKeyboard() 
    ExamineMouse() 

    ;Kraftdivision einstellen 

    If MouseWheel() > 0 
        pw + 100 
        
        If pw = 0 
            pw = 1 
        EndIf 
        
    EndIf 
    
    If MouseWheel() < 0 
        pw - 100 
        If pw = 0 
            pw = -1 
        EndIf 
        
    EndIf 
    
    If bally < -16000 
        bally = -16000 
        ballym = 0 
    EndIf 
    
    
    If MouseButton(1) 
        tempx = (ballx-MouseX())/pw 
        tempy = (bally-MouseY())/pw 
        
        ballym -  tempy 
        ballxm -  tempx 
    
        ping = 1 
    Else 
        ping = 0 
    EndIf 

    If bally <  sh-16 
        ballym = ballym + 0.1 
    EndIf 
    
    bally + ballym 
    
    If bally > sh-16 
        bally = sh-16 
        ballym = -(ballym/2)    

        rotm =  ballxm 
        
    EndIf 
    
    If ballxm > 0 
        ballxm - 0.01 
    EndIf 
    If ballxm < 0 
        ballxm + 0.01 
    EndIf 

    ballx+ballxm 
    
    If ballx > sw-16 
        ballx = sw-16 
        ballxm = -(ballxm/2) 
        rotm = -ballym 
    EndIf 
    If ballx < 16 
        ballx = 16 
        ballxm = -(ballxm/2) 
        rotm = ballym 
    EndIf 

    If rotm > 0 
        rotm - 0.01 
    EndIf 
    
    If rotm < 0 
        rotm + 0.01 
    EndIf 
    
    StartDrawing(ScreenOutput()) 
        olposx = MouseX() 
        olposy = MouseY() 
        If ping = 1 
            For x = 0 To 50 

                If ballx > olposx 
                    newposx = Random(16)-4 
                Else 
                    newposx = Random(64)-32 
                    If ballx < olposx 
                        newposx = 4-Random(16)                    
                    EndIf 
                EndIf 
            
                If bally > olposy 
                    newposy = Random(16)-4 
                Else 
                    newposy = Random(64)-32 
                    If bally < olposy 
                        newposy = 4-Random(16)                    
                    EndIf 
                EndIf 

                If x = 100 
                    newposx = olposx-ballx 
                    newposy = olposy-bally 
                EndIf 
                Line(olposx,olposy,newposx,newposy,RGB(100-x,50-x/2,255-x*2)) 
                olposx = olposx + newposx 
                olposy = olposy + newposy 
            Next 
            
        EndIf 
        Circle(ballx,bally,16,RGB(100,0,0)) 

        rot - rotm 
        For x = 1 To 8 
            rox.f = Sin(2*pi*((rot+(x*45))/360))*15 
            roy.f = Cos(2*pi*((rot+(x*45))/360))*15 
            Line(ballx,bally,rox,roy,RGB(255,0,0)) 
        Next 
        
        Line(MouseX(),MouseY()-16,0,32,RGB(255,255,0)) 
        Line(MouseX()-16,MouseY(),32,0,RGB(255,255,0)) 
    
        DrawingMode(1) 
        FrontColor(RGB(255,255,255))
        DrawText(0, 0, "Power-Division: "+Str(pw)) 
        DrawText(0, 16, "Ball-X: "+Str(ballx)) 
        DrawText(0, 32, "Ball-Y: "+Str(bally)) 
        DrawText(0, 48, "Ball-Move-X: "+StrF(ballxm,3)) 
        DrawText(0, 64, "Ball-Move-Y: "+StrF(ballym,3))        
    StopDrawing() 
    
    FlipBuffers() 
    ClearScreen(RGB(10,10,0))
    
Until KeyboardPushed(#PB_Key_Escape) 
CloseScreen() 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger