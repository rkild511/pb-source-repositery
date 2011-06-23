; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1878&highlight=
; Author: Thorsten (updated for PB4.00 by blbltheworm)
; Date: 31. July 2003
; OS: Windows
; Demo: Yes

; Base code for an event loop, doesn't run directly !!
; Grundger�st f�r eine Ereignisschleife...  Achtung ! - Ist nicht direkt lauff�hig!!!

;Deine Hauptschleife 
Repeat 

   Event = WaitWindowEvent() 

   Select Event 

     ;Men� wurde angeklickt 
     Case #PB_Event_Menu 
      
       Select EventMenu() 
         Case #Menu1 
          
         Case #Menu2 

       EndSelect 

      Case #PB_Event_Gadget 
        ;irgend ein Gadget wurde ver�ndert / angeklickt 
        
        Select EventGadget() 
           ;Welches genau? 

           Case #Gadget1 
           ;Gadget1 

           Case #Gadget2 
           ;Gadget2 

        EndSelect 

      Case #PB_Event_CloseWindow 
        ;Programm beenden 
        Exit = #True 
          
      Case #WM_PAINT        
      ;Fenster muss neu gezeichnet werden 

      Case #WM_LBUTTONDOWN 
      ;Die linke Maustaste wurde gedr�ckt ... 

      Case #WM_RBUTTONDOWN 
      ;Die rechte Maustaste wurde gedr�ckt ... 
        
      Case #WM_KEYDOWN 
      ;Eine Taste wurde gedr�ckt 

        ;Welche genau? 
        Select EventwParam() 

          ;Enter 
          Case 13 
        
          ;Escape 
          Case 27 

        EndSelect 
          
   EndSelect 

Until Exit 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
