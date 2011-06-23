; English forum: http://www.purebasic.fr/english/viewtopic.php?t=12390&highlight=
; Author: Erix14 (updated for PB 4.00 by Andre)
; Date: 08. September 2004
; OS: Windows
; Demo: No


; Kann bitte mal jemand die verbliebenen (auskommentierten) Locate() Befehle
; überprüfen? Insbesondere wegen den dort angegebenen Minus-Werten..


;/
;/                   -  Speed Tetris  - Programme Erix14 (2004)
;/                  Windows XP SP2 - PureBasic 3.91 - jaPBe 2.4.7.17
;/
; Originally posted @ http://purebasic.hmt-forum.com/viewtopic.php?t=1417&sid=9001af316d4ba274773e4bf62344da4f
;
; Updates and translation F.Weil for english readers
;
#WindowWidth = 800
#WindowHeight = 600

Structure Sort
  Mode.b
  PlayerName.b[16]
  Chrono.l
EndStructure

Enumeration
  #ComponentEmpty
  #ComponentGreen
  #ComponentRed
  #ComponentBlue
  #ComponentBrown
  #ComponentYellow
  #ComponentViolet
  #ComponentGray
  #Image1
  #Image2
  #Image3
  #Image4
  #Image5
  #BkGame
  #Game
  #BkFuturComponent
  #Sort
  #Chrono
  #Loose
  #Countdown
EndEnumeration

Enumeration
  #Window
  #NewGame
  #Rule
  #Mode
  #Cancel
  #Quit
EndEnumeration

Global hWnd,NewGame,ComponentX,ComponentY,Component,Rotation,Points,m_hMidiOut,m_MIDIOpen.b
Global StartChrono,StopChrono,FuturComponent,Nom$,Mode

Global NewList SortSprintList.Sort()
Global NewList SortEnduranceList.Sort()

Global Dim GameArray.b(10,17)
Global Dim Shape.l(7,4)

Shape(1,1)=%0100010001000100
Shape(1,2)=%0000111100000000
Shape(1,3)=%0100010001000100
Shape(1,4)=%0000111100000000
Shape(2,1)=%0000011001100000
Shape(2,2)=%0000011001100000
Shape(2,3)=%0000011001100000
Shape(2,4)=%0000011001100000
Shape(3,1)=%0110010001000000
Shape(3,2)=%1110001000000000
Shape(3,3)=%0010001001100000
Shape(3,4)=%1000111000000000
Shape(4,1)=%1110010000000000
Shape(4,2)=%0010011000100000
Shape(4,3)=%0000010011100000
Shape(4,4)=%1000110010000000
Shape(5,1)=%1100011000000000
Shape(5,2)=%0100110010000000
Shape(5,3)=%1100011000000000
Shape(5,4)=%0100110010000000
Shape(6,1)=%0110110000000000
Shape(6,2)=%1000110001000000
Shape(6,3)=%0110110000000000
Shape(6,4)=%1000110001000000
Shape(7,1)=%0110001000100000
Shape(7,2)=%0010111000000000
Shape(7,3)=%0100010001100000
Shape(7,4)=%1110100000000000

Procedure.l ImageButton(ImageIndex.l, Length.l, Height.l, Text.s)
  ImageID.l = CreateImage(ImageIndex, Length, Height)
  a.f = 150 / Height
  StartDrawing(ImageOutput(ImageIndex))
  For T = 0 To Height
    c = (Height-T)*a + 60
    Line(0,T,Length,0, RGB(0,c,0))
  Next
  DrawingMode(1)
  FrontColor(RGB(0,0,0))
  DrawText(10, 2, Text)
  StopDrawing()
  ProcedureReturn ImageID
EndProcedure

Procedure ComponentImage(ImageIndex,r,g,b)
  CreateSprite(ImageIndex,30,30)
  StartDrawing(SpriteOutput(ImageIndex))
  Box(1,1,28,28,RGB(r,g,b))
  Line(0,0,29,0,RGB(r*1.5,g*1.5,b*1.5))
  Line(0,0,0,29)
  Line(0,29,29,0,RGB(r*0.4,g*0.4,b*0.4))
  Line(29,0,0,29)
  StopDrawing()
