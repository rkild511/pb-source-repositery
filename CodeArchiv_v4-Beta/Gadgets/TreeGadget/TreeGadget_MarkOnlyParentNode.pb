; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3367&highlight=
; Author: nicolaus (updated for PB4.00 by blbltheworm)
; Date: 08. January 2004
; OS: Windows
; Demo: Yes

#File_TreeGadget = 0 

OpenWindow(0,100,100,160,550, "Treegadget-test",#PB_Window_TitleBar | #PB_Window_SystemMenu) 
CreateGadgetList(WindowID(0)) 
TreeGadget(#File_TreeGadget,5,5,150,540,#PB_Tree_CheckBoxes) 
  AddGadgetItem(#File_TreeGadget,0,"Audio") 
    AddGadgetItem(#File_TreeGadget,1,"mp3",0,1) 
    AddGadgetItem(#File_TreeGadget,2,"mp2",0,1) 
    AddGadgetItem(#File_TreeGadget,3,"wav",0,1) 
    AddGadgetItem(#File_TreeGadget,4,"wma",0,1) 
    AddGadgetItem(#File_TreeGadget,5,"asf",0,1) 
    AddGadgetItem(#File_TreeGadget,6,"ogg",0,1) 
    AddGadgetItem(#File_TreeGadget,7,"mid",0,1) 
    AddGadgetItem(#File_TreeGadget,8,"rmi",0,1) 
    AddGadgetItem(#File_TreeGadget,9,"sgt",0,1) 
    AddGadgetItem(#File_TreeGadget,10,"it",0,1) 
    AddGadgetItem(#File_TreeGadget,11,"xm",0,1) 
    AddGadgetItem(#File_TreeGadget,12,"s3m",0,1) 
    AddGadgetItem(#File_TreeGadget,13,"mod",0,1) 
  AddGadgetItem(#File_TreeGadget,14,"Video") 
    AddGadgetItem(#File_TreeGadget,15,"avi",0,1) 
    AddGadgetItem(#File_TreeGadget,16,"mpg",0,1) 
    AddGadgetItem(#File_TreeGadget,17,"mpeg",0,1) 
    AddGadgetItem(#File_TreeGadget,18,"wmv",0,1) 
    AddGadgetItem(#File_TreeGadget,19,"qt",0,1) 
    AddGadgetItem(#File_TreeGadget,20,"dat",0,1) 
    AddGadgetItem(#File_TreeGadget,21,"m2p",0,1) 
  AddGadgetItem(#File_TreeGadget,22,"Picures") 
    AddGadgetItem(#File_TreeGadget,23,"bmp",0,1) 
    AddGadgetItem(#File_TreeGadget,24,"jpg",0,1) 
    AddGadgetItem(#File_TreeGadget,25,"jpeg",0,1) 
    AddGadgetItem(#File_TreeGadget,26,"png",0,1) 
    AddGadgetItem(#File_TreeGadget,27,"tga",0,1) 
    AddGadgetItem(#File_TreeGadget,28,"tiff",0,1) 
    AddGadgetItem(#File_TreeGadget,29,"ico",0,1) 
  
  SetGadgetItemState(#File_TreeGadget,0,#PB_Tree_Expanded) 
  SetGadgetItemState(#File_TreeGadget,14,#PB_Tree_Expanded) 
  SetGadgetItemState(#File_TreeGadget,22,#PB_Tree_Expanded) 

Repeat 
  Delay(1) 
  Event = WindowEvent() 
  
  If Event = #PB_Event_Gadget 
    
    
    GadgetID = EventGadget() 
    
        
    If GadgetID = #File_TreeGadget 
        If GetGadgetItemState(#File_TreeGadget,0) & #PB_Tree_Checked 
          For i = 1 To 13 
            SetGadgetItemState(#File_TreeGadget,i,#PB_Tree_Checked) 
          Next 
        Else 
          For i = 1 To 13 
            SetGadgetItemState(#File_TreeGadget,i,0) 
          Next 
        EndIf 
      
        If GetGadgetItemState(#File_TreeGadget,14) & #PB_Tree_Checked 
          For i = 15 To 21 
            SetGadgetItemState(#File_TreeGadget,i,#PB_Tree_Checked) 
          Next 
        Else 
          For i = 15 To 21 
            SetGadgetItemState(#File_TreeGadget,i,0) 
          Next 
        EndIf 
        If GetGadgetItemState(#File_TreeGadget,22) & #PB_Tree_Checked 
          For i = 23 To 29 
            SetGadgetItemState(#File_TreeGadget,i,#PB_Tree_Checked) 
          Next 
        Else 
          For i = 23 To 29 
            SetGadgetItemState(#File_TreeGadget,i,0) 
          Next 
        EndIf  
    EndIf 
  EndIf 
  
Until Event = #PB_Event_CloseWindow 

End 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
