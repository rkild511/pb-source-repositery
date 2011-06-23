; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown (updated for PB3.93 by ts-soft, updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: No


;- Definition 
Define.f HighCounter, CounterMerken, Zeit2 
Frequ.LARGE_INTEGER 
Count.LARGE_INTEGER 

;- Konstanten 
#Window = 0 
#Flags  = #PB_Window_MaximizeGadget| #PB_Window_ScreenCentered 
#Gadget = 0 

If InitSprite() = 0 
  MessageRequester("Fehler", "DirectX ist nicht aktuell.", 0) 
  End 
EndIf 

WindowID = OpenWindow(#Window, 0, 0, 400, 450, "CounterTest", #Flags) 
If WindowID = 0 
  MessageRequester("Fehler", "Es konnte kein Fenster erstellt werden", 0) 
  End 
Else 
  OpenWindowedScreen(WindowID, 0, 0, 400, 400, 0, 0, 0) 
  CreateGadgetList(WindowID) 
    TrackBarGadget(#Gadget, 16, 405, 366, 40, 0, 60, #PB_TrackBar_Ticks) 
    FrameRate = 0 
    SetGadgetState(#Gadget, FrameRate) 
EndIf 

Procedure.l FPS() 
  Shared Zeit, Frames, Ausgabe 
  If GetTickCount_() < Zeit + 1000 
    Frames + 1 
  Else 
    Ausgabe = Frames 
    Frames  = 0 
    Zeit    = GetTickCount_() 
  EndIf 
  If Ausgabe > 0 
    ProcedureReturn Ausgabe 
  Else 
    ProcedureReturn 60 
  EndIf  
EndProcedure 

;- Counter vorbereiten 
MemCounter = AllocateMemory(8) 
QueryPerformanceFrequency_(MemCounter) 
CopyMemory(MemCounter, @Frequ, 8) 
CountsProSek = Frequ\lowpart 
QueryPerformanceCounter_(MemCounter) 
CopyMemory(MemCounter, @Count, 8) 
CounterMerken = Count\lowpart 

SetFrameRate(FrameRate) 
Repeat 
  Event = WindowEvent() 
  If Event = #PB_Event_CloseWindow 
    beenden = #True 
  EndIf 
  
  If Event = #PB_Event_Gadget 
    Select EventGadget() 
      Case #Gadget 
        FrameRate = GetGadgetState(#Gadget) 
        SetFrameRate(FrameRate) 
    EndSelect 
  EndIf 
  
  fps = FPS() 
  
  ClearScreen(RGB(0,0,0)) 
    StartDrawing(ScreenOutput()) 
        
        DrawText(0, 0,"Eingestellte FrameRate: " + Str(FrameRate)) 
        DrawText(0, 18,"Gemessene Frames: " + Str(fps)) 
      
        DrawText(0, 40,"Soll-FrameAbstand in ms: " + StrF(1000 / fps)) 
        Gosub HighCounter 
        DrawText(0, 58,"Ist-FrameAbstand in ms: " + StrF(HighCounter * 1000)) 
      
        Zeit2 + HighCounter * 1000 
        If Zeit2 < 1000 
          Frame2 + 1 
        Else 
          Ausgabe2 = Frame2 
          Frame2 = 0 
          Zeit2  = 0 
        EndIf  
        DrawText(0, 80,"Echte Frames: " + Str(Ausgabe2)) 

    StopDrawing() 
    FlipBuffers()
Until beenden = #True 
End 

HighCounter: 
  QueryPerformanceCounter_(MemCounter) 
  CopyMemory(MemCounter, @Count, 8) 
  HighCounter = (Count\lowpart - CounterMerken) / CountsProSek 
  CounterMerken = Count\lowpart 
Return 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger