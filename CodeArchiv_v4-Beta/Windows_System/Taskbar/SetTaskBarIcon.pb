; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5271&postdays=0&postorder=asc&start=10
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 07. August 2004
; OS: Windows
; Demo: No

; ... see also the SendMessage_MiniTutorial.pb code for more details
; about SendMessage().
; 
; by Danilo, 07.08.2004 - german forum 
; 
#ICON_SMALL = 0 
#ICON_BIG   = 1 

OpenWindow(0,200,200,200,200,"PB Icon Test",#PB_Window_SystemMenu) 

hIcon1 = CatchImage(0,?Icon16x16) 
hIcon2 = CatchImage(1,?Icon32x32) 

SendMessage_(WindowID(0),#WM_SETICON,#ICON_SMALL,hIcon1) 
SendMessage_(WindowID(0),#WM_SETICON,#ICON_BIG  ,hIcon2) 

Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow 

DataSection 
  Icon16x16: 
    IncludeBinary "..\..\Graphics\Gfx\cube16.ico" 
  Icon32x32: 
    IncludeBinary "..\..\Graphics\Gfx\cube32.ico" 
EndDataSection
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -