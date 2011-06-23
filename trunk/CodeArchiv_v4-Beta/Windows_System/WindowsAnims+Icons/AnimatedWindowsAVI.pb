; English forum:
; Author: Berikco (updated for PB4.00 by blbltheworm)
; Date: 21. September 2002
; OS: Windows
; Demo: No


h=LoadLibrary_("Shell32.dll") 
;
hwnd=OpenWindow(0,100,150,335,160,"Test",#PB_Window_SystemMenu)
If hwnd
  If CreateGadgetList(hwnd)
    ButtonGadget(1, 10, 100,  72, 20, "Search")
    ButtonGadget(2, 90, 100,  72, 20, "Search Doc")
    ButtonGadget(3, 170, 100,  72, 20, "Search Com")
    ButtonGadget(4, 250, 100,  72, 20, "File Cpy")
    ButtonGadget(5, 10, 128,  72, 20, "Copy File")
    ButtonGadget(6, 90, 128,  72, 20, "Delete File")
    ButtonGadget(7, 170, 128,  72, 20, "Empty Bin")
    ButtonGadget(8, 250, 128,  72, 20, "Kill File")
    AniWin=CreateWindowEx_(0,"SysAnimate32","",#ACS_AUTOPLAY|#ACS_CENTER|#ACS_TRANSPARENT|#WS_CHILD|#WS_VISIBLE|#WS_CLIPCHILDREN|#WS_CLIPSIBLINGS,10,10,280,100, hwnd,0,GetModuleHandle_(0),0)
  EndIf
EndIf
;
Repeat
  EventID = WaitWindowEvent()
  If EventID = #PB_Event_Gadget
    Select EventGadget()
    Case 1
      SendMessage_(AniWin,#ACM_OPEN,h,150) ;Search.avi
    Case 2
      SendMessage_(AniWin,#ACM_OPEN,h,151) ;SearchDoc.avi
    Case 3
      SendMessage_(AniWin,#ACM_OPEN,h,152) ;SearchCom.avi
    Case 4
      SendMessage_(AniWin,#ACM_OPEN,h,160) ;FilesCpy.avi
    Case 5
      SendMessage_(AniWin,#ACM_OPEN,h,161) ;FileCopy.avi
    Case 6
      SendMessage_(AniWin,#ACM_OPEN,h,162) ;FileDel.avi
    Case 7
      SendMessage_(AniWin,#ACM_OPEN,h,163) ;Search.avi
    Case 8
      SendMessage_(AniWin,#ACM_OPEN,h,164) ;FileKill.avi
   EndSelect
   RedrawWindow_(AniWin,0,0,#RDW_INVALIDATE | #RDW_ERASE)
  EndIf
Until  EventID=#PB_Event_CloseWindow
FreeLibrary_(h)
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP