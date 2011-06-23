; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8302&highlight=
; Author: Karbon
; Date: 12. November 2003
; OS: Windows
; Demo: No


; Note by Andre: I've changed #INTERNET_DEFAULT_HTTP_PORT = 443 to 
;                #INTERNET_DEFAULT_HTTPS_PORT = 443  (be aware of the additional 'S' at '_HTTPS_')
;                because the #INTERNET_DEFAULT_HTTP_PORT constant is already declared in a .res
;                file with another value

; This one does SSL, all you need to do for standard HTTP is change the
; INTERNET_FLAG_SECURE To 0 and the port to 80. 

  ; 
  ; All stuff for the WinInet lib. 
  ; 
  #INTERNET_OPEN_TYPE_DIRECT = 1 
  #HTTP_ADDREQ_FLAG_ADD = $20000000 
  #HTTP_ADDREQ_FLAG_REPLACE = $80000000 
  #INTERNET_FLAG_SECURE = $800000 
  
  ; 
  ; Type of connection (could be FTP Gopher etc). HTTPS is done as HTTP too. 
  ; 
  #INTERNET_SERVICE_HTTP = 3 
  
  ; 
  ; HTTP port is 80, HTTPS (SSL) port is 443. 
  ; 
  #INTERNET_DEFAULT_HTTPS_PORT = 443  

Procedure do_post() 

  ; 
  ; Do NOT include http:// or any other protocol indicator here 
  ; 
  host.s = "secure.example.com" 
  
  ; 
  ; Everything after the hostname of the server 
  ; 
  get_url.s = "/pb_test.php" 
  
  ; 
  ; Holds the result from the CGI/page 
  ; 
  result.s = "" 
  
  ; 
  ; All from the wininet DLL 
  ; 
  ; Be sure your Internet Explorer is up to date! 
  ; 
  open_handle = InternetOpen_("User Agent Info Goes Here",#INTERNET_OPEN_TYPE_DIRECT,"","",0) 
  
  connect_handle = InternetConnect_(open_handle,host,#INTERNET_DEFAULT_HTTPS_PORT,"","",#INTERNET_SERVICE_HTTP,0,0) 
  
  request_handle = HttpOpenRequest_(connect_handle,"POST",get_url,"","",0,#INTERNET_FLAG_SECURE,0) 
  
  headers.s = "Content-Type: application/x-www-form-urlencoded" +Chr(13)+Chr(10)  
  
  HttpAddRequestHeaders_(request_handle,headers,Len(headers), #HTTP_ADDREQ_FLAG_REPLACE | #HTTP_ADDREQ_FLAG_ADD) 
  
  post_data.s = "testval=dootdedootdoot" 
  
  post_data_len = Len(post_data) 
  
  send_handle = HttpSendRequest_(request_handle,"",0,post_data,post_data_len) 
  
  buffer.s = Space(1024) 
  
  bytes_read.l 
  
  total_read.l 
  
  total_read = 0 
  
  ; 
  ; Read until we can't read anymore.. 
  ; The string "result" will hold what ever the server pushed at us. 
  ; 
  Repeat 
    
    InternetReadFile_(request_handle,@buffer,1024,@bytes_read) 
    
    result + Left(buffer,bytes_read) 
    
    buffer = Space(1024) 
    
  Until bytes_read=0 
  
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
