; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown (updated for PB 4.00 by Andre)
; Date: 22. November 2003
; OS: Windows
; Demo: Yes


; Calls the compiler, without starting the resulting executable
; Compiler aufrufen, ohne dass er die erstellte Exe-Datei automatisch ausführt


; You must specify the path to your PureBasic compiler
; in the procedure _Compile() !!

; PureBasic Visual Designer v3.80 build 1249 


;- Window Constants 
; 
Enumeration 
  #Window_0 
EndEnumeration 

;- Gadget Constants 
; 
Enumeration 
  #Gadget_0 
  #Gadget_1 
  #Gadget_2 
  #Gadget_3 
  #Gadget_4 
  #Gadget_5 
  #Gadget_6 
EndEnumeration 

Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 264, 0, 598, 207, "Compile without IDE...", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar) 
    If CreateGadgetList(WindowID(#Window_0)) 
      TextGadget(#Gadget_0, 20, 30, 230, 20, "Pfad für PBSource bitte eingeben",#PB_Text_Border) 
      StringGadget(#Gadget_2, 20, 50, 570, 20, "C:\Programme\Purebasic\Examples\Sources\Gadget.pb") 
      TextGadget(#Gadget_1, 20, 90, 230, 20, "Pfad für compiliertes Programm bitte eingeben",#PB_Text_Border) 
      StringGadget(#Gadget_3, 20, 110, 570, 20, "C:\Programme\Purebasic\Examples\Tasten.exe") 
      ButtonGadget(#Gadget_4, 20, 150, 100, 40, "Compile to EXE") 
      ButtonGadget(#Gadget_5, 140, 150, 110, 40, "Compile to DLL") 
      ButtonGadget(#Gadget_6, 270, 150, 80, 40, "Cancel") 
      
    EndIf 
  EndIf 
EndProcedure 

Procedure _Compile(Source$,Ausgabe$,Was$) 
  RunProgram("C:\Programme\PureBASIC\Compilers\PBCompiler.exe"," "+Source$+" "+Was$+" "+Ausgabe$,"",1)  ; DOS-BOX wird noch angezeigt 
  ;RunProgram("C:\Programme\PureBASIC\Compilers\PBCompiler.exe"," "+Source$+" "+Was$+" "+Ausgabe$,"",1|2) ; Unsichtbarer Modus 
  Delay(500) 
EndProcedure 



Open_Window_0() 
Pfad1$= GetGadgetText(#Gadget_2) 
Ausgabe$= GetGadgetText(#Gadget_3) 

Repeat 
  
  Event = WaitWindowEvent() 
  
  If Event = #PB_Event_Gadget 
    
        
    GadgetID = EventGadget() 
    
    If GadgetID = #Gadget_2 
       Pfad1$=GetGadgetText(#Gadget_2) 
    ElseIf GadgetID = #Gadget_3 
       Ausgabe$=GetGadgetText(#Gadget_3) 
    ElseIf GadgetID = #Gadget_4 
       _Compile(Pfad1$,Ausgabe$,"/EXE") 
          
    ElseIf GadgetID = #Gadget_5 
      _Compile(Pfad1$,Ausgabe$,"/DLL") 
    ElseIf GadgetID = #Gadget_6 
      End 
      
    EndIf 
    
  EndIf 
  
Until Event = #PB_Event_CloseWindow 

End 
;
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP