; English forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 23. January 2003
; OS: Windows
; Demo: No

If OpenWindow(0,200,200,300,150,"test",#PB_Window_SystemMenu)
  CreateGadgetList(WindowID(0))
  t$="This text goes inside a multiline StringGadget."+Chr(13)+Chr(10)
  For r=2 To 10 : t$+Str(r)+Chr(13)+Chr(10) : Next
  StringGadget(0,10,10,200,100,t$,#ES_MULTILINE|#ES_AUTOVSCROLL|#WS_VSCROLL|#WS_HSCROLL)
  ButtonGadget(1,230,10,50,20,"Save")
  ButtonGadget(2,230,40,50,20,"Load")
  ButtonGadget(3,230,70,50,20,"Info")
  Repeat
    ev=WaitWindowEvent()
    If ev=#PB_Event_Gadget
      Select EventGadget()
        Case 1 ; Save
          If CreateFile(0,"MultiLine.txt")
            WriteStringN(0,GetGadgetText(0))
            CloseFile(0)
          EndIf
        Case 2 ; Load
          If ReadFile(0,"MultiLine.txt")
            A$=""
            Repeat
              A$+ReadString(0)+Chr(13)+Chr(10)
            Until Eof(0)<>0
            CloseFile(0)
            SetGadgetText(0,A$)
          EndIf
        Case 3 ; Info
          lines=SendMessage_(GadgetID(0),#EM_GETLINECOUNT,0,0)
          where=SendMessage_(GadgetID(0),#EM_LINEFROMCHAR,-1,0)+1
          MessageRequester("Info",Str(lines)+" lines in the box."+Chr(13)+"You are on line "+Str(where)+".",0)
      EndSelect
    EndIf
  Until ev=#PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -