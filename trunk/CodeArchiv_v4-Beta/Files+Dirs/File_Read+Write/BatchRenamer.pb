; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8342&highlight=
; Author: bcgreen (corrected Henrik, updated for PB4.00 by blbltheworm)
; Date: 15. November 2003
; OS: Windows
; Demo: Yes


Enumeration 
  #Window_0 
EndEnumeration 

Enumeration 
  #oldextbox 
  #newextbox 
  #renamebutton 
  #browsebutton 
  #Gadget_5 
  #Gadget_6 
  #listbox 
EndEnumeration 


Global path$ ; <- ****** changed ******* 


Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 259, 121, 652, 359, "batchRenamer",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
    If CreateGadgetList(WindowID(#Window_0)) 
      StringGadget(#oldextbox, 30, 330, 110, 20, "") 
      StringGadget(#newextbox, 260, 330, 120, 20, "") 
      ButtonGadget(#renamebutton, 150, 330, 100, 20, "Rename File!") 
      ButtonGadget(#browsebutton, 20, 10, 140, 30, "Browse For Folder") 
      TextGadget(#Gadget_5, 30, 310, 110, 20, "Old Extension:") 
      TextGadget(#Gadget_6, 260, 310, 120, 20, "New Extension:") 
      ListViewGadget(#listbox, 20, 50, 620, 260) 
      
    EndIf 
  EndIf 
EndProcedure 


Procedure listfiles(SomeString$) ; <- ****** changed ******* 

path$=SomeString$ ; <- ****** changed ******* 

  result = ExamineDirectory(1, path$, "*.*") 
  If result = 0: MessageRequester("Error!", "Can't open directory!"):ProcedureReturn:EndIf 
  ClearGadgetItemList(#listbox) 
  Repeat 
   result = NextDirectoryEntry(1) 
  If result = 1 
    AddGadgetItem(#listbox, -1, DirectoryEntryName(1)) 
  ElseIf result = 0 
    ProcedureReturn 
  EndIf 
  ForEver 
EndProcedure 

Procedure renamefiles(oldext$, newext$) 
  ExamineDirectory(1, path$, "*.*") 
  ClearGadgetItemList(#listbox) 
  Repeat 
    result = NextDirectoryEntry(1) 
    If result = 1 
      filename$ = DirectoryEntryName(1) 
      oldfilename$ = filename$ 
        If Right(filename$, 3) = oldext$ 
          filename$ = Left(filename$, Len(filename$)-3) + newext$ 
          RenameFile(path$ + oldfilename$, path$ + filename$) 
        EndIf 
    AddGadgetItem(#listbox, -1, filename$) 
    ElseIf result = 0 
    ProcedureReturn 
    EndIf 
  ForEver 
EndProcedure 

;Global path$ 

Open_Window_0() 

Repeat 
  
  Event = WaitWindowEvent() 
  
  If Event = #PB_Event_Gadget 
    
    GadgetID = EventGadget() 
    
    If GadgetID = #renamebutton 
      If GetGadgetText(#oldextbox) = "" Or GetGadgetText(#newextbox) = "" 
        MessageRequester("Error!", "No extensions specified!") 
      ElseIf path$ = "" 
        MessageRequester("Error!", "No path specified!") 
      Else 
      oldext$ = GetGadgetText(#oldextbox) 
      newext$ = GetGadgetText(#newextbox) 
      renamefiles(oldext$, newext$) 
      EndIf 
      
    ElseIf GadgetID = #browsebutton 
      path$ = PathRequester("Choose a folder:", "") 
      listfiles(path$) 
    EndIf 
    
  EndIf 
  
Until Event = #PB_Event_CloseWindow 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
