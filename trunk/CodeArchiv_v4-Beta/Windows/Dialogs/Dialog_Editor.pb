; English forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 10. March 2003
; OS: Windows
; Demo: No


; Example for Dialog-Editor with Password input


;Purebasic Window Editor v2.91

;GADGET IDs
#BT_MSHOW=0
#BT_MCANCEL=1

;DIALOG IDs
#Text0=0
#ED_PASSWORD=1
#BT_OK=2
#BT_CANCEL=3

;WINDOW ID
#Window1=0

Structure PASS
  psw.s
EndStructure


Global hwmain,gcharbuf$,spw.PASS,hinst

gcharbuf$=Space(#MAX_PATH)
hinst=GetModuleHandle_(0)

;Dialog Procedure
Procedure Dialogproc(hdlg,msg,wparam,lparam)
  Select msg
   
    Case #WM_COMMAND
      Select PeekW(@wparam)
        Case #BT_OK
          RtlZeroMemory_(@gcharbuf$,#MAX_PATH)
          GetDlgItemText_(hdlg,#ED_PASSWORD,@gcharbuf$,#MAX_PATH)
          spw\psw=gcharbuf$ 
          EndDialog_(hdlg,1)
          retval=1

        Case #BT_CANCEL
          EndDialog_(hdlg,0)
          retval=1

      EndSelect

    Case #WM_CLOSE
      EndDialog_(hdlg,0)

    Default
      retval=0

  EndSelect
  ProcedureReturn retval
EndProcedure

;WINDOW
hwmain=OpenWindow(#Window1,264,164,257,114,"Main",#PB_Window_SystemMenu|#PB_Window_TitleBar|#PB_Window_ScreenCentered)
CreateGadgetList(WindowID(#Window1))

ButtonGadget(#BT_MSHOW,20,56,90,24,"Show Dialog")
ButtonGadget(#BT_MCANCEL,140,56,90,24,"Cancel")


;EVENT LOOP
Repeat
  EventID=WaitWindowEvent()
    Select EventID
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #BT_MSHOW
            If DialogBoxIndirectParam_(hinst,?dialogdata,hwmain,@Dialogproc(),0)
              MessageRequester("Pass:",spw\psw,0)
            EndIf

          Case #BT_MCANCEL
            close=1

        EndSelect
    EndSelect
Until EventID=#PB_Event_CloseWindow Or close
End

;DIALOG TEMPLATE (Modal)
DataSection
dialogdata:
Data.b 193,8,200,20, 0,0,0,1, 4,0, 181,0, 98,0, 143,0, 59,0
Data.b 0,0, 0,0, 77,0,111,0,100,0,97,0,108,0,32,0,68,0,105,0,97,0,108,0,111,0,103,0,0,0, 1,0, 77,0,83,0,32,0,83,0,97,0,110,0,115,0,32,0,83,0,101,0,114,0,105,0,102,0,0,0 ,0,0

Data.b 0,0,0,80, 0,0,0,0, 7,0, 10,0, 60,0, 15,0, 0,0
Data.b 83,0,116,0,97,0,116,0,105,0,99,0,0,0, 69,0,110,0,116,0,101,0,114,0,32,0,112,0,97,0,115,0,115,0,119,0,111,0,114,0,100,0,58,0,0,0 ,0,0 ,0,0

Data.b 32,0,129,80, 0,0,0,0, 67,0, 10,0, 67,0, 15,0, 1,0
Data.b 69,0,100,0,105,0,116,0,0,0, 0,0 ,0,0

Data.b 0,0,1,80, 0,0,0,0, 7,0, 34,0, 60,0, 15,0, 2,0
Data.b 66,0,117,0,116,0,116,0,111,0,110,0,0,0, 79,0,107,0,0,0 ,0,0

Data.b 0,0,1,80, 0,0,0,0, 73,0, 34,0, 60,0, 15,0, 3,0
Data.b 66,0,117,0,116,0,116,0,111,0,110,0,0,0, 67,0,97,0,110,0,99,0,101,0,108,0,0,0 ,0,0
EndDataSection

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP