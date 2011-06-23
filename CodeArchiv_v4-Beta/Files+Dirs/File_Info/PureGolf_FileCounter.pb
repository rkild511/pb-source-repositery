; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown (updated for PB v4 by Andre)
; Date: 22. November 2003
; OS: Windows
; Demo: Yes

win = OpenWindow(0,0,0,200,45,"Codezähler",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
CreateGadgetList(win)
StringGadget(0,0,0,140,20,"")
ButtonGadget(1,141,0,58,20,"Browse")
ButtonGadget(2,0,22,60,20,"Count")
TextGadget(3,65,25,200,20,"Zeichen: ")
Repeat
  eventid=WaitWindowEvent()
  If eventid=#PB_Event_Gadget
    If EventGadget() = 1
      file.s = OpenFileRequester("Open","","PB-Code *.pb | *.pb| Alles *.* | *.*",0)
      SetGadgetText(0,file)
    ElseIf EventGadget() = 2
      count=0
      If file
        OpenFile(0,file)
        While Eof(0) = 0
          line.s = ReadString(0)
          If Mid(line,1,1) <> ";" : count+Len(line) : EndIf
        Wend
        SetGadgetText(3,"Zeichen: "+Str(count))
      EndIf
    EndIf
  EndIf
Until eventid = #PB_Event_CloseWindow
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP