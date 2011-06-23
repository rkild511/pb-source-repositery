; English forum: 
; Author: Justin (updated for PB4.00 by blbltheworm)
; Date: 28. February 2003
; OS: Windows
; Demo: No


;Draw bitmap setting a transparent color
;Ref : http://msdn.microsoft.com/library/en-us/shellcc/platform/commctls/imagelist/reflist.asp

;this example draws a 256 colors bitmap at 0,0 coord in the window
;RGB(255,0,255) is set as the transparent color

;Justin 02/03

;structure

Global ptst.PAINTSTRUCT,himglist


; hbimglist=CatchImage(0,?limglist)
hbimglist = LoadImage(0, "..\gfx\Geebee2.bmp")

himglist=ImageList_Create_(ImageWidth(0),ImageHeight(0),#ILC_COLOR8|#ILC_MASK,1,0) ;Create ImageList (8 Bit)
ImageList_AddMasked_(himglist,hbimglist,RGB(255,0,255)) ;set transparent color

;window procedure
Procedure windowproc(hwnd,msg,wparam,lparam)
  retval=#PB_ProcessPureBasicEvents 
  Select msg
    Case #WM_PAINT ;DRAW IMAGE
      hdc=BeginPaint_(hwnd,@ptst)
      ImageList_Draw_(himglist,0,hdc,0,0,#ILD_TRANSPARENT) 
      EndPaint_(hwnd,@ptst)
      retval=0
  EndSelect
  ProcedureReturn retval
EndProcedure

;WINDOW
OpenWindow(0,150,70,552,352,"Window1",#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_TitleBar)

SetWindowCallback(@windowproc()) 

;EVENT LOOP
Repeat
Until WaitWindowEvent()=#PB_Event_CloseWindow

;free imglist
ImageList_Destroy_(himglist)
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -