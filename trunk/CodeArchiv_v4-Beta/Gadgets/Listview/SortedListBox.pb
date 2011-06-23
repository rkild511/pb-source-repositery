; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13903&highlight=
; Author: Leo (updated for PB 4.00 by Andre)
; Date: 02. February 2005
; OS: Windows
; Demo: Yes


; A hidden sorted ListBox (i.e. ListView Gadget) may be an alternative for
; LinkedLists, Balanced Trees, Hashmaps, SkipList or Associative Arrays.
;
; I made a simple example program to demonstrate that. In the ListBoxList
; 10.000 records are inserted consisting of a 4 character key (only lower
; case alfabeticals from a till z) and of record Data (the order of creation
; of the record). Key and recorddata are seperated by the Horizontal Tab.

; Note:
; The maximum number of items in a listbox depends in the Windows OS.
; For Win95 and Win98 it is 32,768 and for WinNT 4.0, Win2000 and WinXP it is
; 2,147,483,647. The initial loading is somewhat slower for huge amounts
; of items in WINNT 4.0 and up but searching, previous and next is still fast.


;/ Created with PureVisionXP v2.03
;/ Wed, 02 Feb 2005 12:53:25
;/ by Mijnders Automation


;-Global Variables and Constants
Global BubbleTipStyle.l:BubbleTipStyle=0
#PB_Image_BorderRaised =$1

;-Window Constants
Enumeration 1
  #Window_LBList
EndEnumeration
#WindowIndex=#PB_Compiler_EnumerationValue


;-Gadget Constants
Enumeration 1
  ;Window_LBList
  #Gadget_LBList_Frame3D2
  #Gadget_LBList_Text3
  #Gadget_LBList_stKey
  #Gadget_LBList_Text5
  #Gadget_LBList_stRecord
  #Gadget_LBList_stSearch
  #Gadget_LBList_btSearch
  #Gadget_LBList_btFirst
  #Gadget_LBList_cbExact
  #Gadget_LBList_btNext
  #Gadget_LBList_btPrevious
  #Gadget_LBList_btLast
  #Gadget_LBList_Text14


EndEnumeration
#GadgetIndex=#PB_Compiler_EnumerationValue


