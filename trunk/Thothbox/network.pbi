Procedure servercall()
  Protected http.HTTP_Query,*mem
  If gp\useProxy=#True
    HTTP_proxy(@http,gp\proxy\host,gp\proxy\port,gp\proxy\login,gp\proxy\password)
  EndIf
  HTTP_query(@http, #HTTP_METHOD_POST, "http://www.thyphoon.com/test.php")
  HTTP_addQueryHeader(@http, "User-Agent", "PB")
  HTTP_addPostData(@http, "info", "")
  *mem=HTTP_receiveRawData(@http)
  If *mem<>0
    MessageRequester("Server Back",PeekS(*mem, #PB_Ascii))
  Else
    MessageRequester("Server Back","Error")
  EndIf
EndProcedure
; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 12
; Folding = -
; EnableXP