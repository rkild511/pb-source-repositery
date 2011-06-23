; www.PureArea.net
; Author: robink (updated for PB 4.00 by Andre)
; Date: 17. April 2004
; OS: Windows
; Demo: Yes

Dim Buffer(1, 57599) 
Dim Back(57599, 2) 

sa.f = 0.05
a.f = 0   
Global Start, Time, Current, ETime
cbuf = 0

Procedure MM(a, b, c)
  If a < b
    ProcedureReturn b
  EndIf
  If a > c
    ProcedureReturn c
  EndIf  
  ProcedureReturn a
EndProcedure

Procedure.l Timer()  
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows
      ProcedureReturn ElapsedMilliseconds()    ; formerly used command: GetTickCount_()
    CompilerCase #PB_OS_Linux
      ProcedureReturn ElapsedMilliseconds()
  CompilerEndSelect
EndProcedure 

Procedure.l ETimer()  
  ProcedureReturn Timer() - Start
EndProcedure 

Start = Timer()

Procedure.l TimePerFrame()
  Protected t.l
  t = Timer() - Current
  Current = Timer()
  ETime = ETimer() 
  ProcedureReturn t
EndProcedure

ExamineDesktops()
width  = DesktopWidth(0)
height = DesktopHeight(0)

If InitSprite() = 0 Or OpenScreen(width, height, 32, "") = 0 Or InitKeyboard() = 0 
  End
EndIf


UsePNGImageDecoder()
CatchSprite(0, ?logo) 

StartDrawing(SpriteOutput(0))
  For x = 0 To 57599
    dx = x%320
    dy = x/320   
    c = Point(dx, dy)
    Back(x, 0) = Red(c)  
    Back(x, 1) = Green(c)
    Back(x, 2) = Blue(c)        
  Next  
StopDrawing()

Flash = 0
Level = 0
r1.f = 50
rs.f = 1

Dim Meteor(200)
Dim Ball(20, 5)

Structure Star 
  r.f       
  w.f       
  z.f       
  zv.f          
EndStructure 

Dim Stars.Star(100)


For n = 0 To 100
  Stars(n)\r  = Random(200)-100 
  Stars(n)\w  = (Random(1000)-500)/100 
  Stars(n)\z = 100 + Random(900) 
  Stars(n)\zv = 0.5 + (Random(50)/10) 
Next 

For n = 0 To 20
  Ball(n, 0) = 160
  Ball(n, 1) = 90  
  Ball(n, 2) = 160
  Ball(n, 3) = 90    
  Ball(n, 4) = 0
  Ball(n, 5) = 0     
Next

For n = 0 To 200
  Meteor(n) = Random(319)
Next
    
