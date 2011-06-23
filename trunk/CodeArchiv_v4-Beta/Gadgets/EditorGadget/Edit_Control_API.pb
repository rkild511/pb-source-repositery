; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6181&highlight=
; Author: Dennis (updated for PB4.00 by blbltheworm)
; Date: 19. May 2003
; OS: Windows
; Demo: No

; +++ updated 03/2005 by Team100 and tested with PB 3.93



#EditText      = 200 
#EditText2     = 201 
#Button_OK     = 202 
#Button_Cancel = 203 

Procedure CreateEditText() 

  hInstance = GetModuleHandle_(0) 
  HwndEditText  = CreateWindowEx_(#WS_EX_CLIENTEDGE,"EDIT","", #WS_VISIBLE | #WS_CHILDWINDOW | #ES_AUTOHSCROLL  | #WS_VSCROLL | #ES_MULTILINE | #ES_WANTRETURN |#ES_NOHIDESEL, 50,50,300,300,WindowID(0),#EditText,hInstance,0) 

  HwndEditText1 = CreateWindowEx_(#WS_EX_CLIENTEDGE,"EDIT","", #WS_VISIBLE | #WS_CHILDWINDOW | #ES_AUTOHSCROLL  | #WS_VSCROLL | #ES_MULTILINE | #ES_WANTRETURN |#ES_NOHIDESEL, 500,50,300,300,WindowID(0),#EditText2,hInstance,0) 

EndProcedure 




If OpenWindow(0,0,0,900,600,"Basic Text Control",#PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
  CreateEditText() 
  If CreateGadgetList(WindowID(0)) 
     ButtonGadget(#Button_OK, 50, 500, 30, 30, "Start") 
     ButtonGadget(#Button_Cancel, 100, 500, 70, 30, "Cancel") 
  EndIf 
EndIf 


Repeat 
     Select WaitWindowEvent() 
       Case  #PB_Event_Gadget
         Select EventGadget() 

             Case #Button_OK 
              If Once = 0 

                 string.s="" 

; +++ faster text-builder added

                 string = Space(64400)

              ; assign text to the String 

                For i=1 To 64400/2 
                    PokeS(@string+(i-1)*2,"HE")
                   ;string + "HE"                 ; +++ too slow 
                Next i 
                
                string + "Z"  ; last Char <> to verify inside the control 
              ; write text inside 1st control 
                SetDlgItemText_(WindowID(0),#EditText,string) 
;        
                Debug("Len(String)") 
                Debug(Len(string )) 
                Debug("") 

                string=""  ; clear string 
                
                string1.s= Space(i*2)  ; new string to get text 
                
;               ; get text from 1st controm and set String1 with it 
                GetDlgItemText_(WindowID(0),#EditText,string1,65000) 
                    
                MessageRequester("","The 1st control has been set",16) 

              ; write text inside 2nd control 
                SetDlgItemText_(WindowID(0),#EditText2,string1) 
                Debug("Len(String1)") 
                Debug(Len(string1)) 
                  
                Once = 1 
                EndIf 

             Case #Button_Cancel 
               Quit = 1 

          EndSelect 
              
       Case #PB_Event_CloseWindow 
            Quit = 1 
     EndSelect 
Until Quit 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
