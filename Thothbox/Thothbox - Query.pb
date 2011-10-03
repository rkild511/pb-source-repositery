; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; CODE GÉNÉRÉ AUTOMATIQUEMENT, NE PAS MODIFIER À
; MOINS D'AVOIR UNE RAISON TRÈS TRÈS VALABLE !!!
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Code généré par : Dev-Type V3.18.3
; Nom du projet : Le nom du projet ici
; Nom du fichier : Nom du fichier
; Version du fichier : 0.0.0
; Programmation : À vérifier
; Programmé par : Votre Nom Ici
; Alias : Votre Pseudo Ici
; Courriel : adresse@quelquechose.com
; Date : 25-09-2011
; Mise à jour : 25-09-2011
; Codé pour PureBasic V4.60
; Plateforme : Windows, Linux, MacOS X
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Enumeration
  
  #QUERY_METHOD_GET
  #QUERY_METHOD_POST
  #QUERY_METHOD_FILE
  
EndEnumeration

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Déclaration de la Structure <<<<<

Structure Query

  Method.b
  Host.s
  Port.l
  Path.s
  Boundary.s
  BufferPtr.i
  RawDataPtr.i
  DataPtr.i
  HeaderPtr.i
  Error.b
  DownCallback.i
  UpCallback.i
  List Headers.s()
  List PostData.s()
  List Files.HttpFile()

EndStructure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Les observateurs <<<<<

Macro GetQueryMethod(QueryA)

  QueryA\Method

EndMacro

Macro GetQueryHost(QueryA)

  QueryA\Host

EndMacro

Macro GetQueryPort(QueryA)

  QueryA\Port

EndMacro

Macro GetQueryPath(QueryA)

  QueryA\Path

EndMacro

Macro GetQueryBoundary(QueryA)

  QueryA\Boundary

EndMacro

Macro GetQueryBufferPtr(QueryA)

  QueryA\BufferPtr

EndMacro

Macro GetQueryRawDataPtr(QueryA)

  QueryA\RawDataPtr

EndMacro

Macro GetQueryDataPtr(QueryA)

  QueryA\DataPtr

EndMacro

Macro GetQueryHeaderPtr(QueryA)

  QueryA\HeaderPtr

EndMacro

Macro GetQueryError(QueryA)

  QueryA\Error

EndMacro

Macro GetQueryDownCallback(QueryA)

  QueryA\DownCallback

EndMacro

Macro GetQueryUpCallback(QueryA)

  QueryA\UpCallback

EndMacro

Macro GetQueryHeaders(QueryA)

  QueryA\Headers()

EndMacro

Macro GetQueryPostData(QueryA)

  QueryA\PostData()

EndMacro

Macro GetQueryFiles(QueryA)

  QueryA\Files()

EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Les mutateurs <<<<<

Macro SetQueryMethod(QueryA, P_Method)

  GetQueryMethod(QueryA) = P_Method

EndMacro

Macro SetQueryHost(QueryA, P_Host)

  GetQueryHost(QueryA) = P_Host

EndMacro

Macro SetQueryPort(QueryA, P_Port)

  GetQueryPort(QueryA) = P_Port

EndMacro

Macro SetQueryPath(QueryA, P_Path)

  GetQueryPath(QueryA) = P_Path

EndMacro

Macro SetQueryBoundary(QueryA, P_Boundary)

  GetQueryBoundary(QueryA) = P_Boundary

EndMacro

Macro SetQueryBufferPtr(QueryA, P_BufferPtr)

  GetQueryBufferPtr(QueryA) = P_BufferPtr

EndMacro

Macro SetQueryRawDataPtr(QueryA, P_RawDataPtr)

  GetQueryRawDataPtr(QueryA) = P_RawDataPtr

EndMacro

Macro SetQueryDataPtr(QueryA, P_DataPtr)

  GetQueryDataPtr(QueryA) = P_DataPtr

EndMacro

Macro SetQueryHeaderPtr(QueryA, P_HeaderPtr)

  GetQueryHeaderPtr(QueryA) = P_HeaderPtr