Repeat
  Delay(10)
  FlipBuffers()  
  ExamineKeyboard()      
  ClearScreen(RGB(0, 0, 0))
  
  Time = TimePerFrame()
  If Time <> 0 
    If FPS = 0
      FPS = 1000/Time
    EndIf 
    FPS = (FPS * 0.9) + (1000/Time) * 0.1
  EndIf  
  If KeyboardReleased(#PB_Key_F)
    sFPS = 1 - sFPS
  EndIf  
  
  If Level < 3
    If Level = 1
      Max = ETime/500  
    ElseIf Level = 2    
      Max = 20
    Else
      Max = 5
    EndIf
    For n = 0 To Max
      Buffer(cbuf, Random(57278) + 1) = Random(255) - 128
    Next
  ElseIf Level = 3 
    For n = 0 To ETime/100
      Meteor(n) + 641
      If Meteor(n) > 56959
        Buffer(0, Meteor(n) - 641) = Random(127)
        Buffer(0, Meteor(n) - 642) = Random(127)
        Buffer(0, Meteor(n) - 640) = Random(127)
        Buffer(0, Meteor(n) - 643) = Random(127)        
        Buffer(0, Meteor(n) - 639) = Random(127)                
        Buffer(0, Meteor(n) - 961) = Random(127)                        
        Buffer(0, Meteor(n) - 960) = Random(127)                                
        Buffer(0, Meteor(n) - 962) = Random(127)                                     
        dx = Meteor(n)%320        
        Buffer(0, 56959 + dx) = Random(127)
        Meteor(n) = Random(319)      
      EndIf
    Buffer(0, Meteor(n)) = 127
    Next 
  ElseIf Level = 4      
    Buffer(0, 56959 + Random(320)) = Random(127)   
  ElseIf Level = 5  
    For n = 0 To ETime/1500
      Buffer(0, 28960 + n - Random(2*n))  = 127
      dx = (Ball(n, 2) - Ball(n, 0))
      dy = (Ball(n, 3) - Ball(n, 1))
      If Abs(dx) + Abs(dy) < 50
        Ball(n, 2) = Random(319)
        Ball(n, 3) = Random(179)    
      EndIf
      Ball(n, 0) + Ball(n, 4)
      Ball(n, 1) + Ball(n, 5)
      Ball(n, 4) + dx * 0.01
      Ball(n, 5) + dy * 0.01
      Ball(n, 4) * 0.9
      Ball(n, 5) * 0.9            
      tx = Ball(n, 0) + Ball(n, 1) * 320
      If tx >= 320 And  tx <= 57279 
        Buffer(0, tx) = 127
        Buffer(0, tx + 1) = 127
        Buffer(0, tx - 1) = 127  
        Buffer(0, tx + 320) = 127
        Buffer(0, tx - 320) = 127                
      EndIf      
    Next
  ElseIf Level > 5 And Level < 9
    If Level = 6
      dx = (Ball(0, 2) - Ball(0, 0))
      dy = (Ball(0, 3) - Ball(0, 1))
      If Abs(dx) + Abs(dy) < 50
        Ball(0, 2) = Random(319)
        Ball(0, 3) = Random(179)    
      EndIf        
    Else
      a.f + 0.1
      If r1 > 75
        rs = -1
      ElseIf r1 < 25
        rs = 1
      EndIf
      r1 + rs
      x2.f = r1 * Cos(a) + Sin(a) * r1 + 160
      y2.f = r1 * Sin(a) - Cos(a) * r1 + 90       
      dx = (x2 - Ball(0, 0))     
      dy = (y2 - Ball(0, 1))         
    EndIf
    Ball(0, 0) + Ball(0, 4)
    Ball(0, 1) + Ball(0, 5)
    If Level <> 8
      Ball(0, 4) + dx * 0.01
      Ball(0, 5) + dy * 0.01
      Ball(0, 4) * 0.9
      Ball(0, 5) * 0.9            
    EndIf
    tx = Ball(0, 0) + Ball(0, 1) * 320
    If tx >= 320 And  tx <= 57279 
      Buffer(0, tx) = 127
      Buffer(0, tx + 1) = 127
      Buffer(0, tx - 1) = 127  
      Buffer(0, tx + 320) = 127
      Buffer(0, tx - 320) = 127                
    EndIf     
    For n = 20 To 1 Step -1
      dx = (Ball(n - 1, 0) - Ball(n, 0))
      dy = (Ball(n - 1, 1) - Ball(n, 1))
      Ball(n, 0) + Ball(n, 4)
      Ball(n, 1) + Ball(n, 5)
      If Level <> 8      
        Ball(n, 4) + dx * 0.01
        Ball(n, 5) + dy * 0.01
        Ball(n, 4) * 0.9
        Ball(n, 5) * 0.9            
      EndIf
      tx = Ball(n, 0) + Ball(n, 1) * 320
      If tx >= 320 And  tx <= 57279 
        Buffer(0, tx) = 127
        Buffer(0, tx + 1) = 127
        Buffer(0, tx - 1) = 127  
        Buffer(0, tx + 320) = 127
        Buffer(0, tx - 320) = 127                
      EndIf      
    Next        
  EndIf

  StartDrawing(ScreenOutput())
    If Level < 9
      For x = 640 To 57279
        If Level < 3
          Buffer(1 - cbuf, x) = ((Buffer(cbuf, x - 1) + Buffer(cbuf, x + 1) + Buffer(cbuf, x - 320) + Buffer(cbuf, x + 320)) >> 1) - Buffer(1 - cbuf, x) 
          If Level < 2      
            Buffer(1 - cbuf, x) = Buffer(1 - cbuf, x) - Buffer(1 - cbuf, x) >> 7
          EndIf
          If Level = 0
            XOffset = Buffer(cbuf, x - 1) - Buffer(cbuf, x + 1)
            YOffset = Buffer(cbuf, x - 320) - Buffer(cbuf, x + 320)
            tx = x + XOffset + YOffset * 320      
            Shading = (XOffset+YOffset)
            If tx >= 320 And  tx <= 57279
              r = MM(Back(tx, 0) + Shading, 0, 255)
              g = MM(Back(tx, 1) + Shading, 0, 255)
              b = MM(Back(tx, 2) + Shading, 0, 255)
              c = RGB(r, g, b)                  
            EndIf
          Else
            c = Buffer(1 - cbuf, x) + 128
            c = RGB(c *  0.7, c * 0.8, c)
          EndIf
        ElseIf level > 2
          r = 320 + 1 - Random(1) * 2 
          Buffer(0, x - r) = (Buffer(0, x - 1) + Buffer(0, x + 1) + Buffer(0, x - 320) + Buffer(0, x + 320) + Buffer(0, x))/5 - Random(12) >> 2
          Buffer(0, x - r) = MM(Buffer(0, x  - r), -128, 127)  
          c = Buffer(0, x) + 128
          c = RGB(MM(c << 2, 0, 255), MM(c << 1, 0, 255), MM(c >> 1, 0, 255))
        EndIf      
        dx = x%320
        dy = x/320        
        Plot(dx, dy + 30, c)              
      Next  
    ElseIf Level = 9
      a.f + sa.f
      If a > 5
        sa  -0.0001
      ElseIf a < -5
        sa + 0.0001
      EndIf      
      For n = 0 To 100
        Stars(n)\z = Stars(n)\z - Stars(n)\zv 
        px.f = Stars(n)\r * Cos(Stars(n)\w + a) + Sin(Stars(n)\w + a) * Stars(n)\r
        py.f = Stars(n)\r * Sin(Stars(n)\w + a) - Cos(Stars(n)\w + a) * Stars(n)\r
        sx = px / Stars(n)\z * 100 + 160
        sy = py / Stars(n)\z * 100 + 90

        If sx < 0 Or sy < 0 Or sx > 319 Or sy > 179 Or Stars(dummy)\z < 1 
          Stars(n)\r  = Random(500)-250 
          Stars(n)\w  = (Random(1000)-500)/100 
          Stars(n)\z = 100 + Random(900) 
          Stars(n)\zv = 0.5 + (Random(50)/10) 
        Else 
          b = 255-(Stars(n)\z *(255/1000)) 
          Plot(sx, sy + 30, RGB(b, b, b))
        EndIf 
      Next 
    EndIf
    If ETime >= 10000 And Level = 2
      Level = 3
      Start = Timer()      
      For x = 0 To 320
        Buffer(0, 56959 + x) = -128
        Buffer(0, 57279 + x) = -128      
      Next           
    EndIf     
    If ETime >= 15000 And Level = 1
      Level = 2
      Start = Timer()      
    EndIf        
    If ETime >= 15000 And Level = 0
      Level = 1
      Flash = 5 
      Start = Timer()   
    EndIf     
    If ETime >= 20000 And Level = 4
      Level = 5
      Start = Timer()  
      For x = 0 To 320
        Buffer(0, 56959 + x) = -128
        Buffer(0, 57279 + x) = -128      
      Next           
    EndIf    
    If ETime >= 20000 And Level = 9 And ETime <= 30000 
      DrawingMode(1)
      FrontColor(RGB(128, 128, 128))
      DrawText(320 - (Etime - 20000)/10, 30, "This was a Little Graphics Demo by robink, programmed in Purebasic!")
    EndIf      
    If ETime >= 10000 And Level = 8
      Level = 9      
      Start = Timer()    
      sa.f = 0.05
      a.f = 0    
      Flash = 5  
    EndIf      
    If ETime >= 30000 And Level = 9
      End
    EndIf        
    If ETime >= 30000 And Level = 7
      Level = 8
      Start = Timer()    
    EndIf         
    If ETime >= 30000 And Level = 6
      Level = 7
      Start = Timer()    
    EndIf                 
    If ETime >= 30000 And Level = 3
      Level = 4
      Start = Timer()    
    EndIf      
    If ETime >= 30000 And Level = 5
      Level = 6
      Start = Timer()    
    EndIf       
    If Flash > 0 
      Box(0, 30, 320, 180, RGB(255, 255, 255))
      Flash - 1
    EndIf
    cbuf = 1 - cbuf
    Box(0, 0, 320, 30, 0)
    Box(0, 210, 320, 30, 0)    
    If sFPS 
      DrawingMode(1)
      FrontColor(RGB(128, 128, 128))
      DrawText(250, 215, "fps: " + Str(FPS))
    EndIf    
  StopDrawing()
Until KeyboardReleased(#PB_Key_Escape)
End

DataSection
  Logo:
  IncludeBinary "bg.png"
EndDataSection 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; Executable = ..\upx\gfxdemo.exe
; DisableDebugger