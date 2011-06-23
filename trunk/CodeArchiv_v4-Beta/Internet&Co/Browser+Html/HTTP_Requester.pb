; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2682&highlight=
; Author: Deeem2031 (updated for PB 4.00 by Andre)
; Date: 28. March 2005
; OS: Windows
; Demo: No

Enumeration ;Windows 
  #W_Main 
EndEnumeration 

Enumeration ;Gadgets 
  #G_SourceCode 
  #G_IEView 
  #G_B_Request 

  #G_I_URI 
  #G_I_Port 
  #G_I_Method 
  #G_I_File 
  #G_I_Protocol 
  #G_I_Content 
  
  ;Headerfields-> 
  #G_I_Accept 
  #G_I_Accept_Charset 
  #G_I_Accept_Encoding 
  #G_I_Accept_Language 
  #G_I_Accept_Ranges 
  #G_I_Age 
  #G_I_Allow 
  #G_I_Autorization 
  #G_I_Chache_Control 
  
  #G_I_Connection 
  #G_I_Content_Encoding 
  #G_I_Content_Language 
  #G_I_Content_Length 
  #G_I_Content_Location 
  #G_I_Content_MD5 
  #G_I_Content_Range 
  #G_I_Content_Type 
  #G_I_Date 
  #G_I_ETag 
  
  #G_I_Expect 
  #G_I_Expires 
  #G_I_From 
  #G_I_Host 
  #G_I_If_Match 
  #G_I_If_Modified_Since 
  #G_I_If_None_Match 
  #G_I_If_Range 
  #G_I_If_Unmodified_Since 
  #G_I_Last_Modified 
  
  #G_I_Location 
  #G_I_Max_Forwards 
  #G_I_Progma 
  #G_I_Proxy_Authenticate 
  #G_I_Proxy_Authorization 
  #G_I_Range 
  #G_I_Referer 
  #G_I_Retry_After 
  #G_I_Server 
  #G_I_TE 
  
  #G_I_Trailer 
  #G_I_Transfer_Encoding 
  #G_I_Upgrade 
  #G_I_User_Agent 
  #G_I_Vary 
  #G_I_Via 
  #G_I_Warning 
  #G_I_WWW_Authenticate 
  ;<-Headerfields 
  
  #G_T_Host 
  #G_T_User_Agent 
  #G_T_Referer 
  #G_CB_Host 
  
  #G_T_Content_Encoding 
  #G_T_Content_Language 
  #G_T_Content_Length 
  #G_T_Content_Location 
  #G_T_Content_MD5 
  #G_T_Content_Range 
  #G_T_Content_Type 
  #G_CB_Content_Length 
  #G_CB_Content_MD5 
EndEnumeration 


#Known_Methods = 18 
Dim Known_Method.s(#Known_Methods) 

Known_Method(0) = "OPTIONS" 
Known_Method(1) = "GET" 
Known_Method(2) = "HEAD" 
Known_Method(3) = "POST" 
Known_Method(4) = "TRACE" 
Known_Method(5) = "PUT" 
Known_Method(6) = "DELETE" 
Known_Method(7) = "CONNECT" 
Known_Method(8) = "PATCH" 
Known_Method(9) = "LINK" 
Known_Method(10) = "UNLINK" 
Known_Method(11) = "COPY" 
Known_Method(12) = "MOVE" 
Known_Method(13) = "MKCOL" 
Known_Method(14) = "PROPFIND" 
Known_Method(15) = "PROPPATCH" 
Known_Method(16) = "LOCK" 
Known_Method(17) = "UNLOCK" 
Known_Method(18) = "SEARCH" 

#Known_Protocols = 1 
Dim Known_Protocol.s(#Known_Protocols) 

Known_Protocol(0) = "HTTP/1.0" 
Known_Protocol(1) = "HTTP/1.1" 

#Known_User_Agents = 25 
Dim Known_User_Agent.s(#Known_User_Agents) 

Known_User_Agent(0) = "Opera/7.54 (Windows NT 5.1; U)  [de]" 
Known_User_Agent(1) = "Mozilla/5.0 (Windows; U; Windows NT 5.1; de-DE; rv:1.7.6) Gec" 
Known_User_Agent(2) = "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.6) Gec" 
Known_User_Agent(3) = "Mozilla/5.0 (Windows; U; Windows NT 5.1; de-DE; rv:1.7.5) Gec" 
Known_User_Agent(4) = "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.5) Gec" 
Known_User_Agent(5) = "Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.7.5) Gec" 
Known_User_Agent(6) = "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7) Gecko" 
Known_User_Agent(7) = "Mozilla/5.0 (Windows; U; Windows NT 5.1; de-DE; rv:1.4) Gecko" 
Known_User_Agent(8) = "Mozilla/5.0 (Windows; U; Windows NT 5.0; de-DE; rv:1.7.5) Gec" 
Known_User_Agent(9) = "Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.7.5) Gecko/20050" 
Known_User_Agent(10) = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)" 
Known_User_Agent(11) = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET" 
Known_User_Agent(12) = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)" 
Known_User_Agent(13) = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1" 
Known_User_Agent(14) = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1) Opera 7.54" 
Known_User_Agent(15) = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1) Opera 7.23" 
Known_User_Agent(16) = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; Q312461; ." 
Known_User_Agent(17) = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; Crazy" 
Known_User_Agent(18) = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; Salzb" 
Known_User_Agent(19) = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)" 
Known_User_Agent(20) = "Mozilla/4.0 (compatible; MSIE 6.0; X11; Linux i686) Opera 7.5" 
Known_User_Agent(21) = "Mozilla/4.0 (compatible; MSIE 5.5; Windows NT 5.0; DT)" 
Known_User_Agent(22) = "Mozilla/4.0 (compatible; MSIE 5.5; Windows 98; Win 9x 4.90; A" 
Known_User_Agent(23) = "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" 
Known_User_Agent(24) = "Mozilla/4.0 (compatible; MSIE 5.0; Windows 98; DigExt)" 
Known_User_Agent(25) = "msnbot/1.0 (+http://search.msn.com/msnbot.htm)" 

#Known_Content_Types = 2 
Dim Known_Content_Type.s(#Known_Content_Types) 
Known_Content_Type(0) = "text/html; charset=ISO-8859-1" 
Known_Content_Type(1) = "message/http" 
Known_Content_Type(2) = "application/x-www-form-urlencoded" 



InitNetwork() 

CreateGadgetList(OpenWindow(#W_Main,0,0,800,600,"HTTP-Requester",#PB_Window_ScreenCentered|#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_Invisible)) 

AddKeyboardShortcut(#W_Main,#PB_Shortcut_Return,13) 

StringGadget(#G_SourceCode,0,0,800,500,"",#ES_MULTILINE|#WS_VSCROLL) 
;WebGadget(#G_IEView,400,0,400,500,"") 

StringGadget(#G_I_URI,0,500,100,20,"www.deeem2031.de."):StringGadget(#G_I_Port,100,500,20,20,"80",#PB_String_Numeric) 
ComboBoxGadget(#G_I_Method,120,500,80,#Known_Methods*20+40,#PB_ComboBox_Editable):For i = 0 To #Known_Methods: AddGadgetItem(#G_I_Method,-1,Known_Method(i)):Next:SetGadgetState(#G_I_Method,1) 
ComboBoxGadget(#G_I_Protocol,650,500,100,#Known_Protocols*20+40,#PB_ComboBox_Editable):For i = 0 To #Known_Protocols: AddGadgetItem(#G_I_Protocol,-1,Known_Protocol(i)):Next:SetGadgetState(#G_I_Protocol,0) 
StringGadget(#G_I_File,200,500,450,20,"/") 
TextGadget(#G_T_Host,2,522,28,20,"Host:"):CheckBoxGadget(#G_CB_Host,30,520,15,20,""):SetGadgetState(#G_CB_Host,1):StringGadget(#G_I_Host,45,520,155,20,"www.deeem2031.de.") 
TextGadget(#G_T_User_Agent,202,522,70,20,"User-Agent:"):ComboBoxGadget(#G_I_User_Agent,270,520,330,#Known_User_Agents*20+40,#PB_ComboBox_Editable):For i = 0 To #Known_User_Agents: AddGadgetItem(#G_I_User_Agent,-1,Known_User_Agent(i)):Next:SetGadgetState(#G_I_User_Agent,0) 
TextGadget(#G_T_Referer,602,522,50,20,"Referer:"):StringGadget(#G_I_Referer,650,520,150,20,"") 

TextGadget(#G_T_Content_Encoding,2,540,100,20,"Content-Encoding"):TextGadget(#G_T_Content_Language,100,540,100,20,"-Language"):TextGadget(#G_T_Content_Length,200,540,40,20,"-Length"):TextGadget(#G_T_Content_Location,260,540,100,20,"-Location"):TextGadget(#G_T_Content_MD5,360,540,120,20,"-MD5"):TextGadget(#G_T_Content_Range,500,540,100,20,"-Range"):TextGadget(#G_T_Content_Type,600,540,100,20,"-Type") 
CheckBoxGadget(#G_CB_Content_Length,245,540,15,20,""):SetGadgetState(#G_CB_Content_Length,1):CheckBoxGadget(#G_CB_Content_MD5,485,540,15,20,""):SetGadgetState(#G_CB_Content_MD5,1) 
StringGadget(#G_I_Content_Encoding,0,560,100,20,""):              StringGadget(#G_I_Content_Language,100,560,100,20,""):       StringGadget(#G_I_Content_Length,200,560,60,20,""):     StringGadget(#G_I_Content_Location,260,560,100,20,""):       StringGadget(#G_I_Content_MD5,360,560,140,20,""):  StringGadget(#G_I_Content_Range,500,560,100,20,"") 
ComboBoxGadget(#G_I_Content_Type,600,560,200,#Known_Content_Types*20+40,#PB_ComboBox_Editable):For i = 0 To #Known_Content_Types: AddGadgetItem(#G_I_Content_Type,-1,Known_Content_Type(i)):Next:SetGadgetState(#G_I_Content_Type,0) 
StringGadget(#G_I_Content,0,580,800,20,"") 

ButtonGadget(#G_B_Request,750,500,50,20,"Request") 

HideWindow(#W_Main,0) 

Repeat 
  Select WindowEvent() 
    Case #PB_Event_Menu 
      Focus = GetFocus_() 
      SendMessage_(GadgetID(#G_B_Request),#WM_LBUTTONDOWN,#MK_LBUTTON,0) 
      SendMessage_(GadgetID(#G_B_Request),#WM_LBUTTONUP,#MK_LBUTTON,0) 
      If Focus:SetFocus_(Focus):EndIf 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case #G_I_Method 
          If UCase(GetGadgetText(#G_I_Method)) = "POST" 
            SetGadgetText(#G_I_Content_Type,"application/x-www-form-urlencoded") 
          EndIf 
        Case #G_I_URI 
          If GetGadgetState(#G_CB_Host) 
            SetGadgetText(#G_I_Host,GetGadgetText(#G_I_URI)) 
          EndIf 
        Case #G_I_Content 
          Content.s = GetGadgetText(#G_I_Content) 
          ContentLength = Len(Content) 
          If GetGadgetState(#G_CB_Content_Length) 
            SetGadgetText(#G_I_Content_Length,Str(ContentLength)) 
          EndIf 
          If GetGadgetState(#G_CB_Content_MD5) 
            SetGadgetText(#G_I_Content_MD5,MD5Fingerprint(@Content,ContentLength)) 
          EndIf 
        Case #G_B_Request 
          
          Header.s = GetGadgetText(#G_I_Method)+" "+GetGadgetText(#G_I_File)+" "+GetGadgetText(#G_I_Protocol)+#CRLF$ 
          
          If GetGadgetText(#G_I_Host): Header + "Host: "+GetGadgetText(#G_I_Host)+#CRLF$ :EndIf 
          If GetGadgetText(#G_I_User_Agent): Header + "User-Agent: "+GetGadgetText(#G_I_User_Agent)+#CRLF$ :EndIf 
          If GetGadgetText(#G_I_Referer): Header + "Referer: "+GetGadgetText(#G_I_Referer)+#CRLF$ :EndIf 
          If GetGadgetText(#G_I_Content) 
            If GetGadgetText(#G_I_Content_Encoding): Header + "Content-Encoding: "+GetGadgetText(#G_I_Content_Encoding)+#CRLF$ :EndIf 
            If GetGadgetText(#G_I_Content_Language): Header + "Content-Language: "+GetGadgetText(#G_I_Content_Language)+#CRLF$ :EndIf 
            If GetGadgetText(#G_I_Content_Length): Header + "Content-Length: "+GetGadgetText(#G_I_Content_Length)+#CRLF$ :EndIf 
            If GetGadgetText(#G_I_Content_Location): Header + "Content-Location: "+GetGadgetText(#G_I_Content_Location)+#CRLF$ :EndIf 
            If GetGadgetText(#G_I_Content_MD5): Header + "Content-MD5: "+GetGadgetText(#G_I_Content_MD5)+#CRLF$ :EndIf 
            If GetGadgetText(#G_I_Content_Range): Header + "Content-Range: "+GetGadgetText(#G_I_Content_Range)+#CRLF$ :EndIf 
            If GetGadgetText(#G_I_Content_Type): Header + "Content-Type: "+GetGadgetText(#G_I_Content_Type)+#CRLF$ :EndIf 
          EndIf 
          
          Header + #CRLF$+GetGadgetText(#G_I_Content)+#CRLF$ 
          
          If CID: CloseNetworkConnection(CID):EndIf 
          CID = OpenNetworkConnection(GetGadgetText(#G_I_URI),Val(GetGadgetText(#G_I_Port))) 
          If CID 
            SendNetworkString(CID,Header) 
            SetGadgetText(#G_SourceCode,"") 
          EndIf 
      EndSelect 
    Case #PB_Event_CloseWindow 
      quit = 1 
    Case 0 
      Delay(10) 
  EndSelect 
  
  If CID 
    If NetworkClientEvent(CID) 
      SourceCode.s=Space(1024) 
      SourceCodelen = ReceiveNetworkData(CID,@SourceCode,1024) 
      SetGadgetText(#G_SourceCode,GetGadgetText(#G_SourceCode)+RTrim(SourceCode)) 
    EndIf 
  EndIf 
  
Until quit

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP