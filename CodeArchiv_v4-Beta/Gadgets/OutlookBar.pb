; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7383&highlight=
; Author: Leo (updated for PB 4.00 by Andre)
; Date: 02. March 2005
; OS: Windows
; Demo: No


; With some simple coding an OutLookBar can be created in PureBasic. 
; Here is an example. To run it replace the icons with your own 
; 32*32 icons and replace the path of the calc.exe with the one on 
; your computer. 

  strCompleteFilename.s="c:\windows\calc.exe" 
  
  lngRetValue = ExtractIcon_(0, strCompleteFilename, 0) 
  
    CreateImage(5,32,32) 
    StartDrawing(ImageOutput(5)) 
    Box(0,0,32,32,GetSysColor_(#COLOR_WINDOW)) 
    If lngRetValue 
      DrawImage(lngRetValue,0,0) 
    Else
      Box(5,5,22,22,RGB(250,20,20))
    EndIf
    StopDrawing() 
  
  
  Procedure ResizeProc(A.l) 
    d=0 
    For i=2 To 4 
      HideGadget(i,1) 
      If i-A=1 
        d=200 
      EndIf 
      ResizeGadget(i,#PB_Ignore,20*i-10+d,#PB_Ignore,#PB_Ignore) 
      HideGadget(i,0) 
    Next 
    HideGadget(5,1) 
    ResizeGadget(5,#PB_Ignore,20*(A+1)-10,#PB_Ignore,#PB_Ignore) 
    HideGadget(5,0) 
    ClearGadgetItemList(5) 
;    ChangeListIconGadgetDisplay(5, 0) 
    Select A 
      Case 1 
          AddGadgetItem(5,-1,"Picture 1",ImageID(0)) 
          AddGadgetItem(5,-1,"Picture 2",ImageID(1)) 
          AddGadgetItem(5,-1,"Picture 3",ImageID(2)) 
          AddGadgetItem(5,-1,"Picture 4",ImageID(3)) 
          AddGadgetItem(5,-1,"Picture 5",ImageID(1)) 
          AddGadgetItem(5,-1,"Picture 6",ImageID(2)) 
          AddGadgetItem(5,-1,"Picture 7",ImageID(3)) 
      Case 2 
          AddGadgetItem(5,-1,"Picture 1",ImageID(1)) 
          AddGadgetItem(5,-1,"Picture 2",ImageID(1)) 
          AddGadgetItem(5,-1,"Picture 3",ImageID(1)) 
          AddGadgetItem(5,-1,"Picture 4",ImageID(0)) 
          AddGadgetItem(5,-1,"Picture 5",ImageID(2)) 
          AddGadgetItem(5,-1,"Picture 6",ImageID(3)) 
          AddGadgetItem(5,-1,"Picture 7",ImageID(1)) 
      Case 3 
          AddGadgetItem(5,-1,"Picture 1",ImageID(2)) 
          AddGadgetItem(5,-1,"Picture 2",ImageID(1)) 
          AddGadgetItem(5,-1,"Picture 3",ImageID(0)) 
          AddGadgetItem(5,-1,"Picture 4",ImageID(2)) 
          AddGadgetItem(5,-1,"Picture 5",ImageID(2)) 
          AddGadgetItem(5,-1,"Picture 6",ImageID(3)) 
          AddGadgetItem(5,-1,"Picture 7",ImageID(2)) 
      Case 4 
          AddGadgetItem(5,-1,"Picture 1",ImageID(3)) 
          AddGadgetItem(5,-1,"Picture 2",ImageID(0)) 
          AddGadgetItem(5,-1,"Picture 3",ImageID(1)) 
          AddGadgetItem(5,-1,"Picture 4",ImageID(2)) 
          AddGadgetItem(5,-1,"Picture 5",ImageID(3)) 
          AddGadgetItem(5,-1,"Picture 6",ImageID(3)) 
          AddGadgetItem(5,-1,"Picture 7",ImageID(3)) 
      Default 
    EndSelect 
  EndProcedure  
  
  If OpenWindow(0,0,0,430,300,"Outlook Bar Control",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
    ButtonGadget(1, 10,  10, 100, 20, "Area 1") 
    ButtonGadget(2, 10, 230, 100, 20, "Area 2") 
    ButtonGadget(3, 10, 250, 100, 20, "Area 3") 
    ButtonGadget(4, 10, 270, 100, 20, "Area 4") 
    ListIconGadget(5,10,30,100,200, "",200) 
    ListViewGadget(6,120,10,300,280) 
    ChangeListIconGadgetDisplay(5, #PB_ListIcon_LargeIcon) 
    LoadImage(0,"../Graphics/Gfx/file.ico")
    LoadImage(1,"../Graphics/Gfx/folder.ico")
    LoadImage(2,"../Graphics/Gfx/font.ico")
    LoadImage(3,"../Graphics/Gfx/stop.ico")
;     LoadImage(0,"windowcat.ico") 
;     LoadImage(1,"winterwindow.ico") 
;     LoadImage(2,"hallwnwindow.ico") 
;     LoadImage(3,"xmaswindow.ico") 
    Area=1
    ResizeProc(1) 
    Repeat 
      eid=WaitWindowEvent() 
      ;         Debug eid 
      Select eid 
        Case #PB_Event_Gadget 
          Select EventGadget() 
            Case 1 
              Area=1 
              ResizeProc(1) 
            Case 2 
              Area=2 
              ResizeProc(2) 
            Case 3 
              Area=3 
              ResizeProc(3) 
            Case 4 
              Area=4 
              ResizeProc(4) 
            Case 5 
              If GetGadgetState(5)>-1 
                AddGadgetItem(6,-1,"Area "+Str(Area)+" Picture "+Str(GetGadgetState(5)+1)) 
                If Area=1 And GetGadgetState(5)=6 
                  RunProgram("c:\windows\calc.exe") 
                EndIf  
              EndIf  
          EndSelect    
      EndSelect 
      
    Until eid=#PB_Event_CloseWindow 
  EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP