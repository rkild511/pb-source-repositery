; www.PureArea.net
; Author: Ingo Turski (updated for PB4.00 by blbltheworm)
; Date: 20. January 2003
; OS: Windows
; Demo: Yes


; MessageRequester Demo 
; 20. Jan. 2003 by Ingo Turski

If OpenWindow(0, 235, 10, 550, 290, "MessageRequester-Demo", #PB_Window_MinimizeGadget | #PB_Window_TitleBar)

  If CreateGadgetList(WindowID(0))
    
    Button=ButtonGadget(0,10,10,150,24,"#MB_ICONSTOP") 
    Button=ButtonGadget(1,200,10,150,24,"#MB_ICONERROR") 
    Button=ButtonGadget(2,10,40,150,24,"#MB_ICONHAND") 

    Button=ButtonGadget(3,10,100,150,24,"#MB_ICONQUESTION") 

    Button=ButtonGadget(4,10,160,150,24,"#MB_ICONASTERISK") 
    Button=ButtonGadget(5,10,190,150,24,"#MB_ICONINFORMATION") 

    Button=ButtonGadget(6,200,260,150,24,"#MB_ICONWARNING") 
    Button=ButtonGadget(7,10,260,150,24,"#MB_ICONEXCLAMATION") 

    Button=ButtonGadget(8,390,10,150,24,"0") 
    Button=ButtonGadget(9,390,70,150,24,"#MB_OKCANCEL") 
    Button=ButtonGadget(10,390,130,150,24,"#MB_YESNO") 
    Button=ButtonGadget(11,390,160,150,24,"#MB_YESNOCANCEL") 
    Button=ButtonGadget(12,390,220,150,24,"#MB_RETRYCANCEL") 
    Button=ButtonGadget(13,390,260,150,24,"#MB_ABORTRETRYIGNORE") 

    TextGadget(14, 247, 117, 56, 56, Chr(10)+"Result" , #PB_Text_Center | #PB_Text_Border)

    Repeat
      EventID.l = WaitWindowEvent()
      If EventID = #PB_Event_CloseWindow
        Quit = #True
      ElseIf EventID = #PB_Event_Gadget 

        Select EventGadget()
        Case 0 
          Result = MessageRequester("MessageRequester-Demo", "Icon (X) : Stop", #MB_ICONSTOP)
        Case 1
          Result = MessageRequester("MessageRequester-Demo", "Icon (X) : Stop (ab NT4/95)", #MB_ICONERROR)
        Case 2
          Result = MessageRequester("MessageRequester-Demo", "Icon (X) : Stop", #MB_ICONHAND)
        Case 3
          Result = MessageRequester("MessageRequester-Demo", "Icon (?) : Frage", #MB_ICONQUESTION)
        Case 4
          Result = MessageRequester("MessageRequester-Demo", "Icon (i) : Information", #MB_ICONASTERISK)
        Case 5
          Result = MessageRequester("MessageRequester-Demo", "Icon (i) : Information", #MB_ICONINFORMATION)
        Case 6
          Result = MessageRequester("MessageRequester-Demo", "Warnung (ab NT4/95)", #MB_ICONWARNING)
        Case 7
          Result = MessageRequester("MessageRequester-Demo", "Warnung", #MB_ICONEXCLAMATION)
        Case 8
          Result = MessageRequester("MessageRequester-Demo", "#MB_OK (0 = Standard)", #MB_OK)
        Case 9
          Result = MessageRequester("MessageRequester-Demo", "#MB_OKCANCEL", #MB_OKCANCEL)
        Case 10
          Result = MessageRequester("MessageRequester-Demo", "#MB_YESNO", #MB_YESNO)
        Case 11
          Result = MessageRequester("MessageRequester-Demo", "#MB_YESNOCANCEL", #MB_YESNOCANCEL)
        Case 12
          Result = MessageRequester("MessageRequester-Demo", "#MB_RETRYCANCEL", #MB_RETRYCANCEL)
        Case 13
          Result = MessageRequester("MessageRequester-Demo", "#MB_ABORTRETRYIGNORE", #MB_ABORTRETRYIGNORE)
        EndSelect
        SetGadgetText(14,Chr(10)+"Result"+Chr(10)+"= "+Str(Result))

      EndIf 
    Until Quit

  Else
    MessageRequester("MessageRequester-Demo", "schwerwiegender Programmfehler !", #MB_ICONSTOP | #MB_SYSTEMMODAL)
  EndIf

CloseWindow(0)
EndIf

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger