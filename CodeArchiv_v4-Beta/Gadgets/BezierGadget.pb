; http://www.freesoundeditor.com/downloads/sources/beziergadget.pb
; Author: ZapMan (updated for PB 4.00 by Andre)
; Date: 14. November 2004
; OS: Windows
; Demo: No

; Bezier Gadget 
; By Zapman  
;
; Développé avec PureBasic 3.90
;
; Pas de bibliothcque nécessaire
;
; Comme son nom le laisse supposer, Bezier Gadget permet de créer
; et de gérer un "simili" gadget de type "courbe de Bezier".
;
; Le calcul de la courbe est basé sur une procédure absolument somptueuse
; signée Rob (du Robsite). Les matheux apprécieront sans doute.

#WM_MOUSEWHEEL=522 

#PaleYellow=255+ (250*256) + (220*256*256) 
#PaleBlue  =220+ (255*256) + (255*256*256) 
#Violet    =240 + (30*256) + (170*256*256) 
;
#MaxBPoints = 100 
; 
Structure BezierPoint 
  x.l 
  y.l 
  t1x.l 
  t1y.l 
  t2x.l 
  t2y.l 
EndStructure 
; 
Dim DBPoints.BezierPoint(#MaxBPoints) 
; 
Structure BezierArea 
  RefNumber.l 
  leftP.l 
  topP.l 
  RightP.l 
  BottomP.l 
  BPoints.BezierPoint[#MaxBPoints] 
  UndoL1Points.BezierPoint[#MaxBPoints]
  UndoL2Points.BezierPoint[#MaxBPoints]
  UndoLevel.l
  SelectedPoint.l 
  OutOfAreaCursor.l 
  InsideAreaCursor.l 
  MoveCursor.l 
  Image.l 
  SDrawing.l 
  BezierCallBack.l 
  TimeType.l 
  OnPoint.l 
  OnLTangeante.l 
  OnRTangeante.l 
  SymTangeante.l 
  ForgetBS.l 
EndStructure 

Declare AddBezierPoint (*Area.BezierArea,x,y,t1x,t1y,t2x,t2y) 
Declare BezierGadget (NRef,*Area.BezierArea,vleft,vtop,vright,vbottom,TimeType,BezierCallBack) 
Declare RedrawBezier (*Area.BezierArea) 
Declare BezierCurve(x1,y1,x2,y2,x3,y3,x4,y4,DWide,color) 
Declare ManageBezierEvents (*Area.BezierArea,WE) 
Declare DestroyBezierGadget (*Area.BezierArea) 

; 
Procedure BezierCallBack1 (*Area.BezierArea) 
  ; modifiez cette procédure si vous voulez dessinez un fond derricre votre courbe de Bezier 
  Box(0,0,*Area\RightP-*Area\LeftP,*Area\BottomP-*Area\TopP,#PaleYellow) 
  Line (0,((*Area\BottomP-*Area\TopP)/2),*Area\RightP-*Area\LeftP,0,#Violet) 
EndProcedure 
; 
; 
Procedure BezierCallBack2 (*Area.BezierArea) 
  ; modifiez cette procédure si vous voulez dessinez un fond derricre votre courbe de Bezier 
  Box(0,0,*Area\RightP-*Area\LeftP,*Area\BottomP-*Area\TopP,#PaleBlue) 
  Circle(150,100,30,#PaleYellow) 
  Circle(350,130,30,255) 
EndProcedure 

#NoWindow = 1 
hwd = OpenWindow(#NoWindow, 0, 0, 510, 510, "BezierGadget Demo", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar| #PB_Window_TitleBar | #PB_Window_ScreenCentered) 
If hwd 
  If CreateGadgetList(WindowID(#NoWindow)) 
    ;- Gadget Constants 
    
    #WDrawing = 479 
    #HDrawing = 188 
    
    #THelp      = 2 
    #BSaw       = 3 
    #BSinus     = 4 
    #BRTime     = 5 
    #BRNormal   = 6 
    #TTitle1    = 7 
    #TTitle2    = 8 
    
    #Bezier1     = 10 
    #Bezier2     = 11 
    ; 


    ButtonGadget(#BSaw     ,  13, 225, 70, 20, "Saw") 
    ButtonGadget(#BSinus   ,  13, 250, 70, 20, "Sinus") 
    OptionGadget(#BRTime   , 183, 225, 70, 20, "Time") 
    OptionGadget(#BRNormal , 280, 225, 70, 20, "Normal") 
    SetGadgetState (#BRTime,1) 
    TimeOrNormal = 1 

    BezierGadget (#Bezier1,BezierArea1.BezierArea,13,27,#WDrawing+13,#HDrawing+27,TimeOrNormal,@BezierCallBack1()) 
    tx.s= "Bouton droit : crée/modifie les tangeantes - Roue de souris : défilement" 
    tx + Chr(13)+ "Appuyez sur majuscule pour avoir des tangeantes symétriques." 
    tx + Chr(13)+ "Déplacez le point sélectionné avec les touches 'flcche'." 
    tx + Chr(13)+ "<- (backspace) supprime le point sélectionné." 
    TextGadget(#THelp, 83, #HDrawing+55, #WDrawing, 60, tx, #PB_Text_Center) 
    TextGadget(#TTitle1, 13, 5, 80, 20, "Time/Normal") 
    TextGadget(#TTitle2, 13, 290, 80, 20, "Normal") 
    
    AddBezierPoint (BezierArea1,0,-#HDrawing*1/4,-#WDrawing*1/4,0,#WDrawing*1/4,0) 
    AddBezierPoint (BezierArea1,#WDrawing/2,#HDrawing*1/4,-#WDrawing*1/4,0,#WDrawing*1/4,0) 

    RedrawBezier(BezierArea1) 
    
    BezierGadget (#Bezier2,BezierArea2.BezierArea,13,310,#WDrawing+13,#HDrawing+310,0,@BezierCallBack2()) 
    AddBezierPoint (BezierArea2,#WDrawing/2,-#HDrawing*1/4,-#WDrawing*1/4,0,#WDrawing*1/4,0) 
    AddBezierPoint (BezierArea2,#WDrawing/2-150,#HDrawing*1/4,-#WDrawing*1/4,0,#WDrawing*1/4,0) 
    AddBezierPoint (BezierArea2,#WDrawing/2+150,-#HDrawing*1/4,0,0,0,0) 
    AddBezierPoint (BezierArea2,#WDrawing/2+150,#HDrawing*1/4,0,0,0,0) 
    RedrawBezier(BezierArea2) 

    ; 
    QuitWSynthetiser = 0 
    cont = 0 

    Repeat 
      Delay(10) 
      WE = WindowEvent() 
      If EventWindow()<>#NoWindow 
        WE = 0 
      Else 
        ManageBezierEvents (BezierArea1,WE) 
        ManageBezierEvents (BezierArea2,WE) 
      EndIf 

      If WE = #PB_Event_CloseWindow 
        Quit = 1 
      EndIf 
      If WE = #PB_Event_Gadget 
                
        Select EventGadget() 

          Case #BSinus 
            BHigh = BezierArea1\BottomP-BezierArea1\TopP 
            BWide = BezierArea1\RightP -BezierArea1\LeftP 
            BezierArea1\BPoints[1]\x=-1 
            AddBezierPoint (BezierArea1,0,-BHigh *1/4,-BWide*1/4,0,BWide*1/4,0) 
            AddBezierPoint (BezierArea1,BWide/2,BHigh *1/4,-BWide*1/4,0,BWide*1/4,0) 
            RedrawBezier (BezierArea1) 
          Case #BSaw 
            BHigh = BezierArea1\BottomP-BezierArea1\TopP 
            BWide = BezierArea1\RightP -BezierArea1\LeftP 
            BezierArea1\BPoints[1]\x=-1 
            AddBezierPoint (BezierArea1,BWide/2,-BHigh *1/4,0,0,0,0) 
            AddBezierPoint (BezierArea1,BWide/2+1,BHigh *1/4,0,0,0,0) 
            RedrawBezier (BezierArea1) 
          Case #BRTime 
            TimeOrNormal = 1 
            DestroyBezierGadget (BezierArea1) 
            BezierGadget (#Bezier1,BezierArea1,13,27,#WDrawing+13,#HDrawing+27,TimeOrNormal,@BezierCallBack1()) 

            AddBezierPoint (BezierArea1,0,-#HDrawing*1/4,-#WDrawing*1/4,0,#WDrawing*1/4,0) 
            AddBezierPoint (BezierArea1,#WDrawing/2,#HDrawing*1/4,-#WDrawing*1/4,0,#WDrawing*1/4,0) 
            RedrawBezier (BezierArea1) 
          Case #BRNormal 
            TimeOrNormal = 0 
            DestroyBezierGadget (BezierArea1) 
            BezierGadget (#Bezier1,BezierArea1,13,27,#WDrawing+13,#HDrawing+27,TimeOrNormal,@BezierCallBack2()) 

            AddBezierPoint (BezierArea1,#WDrawing/2,-#HDrawing*1/4,-#WDrawing*1/4,0,#WDrawing*1/4,0) 
            AddBezierPoint (BezierArea1,#WDrawing/2,#HDrawing*1/4,-#WDrawing*1/4,0,#WDrawing*1/4,0) 
            RedrawBezier (BezierArea1) 
        EndSelect 
      EndIf 

    Until Quit 

    CloseWindow(#NoWindow) 
  EndIf 
EndIf 




Procedure AddBezierPoint (*Area.BezierArea,x,y,t1x,t1y,t2x,t2y) 
  ct = 1 
  While *Area\BPoints[ct]\x<>-1 And ct<#MaxBPoints 
    ct + 1 
  Wend 
  If *Area\BPoints[ct]\x=-1 
    *Area\BPoints[ct]\x=x 
    *Area\BPoints[ct]\y=y 
    *Area\BPoints[ct]\t1x=t1x 
    *Area\BPoints[ct]\t1y=t1y 
    *Area\BPoints[ct]\t2x=t2x 
    *Area\BPoints[ct]\t2y=t2y 
    If ct<#MaxBPoints 
      *Area\BPoints[ct+1]\x=-1 
    EndIf 
    *Area\SelectedPoint = x 
    result = 1 
  Else 
    result = 0 
  EndIf 
  ProcedureReturn result 
EndProcedure 
; 
Procedure BezierGadget (NRef,*Area.BezierArea,vleft,vtop,vright,vbottom,TimeType,BezierCallBack) 
  *Area\RefNumber = NRef 
  *Area\LeftP = vleft 
  *Area\topP    = vtop 
  *Area\RightP  = vright 
  *Area\BottomP = vbottom 
  *Area\BPoints[1]\x=-1 
  *Area\SelectedPoint=-1 
  *Area\OutOfAreaCursor=LoadCursor_(0, #IDC_ARROW) 
  *Area\InsideAreaCursor=LoadCursor_(0, #IDC_CROSS) 
  *Area\MoveCursor=LoadCursor_(0, #IDC_SIZEALL) 
  *Area\Image = CreateImage(NRef,vright-vleft,vbottom-vtop) 
  *Area\SDrawing = ImageGadget(NRef, vleft, vtop, vright-vleft, vbottom-vtop,*Area\Image, #PB_Image_Border) 
  *Area\BezierCallBack=BezierCallBack 
  *Area\TimeType = TimeType 
  *Area\OnPoint = 0 
  *Area\OnLTangeante = 0 
  *Area\OnRTangeante = 0 
  *Area\SymTangeante = 0 
  *Area\ForgetBS = 0 
  #BViolet    =240 + (30*256) + (170*256*256)
  While GetAsyncKeyState_(#VK_LBUTTON) Or GetAsyncKeyState_(#VK_RBUTTON) : Wend
  ProcedureReturn 1 
EndProcedure 
; 
Procedure DestroyBezierGadget (*Area.BezierArea) 
  DestroyCursor_(*Area\OutOfAreaCursor) 
  DestroyCursor_(*Area\InsideAreaCursor) 
  DestroyCursor_(*Area\MoveCursor) 
  FreeGadget (NRef) 
EndProcedure 
; 
Procedure BezierCurve(x1,y1,x2,y2,x3,y3,x4,y4,DWide,color) 
  ; D'aprés une procédure de Rob, du Robsite German forum 
  ; From a procedure of Rob - Robsite German forum 
  i.f = 0 
  oldx=x1 
  oldy=y1 
  cx.f=3*x2 
  bx.f=3*(x4+x3-x2-x1)-cx 
  ax.f=x4-x1-cx-bx 
  cy.f=3*y2 
  by.f=3*(y4+y3-y2-y1)-cy 
  ay.f=y4-y1-cy-by 
  While i.f < 1 
    i+0.05 
    x=((ax*i+bx)*i+cx)*i+x1 
    y=((ay*i+by)*i+cy)*i+y1 
    If i>0 
      If x>DWide 
        If oldx<DWide 
          LineXY(oldx,oldy,x,y,color) 
        EndIf 
        xb=x-DWide 
        oldxb=oldx-DWide 
      Else 
        xb=x 
        oldxb=oldx 
      EndIf 
      yb=y 
      oldyb=oldy 
      If xb<0 
        xb=0 
      EndIf 
      If oldxb<0 
        If x<>oldx 
          ps=oldxb*(y-oldy)/(x-oldx) 
          oldyb=oldyb-ps 
        Else 
          oldyb=yb 
        EndIf 
        oldxb=0 
      EndIf 
      LineXY(oldxb,oldyb,xb,yb,color) 
    EndIf  
    oldx=x 
    oldy=y 
  Wend 
EndProcedure 
; 
Procedure RedrawBezier (*Area.BezierArea) 
  change = *Area\TimeType 
  While change                ; Sort the array - Trie le tableau 
    change = 0 
    For ct=1 To #MaxBPoints-1 
      If *Area\BPoints[ct+1]\x=-1 Or *Area\BPoints[ct]\x=-1 
        If *Area\BPoints[ct]\x=-1 : ctend = ct : Else : ctend = ct+1 : EndIf 
        ct=#MaxBPoints 
      Else 
        If *Area\BPoints[ct+1]\x<*Area\BPoints[ct]\x 
          change = 1 
          mempoint.BezierPoint\x=*Area\BPoints[ct]\x 
          mempoint\y  =*Area\BPoints[ct]\y 
          mempoint\t1x=*Area\BPoints[ct]\t1x 
          mempoint\t1y=*Area\BPoints[ct]\t1y 
          mempoint\t2x=*Area\BPoints[ct]\t2x 
          mempoint\t2y=*Area\BPoints[ct]\t2y 
          *Area\BPoints[ct]\x  = *Area\BPoints[ct+1]\x 
          *Area\BPoints[ct]\y  = *Area\BPoints[ct+1]\y 
          *Area\BPoints[ct]\t1x= *Area\BPoints[ct+1]\t1x 
          *Area\BPoints[ct]\t1y= *Area\BPoints[ct+1]\t1y 
          *Area\BPoints[ct]\t2x= *Area\BPoints[ct+1]\t2x 
          *Area\BPoints[ct]\t2y= *Area\BPoints[ct+1]\t2y 
          *Area\BPoints[ct+1]\x  = mempoint\x 
          *Area\BPoints[ct+1]\y  = mempoint\y 
          *Area\BPoints[ct+1]\t1x= mempoint\t1x 
          *Area\BPoints[ct+1]\t1y= mempoint\t1y 
          *Area\BPoints[ct+1]\t2x= mempoint\t2x 
          *Area\BPoints[ct+1]\t2y= mempoint\t2y 
          If *Area\SelectedPoint = ct 
            *Area\SelectedPoint = ct + 1 
            *Area\OnPoint = ct + 1 
            *Area\OnLTangeante = ct + 1 
            *Area\OnRTangeante = ct + 1 
          Else 
            If *Area\SelectedPoint = ct+1 
              *Area\SelectedPoint = ct 
              *Area\OnPoint = ct 
              *Area\OnLTangeante = ct 
              *Area\OnRTangeante = ct 
            EndIf 
          EndIf 
        EndIf 
      EndIf 
    Next 
  Wend 
  DWide = *Area\RightP-*Area\LeftP 
  DHigh = *Area\BottomP-*Area\TopP 
  If *Area\TimeType 
    For ct=1 To #MaxBPoints-1 ; limit tangeantes lenght 
      If *Area\BPoints[ct]\x<>-1 
        If ct>1 
          If *Area\BPoints[ct]\t1x+*Area\BPoints[ct]\x<*Area\BPoints[ct-1]\x 
            *Area\BPoints[ct]\t1x=*Area\BPoints[ct-1]\x-*Area\BPoints[ct]\x 
          EndIf 
        Else 
          If *Area\BPoints[1]\t1x+*Area\BPoints[1]\x<*Area\BPoints[ctend-1]\x-DWide 
            *Area\BPoints[1]\t1x=*Area\BPoints[ctend-1]\x-DWide -*Area\BPoints[1]\x 
          EndIf 
        EndIf 
        If *Area\BPoints[ct+1]\x<>-1 
          If *Area\BPoints[ct]\t2x+*Area\BPoints[ct]\x>*Area\BPoints[ct+1]\x 
            *Area\BPoints[ct]\t2x=*Area\BPoints[ct+1]\x-*Area\BPoints[ct]\x 
          EndIf 
        Else 
          If *Area\BPoints[ct]\t2x+*Area\BPoints[ct]\x>*Area\BPoints[1]\x+DWide 
            *Area\BPoints[ct]\t2x=*Area\BPoints[1]\x+DWide -*Area\BPoints[ct]\x 
          EndIf 
          ct=#MaxBPoints 
        EndIf 
      EndIf 
    Next 
  EndIf 
  StartDrawing(ImageOutput(*Area\RefNumber)) 
  If *Area\BezierCallBack 
    CallFunctionFast(*Area\BezierCallBack,*Area) 
  Else 
    Box(0,0,*Area\RightP-*Area\LeftP,*Area\BottomP-*Area\TopP,#White) 
  EndIf 
  For ct=1 To #MaxBPoints 
    If *Area\BPoints[ct]\x=-1 
      ctend=ct-1 
      ct=#MaxBPoints 
    Else 
      If ct=*Area\SelectedPoint 
        DrawingMode(0) 
      Else 
        DrawingMode(4) 
      EndIf 
      Box(*Area\BPoints[ct]\x-2,*Area\BPoints[ct]\y+(DHigh/2)-2,5,5,0) 
      If *Area\BPoints[ct]\t1x Or *Area\BPoints[ct]\t1y 
        DrawingMode(4) 
        Circle (*Area\BPoints[ct]\x+*Area\BPoints[ct]\t1x,*Area\BPoints[ct]\y+*Area\BPoints[ct]\t1y+(DHigh/2),3,#Red) 
        xt = *Area\BPoints[ct]\x+*Area\BPoints[ct]\t1x 
        yt = *Area\BPoints[ct]\y+*Area\BPoints[ct]\t1y+(DHigh/2) 
        If xt<0 
          ps=xt**Area\BPoints[ct]\t1y/(*Area\BPoints[ct]\x-xt) 
          yt=yt+ps 
          xt=0 
        EndIf 
        LineXY(*Area\BPoints[ct]\x,*Area\BPoints[ct]\y+(DHigh/2),xt,yt,#BViolet) 
      EndIf 
      If *Area\BPoints[ct]\t2x Or *Area\BPoints[ct]\t2y 
        DrawingMode(4) 
        Circle (*Area\BPoints[ct]\x+*Area\BPoints[ct]\t2x,*Area\BPoints[ct]\y+*Area\BPoints[ct]\t2y+(DHigh/2),3,#Red) 
        LineXY(*Area\BPoints[ct]\x,*Area\BPoints[ct]\y+(DHigh/2),*Area\BPoints[ct]\x+*Area\BPoints[ct]\t2x,*Area\BPoints[ct]\y+*Area\BPoints[ct]\t2y+(DHigh/2),#BViolet) 
      EndIf 
      If ct>1 
        BezierCurve(*Area\BPoints[ct-1]\x,*Area\BPoints[ct-1]\y+(DHigh/2),*Area\BPoints[ct-1]\t2x,*Area\BPoints[ct-1]\t2y,*Area\BPoints[ct]\t1x,*Area\BPoints[ct]\t1y,*Area\BPoints[ct]\x,*Area\BPoints[ct]\y+(DHigh/2),DWide,0) 
      EndIf 
    EndIf 
  Next 
  If ctend And *Area\TimeType 
    BezierCurve(*Area\BPoints[ctend]\x,*Area\BPoints[ctend]\y+(DHigh/2),*Area\BPoints[ctend]\t2x,*Area\BPoints[ctend]\t2y,*Area\BPoints[1]\t1x,*Area\BPoints[1]\t1y,*Area\BPoints[1]\x+DWide,*Area\BPoints[1]\y+(DHigh/2),DWide,0) 
  EndIf 
  StopDrawing() 
  SetGadgetState(*Area\RefNumber, ImageID(*Area\RefNumber)) 
EndProcedure 
; 
Procedure ManageBezierEvents (*Area.BezierArea,WE)
  If WE = #WM_LBUTTONDOWN Or WE = #WM_RBUTTONDOWN
    CopyMemory(@*Area\UndoL1Points[0],@*Area\UndoL2Points[0],SizeOf(BezierPoint)*#MaxBPoints)
    CopyMemory(@*Area\BPoints[0],@*Area\UndoL1Points[0],SizeOf(BezierPoint)*#MaxBPoints)
    *Area\UndoLevel + 1
  EndIf
  If WE = #WM_KEYDOWN
    If GetAsyncKeyState_(#VK_CONTROL) And GetAsyncKeyState_(#VK_Z) And *Area\UndoLevel
      CopyMemory(@*Area\UndoL1Points[0],@*Area\BPoints[0],SizeOf(BezierPoint)*#MaxBPoints)
      CopyMemory(@*Area\UndoL2Points[0],@*Area\UndoL1Points[0],SizeOf(BezierPoint)*#MaxBPoints)
      RedrawBezier (*Area)
      *Area\UndoLevel - 1
    EndIf
  EndIf
  GetCursorPos_(@MP.Point) 
  MP\x = MP\x-2 
  MP\y = MP\y-2 
  GetWindowRect_(*Area\SDrawing,@re.RECT) 
  BHigh = *Area\BottomP-*Area\TopP 
  BWide = *Area\RightP -*Area\LeftP 
  re\right  =re\left  + BWide 
  re\bottom =re\top   + BHigh 
  If PtInRect_(re,MP\x,MP\y) 
    MO = 1 
  Else 
    MO = 0 
  EndIf 
  MP\x = MP\x - re\left 
  MP\y = MP\y - re\top 
  If GetAsyncKeyState_(#VK_LBUTTON) Or GetAsyncKeyState_(#VK_RBUTTON) 
    If GetAsyncKeyState_(#VK_LBUTTON) And GetAsyncKeyState_(#VK_CONTROL)=0 
      LBUTTONDOWN = 1 
      RBUTTONDOWN = 0 
    Else 
      RBUTTONDOWN = 1 
    EndIf 
    If MO 
      *Area\ForgetBS = 0 
    Else 
      *Area\ForgetBS = 1 
    EndIf 
  Else 
    RBUTTONDOWN = 0 
    LBUTTONDOWN = 0 
    *Area\OnPoint = 0 
    *Area\OnLTangeante = 0 
    *Area\OnRTangeante = 0 
    *Area\SymTangeante = 0 
  EndIf 
  ; 
  mp\y=mp\y-(BHigh /2) 
  ; 
  If MO 
    NCurs = *Area\InsideAreaCursor 
    ct = 0 
    If *Area\OnPoint=0 And *Area\OnLTangeante=0 And *Area\OnRTangeante=0 
      While *Area\BPoints[ct]\x<>-1 And ct<#MaxBPoints 
        If Abs(mp\x-*Area\BPoints[ct]\x)<5 And Abs(mp\y-*Area\BPoints[ct]\y)<5 
          NCurs = *Area\MoveCursor 
          If LBUTTONDOWN 
            *Area\OnPoint = ct 
          ElseIf RBUTTONDOWN 
            *Area\OnLTangeante = ct ; will reset the both tangeantes to zero 
            *Area\OnRTangeante = ct 
          EndIf 
        EndIf 
        If Abs(mp\x-(*Area\BPoints[ct]\x+*Area\BPoints[ct]\t1x))<5 And Abs(mp\y-(*Area\BPoints[ct]\y+*Area\BPoints[ct]\t1y))<5 
          NCurs = *Area\MoveCursor 
          If LBUTTONDOWN Or RBUTTONDOWN 
            *Area\OnLTangeante = ct 
          EndIf 
        EndIf 
        If Abs(mp\x-(*Area\BPoints[ct]\x+*Area\BPoints[ct]\t2x))<5 And Abs(mp\y-(*Area\BPoints[ct]\y+*Area\BPoints[ct]\t2y))<5 
          NCurs = *Area\MoveCursor 
          If LBUTTONDOWN Or RBUTTONDOWN 
            *Area\OnRTangeante = ct 
          EndIf 
        EndIf 
        ct + 1 
      Wend 
    EndIf 
    If *Area\OnPoint Or *Area\OnLTangeante Or *Area\OnRTangeante 
      If *Area\OnLTangeante = *Area\OnRTangeante 
        *Area\SymTangeante = 1 
        If mp\x>*Area\BPoints[*Area\OnLTangeante]\x+*Area\BPoints[*Area\OnLTangeante]\t1x 
          *Area\OnLTangeante = 0 
        Else 
          *Area\OnRTangeante = 0 
        EndIf 
      EndIf 
      If *Area\TimeType 
        If *Area\OnLTangeante And mp\x>*Area\BPoints[*Area\OnLTangeante]\x 
          *Area\OnRTangeante = *Area\OnLTangeante 
          *Area\OnLTangeante = 0 
        EndIf 
        If *Area\OnRTangeante And mp\x<*Area\BPoints[*Area\OnRTangeante]\x 
          *Area\OnLTangeante = *Area\OnRTangeante 
          *Area\OnRTangeante = 0 
        EndIf 
      EndIf 
      If *Area\OnPoint 
        *Area\BPoints[*Area\OnPoint]\x=mp\x 
        *Area\BPoints[*Area\OnPoint]\y=mp\y 
        *Area\SelectedPoint = *Area\OnPoint 
        RedrawBezier (*Area) 
      ElseIf *Area\OnLTangeante 
        *Area\BPoints[*Area\OnLTangeante]\t1x=mp\x-*Area\BPoints[*Area\OnLTangeante]\x 
        *Area\BPoints[*Area\OnLTangeante]\t1y=mp\y-*Area\BPoints[*Area\OnLTangeante]\y 
        If *Area\SymTangeante Or GetAsyncKeyState_(#VK_SHIFT) 
          *Area\BPoints[*Area\OnLTangeante]\t2x=-*Area\BPoints[*Area\OnLTangeante]\t1x 
          *Area\BPoints[*Area\OnLTangeante]\t2y=-*Area\BPoints[*Area\OnLTangeante]\t1y 
        EndIf 
        *Area\SelectedPoint = OnLTangeante 
        RedrawBezier (*Area) 
      ElseIf *Area\OnRTangeante 
        *Area\BPoints[*Area\OnRTangeante ]\t2x=mp\x-*Area\BPoints[*Area\OnRTangeante ]\x 
        *Area\BPoints[*Area\OnRTangeante ]\t2y=mp\y-*Area\BPoints[*Area\OnRTangeante ]\y 
        If *Area\SymTangeante Or GetAsyncKeyState_(#VK_SHIFT) 
          *Area\BPoints[*Area\OnRTangeante]\t1x=-*Area\BPoints[*Area\OnRTangeante]\t2x 
          *Area\BPoints[*Area\OnRTangeante]\t1y=-*Area\BPoints[*Area\OnRTangeante]\t2y 
        EndIf 
        *Area\SelectedPoint = *Area\OnRTangeante 
        RedrawBezier (*Area) 
      EndIf 
    Else 
      If (LBUTTONDOWN Or RBUTTONDOWN) 
        ct = 0 
        While *Area\BPoints[ct]\x<>-1 And ct<#MaxBPoints : ct+1 : Wend 
        If *Area\BPoints[ct]\x=-1 
          NCurs = *Area\MoveCursor 
          *Area\BPoints[ct]\x=mp\x 
          *Area\BPoints[ct]\y=mp\y 
          *Area\BPoints[ct]\t1x=0 
          *Area\BPoints[ct]\t1y=0 
          *Area\BPoints[ct]\t2x=0 
          *Area\BPoints[ct]\t2y=0 
          *Area\SelectedPoint = ct 
          If LBUTTONDOWN 
            *Area\OnPoint = ct 
          Else 
            *Area\OnLTangeante = ct 
            *Area\OnRTangeante = ct 
          EndIf 
          If ct<#MaxBPoints 
            *Area\BPoints[ct+1]\x=-1 
          EndIf 
          RedrawBezier (*Area) 
        EndIf 
      EndIf 
    EndIf 
  Else 
    NCurs = *Area\OutOfAreaCursor 
  EndIf 
  If NCurs<>*Area\OutOfAreaCursor 
    SetCursor_(NCurs) 
  EndIf 
  ; 
  If WE = #WM_MOUSEWHEEL And *Area\TimeType And *Area\ForgetBS=0 
    s.l=-(EventwParam() >> 16)/20 
    For ct=1 To #MaxBPoints-1 
      If *Area\BPoints[ct]\x=-1 
        ct=#MaxBPoints 
      Else 
        mx = *Area\BPoints[ct]\x 
        *Area\BPoints[ct]\x=*Area\BPoints[ct]\x+s 
        If *Area\BPoints[ct]\x<0 
          *Area\BPoints[ct]\x=*Area\BPoints[ct]\x+BWide 
        EndIf 
        If *Area\BPoints[ct]\x>BWide 
          *Area\BPoints[ct]\x=*Area\BPoints[ct]\x-BWide 
        EndIf 
      EndIf 
    Next 
    RedrawBezier (*Area) 
  EndIf 
  If WE = #WM_KEYDOWN 
    ; Shortcuts - Gestion des touches rapides flcches et Backspace 
    If *Area\ForgetBS=0 And *Area\SelectedPoint>-1 
      If GetAsyncKeyState_(#VK_UP)
        CopyMemory(@*Area\UndoL1Points[0],@*Area\UndoL2Points[0],SizeOf(BezierPoint)*#MaxBPoints)
        CopyMemory(@*Area\BPoints[0],@*Area\UndoL1Points[0],SizeOf(BezierPoint)*#MaxBPoints)
        *Area\UndoLevel + 1
        *Area\BPoints[*Area\SelectedPoint]\y-1 
        If *Area\BPoints[*Area\SelectedPoint]\y<(-BHigh/2+1) 
          *Area\BPoints[*Area\SelectedPoint]\y = -BHigh/2 
        EndIf 
        RedrawBezier(*Area)
      EndIf 
      If GetAsyncKeyState_(#VK_DOWN)
        CopyMemory(@*Area\UndoL1Points[0],@*Area\UndoL2Points[0],SizeOf(BezierPoint)*#MaxBPoints)
        CopyMemory(@*Area\BPoints[0],@*Area\UndoL1Points[0],SizeOf(BezierPoint)*#MaxBPoints)
        *Area\UndoLevel + 1
        *Area\BPoints[*Area\SelectedPoint]\y+1 
        If *Area\BPoints[*Area\SelectedPoint]\y>(BHigh/2-1) 
          *Area\BPoints[*Area\SelectedPoint]\y = BHigh/2 
        EndIf 
        RedrawBezier(*Area)
      EndIf 
      If GetAsyncKeyState_(#VK_RIGHT)
        CopyMemory(@*Area\UndoL1Points[0],@*Area\UndoL2Points[0],SizeOf(BezierPoint)*#MaxBPoints)
        CopyMemory(@*Area\BPoints[0],@*Area\UndoL1Points[0],SizeOf(BezierPoint)*#MaxBPoints)
        *Area\UndoLevel + 1
        *Area\BPoints[*Area\SelectedPoint]\x+1 
        If *Area\BPoints[*Area\SelectedPoint]\x>(BWide-1) 
          *Area\BPoints[*Area\SelectedPoint]\x =BWide 
        EndIf 
        RedrawBezier(*Area)
      EndIf 
      If GetAsyncKeyState_(#VK_LEFT)
        CopyMemory(@*Area\UndoL1Points[0],@*Area\UndoL2Points[0],SizeOf(BezierPoint)*#MaxBPoints)
        CopyMemory(@*Area\BPoints[0],@*Area\UndoL1Points[0],SizeOf(BezierPoint)*#MaxBPoints)
        *Area\UndoLevel + 1
        *Area\BPoints[*Area\SelectedPoint]\x-1 
        If *Area\BPoints[*Area\SelectedPoint]\x<1 
          *Area\BPoints[*Area\SelectedPoint]\x = 0 
        EndIf 
        RedrawBezier(*Area)
      EndIf 
      If GetAsyncKeyState_(#VK_BACK) Or GetAsyncKeyState_(#VK_CLEAR) 
        ;- ClearPoint
        CopyMemory(@*Area\UndoL1Points[0],@*Area\UndoL2Points[0],SizeOf(BezierPoint)*#MaxBPoints)
        CopyMemory(@*Area\BPoints[0],@*Area\UndoL1Points[0],SizeOf(BezierPoint)*#MaxBPoints)
        *Area\UndoLevel + 1
        For ct=*Area\SelectedPoint To #MaxBPoints-1 
          If ct >1 Or *Area\TimeType=0 Or *Area\BPoints[ct+1]\x>0 
            *Area\BPoints[ct]\x=*Area\BPoints[ct+1]\x 
            *Area\BPoints[ct]\y=*Area\BPoints[ct+1]\y 
            *Area\BPoints[ct]\t1x=*Area\BPoints[ct+1]\t1x 
            *Area\BPoints[ct]\t1y=*Area\BPoints[ct+1]\t1y 
            *Area\BPoints[ct]\t2x=*Area\BPoints[ct+1]\t2x 
            *Area\BPoints[ct]\t2y=*Area\BPoints[ct+1]\t2y 
            If *Area\BPoints[ct]\x=-1 
              ct = #MaxBPoints 
            EndIf 
          EndIf 
        Next 
        RedrawBezier(*Area) 
      EndIf 
    EndIf 
  EndIf 
EndProcedure  
;
Procedure CalcYFromXTimeBezier(xr,*area.BezierArea) 
  DWide = *Area\RightP-*Area\LeftP 
  DHigh = *Area\BottomP-*Area\TopP 
  If *Area\BPoints[1]\x<>-1 And xr>-1 And xr<(DWide+1) 
    For ct=1 To #MaxBPoints 
      If *Area\BPoints[ct+1]\x=-1 
        xend=*Area\BPoints[ct]\x 
        ctend = ct 
        ct = #MaxBPoints 
      EndIf 
    Next 
    ct = 1 
    While *Area\BPoints[ct]\x<xr And ct<ctend : ct + 1 : Wend 
    If ct = 1 
      ctd = ctend 
      ctf = ct 
    ElseIf *Area\BPoints[ct]\x<xr 
      ctd = ctend 
      ctf = 1 
    Else 
      ctd = ct-1 
      ctf = ct 
    EndIf
    x1 = *Area\BPoints[ctd]\x 
    y1 = *Area\BPoints[ctd]\y;+(DHigh/2) 
    x2 = *Area\BPoints[ctd]\t2x 
    y2 = *Area\BPoints[ctd]\t2y 
    x3 = *Area\BPoints[ctf]\t1x 
    y3 = *Area\BPoints[ctf]\t1y 
    x4 = *Area\BPoints[ctf]\x 
    y4 = *Area\BPoints[ctf]\y;+(DHigh/2) 
    If ct = 1 
      x1 = DWide - x1 
    ElseIf *Area\BPoints[ct]\x<xr 
      x4 + DWide 
    EndIf 
    cx.f=3*x2 
    bx.f=3*(x4+x3-x2-x1)-cx 
    ax.f=x4-x1-cx-bx 
    cy.f=3*y2 
    by.f=3*(y4+y3-y2-y1)-cy 
    ay.f=y4-y1-cy-by 
    Lowlim.f=0 
    Highlim.f = 1 
    cont = 1 
    While cont 
      i.f=(Highlim-Lowlim)/2+Lowlim 
      x=((ax*i+bx)*i+cx)*i+x1
      If xr>x 
        Lowlim=i 
      ElseIf xr<x 
        Highlim=i 
      Else 
        cont = 0 
        y=((ay*i+by)*i+cy)*i+y1 
      EndIf
      If Lowlim = Highlim
        cont = 0
      EndIf
    Wend 
    ProcedureReturn y 
  EndIf 
EndProcedure 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP