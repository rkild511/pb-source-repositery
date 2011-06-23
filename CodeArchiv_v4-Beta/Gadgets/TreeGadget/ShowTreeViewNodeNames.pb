; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7929&highlight=
; Author: Fangbeast (updated for PB4.00 by blbltheworm)
; Date: 17. October 2003
; OS: Windows
; Demo: No


;---------------------------------------------------------------------------------------------------------------------------

Enumeration
#Window_Test_Form                             ; Window Constants
EndEnumeration

#WindowIndex = #PB_Compiler_EnumerationValue

Enumeration                                   ; Gadget Constants
#Gadget_Test_Form_Creatures                   ; Window_Test_Form
#Gadget_Test_Form_Messages
#Gadget_Test_Form_Mainframe
EndEnumeration

#GadgetIndex = #PB_Compiler_EnumerationValue

;---------------------------------------------------------------------------------------------------------------------------

Procedure.l Window_Test_Form()
  If OpenWindow(#Window_Test_Form,175,0,700,400,"Test Form",#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_Invisible)
    If CreateGadgetList(WindowID(#Window_Test_Form))
      TreeGadget(#Gadget_Test_Form_Creatures,15,15,225,370)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Physical")
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Human",0,1)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Role",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Swordsman",0,3)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Magician",0,3)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Thief",0,3)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Trader",0,3)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Asassin",0,3)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Politician",0,3)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Cleric",0,3)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Strength",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Level",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Maximum",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Agility",0,1)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Cunning",0,1)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Diplomacy",0,1)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Evil",0,1)
      ;-------------------------------------------
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Alien")
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Role",0,1)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Swordsman",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Magician",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Thief",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Trader",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Asassin",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Politician",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Cleric",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Strength",0,1)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Level",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Maximum",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Agility",0,1)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Cunning",0,1)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Diplomacy",0,1)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Evil",0,1)
      ;------------------------------------------
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Animal")
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Role",0,1)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Swordsman",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Magician",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Thief",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Trader",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Asassin",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Politician",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Cleric",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Strength",0,1)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Level",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Maximum",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Agility",0,1)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Cunning",0,1)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Diplomacy",0,1)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Evil",0,1)
      ;------------------------------------------
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Mythical")
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Role",0,1)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Swordsman",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Magician",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Thief",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Trader",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Asassin",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Politician",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Cleric",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Strength",0,1)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Level",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Maximum",0,2)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Agility",0,1)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Cunning",0,1)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Diplomacy",0,1)
      AddGadgetItem(#Gadget_Test_Form_Creatures, -1, "Evil",0,1)
      
      SendMessage_(GadgetID(#Gadget_Test_Form_Creatures),$111D,0,12189133)
      EditorGadget(#Gadget_Test_Form_Messages,250,15,435,370)
      SendMessage_(GadgetID(#Gadget_Test_Form_Messages),#EM_SETBKGNDCOLOR,0,16703173)
      Frame3DGadget(#Gadget_Test_Form_Mainframe,5,0,690,395,"")
      HideWindow(#Window_Test_Form,0)
      ProcedureReturn WindowID(#Window_Test_Form)
    EndIf
  EndIf
EndProcedure

;---------------------------------------------------------------------------------------------------------------------------

If Window_Test_Form()                             ; Main Loop
  
  QuitTest_Form = 0
  
  Repeat
    EventID = WaitWindowEvent()
    Select EventID
    Case #PB_Event_CloseWindow
      If EventWindow() = #Window_Test_Form
        QuitTest_Form = 1
      EndIf
    Case #PB_Event_Gadget
      Select EventGadget()
      Case #Gadget_Test_Form_Creatures
        Select EventType()
        Case #PB_EventType_LeftClick        : Gosub Test_Tree
        Case #PB_EventType_LeftDoubleClick
        Case #PB_EventType_RightDoubleClick
        Case #PB_EventType_RightClick
          Default
        EndSelect
      Case #Gadget_Test_Form_Messages
      EndSelect
    EndSelect
  Until QuitTest_Form
  CloseWindow(#Window_Test_Form)
EndIf
End

Test_Tree:

If GetGadgetState(#Gadget_Test_Form_Creatures) <> -1
  CurrentItem.l = GetGadgetState(#Gadget_Test_Form_Creatures)
  CurrentText.s = GetGadgetItemText(#Gadget_Test_Form_Creatures, CurrentItem, 0)
  
  ItemToWalk.l = CurrentItem
  FullPath.s   = CurrentText.s
  
  While GetGadgetItemAttribute(#Gadget_Test_Form_Creatures, ItemToWalk,#PB_Tree_SubLevel) > 0
    curSubLevel.l=GetGadgetItemAttribute(#Gadget_Test_Form_Creatures, ItemToWalk,#PB_Tree_SubLevel)
    
    i.l=0
    While curSubLevel<=GetGadgetItemAttribute(#Gadget_Test_Form_Creatures, ItemToWalk-i,#PB_Tree_SubLevel)
      i+1
    Wend
     
    ParentNumber.l = ItemToWalk-i
    
    ParentText.s   = GetGadgetItemText(#Gadget_Test_Form_Creatures, ParentNumber, 0)
    FullPath.s     = ParentText + "/" + FullPath
    ItemToWalk     = ParentNumber
  Wend
  
  If Left(FullPath.s, 1) = "/"
    FullPath.s = Mid(FullPath.s, 2, Len(FullPath.s) - 1)
  EndIf
  AddGadgetItem(#Gadget_Test_Form_Messages, -1, "Line:   " + Str(CurrentItem))
  AddGadgetItem(#Gadget_Test_Form_Messages, -1, "Child:  " + CurrentText)
  AddGadgetItem(#Gadget_Test_Form_Messages, -1, "Parent: " + FullPath.s)
  AddGadgetItem(#Gadget_Test_Form_Messages, -1, "-------------------------------------------")
  
EndIf

Return

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
