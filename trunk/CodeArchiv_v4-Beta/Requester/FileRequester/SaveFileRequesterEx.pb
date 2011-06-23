; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13318&highlight=
; Author: Chris (updated for PB 4.00 by Andre)
; Date: 08. December 2004
; OS: Windows
; Demo: Yes


; Procedure for saving files. 
; ---------------------------
; Explanation. 
; If several extensions are contained in the filter, (eg: *.jpg; *.jpeg; *.bmp), 
; and if you don't specify any extension in the title of the file, or if you 
; put an extension which is not contained in the filter, (eg: .png), the file 
; will be saved with the first extension found in the selected filter (eg: .jpg) 
; 
; If you put an extension, and if she is contained in the filter, the file will 
; be saved with the extension you are entered. 
; 
; If you choose "all types", you can save with the extension which you want. 
; (eg: .glop), and if you don't put extension, it will have nothing. 

Procedure.s SaveFile(Titre$, Defaut$, Filtre$, Position) 
  ;{- Getting the extensions and associated indexes 
  Structure SAUVEFICHIERS 
    id.w 
    Extens.s 
  EndStructure 
  NewList Extensions.SAUVEFICHIERS() 
  
  Num = 0 : I = 1 : J = 2 
  
  Repeat 
    Typ$ = StringField(Filtre$, I, "|") 
    Ext$ = StringField(Filtre$, J, "|") 
    
    If Ext$ 
      If FindString(Ext$, ";", 1) 
        Count = CountString(Ext$, ";") 
        For k = 0 To Count 
          n$ = StringField(Ext$, k + 1, ";") 
          AddElement(Extensions()) 
          Extensions()\id = Num 
          Extensions()\Extens = StringField(n$, 2, ".") ;n$ 
        Next 
      Else 
        AddElement(Extensions()) 
        Extensions()\id = Num 
        Extensions()\Extens = StringField(Ext$, 2, ".") ;Ext$ 
      EndIf 
    EndIf 
    I + 2 : J + 2 : Num + 1 
  Until Ext$ = "" Or Typ$ = "" 
  ;}- 
  
  ;{- Treatment of the filenames 
  ; 
  Full_Path$ = SaveFileRequester(Titre$, Defaut$, Filtre$, Position) 
  
  If Full_Path$ 
    ; Verify that the path does not ended by a point 
    If Right(Full_Path$,1) = "." 
      Full_Path$  = Left(Full_Path$, Len(Full_Path$)-1) 
    EndIf 
    
    ; Getting de datas of the file 
    Fic_Chemin$     = GetPathPart(Full_Path$) 
    Fic_Extension$  = GetExtensionPart(Full_Path$) 
    Fic_Fichier$    = StringField(GetFilePart(Full_Path$),1,".") 
    Fic_Index       = SelectedFilePattern() 
    
    ; Vérifiez que le choix n'est pas "*. *". 
    ForEach Extensions() 
      If Extensions()\id = Fic_Index And Extensions()\Extens = "*" 
        If Fic_Extension$ 
          ProcedureReturn Fic_Chemin$+Fic_Fichier$+"."+Fic_Extension$ 
        Else 
          ProcedureReturn Fic_Chemin$+Fic_Fichier$ 
        EndIf 
        Break 
      EndIf 
    Next 
    ResetList(Extensions()) 
    
    ; If the choice are not "*.*" 
    ForEach Extensions() 
      If Extensions()\id = Fic_Index 
        P = ListIndex(Extensions()) 
        Fic_Def$ = Extensions()\Extens 
        Break 
      EndIf 
    Next 
    
    If Fic_Extension$ 
      SelectElement(Extensions(),P) 
      While Extensions()\id = Fic_Index 
        If Extensions()\Extens = Fic_Extension$ 
          Extension$ = Extensions()\Extens 
          Break 
        Else 
          Extension$ = Fic_Def$ 
        EndIf 
        NextElement(Extensions()) 
      Wend 
    Else 
      Extension$ = Fic_Def$ 
    EndIf 
    
    NomFichier$ = Fic_Chemin$ + Fic_Fichier$ + "." + Extension$ 
    ClearList(Extensions()) 
    ProcedureReturn NomFichier$ 
  Else 
    ClearList(Extensions()) 
    ProcedureReturn 
  EndIf ;} 
EndProcedure 

;-============================ Procedure test ============================ 
;/ Title 
T$ = "Save a file" 
;/ Default file & path 
D$ = "\..\PureBasic\ParDefaut.txt" 
;/ Filters 
F$ = "Fichiers texte (*.txt)|*.txt|Texte enrichi (*.rtf,rtx,rty,rtz)|*.rtf;*.rtx;*.rty;*.rtz|Format Word (*.doc,*.dog,*.dod)|*.doc;*.dog;*.dod|Tous types (*.*)|*.*" 
;/ Default position 
P = 1 

CheminFichier$ = SaveFile(T$,D$,F$,P) ; appel de la procédure 

If CheminFichier$ 
  MessageRequester("Saved file", "A file have been saved in:"+Chr(10) + CheminFichier$, #MB_ICONINFORMATION) 
EndIf 

If CheminFichier$ 
  If CreateFile(0, CheminFichier$) 
    CloseFile(0) 
  EndIf 
EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -