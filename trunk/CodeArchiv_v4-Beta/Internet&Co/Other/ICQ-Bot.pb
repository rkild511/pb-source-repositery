; www.purearea.net (Sourcecode collection by cnesm)
; Author: Deeem2031 (updated for PB3.93 by ts-soft, updated for PB 4.00 by Andre)
; Date: 22. November 2003
; OS: Windows
; Demo: No

#Gadget_0 = 0 
#Gadget_text_version = 1 
#Gadget_User = 2 
#Gadget_Text = 3 
#Gadget_Nachrichten = 4 
#Gadget_Text_abbr = 5 
#Gadget_Text_ok  = 6 
#Gadget_username = 7 
#Gadget_Art = 8 
#Gadget_Zeit = 9 
#Gadget_12 = 10 
#Gadget_Nachricht_add = 11 
#Gadget_Nachricht_edit = 12 
#Gadget_User_add = 13 
#gadget_user_edit = 14 
#gadget_language = 15 
#gadget_stext = 16 

Structure window 
  name.s 
  handle.l 
EndStructure 

Global NewList win.window() 

Structure text 
  name.s 
  text.s 
  timer.l 
  time.l 
  art.l 
EndStructure 

Structure user 
  name.s 
  a.b[100] 
EndStructure 

Global NewList u.user() 
Global NewList t.text() 
;NewList s.send() 

Global tmp.l 
Global sendwindowhandle.l 
Global sendbuttonhandle.l 
Global timediff.l 
Global lasttime.l 
Global titlepart.s 
titlepart = "Nachrichtensitzung" 
Global sendbuttonname.s 
sendbuttonname = "&Senden" 


Procedure getsendwindow(handle.l,lParam.l) 
  If tmp = 0 
    sendwindowhandle = handle 
  EndIf 
  tmp + 1 
  buffer = AllocateMemory(1024) 
  GetWindowText_(handle,buffer,1024) 
  name.s = PeekS(buffer) 
  If name = sendbuttonname 
    sendbuttonhandle = handle 
  EndIf 
  ProcedureReturn #True 
EndProcedure 

