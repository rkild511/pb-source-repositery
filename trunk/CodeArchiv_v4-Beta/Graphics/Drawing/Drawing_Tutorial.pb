; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8623&highlight=
; Author: Paul (updated for PB4.00 by blbltheworm)
; Date: 06. December 2003
; OS: Windows
; Demo: Yes

#Window_Mode=0 
#Gadget_Mode_Option1=1 
#Gadget_Mode_Option2=2 
#Gadget_Mode_Ok=3 



If InitSprite()=0 Or InitKeyboard()=0 
  MessageRequester("Error","Could Not Initialize DirectX",0) 
  End 
EndIf 

UseJPEGImageDecoder() 
    
    

If OpenWindow(#Window_Mode,175,0,201,129,"Select Mode",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  If CreateGadgetList(WindowID(#Window_Mode)) 
    OptionGadget(#Gadget_Mode_Option1,45,25,95,15,"Window Mode") 
    OptionGadget(#Gadget_Mode_Option2,45,45,95,15,"Screen Mode") 
    ButtonGadget(#Gadget_Mode_Ok,70,85,60,20,"Ok") 
    SetGadgetState(#Gadget_Mode_Option1,1)    

    quitMode=0 
    Repeat 
      EventID=WaitWindowEvent() 
      Select EventID 
        Case #PB_Event_CloseWindow 
          If EventWindow()=#Window_Mode 
            End 
          EndIf 

        Case #PB_Event_Gadget 
          Select EventGadget() 
            Case #Gadget_Mode_Ok 
              If GetGadgetState(#Gadget_Mode_Option1) 
                screenmode=1 
                Else 
                screenmode=0 
              EndIf 
              quitMode=1 
          EndSelect 

      EndSelect 
    Until quitMode 
    CloseWindow(#Window_Mode) 
    
    
    If screenmode 
      If OpenWindow(0,0,0,640,480,"MyApp",#PB_Window_TitleBar|#PB_Window_ScreenCentered) 
        If OpenWindowedScreen(WindowID(0),0,0,640,480,0,0,0)=0 
          MessageRequester("Error","Could not open Windowed Screen",0) 
        EndIf 
        Else 
        MessageRequester("Error","Could not create Window",0) 
        End 
      EndIf 
      
      Else 
      If OpenScreen(640,480,16,"MyApp")=0 
        MessageRequester("Error","Could not create DirectX Screen",0) 
      EndIf 
    EndIf 
    SetFrameRate(75) 




    
    LoadSprite(0,"..\Gfx\image1.jpg") 
    LoadSprite(1,"..\Gfx\image2.jpg") 
    
    
    quitMain=0 
    Repeat 
      If screenmode 
        WindowEvent() 
        Delay(1) 
      EndIf 
      
      ExamineKeyboard() 
      If KeyboardReleased(#PB_Key_Escape) 
        quitMain=1 
      EndIf 
      
      ClearScreen(RGB(0,0,0)) 
      
      counter+1 
      If counter>75 
        counter=0 
        image+1 
        If image>1 
          image=0 
        EndIf 
      EndIf 
      
      DisplaySprite(image,50,50) 
      
      FlipBuffers()    
    Until quitMain 
      
  EndIf 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
