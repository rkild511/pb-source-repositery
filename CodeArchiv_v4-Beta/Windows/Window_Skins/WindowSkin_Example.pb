; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3325&highlight=
; Author: Mischa (updated for PB4.00 by blbltheworm)
; Date: 04. January 2004
; OS: Windows
; Demo: No


; Example for including the Include-file created by "WindowSkin_Generator.pb".
; You must change the 'name' at IncludeFile and OpenMaskedWindow_xxx to the 
; right image/file name!

; Beispiel für die Einbindung der von "WindowSkin_Generator.pb" erstellten Include-Datei.
; Sie müssen den 'name' bei IncludeFile und OpenMaskedWindow_xxx in den
; richtigen Bild/Datei-Namen ändern!


IncludeFile "WindowSkin_Example_Geebee2.pbi";WindowSkin_name.pbi" 

hwnd=OpenMaskedWindow_Geebee2(0,50,50,"Test",0) 
;OpenMaskedWindow_hiername(WindowID,x,y,title,ImageID) 

Repeat 
  Select WaitWindowEvent() 
    Case #WM_LBUTTONDOWN 
      SendMessage_(hwnd,#WM_NCLBUTTONDOWN, #HTCAPTION,0) 
    Case #WM_RBUTTONDOWN ;right mousekey -> end 
      Quit=1 
  EndSelect 
Until Quit=1 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