Procedure sendtext(handle.l,text.s) 
  tmp = 0 
  EnumChildWindows_(handle.l,@getsendwindow(),0) 
  str.s 
  len = SendMessage_(sendwindowhandle,#WM_GETTEXTLENGTH,0,0) 
  If len 
    SendMessage_(sendwindowhandle,#EM_GETSEL,@cursors.l,@cursore.l) 
    string = AllocateMemory(len) 
    SendMessage_(sendwindowhandle,#WM_GETTEXT,len,string) 
    str = Trim(PeekS(string,len)) 
;     text = str.s+Chr(13)+Chr(10)+text 
    FreeMemory(string) 
  EndIf 
  ;text = " " 
  SendMessage_(sendwindowhandle,#WM_SETTEXT,0,@text) 
  EnableWindow_(sendbuttonhandle,1) 
;  enumchildwindows_(handle.l,@getsendwindow(),0) 
;  sendmessage_(sendbuttonhandle,#wm_enable,1,0) 
  Repeat 
  SendMessage_(sendbuttonhandle,#WM_LBUTTONDOWN,#MK_LBUTTON,0) 
  SendMessage_(sendbuttonhandle,#WM_LBUTTONUP,#MK_LBUTTON,0) 
  Delay(100) 
  Until SendMessage_(sendwindowhandle,#WM_GETTEXTLENGTH,0,0) = 0 
  SendMessage_(sendwindowhandle,#WM_SETTEXT,0,@str) 
  SendMessage_(sendwindowhandle,#EM_SETSEL,cursors.l,cursore.l) 
;  setwindowtext_(sendwindowhandle,@text) 
EndProcedure 

Procedure getname(handle.l,lParam.l) 
  buffer = AllocateMemory(1024) 
  GetWindowText_(handle,buffer,1024) 
  name.s = PeekS(buffer) 
  AddElement(win())  
  If FindString(name,titlepart,1) : win()\name = name : win()\handle=handle 
    If FirstElement(u()) 
      For i = 1 To CountList(u()) 
        If FindString(name,u()\name,1) > 0 And GetGadgetItemState(#Gadget_User,i-1) & #PB_Tree_Checked 
          GetLocalTime_(@date.systemtime) 
;          sendtext(win()\handle,"Bot: System-Zeit:"+Str(date\wday)+"."+Str(date\wmonth)+"."+Str(date\wyear)+" "+Str(date\whour)+":"+Str(date\wminute)+":"+Str(date\wsecond)) 
;          sendtext(win()\handle,"Bot: Win98 ist besser als WinXP") 
;          sendtext(win()\handle,"Bot: Email ist immer noch nicht da.") 
;          sendtext(win()\handle,"BOT: _,-"+Chr(34)+"´´"+Chr(34)+"-,_,-"+Chr(34)+"´´"+Chr(34)+"-,_,-"+Chr(34)+"´´"+Chr(34)+"-,") 
    ;      sendtext(win()\handle,"BOT: Test (Nachricht wiederholt sich jede 10 Sekunden)") 
          If FirstElement(t()) 
          For i =  1 To 99 
            If u()\a[i] 
              t()\time - timediff 
              If t()\time <= 0 
                If t()\art = 1 
                  t()\time = t()\timer;*1000 
                ElseIf t()\art = 2 
                  t()\time = Random(t()\timer) 
                EndIf 
                sendtext(win()\handle,t()\text) 
              EndIf 
            EndIf 
          NextElement(t()) 
          Next 
          EndIf 
        EndIf 
        NextElement(u()) 
      Next 
    EndIf 
;    If FirstElement(s()) 
;      For i = 1 To CountList(s()) 
;        del = 0 
;        If FindString(name,s()\user,1) > 0 
;          s()\time - timediff 
;          If s()\time < 0 
;            sendtext(win()\handle,s()\text) 
;            DeleteElement(s()) 
;            del = 1 
;          EndIf 
;        EndIf 
;        If del = 0 
;          NextElement(s()) 
;        EndIf 
;      Next 
;    EndIf 
  EndIf 
  FreeMemory(buffer) 
  ProcedureReturn #True 
EndProcedure 

If CreateGadgetList(OpenWindow(0,0, 0, 600, 300, "ICQ-Bot V1.1",  #PB_Window_SystemMenu | #PB_Window_TitleBar |#PB_Window_ScreenCentered | #PB_Window_MinimizeGadget)) 
  PanelGadget(#Gadget_0, 0, 0, 600, 300) 
  AddGadgetItem(#Gadget_0, -1, "Haupteinstellungen") 
;  CheckBoxGadget(#Gadget_1, 8, 8, 200, 20, "Bei Systemstart mitstarten (Autostart)") 
  TextGadget(#Gadget_text_version,8,8,200,20,"ICQ-Version:") 
  ComboBoxGadget(#gadget_language,392,8,200,60) 
  AddGadgetItem(#gadget_language,-1,"Deutsch") 
  AddGadgetItem(#gadget_language,-1,"Englisch") 
  SetGadgetState(#gadget_language,0) 
  AddGadgetItem(#Gadget_0, -1, "Nachrichten Einstellungen") 
  StringGadget(#Gadget_username,8,8,190,20,"Username") 
  DisableGadget(#Gadget_username,1) 
  TreeGadget(#Gadget_User, 8, 36, 190, 200,#PB_Tree_AlwaysShowSelection | #PB_Tree_NoLines | #PB_Tree_CheckBoxes) 
  GadgetToolTip(#Gadget_User, "User") 
  ButtonGadget(#Gadget_User_add , 8, 244, 91 ,20,"User hinzufügen") 
  ButtonGadget(#gadget_user_edit , 109, 244, 91 ,20,"User editieren") 
;  ListViewGadget(#Gadget_Textgruppe, 208, 8, 180, 50) 
;  ButtonGadget(#Gadget_Textgruppe_add, 208, 68, 180, 20, "Text-Gruppe hinzufügen") 
;  SpinGadget(#Gadget_Textnummer, 528, 8, 60, 20, 1, 10) 
;  SetGadgetState(#Gadget_Textnummer,1) 
;  TextGadget(#Gadget_9, 398, 8, 120, 20, "Text-Nummer:") 
  ListViewGadget(#Gadget_Art, 208, 8, 180, 40) 
  StringGadget(#Gadget_Zeit, 318, 58, 70, 20, "",#PB_String_Numeric) 
  DisableGadget(#Gadget_Art,1) 
  DisableGadget(#Gadget_Zeit,1) 
  TextGadget(#Gadget_12, 208, 58, 110, 20, "(Maximal-)Zeit (in sek.):") 
  StringGadget(#Gadget_Text, 208, 88, 180, 146, "Nachricht",#ES_MULTILINE) 
  ButtonGadget(#Gadget_Text_ok,208, 244,86,20,"OK") 
  ButtonGadget(#Gadget_Text_abbr,302, 244,86,20,"Abbrechen") 
  DisableGadget(#Gadget_Text,1) 
  DisableGadget(#Gadget_Text_ok,1) 
  DisableGadget(#Gadget_Text_abbr,1) 
  TreeGadget(#Gadget_Nachrichten, 398, 8, 190, 228,#PB_Tree_AlwaysShowSelection | #PB_Tree_NoLines | #PB_Tree_CheckBoxes) 
  GadgetToolTip(#Gadget_Nachrichten, "Nachrichten") 
  DisableGadget(#Gadget_Nachrichten,1) 
  ButtonGadget(#gadget_nachricht_add , 398, 244, 91 ,20,"Nachricht hinzufügen") 
  DisableGadget(#Gadget_Nachricht_add,1) 
  ButtonGadget(#gadget_nachricht_edit , 499, 244, 91 ,20,"Nachricht editieren") 
  DisableGadget(#Gadget_Nachricht_edit,1) 
;  OptionGadget(#Gadget_Nachricht_add, 208, 178, 180, 20, "An Nachricht anhägen") 
;  OptionGadget(#Gadget_Nachricht_extra, 208, 198, 180, 20, "Extra Nachricht erstellen") 
  AddGadgetItem(#gadget_art,-1,"In bestimmten Zeitabständen") 
  AddGadgetItem(#gadget_art,-1,"Zufällige Zeitabstände") 
;  AddGadgetItem(#gadget_art,-1,"Wenn Nachricht geschrieben wird") 
  StringGadget(#gadget_stext,208,88,180,20,"") 
  HideGadget(#gadget_stext,1) 
  CloseGadgetList() 
EndIf 

Repeat 
  timediff = timeGetTime_() - lasttime 
  lasttime = timeGetTime_() 
  If lasttime - timer > 1000 
    ClearList(win()) 
    EnumWindows_(@getname(),0) 
;    text.s = "" 
;    FirstElement(win()) 
;    For i = 1 To CountList(win()) 
;      If win()\name <> "" 
;        text + win()\name + " (Handle:"+Str(win()\handle)+" Hex:"+Hex(win()\handle)+")" + Chr(13) + Chr(10) 
;      EndIf 
;      NextElement(win()) 
;    Next 
;    SetGadgetText(0,text) 
    timer = timeGetTime_() 
  EndIf 
  
  
  
  Select WindowEvent() 
    Case #PB_Event_CloseWindow 
      quit = 1 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case #gadget_language 
          Select GetGadgetState(#gadget_language) 
            Case 0 
              titlepart = "Nachrichtensitzung" 
              sendbuttonname = "&Senden" 
            Case 1 
              titlepart = "Message Session" 
              sendbuttonname = "&Send" 
          EndSelect 
        Case #gadget_user_add 
          AddGadgetItem(#gadget_user,-1,"Neuer User") 
          AddElement(u()) 
          u()\name = "Neuer User" 
          If GetGadgetState(#gadget_user) = -1 
;           SetGadgetState(#gadget_user,0) 
          EndIf 
        Case #gadget_user_edit 
          If GetGadgetState(#gadget_user) >= 0 
          SelectElement(u(),GetGadgetState(#gadget_user)) 
          If GetGadgetText(#gadget_user_edit) <> "OK" 
;            u()\name = InputRequester("","Name eingeben!","") 
;            SetGadgetItemText(#gadget_user,GetGadgetState(#gadget_user),u()\name,0) 
            DisableGadget(#gadget_user,1) 
;            DisableGadget(#gadget_user_edit,1) 
            SetGadgetText(#gadget_user_edit,"OK") 
            DisableGadget(#gadget_user_add,1) 
            DisableGadget(#gadget_username,0) 
            SetGadgetText(#gadget_username,u()\name) 
            DisableGadget(#gadget_nachrichten,0) 
            DisableGadget(#gadget_nachricht_add,0) 
            DisableGadget(#gadget_nachricht_edit,0) 
;            DisableGadget(#gadget_text_ok,0) 
;            DisableGadget(#gadget_text_abbr,0) 
            For i = 1 To CountGadgetItems(#gadget_nachrichten) 
              If u()\a[i] 
                SetGadgetItemState(#gadget_nachrichten,i-1,#PB_Tree_Checked) 
              Else 
                SetGadgetItemState(#gadget_nachrichten,i-1,0) 
              EndIf 
            Next 
          Else 
            DisableGadget(#gadget_user,0) 
            SetGadgetText(#gadget_user_edit,"User editieren") 
            DisableGadget(#gadget_user_add,0) 
            DisableGadget(#gadget_username,1) 
            u()\name = GetGadgetText(#gadget_username) 
            SetGadgetItemText(#gadget_user,GetGadgetState(#gadget_user),u()\name,0) 
            SetGadgetText(#gadget_username,"Username") 
            DisableGadget(#gadget_nachrichten,1) 
            DisableGadget(#gadget_nachricht_add,1) 
            DisableGadget(#gadget_nachricht_edit,1) 
            For i = 1 To CountGadgetItems(#gadget_nachrichten) 
              u()\a[i] = GetGadgetItemState(#gadget_nachrichten,i-1) & #PB_Tree_Checked 
            Next 
          EndIf 
          EndIf 
        Case #gadget_user 
          If FirstElement(u()) 
          If GetGadgetState(#gadget_user) > 0 
            For i = 1 To GetGadgetState(#gadget_user)-1 
              NextElement(u()) 
            Next 
            EndIf 
            u()\a[0] = GetGadgetItemState(#gadget_user,GetGadgetState(#gadget_user)) & #PB_Tree_Checked            
          EndIf 
        Case #gadget_art 
          Select GetGadgetState(#gadget_art) 
            Case 0 
              SetGadgetText(#gadget_12,"Zeit-Abstand:") 
              HideGadget(#gadget_zeit,0) 
              HideGadget(#gadget_stext,1) 
              ResizeGadget(#gadget_text,208,88,180,146) 
            Case 1 
              SetGadgetText(#gadget_12,"Maximale Zeit:") 
              HideGadget(#gadget_zeit,0) 
              HideGadget(#gadget_stext,1) 
              ResizeGadget(#gadget_text,208,88,180,146) 
            Case 2 
              SetGadgetText(#gadget_12,"Nachricht:") 
              HideGadget(#gadget_zeit,1) 
              HideGadget(#gadget_stext,0) 
              ResizeGadget(#gadget_text,208,116,180,118) 
              ;redrawwindow_(GadgetID(#gadget_text),0,0,0) 
          EndSelect 
        Case #gadget_nachrichten 
          If FirstElement(u()) 
          If GetGadgetState(#gadget_user) > 0 
            For i = 1 To GetGadgetState(#gadget_user)-1 
              NextElement(u()) 
            Next 
          EndIf 
          u()\a[GetGadgetState(#gadget_nachrichten)+1] = GetGadgetItemState(#gadget_nachrichten,GetGadgetState(#gadget_nachrichten)) & #PB_Tree_Checked 
          EndIf 
        Case #gadget_nachricht_add 
          AddGadgetItem(#gadget_nachrichten,-1,"Neue Nachricht ") 
          AddElement(t()) 
          t()\timer = 10 
          If GetGadgetState(#gadget_nachrichten) = -1 
;            SetGadgetState(#gadget_nachrichten,0) 
          EndIf 
;        Case #gadget_text 
;          If GetGadgetState(#gadget_nachrichten) <> letztenachricht And FirstElement(t()) 
;            For i = 1 To GetGadgetState(#gadget_nachrichten)-1 
;              NextElement(t()) 
;            Next 
;            letztenachricht = GetGadgetState(#gadget_nachrichten) 
;            SetGadgetText(#gadget_text,t()\text) 
;          EndIf 
;          If FirstElement(t()) 
;            For i = 1 To GetGadgetState(#gadget_nachrichten)-1 
;              NextElement(t()) 
;            Next 
;            t()\text = GetGadgetText(#gadget_text) 
;            Debug t()\text 
;          EndIf 
        Case #gadget_nachricht_edit 
          If FirstElement(t()) And GetGadgetState(#gadget_nachrichten) >= 0 
            If GetGadgetState(#gadget_nachrichten) > 0 
            For i = 1 To GetGadgetState(#gadget_nachrichten) 
              NextElement(t()) 
            Next 
            EndIf 
            DisableGadget(#gadget_nachricht_edit,1) 
            DisableGadget(#gadget_nachrichten,1) 
            DisableGadget(#gadget_nachricht_add,1) 
            DisableGadget(#Gadget_Text,0) 
            DisableGadget(#Gadget_Text_ok,0) 
            DisableGadget(#Gadget_Text_abbr,0) 
            DisableGadget(#Gadget_art,0) 
            DisableGadget(#Gadget_zeit,0) 
            DisableGadget(#gadget_user_edit,1) 
            SetGadgetText(#gadget_text,t()\text) 
            SetGadgetText(#gadget_zeit,Str(t()\timer)) 
            If t()\art > 0 
              SetGadgetState(#gadget_art,t()\art-1) 
            Else 
              SetGadgetState(#gadget_art,0) 
            EndIf 
;            DisableGadget(#gadget_nachricht_edit,1) 
;            t()\name = InputRequester("","Name eingeben!","") 
;            SetGadgetItemText(#gadget_nachrichten,GetGadgetState(#gadget_nachrichten),t()\name,0) 
          EndIf 
        Case #gadget_text_ok 
            DisableGadget(#gadget_nachricht_edit,0) 
            DisableGadget(#gadget_nachrichten,0) 
            DisableGadget(#gadget_nachricht_add,0) 
            DisableGadget(#Gadget_Text,1) 
            DisableGadget(#Gadget_Text_ok,1) 
            DisableGadget(#Gadget_Text_abbr,1) 
            DisableGadget(#Gadget_art,1) 
            DisableGadget(#Gadget_zeit,1) 
            DisableGadget(#gadget_user_edit,0) 
            If GetGadgetState(#gadget_nachrichten) >= 0 And FirstElement(t()) 
            If GetGadgetState(#gadget_nachrichten) > 0 
              For i = 1 To GetGadgetState(#gadget_nachrichten) 
                NextElement(t()) 
              Next 
              EndIf 
              t()\text = GetGadgetText(#gadget_text) 
              t()\name = Left(GetGadgetText(#gadget_text),20) 
              SetGadgetItemText(#gadget_nachrichten,GetGadgetState(#gadget_nachrichten),t()\name,0) 
              t()\timer = Val(GetGadgetText(#gadget_zeit)) 
              t()\art = GetGadgetState(#gadget_art)+1 
          EndIf 
        Case #gadget_text_abbr 
          DisableGadget(#gadget_nachricht_edit,0) 
          DisableGadget(#gadget_nachrichten,0) 
          DisableGadget(#gadget_nachricht_add,0) 
          DisableGadget(#Gadget_Text,1) 
          DisableGadget(#Gadget_Text_ok,1) 
          DisableGadget(#Gadget_Text_abbr,1) 
          DisableGadget(#Gadget_art,1) 
          DisableGadget(#Gadget_zeit,1) 
          DisableGadget(#gadget_user_edit,0) 
        Case #gadget_zeit 
            If GetGadgetState(#gadget_nachrichten) >= 0 And FirstElement(t()) 
            If GetGadgetState(#gadget_nachrichten) > 0 
              For i = 1 To GetGadgetState(#gadget_nachrichten) 
                NextElement(t()) 
              Next 
            EndIf 
            t()\timer = Val(GetGadgetText(#gadget_zeit)) 
            EndIf 
      EndSelect 
  EndSelect 
Until quit = 1

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger