; German forum: http://www.purebasic.fr/german/viewtopic.php?t=35&highlight=
; Author: brotkasten-deluxe (updated for PB 4.00 by Andre)
; Date: 30. August 2004
; OS: Windows
; Demo: No

; Daten direkt in ein WebGadget reinstreamen, ohne den Umweg über eine Datei zu gehen

Global WebObject.IWebBrowser2 

Procedure link() 
    If WebObject\get_document(@pDispatch.IDispatch) = #S_OK 
        If pDispatch\QueryInterface(?IID_IHTMLDocument2, @pDocument2.IHTMLDocument2) = #S_OK        
            If pDocument2\elementFromPoint(WindowMouseX(0) , WindowMouseY(0) , @pElement.IHTMLElement) = #S_OK            
                If pElement\QueryInterface(?IID_IHTMLAnchorElement, @pAnchor.IHTMLAnchorElement)= #S_OK                    
                  pAnchor\get_href(@BSTR_Anchor) 
                  aLen = WideCharToMultiByte_(#CP_ACP, 0, BSTR_Anchor, -1, 0, 0, 0, 0) 
                  anchor$ = Space(aLen) 
                  WideCharToMultiByte_(#CP_ACP, 0, BSTR_Anchor, -1, @anchor$, aLen, 0, 0) 
                  SysFreeString_(BSTR_Anchor)              
                  If currentsb$ <> anchor$ 
                    StatusBarText(0, 0, anchor$) 
                    currentsb$ = anchor$ 
                  EndIf              
                pAnchor\Release() 
                EndIf                            
            pElement\Release() 
            EndIf        
      pDocument2\Release() 
      EndIf          
    pDispatch\Release()  
    EndIf 
EndProcedure 


If OpenWindow(0, 10, 10, 700, 500, "WebGadget ReadyState", #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 

  If CreateStatusBar(0, WindowID(0)) 
    StatusBarText(0, 0, "") 
  EndIf 
      
  If CreateGadgetList(WindowID(0)) 
    WebGadget(0, 10, 10, 680, 460, "www.purebasic.com") 
    WebObject = GetWindowLong_(GadgetID(0), #GWL_USERDATA) 
  EndIf 
    
EndIf 

Repeat 
   EventID.l=WaitWindowEvent() 
        
    If   hBrowser = 0 
       hChild1 = FindWindowEx_(GadgetID(0), 0, "Shell Embedding", 0) 
        hChild2 = FindWindowEx_(hChild1, 0, "Shell DocObject View", 0) 
        hBrowser = FindWindowEx_(hChild2, 0, "Internet Explorer_Server", 0) 
        SetParent_(hBrowser,WindowID(0)) 
    EndIf 
  
  If isBusy 
    WebObject\get_ReadyState(@isReady) 
      
      Select isReady 
        Case 1 
        page=0 
          StatusBarText(0, 0, "Page Loading") 
          
        Case 2 
          StatusBarText(0, 0, "Page Loaded") 
          
        Case 3 
          page=1 
          StatusBarText(0, 0, "Page is interactive with some data missing") 
          
        Case 4 
          page=1 
          StatusBarText(0, 0, "Page finished loading") 
          
      EndSelect 
  EndIf 
          
  WebObject\get_busy(@isBusy) 
  

      Select EventID 
        Case #WM_MOUSEMOVE 
        Hcursor=GetCursor_() 
        If page 
            If Hcursor<>65555 And  Hcursor<>65553 
            link() 
            Else 
            StatusBarText(0, 0, "") 
            EndIf 
        EndIf 
        
        Case #WM_CLOSE 
            quit=1 
    EndSelect 

Until quit=1 

End 

DataSection 
IID_IHTMLDocument2: 
;332C4425-26CB-11D0-B483-00C04FD90119 
Data.l $332C4425 
Data.w $26CB, $11D0 
Data.b $B4, $83, $00, $C0, $4F, $D9, $01, $19 

IID_IHTMLAnchorElement: 
;3050F1DA-98B5-11CF-BB82-00AA00BDCE0B 
Data.l $3050F1DA 
Data.w $98B5, $11CF 
Data.b $BB, $82, $00, $AA, $00, $BD, $CE, $0B 

EndDataSection
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -