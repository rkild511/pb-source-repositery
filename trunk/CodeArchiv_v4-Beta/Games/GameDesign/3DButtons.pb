; French forum: http://purebasic.hmt-forum.com/viewtopic.php?t=1567&sid=39aa32245ac870ecf2c0a6740bbb1984
; Author: Erix14 (updated for PB 4.00 by Andre)
; Date: 03. October 2004
; OS: Windows
; Demo: No

;/
;/                     RectangleArrondi3D  - Programme Eric Ducoulombier ( Erix14 )
;/                             Windows XP SP2 - PureBasic 3.91 - jaPBe 2.4.9.25
;/                                                          02/10/2004
;/
#Longueur = 500
#Largeur = 500
#Window = 0
Global hWnd
Structure UnPoint
  Epaisseur.f
  NormalX.f
  NormalY.f
  NormalZ.f
EndStructure
Global Dim Buffet3D.UnPoint(#Longueur,#Largeur)

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

Procedure mycallback(WindowID, Message, lParam, wParam)
  Result = #PB_ProcessPureBasicEvents
  Select Message
    Case #WM_PAINT
      hRgn = CreateRoundRectRgn_(1,1,#Longueur-1,#Largeur-1,200,200)
      SetWindowRgn_(hWnd, hRgn, #True)
      DeleteObject_(hRgn)
  EndSelect
  ProcedureReturn Result
EndProcedure

;- Debut du programme
hWnd = OpenWindow(#Window, 0, 0, #Longueur, #Largeur, "RectangleArrondi3D", #PB_Window_BorderLess | #PB_Window_Invisible | #PB_Window_ScreenCentered)
CreateGadgetList(WindowID(#Window))
;{/ Image de fond
CreateImage(0, #Longueur, #Largeur)
StartDrawing(ImageOutput(0))
RectangleArrondi3D(0,0,#Longueur-1,#Largeur-1,100,20)
CaviteArrondi3D(80,80,320,60,30,10)
RectangleArrondi3D(90,90,300,40,20,10)
CaviteArrondi3D(80,150,320,60,30,10)
RectangleArrondi3D(90,160,300,40,20,10)
CaviteArrondi3D(100,300,84,84,42,12)
CaviteArrondi3D(200,300,84,84,42,12)
CaviteArrondi3D(300,300,84,84,42,12)
CaviteArrondi3D(90,400,320,60,30,10)
Rendu3D(#Longueur-1,#Largeur-1,RGB(128,128,0))

EffaceBuffet3D()
RectangleArrondi3D(111,311,62,62,31,10)
Rendu3D(#Longueur-1,#Largeur-1,RGB(0,0,128))

EffaceBuffet3D()
RectangleArrondi3D(211,311,62,62,31,10)
Rendu3D(#Longueur-1,#Largeur-1,RGB(128,128,128))

EffaceBuffet3D()
RectangleArrondi3D(311,311,62,62,31,10)
Rendu3D(#Longueur-1,#Largeur-1,RGB(128,0,0))

EffaceBuffet3D()
RectangleArrondi3D(90,230,300,40,20,10)
Rendu3D(#Longueur-1,#Largeur-1,RGB(128,128,32))

DrawingMode(1)
DrawingFont(LoadFont(0,"Times New Roman",24))
FrontColor(RGB(50,50,50))
DrawText(110, 92, "RectangleArrondi3D")
DrawText(130, 162, "CaviteArrondi3D")
DrawingFont(LoadFont(0,"Times New Roman",20,#PB_Font_Bold))
DrawText(115, 230, "[Echap] pour quitter")
DrawText(130, 412, "Programme Erix14")
StopDrawing();}
ImageGadget(0, 0, 0, 0, 0, ImageID(0))
SetWindowCallback(@mycallback())
HideWindow(#Window,0)
Repeat
  Select WaitWindowEvent()
    Case #WM_LBUTTONDOWN;{ Déplacement de la fenêtre
      SendMessage_(hWnd, #WM_NCLBUTTONDOWN, #HTCAPTION, #Null);}
    Case #WM_KEYDOWN;{  Commande clavier
      Key = EventwParam()
      If Key = 27 : End : EndIf;}
  EndSelect
ForEver

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; DisableDebugger