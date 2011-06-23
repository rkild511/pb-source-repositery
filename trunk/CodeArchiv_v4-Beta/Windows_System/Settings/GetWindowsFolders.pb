; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2397&highlight=
; Author: Micha2003 (updated for PB4.00 by blbltheworm)
; Date: 27. September 2003
; OS: Windows
; Demo: No

Window_0=1

If OpenWindow(Window_0, 273, 130, 420, 300, "Desktop Folder", #PB_Window_SystemMenu)
  If CreateGadgetList(WindowID(Window_0))
    ListViewGadget(0, 10, 30, 400, 200)
    ButtonGadget(1, 150, 250, 80, 30, "Ende")
  EndIf
  Gosub Ausgabe
  Repeat
    EventID.l = WaitWindowEvent()
    If EventID = #PB_Event_Gadget
      If EventGadget() = 1
        End
      EndIf
    EndIf
  Until EventID = #PB_Event_CloseWindow
EndIf

End

Ausgabe:
Neu.l=0
For x= 1 To 70
  Alluser$=Space(1000)
  SHGetSpecialFolderLocation_(WindowID(Window_0),x,@Neu)
  SHGetPathFromIDList_(Neu,@Alluser$)
  y$=Str(x)
  y1$ = RSet(y$,3)
  If Alluser$ <>""
    AddGadgetItem(0,-1,y1$+"      "+Alluser$)
  EndIf
Next x
Return

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
