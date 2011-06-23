; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1397&highlight=
; Author: Thorsten (updated for PB4.00 by blbltheworm)
; Date: 18. June 2003
; OS: Windows
; Demo: No


; Procedures & Callbacks for loading + saving data in EditorGadget (Richedit)
; ----------------------------------------------------------------------------

; Hinweis: 
; Die Idee und das Grundgerüst zum laden stammt von El_Choni 
; aus dem englischen Forum - ich habe es etwas vereinfacht und 
; die schreibe - Procedure erstellt.
; 

;- Load *******
Procedure StreamFileIn_Callback(hFile, pbBuff, cb, pcb) 
  ProcedureReturn ReadFile_(hFile, pbBuff, cb, pcb, 0)!1 
EndProcedure 

; Hier eine Procedure + Callback zum laden einer Datei: 
; 
; FileID freie ID für Dateioperationen 
; File Die Datei ggf. mit Pfad 
; Gadget Gadget ID vom EditorGadget() 

Procedure FileStreamIn(FileID.l, File.s, Gadget.l) 
  
  ;Procedure zum streamen einer Datei in das RichEdit 
  ;Control 

  Protected StreamData.EDITSTREAM 
  
  ;Wenn die Datei geöffnet werden kann, fortfahren.  
  If ReadFile(FileID, File)    
        
    ;Das Handle der Datei speichern 
    StreamData\dwCookie = FileID(FileID) 
    StreamData\dwError = #Null 
    
    ;Die Adresse der Callback Procedure speichern 
    StreamData\pfnCallback = @StreamFileIn_Callback() 
    
    ;Das RichEdit Control anweisen, den Stream zu aktivieren 
    SendMessage_(GadgetID(Gadget), #EM_STREAMIN, #SF_TEXT, @StreamData) 
    
    ;Datei schliessen 
    CloseFile(FileID) 
    
  EndIf 

EndProcedure 
 

;- Save *******
Procedure StreamFileOut_Callback(hFile, pbBuff, cb, pcb) 
  ProcedureReturn WriteFile_(hFile, pbBuff, cb, pcb, 0)!1 
EndProcedure 
 

; Hier eine Procedure + Callback zum speichern einer Datei: 
; 
; FileID freie ID für Dateioperationen 
; File Die Datei ggf. mit Pfad 
; Gadget Gadget ID vom EditorGadget() 

Procedure FileStreamOut(FileID.l, File.s, Gadget.l) 

  Protected StreamData.EDITSTREAM 
  
  ;Wenn die Datei erzeugt werden kann, fortfahren.  
  If CreateFile(FileID, File) 
        
    ;Das Handle der Datei speichern 
    StreamData\dwCookie = FileID(FileID) 
    StreamData\dwError = #Null 
    
    ;Die Adresse der Callback Procedure speichern 
    StreamData\pfnCallback = @StreamFileOut_Callback() 
    
    ;Das RichEdit Control anweisen, den Stream zu aktivieren 
    SendMessage_(GadgetID(Gadget), #EM_STREAMOUT, #SF_TEXT, @StreamData) 
    
    ;Datei schliessen 
    CloseFile(FileID) 
    
  EndIf 

EndProcedure 
 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
