; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1697&highlight=
; Author: qbcafe (updated for PB 4.00 by Andre)
; Date: 16. July 2003
; OS: Windows
; Demo: Yes


; Attention!
; Doesn't run directly, code must be splitted in two files:
; first part is the Dll code, second part is the program, which calls the Dll

; Hatte mich schon seit längerem mit dem Problem beschäftigt, Images in eine DLL auszulagern,
; um von unterschiedlichen Programmen drauf zugreifen zu können. 
; Ich denke, das Problem hatten auch andere, deshalb hier eine für mich akzeptable Lösung. 

;***********************************
;- DLL-Code
;***********************************
; sprite.dll by qbcafe 

ProcedureDLL.l Image2Memory(num) 

  Select num 
    Case 0:Result = ?Image1 
    Case 1:Result = ?Image2 
    Default:Result = 0 
  EndSelect  
  ProcedureReturn Result                    ;Pointer auf Image zurueckgeben 

  ;- Images 
  DataSection 
    Image1: IncludeBinary "images\1.bmp"      ;evtl. Pfad und Filename anpassen 
    Image2: IncludeBinary "images\2.bmp"      ;           --- dto. --- 
  EndDataSection 

EndProcedure 
 
; (Wie eine DLL generieriert wird, steht in der PB-Hilfe ...) 

;***********************************
;- Program-Code
;***********************************
; Hier nun das Programm, das auf die DLL zugreift: 

;Sprites aus DLL holen 

If InitSprite() = #True 
  MessageRequester("Error","Cannot find DirectX",#MB_ICONERROR):End 
EndIf                                                              

If OpenWindow(0, 277, 70, 620, 560, "Memory to Sprite", #PB_Window_SystemMenu | #PB_Window_TitleBar) 
  OpenWindowedScreen(WindowID(0), 305, 42, 288, 432, 0, 0, 30) 
  If OpenLibrary(0, "sprite.dll") 
    x = CallFunction(0, "Image2Memory",0) 
    CatchSprite(0, x) 
    DisplaySprite(0,0,0) 
    FlipBuffers()    
    Delay(2000) 
    x = CallFunction(0, "Image2Memory",1)   ;Pointer abholen 
    CatchSprite(0, x)                       ;Sprite einlesen 
    DisplaySprite(0,0,0)                    ;auf Screen 
    FlipBuffers()                           ;und anzeigen  
    Delay(2000) 
  Else 
     MessageRequester("Error", "DLL not found ...",#MB_ICONERROR):End 
  EndIf 
  CloseLibrary(0) 
EndIf 
 

; DLL und Hauptprogramm sollten im selben Ordner liegen; ansonsten Pfad anpassen. 
; Noch ein Hinweis: Das Sprite muß mit CatchSprite() abgeholt werden, BEVOR die DLL mit
; CloseLibrary() geschlossen wird, da der reservierte Speicherplatz wieder freigegeben wird. 

; Geschrieben und getestet mit PB 3.70 unter WinXP Pro SP1

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
