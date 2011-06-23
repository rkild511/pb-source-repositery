; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13933&highlight=
; Author: Comtois (updated for PB 4.00 by Andre)
; Date: 06. February 2005
; OS: Windows
; Demo: Yes


;Comtois 05/02/05
;Détection d'un point dans un triangle

;-Initialisation
Declare Erreur(Message$)
Global ScreenWidth.l,ScreenHeight.l
If ExamineDesktops()
  ScreenWidth = DesktopWidth(0)
  ScreenHeight = DesktopHeight(0)
EndIf
If InitSprite() = 0 Or InitSound() = 0 Or InitMouse()=0 Or InitKeyboard()=0
  Erreur("Impossible d'initialiser DirectX 7 Ou plus")
ElseIf OpenWindow(0,0,0,ScreenWidth,ScreenHeight,"Collision point/triangle",#PB_Window_BorderLess) = 0
  Erreur("Impossible de créer la fenêtre")
ElseIf OpenWindowedScreen( WindowID(0), 0, 0, ScreenWidth , ScreenHeight, 0, 0, 0 ) = 0
  Erreur("Impossible d'ouvrir l'écran ")
EndIf

Structure Triangle
  X1.l
  Y1.l
  X2.l
  Y2.l
  X3.l
  Y3.l
EndStructure

Procedure Erreur(Message$)
  MessageRequester( "Erreur" , Message$ , 0 )
  End
EndProcedure

Procedure Signe(a.l)
  If a>0
    ProcedureReturn 1
  ElseIf a=0
    ProcedureReturn 0
  Else
    ProcedureReturn -1
  EndIf
EndProcedure


Procedure CollisionTriangle(*T.Triangle,*P.point)
  ;Test la collision du point avec le triangle
  ;pour en savoir plus  http://tanopah.jo.free.fr/seconde/region.html
  ;Plan 1
  xu1=*T\X2-*T\X1:yu1=*T\Y2-*T\Y1
  c1=*T\Y1*xu1-*T\X1*yu1
  P1=*T\X3*yu1-*T\Y3*xu1+c1
  AX1=*P\x*yu1-*P\y*xu1+c1
  ;Plan 2
  xu2=*T\X3-*T\X2:yu2=*T\Y3-*T\Y2
  c2=*T\Y2*xu2-*T\X2*yu2
  P2=*T\X1*yu2-*T\Y1*xu2+c2
  AX2=*P\x*yu2-*P\y*xu2+c2
  ;Plan 3
  xu3=*T\X1-*T\X3:yu3=*T\Y1-*T\Y3
  c3=*T\Y3*xu3-*T\X3*yu3
  P3=*T\X2*yu3-*T\Y2*xu3+c3
  AX3=*P\x*yu3-*P\y*xu3+c3

  If  Signe(AX1)=Signe(P1) And Signe(AX2)=Signe(P2) And Signe(AX3)=Signe(P3)
    Resultat=#True
  EndIf
  ProcedureReturn Resultat
EndProcedure

Procedure AffPoints(*T.Triangle,*P.point,mem)
  StartDrawing(ScreenOutput())
  ;/Affiche le triangle
  Circle(*T\X1,*T\Y1,4,RGB(255,0,0))
  Circle(*T\X2,*T\Y2,4,RGB(255,0,0))
  Circle(*T\X3,*T\Y3,4,RGB(255,0,0))
  LineXY(*T\X1,*T\Y1,*T\X2,*T\Y2,RGB(255,0,0))
  LineXY(*T\X2,*T\Y2,*T\X3,*T\Y3,RGB(255,0,0))
  LineXY(*T\X1,*T\Y1,*T\X3,*T\Y3,RGB(255,0,0))
  ;/Affiche le point
  If mem
    DrawingMode(4)
    Circle(*P\x,*P\y,6,RGB(255,255,255))
  Else
    DrawingMode(0)
    Circle(*P\x,*P\y,4,RGB(255,255,255))
  EndIf
  ;/Affiche une croix pour mieux suivre le déplacement du point
  LineXY(*P\x,0,*P\x,ScreenHeight-1,RGB(255,255,255))
  LineXY(0,*P\y,ScreenWidth-1,*P\y,RGB(255,255,255))
  If CollisionTriangle(*T,*P)
    FrontColor(RGB(255,255,0))
    BackColor(RGB(255,0,0))
    texte$="  IN "
  Else
    FrontColor(RGB(255,255,255))
    BackColor(RGB(0,255,0))
    texte$=" OUT "
  EndIf
  DrawText(0, 0, texte$)
  StopDrawing()
EndProcedure
Procedure TestPoint(X1,Y1,X2,Y2,d)
  If X1>X2-d And X1<X2+d And Y1>Y2-d And Y1<Y2+d
    Resultat=#True
  EndIf
  ProcedureReturn Resultat
EndProcedure

Triangle.Triangle
Point.point
;Triangle modifiable à la souris
Triangle\X1=50
Triangle\Y1=50
Triangle\X2=200
Triangle\Y2=400
Triangle\X3=730
Triangle\Y3=150
;Point à tester
Point\x=340
Point\y=100
DiametreSelection=6

Repeat
  While WindowEvent():Wend
  ClearScreen(RGB(0, 0, 0))
  ExamineKeyboard()
  ExamineMouse()
  Mx=WindowMouseX(0)
  My=WindowMouseY(0)
  ;Le triangle est modifiable à la souris en cliquant sur un point
  If MouseButton(1)
    If MemPoint=1
      Triangle\X1=Mx
      Triangle\Y1=My
    ElseIf MemPoint=2
      Triangle\X2=Mx
      Triangle\Y2=My
    ElseIf MemPoint=3
      Triangle\X3=Mx
      Triangle\Y3=My
    EndIf
  Else
    MemPoint=0
  EndIf
  If TestPoint(Mx,My,Triangle\X1,Triangle\Y1,DiametreSelection)
    MemPoint=1
  ElseIf TestPoint(Mx,My,Triangle\X2,Triangle\Y2,DiametreSelection)
    MemPoint=2
  ElseIf TestPoint(Mx,My,Triangle\X3,Triangle\Y3,DiametreSelection)
    MemPoint=3
  EndIf
  ;Place le point à tester sous la souris
  Point\x=Mx
  Point\y=My
  ;Affiche le tout
  AffPoints(@Triangle,@Point,MemPoint)
  FlipBuffers()
  Delay(1)
Until KeyboardPushed(#PB_Key_Escape)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger