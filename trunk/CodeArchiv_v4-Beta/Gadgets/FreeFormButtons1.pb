; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=26596#26596
; Author: Mischa (updated for PB4.00 by blbltheworm)
; Date: 05. January 2004
; OS: Windows
; Demo: No


; Simples Beispiel, wie man eigene Buttons realisieren kann. 
; Die Funktionen bedürfen, denke ich keiner ausführlichen Dokumentation, 
; da Funktionsnamen/Parameter es verdeutlichen. 

; Natürlich kann man eigene Buttonformen auf Basis von Images verwenden.
; Die gezeichneten Dinger dienen nur zur Demonstration. Sie sind hier
; zweckmäßig, weil ich nicht extra Bilder mitliefern muß. Also einfach
; mal probieren. 


;Include Teil / Funktionen 
Structure ibdata 
  id.l 
  handle.l 
  state.l 
  hwnd.l 
  image.l[3] 
EndStructure 
Global NewList buttondata.ibdata() 

Global ActualImageButton 

#IButton_Enter=1 
#IButton_Inside=2 
#IButton_MouseDown=3 
#IButton_MouseStillDown=4 
#IButton_MouseUp=5 

Procedure CreateImageButton(id,buttonimageid,backimageid,wnd,x,y,transcolor) 
  AddElement(buttondata()) 
  buttondata()\id=id 
  buttondata()\hwnd=wnd 
  id=ImageID(buttonimageid) 
  w=ImageWidth(buttonimageid)/3:h=ImageHeight(buttonimageid) 
  If transcolor=-1 
    StartDrawing(ImageOutput(buttonimageid)) 
      transcolor=Point(w-1,0) 
    StopDrawing() 
  EndIf 
  imglist=ImageList_Create_(w,h,#ILC_COLORDDB|#ILC_MASK,3,0) 
  ImageList_AddMasked_(imglist,id,transcolor) 
  dc=StartDrawing(ImageOutput(backimageid)) 
    For i=0 To 2 
      buttondata()\image[i]=CreateCompatibleBitmap_(dc,w,h) 
      tdc=CreateCompatibleDC_(dc) 
      object=SelectObject_(tdc,buttondata()\image[i]) 
      BitBlt_(tdc,0,0,w,h,dc,x,y,#SRCCOPY) 
      ImageList_Draw_(imglist,i,tdc,0,0,#ILD_TRANSPARENT) 
      DeleteObject_(object) 
      DeleteDC_(tdc) 
    Next i    
  StopDrawing()  
  ImageList_Destroy_(imglist) 
  buttondata()\handle=CreateWindowEx_(0,"STATIC","",1409286158,x,y,w,h,wnd,0,0,0) 
  SendMessage_(buttondata()\handle,370,0,buttondata()\image[0]) 
  ProcedureReturn buttondata()\handle 
EndProcedure 

Procedure ButtonEvent() 
  GetCursorPos_(mousepos.POINT) 
  ForEach buttondata() 
    GetWindowRect_(buttondata()\handle,position.RECT) 
    If PtInRect_(position,mousepos\x,mousepos\y) And GetForegroundWindow_()=buttondata()\hwnd 
      GetAsyncKeyState_(#VK_LBUTTON+GetSystemMetrics_(#SM_SWAPBUTTON)) 
      If buttondata()\state=5 
        buttondata()\state=2:etype=2 
      ElseIf GetAsyncKeyState_(#VK_LBUTTON+GetSystemMetrics_(#SM_SWAPBUTTON)) 
        If buttondata()\state<3 
          buttondata()\state=3:etype=3 
          SendMessage_(buttondata()\handle,370,0,buttondata()\image[2]) 
        Else 
          buttondata()\state=4:etype=4 
        EndIf  
      ElseIf buttondata()\state>2 
        SendMessage_(buttondata()\handle,370,0,buttondata()\image[1]) 
        buttondata()\state=5:etype=5 
      ElseIf buttondata()\state=0 
        buttondata()\state=1:etype=1 
        SendMessage_(buttondata()\handle,370,0,buttondata()\image[1]) 
      ElseIf buttondata()\state=1 
        buttondata()\state=2:etype=2 
      ElseIf buttondata()\state=2 
        etype=2 
      EndIf 
      ActualImageButton=buttondata()\id 
    ElseIf buttondata()\state>0 
      ActualImageButton=0 
      buttondata()\state=0 
      SendMessage_(buttondata()\handle,370,0,buttondata()\image[0]) 
    EndIf 
  Next 
  ProcedureReturn etype 
EndProcedure 

Procedure KillAllImageButtons(mode) 
  ForEach buttondata() 
    For i=0 To 2 
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
    SendMessage_(buttondata()\handle,370,0,buttondata()\image[0]) 
  Next 
EndProcedure 

Procedure KillImageButton(id) 
  ResetList(buttondata()) 
  While NextElement(buttondata()) And isfound=0 
    If buttondata()\id = id 
      isfound=1 
      For i=0 To 2 
        DeleteObject_(buttondata()\image[i]) 
      Next i 
      DestroyWindow_(buttondata()\handle) 
      DeleteElement(buttondata()) 
    EndIf 
  Wend 
EndProcedure 
;Ende des Include Teiles 




;Demonstration 
;------------- 

;Bilder erstellen (nur zur Demonstration - im Normalfall catch/load ;) 
CreateImage(0,400,300) 
dc=StartDrawing(ImageOutput(0)) 
  For i=0 To 299:LineXY(0,i,400,i,RGB(i*0.8,0,i*0.8)):Next i 
StopDrawing() 
backbrush=CreatePatternBrush_(ImageID(0)) 
;Benötigt werden 3 gleichgroße Bilder nebeneinander innerhalb eines Image 
;Also 240*40 = 3 Bilder 80*40 
id=CreateImage(1,240,40) 
dc=StartDrawing(ImageOutput(1)) 
  For i=0 To 2 
    region=CreateRoundRectRgn_(i*80,0,i*80+80,40,40,40) 
    brush =CreateSolidBrush_(RGB(32,i*80,i*50)) 
    FillRgn_(dc,region,brush):DeleteObject_(brush) 
    brush =CreateSolidBrush_(RGB(255,255,255)) 
    FrameRgn_(dc,region,brush,1,1):DeleteObject_(brush) 
    FrontColor(RGB(255,255,255)):DrawingMode(1) 
    DrawText(i*80+17,11,"State "+Chr(65+i)) 
  Next i 
StopDrawing() 
;und eine zweite Serie (etwas größer) 
id=CreateImage(2,900,40) 
dc=StartDrawing(ImageOutput(2)) 
  For i=0 To 2 
    region=CreateRoundRectRgn_(i*300,0,i*300+300,40,40,40) 
    brush =CreateSolidBrush_(RGB(i*80,i*80,100)) 
    FillRgn_(dc,region,brush):DeleteObject_(brush) 
    brush =CreateSolidBrush_(RGB(255,255,255)) 
    FrameRgn_(dc,region,brush,1,1):DeleteObject_(brush) 
    FrontColor(RGB(255,255,255)):DrawingMode(1) 
    DrawText(i*300+70,11,"Langer Button  -  State "+Chr(65+i)) 
  Next i 
StopDrawing() 
id=CreateImage(3,900,40) 
dc=StartDrawing(ImageOutput(3)) 
  Global Dim text.s(2):text(0)="eXit":text(1)="Exit":text(2)="EXIT" 
  LoadFont(0,"System",26,#PB_Font_Bold) 
  For i=0 To 2 
    DrawingMode(4) 
    Box(i*300,0,300,40,RGB(200,200,255)) 
    FrontColor(RGB(i*120,i*120,100)):DrawingMode(1) 
    DrawingFont(FontID(0)) 
    DrawText(i*300+124,4,text(i)) 
  Next i 
StopDrawing() 
;Ende der Bilderstellung 



;Hauptprogramm 
xresu=GetSystemMetrics_(#SM_CXSCREEN):yresu=GetSystemMetrics_(#SM_CYSCREEN) 
OpenWindow(0,xresu,0,400,300,"TransButton",#WS_POPUP) 
region=CreateRoundRectRgn_(0,0,400,300,30,30) 
SetWindowRgn_(WindowID(0),region,#True) 
SetClassLong_(WindowID(0),#GCL_HBRBACKGROUND,backbrush) 


;Ein paar von unseren besondern Buttons ;) 
For i=0 To 5 
  CreateImageButton(100+i+1,1,0,WindowID(0),5,5+i*50,-1) 
Next i 
For i=0 To 4 
  CreateImageButton(200+i+1,2,0,WindowID(0),90,5+i*50,-1) 
Next i 
CreateImageButton(300,3,0,WindowID(0),90,5+i*50,0) 
;CreateImageButton(ButtonID,ButtonImageID,BackgroundImageID,WindowHandle,x,y,Transcolor) 
;Transcolor=-1  <-Pixel rechts/oben in ButtonImage wird transparent 


ResizeWindow(0,xresu/2-200,yresu/2-150,#PB_Ignore,#PB_Ignore) 
While WindowEvent():Wend 

Repeat 
  IButtonEvent=ButtonEvent() 
  If IButtonEvent 
    Select IButtonEvent 
      Case #IButton_Enter 
        Beep_(500,50) 
        
      Case #IButton_Inside 
        ;...bin noch im Button 
        
      Case #IButton_MouseDown 
        Beep_(1000,50) 
        
      Case #IButton_MouseStillDown 
        ;...halte gedrückt 
        
      Case #IButton_MouseUp 
        ResetImageButtons() 
        If ActualImageButton=300 
          Exit=1 
        Else 
          MessageRequester("Info","Button Id="+Str(ActualImageButton),0) 
        EndIf 
        
    EndSelect 
  EndIf 
  Event=WindowEvent() 
  If Event 
    Select Event 
      Case #WM_LBUTTONDOWN 
        If ActualImageButton=0 
          SendMessage_(WindowID(0),#WM_NCLBUTTONDOWN, #HTCAPTION,0) 
        EndIf 
      ;.... 
    EndSelect 
  EndIf 
  Delay(5) 
Until Exit=1 

KillAllImageButtons(0) 
DeleteObject_(backbrush) 
DeleteObject_(region) 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
