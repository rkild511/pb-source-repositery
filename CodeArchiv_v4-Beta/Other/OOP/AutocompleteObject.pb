; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8048&highlight=
; Author: Justin (updated for PB 4.00 by Andre)
; Date: 25. October 2003
; OS: Windows
; Demo: No


;Autocomplete object
;Justin 10/03

; Just to play a little with the new functions. An object that makes an autocomplete
; in an editbox / listbox. It's a working example, note that you have to use setsel()
; if the selected listbox index changes outside the object, i did this to improve the
; speed, rather than checking the selected index for every edit change inside the object.
; Only for windows.

Interface IPBAutoComplete
  FindStr(str$)
  SetEdit(id)
  SetListBox(id)
  SetSel(isel)
EndInterface

Structure PBAutoCompleteFunctions
  FindStr.l
  SetEdit.l
  SetListBox.l
  SetSel.l
EndStructure

Structure OPBAutoComplete
  *VTable.PBAutoCompleteFunctions
  hwndedit.l
  hwndlistbox.l
  idedit.l
  idlistbox.l
  iselected.l
EndStructure

;finds and select the passed string
Procedure FindStr(*Object.OPBAutoComplete,str$)
  hwndlistbox=*Object\hwndlistbox
  istr=SendMessage_(hwndlistbox,#LB_FINDSTRING,-1,str$)
  If istr<>-1
    ;skip if item is selected
    If *Object\iselected=istr : ProcedureReturn : EndIf
    textlen=Len(str$)
    
    newtextlen=SendMessage_(hwndlistbox,#LB_GETTEXTLEN,istr,0)
    seltextlen=newtextlen-textlen
    
    ;select
    SendMessage_(hwndlistbox,#LB_SETCURSEL,istr,0)
    ;set edit text
    SetGadgetText(*Object\idedit,GetGadgetItemText(*Object\idlistbox,istr,-1))
    ;set selected text
    SendMessage_(*Object\hwndedit,#EM_SETSEL,textlen,newtextlen)
    
    ;update index
    *Object\iselected=istr
  EndIf
EndProcedure

;sets the editbox for this object
;id : editbox id
Procedure SetEdit(*Object.OPBAutoComplete,id)
  *Object\idedit=id
  *Object\hwndedit=GadgetID(id)
EndProcedure

;sets the listbox for this object
;id : listbox id
Procedure SetListBox(*Object.OPBAutoComplete,id)
  *Object\idlistbox=id
  *Object\hwndlistbox=GadgetID(id)
EndProcedure

;sets the selected listbox index
;iselected : index of selected item
;you are responsable to update this index every time it changes
;-1 = no selection
Procedure SetSel(*Object.OPBAutoComplete,iselected)
  *Object\iselected=iselected
EndProcedure

PBAutoCompleteFunctions.PBAutoCompleteFunctions\FindStr=@FindStr()
PBAutoCompleteFunctions.PBAutoCompleteFunctions\SetEdit=@SetEdit()
PBAutoCompleteFunctions.PBAutoCompleteFunctions\SetListBox=@SetListBox()
PBAutoCompleteFunctions.PBAutoCompleteFunctions\SetSel=@SetSel()

OPBAutoComplete.OPBAutoComplete\VTable=PBAutoCompleteFunctions

;-----------------------------------------------------------------
;CODE

;GADGET IDs
#String0=0
#ListView1=1

;WINDOW ID
#Window1=0

;WINDOW
OpenWindow(#Window1,150,70,550,350,"Auto Complete",#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget|#PB_Window_TitleBar)
CreateGadgetList(WindowID(#Window1))

StringGadget(#String0,10,8,310,24,"")
ListViewGadget(#ListView1,11,49,308,262)

AddGadgetItem(#ListView1,-1,"Red")
AddGadgetItem(#ListView1,-1,"Green")
AddGadgetItem(#ListView1,-1,"Blue")
AddGadgetItem(#ListView1,-1,"Yellow")
AddGadgetItem(#ListView1,-1,"Black")
AddGadgetItem(#ListView1,-1,"White")
AddGadgetItem(#ListView1,-1,"Pink")
AddGadgetItem(#ListView1,-1,"Purple")
AddGadgetItem(#ListView1,-1,"Gray")
AddGadgetItem(#ListView1,-1,"Orange")

SetActiveGadget(#String0)

;create object
OAutoCP.IPBAutoComplete=@OPBAutoComplete

;init object
OAutoCP\SetEdit(#String0)
OAutoCP\SetListBox(#ListView1)
OAutoCP\SetSel(-1) ;no items selected

;EVENT LOOP
Repeat
  EvID=WaitWindowEvent()
  Select EvID
  Case #PB_Event_Gadget
    Select EventGadget()
    Case #String0
      Select EventType()
      Case #PB_EventType_Change
        str$=GetGadgetText(#String0)
        OAutoCP\FindStr(str$)
      EndSelect
      
    Case #ListView1 ;important to update selected index in object
      isel=GetGadgetState(#ListView1)
      ;update selected index
      OAutoCP\SetSel(isel)
      ;set selected in edit
      str$=GetGadgetItemText(#ListView1,isel,-1)
      SetGadgetText(#String0,str$)
    EndSelect
  EndSelect
Until EvID=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
