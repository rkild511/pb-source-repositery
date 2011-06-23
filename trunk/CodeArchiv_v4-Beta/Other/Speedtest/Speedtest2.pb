; English forum: 
; Author: Unknown (updated for PB 4.00 by Andre)
; Date: 31. December 2002
; OS: Windows
; Demo: No


OpenWindow(1,224, 172, 205, 64,"Test Speed PureBasic",#PB_Window_SystemMenu)
CreateGadgetList(WindowID(1)) 
StringGadget(1,  4, 4, 128, 20, "") 
ButtonGadget(2, 136, 4, 60, 20, "Begin") 
TextGadget(3,4, 28, 128, 16, "Elapsed: 0") 
ButtonGadget(4, 136, 28, 60, 20, "Exit") 

  Repeat
    EventID.l = WaitWindowEvent()
    Select EventGadget() 
      Case 2
        Gosub ExecuteTest
      Case 4
        End
    EndSelect
  Until EventID = #PB_Event_CloseWindow

End

ExecuteTest:

    SetGadgetText(3, "Please Wait .")
    
  StartTimer.l = GetTickCount_()
    
  For LoopFor1.l = 1 To 10000000
    Result1.f=((100000 * 100) / 1000) + Sqr(4)
    Result2.f=((100000 * 100) / 1000) + Sqr(4)
    Result3.f=((100000 * 100) / 1000) + Sqr(4)
    Result4.f=((100000 * 100) / 1000) + Sqr(4)
  
    Result1=((100000 * 100) / 1000) + Sqr(4)
    Result2=((100000 * 100) / 1000) + Sqr(4)
    Result3=((100000 * 100) / 1000) + Sqr(4)
    Result4=((100000 * 100) / 1000) + Sqr(4)
  
    If LoopFor1 = 100000
      SetGadgetText(3, "Please Wait .") 
    ElseIf LoopFor1 = 1000000
      SetGadgetText(3, "Please Wait .") 
    ElseIf LoopFor1 = 10000000
      SetGadgetText(3, "Please Wait .") 
    EndIf
  Next LoopFor1
  
  SetGadgetText(1, "Result:" + Str(Result1 + Result2))
     
  ElapsedTime.l = GetTickCount_()-StartTimer

  SetGadgetText(3, "Elapsed: " + Str(ElapsedTime) +  " ms")

Return

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger