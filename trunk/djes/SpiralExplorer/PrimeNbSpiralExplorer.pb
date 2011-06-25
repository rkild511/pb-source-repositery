;**********************************
;
; Primes numbers spiral exploration
; 26/05/2011
; by djes (djes@free.fr)
; Thx to Sirius-2337, Demivec, Gnasen for IsPrime optim
; Thx to DjPoke, Fig, zaphod, graph100, LSI & Nat the Great for LookForPrimes() optim
;
;**********************************

Global PrimesNb, ww, wh, GadgetAngle, GadgetDeviation, TextFlag
Global Dim Primes(80000)

Procedure IsPrime(number.l)

  If number = 2
    ProcedureReturn 1
  ElseIf number % 2 = 0
    ProcedureReturn 0
  Else
    x = Sqr(number)
    For t = 3 To x Step 2
      If number % t = 0
        ProcedureReturn 0
      EndIf
    Next t
  EndIf

  ProcedureReturn 1

EndProcedure

Procedure SpiralDraw()
 
  cx = ww / 2 - 20 : cy = wh / 2
 
  Angle.d = #PI / (GetGadgetState(0) / 100)
  Deviation.d = #PI / (GetGadgetState(1) / 10 )
 
  i.d = 0
  e.d = 0
  ;PreviousPrime = 0
  StartDrawing(ImageOutput(0))
  Box(0, 0, ww - 40, wh, $FFFFFF)
  If TextFlag
    DrawingMode(#PB_2DDrawing_Transparent|#PB_2DDrawing_XOr)
    For u = 0 To PrimesNb - 1
      x = cx + e * Sin(i)
      y = cy + e * Cos(i)
      DrawText(x, y, Str(Primes(u)), RGB($FF, $FF, 0))
      i = Angle * Primes(u)
      ;e = Deviation * Primes(u) ;deviation from the center is based on the prime value
      e + Deviation              ;deviation is linear
    Next u
  EndIf
 
  i.d = 0
  e.d = 0
  DrawingMode(#PB_2DDrawing_Default)
  For u = 0 To PrimesNb - 1
    x = cx + e * Sin(i)
    y = cy + e * Cos(i)
    If x >= 0 And x < ww - 40 And y >= 0 And y < wh
      Plot(x, y, 0)
    EndIf
    i = Angle * Primes(u)
    ;e = Deviation * Primes(u) ;deviation from the center is based on the prime value
    e + Deviation              ;deviation is linear
    ;PreviousPrime = Primes(u)
  Next u

  StopDrawing()
  StartDrawing(WindowOutput(0))
  DrawImage(ImageID(0), 0, 0)
  DrawText(0,  0, "Angle : PI/" + StrD(GetGadgetState(0) / 100, 2), 0, $FFFFFF)
  DrawText(0, 20, "Deviation : PI/" + Str(GetGadgetState(1)), 0, $FFFFFF)
  StopDrawing()

EndProcedure

Procedure GUIInit()
 
  ww = WindowWidth(0) : wh = WindowHeight(0)
  CreateImage(0, ww - 40, wh)
  TrackBarGadget(0, WindowWidth(0) - 40, 16, 20, WindowHeight(0) - 16, 1, 31410, #PB_TrackBar_Vertical)
  TrackBarGadget(1, WindowWidth(0) - 20, 16, 20, WindowHeight(0) - 16, 1, 4000, #PB_TrackBar_Vertical)
  CheckBoxGadget(2, WindowWidth(0) - 40,  1, 40, 16, "Text")
 
  SetGadgetState(0, GadgetAngle)
  SetGadgetState(1, GadgetDeviation)
 
EndProcedure

Procedure LookForPrimes(RangeSearch)
;  
;   TextGadget(4, 5, wh / 2 - 20, ww - 40 - 5, 20, "Looking for primes numbers - Please wait", #PB_Text_Right)
;   ProgressBarGadget(3,  5, wh / 2, ww - 40 - 5, 20, 0, RangeSearch, #PB_ProgressBar_Smooth)
;  
;   PrimesNb = 0
;   For u = 2 To RangeSearch
;     If IsPrime(u)
;       Primes(PrimesNb) = u
;       PrimesNb + 1
;     EndIf
;     SetGadgetState(3, u)
;   Next u
;   SetGadgetText(4, Str(PrimesNb) + " found")
;   Delay(1000)
;   FreeGadget(3)
;   FreeGadget(4)

   ; algo nat the great pour blitzmax
   ; port en pb by zaphod - 23/05/2011
   
  Define num.i = RangeSearch
  Define sqrnum.i = Sqr(RangeSearch)+1
  Dim PrimeFlags.i(RangeSearch)
  ReDim Primes.i(RangeSearch)
  Define tim.i
  
  PrimesNb = 1
  
  For x = 3 To sqrnum Step 2
    If PrimeFlags(x) = #False
      Primes(PrimesNb) = x
      PrimesNb+1   
      
      tim = x + x
      Repeat
        PrimeFlags(tim) = #True
        tim + x
      Until tim >= num
    EndIf
  Next
  
  Primes(0) = 2
  For y = x To num Step 2
    If PrimeFlags(y) = #False
      Primes(PrimesNb) = y     
      PrimesNb+1   
    EndIf
  Next

EndProcedure

;-MAIN

If OpenWindow(0, 0, 0, 600, 600, "Prime nb spiral explorer by djes@free.fr - Use top/down keys on gadgets", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget)
 
  WindowBounds(0, 500, 500, 4000, 4000)
 
  TextFlag = #False
  GadgetAngle = 247
  GadgetDeviation = 600
 
  GUIInit()
  LookForPrimes(500000)
  SpiralDraw()
     
  Repeat
   
    Event = WaitWindowEvent()
   
    Select Event
       
      Case #PB_Event_SizeWindow
       
        GUIInit()
        SpiralDraw()
       
      Case #PB_Event_Gadget
       
        Select EventGadget()
           
          Case 0, 1
           
            GadgetAngle = GetGadgetState(0)
            GadgetDeviation = GetGadgetState(1)
            SpiralDraw()
           
          Case 2
           
            TextFlag = ~TextFlag
            SpiralDraw()
           
        EndSelect

      Case #PB_Event_CloseWindow
        Quit = 1
       
    EndSelect
   
  Until Quit = 1
 
EndIf

End
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 6
; FirstLine = 129
; Folding = -
; EnableXP
; Executable = PrimeNbSpiralExplorer.exe
; DisableDebugger