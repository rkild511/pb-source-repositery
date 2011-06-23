; German forum:
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 22. November 2002
; OS: Windows
; Demo: No

; Mit dem Api-Befehl ExtractIcon_() wird das Icon aus der angegebenen Datei ausgelesen. 
; Syntax: 
; ExtractIcon_(#Icon,Pfad der Datei,#Iconnummer in der Datei)

SystemPath.s=Space(255) 
Result=GetSystemDirectory_(SystemPath.s,255) 

OpenWindow(0,0,0,237,50,"Icon-Test",#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_ScreenCentered) 

If CreateGadgetList(WindowID(0)) 
For a=0 To 5 
  ButtonImageGadget(a,10+a*36,10,36,36,ExtractIcon_(0,SystemPath+"\SetupAPI.dll",a)) 
Next 
EndIf 

Repeat : Until WindowEvent()=#PB_Event_CloseWindow 

End 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -