; English forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 21. January 2003
; OS: Windows
; Demo: No

InitSprite() 
InitKeyboard() 
InitMouse() 

If OpenScreen(800,600,32,"TEST") = 0    ; test 32bit 
If OpenScreen(800,600,24,"TEST") = 0   ; if 32bit failed, test 24bit 
  If OpenScreen(800,600,16,"TEST") = 0  ; if 32/24 failed, try 16bit screen 
     MessageRequester("ERROR","Cant open 16/24/32bit Screen",0):End 
  EndIf 
EndIf 
EndIf 

   ; limit Speed 
   SetFrameRate(50) 

   BackTileX = -200 
   BackTileY = -200 

Procedure checkerboard() 
   CreateSprite(1,1000,800,0) 
   StartDrawing(SpriteOutput(1)) 
     For b = 0 To 3 
      For a = 0 To 4 
          Box(a*200    ,b*200     , 100, 100,RGB( 00, 00,255)) 
          Box(a*200+100,b*200     , 100, 100,RGB( 00, 00, 00)) 
          Box(a*200+100,b*200+100 , 100, 100,RGB( 45, 45,255)) 
          Box(a*200    ,b*200+100 , 100, 100,RGB(255,255, 00)) 
      Next a 
     Next b 
   StopDrawing() 
EndProcedure 


checkerboard() 
max_speed.f = 10.0 

speed.f 
Direction = 1 
Repeat 
    FlipBuffers() 
    If IsScreenActive() 
       ClearScreen(RGB($66,$66,$66)) 
       R = 0 : G = 0 : B = 0 

       ; KEYBOARD CHECK 
       ; 
       ExamineKeyboard() 
       If KeyboardPushed(#PB_Key_Up) 
          If speed = 0.0: speed = 0.75:EndIf 
          speed * 1.02;speed 
          ;speed + 0.05 
          If speed > max_speed: speed = max_speed:EndIf 
       Else 
          speed - 0.15 
          If speed < 0: Speed = 0: EndIf 
       EndIf 
       If KeyboardPushed(#PB_Key_Down) 
          speed - 0.8 ; 0.4 
          If speed < 0: speed = 0: EndIf 
       EndIf 

       If KeyboardPushed(#PB_Key_Right) 
          If direction_just_changed = 0 
             Direction_Changed = 1 
          EndIf 
       EndIf 

       If KeyboardPushed(#PB_Key_Left) 
          If direction_just_changed = 0 
             Direction_Changed = -1 
          EndIf 
       EndIf 
      

      If frame = 1 Or frame = 10 
         If Direction_Changed = 1 
            Direction + 1 
            direction_just_changed = 4 
            If Direction = 17: Direction = 1: EndIf 
         ElseIf Direction_Changed = -1 
            Direction - 1 
            direction_just_changed = 4 
            If Direction = 0: Direction = 16: EndIf 
         EndIf 
         Direction_Changed = 0 
      EndIf 
      If direction_just_changed > 0 
         direction_just_changed - 1 
      EndIf 

      frame + 1 
      If frame = 21: frame = 1:EndIf 

      Select Direction 
          Case 1 : backY + speed 
          Case 2 : backY + speed        : backX - speed/2 
          Case 3 : backY + (speed*0.8)  : backX - (speed*0.8) 
          Case 4 : backY + speed/2      : backX - speed 
          Case 5 :                      : backX - speed 
          Case 6 : backY - speed/2      : backX - speed 
          Case 7 : backY - (speed*0.8)  : backX - (speed*0.8) 
          Case 8 : backY - speed        : backX - speed/2 
          Case 9 : backY - speed 
          Case 10: backY - speed        : backX + speed/2 
          Case 11: backY - (speed*0.8)  : backX + (speed*0.8) 
          Case 12: backY - speed/2      : backX + speed 
          Case 13:                        backX + speed 
          Case 14: backY + speed/2      : backX + speed 
          Case 15: backY + (speed*0.8)  : backX + (speed*0.8) 
          Case 16: backY + speed        : backX + speed/2          
      EndSelect 

      If backY <= ((BackTileY)-1) : backY = 0 : EndIf 
      If backY => 1   : backY = BackTileY : EndIf 
        
      If backX <= ((BackTileX)-1) : backX = 0 : EndIf 
      If backX => 1   : backX = BackTileX : EndIf 

       DisplaySprite(1,backX,backY) 

       StartDrawing(ScreenOutput()) 
          A$=StrF(speed,2) 
          Select FindString(A$,".",0) 
             Case 0: 
                  If Len(A$) = 1: A$ = "0"+A$+".00" 
                  ElseIf Len(A$) = 2: A$ + ".00": EndIf 
             Case 2: A$ = "0"+A$                  
          EndSelect 

          FrontColor(RGB(0,0,0)) 
          DrawingMode(1) 

          DrawText(10,10,"Speed: "+A$) 
          DrawText(10,30,"Direction: "+Str(Direction)) 
          DrawText(10,50,"F1 = change texture (current = "+Str(backgroundtexture)+"/4)") 
          DrawText(10,70,"Cursor keys to move...") 
                    
          FrontColor(RGB(255,255,255)) 
          DrawText(11,11,"Speed: "+A$) 
          DrawText(11,31,"Direction: "+Str(Direction)) 
          DrawText(11,51,"F1 = change texture (current = "+Str(backgroundtexture)+"/4)") 
          DrawText(11,71,"Cursor keys to move...") 
          
       StopDrawing() 

       Sleep_(1) 
    Else 
       Sleep_(200) 
    EndIf 
Until KeyboardPushed(#PB_Key_Escape) Or Quit = 1 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger