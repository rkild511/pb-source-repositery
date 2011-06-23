; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3591&start=10
; Author: Batze (updated for PB 4.00 by Andre)
; Date: 07. June 2005
; OS: Windows
; Demo: Yes


;Desktop Tennis 

;######################################### 
;#  Steuerung: Maus (bitte anschneiden!) # 
;#  Beenden:   obere linke Ecke          # 
;#                                       # 
;#  Punkte:  Rückwand       =  -1 P.     # 
;#           Seitenwände    =  10 P.     # 
;#           Mein Highscore = 549 P.     # 
;######################################### 

ExamineDesktops() 

W = DesktopWidth(0) 
H = DesktopHeight(0) 

Bx.f = 40 
By.f = H/2 - 10 

Mx.f = 10
My.f = 0 

;- Fenster oeffnen 
OpenWindow(0,   Bx,   By,  20,   20, "Desktop Tennis", #PB_Window_BorderLess) 

OpenWindow(2,   20, H-20, W-20,   20, "", #PB_Window_BorderLess, WindowID(0)) 
OpenWindow(3,    0,   20,   20, H-20, "", #PB_Window_BorderLess, WindowID(0)) 
OpenWindow(4, W-40,   50,   20,  H/5, "", #PB_Window_BorderLess, WindowID(0)) 
OpenWindow(1,    0,    0,    W,   20, "", #PB_Window_BorderLess, WindowID(0)) 

 Y = DesktopMouseY() - H/10 
 Sm = Y 

;- Hauptschleife 

Repeat 

 ;- Eventhandling 
 Event = WindowEvent() 
  
 If Event = #PB_Event_MoveWindow And EventWindow() = 2 And WindowY(2) <> H-20 
  ResizeWindow(2, 20, H-20, #PB_Ignore, #PB_Ignore) 
  ;Debug "Move" 
 EndIf 
  
 Bx + Mx 
 By + My 
  
 If Mx > 0 And Bx > W-60 And By > Y And By < Y+H/5 : Mx = (Mx+1)* -1 : My - Sm/15 
 ElseIf My > 0 And By > H-40 : My * -1 : Punkte + 10 
 ElseIf Mx < 0 And Bx <   20 : Mx * -1 : Punkte - 1 
 ElseIf My < 0 And By <   20 : My * -1 : Punkte + 10 
 Else 
  Y = DesktopMouseY() - H/10 
  Sm = Y - Oy : Oy = Y 
    
  ResizeWindow(4, W-40,  Y, #PB_Ignore, #PB_Ignore) 
  ResizeWindow(0,  Bx, By, #PB_Ignore, #PB_Ignore) 
  If Mx > 0 And Bx > W 
   Event = 333 
   Break 
  EndIf 
  
 EndIf 
  
 ;- Fenster Färben 
 For i=0 To 4 
  StartDrawing(WindowOutput(i)) 
   Box(0, 0, WindowWidth(i), WindowHeight(i), PeekL(?Col + i*4)) 
   If i=1 
    FrontColor(RGB($EA, $EB, $15)) : BackColor(RGB($23, $73, $DC))
    Circle(10, 10, 9) 
    DrawText(W-150, 2, "Punkte: "+Str(Punkte)) 
   EndIf 
  StopDrawing() 
 Next 
  
 Delay(20) 
  
 If DesktopMouseX() < 20 And DesktopMouseY() < 20 
  If MessageRequester("Beenden?", "Sie wollen also das Spiel vorzeitig beenden?", 1) = 1 : End : EndIf 
 EndIf 
  
ForEver 

For i=0 To 4 
 CloseWindow(i) 
Next 

;- Highscore 
OpenWindow(0, 1, 1, 330, 320,  "Highscore", #PB_Window_ScreenCentered) 
 CreateGadgetList(WindowID(0)) 
  OpenFile(0, "Highscore.dat") 
  If Lof(0) < 15 
   For i=1 To 10 : WriteLong(0, -10-i) : WriteStringN(0, "Niemand") : Next 
   FileSeek(0, 0) 
  EndIf    
  
  For i=1 To 10 
   Points = ReadLong(0) 
   Name.s = ReadString(0) 
   If Punkte > Points 
    TextGadget  (10+i,  20, 25*i,  80, 20, Str(Punkte), #PB_Text_Center) : Punkte = -11111 
    StringGadget(   i, 110, 25*i, 200, 20,          "", #PB_String_BorderLess) 
    Activate = i 
    i+1 
   EndIf 
   TextGadget  (10+i,  20, 25*i,  80, 20, Str(Points), #PB_Text_Center) 
   StringGadget(   i, 110, 25*i, 200, 20,        Name, #PB_String_BorderLess | #PB_String_ReadOnly) 
  Next 
  ButtonGadget (   0, 115, 290, 100, 20, "Eintragen") 
  
  CloseFile(0) 
  SetActiveGadget(Activate) 
  
  
 Repeat 
 Until WaitWindowEvent() = #PB_Event_Gadget And EventGadget() = 0 

 CreateFile(0, "Highscore.dat") 
  
 For i=1 To 10 
  WriteLong    (0, Val(GetGadgetText(10+i))) 
  WriteStringN (0,     GetGadgetText(   i) ) 
 Next 
  
DataSection 
 Col: 
 Data.l $4A16B5, $DC7323, $DC7323, $DC7323, $9BBD31 
EndDataSection 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger
