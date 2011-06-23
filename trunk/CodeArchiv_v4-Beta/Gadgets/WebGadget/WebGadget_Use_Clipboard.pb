; English forum:http://www.purebasic.fr/english/viewtopic.php?p=35682 
; Author: Freak (updated for PB 4.00 by mardanny71, description added by Andre)
; Date: 26. August 2003 
; OS: Windows 
; Demo: No 

;---------------------------------------------------------------------------------------------------- 
; Note about using the "copy" function:
; Select a part of the text in the WebGadget and then press "copy" (or press CTRL+C). 
; This will copy the selected text into the clipboard and so will display its contents 
; in the messagerequester later.

; Hinweis zur Benutzung der "Copy" Funktion:
; Wähle einen Teil des Texts im WebGadget aus und drücke dann "Copy" (oder STRG+C).
; Dies kopiert den markierten Text in die Zwischenablage und wird so deren Inhalt 
; später im Messagerequester darstellen.

Enumeration 1 
  #OLECMDID_OPEN          
  #OLECMDID_NEW        
  #OLECMDID_SAVE          
  #OLECMDID_SAVEAS            
  #OLECMDID_SAVECOPYAS    
  #OLECMDID_PRINT        
  #OLECMDID_PRINTPREVIEW        
  #OLECMDID_PAGESETUP        
  #OLECMDID_SPELL            
  #OLECMDID_PROPERTIES  
  #OLECMDID_CUT          
  #OLECMDID_COPY        
  #OLECMDID_PASTE            
  #OLECMDID_PASTESPECIAL    
  #OLECMDID_UNDO            
  #OLECMDID_REDO          
  #OLECMDID_SELECTALL        
  #OLECMDID_CLEARSELECTION 
  #OLECMDID_ZOOM            
  #OLECMDID_GETZOOMRANGE      
  #OLECMDID_UPDATECOMMANDS  
  #OLECMDID_REFRESH            
  #OLECMDID_STOP              
  #OLECMDID_HIDETOOLBARS      
  #OLECMDID_SETPROGRESSMAX    
  #OLECMDID_SETPROGRESSPOS  
  #OLECMDID_SETPROGRESSTEXT    
  #OLECMDID_SETTITLE          
  #OLECMDID_SETDOWNLOADSTATE  
  #OLECMDID_STOPDOWNLOAD      
EndEnumeration 

Enumeration 0 
  #OLECMDEXECOPT_DODEFAULT      
  #OLECMDEXECOPT_PROMPTUSER        
  #OLECMDEXECOPT_DONTPROMPTUSER    
  #OLECMDEXECOPT_SHOWHELP        
EndEnumeration 

; ------------------------------------------------------------------------------------------ 

; Now the code 

#WebGadget = 1 
#Button = 2 

OpenWindow(0, 0, 0, 800, 600,"WebBrowser" ,#PB_Window_ScreenCentered|#PB_Window_SystemMenu ) 

CreateGadgetList(WindowID(0)) 

  WebGadget(#WebGadget, 10, 40, 780, 550, "www.purebasic.com") 
  ButtonGadget(#Button, 10, 10, 60, 20, "Copy") 

; Fred the genius stored the Interface pointer to IWebBrowser2 in the DATA 
; member of the windowstructure of the WebGadget containerwindow, so we can get 
; that easily: 
  
WebObject.IWebBrowser2 = GetWindowLong_(GadgetID(#WebGadget), #GWL_USERDATA) 

Repeat 
  Event = WaitWindowEvent() 
  If Event = #PB_Event_Gadget And EventGadget() = #Button 
    
    ; Now here's the actual copy thing, not that complicated... 
    WebObject\ExecWB(#OLECMDID_COPY, #OLECMDEXECOPT_DONTPROMPTUSER, 0, 0) 
    
    ; little test: 
    MessageRequester("", GetClipboardText(), 0) 
    
  EndIf 
Until Event = #PB_Event_CloseWindow 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP