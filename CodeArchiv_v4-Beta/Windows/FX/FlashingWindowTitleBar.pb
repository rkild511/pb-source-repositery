; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1650&highlight=
; Author: Leo (updated for PB 4.00 by Andre)
; Date: 15. January 2005
; OS: Windows
; Demo: No


; Flashing window titlebar
; Fenster Titelleiste blinken lassen 

;Fenster öffnen 
hwnd = OpenWindow(0,0,0,200,200,"Flash Window",#PB_Window_ScreenCentered|#PB_Window_SystemMenu) 

;Die Strukture FLASHWINFO wird für den 
;Win Api Befehl FlashWindowEx_() gebraucht 
Structure FLASHWINFO 
  cbSize.l 
  hwnd.l 
  dwFlags.l 
  uCount.l 
  dwTimeout.l 
EndStructure 

;Variable mit der Strukture FLASHWINFO erstellen 
Info.FLASHWINFO 

;Größe der Strukture in Bytes 
Info\cbSize = SizeOf(FLASHWINFO) 

;Die Titelleiste welches Fensters blinken soll 
Info\hwnd   = hwnd 

;Flags: 
;#FLASHW_CAPTION: Lässt nur die Titelleiste blinken (In Hex: $5) 
;#FLASHW_TRAY   : Lässt nur das Teil in der Taskbar blinken  (In Hex: $6) 
;#FLASHW_ALL    : Beides zusammen (In Hex: $7) 
;Es gibt noch mehr Flags, die aber meiner Meinung nach nicht 
;nützlich sind 
Info\dwFlags= $7;#FLASHW_ALL 

;Wie oft das Fenster blinken soll. 
;Wenn null angegeben wird, dann blinkt 
;das Fenster immer 
Info\uCount = 0 

;Wie lange zwischen dem blinken gewartet werden soll (in Millisekunden), 
;Wenn null angegeben wird, dann wird die Standart Blinkwartezeit 
;gewählt 
;Info\dwTimeout=0 
Info\dwTimeout = 200 

;Jetzt die Parameter übergeben und die Funktion aufrufen 
FlashWindowEx_(Info) 

;Hauptschleife 
Repeat : Until WindowEvent() = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -