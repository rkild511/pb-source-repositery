; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7053&highlight=
; Author: Inner (updated for PB 4.00 by Deeem2031)
; Date: 29. July 2003
; OS: Windows
; Demo: Yes

;----------------------------------------------------------------------------- 
;############################################################################# 
;#                                                                           # 
;# Title: Language_Editor.pb                                                 # 
;# Author: T.J.Rougtoon                                                      # 
;#                                                                           # 
;# Copyright Roughton Design 2003 (c)                                        # 
;#                                                                           # 
;############################################################################# 
;----------------------------------------------------------------------------- 
#LANGUAGE_WINDOW = 0 

#GAD_FRAME0 = 0 
#GAD_FRAME1 = 1 
#GAD_FRAME2 = 2 
#GAD_LANGLIST = 3 
#GAD_SAVEAS = 4 
#GAD_OPEN = 5 
#GAD_VALUE = 6 
#GAD_IDX = 7 
#GAD_ADD = 8 
#GAD_DELETE = 9 
;----------------------------------------------------------------------------- 
; 
;----------------------------------------------------------------------------- 
Procedure Open_LanguageWindow() 
  If OpenWindow(#LANGUAGE_WINDOW, 327, 153, 364, 437, "Language Editor", #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered) 
    If CreateGadgetList(WindowID(#LANGUAGE_WINDOW)) 
      Frame3DGadget(#GAD_FRAME0, 0, 5, 365, 355, "Language Content") 
      Frame3DGadget(#GAD_FRAME1, 0, 365, 70, 45, "Index ID") 
      Frame3DGadget(#GAD_FRAME2, 75, 365, 205, 45, "Value") 
      ListIconGadget(#GAD_LANGLIST, 10, 25, 345, 325,"Index",45,#PB_ListIcon_FullRowSelect) 
        AddGadgetColumn(#GAD_LANGLIST,1,"Value",256)    
      ButtonGadget(#GAD_SAVEAS, 285, 390, 75, 20, "Save As...") 
      ButtonGadget(#GAD_OPEN, 285, 365, 75, 20, "Open") 
      ButtonGadget(#GAD_ADD, 155, 415, 100, 20, "Add") 
      ButtonGadget(#GAD_DELETE, 260, 415, 100, 20, "Delete") 
      StringGadget(#GAD_VALUE, 80, 385, 195, 20, "") 
      SpinGadget(#GAD_IDX, 5, 385, 55, 20, 0, 1000) 
      SetGadgetState (#GAD_IDX,0) : SetGadgetText(#GAD_IDX,"0")   ; set initial value  
    EndIf 
  EndIf 
EndProcedure 

Open_LanguageWindow() 

Repeat 
    EventID=WaitWindowEvent() 
    Select EventID 
        Case #PB_Event_Gadget 
            Select EventGadget() 
                Case #GAD_ADD 
                    RemoveGadgetItem(#GAD_LANGLIST,GetGadgetState(#GAD_IDX)) 
                    idx.s=Str(GetGadgetState(#GAD_IDX)) 
                    value.s=GetGadgetText(#GAD_VALUE) 
                    AddGadgetItem(#GAD_LANGLIST,GetGadgetState(#GAD_IDX),idx+Chr(10)+value) 
                Case #GAD_DELETE 
                    For i=0 To CountGadgetItems(#GAD_LANGLIST) 
                        If(GetGadgetItemState(#GAD_LANGLIST,i)=1) 
                            RemoveGadgetItem(#GAD_LANGLIST,i) 
                        EndIf 
                    Next 
                Case #GAD_OPEN 
                    filename.s=OpenFileRequester("Open Language File","","Language File|*.lang",0) 
                    If(filename<>"") 
                        If(OpenFile(0,filename)<>0) 
                            langh.s=Space(4) 
                            ReadData(0,@langh,4) 
                            If(langh="LANG") 
                                items=ReadWord(0) 
                                For i=0 To items 
                                    open_idx=ReadWord(0) 
                                    value_len=ReadWord(0) 
                                    valuebuf.s=Space(value_len) 
                                    ReadData(0,@valuebuf,value_len) 
                                    AddGadgetItem(#GAD_LANGLIST,i,Str(open_idx)+Chr(10)+valuebuf) 
                                Next 
                            Else 
                                MessageRequester("Error","What are you trying to do to me?"+Chr(10)+"this ain't no language file!!!",#PB_MessageRequester_Ok) 
                            EndIf 
                            CloseFile(0) 
                        EndIf    
                    EndIf 
                Case #GAD_SAVEAS 
                    filename.s=SaveFileRequester("Save Language File","","Language File|*.lang",0) 
                    If(filename<>"") 
                        If Right(LCase(filename),4) <> ".lang": filename+".lang":EndIf
                        If(CreateFile(0,filename)<>0) 
                            WriteString(0,"LANG") 
                            WriteWord(0,CountGadgetItems(#GAD_LANGLIST)-1)                        
                            For i=0 To CountGadgetItems(#GAD_LANGLIST)-1 
                                save_idx.s=GetGadgetItemText(#GAD_LANGLIST,i,0)  
                                save_value.s=GetGadgetItemText(#GAD_LANGLIST,i,1)  
                                WriteWord(0,Val(save_idx)) 
                                WriteWord(0,Len(save_value)) 
                                WriteString(0,save_value) 
                            Next 
                            CloseFile(0) 
                        EndIf 
                    EndIf 
                Default 
                    SetGadgetText(#GAD_IDX,Str(GetGadgetState(#GAD_IDX))) 
                    WindowEvent() 
            EndSelect 
    EndSelect 
Until EventID=#PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
