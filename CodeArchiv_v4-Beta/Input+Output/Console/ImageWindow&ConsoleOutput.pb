; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9170&highlight=
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 24. January 2004
; OS: Windows
; Demo: Yes

Global close 

Procedure ShowConsole(x) 
  Delay(1000) 
    
    OpenConsole() 
      PrintN("just move this console window to see the ImageGadget doesn't update automaticly") 
      PrintN("press enter to quit") : kolom$=Input() 
      ClearConsole() 
      Print("thanks for testing! if you can help my, then post some reply! :-)") 
      Delay(1000) 
    CloseConsole() 
    
    close = #True 

EndProcedure 

CreateImage(0,800,600) 

OpenWindow(0,100,100,800,600,"4opnrij",#PB_Window_BorderLess) 
  CreateGadgetList(WindowID(0)) 
    ImageGadget(0,0,0,800,600,0) 
    SetGadgetState(0,ImageID(0)) 


  StartDrawing(ImageOutput(0)) 
    FrontColor(RGB(255,255,255))
    
    For t=0 To 9 
      Box(t*50,t*50,40,40,RGB(4*t,20*t,5*t)) 
    Next t 
    Box(22,573,227-22,592-573) 
  StopDrawing() 

  SetGadgetState(0,ImageID(0)) 

  CreateThread(@ShowConsole(),0) 

  Repeat 
    Repeat 
      Event=WindowEvent() 
      If Event=#PB_Event_CloseWindow 
        close=#True 
      ElseIf Event=0 
        Delay(10) 
      EndIf 
    Until Event=0 
  Until close 
    
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger