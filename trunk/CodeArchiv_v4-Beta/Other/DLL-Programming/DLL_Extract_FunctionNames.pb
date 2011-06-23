; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1600&highlight=
; Author: Herbi (updated for PB 4.00 by Andre)
; Date: 04. July 2003
; OS: Windows
; Demo: Yes
; 
; ------------------------------------------------------------ 
; 
;   DLL Spion 
; 
;   Vorsicht : Geht nicht bei allen DLLs 
;   ist aber für den normalen Gebrauch geeignet 
;    
; ------------------------------------------------------------ 
; 

Global datei.s, zeile.s, fname.s, fadress.l, open.l, count.l 
#dll = 0 

If OpenWindow(0, 100, 100, 600, 460, "DLL - Spion", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered) 
  

  If CreateGadgetList(WindowID(0)) 
          
     ButtonGadget(1, 5,   20, 80, 25, "DLL Laden") 
     ButtonGadget(2, 105, 20, 80, 25, "Anzeigen") 
     ButtonGadget(3, 305, 20, 80, 25, "Ende") 
     TextGadget(4, 5, 70, 300, 25, "") 
      
     ListIconGadget(30, 5, 110, 590, 320, "Funktions - Adresse", 120, #PB_ListIcon_GridLines) 
     AddGadgetColumn(30, 1, "Funktions - Name", 280) 
     AddGadgetColumn(30, 2, "lfd. Nummer", 170) 
      
  EndIf    

  Repeat 
    EventID.l = WaitWindowEvent() 
   Select EventID 
      Case #PB_Event_CloseWindow  
                 Quit = 1 
      Case #PB_Event_Gadget 
         Select EventGadget() 
           Case 1 
             ; DLL laden 
              datei = "" 
              datei = OpenFileRequester("DLL laden", "", "DLL Dateien | *.dll", 1) 
              If datei <> "" 
                 open = OpenLibrary(#dll, datei) 
              EndIf    
             Case 2 
             ; Funktionen anzeigen 
               If open <> 0 
                   count = 0 
                   anz.l = CountLibraryFunctions(#dll) 
                   SetGadgetText(4, "Anzahl der Funktionen : " + Str(anz)) 
                   ClearGadgetItemList(30) 
                   If ExamineLibraryFunctions(#dll) 
                      While NextLibraryFunction() <> 0 
                         fname   = LibraryFunctionName() 
                         fadress = LibraryFunctionAddress() 
                         count = count + 1 
                         zeile = Str(fadress) + Chr(10) + fname + Chr(10) + Str(count) 
                         AddGadgetItem(30, -1, zeile) 
                      Wend 
                   EndIf 
                   CloseLibrary(#dll) 
               EndIf      
              
             Case 3 
             ; Button 4 
             Quit = 1 
                
         EndSelect            
    EndSelect 

  Until Quit = 1 
  
EndIf 

End    

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