EndMacro

Macro SetQueryError(QueryA, P_Error)

  GetQueryError(QueryA) = P_Error

EndMacro

Macro SetQueryDownCallback(QueryA, P_DownCallback)

  GetQueryDownCallback(QueryA) = P_DownCallback

EndMacro

Macro SetQueryUpCallback(QueryA, P_UpCallback)

  GetQueryUpCallback(QueryA) = P_UpCallback

EndMacro

Macro SetQueryHeaders(QueryA, P_Headers)

  GetQueryHeaders(QueryA) = P_Headers

EndMacro

Macro SetQueryPostData(QueryA, P_PostData)

  GetQueryPostData(QueryA) = P_PostData

EndMacro

Macro SetQueryFiles(QueryA, P_Files)

  GetQueryFiles(QueryA) = P_Files

EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Les macros complémentaires pour les Listes chaînées <<<<<

Macro AddQueryHeadersElement(QueryA)

  AddElement(GetQueryHeaders(QueryA))

EndMacro

Macro AddQueryHeadersElementEx(QueryA, P_Element)

  AddElement(GetQueryHeaders(QueryA))
  SetQueryHeaders(QueryA, P_Element)

EndMacro

Macro InsertQueryHeadersElement(QueryA)

  InsertElement(GetQueryHeaders(QueryA))

EndMacro

Macro InsertQueryHeadersElementEx(QueryA, P_Element)

  InsertElement(GetQueryHeaders(QueryA))
  SetQueryHeaders(QueryA, P_Element)

EndMacro

Macro SelectQueryHeadersElement(QueryA, Position)

  SelectElement(GetQueryHeaders(QueryA), Position)

EndMacro

Macro PreviousQueryHeadersElement(QueryA)

  PreviousElement(GetQueryHeaders(QueryA))

EndMacro

Macro NextQueryHeadersElement(QueryA)

  NextElement(GetQueryHeaders(QueryA))

EndMacro

Macro FirstQueryHeadersElement(QueryA)

  FirstElement(GetQueryHeaders(QueryA))

EndMacro

Macro LastQueryHeadersElement(QueryA)

  LastElement(GetQueryHeaders(QueryA))

EndMacro

Macro PopListQueryHeadersPosition(QueryA)

  PopListPosition(GetQueryHeaders(QueryA))

EndMacro

Macro PushListQueryHeadersPosition(QueryA)

  PushListPosition(GetQueryHeaders(QueryA))

EndMacro

Macro DeleteQueryHeadersElement(QueryA, Flag = 0)

  DeleteElement(GetQueryHeaders(QueryA), Flag)

EndMacro

Macro ListQueryHeadersSize(QueryA)

  ListSize(GetQueryHeaders(QueryA))

EndMacro

Macro ResetQueryHeaders(QueryA)

  ResetList(GetQueryHeaders(QueryA))

EndMacro

Macro ListQueryHeadersIndex(QueryA)

  ListIndex(GetQueryHeaders(QueryA))

EndMacro

Macro ClearQueryHeaders(QueryA)

  ClearList(GetQueryHeaders(QueryA))

EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Les macros complémentaires pour les Listes chaînées <<<<<

Macro AddQueryPostDataElement(QueryA)

  AddElement(GetQueryPostData(QueryA))

EndMacro

Macro AddQueryPostDataElementEx(QueryA, P_Element)

  AddElement(GetQueryPostData(QueryA))
  SetQueryPostData(QueryA, P_Element)

EndMacro

Macro InsertQueryPostDataElement(QueryA)

  InsertElement(GetQueryPostData(QueryA))

EndMacro

Macro InsertQueryPostDataElementEx(QueryA, P_Element)

  InsertElement(GetQueryPostData(QueryA))
  SetQueryPostData(QueryA, P_Element)

EndMacro

Macro SelectQueryPostDataElement(QueryA, Position)

  SelectElement(GetQueryPostData(QueryA), Position)

EndMacro

Macro PreviousQueryPostDataElement(QueryA)

  PreviousElement(GetQueryPostData(QueryA))

EndMacro

Macro NextQueryPostDataElement(QueryA)

  NextElement(GetQueryPostData(QueryA))

EndMacro

Macro FirstQueryPostDataElement(QueryA)

  FirstElement(GetQueryPostData(QueryA))

EndMacro

Macro LastQueryPostDataElement(QueryA)

  LastElement(GetQueryPostData(QueryA))

EndMacro

Macro PopListQueryPostDataPosition(QueryA)

  PopListPosition(GetQueryPostData(QueryA))

EndMacro

Macro PushListQueryPostDataPosition(QueryA)

  PushListPosition(GetQueryPostData(QueryA))

EndMacro

Macro DeleteQueryPostDataElement(QueryA, Flag = 0)

  DeleteElement(GetQueryPostData(QueryA), Flag)

EndMacro

Macro ListQueryPostDataSize(QueryA)

  ListSize(GetQueryPostData(QueryA))

EndMacro

Macro ResetQueryPostData(QueryA)

  ResetList(GetQueryPostData(QueryA))

EndMacro

Macro ListQueryPostDataIndex(QueryA)

  ListIndex(GetQueryPostData(QueryA))

EndMacro

Macro ClearQueryPostData(QueryA)

  ClearList(GetQueryPostData(QueryA))

EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Les macros complémentaires pour les Listes chaînées <<<<<

Macro AddQueryFilesElement(QueryA)

  AddElement(GetQueryFiles(QueryA))

EndMacro

Macro AddQueryFilesElementEx(QueryA, P_Element)

  AddElement(GetQueryFiles(QueryA))
  SetQueryFiles(QueryA, P_Element)

EndMacro

Macro InsertQueryFilesElement(QueryA)

  InsertElement(GetQueryFiles(QueryA))

EndMacro

Macro InsertQueryFilesElementEx(QueryA, P_Element)

  InsertElement(GetQueryFiles(QueryA))
  SetQueryFiles(QueryA, P_Element)

EndMacro

Macro SelectQueryFilesElement(QueryA, Position)

  SelectElement(GetQueryFiles(QueryA), Position)

EndMacro

Macro PreviousQueryFilesElement(QueryA)

  PreviousElement(GetQueryFiles(QueryA))

EndMacro

Macro NextQueryFilesElement(QueryA)

  NextElement(GetQueryFiles(QueryA))

EndMacro

Macro FirstQueryFilesElement(QueryA)

  FirstElement(GetQueryFiles(QueryA))

EndMacro

Macro LastQueryFilesElement(QueryA)

  LastElement(GetQueryFiles(QueryA))

EndMacro

Macro PopListQueryFilesPosition(QueryA)

  PopListPosition(GetQueryFiles(QueryA))

EndMacro

Macro PushListQueryFilesPosition(QueryA)

  PushListPosition(GetQueryFiles(QueryA))

EndMacro

Macro DeleteQueryFilesElement(QueryA, Flag = 0)

  DeleteElement(GetQueryFiles(QueryA), Flag)

EndMacro

Macro ListQueryFilesSize(QueryA)

  ListSize(GetQueryFiles(QueryA))

EndMacro

Macro ResetQueryFiles(QueryA)

  ResetList(GetQueryFiles(QueryA))

EndMacro

Macro ListQueryFilesIndex(QueryA)

  ListIndex(GetQueryFiles(QueryA))

EndMacro

Macro ClearQueryFiles(QueryA)

  ClearList(GetQueryFiles(QueryA))

EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< L'opérateur Reset <<<<<

Macro ResetQuery(QueryA)
  
  SetQueryMethod(QueryA, 0)
  SetQueryHost(QueryA, "")
  SetQueryPort(QueryA, 0)
  SetQueryPath(QueryA, "")
  SetQueryBoundary(QueryA, "")

  If GetQueryBufferPtr(QueryA) <> #Null
    FreeMemory(GetQueryBufferPtr(QueryA))
    SetQueryBufferPtr(QueryA, #Null)
  EndIf
  
  If GetQueryRawDataPtr(QueryA) <> #Null
    FreeMemory(GetQueryRawDataPtr(QueryA))
    SetQueryRawDataPtr(QueryA, #Null)
  EndIf
  
  If GetQueryDataPtr(QueryA) <> #Null
    FreeMemory(GetQueryDataPtr(QueryA))
    SetQueryDataPtr(QueryA, #Null)
  EndIf
  
  If GetQueryHeaderPtr(QueryA) <> #Null
    FreeMemory(GetQueryHeaderPtr(QueryA))
    SetQueryHeaderPtr(QueryA, #Null)
  EndIf
  
  SetQueryError(QueryA, 0)
  SetQueryDownCallback(QueryA, 0)
  SetQueryUpCallback(QueryA, 0)
  
  ForEach GetQueryHeaders(QueryA)
    SetQueryHeaders(QueryA, "")
  Next
  
  ClearQueryHeaders(QueryA)
  
  ForEach GetQueryPostData(QueryA)
    SetQueryPostData(QueryA, "")
  Next
  
  ClearQueryPostData(QueryA)
  
  ForEach GetQueryFiles(QueryA)
    ResetHttpFile(GetQueryFiles(QueryA))
  Next
  
  ClearQueryFiles(QueryA)
  
  ClearStructure(QueryA, Query)
  InitializeStructure(QueryA, Query)

EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< L'opérateur Initialize <<<<<

Procedure InitializeQuery(*QueryA.Query)
  
  SetQueryMethod(*QueryA, 0)
  SetQueryHost(*QueryA, "")
  SetQueryPort(*QueryA, 0)
  SetQueryPath(*QueryA, "")
  SetQueryBoundary(*QueryA, "")
  
  
  SetQueryBufferPtr(*QueryA, 0)
  SetQueryRawDataPtr(*QueryA, 0)
  SetQueryDataPtr(*QueryA, 0)
  SetQueryHeaderPtr(*QueryA, 0)
  
  
  
  SetQueryError(*QueryA, 0)
  SetQueryDownCallback(*QueryA, 0)
  SetQueryUpCallback(*QueryA, 0)
  
  ForEach GetQueryHeaders(*QueryA)
    SetQueryHeaders(*QueryA, "")
  Next
  
  ClearQueryHeaders(*QueryA)
  
  ForEach GetQueryPostData(*QueryA)
    SetQueryPostData(*QueryA, "")
  Next
  
  ClearQueryPostData(*QueryA)
  
  ForEach GetQueryFiles(*QueryA)
    ResetHttpFile(GetQueryFiles(*QueryA))
  Next
  
  ClearQueryFiles(*QueryA)
  
  ClearStructure(*QueryA, Query)
  InitializeStructure(*QueryA, Query)

EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Code généré en : 00.016 secondes (38250.00 lignes/seconde) <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< L'opérateur InitializeQueryHeaders <<<<<

Procedure InitializeQueryHeaders(*QueryA.Query, *ProxyA.Proxy)
 
  If GetProxyIsRequired(*ProxyA) = #True 
    AddQueryHeadersElementEx(*QueryA, "Proxy-Authorization: Basic " + FormatProxy(*ProxyA))
  EndIf
  
  AddQueryHeadersElementEx(*QueryA, "Host: " + GetQueryHost(*QueryA))
  
  Select GetQueryMethod(*QueryA)
      
    Case #QUERY_METHOD_GET
      
    Case #QUERY_METHOD_POST
      AddQueryHeadersElementEx(*QueryA, "Content-type: application/x-www-form-urlencoded")
      
    Case #QUERY_METHOD_FILE
      SetQueryBoundary(*QueryA, LSet("", 10, "-") + Str(ElapsedMilliseconds()))
      AddQueryHeadersElementEx(*QueryA, "Content-type: multipart/form-data; boundary=" + GetQueryBoundary(*QueryA))
      
  EndSelect
  
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< FIN DU FICHIER <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<
; IDE Options = PureBasic 4.60 RC 1 (Linux - x64)
; CursorPosition = 665
; FirstLine = 534
; Folding = -------------z
; EnableXP