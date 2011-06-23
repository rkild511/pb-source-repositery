; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14636&highlight=
; Author: localmotion34 (updated for PB 4.00 by Andre)
; Date: 02. April 2005
; OS: Windows
; Demo: No


; Here is a little version of the DirectUIhwnd class that microsoft uses in the 
; control panel of Windows XP. its not finished yet, but i thought id get some 
; input on it. try it out... 

Structure inf 
  duinum.l 
  State.l 
  mainhandle.l 
  hwnd.l 
  imagehwnd.l 
  button.l 
  buttonstate.l 
  width.l 
  height.l 
  hyperlink.l[50] 
EndStructure 

Procedure InitDUI() 
  Global NewList dui.inf() 
  Global Dim icon.l(50) 
EndProcedure 

Procedure buttonproc(hwnd,msg,wParam,lParam) 
  Select msg 
    Case #WM_LBUTTONUP 
      imgparent=GetParent_(hwnd) 
      parent=GetParent_(imgparent) 
      ForEach dui() 
        If parent=dui()\hwnd 
          currentdui=dui()\duinum 
          SelectElement(dui(),currentdui) 
          If dui()\State=1 
            SetWindowPos_(dui()\hwnd,0,0,0,dui()\width,20,#SWP_NOMOVE) 
            dui()\State=0 
          ElseIf dui()\State=0 
            SetWindowPos_(dui()\hwnd,0,0,0,dui()\width,dui()\height,#SWP_NOMOVE) 
            dui()\State=1 
          EndIf 
          Break 
        EndIf 
      Next 
      
  EndSelect 
  ProcedureReturn CallWindowProc_(GetProp_(hwnd,"OldProc1"),hwnd,msg,wParam,lParam) 
EndProcedure 

Procedure DirectUIhwnd(number,x,y,width,height,text.s,icon,parentid) 
  AddElement(dui()) 
  SelectElement(dui(),number) 
  dui()\duinum=number 
  dui()\width=width 
  dui()\height=height 
  dui()\mainhandle=OpenWindow(#PB_Any,x,y,width,height,"", #PB_Window_BorderLess   |#PB_Window_Invisible) 
  dui()\hwnd=WindowID(dui()\mainhandle) 
  SetWindowLong_(WindowID(dui()\mainhandle),#GWL_STYLE, #WS_CHILD |#WS_BORDER|#WS_CLIPCHILDREN|#WS_CLIPSIBLINGS ) 
  ;RedrawWindow_(dui()\hwnd,0,0,7) 
  SetParent_(WindowID(dui()\mainhandle),parentid) 
  icon(number)=CreateImage(number+200,width,20) 
  StartDrawing(ImageOutput(number+200)) 
  DrawImage(icon(0),0,0) 
  #clnavy=$00800000 
  Box(0,0,width,20,#clnavy) 
  StopDrawing() 
  CreateGadgetList(WindowID(dui()\mainhandle)) 
  dui()\imagehwnd=ImageGadget(#PB_Any,0,0,width,20,0) 
  SetGadgetState(dui()\imagehwnd,icon(number)) 
  dui()\button=ButtonGadget(#PB_Any,width-18,2,16,16,"^") 
  style = GetWindowLong_(GadgetID(dui()\button), #GWL_STYLE) 
  toggleStyle=style|$1083 
  SetWindowLong_(GadgetID(dui()\button), #GWL_STYLE, toggleStyle) 
  SetParent_(GadgetID(dui()\button),GadgetID(dui()\imagehwnd)) 
  SendMessage_(GadgetID(dui()\button),#BM_SETCHECK,#BST_CHECKED,0) 
  SetProp_(GadgetID(dui()\button),"OldProc1",SetWindowLong_(GadgetID(dui()\button), #GWL_WNDPROC, @buttonproc())) 
  SetWindowPos_(dui()\hwnd,0,0,0,dui()\width,20,#SWP_NOMOVE) 
  SetWindowPos_(dui()\hwnd,parentid,0,0,dui()\width,dui()\height,#SWP_NOMOVE) 
  RedrawWindow_(WindowID(dui()\mainhandle),0,0,#RDW_ALLCHILDREN   ) 
  ShowWindow_(WindowID(dui()\mainhandle),#SW_SHOW) 
  UpdateWindow_(WindowID(dui()\mainhandle)) 
  SetWindowPos_(dui()\hwnd,0,0,0,dui()\width,dui()\height,#SWP_NOMOVE) 
  dui()\State=1 
EndProcedure 

 Procedure addDUIlink(numberDUI,Position,text.s,color.l) 
  SelectElement(dui(),numberDUI) 
    UseGadgetList(WindowID(dui()\mainhandle)) 
    hyperlink=HyperLinkGadget(#PB_Any, 5, Position*20 +25,dui()\width,20,Space(10)+ text, color) 
    RedrawWindow_(WindowID(dui()\mainhandle),0,0,#RDW_ALLCHILDREN   ) 
    ShowWindow_(WindowID(dui()\mainhandle),#SW_SHOWNORMAL) 
    UpdateWindow_(WindowID(dui()\mainhandle)) 
    dui()\hyperlink[Position]=hyperlink 
    ProcedureReturn hyperlink 
  EndProcedure 
  
  OpenWindow(0,0,0,270,160,"DirectUIhwnd",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
  InitDUI() 
  DirectUIhwnd(0,10,10,100,100,"test",0,WindowID(0)) 
  DirectUIhwnd(1,130,10,100,100,"test2",0,WindowID(0)) 
  link=addDUIlink(0,0,"test",$FF04) 
  link2=addDUIlink(0,1,"test 2",$FF04) 
  Repeat 
    Select WindowEvent() 
      Case #PB_Event_Gadget 
        Select EventGadget() 
          Case link 
            Debug "it works" 
          Case 0 

        EndSelect 
      Case #PB_Event_CloseWindow 
        Quit=1 
    EndSelect 
  Until Quit=1 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -