; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1691&highlight=
; Author: Pille (updated for PB4.00 by blbltheworm)
; Date: 14. July 2003
; OS: Windows
; Demo: No

; 
; by Pille, 14.07.2003 
; 
; 31-Oct-2003: constants declaration changed to Enumeration by Andre

Enumeration
  #gIndex
  #Window
  #Editor
  #Url
  #cmdOpenUrl
EndEnumeration

defaultUrl.s="http://www.google.de/index.html" 

Procedure.s OpenURL(Url.s, OpenType.b) 
  ;?OpenType [1 = IOTPreconfig | 2 =  IOTDirect | 3 = IOTProxy] 
  ;content.s = OpenURL("http://www.google.de/index.html", 1) 
  
  isLoop.b=1 
  INET_RELOAD.l = $80000000 
  hInet.l=0 
  hURL.l=0 
  Bytes.l=0 
  Buffer.s=Space(2048) 
  res.s="" 

   hInet = InternetOpen_("PB@INET", OpenType, #Null, #Null, 0) 
   hURL = InternetOpenUrl_(hInet, Url, #Null, 0, INET_RELOAD, 0) 
    
   Repeat 
      InternetReadFile_(hURL,@Buffer, Len(Buffer), @Bytes) 
      If Bytes = 0 
         isLoop=0 
      Else 
         res = res + Left(Buffer, Bytes) 
      EndIf 
   Until isLoop=0 

   InternetCloseHandle_(hURL) 
   InternetCloseHandle_(hInet) 
   ProcedureReturn res 
EndProcedure 


If OpenWindow(#Window, 0, 0, 500, 500, "OpenUrl", #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered ) 
    
   If CreateGadgetList(WindowID(#Window)) 
      EditorGadget(#Url, 5, 5, 410, 20) 
      EditorGadget(#Editor, 5, 30, 490, 465) 
      ButtonGadget(#cmdOpenUrl, 420, 5, 75, 20, "Get Source!") 
   EndIf 
    
   SetGadgetText(#Url, defaultUrl) 
    
   Repeat 
      EventID.l = WaitWindowEvent() 
      If EventID = #PB_Event_Gadget    
         Select EventGadget() 
         Case #cmdOpenUrl 
            SetGadgetText(#Editor, OpenUrl(GetGadgetText(#Url),1)) 
         EndSelect 
      EndIf        
   Until EventID = #PB_Event_CloseWindow 

EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
