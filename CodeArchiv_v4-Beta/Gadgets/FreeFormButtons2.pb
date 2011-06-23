; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=26749#26749
; Author: Mischa (updated for PB4.00 by blbltheworm)
; Date: 06. January 2004
; OS: Windows
; Demo: No

; Ein weiteres Beispiel, wie man eigene Buttons realisieren kann. 

;Include Teil / Funktionen 
Structure ibdata 
  id.l 
  handle.l 
  state.l 
  typ.l 
  check.l 
  hwnd.l 
  image.l[6] 
EndStructure 
Global NewList buttondata.ibdata() 

Global ActualImageButton 
Global Dim imagecreations.l(1) 
#IButton_Transparent=1 

Enumeration 1 
  #IButton_Enter 
  #IButton_Inside 
  #IButton_MouseDown 
  #IButton_MouseStillDown 
  #IButton_MouseUp 
EndEnumeration 

Procedure CreateImageButton(id,buttonimageid,stateimageid,backimageid,wnd,x,y,trans,color) 
  imagecreations(0)=buttonimageid 
  AddElement(buttondata()) 
  buttondata()\id=id 
  buttondata()\hwnd=wnd 
  If stateimageid>-1 
    buttondata()\typ=1 
    imagecreations(1)=stateimageid 
    ischeck=1 
  EndIf 
  For c=0 To ischeck 
    id=ImageID(imagecreations(c)) 
    w=ImageWidth(imagecreations(c))/3:h=ImageHeight(imagecreations(c)) 
    If trans 
      If color=-1 
        StartDrawing(ImageOutput(imagecreations(c))) 
          color=Point(w-1,0) 
        StopDrawing() 
      EndIf 
      imglist=ImageList_Create_(w,h,#ILC_COLORDDB|#ILC_MASK,3,0) 
      ImageList_AddMasked_(imglist,id,color) 
    EndIf 
    dc=StartDrawing(ImageOutput(backimageid)) 
      For i=0 To 2 
        buttondata()\image[i+c*3]=CreateCompatibleBitmap_(dc,w,h) 
        tdc=CreateCompatibleDC_(dc) 
        object=SelectObject_(tdc,buttondata()\image[i+c*3]) 
        BitBlt_(tdc,0,0,w,h,dc,x*trans+(1-trans)*w*i,y*trans,#SRCCOPY) 
        ImageList_Draw_(imglist,i,tdc,0,0,#ILD_TRANSPARENT) 
        DeleteObject_(object) 
        DeleteDC_(tdc) 
      Next i 
    StopDrawing() 
    If trans      
      ImageList_Destroy_(imglist) 
    EndIf 
  Next c 
  buttondata()\handle=CreateWindowEx_(0,"STATIC","",1409286158,x,y,w,h,wnd,0,0,0) 
  SendMessage_(buttondata()\handle,370,0,buttondata()\image[0]) 
  ProcedureReturn buttondata()\handle 
EndProcedure 

Procedure ButtonEvent() 
  GetCursorPos_(mousepos.POINT) 
  ForEach buttondata() 
    checked=buttondata()\check 
    GetWindowRect_(buttondata()\handle,position.RECT) 
    If PtInRect_(position,mousepos\x,mousepos\y) And GetForegroundWindow_()=buttondata()\hwnd 
      GetAsyncKeyState_(#VK_LBUTTON+GetSystemMetrics_(#SM_SWAPBUTTON)) 
      If buttondata()\state=5 
        buttondata()\state=2:etype=2 
      ElseIf GetAsyncKeyState_(#VK_LBUTTON+GetSystemMetrics_(#SM_SWAPBUTTON)) 
        If buttondata()\state<3 
          buttondata()\state=3:etype=3 
          SendMessage_(buttondata()\handle,370,0,buttondata()\image[2+checked*3]) 
        Else 
          buttondata()\state=4:etype=4 
        EndIf  
      ElseIf buttondata()\state>2 
        If buttondata()\typ=1 
          buttondata()\check=(1-buttondata()\check)*1 
        EndIf 
        SendMessage_(buttondata()\handle,370,0,buttondata()\image[1+buttondata()\check*3]) 
        buttondata()\state=5:etype=5 
      ElseIf buttondata()\state=0 
        buttondata()\state=1:etype=1 
        SendMessage_(buttondata()\handle,370,0,buttondata()\image[1+checked*3]) 
      ElseIf buttondata()\state=1 
        buttondata()\state=2:etype=2 
      ElseIf buttondata()\state=2 
        etype=2 
      EndIf 
      ActualImageButton=buttondata()\id 
    ElseIf buttondata()\state>0 
      ActualImageButton=0 
      buttondata()\state=0 
      SendMessage_(buttondata()\handle,370,0,buttondata()\image[checked*3]) 
    EndIf 
  Next 
  ProcedureReturn etype 
EndProcedure 

Procedure KillAllImageButtons(mode) 
  ForEach buttondata() 
    For i=0 To 2+buttondata()\typ*3 
      DeleteObject_(buttondata()\image[i]) 
    Next i 
    If mode 
      DestroyWindow_(buttondata()\handle) 
    EndIf 
  Next 
  ClearList(buttondata()) 
EndProcedure 

Procedure ResetImageButtons() 
  ForEach buttondata() 
    buttondata()\state=0 
    SendMessage_(buttondata()\handle,370,0,buttondata()\image[buttondata()\check*3]) 
  Next 
EndProcedure 

Procedure KillImageButton(id) 
  ResetList(buttondata()) 
  While NextElement(buttondata()) And isfound=0 
    If buttondata()\id = id 
      isfound=1 
      For i=0 To 2+buttondata()\typ*3 
        DeleteObject_(buttondata()\image[i]) 
      Next i 
      DestroyWindow_(buttondata()\handle) 
      DeleteElement(buttondata()) 
    EndIf 
  Wend 
EndProcedure 

Procedure GetIButtonState(id) 
  ResetList(buttondata()) 
  While NextElement(buttondata()) And isfound=0 
    If buttondata()\id = id 
      isfound=1 
      check=buttondata()\check 
    EndIf 
  Wend 
  If isfound 
    ProcedureReturn check 
  Else 
    ProcedureReturn -1 
  EndIf 
EndProcedure 

Procedure SetIButtonState(id,checkvalue) 
  ResetList(buttondata()) 
  While NextElement(buttondata()) And isfound=0 
    If buttondata()\id = id 
      isfound=1 
      typ=buttondata()\typ 
      If typ 
        check=buttondata()\check 
        buttondata()\check=checkvalue 
        buttondata()\state=0 
        SendMessage_(buttondata()\handle,370,0,buttondata()\image[checkvalue*3]) 
      EndIf 
    EndIf 
  Wend 
  If isfound And typ 
    ProcedureReturn check 
  ElseIf isfound 
    ProcedureReturn -2 
  Else 
    ProcedureReturn -1 
  EndIf 
EndProcedure 
;Ende des Include Teiles 






;Demonstration 
;------------- 

;Bilder erstellen (nur zur Demonstration - im Normalfall catch/load ;) 
CreateImage(0,400,300) 
dc=StartDrawing(ImageOutput(0)) 
  For i=0 To 299:LineXY(0,i,400,i,RGB(i*0.8,0,i*0.8)):Next i 
  brush =CreateSolidBrush_(RGB(255,255,255)) 
  wregion=CreateRoundRectRgn_(0,0,400,300,30,30) 
  FrameRgn_(dc,wregion,brush,1,1):DeleteObject_(brush) 
StopDrawing() 
backbrush=CreatePatternBrush_(ImageID(0)) 
;Benötigt werden 3 gleichgroße Bilder nebeneinander innerhalb eines Image 
;Also 240*40 = 3 Bilder 80*40 (und das ganze 2 mal für checkable buttons) 

CreateImage(1,240,40) ;Normale Bilder 
dc=StartDrawing(ImageOutput(1)) 
  For i=0 To 2 
    region=CreateRoundRectRgn_(i*80,0,i*80+80,40,40,40) 
    brush =CreateSolidBrush_(RGB(32,i*80,i*50)) 
    FillRgn_(dc,region,brush):DeleteObject_(brush) 
    brush =CreateSolidBrush_(RGB(255,255,255)) 
    FrameRgn_(dc,region,brush,1,1) 
    DeleteObject_(brush):DeleteObject_(region) 
    FrontColor(RGB(255,255,255)):DrawingMode(1) 
    DrawText(i*80+17,11,"State "+Chr(65+i)) 
  Next i 
StopDrawing() 

CreateImage(2,900,40) 
LoadFont(0,"System",26,#PB_Font_Bold)
dc=StartDrawing(ImageOutput(2)) 
  Global Dim text.s(2):text(0)="eXit":text(1)="ExIT":text(2)="EXIT" 
  For i=0 To 2 
    Box(i*300+5,5,290,30,RGB(200,200,255-i*80)) 
    DrawingMode(4) 
    Box(i*300,0,300,40,RGB(200,200,255)) 
    FrontColor(RGB(i*120,i*120,100)):DrawingMode(1) 

    DrawingFont(FontID(0)) 
    DrawText(i*300+124,4,text(i)) 
  Next i 
StopDrawing() 

CreateImage(3,120,40) 
dc=StartDrawing(ImageOutput(3)) 
For i=0 To 2 
  Select i 
    Case 0 
      DrawingMode(4):Box(i*40,0,40,40,RGB(250,160,250)) 
      DrawingMode(0):Box(i*40+4,4,32,32,RGB(150,100,150)) 
    Case 1 
      DrawingMode(4):Box(i*40,0,40,40,RGB(255,255,0)) 
      DrawingMode(4):Box(i*40+1,1,38,38,RGB(255,255,0)) 
      DrawingMode(0):Box(i*40+4,4,32,32,RGB(150,100,150)) 
    Case 2 
      DrawingMode(4):Box(i*40,0,40,40,RGB(255,255,0)) 
      DrawingMode(4):Box(i*40+1,1,38,38,RGB(255,255,0)) 
      DrawingMode(0):Box(i*40+8,8,24,24,RGB(200,133,200)) 
  EndSelect 
Next i 
StopDrawing() 
CreateImage(4,120,40) 
dc=StartDrawing(ImageOutput(4)) 
For i=0 To 2 
  Select i 
    Case 0 
      DrawingMode(4):Box(i*40,0,40,40,RGB(250,160,250)) 
      DrawingMode(0):Box(i*40+6,6,28,28,RGB(200,133,200)) 
    Case 1 
      DrawingMode(4):Box(i*40,0,40,40,RGB(255,255,0)) 
      DrawingMode(4):Box(i*40+1,1,38,38,RGB(255,255,0)) 
      DrawingMode(0):Box(i*40+6,6,28,28,RGB(200,133,200)) 
    Case 2 
      DrawingMode(4):Box(i*40,0,40,40,RGB(255,255,0)) 
      DrawingMode(4):Box(i*40+1,1,38,38,RGB(255,255,0)) 
      DrawingMode(0):Box(i*40+8,8,24,24,RGB(200,133,200)) 
  EndSelect 
Next i 
StopDrawing() 
;Ende der Bilderstellung 


;Tests für check/uncheck 
Procedure CheckAllButtons(value) 
  For i=200 To 229 
    result=SetIButtonState(i,value) 
    ;Result = Alter Status, oder -2 wenn Button kein CheckButton, oder -1 wenn ID ungültig 
  Next i 
EndProcedure 

Procedure InvertAllButtons() 
  For i=200 To 229 
    result = GetIButtonState(i)    
    ;Result = Status, oder -1 wenn ID ungültig 
    SetIButtonState(i,(1-result)*1) 
  Next i 
EndProcedure 
;Ende Testfunktionen 



;Hauptprogramm 
xresu=GetSystemMetrics_(#SM_CXSCREEN):yresu=GetSystemMetrics_(#SM_CYSCREEN) 
OpenWindow(0,xresu,0,400,300,"TransButton",#WS_POPUP) 
SetWindowRgn_(WindowID(0),wregion,#True):DeleteObject_(wregion) 
SetClassLong_(WindowID(0),#GCL_HBRBACKGROUND,backbrush) 


;Ein paar von unseren besondern Buttons ;) 
For i=0 To 5 
  CreateImageButton(100+i+1,1,-1,0,WindowID(0),5,5+i*50,#IButton_Transparent,-1) 
Next i 

For y=1 To 5 
  For x=1 To 6 
     CreateImageButton(193+y*6+x,3,4,0,WindowID(0),70+x*42,-15+y*42,#IButton_Transparent,0) 
  Next x 
Next y 

CreateImageButton(2000,2,-1,0,WindowID(0),85,255,#IButton_Transparent,0) 
;CreateImageButton(ButtonID,ButtonImageID,CheckButtonImageID,BackgroundImageID,WindowHandle,x,y,Transmode,Transcolor) 

;Transcolor=-1          <-Farbe Pixel rechts/oben in ButtonImage wird transparente Farbe 
;CheckButtonImageID=-1  <-Kein Checkbutton (also nur ein Image [mit 3 Bildern], sonst 2 Images) 
;Transmode=0            <-Button wird nicht transparent gezeichnet 




ResizeWindow(0,xresu/2-200,yresu/2-150,#PB_Ignore,#PB_Ignore) 
While WindowEvent():Wend 

Repeat 
  Select ButtonEvent() 
    Case #IButton_Enter 
      Beep_(500,50) 
      
    Case #IButton_Inside 
      ;...bin noch im Button 
      
    Case #IButton_MouseDown 
      Beep_(1000,50) 
      
    Case #IButton_MouseStillDown 
      ;...halte gedrückt 
      
    Case #IButton_MouseUp 
      If ActualImageButton=2000 
        Exit=1 
      ElseIf ActualImageButton=101 
        CheckAllButtons(1) 
      ElseIf ActualImageButton=102 
        CheckAllButtons(0) 
      ElseIf ActualImageButton=103 
        InvertAllButtons() 
      ElseIf ActualImageButton<200 
        ResetImageButtons() 
        MessageRequester("Info","Button Id="+Str(ActualImageButton),0) 
      EndIf 
      
  EndSelect 
  
  Event=WindowEvent() 
  While Event=#WM_PAINT:Event=WindowEvent():Wend ;<-Notwendig für schnellen Bildwiederaufbau 
  Select Event 
    Case #WM_LBUTTONDOWN 
      If ActualImageButton=0 
        SendMessage_(WindowID(0),#WM_NCLBUTTONDOWN, #HTCAPTION,0) 
      EndIf 
    ;.... 
  EndSelect 
  
  Delay(4) 

Until Exit=1 

KillAllImageButtons(0) 
DeleteObject_(backbrush) 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; EnableXP
; DisableDebugger
