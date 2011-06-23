; French forum: http://purebasic.hmt-forum.com/viewtopic.php?t=1567&sid=39aa32245ac870ecf2c0a6740bbb1984
; Author: Erix14 (updated for PB 4.00 by Andre)
; Date: 03. October 2004
; OS: Windows
; Demo: No

;/
;/                     Le Solitaire  - Programme Eric Ducoulombier ( Erix14 )
;/                         Windows XP SP2 - PureBasic 3.91 - jaPBe 2.4.9.25
;/                                                          03/10/2004
;/
#Longueur = 500
#Largeur = 500
#Window = 0
Global m_hMidiOut,m_MIDIOpen.b,hWnd,hBmp,DeplaceBille,PosX,PosY,AncienX,AncienY,NbCoup
Structure UnPoint
  Epaisseur.f
  NormalX.f
  NormalY.f
  NormalZ.f
EndStructure
Global Dim Buffet3D.UnPoint(#Longueur,#Largeur)
Global Dim PlateauBille.b(7,7)
Procedure SendMIDIMessage(nStatus.l,nCanal.l,nData1.l,nData2.l)
  dwFlags.l = nStatus | nCanal | (nData1 << 8) | (nData2 << 16)
  temp.l = midiOutShortMsg_(m_hMidiOut,dwFlags);
  If temp<>0
    MessageRequester("Problème", "Erreur dans l'envoi du message MIDI",0)
  EndIf
EndProcedure
Procedure MIDIOpen()
  If m_MIDIOpen = 0
    If midiOutOpen_(@m_hMidiOut,MIDIMAPPER,0,0,0) <> 0
      MessageRequester("Problème", "Impossible d'ouvrir le périphérique MIDI",0)
    Else
      SendMIDIMessage($C0,0,0,0)
      m_MIDIOpen = 1
    EndIf
  EndIf
EndProcedure
Procedure PlayNoteMIDI(Canal.b,Note.b,VelociteDown.b,VelociteUp.b)
  If m_MIDIOpen
    SendMIDIMessage($80 | Canal,0,Note,VelociteDown)
    SendMIDIMessage($90 | Canal,0,Note,VelociteUp)
  EndIf
EndProcedure
Procedure ChargeInstrument(Canal.b,Instrument.b)
  If m_MIDIOpen
    SendMIDIMessage($C0 | Canal,0,Instrument,0)
  EndIf
EndProcedure
Procedure EffaceBuffet3D()
  For y=0 To #Largeur-1
    For x=0 To #Longueur-1
      Buffet3D(x,y)\Epaisseur = 0
      Buffet3D(x,y)\NormalX = 0
      Buffet3D(x,y)\NormalY = 0
      Buffet3D(x,y)\NormalZ = 0
    Next
  Next
EndProcedure
Procedure RectangleArrondi3D(PositionX,PositionY,longueur,largeur,rayon,Epaisseur)
  Zone = rayon-Epaisseur
  For j = 0 To rayon : JJ = j + PositionY;          coin supérieur gauche
    For i = 0 To rayon : II = i + PositionX
      x = i - rayon : y = j - rayon : Distance.f = Sqr(x*x + y*y)
      If Distance <= rayon And Distance >= Zone
        D.l = Distance-Zone
        Buffet3D(II,JJ)\NormalX = (x*D)/(Epaisseur*Distance)
        Buffet3D(II,JJ)\NormalY = (y*D)/(Epaisseur*Distance)
        Buffet3D(II,JJ)\NormalZ = Sqr(Epaisseur*Epaisseur-D*D)/Epaisseur
        Buffet3D(II,JJ)\Epaisseur = Buffet3D(II,JJ)\NormalZ*Epaisseur
      ElseIf Distance < Zone
        Buffet3D(II,JJ)\Epaisseur = Epaisseur
        Buffet3D(II,JJ)\NormalX = 0
        Buffet3D(II,JJ)\NormalY = 0
        Buffet3D(II,JJ)\NormalZ = 1
      EndIf
    Next
  Next
  For j = rayon To rayon*2 : JJ = PositionY + j + largeur - 2*rayon;    coin inférieur droit
    For i = rayon To rayon*2 : II = PositionX + i + longueur - 2*rayon
      x = i - rayon : y = j - rayon : Distance.f = Sqr(x*x + y*y)
      If Distance <= rayon And Distance >= Zone
        D.l = Distance-Zone
        Buffet3D(II,JJ)\NormalX = (x*D)/(Epaisseur*Distance)
        Buffet3D(II,JJ)\NormalY = (y*D)/(Epaisseur*Distance)
        Buffet3D(II,JJ)\NormalZ = Sqr(Epaisseur*Epaisseur-D*D)/Epaisseur
        Buffet3D(II,JJ)\Epaisseur = Buffet3D(II,JJ)\NormalZ*Epaisseur
      ElseIf Distance < Zone
        Buffet3D(II,JJ)\Epaisseur = Epaisseur
        Buffet3D(II,JJ)\NormalX = 0
        Buffet3D(II,JJ)\NormalY = 0
        Buffet3D(II,JJ)\NormalZ = 1
      EndIf
    Next
  Next
  For j = 0 To rayon : JJ = PositionY + j;          coin supérieur droit
    For i = rayon To rayon*2 : II = PositionX + i + longueur - 2*rayon
      x = i - rayon : y = j - rayon : Distance.f = Sqr(x*x + y*y)
      If Distance <= rayon And Distance >= Zone
        D.l = Distance-Zone
        Buffet3D(II,JJ)\NormalX = (x*D)/(Epaisseur*Distance)
        Buffet3D(II,JJ)\NormalY = (y*D)/(Epaisseur*Distance)
        Buffet3D(II,JJ)\NormalZ = Sqr(Epaisseur*Epaisseur-D*D)/Epaisseur
        Buffet3D(II,JJ)\Epaisseur = Buffet3D(II,JJ)\NormalZ*Epaisseur
      ElseIf Distance < Zone
        Buffet3D(II,JJ)\Epaisseur = Epaisseur
        Buffet3D(II,JJ)\NormalX = 0
        Buffet3D(II,JJ)\NormalY = 0
        Buffet3D(II,JJ)\NormalZ = 1
      EndIf
    Next
  Next
  For j = rayon To rayon*2 : JJ = PositionY + j + largeur - 2*rayon;    coin inférieur gauche
    For i = 0 To rayon : II = PositionX + i
      x = i - rayon : y = j - rayon : Distance.f = Sqr(x*x + y*y)
      If Distance <= rayon And Distance >= Zone
        D.l = Distance-Zone
        Buffet3D(II,JJ)\NormalX = (x*D)/(Epaisseur*Distance)
        Buffet3D(II,JJ)\NormalY = (y*D)/(Epaisseur*Distance)
        Buffet3D(II,JJ)\NormalZ = Sqr(Epaisseur*Epaisseur-D*D)/Epaisseur
        Buffet3D(II,JJ)\Epaisseur = Buffet3D(II,JJ)\NormalZ*Epaisseur
      ElseIf Distance < Zone
        Buffet3D(II,JJ)\Epaisseur = Epaisseur
        Buffet3D(II,JJ)\NormalX = 0
        Buffet3D(II,JJ)\NormalY = 0
        Buffet3D(II,JJ)\NormalZ = 1
      EndIf
    Next
  Next
  RR = PositionY + rayon
  For y=rayon To largeur-rayon
    JJ = PositionY + y
    For x=0 To Epaisseur
      II = PositionX + x
      Buffet3D(II,JJ)\Epaisseur = Buffet3D(II,RR)\Epaisseur;    côté gauche
      Buffet3D(II,JJ)\NormalX = Buffet3D(II,RR)\NormalX
      Buffet3D(II,JJ)\NormalY = Buffet3D(II,RR)\NormalY
      Buffet3D(II,JJ)\NormalZ = Buffet3D(II,RR)\NormalZ
      x1 = II + longueur - Epaisseur
      Buffet3D(x1,JJ)\Epaisseur = Buffet3D(x1,RR)\Epaisseur;    côté droit
      Buffet3D(x1,JJ)\NormalX = Buffet3D(x1,RR)\NormalX
      Buffet3D(x1,JJ)\NormalY = Buffet3D(x1,RR)\NormalY
      Buffet3D(x1,JJ)\NormalZ = Buffet3D(x1,RR)\NormalZ
    Next
    For x=Epaisseur To longueur-Epaisseur;  centre
      II = PositionX + x
      Buffet3D(II,JJ)\Epaisseur = Epaisseur
      Buffet3D(II,JJ)\NormalX = 0
      Buffet3D(II,JJ)\NormalY = 0
      Buffet3D(II,JJ)\NormalZ = 1
    Next
  Next
  RR = PositionX + rayon
  For x=rayon To longueur-rayon
    II = PositionX + x
    For y=0 To Epaisseur
      JJ = PositionY + y
      Buffet3D(II,JJ)\Epaisseur = Buffet3D(RR,JJ)\Epaisseur;    côté supérieur
      Buffet3D(II,JJ)\NormalX = Buffet3D(RR,JJ)\NormalX
      Buffet3D(II,JJ)\NormalY = Buffet3D(RR,JJ)\NormalY
      Buffet3D(II,JJ)\NormalZ = Buffet3D(RR,JJ)\NormalZ
      y1 = JJ + largeur - Epaisseur
      Buffet3D(II,y1)\Epaisseur = Buffet3D(RR,y1)\Epaisseur;    côté inférieur
      Buffet3D(II,y1)\NormalX = Buffet3D(RR,y1)\NormalX
      Buffet3D(II,y1)\NormalY = Buffet3D(RR,y1)\NormalY
      Buffet3D(II,y1)\NormalZ = Buffet3D(RR,y1)\NormalZ
    Next
  Next
  For x=rayon To longueur-rayon
    II = PositionX + x
    For y=Epaisseur To rayon
      JJ = PositionY + y
      Buffet3D(II,JJ)\Epaisseur = Epaisseur; centre supérieur
      Buffet3D(II,JJ)\NormalX = 0
      Buffet3D(II,JJ)\NormalY = 0
      Buffet3D(II,JJ)\NormalZ = 1
    Next
    For y=largeur-rayon To largeur-Epaisseur
      JJ = PositionY + y
      Buffet3D(II,JJ)\Epaisseur = Epaisseur; centre inférieur
      Buffet3D(II,JJ)\NormalX = 0
      Buffet3D(II,JJ)\NormalY = 0
      Buffet3D(II,JJ)\NormalZ = 1
    Next
  Next
EndProcedure
Procedure CaviteArrondi3D(PositionX,PositionY,longueur,largeur,rayon,Epaisseur)
  Zone = rayon-Epaisseur
  For j = 0 To rayon : JJ = j + PositionY;          coin supérieur gauche
    For i = 0 To rayon : II = i + PositionX
      x = i - rayon : y = j - rayon : Distance.f = Sqr(x*x + y*y)
      If Distance <= rayon And Distance > Zone
        D.l = rayon-Distance
        Buffet3D(II,JJ)\NormalX = -(x*D)/(Epaisseur*Distance)
        Buffet3D(II,JJ)\NormalY = -(y*D)/(Epaisseur*Distance)
        Buffet3D(II,JJ)\NormalZ = Sqr(Epaisseur*Epaisseur-D*D)/Epaisseur
        Buffet3D(II,JJ)\Epaisseur = Buffet3D(II,JJ)\NormalZ*Epaisseur
      EndIf
    Next
  Next
  For j = rayon To rayon*2 : JJ = PositionY + j + largeur - 2*rayon;    coin inférieur droit
    For i = rayon To rayon*2 : II = PositionX + i + longueur - 2*rayon
      x = i - rayon : y = j - rayon : Distance.f = Sqr(x*x + y*y)
      If Distance <= rayon And Distance > Zone
        D.l = rayon-Distance
        Buffet3D(II,JJ)\NormalX = -(x*D)/(Epaisseur*Distance)
        Buffet3D(II,JJ)\NormalY = -(y*D)/(Epaisseur*Distance)
        Buffet3D(II,JJ)\NormalZ = Sqr(Epaisseur*Epaisseur-D*D)/Epaisseur
        Buffet3D(II,JJ)\Epaisseur = Buffet3D(II,JJ)\NormalZ*Epaisseur
      EndIf
    Next
  Next
  For j = 0 To rayon : JJ = j + PositionY;          coin supérieur droit
    For i = rayon To rayon*2 : II = PositionX + i + longueur - 2*rayon
      x = i - rayon : y = j - rayon : Distance.f = Sqr(x*x + y*y)
      If Distance <= rayon And Distance > Zone
        D.l = rayon-Distance
        Buffet3D(II,JJ)\NormalX = -(x*D)/(Epaisseur*Distance)
        Buffet3D(II,JJ)\NormalY = -(y*D)/(Epaisseur*Distance)
        Buffet3D(II,JJ)\NormalZ = Sqr(Epaisseur*Epaisseur-D*D)/Epaisseur
        Buffet3D(II,JJ)\Epaisseur = Buffet3D(II,JJ)\NormalZ*Epaisseur
      EndIf
    Next
  Next
  For j = rayon To rayon*2 : JJ = PositionY + j + largeur - 2*rayon;    coin inférieur gauche
    For i = 0 To rayon : II = i + PositionX
      x = i - rayon : y = j - rayon : Distance.f = Sqr(x*x + y*y)
      If Distance <= rayon And Distance > Zone
        D.l = rayon-Distance
        Buffet3D(II,JJ)\NormalX = -(x*D)/(Epaisseur*Distance)
        Buffet3D(II,JJ)\NormalY = -(y*D)/(Epaisseur*Distance)
        Buffet3D(II,JJ)\NormalZ = Sqr(Epaisseur*Epaisseur-D*D)/Epaisseur
        Buffet3D(II,JJ)\Epaisseur = Buffet3D(II,JJ)\NormalZ*Epaisseur
      EndIf
    Next
  Next
  RR = PositionY + rayon
  For y=rayon To largeur-rayon : JJ = PositionY + y
    For x=0 To Epaisseur : II = PositionX + x
      Buffet3D(II,JJ)\Epaisseur = Buffet3D(II,RR)\Epaisseur;      côté gauche
      Buffet3D(II,JJ)\NormalX = Buffet3D(II,RR)\NormalX
      Buffet3D(II,JJ)\NormalY = Buffet3D(II,RR)\NormalY
      Buffet3D(II,JJ)\NormalZ = Buffet3D(II,RR)\NormalZ
      x1 = II + longueur - Epaisseur
      Buffet3D(x1,JJ)\Epaisseur = Buffet3D(x1,RR)\Epaisseur;      côté droit
      Buffet3D(x1,JJ)\NormalX = Buffet3D(x1,RR)\NormalX
      Buffet3D(x1,JJ)\NormalY = Buffet3D(x1,RR)\NormalY
      Buffet3D(x1,JJ)\NormalZ = Buffet3D(x1,RR)\NormalZ
    Next
  Next
  RR = PositionX + rayon
  For x=rayon To longueur-rayon : II = PositionX + x
    For y=0 To Epaisseur : JJ = PositionY + y
      Buffet3D(II,JJ)\Epaisseur = Buffet3D(RR,JJ)\Epaisseur;      côté supérieur
      Buffet3D(II,JJ)\NormalX = Buffet3D(RR,JJ)\NormalX
      Buffet3D(II,JJ)\NormalY = Buffet3D(RR,JJ)\NormalY
      Buffet3D(II,JJ)\NormalZ = Buffet3D(RR,JJ)\NormalZ
      y1 = JJ + largeur - Epaisseur
      Buffet3D(II,y1)\Epaisseur = Buffet3D(RR,y1)\Epaisseur;      côté inférieur
      Buffet3D(II,y1)\NormalX = Buffet3D(RR,y1)\NormalX
      Buffet3D(II,y1)\NormalY = Buffet3D(RR,y1)\NormalY
      Buffet3D(II,y1)\NormalZ = Buffet3D(RR,y1)\NormalZ
    Next
  Next
EndProcedure
Procedure Rendu3D(longueur,largeur,couleur)
  LR = Red(couleur) : LG = Green(couleur) : LB = Blue(couleur); Couleur du rendu
  LX.f = 0 : LY.f = 0 : LZ.f = 50; Position de la lampe ponctuel
  PR = 128 : PG = 128 : PB = 128; Lumière de la lampe ponctuel
  AR = 32 : AG = 32 : AB = 32; Lumière d'ambiance
  For y=0 To largeur
    For x=0 To longueur
      If Buffet3D(x,y)\Epaisseur = 0 : Continue : EndIf
      Distance.f = Sqr(Pow(x-LX,2)+Pow(y-LY,2)+Pow(Buffet3D(x,y)\Epaisseur-LZ,2))
      DirX.f = (x-LX)/Distance
      DirY.f = (y-LY)/Distance
      DirZ.f = (Buffet3D(x,y)\Epaisseur-LZ)/Distance
      K.f = -(Buffet3D(x,y)\NormalX*DirX + Buffet3D(x,y)\NormalY*DirY + Buffet3D(x,y)\NormalZ*DirZ)
      r = LR + AR + K*PR : If r > 255 : r = 255 : EndIf : If r < 0 : r = 0 : EndIf
      g = LG + AG + K*PG : If g > 255 : g = 255 : EndIf : If g < 0 : g = 0 : EndIf
      b = LB + AB + K*PB : If b > 255 : b = 255 : EndIf : If b < 0 : b = 0 : EndIf
      Plot(x,y,RGB(r,g,b))
    Next
  Next
EndProcedure
Procedure AffichePlateauBille()
  For y=0 To 6
    For x=0 To 6
      If PlateauBille(x,y) = 1 : DisplayTransparentSprite(2,50+x*60,50+y*60) : EndIf
    Next
  Next
  font = LoadFont(2,"Times New Roman",34,#PB_Font_Bold)
  StartDrawing(ScreenOutput())
  DrawingMode(1)
  DrawingFont(font)
  FrontColor(RGB(250,250,250))
  DrawText(368,363,RSet(Str(NbCoup),2,"0"))
  StopDrawing()
EndProcedure
Procedure NouvellePartie()
  DeplaceBille = #False : NbCoup = 0
  For x=0 To 6
    For y=0 To 6
      If PlateauBille(x,y)<>10 : PlateauBille(x,y)=1 : EndIf
    Next
  Next
  Cherche = #True
  While Cherche
    x = Random(6) : y = Random(6)
    If PlateauBille(x,y) = 1
      Cherche = #False
      PlateauBille(x,y) = 0
    EndIf
  Wend
  DisplaySprite(1,0,0)
  AffichePlateauBille()
  FlipBuffers()
  PlayNoteMIDI(0,54,127,127)
EndProcedure
Procedure mycallback(WindowID, Message, lParam, wParam)
  Result = #PB_ProcessPureBasicEvents
  Select Message
    Case #WM_PAINT
      hRgn = CreateRoundRectRgn_(1,1,#Longueur-1,#Largeur-1,300,300)
      hBrush = CreatePatternBrush_(hBmp)
      SetClassLong_(hWnd, #GCL_HBRBACKGROUND, hBrush)
      InvalidateRect_(hWnd, #Null, #True)
      SetWindowRgn_(hWnd, hRgn, #True)
      DeleteObject_(hRgn)
      DeleteObject_(hBrush)
      DisplaySprite(1,0,0)
      AffichePlateauBille()
      FlipBuffers()
  EndSelect
  ProcedureReturn Result
EndProcedure

;- Debut du programme
If InitSprite() = 0 : End : EndIf
hWnd = OpenWindow(#Window, 0, 0, #Longueur, #Largeur, "Le Solitaire", #PB_Window_BorderLess | #PB_Window_Invisible | #PB_Window_ScreenCentered)
OpenWindowedScreen(hWnd, 0,0,#Longueur,#Largeur,0,0,0)
MIDIOpen() : ChargeInstrument(0,9)

;{/ Image de fond
font1 = LoadFont(0,"Times New Roman",20,#PB_Font_Bold)
font2 = LoadFont(1,"Times New Roman",14)
hBmp = CreateSprite(1, #Longueur, #Largeur)
StartDrawing(SpriteOutput(1))
RectangleArrondi3D(0,0,#Longueur-1,#Largeur-1,150,40)
For t=0 To 6
  CaviteArrondi3D(160,40+t*60,60,60,30,10)
  CaviteArrondi3D(220,40+t*60,60,60,30,10)
  CaviteArrondi3D(280,40+t*60,60,60,30,10)
Next
For t=2 To 4
  CaviteArrondi3D(40,40+t*60,60,60,30,10)
  CaviteArrondi3D(100,40+t*60,60,60,30,10)
  CaviteArrondi3D(340,40+t*60,60,60,30,10)
  CaviteArrondi3D(400,40+t*60,60,60,30,10)
Next
CaviteArrondi3D(340,340,100,100,50,11)
CaviteArrondi3D(60,340,100,100,50,11)
Rendu3D(#Longueur-1,#Largeur-1,RGB(128,64,0))
EffaceBuffet3D()
RectangleArrondi3D(350,350,80,80,40,10)
RectangleArrondi3D(70,350,80,80,40,10)
Rendu3D(#Longueur-1,#Largeur-1,RGB(0,0,64))
DrawingMode(1)
DrawingFont(font1)
FrontColor(RGB(50,50,50))
DrawText(180,5,"Le Solitaire")
DrawingFont(font2)
FrontColor(RGB(250,250,250))
DrawText(88,380,"Erix14")
FrontColor(RGB(64,32,0))
DrawText(70,80,"[Espace]")
DrawText(70,100,"Nouvelle")
DrawText(70,120,"partie")
DrawText(360,80,"[Echap]")
DrawText(360,100,"Quitter")
StopDrawing();}
;{/ Image bille
CreateSprite(2,40,40)
StartDrawing(SpriteOutput(2))
EffaceBuffet3D()
RectangleArrondi3D(0,0,40,40,20,20)
Rendu3D(40,40,RGB(110,110,110))
StopDrawing();}
;{/ Image bille2
CreateSprite(4,40,40)
StartDrawing(SpriteOutput(4))
EffaceBuffet3D()
RectangleArrondi3D(0,0,40,40,20,20)
Rendu3D(40,40,RGB(50,150,50))
StopDrawing();}
PlateauBille(0,0) = 10 : PlateauBille(0,1) = 10 : PlateauBille(1,0) = 10 :PlateauBille(1,1) = 10
PlateauBille(0,5) = 10 : PlateauBille(0,6) = 10 : PlateauBille(1,5) = 10 :PlateauBille(1,6) = 10
PlateauBille(5,0) = 10 : PlateauBille(5,1) = 10 : PlateauBille(6,0) = 10 :PlateauBille(6,1) = 10
PlateauBille(5,5) = 10 : PlateauBille(5,6) = 10 : PlateauBille(6,5) = 10 :PlateauBille(6,6) = 10
SetWindowCallback(@mycallback())
HideWindow(#Window,0)
NouvellePartie()
Repeat
  Select WaitWindowEvent()
    Case #WM_MOUSEMOVE;{ Déplacement de la souris
      If DeplaceBille
        mx = WindowMouseX(#Window) : my = WindowMouseY(#Window)
        If mx<50 Or mx>450 Or my<50 Or my>450
          PlateauBille(PosX,PosY) = 1
          DisplaySprite(1,0,0)
          AffichePlateauBille()
          FlipBuffers()
          DeplaceBille = #False
        Else
          mx - 20 : my -20
          DisplaySprite(3,AncienX,AncienY)
          GrabSprite(3,mx,my,40,40)
          DisplayTransparentSprite(4,mx,my)
          AncienX = mx : AncienY = my
          FlipBuffers()
        EndIf
      EndIf;}
    Case #WM_LBUTTONDOWN;{
      mx = WindowMouseX(#Window) : my = WindowMouseY(#Window)
      If mx>50 And mx<450 And my>50 And my<450
        i = (mx-50)/60 : j = (my-50)/60
        If PlateauBille(i,j) = 1
          DeplaceBille = #True
          PlateauBille(i,j) = 0
          PosX = i : PosY = j
          UseBuffer(1)
          AncienX = 50+i*60 : AncienY = 50+j*60
          GrabSprite(3,AncienX,AncienY,40,40)
          UseBuffer(-1)
          DisplayTransparentSprite(4,AncienX,AncienY)
          FlipBuffers()
        EndIf
      Else
        SendMessage_(hWnd, #WM_NCLBUTTONDOWN, #HTCAPTION, #Null)
      EndIf;}
    Case #WM_LBUTTONUP;{
      mx = WindowMouseX(#Window) : my = WindowMouseY(#Window)
      If DeplaceBille : PlateauBille(PosX,PosY) = 1 : EndIf
      DeplaceBille = #False
      If mx>50 And mx<450 And my>50 And my<450
        i = (mx-50)/60 : j = (my-50)/60
        If PlateauBille(i,j) = 0
          If PosX-2 >= 0
            If i=PosX-2 And j=PosY And PlateauBille(PosX-1,PosY)=1
              PlateauBille(i,j) = 1
              PlateauBille(PosX-1,PosY) = 0
              PlateauBille(PosX,PosY) = 0
              PlayNoteMIDI(0,74,127,127) : NbCoup + 1
            EndIf
          EndIf
          If PosX+2 <= 6
            If i=PosX+2 And j=PosY And PlateauBille(PosX+1,PosY)=1
              PlateauBille(i,j) = 1
              PlateauBille(PosX+1,PosY) = 0
              PlateauBille(PosX,PosY) = 0
              PlayNoteMIDI(0,74,127,127) : NbCoup + 1
            EndIf
          EndIf
          If PosY-2 >= 0
            If i=PosX And j=PosY-2 And PlateauBille(PosX,PosY-1)=1
              PlateauBille(i,j) = 1
              PlateauBille(PosX,PosY-1) = 0
              PlateauBille(PosX,PosY) = 0
              PlayNoteMIDI(0,74,127,127) : NbCoup + 1
            EndIf
          EndIf
          If PosY+2 <= 6
            If i=PosX And j=PosY+2 And PlateauBille(PosX,PosY+1)=1
              PlateauBille(i,j) = 1
              PlateauBille(PosX,PosY+1) = 0
              PlateauBille(PosX,PosY) = 0
              PlayNoteMIDI(0,74,127,127) : NbCoup + 1
            EndIf
          EndIf
        EndIf
        DisplaySprite(1,0,0)
        AffichePlateauBille()
        FlipBuffers()
      EndIf;}
    Case #WM_KEYDOWN;{  Commandes clavier
      Key = EventwParam()
      If Key = 32 : NouvellePartie() : EndIf
      If Key = 27 : End : EndIf;}
  EndSelect
ForEver

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ---