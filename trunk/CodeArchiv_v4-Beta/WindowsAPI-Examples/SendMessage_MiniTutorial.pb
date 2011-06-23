; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5271&postdays=0&postorder=asc&start=10
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 07. August 2004
; OS: Windows
; Demo: No

; SendMessage_() sendet eine Nachricht an ein Fenster, so wie 
; der Name schon sagt. 
; Dabei gibt es 4 Parameter für SendMessage_(): 
; 1. hWnd, das Handle des Fensters an das gesendet wird 
; 2. die Message 
; 3. wParam 
; 4. lParam 
; 
; wParam und lParam sind Argumente die von der Nachricht 
; abhängig sind. Bei WM_SETICON gibt wParam eben an welches 
; Icon gesetzt wird (groß oder klein), und lParam ist das Icon-Handle. 
; 
; Diese 4 Parameter sind genau die Gleichen wie in einem 
; Window-Callback. 
; 
; Simples Beispiel: Eigenes Icon in der TaskBar
; 
; by Danilo, 07.08.2004 - german forum 
; 
#ICON_SMALL = 0 
#ICON_BIG   = 1 

OpenWindow(0,200,200,200,200,"PB Icon Test",#PB_Window_SystemMenu) 

hIcon1 = LoadIcon_(0,#IDI_EXCLAMATION) ; hIcon1 = LoadImage(0,"Icon16x16.ico") 
hIcon2 = LoadIcon_(0,#IDI_ASTERISK)    ; hIcon2 = LoadImage(1,"Icon32x32.ico") 

SendMessage_(WindowID(0),#WM_SETICON,#ICON_SMALL,hIcon1) 
SendMessage_(WindowID(0),#WM_SETICON,#ICON_BIG  ,hIcon2) 

Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow 

DestroyIcon_(hIcon1) ; not needed for LoadImage 
DestroyIcon_(hIcon2) ; not needed for LoadImage

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -