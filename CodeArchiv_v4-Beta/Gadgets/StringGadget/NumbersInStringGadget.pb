; German forum:
; Author: OzBernd (updated for PB4.00 by blbltheworm)
; Date: 20. December 2002
; OS: Windows
; Demo: No


; Zahlen String Gadget 
; Feel free to use it anywhere, anytime 
; achtung auf decimal und thousend Zeichen achten 
;------------------------------------------------ 

Form1_hWnd= OpenWindow(0,100,200,200,200,"TEST",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
If Form1_hWnd=0 Or CreateGadgetList(Form1_hWnd)=0 : End : EndIf 

#Nummer = 1 
#label = 2 
string_hWnd= StringGadget(#Nummer,10,50,100,20,"") 
label_hWnd = TextGadget(#label, 10,30,100,20,"Limit eingeben") 
GadgetToolTip(#Nummer,"Bitte geben Sie Ihr gewünschtes KreditLimit ein") 
SetActiveGadget(#Nummer) 

Repeat 
  EventID=WaitWindowEvent() 
  Select EventID 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case #Nummer :FakeEndSelect: Gosub Nummer_Click 
        
    EndSelect 
  EndSelect 
  esc=GetAsyncKeyState_(#VK_ESCAPE) 
  ret=GetAsyncKeyState_(#VK_RETURN) 
Until EventID=#PB_Event_CloseWindow Or esc=-32767 Or ret=-32767 


;Format tauschen nach dt. Konvention 
text$ = ReplaceString(text$, ",", ".",1,1) 
          
Debug text$ 




      
End    
          
; Eingabe verarbeiten, NoNumbers ausschließen und cursor ans Ende setzen 
Nummer_Click: 

text$ = GetGadgetText(#Nummer) 
If Len(text$)> 0 
   eingabe.b = Asc(RTrim(Right(text$,1))) 
   If eingabe >=44 And eingabe <=57 And eingabe <> 47      ; zahlen 0 bis 9, -., 
      Return 
   Else 
     SetGadgetText(#Nummer,Left(text$,Len(text$)-1))          ;letztes Zeichen löschen 
     SendMessage_(string_hWnd,#EM_SETSEL, Len(text$),-1)  ;Cursor ans Ende setzen 
   EndIf 
EndIf 

Return 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP