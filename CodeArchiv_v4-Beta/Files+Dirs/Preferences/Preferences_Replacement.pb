; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1424&highlight=
; Author: dussel (updated for PB 4.00 by Andre)
; Date: 29. December 2004
; OS: Windows, Linux
; Demo: Yes


; Ersatz fuer Preference Befehle:
; - Lege eine neue Gruppe mit Key und Value an
; - Ändere den Value eines Key
; - Füge einen neuen Key einer bestehenden Gruppe hinzu
; - Lösche einen Key (durch value="")
;
;
;   INI Manipulation
;
;   [Replacement for Preference Commandset]
;
;   Author: Dussel (http://www.absolut-marc.de)
;

Procedure.s lib_ini_change_entry(param_filename$,param_group$,param_key$,param_value$)
  ;
  ;   Create new Group
  ;   Add new Key
  ;   Insert new Key
  ;   Delete Key (just set param_value$ to "")

  param_group$  = "["+param_group$+"]"

  tmp_filename$ = param_filename$+".tmp"

  tmp_fid_w = OpenFile(#PB_Any,tmp_filename$)
  tmp_fid_r = ReadFile(#PB_Any,param_filename$)

  If tmp_fid_r
    While Eof(tmp_fid_r)=0
      tmp_zeile$ = ReadString(tmp_fid_r)
      If tmp_zeile$=param_group$
        WriteStringN(tmp_fid_w, tmp_zeile$)
        While tmp_flag_end=0
          tmp_zeile$  = ReadString(tmp_fid_r)
          tmp_pos     = FindString(tmp_zeile$,"=",1)
          If tmp_pos=0
            If tmp_flag_written=0 And Len(param_value$)>0
              WriteStringN(tmp_fid_w, param_key$+"="+param_value$)
              tmp_flag_written=1
            EndIf
            WriteStringN(tmp_fid_w, tmp_zeile$)
            tmp_flag_end=1
          Else
            tmp_zeile2$=Mid(tmp_zeile$,1,tmp_pos-1)
            If tmp_zeile2$ = param_key$
              ; Key found
              If Len(param_value$)>0
                WriteStringN(tmp_fid_w, param_key$+"="+param_value$)
                tmp_flag_written=1
              Else
                tmp_flag_written=1
              EndIf
            Else
              WriteStringN(tmp_fid_w, tmp_zeile$)
            EndIf
          EndIf
        Wend
      Else
        WriteStringN(tmp_fid_w, tmp_zeile$)
      EndIf
    Wend
    CloseFile(tmp_fid_r)
    If tmp_flag_written=0 And Len(param_value$)>0
      ; Add Group with key and values
      WriteStringN(tmp_fid_w, param_group$)
      WriteStringN(tmp_fid_w, param_key$+"="+param_value$)
    EndIf
  Else
    If Len(param_value$)>0
      ; Add Group with key and values
      WriteStringN(tmp_fid_w, param_group$)
      WriteStringN(tmp_fid_w, param_key$+"="+param_value$)
    EndIf
  EndIf

  CloseFile(tmp_fid_w)
  CopyFile(tmp_filename$, param_filename$)
  DeleteFile(tmp_filename$)

EndProcedure



Procedure.s lib_ini_read_entry(param_filename$,param_group$,param_key$)
  ;
  ;

  param_group$  = "["+param_group$+"]"

  tmp_fid_r = ReadFile(#PB_Any,param_filename$)

  If tmp_fid_r
    While Eof(tmp_fid_r)=0 And tmp_flag_end=0
      tmp_zeile$ = ReadString(tmp_fid_r)
      If tmp_zeile$=param_group$
        While tmp_flag_end=0
          tmp_zeile$  = ReadString(tmp_fid_r)
          tmp_pos     = FindString(tmp_zeile$,"=",1)
          If tmp_pos=0
            ; End of Group
            tmp_flag_end=1
          Else
            tmp_zeile2$=Mid(tmp_zeile$,1,tmp_pos-1)
            If tmp_zeile2$ = param_key$
              ; Key found
              retval$=Mid(tmp_zeile$,Len(param_key$)+2,Len(tmp_zeile$)-Len(param_key$)-1)
            EndIf
            tmp_flag_end=1
          EndIf
        Wend
      EndIf
    Wend
    CloseFile(tmp_fid_r)
  EndIf

  ProcedureReturn retval$

EndProcedure



param_filename$ = "./test.txt"

lib_ini_change_entry(param_filename$,"test","key1","1")
lib_ini_change_entry(param_filename$,"test","key1","")
lib_ini_change_entry(param_filename$,"test","key1","Wert1")
lib_ini_change_entry(param_filename$,"test","key2","Wert2")
lib_ini_change_entry(param_filename$,"test","key3","Wert3")
lib_ini_change_entry(param_filename$,"test3","key3","Wert in Test3")
lib_ini_change_entry(param_filename$,"test4","key3","")
lib_ini_change_entry(param_filename$,"test5","key1","Ergebnis Wert1")
lib_ini_change_entry(param_filename$,"test","key1","Wert1 in Key1")


Debug lib_ini_read_entry(param_filename$,"test5","key1")


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -