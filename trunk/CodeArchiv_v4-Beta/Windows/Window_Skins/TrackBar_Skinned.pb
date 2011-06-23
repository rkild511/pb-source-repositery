; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3292&highlight=
; Author: Mischa (updated for PB3.93 by Donald)
; Date: 04. January 2004
; OS: Windows
; Demo: No

; Note: MasterVolumeControl userlib is needed!

; - Lautstärkeregelung getrennt für beide Kanäle 
; - Gleichzeitiges drücken der rechten Maustaste und ziehen eines Schiebereglers
;   synchronisiert den anderen Kanal 
; - Lautstärke wird ständig abgefragt (20*sek) und die Regler entsprechend angepaßt. 

;Bilder erstellen 
trans=GetSysColor_(#COLOR_BTNFACE) 
CreateImage(0,15,120) 
StartDrawing(ImageOutput(0)) 
  Box(0,0,15,120,trans) 
  DrawingMode(4) 
  Box(0,0,15,120,0) 
StopDrawing() 
CreateImage(1,13,15) 
StartDrawing(ImageOutput(1)) 
  Box(0,0,13,15,0) 
  For i=2 To 14 Step 2 
    LineXY(0,i,13,i,RGB(128,0,0)) 
  Next i 
StopDrawing() 
;Ende der Bilderstellung 



Procedure DrawBars(l,r,mode) 
  Global Dim Pos.l(1) 
  Pos(0)=l : Pos(1)=r 
  If mode 
    Pos(mode-1)=l 
    Pos(1-(mode-1))=-1 
  EndIf 
  For i=0 To 1 
    If Pos(i)>-1 
      CopyImage(0,3+i) 
      StartDrawing(ImageOutput(3+i)) 
        DrawImage(ImageID(1),1,Pos(i)) 
      StopDrawing() 
      SetGadgetState(1+i,ImageID(3+i)) 
    EndIf 
  Next i 
EndProcedure 


wnd=OpenWindow(0,0,0,60,180,"Volume",#WS_POPUP|#PB_Window_ScreenCentered) 
region=CreateRoundRectRgn_(0,0,60,180,15,15) 
SetWindowRgn_(wnd,region,#True) 
CreateGadgetList(WindowID(0)) 
ButtonGadget(0,10,10,40,20,"eXit") 
ImageGadget(1,10,40,15,120,0) 
ImageGadget(2,35,40,15,120,0) 
DisableGadget(1,1)
DisableGadget(1,2)
OldVolLeft.f=-1 
Global Dim Rect.RECT(1) 
Global Dim Vol.l(1) 
Repeat 
  If GetTickCount_()-timer > 50 
    VolLeft.f  = GetMasterVolume(0,0) 
    VolRight.f = GetMasterVolume(0,1) 
    If VolLeft<>OldVolLeft Or VolRight<>OldVolRight.f 
      OldVolLeft  = VolLeft 
      OldVolRight = VolRight 
      DrawBars(104-VolLeft/65535*104,104-VolRight/65535*104,0) 
    EndIf 
    timer=GetTickCount_() 
  EndIf 
  GetCursorPos_(mousepos.POINT) 
  Event = WindowEvent() 
  If ChangePos 
    If Event = #WM_LBUTTONUP 
      ChangePos=0 
      ClipCursor_(0) 
      oldy=-1 
    Else 
      If mousepos\y<>oldy 
        oldy=mousepos\y 
        Position=oldy-Rect(ChangePos-1)\top 
        DrawBars(Position,0,ChangePos) 
        Vol(0) = GetMasterVolume(0,0) 
        Vol(1) = GetMasterVolume(0,1) 
        Vol(ChangePos-1) = 65536/104*(104-Position) 
        Debug Vol(ChangePos-1)
        If GetAsyncKeyState_(#VK_RBUTTON-GetSystemMetrics_(#SM_SWAPBUTTON)) 
          Vol(1-(ChangePos-1))=Vol(ChangePos-1) 
        EndIf 
        SetMasterVolume(0,Vol(0),Vol(1))  
      EndIf 
    EndIf 
  ElseIf Event = #WM_LBUTTONDOWN 
    For i=0 To 1 
      GetWindowRect_(GadgetID(i+1),Rect(i)) 
      If PtInRect_(Rect(i),mousepos\x,mousepos\y) 
        ChangePos=i+1 
        Rect(i)\top+7:Rect(i)\bottom-8 
        Rect(i)\left+7:Rect(i)\right-7 
        ClipCursor_(Rect(i)) 
      EndIf 
    Next i 
    If WindowFromPoint_(mousepos\x,mousepos\y)=wnd And ChangePos=0 
      ReleaseCapture_() 
      SendMessage_(wnd,#WM_NCLBUTTONDOWN, #HTCAPTION,0) 
    EndIf 
  ElseIf Event = #PB_Event_Gadget 
    Select EventGadget() 
      Case 0 
        Quit=1 
    EndSelect 
  EndIf    
  Delay(4) 
Until Quit=1 
DeleteObject_(region)  

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
