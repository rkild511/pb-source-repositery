; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2953&highlight=
; Author: isidoro
; Date: 27. November 2003
; OS: Windows
; Demo: No


; Use only one code snippet at the same time, else your desktop will be flooded with system windows... !
; Benutze immer nur eins der Code-Snippets zur gleichen Zeit, sonst wird Dein Desktop mit Systemfenstern geflutet!

; Open Printers And Faxes 
Shell_TrayWnd= FindWindow_("Shell_TrayWnd", NULL); 
result = SendMessage_ (Shell_TrayWnd,$111,510,0) 
result = SendMessage_ (Shell_TrayWnd,$111,66046,0) 

; Turn Off Computer Dialog 
Shell_TrayWnd= FindWindow_("Shell_TrayWnd", NULL); 
result = SendMessage_ (Shell_TrayWnd,$111,506,0) 
result = SendMessage_ (Shell_TrayWnd,$111,66042,0) 

; Minimize All Windows 
Shell_TrayWnd= FindWindow_("Shell_TrayWnd", NULL) 
result = SendMessage_ (Shell_TrayWnd,$111,419,0) 

; Undo Minimize All Windows 
Shell_TrayWnd= FindWindow_("Shell_TrayWnd", NULL); 
result = SendMessage_ (Shell_TrayWnd,$111,416,0) 

; Open Control Panel 
Shell_TrayWnd= FindWindow_("Shell_TrayWnd", NULL); 
result = SendMessage_ (Shell_TrayWnd,$111,505,0) 

; Help And Support 
Shell_TrayWnd= FindWindow_("Shell_TrayWnd", NULL); 
result = SendMessage_ (Shell_TrayWnd,$111,503,0) 
result = SendMessage_ (Shell_TrayWnd,$111,66039,0) 

; Lock Unlock The Taskbar 
Shell_TrayWnd= FindWindow_("Shell_TrayWnd", NULL); 
result = SendMessage_ (Shell_TrayWnd,$111,424,0) 
result = SendMessage_ (Shell_TrayWnd,$111,65960,0) 

; Taskbar Properties 
Shell_TrayWnd= FindWindow_("Shell_TrayWnd", NULL); 
result = SendMessage_ (Shell_TrayWnd,$111,413,0) 
result = SendMessage_ (Shell_TrayWnd,$111,65949,0) 

; Date Time Properties 
Shell_TrayWnd= FindWindow_("Shell_TrayWnd", NULL); 
result = SendMessage_ (Shell_TrayWnd,$111,408,0) 
result = SendMessage_ (Shell_TrayWnd,$111,65944,0) 

; Tile Windows 
Shell_TrayWnd= FindWindow_("Shell_TrayWnd", NULL); 
result = SendMessage_ (Shell_TrayWnd,$111,405,0) 

; Tile Windows Horizontally 
Shell_TrayWnd= FindWindow_("Shell_TrayWnd", NULL); 
result = SendMessage_ (Shell_TrayWnd,$111,65940,0) 
result = SendMessage_ (Shell_TrayWnd,$111,65941,0) 

; Cascade Windows 
Shell_TrayWnd= FindWindow_("Shell_TrayWnd", NULL); 
result = SendMessage_ (Shell_TrayWnd,$111,403,0) 
result = SendMessage_ (Shell_TrayWnd,$111,65939,0) 

; Logoff Screen 
Shell_TrayWnd= FindWindow_("Shell_TrayWnd", NULL); 
result = SendMessage_ (Shell_TrayWnd,$111,402,0) 
result = SendMessage_ (Shell_TrayWnd,$111,5000,0) 
result = SendMessage_ (Shell_TrayWnd,$111,65938,0) 

; Open Run 
Shell_TrayWnd= FindWindow_("Shell_TrayWnd", NULL); 
result = SendMessage_ (Shell_TrayWnd,$111,401,0) 
result = SendMessage_ (Shell_TrayWnd,$111,65937,0) 
  
; Open Start Menu 
Shell_TrayWnd= FindWindow_("Shell_TrayWnd", NULL); 
result = SendMessage_ (Shell_TrayWnd,$111,305,0) 
result = SendMessage_ (Shell_TrayWnd,$111,65841,0) 

; Open Task Manager 
Shell_TrayWnd= FindWindow_("Shell_TrayWnd", NULL); 
result = SendMessage_ (Shell_TrayWnd,$111,420,0) 
result = SendMessage_ (Shell_TrayWnd,$111,65956,0) 

; Taskbar And Start Menu Properties -> Customize  Notifications 
Shell_TrayWnd= FindWindow_("Shell_TrayWnd", NULL); 
result = SendMessage_ (Shell_TrayWnd,$111,421,0) 
result = SendMessage_ (Shell_TrayWnd,$111,65957,0) 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