Procedure.l Window_LBList()
  If OpenWindow(#Window_LBList,82,79,376,258,"ListBox List Demo",#PB_Window_SystemMenu|#PB_Window_ScreenCentered|#PB_Window_Invisible)
    If CreateGadgetList(WindowID(#Window_LBList))
      Frame3DGadget(#Gadget_LBList_Frame3D2,10,10,355,80,"Search Result")
      TextGadget(#Gadget_LBList_Text3,30,35,60,15,"Key",#PB_Text_Right)
      StringGadget(#Gadget_LBList_stKey,100,30,80,20,"")
      TextGadget(#Gadget_LBList_Text5,30,60,60,15,"Record",#PB_Text_Right)
      StringGadget(#Gadget_LBList_stRecord,100,55,250,20,"")
      StringGadget(#Gadget_LBList_stSearch,100,110,80,20,"")
      ButtonGadget(#Gadget_LBList_btSearch,10,110,60,20,"Search")
      ButtonGadget(#Gadget_LBList_btFirst,10,140,60,20,"First")
      CheckBoxGadget(#Gadget_LBList_cbExact,195,115,80,15,"Exact")
      ButtonGadget(#Gadget_LBList_btNext,10,170,60,20,"Next")
      ButtonGadget(#Gadget_LBList_btPrevious,10,200,60,20,"Previous")
      ButtonGadget(#Gadget_LBList_btLast,10,230,60,20,"Last")
      TextGadget(#Gadget_LBList_Text14,195,35,140,15,"10.000 records, key : 4*[a-z] ")
      HideWindow(#Window_LBList,0)
      ProcedureReturn WindowID(#Window_LBList)
    EndIf
  EndIf
EndProcedure


#ListBoxList1   = 25

Procedure.l SetFirst(LBL_Id.l)
  If CountGadgetItems(LBL_Id)=0
    ProcedureReturn -1
  EndIf
  SetGadgetState(LBL_Id,0)
  ProcedureReturn 0
EndProcedure

Procedure.l SetLast(LBL_Id.l)
  Nr=CountGadgetItems(LBL_Id)
  If Nr=0
    ProcedureReturn -1
  EndIf
  SetGadgetState(LBL_Id,Nr-1)
  ProcedureReturn 0
EndProcedure

Procedure.l SetNext(LBL_Id.l)
  Nr=CountGadgetItems(LBL_Id)
  If Nr=0
    ProcedureReturn -1
  EndIf
  S=GetGadgetState(LBL_Id)+1
  If S>Nr-1 Or S<0
    ProcedureReturn -2
  EndIf
  SetGadgetState(LBL_Id,S)
  ProcedureReturn 0
EndProcedure

Procedure.l SetPrevious(LBL_Id.l)
  Nr=CountGadgetItems(LBL_Id)
  If Nr=0
    ProcedureReturn -1
  EndIf
  S=GetGadgetState(LBL_Id)-1
  If S>Nr-1 Or S<0
    ProcedureReturn -2
  EndIf
  SetGadgetState(LBL_Id,S)
  ProcedureReturn 0
EndProcedure

Procedure.l Find(LBL_Id.l,S$)
  S=SendMessage_( GadgetID(LBL_Id), #LB_FINDSTRING, 0, S$)
  If S>=0
    SetGadgetState(LBL_Id,S)
    ProcedureReturn 0
  EndIf
  ProcedureReturn -1
EndProcedure

Procedure Display(LBL_Id)
  S$=GetGadgetText(LBL_Id)
  SetGadgetText(#Gadget_LBList_stKey,StringField(S$,1,Chr(9)))
  SetGadgetText(#Gadget_LBList_stRecord,StringField(S$,2,Chr(9)))
EndProcedure

;-Main Loop
If Window_LBList()

  ListViewGadget(#ListBoxList1,150,285,100,100,#LBS_SORT | #PB_Window_Invisible)

  For i=0 To 10000
    S$=""
    For j=0 To 3
      S$+Chr('a'+Random(25))
    Next
    S$+Chr(9)+"Original Recordnumber : "+Str(i)
    SendMessage_( GadgetID(#ListBoxList1), #LB_ADDSTRING, 0, S$)
  Next


  quitLBList=0
  Repeat
    EventID=WaitWindowEvent()
    Select EventID
      Case #PB_Event_CloseWindow
        If EventWindow()=#Window_LBList
          quitLBList=1
        EndIf


      Case #PB_Event_Gadget
        Select EventGadget()
          Case #Gadget_LBList_stKey
          Case #Gadget_LBList_stRecord
          Case #Gadget_LBList_stSearch
          Case #Gadget_LBList_btSearch
            S$=GetGadgetText(#Gadget_LBList_stSearch)
            If GetGadgetState(#Gadget_LBList_cbExact)=1
              S$+Chr(9)
            EndIf
            If Find(#ListBoxList1,S$)=0
              Display(#ListBoxList1)
            Else
              MessageRequester("Info", "Not found in ListBox List",0)
            EndIf
          Case #Gadget_LBList_btFirst
            If SetFirst(#ListBoxList1)=0
              Display(#ListBoxList1)
            Else
              MessageRequester("Info", "ListBox List empty",0)
            EndIf
          Case #Gadget_LBList_cbExact
          Case #Gadget_LBList_btNext
            If SetNext(#ListBoxList1)=0
              Display(#ListBoxList1)
            Else
              MessageRequester("Info", "No Next in ListBox List",0)
            EndIf
          Case #Gadget_LBList_btPrevious
            If SetPrevious(#ListBoxList1)=0
              Display(#ListBoxList1)
            Else
              MessageRequester("Info", "No Previous in ListBox List",0)
            EndIf
          Case #Gadget_LBList_btLast
            If SetLast(#ListBoxList1)=0
              Display(#ListBoxList1)
            Else
              MessageRequester("Info", "ListBox List empty",0)
            EndIf
        EndSelect

    EndSelect
  Until quitLBList
  CloseWindow(#Window_LBList)
EndIf
End


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP