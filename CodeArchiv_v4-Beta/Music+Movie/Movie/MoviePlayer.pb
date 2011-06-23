; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1480&start=10&postdays=0&postorder=asc&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 26. June 2003
; OS: Windows
; Demo: No

; 
; by Danilo, 26.06.2003 - german forum 
; 

Define ChangePos.b

FileName$ = OpenFileRequester("Open","","Movies - AVI,MPG|*.avi;*.mpg",1) 
If FileName$ 
  If InitMovie() 
    OpenWindow(1,200,200,300,300,"MoviePlay-Test",#PB_Window_SystemMenu) 
    CreateGadgetList(WindowID(1)) 
    ImageGadget(2,5,5,300,290,0,#PB_Image_Border) 

    If LoadMovie(1,FileName$)=0 
      MessageRequester("ERROR","Cant load movie !",#MB_ICONERROR):End 
    EndIf 
    ResizeWindow(1,#PB_Ignore,#PB_Ignore,MovieWidth(1)+10,MovieHeight(1)+55) 
    ResizeGadget(2,5,5,MovieWidth(1),MovieHeight(1)) 

    Length  = MovieLength(1)
    Debug MovieInfo(1,0)
    FPS     = MovieInfo(1,0)
    MHeight = MovieHeight(1) 
    MWidth  = MovieWidth(1) 
    TrackBarGadget(1,5,MHeight+10,MWidth-50,20,1,Length/FPS) 
    TextGadget(3,MWidth-45,MHeight+10,50,20,"0",#PB_Text_Right) 
    ButtonGadget(4,5,MHeight+35,60,20,"Pause") 
    ButtonGadget(5,70,MHeight+35,60,20,"Stop") 
    PlayMovie(1,GadgetID(2)) 

    Repeat 
      Select WindowEvent() 
        Case #PB_Event_CloseWindow : End 
        Case #PB_Event_Gadget 
          Select EventGadget() 
            Case 1 ; Trackbar 
              ;Debug EventType() 
              ;If EventType()=-1 
              MovieSeek(1,GetGadgetState(1)*FPS) 
              ChangePos=1
              ;Beep_(800,10) 
              ;EndIf 
            Case 4 ; Pause 
              If GetGadgetText(4)="Pause" 
                PauseMovie(1) 
                SetGadgetText(4,"Resume") 
                DisableGadget(1,1)
              Else 
                ResumeMovie(1) 
                SetGadgetText(4,"Pause") 
                DisableGadget(1,0)
              EndIf 
            Case 5 ; Stop 
              StopMovie(1) 
              MovieSeek(1,1) 
          EndSelect 
          SetFocus_(WindowID(1)) 
        Default 
          Delay(1) 
          x = MovieStatus(1) 
          If x => 0 
            If ChangePos=0
              SetGadgetState(1,x/FPS) 
            Else
              ChangePos=0
            EndIf
            SS = Int(x / FPS)           : While SS > 59:SS-60:Wend 
            MM = Int(x / FPS / 60)      : While MM > 59:MM-60:Wend 
            HH = Int(x / FPS / 60 / 60) : While HH > 59:HH-60:Wend 
            If oldSecond <> SS 
              SetGadgetText(3,RSet(StrU(HH,2),2,"0")+":"+RSet(StrU(MM,2),2,"0")+":"+RSet(StrU(SS,2),2,"0")) 
              oldSecond = SS 
            EndIf 
          EndIf 
          ;UpdateWindow_(WindowID()) 
      EndSelect 
    ForEver 
  Else 
    MessageRequester("ERROR","Cant init movie engine !",#MB_ICONERROR):End 
  EndIf 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