EndProcedure

Procedure.s StrChrono(Chro)
  m = Chro / 60000
  Chro = Chro % 60000
  s = Chro / 1000
  Chro = Chro % 1000
  c = Chro / 10
  ProcedureReturn RSet(Str(m),2,"0")+":"+RSet(Str(s),2,"0")+":"+RSet(Str(c),2,"0")
EndProcedure

Procedure DisplayGame()
  For y=0 To 16
    For x=0 To 9
      If GameArray(x,y) > 0
          DisplaySprite(GameArray(x,y),10+x*30,10+y*30)
      EndIf
    Next
  Next
EndProcedure

Procedure DisplayComponent()
  DisplaySprite(#Game,0,0)
  DisplayGame()
  iPos = %1000000000000000
  iShape = Shape(Component,Rotation)
  For y=0 To 3
    For x=0 To 3
      If (iShape & iPos) > 0
          DisplaySprite(Component,10+x*30+ComponentX*30,10+y*30+ComponentY*30)
      EndIf
      iPos >> 1
    Next
  Next
  FlipBuffers()
EndProcedure

Procedure Affiche_Chrono_Points()
  If NewGame = 1
      StopChrono = GetTickCount_()
  EndIf
  font1 = LoadFont(0,"Times New Roman",20,#PB_Font_Bold)
  BKGame_DC = StartDrawing(WindowOutput(#Window))
  DrawImage(ImageID(#Chrono),35,210)
  DrawingMode(1)
  DrawingFont(font1)
  FrontColor(RGB(32,32,32))
  DrawText(59,254,StrChrono(StopChrono - StartChrono)) ; Display stopwatch
  l = (110 - TextWidth(Str(Points))) / 2
  DrawText(55+l,345,Str(Points)) ; Display current game points
  StopDrawing()
EndProcedure

Procedure Box3D(x,y,Length,Height)
  Line(x,y,Length,0,$FFFFFF)
  Line(x,y,0,Height)
  Line(x,y+Height,Length,0,$000000)
  Line(x+Length,y,0,Height+1)
EndProcedure

Procedure Box3DI(x,y,Length,Height)
  Line(x,y,Length,0,$000000)
  Line(x,y,0,Height)
  Line(x,y+Height,Length,0,$FFFFFF)
  Line(x+Length,y,0,Height+1)
EndProcedure

Procedure PlaqueMetal(x,y,Length,Height)
  Box3D(x,y,Length,Height)
  Box3D(x+4,y+4,3,3)
  Box3D(x+4,y+Height-7,3,3)
  Box3D(x+Length-7,y+4,3,3)
  Box3D(x+Length-7,y+Height-7,3,3)
EndProcedure

Procedure AfficheFuturComponent()
  iPos = %1000000000000000
  iShape = Shape(FuturComponent,Rotation)
  StartDrawing(WindowOutput(#Window))
  DrawImage(ImageID(#BkFuturComponent),80,450)
  For y=0 To 3
    For x=0 To 3
      If (iShape & iPos) > 0
          Box(80+x*20,450+y*20,19,19,RGB(128,128,200))
          Box3D(80+x*20,450+y*20,19,19)
      EndIf
      iPos >> 1
    Next
  Next
  StopDrawing()
EndProcedure

Procedure.b Collision(eX,eY)
  iPos = %1000000000000000
  iShape = Shape(Component,Rotation)
  For y=0 To 3
    For x=0 To 3
      If ((eX + x) > 9 Or (eX + x) < 0) And (iShape & iPos) > 0
          ProcedureReturn 1
        ElseIf (eY + y) > 16 And (iShape & iPos) > 0
          ProcedureReturn 1
        ElseIf (iShape & iPos) > 0 And GameArray(eX+x,eY+y) > 0
          ProcedureReturn 1
      EndIf
      iPos >> 1
    Next
  Next
  ProcedureReturn 0
EndProcedure

Procedure SendMIDIMessage(nStatus.l,nCanal.l,nData1.l,nData2.l)
  dwFlags.l = nStatus | nCanal | (nData1 << 8) | (nData2 << 16)
  temp.l = midiOutShortMsg_(m_hMidiOut,dwFlags);
  If temp<>0
      MessageRequester("Alert", "MIDI send message error",0)
  EndIf
EndProcedure

Procedure MIDIOpen()
  If m_MIDIOpen = 0
      If midiOutOpen_(@m_hMidiOut,MIDIMAPPER,0,0,0) <> 0
          MessageRequester("Alert", "MIDI output not accessible",0)
        Else
          SendMIDIMessage($C0,0,0,0)
          m_MIDIOpen = 1
      EndIf
  EndIf
EndProcedure

Procedure PlayNoteMIDI(Canal.b,Note.b,VelocityDown.b,VelocityUp.b)
  If m_MIDIOpen
      SendMIDIMessage($80 | Canal,0,Note,VelocityDown)
      SendMIDIMessage($90 | Canal,0,Note,VelocityUp)
  EndIf         
EndProcedure

Procedure ChargeInstrument(Canal.b,Instrument.b)
  If m_MIDIOpen
      SendMIDIMessage($C0 | Canal,0,Instrument,0)
  EndIf         
EndProcedure

Procedure DisplaySort()
  font1 = LoadFont(0,"Arial",12,#PB_Font_Bold)
  StartDrawing(WindowOutput(#Window))
  DrawImage(ImageID(#Sort),540,60)
  DrawingFont(font1)
  DrawingMode(1)
  FrontColor(RGB(32,32,32))
  T = 0
  If Mode
      ForEach SortEnduranceList()
        DrawText(555,120+T*20,RSet(Str(T+1),2,"0"))
        NomJ.s = ""
        For c=0 To 15
          NomJ + Chr(SortEnduranceList()\PlayerName[c])
          If TextWidth(NomJ) > 80
              Break
          EndIf
        Next
        DrawText(585,120+T*20,NomJ)
        DrawText(680,120+T*20,StrChrono(SortEnduranceList()\Chrono))
        T + 1
      Next
    Else
      ForEach SortSprintList()
        DrawText(555,120+T*20,RSet(Str(T+1),2,"0"))
        NomJ.s = ""
        For c=0 To 15
          NomJ + Chr(SortSprintList()\PlayerName[c])
          If TextWidth(NomJ) > 80
              Break
          EndIf
        Next
        DrawText(585,120+T*20,NomJ)
        DrawText(680,120+T*20,StrChrono(SortSprintList()\Chrono))
        T + 1
      Next
  EndIf
  FrontColor(RGB(64,32,32))
  If Mode
      DrawText(590,527,"Mode endurance")
    Else
      DrawText(605,527,"Mode sprint")
  EndIf
  StopDrawing()
EndProcedure

Procedure LoadSort()
  ClearList(SortSprintList())
  ClearList(SortEnduranceList())
  iFichier = ReadFile(#PB_Any,"c:\SpeedTetris.dat")
  If iFichier
      While Eof(iFichier) = 0
        ReadData(iFichier, @ListeSort.Sort,SizeOf(Sort))
        If ListeSort\Mode
            AddElement(SortEnduranceList())
            SortEnduranceList()\Mode = ListeSort\Mode
            For c=0 To 15
              SortEnduranceList()\PlayerName[c] = ListeSort\PlayerName[c]
            Next
            SortEnduranceList()\Chrono = ListeSort\Chrono
          Else
            AddElement(SortSprintList())
            SortSprintList()\Mode = ListeSort\Mode
            For c=0 To 15
              SortSprintList()\PlayerName[c] = ListeSort\PlayerName[c]
            Next
            SortSprintList()\Chrono = ListeSort\Chrono
        EndIf
      Wend
      CloseFile(iFichier)
  EndIf
EndProcedure

Procedure SaveSort()
  iFichier = CreateFile(#PB_Any,"c:\SpeedTetris.dat")
  If iFichier
      ForEach SortSprintList()
        WriteData(iFichier, @SortSprintList(),SizeOf(Sort))
      Next
      ForEach SortEnduranceList()
        WriteData(iFichier, @SortEnduranceList(),SizeOf(Sort))
      Next
      CloseFile(iFichier)
  EndIf
EndProcedure

Procedure GamesEnd()
  StopChrono = GetTickCount_()
  NewGame = 0
  Chrono = StopChrono - StartChrono
  iPlace = 0
  If Mode
      ForEach SortEnduranceList()
        If Chrono <= SortEnduranceList()\Chrono
            Break
        EndIf
        iPlace + 1
      Next
      If iPlace > 18
          ProcedureReturn
      EndIf
      Nom$ = InputRequester("Congrats, you are nr "+Str(iPlace+1),"Please enter your name :",Nom$)
      SelectElement(SortEnduranceList(),iPlace)
      If iPlace = CountList(SortEnduranceList())
          AddElement(SortEnduranceList())
        Else
          InsertElement(SortEnduranceList())
      EndIf
      For c=0 To 15
        SortEnduranceList()\PlayerName[c] = Asc(Mid(Nom$,c+1,1))
      Next
      SortEnduranceList()\Mode = Mode
      SortEnduranceList()\Chrono = Chrono
      If CountList(SortEnduranceList()) > 19
          LastElement(SortEnduranceList())
          DeleteElement(SortEnduranceList())
      EndIf
    Else
      ForEach SortSprintList()
        If Chrono <= SortSprintList()\Chrono
            Break
        EndIf
        iPlace + 1
      Next
      If iPlace > 18
          ProcedureReturn
      EndIf
      Nom$ = InputRequester("Congrats, you are nr "+Str(iPlace+1),"Please enter your name :",Nom$)
      SelectElement(SortSprintList(),iPlace)
      If iPlace = CountList(SortSprintList())
          AddElement(SortSprintList())
        Else
          InsertElement(SortSprintList())
      EndIf
      For c=0 To 15
        SortSprintList()\PlayerName[c] = Asc(Mid(Nom$,c+1,1))
      Next
      SortSprintList()\Mode = Mode
      SortSprintList()\Chrono = Chrono
      If CountList(SortSprintList()) > 19
          LastElement(SortSprintList())
          DeleteElement(SortSprintList())
      EndIf
  EndIf
  SaveSort()
EndProcedure

Procedure StorePosition()
  iPos = %1000000000000000
  iShape = Shape(Component,Rotation)
  For y=0 To 3
    For x=0 To 3
      If (iShape & iPos) > 0
          GameArray(ComponentX+x,ComponentY+y) = Component
      EndIf
      iPos >> 1
    Next
  Next
  PlayNoteMIDI(0,64,127,127)
  NbLine = 0
  For y=0 To 16
    Line = 0
    For x=0 To 9
      If GameArray(x,y) > 0
          Line + 1
      EndIf
    Next
    If Line = 10
        For xx=0 To 9
          For yy=y To 1 Step -1
            GameArray(xx,yy) = GameArray(xx,yy-1)
          Next
          GameArray(xx,0) = 0
        Next
        DisplaySprite(#Game,0,0)
        DisplayGame()
        FlipBuffers()
        NbLine + 1
        Points + 5 + NbLine*5
        Affiche_Chrono_Points()
        PlayNoteMIDI(1,64,127,127)
        If Points >= 500 And Mode = 0
            GamesEnd()
            ProcedureReturn
        EndIf
        If Points >= 5000 And Mode = 1
            GamesEnd()
            ProcedureReturn
        EndIf
        Delay(100)
    EndIf
  Next
  Component = FuturComponent
  x = Random(6)+1
  While x = FuturComponent
    x = Random(6)+1
  Wend
  FuturComponent = x
  Rotation = 1
  ComponentX = 5
  ComponentY = 0
  If Collision(ComponentX,ComponentY) > 0
      NewGame = 0
      PlayNoteMIDI(1,80,127,127)
      DisplaySprite(#Game,0,0)
      DisplayGame()
      DisplayTransparentSprite(#Loose,20,200)
      FlipBuffers()
    Else
      DisplayComponent()
      AfficheFuturComponent()
  EndIf
EndProcedure

Procedure LanceNewGame()
  Component = Random(6)+1
  x = Random(6)+1
  While x = Component
    x = Random(6)+1
  Wend
  FuturComponent = x
  Rotation = 1
  ComponentX = 4
  ComponentY = 0
  Points = 0
  Chrono = 0
  For y=0 To 16
    For x=0 To 9
      GameArray(x,y) = 0
    Next
  Next
  StopChrono = StartChrono
  Affiche_Chrono_Points()
  For T=4 To 0 Step -1
    PlayNoteMIDI(1,64,127,127)
    DisplaySprite(#Game,0,0)
    DisplayTransparentSprite(#Countdown+T,80,120)
    FlipBuffers()
    Delay(1000)
  Next
  PlayNoteMIDI(2,64,127,127)
  Delay(200)
  PlayNoteMIDI(2,69,127,127)
  Delay(200)
  DisplaySprite(#Game,0,0)
  DisplayComponent()
  FlipBuffers()
  StartChrono = GetTickCount_()
  AfficheFuturComponent()
  NewGame = 1
EndProcedure

Procedure mycallback(WindowID, Message, lParam, wParam)
  result = #PB_ProcessPureBasicEvents
  Select Message
    Case #WM_PAINT ; Window background design
      hRgnTitre = CreateRoundRectRgn_(0,0,#WindowWidth,50,50,50)
      hRgn = CreateRoundRectRgn_(20,0,#WindowWidth-20,#WindowHeight,50,50)
      CombineRgn_(hRgn, hRgn, hRgnTitre, #RGN_OR)
      Hdc = GetDC_(hWnd)
      ; first image design
      hSrcDC = CreateCompatibleDC_(Hdc)
      hBmpSrc = CreateCompatibleBitmap_(Hdc,#WindowWidth,#WindowHeight)
      SelectObject_(hSrcDC,hBmpSrc)
      BKGame_DC = StartDrawing(ImageOutput(#BkGame))
        BitBlt_(hSrcDC,0,0,#WindowWidth,#WindowHeight,BKGame_DC,0,0,#SRCCOPY)
      StopDrawing()
      ; second image design
      hDestDC = CreateCompatibleDC_(Hdc)
      hBmpDest = CreateCompatibleBitmap_(Hdc,#WindowWidth,#WindowHeight)
      SelectObject_(hDestDC,hBmpDest)
      brush = CreateSolidBrush_($FFFFFF)
      SelectObject_(hDestDC,brush)
      pen = CreatePen_(0,4,RGB(0,0,0))
      SelectObject_(hDestDC,pen)
      RoundRect_(hDestDC,21,1,#WindowWidth-21,#WindowHeight-1,48,48)
      RoundRect_(hDestDC,1,1,#WindowWidth-1,48,48,48)
      ; images synthesis
      BitBlt_(hDestDC,0,0,#WindowWidth,#WindowHeight,hSrcDC,0,0,#SRCAND)
      ; set background
      hBrush = CreatePatternBrush_(hBmpDest)
      SetClassLong_(hWnd,#GCL_HBRBACKGROUND, hBrush)
      InvalidateRect_(hWnd,#Null, #True)
      SetWindowRgn_(hWnd, hRgn, #True)
      DeleteObject_(hRgn)
      DeleteObject_(hRgnTitre)
      DeleteObject_(hSrcDC)
      DeleteObject_(hDestDC)
      DeleteObject_(hBmpSrc)
      DeleteObject_(hBmpDest)
      DeleteObject_(pen)
      DeleteObject_(brush)
      DeleteObject_(hBrush)
      ReleaseDC_(hWnd,Hdc)
      DeleteDC_(Hdc)
      DisplaySprite(#Game,0,0)
      DisplayGame()
      If NewGame
          DisplayComponent()
      EndIf
      FlipBuffers()
      DisplaySort()
      Affiche_Chrono_Points()
  EndSelect
  ProcedureReturn result
EndProcedure

  ; Start of main program
  If InitSprite() = 0
      End
  EndIf
  SystemPath.s=Space(255)
  GetSystemDirectory_(SystemPath,255)
  hWnd = OpenWindow(#Window, 0, 0, #WindowWidth, #WindowHeight, "SpeedTetris", #PB_Window_BorderLess | #PB_Window_ScreenCentered)
  SendMessage_(hWnd,#WM_SETICON,#False,ExtractIcon_(0,SystemPath+"\shell32.dll",130));      affecte un icon au programme
  OpenWindowedScreen(hWnd, 200,55,320,535,0,0,0)
  Timer = SetTimer_(hWnd, 0, 1000, 0)
  LoadSort()
  MIDIOpen()
  ChargeInstrument(0,13)
  ChargeInstrument(1,14)
  ChargeInstrument(2,55)
  ; High score image
  CreateImage(#Sort, 220, 500)
  font1 = LoadFont(0,"Comic Sans MS",18,#PB_Font_Bold)
  StartDrawing(ImageOutput(#Sort))
  For y=0 To 500 Step 2
    For x=0 To 220
      c = 150 + Random(30)
      Plot(x,y,RGB(c,c,c))
    Next
    For x=0 To 220
      c = 120 + Random(30)
      Plot(x,y+1,RGB(c,c,c+30))
    Next
  Next
  DrawingMode(1)
  DrawingFont(font1)
  FrontColor(RGB(50,50,50))
  DrawText(27,12,"High scores")
  FrontColor(RGB(250,250,250))
  DrawText(25,10,"High scores")
  PlaqueMetal(0,0,220,500)
  PlaqueMetal(15,10,190,40)
  PlaqueMetal(15,460,190,30)
  StopDrawing();}
  ; Points and stopwatch image
  CreateImage(#Chrono, 150, 200)
  font1 = LoadFont(0,"Comic Sans MS",12)
  StartDrawing(ImageOutput(#Chrono))
  For y=0 To 200 Step 2
    For x=0 To 150
      c = 150 + Random(30)
      Plot(x,y,RGB(c,c,c))
    Next
    For x=0 To 150
      c = 120 + Random(30)
      Plot(x,y+1,RGB(c,c,c+30))
    Next
  Next
  PlaqueMetal(0,0,150,200)
  PlaqueMetal(10,30,130,60)
  Box(20,40,110,40,RGB(100,160,100))
  Box3DI(20,40,110,40)
  PlaqueMetal(10,120,130,60)
  Box(20,130,110,40,RGB(100,160,100))
  Box3DI(20,130,110,40)
  DrawingMode(1)
  DrawingFont(font1)
  FrontColor(RGB(50,50,50))
  DrawText(52,7,"Chrono")
  DrawText(52,97,"Points")
  FrontColor(RGB(250,250,250))
  DrawText(50,5,"Chrono")
  DrawText(50,95,"Points")
  StopDrawing();}
  ; Main background image
  CreateImage(#BkGame,#WindowWidth,#WindowHeight)
  font1 = LoadFont(0,"Arial",24,#PB_Font_Bold)
  font2 = LoadFont(1,"Comic Sans MS",12)
  BKGame_DC = StartDrawing(ImageOutput(#BkGame))
  iCouleur.f = 150 / 45
  For y = 1 To 45
    Line(0,y,#WindowWidth,0,RGB(64,100 + iCouleur*y,64))
  Next
  For y=46 To #WindowHeight
    iCouleur.f = y * 150/#WindowHeight
    Line(0,y,800,0,RGB(80-iCouleur/2,80-iCouleur/2,160-iCouleur))
  Next
  For y=46 To #WindowHeight Step 10
    Line(0,y,#WindowWidth,0,RGB(0,0,0))
  Next
  For y=0 To #WindowWidth Step 10
    Line(y,46,0,#WindowHeight,RGB(0,0,0))
  Next
  DrawingMode(1)
  DrawingFont(font1)
  FrontColor(RGB(32,32,32))
  DrawText(275,5,"SPEED TETRIS") ; Title shadow display
  FrontColor(RGB(255,255,0))
  DrawText(270,0,"SPEED TETRIS") ; Title display
  DrawingFont(font2)
  FrontColor(RGB(150,150,250))
  DrawText(580,565,"Programme ERIX14")
  DrawImage(ImageID(#Chrono),35,210)
  DrawImage(ImageID(#Sort),540,60)
  StopDrawing();}
  ; Loose image
  CreateSprite(#Loose, 280, 80)
  font1 = LoadFont(0,"Comic Sans MS",64,#PB_Font_Bold)
  StartDrawing(SpriteOutput(#Loose))
  DrawingMode(1)
  DrawingFont(font1)
  FrontColor(RGB(32,32,32))
  ;Locate(-2,-27)
  DrawText(-2,-27,"Loose")
  ;Locate(2,-27)
  DrawText(2,-27,"Loose")
  ;Locate(-2,-23)
  DrawText(-2,-23,"Loose")
  ;Locate(2,-23)
  DrawText(2,-23,"Loose")
  FrontColor(RGB(255,255,255))
  ;Locate(0,-25)
  DrawText(0,-25,"Loose")
  *Ptr.LONG = DrawingBuffer()
  For y=0 To 79
    For x=0 To 279
      If *Ptr\l > $202020
          *Ptr\l = $FFFF00-y*$300
      EndIf
      *Ptr + 4
    Next
  Next
  StopDrawing();}
  ; Images 5 4 3 2 1
  For T = 0 To 4
    CreateSprite(#Countdown+T, 170, 256)
    font1 = LoadFont(0,"Comic Sans MS",200,#PB_Font_Bold)
    StartDrawing(SpriteOutput(#Countdown+T))
    DrawingMode(1)
    DrawingFont(font1)
    FrontColor(RGB(32,32,32))
    ;Locate(0,-77)
    DrawText(0, -77, Str(T+1))
    ;Locate(4,-77)
    DrawText(4, -77, Str(T+1))
    ;Locate(0,-73)
    DrawText(0, -73, Str(T+1))
    ;Locate(4,-73)
    DrawText(4, -73, Str(T+1))
    FrontColor(RGB(255,255,255))
    ;Locate(2,-75)
    DrawText(2,-75,Str(T+1))
    *Ptr.LONG = DrawingBuffer()
    For y=0 To 255
      For x=0 To 169
        If *Ptr\l > $202020
            *Ptr\l = $FFFF00-y*$100
        EndIf
        *Ptr + 4
      Next
    Next
    StopDrawing()
  Next;}
  GrabImage(#BkGame,#BkFuturComponent,80,450,80,80)
  ; Game's area design
  CreateSprite(#Game, 320, 535)
  Game_DC = StartDrawing(SpriteOutput(#Game))
  Box(0,0,320,535,$E0A0A0)
  DrawingMode(1)
  SetTextColor_(Game_DC,$F0B0B0)
  Font = CreateFont_(24,0,300,0,#FW_BOLD,0,0,0,0,0,0,0,0,"Arial")
  SelectObject_(Game_DC,Font)
  For y=0 To 720 Step 60
    ;Locate(0,y)
    DrawText(0, y, "SPEED TETRIS  SPEED TETRIS  SPEED")
    ;Locate(-30,y+48)
    DrawText(-30, y+48, "SPEED TETRIS  SPEED TETRIS  SPEED")
  Next
  Box3D(0,0,319,534)
  Box3D(1,1,317,532)
  DeleteObject_(Font)
  StopDrawing();}
  ; Components design
  ComponentImage(#ComponentGreen,0,160,0)
  ComponentImage(#ComponentRed,160,0,0)
  ComponentImage(#ComponentBlue,0,100,160)
  ComponentImage(#ComponentBrown,128,64,0)
  ComponentImage(#ComponentYellow,160,160,0)
  ComponentImage(#ComponentViolet,128,0,160)
  ComponentImage(#ComponentGray,64,64,64)
  ;}/
  CreateGadgetList(hWnd)
  ButtonImageGadget(#NewGame, 40, 70, 140, 20, ImageButton(#Image1,140,20,"New game"))
  ButtonImageGadget(#Rule, 40, 95, 140, 20, ImageButton(#Image2,140,20,"Game's rules"))
  ButtonImageGadget(#Mode, 40, 120, 140, 20, ImageButton(#Image3,140,20,"Game's mode"))
  ButtonImageGadget(#Cancel, 40, 145, 140, 20, ImageButton(#Image4,140,20,"Cancel Player's list"))
  ButtonImageGadget(#Quit, 40, 170, 140, 20, ImageButton(#Image5,140,20,"Quit"))
  SetWindowCallback(@mycallback())
  ; Main loop
  Repeat
    Select WaitWindowEvent()
      Case #PB_Event_Gadget ; Buttons management
        Select EventGadget()
          Case #NewGame
            LanceNewGame()
            Affiche_Chrono_Points()
          Case #Cancel
            If Mode
                ClearList(SortEnduranceList())
              Else
                ClearList(SortSprintList())
            EndIf
            SaveSort()
            SendMessage_(hWnd,#WM_PAINT,0,0)
          Case #Rule
            Text.s = "       Place squares to complete full lines."+Chr(13)
            Text + "Each full line disappear and gives points :"+Chr(13)
            Text + "     - one line       10 points"+Chr(13)
            Text + "     - two lines      25 points"+Chr(13)
            Text + "     - three lines   45 points"+Chr(13)
            Text + "     - four lines     70 points"+Chr(13)
            Text + "Sprint mode requires 500 points."+Chr(13)
            Text + "Endurance mode requires 5000 points."+Chr(13)
            Text + "Players having highest speed are stored in the players' list"+Chr(13)
            Text + "The goal is to go as fast as possible..."+Chr(13)
            Text + " - up arrow         : rotation"+Chr(13)
            Text + " - right arrow      : right shift"+Chr(13)
            Text + " - left arrow        : left shift"+Chr(13)
            Text + " - donw arrow     : fall"+Chr(13)
            If NewGame = 0
                MessageRequester("Game's rules",Text,#PB_MessageRequester_Ok)
            EndIf
          Case #Mode
            If Mode = 0 And NewGame = 0
                Mode =1
              Else
                Mode = 0
            EndIf
            DisplaySort()
          Case #Quit
            End
        EndSelect;}
      Case #WM_TIMER ; One second timer
        If NewGame
          If Collision(ComponentX,ComponentY+1)
              StorePosition()
            Else
              ComponentY + 1
              DisplayComponent()
          EndIf
          Affiche_Chrono_Points()
        EndIf;}
      Case #WM_KEYDOWN ; Keyboard inputs
          If NewGame
              Select EventwParam()
                Case 37
                  If Collision(ComponentX-1,ComponentY)=0
                      ComponentX - 1
                      DisplayComponent()
                  EndIf
                Case 39
                  If Collision(ComponentX+1,ComponentY)=0
                      ComponentX + 1
                      DisplayComponent()
                  EndIf
                Case 38
                  Rotation + 1
                  If Rotation > 4
                      Rotation = 1
                  EndIf
                  If Collision(ComponentX,ComponentY)
                      Rotation - 1
                      If Rotation < 1
                          Rotation = 4
                      EndIf
                    Else
                      DisplayComponent()
                  EndIf
                Case 40
                  While Collision(ComponentX,ComponentY+1) = 0
                    ComponentY + 1
                  Wend
                  StorePosition()
              EndSelect
          EndIf;}
      Case #WM_LBUTTONDOWN ; Window moves
        my.l = WindowMouseY(#Window)
        If my > 0 And my < 45
            SendMessage_(hWnd, #WM_NCLBUTTONDOWN, #HTCAPTION, NULL)
        EndIf;}
      Case #PB_Event_CloseWindow
        End
    EndSelect
  ForEver
End 
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ----
; DisableDebugger