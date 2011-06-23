; German forum:
; Author: Helge  (updated for PB4.00 by blbltheworm)
; Date: 08. August 2002
; OS: Windows
; Demo: No
 
If OpenWindow(0, 100, 100, 500,400, "PureBasic Window", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
If CreateGadgetList(WindowID(0))
  Textbox=StringGadget(0,  10, 30, 480, 360, "",#ES_MULTILINE|#ES_AUTOVSCROLL|#WS_VSCROLL |#WS_HSCROLL)
   Label=TextGadget(1,1,1,400,22,"INFO")
   Button=ButtonGadget(2,440,1,30,22,"Down")
   Button=ButtonGadget(3,470,1,30,22,"UP")
   
  ;Create some lines
  For line=1 To 300
  info.s=info + "CodeGuru is there in Line:"+Chr(9)+Str(line) +Chr(9)
  For I=1 To 40
   info.s=info + Chr(Random(52)+65)
  Next I
  info=info + Chr(13)+Chr(10)
  Next line
  SetGadgetText(0,info)
  Repeat
    EventID.l = WaitWindowEvent()
    Result=SendMessage_(Textbox,#EM_GETSEL,@Anfang,@Ende)
    Zeichen=Anfang
    Zeile=SendMessage_(Textbox,#EM_LINEFROMCHAR,Zeichen,0)+1
    Zeilenanzahl=SendMessage_(Textbox,#EM_GETLINECOUNT,0,0)
    info.s="Position:"+Str(Zeichen)+" in Line:"+Str(Zeile)+" from Linecount:"+Str(Zeilenanzahl)
    SetGadgetText(1,info)
    If EventID = #PB_Event_CloseWindow 
      Quit = 1
    EndIf
    If EventID = #PB_Event_Gadget
     Gadget = EventGadget()
     If Gadget=3
       Zeile=SendMessage_(Textbox,#EM_SCROLL,#SB_PAGEUP,0)
     EndIf
     If Gadget=2
       Zeile=SendMessage_(Textbox,#EM_SCROLL,#SB_PAGEDOWN,0)
     EndIf
    EndIf
  Until Quit = 1
EndIf
EndIf
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP