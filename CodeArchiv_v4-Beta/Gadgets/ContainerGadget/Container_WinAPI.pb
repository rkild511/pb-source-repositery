; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1175&highlight=
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 10. December 2004
; OS: Windows
; Demo: No

; 
; by Danilo, 10th December 2004 
; 
;   simple WinAPI container example 
; 

#Window = 0

Procedure Container_Callback(hWnd,Msg,wParam,lParam) 
  Select Msg 
    Case #WM_LBUTTONDOWN ; Beispiel für linken Button Down 
      Beep_(800,100) 
      ProcedureReturn 0 
    Case #WM_RBUTTONDOWN ; Beispiel für rechten Button Down 
      Beep_(600,50) 
      ProcedureReturn 0 
    Case #WM_DESTROY     ; Hintergrundfarbe loeschen/freigeben 
      DeleteObject_( GetClassLong_(hWnd,#GCL_HBRBACKGROUND) ) 
      Beep_(600,50):Beep_(800,50) ; Telefon ... LOL ;) 
      ProcedureReturn 0 
  EndSelect 
  PB_Callback = GetWindowLong_(hWnd,#GWL_USERDATA) 
  If PB_Callback 
    ProcedureReturn CallWindowProc_(PB_Callback,hWnd,Msg,wParam,lParam) 
  Else 
    ProcedureReturn DefWindowProc_(hWnd,Msg,wParam,lParam) 
  EndIf 
EndProcedure 

Procedure Container(x,y,width,height,parent,backcolor,border) 
  ; 
  ; Container erstellen mit eigener Hintergrundfarbe und Rahmen 
  ; 
  #Borderless = $0000 
  #Flat       = $0001 
  #Raised     = $0002 
  #Single     = $0004 
  #Double_    = $0008 
  #Thick      = $0010 

  Static container_count 

  ; Select Border Style 
  If     (border & #Flat) 
    Style   = #WS_BORDER;                   Border = 2; 
  ElseIf (border & #Single) 
    ExStyle = #WS_EX_STATICEDGE;            Border = 2; 
  ElseIf (border & #Raised) 
    Style   = #WS_DLGFRAME;                 Border = 6; 
  ElseIf (border & #Double_) 
    ExStyle = #WS_EX_CLIENTEDGE;            Border = 4; 
  ElseIf (border & #Thick) 
    ExStyle = #WS_EX_CLIENTEDGE; 
    Style   = #WS_DLGFRAME;                 Border = 10; 
  EndIf 

  If backcolor = -1 
    backcolor  = GetSysColor_(#COLOR_BTNFACE) 
  EndIf 

  ; Create Window Class 
  window_class$ = "PB_Container_Danilo_"+RSet(Hex(container_count),8,"0") 
  container_count + 1 

  wc.WNDCLASSEX 
  wc\cbSize        = SizeOf(WNDCLASSEX) 
  wc\lpfnWndProc   = @Container_Callback() 
  wc\hInstance     = 0 
  wc\hCursor       = LoadCursor_(0, #IDC_ARROW)  ; #IDC_ARROW   = Arrow 
                                                 ; #IDC_SIZEALL = Size Arrow 
                                                 ; #IDC_CROSS   = Cross 
  wc\hbrBackground = CreateSolidBrush_(backcolor) 
  wc\lpszClassName = @window_class$ 
  If RegisterClassEx_(@wc) 
    hContainer = CreateWindowEx_(ExStyle,window_class$,0,#WS_CHILD|#WS_VISIBLE|Style,x,y,width,height,parent,0,GetModuleHandle_(0),0) 
    If hContainer 
      SetWindowLong_(hContainer,#GWL_USERDATA,GetWindowLong_(WindowID(#Window),#GWL_WNDPROC)) 
      ProcedureReturn hContainer 
    EndIf 
  EndIf 
EndProcedure 


Procedure Message(Msg$) 
  ; 
  ; Display new message 
  ; 
  Static MessageCount 
  MessageCount +1 
  AddGadgetItem(0,-1,RSet(StrU(MessageCount,#Long),10,"0")+": "+Msg$) 
  SendMessage_(GadgetID(0),#LB_SETTOPINDEX,CountGadgetItems(0)-1,0) 
EndProcedure 


hWnd.l = OpenWindow(#Window,0,0,490,440,"Container",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  CreateGadgetList(hWnd) 
  ListViewGadget(0,10,330,470,100) ; Message Window 
    AddGadgetItem(0,-1,"Messages:") 
    SetGadgetFont(0,LoadFont(0,"Courier New",10)) 

  hContainer1 = Container( 10, 10,150,150,hWnd,RGB($80,$80,$80),#Borderless) 

  hContainer2 = Container(170, 10,150,150,hWnd,RGB($B0,$B0,$00),#Flat) 
    UseGadgetList(hContainer2) 
    ButtonGadget(2,10,10,100,20,"Btn 1") 

  hContainer3 = Container(330, 10,150,150,hWnd,RGB($80,$80,$80),#Raised) 
    UseGadgetList(hContainer3) 
    ButtonGadget(3,10,10,100,20,"Btn 2") 

  hContainer4 = Container( 10,170,150,150,hWnd,       -1       ,#Single) 
    UseGadgetList(hContainer4) 
    ListViewGadget(4,10,10,128,128) 
      For i = 0 To 99 
        AddGadgetItem(4,-1,"ListView Item"+Str(i)) 
      Next i 

  hContainer5 = Container(170,170,150,150,hWnd,       -1       ,#Double_) 
    UseGadgetList(hContainer5) 
    PanelGadget(5,10,10,128,128) 
      For i = 0 To 1 
        AddGadgetItem(5,-1,"Panel "+Str(i)) 
      Next i 

  hContainer6 = Container(330,170,150,150,hWnd,       -1       ,#Thick) 
    UseGadgetList(hContainer6) 
    TreeGadget(6,10,10,128,128) 
      For i = 1 To 20 
        If i%5=0 
          AddGadgetItem(6,-1,"Tree "+Str(i), 0, 0) 
          For a = 0 To 9 
            AddGadgetItem(6,-1,"SubItem "+Str(a), 0, 1) 
          Next a 
        Else 
          AddGadgetItem(6,-1,"Tree "+Str(i), 0, 0) 
        EndIf 
      Next i 

Repeat 
  Select WaitWindowEvent() 
     Case #PB_Event_CloseWindow 
       Break 
     Case #PB_Event_Gadget 
       Select EventGadget() 
         Case 2 
           Message("Button 1 geklickt") 
         Case 3 
           Message("Button 2 geklickt") 
         Case 4 
           Message("ListView Item "+Str( GetGadgetState(4) )) 
         Case 5 
           Message("Panel Item "   +Str( GetGadgetState(5) )) 
         Case 6 
           ;If EventType()=#PB_EventType_LeftClick 
             Message("Tree Item "  +Str( GetGadgetState(6) )) 
           ;EndIf 
       EndSelect 
  EndSelect 
ForEver 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP