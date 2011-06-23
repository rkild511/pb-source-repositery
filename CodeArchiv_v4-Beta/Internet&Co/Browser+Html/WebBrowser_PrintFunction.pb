; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7773&highlight=
; Author: Freak (updated for PB4.00 by blbltheworm)
; Date: 06. October 2003
; OS: Windows
; Demo: No

; Question: A way to add a print function in a webgadget ?
; With PB 3.80 and it's Interface stuff, this can be done quite easy using the 
; IWebBrowser2 Interface of the Webgadget's WebBrowser object. 

; For more info about IWebBrowser2, go here: 
; http://msdn.microsoft.com/library/default.asp?url=/workshop/browser/webbrowser/reference/ifaces/iwebbrowser2/iwebbrowser2.asp 


; Constants for the ExecWB() method of IWebBrowser2 

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

; ----------------------------------------------------- 

#WebGadget = 1 
#Button = 2 

OpenWindow(0, 0, 0, 800, 600, "WebBrowser", #PB_Window_ScreenCentered|#PB_Window_SystemMenu) 
CreateGadgetList(WindowID(0)) 

WebGadget(#WebGadget, 10, 40, 780, 550, "www.purebasic.com") 
ButtonGadget(#Button, 10, 10, 60, 20, "Print") 

; The IWebBrowser2 Interface is now defined in a .res file (with about 2000 others), 
; so there's no definition work for us to do :) 

; Fred the genius stored the Interface pointer to IWebBrowser2 in the DATA 
; member of the windowstructure of the WebGadget containerwindow, so we can get 
; that easily: 
WebObject.IWebBrowser2 = GetWindowLong_(GadgetID(#WebGadget), #GWL_USERDATA) 

Repeat 
  Event = WaitWindowEvent() 
  If Event = #PB_Event_Gadget And EventGadget() = #Button 
    
    ; Send the Print Command to the WebGadget: 
    
    WebObject\ExecWB(#OLECMDID_PRINT, #OLECMDEXECOPT_PROMPTUSER, 0, 0) 
    
    ; using #OLECMDEXECOPT_DONTPROMPTUSER as second argument will print without 
    ; the printrequester. 
    
    
  EndIf 
Until Event = #PB_Event_CloseWindow 

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
