; English forum: http://www.purebasic.fr/english/viewtopic.php?t=11524&highlight=
; Author: localmotion34 (updated for PB 4.00 by Andre)
; Date: 02. July 2004
; OS: Windows
; Demo: No

; Powerpoint listview redone
; --------------------------
; Here is a redone version of my powerpoint listview gadget using buttonimagegadgets.
; It is now possible to have up to 10 listviews with 100 images each. It's a little
; buggy now, and im hoping someone can look through it and tell me what is going on,
; especially with the setpptstate() to 2 button, where it sometimes sets the wrong
; listview. Hope this can be useful to some people. Please give me some comments or
; suggestions.

; New version 1.1:
; Bug free and totally working, supporting up to 10 listviews with 100 images each.
; If you use the code, just please give me credit. you can modify it to suit your
; needs, or improve it. My advice as I've tried to tailbite it and it wont work,
; save it as a .pbi include file and throw it in the JAPBE includes. Comments and
; suggestions are welcome.


#SS_NOTIFY=256
#SS_OWNERDRAW=$D

;- Structures, Lists and Arrays
Structure PPTinfo
  gadgetnumber.l
  scrollarea.l
  scrollareachild.l
  scrollareahandle.l
  childimages.l[100]
EndStructure

Global Dim pptLVstruct.PPTinfo(100)

rect.RECT

Structure FindWindowData
  childwindowhandle.l
EndStructure

Structure handle
  hwnd.l
EndStructure

Global Dim PPTimages(500)

Global NewList FindChild.FindWindowData()
Global NewList PptLVnumber.handle()

;- Procedures
Procedure.l EnumChildProc(hChild, lParam)
  AddElement(FindChild())
  FindChild()\childwindowhandle= hChild
  ProcedureReturn 1
EndProcedure

ProcedureDLL PPTcallback(WindowID,message,wParam,lParam)
  UseJPEGImageDecoder()
  UsePNGImageDecoder()
  UseTIFFImageDecoder()
  UseTGAImageDecoder()
  scrollareachild=pptLVstruct(a)\scrollareachild
  scrollareachildfirstchild=GetWindow_(scrollareachild,#GW_CHILD)
  scrollareachildnextchild=GetWindow_(scrollareachildfirstchild,#GW_HWNDNEXT)
  scrollareachildlastchild=GetWindow_(scrollareachildfirstchild,#GW_HWNDLAST)
  result=#PB_ProcessPureBasicEvents
  Select message
    Case #WM_COMMAND
      pptnumber=CountList(PptLVnumber())
      For a=0 To pptnumber-1
        ClearList(FindChild())
        EnumChildWindows_(pptLVstruct(a)\scrollareachild, @EnumChildProc(), 0)
        ResetList(FindChild())
        ForEach FindChild()
          Index = ListIndex(FindChild())
          If lParam = FindChild()\childwindowhandle
            result=SendMessage_(lParam ,#BM_GETCHECK,0,0)
            SendMessage_(FindChild()\childwindowhandle,#BM_SETCHECK,#BST_CHECKED,0)
            ForEach FindChild()
              If lParam <> FindChild()\childwindowhandle
                SendMessage_(FindChild()\childwindowhandle,#BM_SETCHECK,#BST_UNCHECKED,0)
              EndIf
            Next
          EndIf
        Next
      Next
  EndSelect
  ProcedureReturn result
EndProcedure

ProcedureDLL PPtListview(number,x,y,width,height,Imagenumber)
  AddElement(PptLVnumber())
  LVnumber=CountList(PptLVnumber())
  Index= LVnumber-1
  If Index=number
    imagex=5
    imagewidth=width-30
    imageheightF.f=imagewidth*(5/7)
    imageheightF$=StrF(imageheightF)
    Result$ = StringField(imageheightF$, 1,".")
    imageheight=Val(Result$)
    imagey=0-imageheight
    If Imagenumber>4
      scrollheight=Imagenumber*(imageheight+10)
    Else
      scrollheight=600
    EndIf
    pptLVstruct(Index)\scrollarea=ScrollAreaGadget(#PB_Any, x,y,width,height, width-20,scrollheight, 10)
    pptLVstruct(Index)\scrollareachild=GetWindow_(GadgetID(pptLVstruct(Index)\scrollarea),#GW_CHILD)
    pptLVstruct(Index)\scrollareahandle=GadgetID(pptLVstruct(Index)\scrollarea)
    PptLVnumber()\hwnd =pptLVstruct(Index)\scrollareachild
    CreateImage(999,imagewidth, imageheight)
    StartDrawing(ImageOutput(999))
    Box(0,0,imagewidth, imageheight,#COLOR_BTNFACE)
    StopDrawing()
    For a=1 To Imagenumber
      imagey=imagey+ 6+ imageheight
      pptLVstruct(Index)\childimages[a]=ButtonImageGadget(#PB_Any,imagex,imagey, imagewidth, imageheight, ImageID(999))
      style = GetWindowLong_(GadgetID(pptLVstruct(Index)\childimages[a]), #GWL_STYLE)
      toggleStyle = style |$1003
      SetWindowLong_(GadgetID(pptLVstruct(Index)\childimages[a]), #GWL_STYLE, toggleStyle)
      CreateImage(a,imagewidth-10, imageheight-10)
      StartDrawing(ImageOutput(a))
      Box(0,0,imagewidth, imageheight,RGB(228,225,227))
      StopDrawing()
      SetGadgetState(pptLVstruct(Index)\childimages[a],ImageID(a))
    Next
    CloseGadgetList()
    SetWindowCallback(@PPTcallback())
    ProcedureReturn @pptLVstruct(Index)
  EndIf
EndProcedure

ProcedureDLL GetPPTstate(PPTlistview)
  scrollareachild=pptLVstruct(PPTlistview)\scrollareachild
  ClearList(FindChild())
  EnumChildWindows_(scrollareachild, @EnumChildProc(), 0)
  ResetList(FindChild())
  While NextElement(FindChild())
    Index = ListIndex(FindChild())
    If SendMessage_(FindChild()\childwindowhandle,#BM_GETCHECK,0,0)=#BST_CHECKED
      ProcedureReturn Index+1
      Break
    Else
    EndIf
  Wend
EndProcedure

ProcedureDLL SetPPTstate(PPTlistview,item,State)
  scrollareachild=pptLVstruct(PPTlistview)\scrollareachild
  ClearList(FindChild())
  EnumChildWindows_(scrollareachild, @EnumChildProc(), 0)
  If State =0
    ResetList(FindChild())
    While NextElement(FindChild())
      SendMessage_(FindChild()\childwindowhandle,#BM_SETCHECK,#BST_UNCHECKED,0)
    Wend
  ElseIf State=1
    ResetList(FindChild())
    ForEach FindChild()
      SendMessage_(FindChild()\childwindowhandle,#BM_SETCHECK,#BST_UNCHECKED,0)
    Next
    SelectElement(FindChild(),item-1)
    SendMessage_(GadgetID(pptLVstruct(PPTlistview)\childimages[item]),#BM_SETCHECK,#BST_CHECKED,0)
  EndIf
EndProcedure

ProcedureDLL AddPPTitem(PPTlistview,optionalimage)
  scrollarea=pptLVstruct(PPTlistview)\scrollarea
  scrollareachild=GetWindow_(GadgetID(pptLVstruct(PPTlistview)\scrollarea),#GW_CHILD)
  ClearList(FindChild())
  EnumChildWindows_(scrollareachild, @EnumChildProc(), 0)
  numberimages=CountList(FindChild())
  AddElement(FindChild())
  imagex=5
  width=GadgetWidth(scrollarea)
  y=GadgetY(pptLVstruct(PPTlistview)\childimages[numberimages])
  imagewidth=width-30
  imageheightF.f=imagewidth*(5/7)
  imageheightF$=StrF(imageheightF)
  Result$ = StringField(imageheightF$, 1,".")
  imageheight=Val(Result$)
  imagey=y+imageheight+5
  CreateImage(999,imagewidth, imageheight)
  StartDrawing(ImageOutput(999))
  Box(0,0,imagewidth, imageheight,#COLOR_BTNFACE)
  StopDrawing()
  OpenGadgetList(scrollarea)
  pptLVstruct(PPTlistview)\childimages[numberimages+1]=ButtonImageGadget(#PB_Any,imagex,imagey, imagewidth, imageheight, ImageID(999))
  style = GetWindowLong_(GadgetID(pptLVstruct(PPTlistview)\childimages[numberimages+1]), #GWL_STYLE)
  toggleStyle = style |$1003
  SetWindowLong_(GadgetID(pptLVstruct(PPTlistview)\childimages[numberimages+1]), #GWL_STYLE, toggleStyle)
  If CreateImage(numberimages+1,imagewidth-10, imageheight-10)
    StartDrawing(ImageOutput(numberimages+1))
    Box(0,0,imagewidth, imageheight,RGB(228,225,227))
    StopDrawing()
    SetGadgetState(pptLVstruct(PPTlistview)\childimages[numberimages+1],ImageID(numberimages+1))
  EndIf
  CloseGadgetList()
  If numberimages>4
    scrollheight=(numberimages+1)*(imageheight+10)
    SetGadgetAttribute(scrollarea,#PB_ScrollArea_InnerHeight,scrollheight)
  EndIf
  If optionalimage <> 0 Or optionalimage <>#Null
    numberimages=CountList(FindChild())
    imagewidth=GadgetWidth(PPTimages(numberimages+1))
    imageheight=GadgetHeight(PPTimages(numberimages+1))
    ResizeImage(optionalimage,imagewidth,imageheight)
    SetGadgetState(pptLVstruct(PPTlistview)\childimages[numberimages+1],ImageID(optionalimage))
  EndIf
EndProcedure

ProcedureDLL CountPPTitems(PPTlistview)
  scrollareachild=GetWindow_(GadgetID(pptLVstruct(PPTlistview)\scrollarea),#GW_CHILD)
  ClearList(FindChild())
  EnumChildWindows_(scrollareachild, @EnumChildProc(), 0)
  itemcount=CountList(FindChild())
  ProcedureReturn itemcount
EndProcedure

Procedure DeletePPTitem(PPTlistview,item)
EndProcedure

ProcedureDLL SetPPTitemImage(PPTlistview,item,Image)
  scrollareachild=pptLVstruct(PPTlistview)\scrollareachild
  ClearList(FindChild())
  EnumChildWindows_(scrollareachild, @EnumChildProc(), 0)
  numberimages=CountList(FindChild())
  imagewidth=GadgetWidth(pptLVstruct(PPTlistview)\childimages[numberimages])
  imageheight=GadgetHeight(pptLVstruct(PPTlistview)\childimages[numberimages])
  ResizeImage(Image,imagewidth,imageheight)
  SetGadgetState(pptLVstruct(PPTlistview)\childimages[item],ImageID(Image))
EndProcedure

ProcedureDLL GetPPTitemImage(PPTlistview,item)
  If item=0
  Else
    imagewidth=GadgetWidth(pptLVstruct(PPTlistview)\childimages[item])
    imageheightF.f=imagewidth*(5/7)
    imageheightF$=StrF(imageheightF)
    Result$ = StringField(imageheightF$, 1,".")
    imageheight=Val(Result$)
    width=imagewidth*3
    height=imageheight*3
    imagehandle=SendMessage_(GadgetID(pptLVstruct(PPTlistview)\childimages[item]),#BM_GETIMAGE,#IMAGE_BITMAP,0)
    imagereturn=CreateImage(#PB_Any,width,height)
    StartDrawing(ImageOutput(imagereturn))
    If imagehandle
      DrawImage(imagehandle,0,0,width,height)
    EndIf
    StopDrawing()
  EndIf
  ProcedureReturn imagereturn
EndProcedure

;-Main Program
OpenWindow(0,0,0,680,600,"PPTlistview Test",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
CreateGadgetList(WindowID(0))
PPL=PPtListview(0,5,10,190,500,4)
lll=PPtListview(1,200,10,190,500,3)
ButtonGadget(8,400,10,150,20,"Grab Selected Image")
ButtonGadget(7,400,30,150,20,"Add Image To First Item")
ButtonGadget(1,400,50,150,20,"Get PPTLv State")
ButtonGadget(2,400,70,150,20,"Set PPTLv State To 0")
ButtonGadget(3,400,90,150,20,"Set PPTLv State To 2")
ButtonGadget(5,400,110,150,20,"Add PPTlv Item")
ButtonGadget(6,400,130,150,20,"Count PPTlv Items")
ImageGadget(4,392,170,280,210,0,#PB_Image_Border)
OptionGadget(9,400,410,150,20,"Select PPT Listview 0"):SetGadgetState(9,1)
OptionGadget(10,400,440,150,20,"Select PPT Listview 1")
;-Event Loop
Repeat
  If GetGadgetState(9)=1
    selected=0
  ElseIf GetGadgetState(10)=1
    selected=1
  EndIf

  Select WaitWindowEvent()
    Case  #PB_Event_CloseWindow
      SetWindowCallback(0)
      End
    Case  #PB_Event_Gadget
      Select EventGadget()
        Case 1
          State=GetPPTstate(selected)
          MessageRequester("Info","The PPT Listview State is " + Str(State))
        Case 2
          SetPPTstate(selected,0,0)
        Case 3
          SetPPTstate(selected,2,1)
        Case 5
          AddPPTitem(selected,0)
        Case 6
          number=CountPPTitems(selected)
          MessageRequester("Info" ,"There are" + " " + Str(number) + " "+"Items In the PPT Listview")
        Case 7
          Filename$ = OpenFileRequester("Choose an Image", "", "All Images Formats|*.bmp;*.jpg;*.png;*.tif;*.tga", 0)
          If Filename$
            currentimage=LoadImage(#PB_Any,Filename$)
            SetPPTitemImage(selected,1,currentimage)
          EndIf
        Case 8
          currentimage=GetPPTitemImage(selected,GetPPTstate(selected))
          If currentimage
            ResizeImage(currentimage,GadgetWidth(4)-4,GadgetHeight(4)-4)
            SetGadgetState(4,ImageID(currentimage))
          EndIf
          ;SetPPTitemImage(1,1,currentimage)
        Case PPL
          Debug "ok"
      EndSelect

  EndSelect

ForEver

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP