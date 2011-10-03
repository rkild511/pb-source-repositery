; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; CODE GÉNÉRÉ AUTOMATIQUEMENT, NE PAS MODIFIER À
; MOINS D'AVOIR UNE RAISON TRÈS TRÈS VALABLE !!!
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Code généré par : Dev-Type V3.0.0
; Nom du projet : Le nom du projet ici
; Nom du fichier : Nom du fichier
; Version du fichier : 0.0.0
; Programmation : À vérifier
; Programmé par : Votre Nom Ici
; Alias : Votre Pseudo Ici
; Courriel : adresse@quelquechose.com
; Date : 02-05-2011
; Mise à jour : 02-05-2011
; Codé pour PureBasic V4.60
; Plateforme : Windows, Linux, MacOS X
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

CompilerIf #PB_Compiler_OS = #PB_OS_Linux
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Déclaration de la Structure <<<<<
  
  Structure Entry
    
    Key.s
    Value.s
    
  EndStructure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Les observateurs <<<<<
  
  Macro GetEntryKey(EntryA)
    
    EntryA\Key
    
  EndMacro
  
  Macro GetEntryValue(EntryA)
    
    EntryA\Value
    
  EndMacro
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Les mutateurs <<<<<
  
  Macro SetEntryKey(EntryA, P_Key)
    
    GetEntryKey(EntryA) = P_Key
    
  EndMacro
  
  Macro SetEntryValue(EntryA, P_Value)
    
    GetEntryValue(EntryA) = P_Value
    
  EndMacro
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< L'opérateur Update <<<<<
  
  Macro UpdateEntry(EntryA, P_Key, P_Value)
    
    SetEntryKey(EntryA, P_Key)
    SetEntryValue(EntryA, P_Value)
    
  EndMacro
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< L'opérateur Reset <<<<<
  
  Macro ResetEntry(EntryA)
    
    SetEntryKey(EntryA, "")
    SetEntryValue(EntryA, "")
    
  EndMacro
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< L'opérateur Reset <<<<<
  
  Macro WriteEntry(FileID, EntryA)
    
    WriteStringN(FileID, GetEntryKey(EntryA) + "=" + GetEntryValue(EntryA))
    
  EndMacro
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Déclaration de la Structure <<<<<
  
  Structure Desktop
    
    Path.s
    FileName.s
    List Entry.Entry()
    
  EndStructure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Les observateurs <<<<<
  
  Macro GetDesktopPath(DesktopA)
    
    DesktopA\Path
    
  EndMacro
  
  Macro GetDesktopFileName(DesktopA)
    
    DesktopA\FileName
    
  EndMacro
  
  Macro GetDesktopEntry(DesktopA)
    
    DesktopA\Entry()
    
  EndMacro
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Les mutateurs <<<<<
  
  Macro SetDesktopPath(DesktopA, P_Path)
    
    GetDesktopPath(DesktopA) = P_Path
    
  EndMacro
  
  Macro SetDesktopFileName(DesktopA, P_FileName)
    
    GetDesktopFileName(DesktopA) = P_FileName
    
  EndMacro
  
  Macro SetDesktopEntry(DesktopA, P_Entry)
    
    GetDesktopEntry(DesktopA) = P_Entry
    
  EndMacro
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Les macros complémentaires pour les Listes chaînées <<<<<
  
  Macro AddDesktopEntryElement(DesktopA, P_Key, P_Value)
    
    AddElement(GetDesktopEntry(DesktopA))
    UpdateEntry(GetDesktopEntry(DesktopA), P_Key, P_Value)
    
  EndMacro
  
  Macro ClearDesktopEntry(DesktopA)
    
    ClearList(GetDesktopEntry(DesktopA))
    
  EndMacro
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< L'opérateur Reset <<<<<
  
  Macro ResetDesktop(DesktopA)
    
    SetDesktopPath(DesktopA, "")
    SetDesktopFileName(DesktopA, "")
    
    ForEach GetDesktopEntry(DesktopA)
      ResetEntry(GetDesktopEntry(DesktopA))
    Next
    
    ClearDesktopEntry(DesktopA)
    ; ClearStructure(DesktopA, Desktop)

  EndMacro
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< Code généré en : 00.012 secondes (14916.67 lignes/seconde) <<<<<
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  
  Macro AddDesktopEntryType(DesktopA, P_Value)
    
    AddElement(GetDesktopEntry(DesktopA))
    UpdateEntry(GetDesktopEntry(DesktopA), "Type", P_Value)
    
  EndMacro
  
  Macro AddDesktopEntryExec(DesktopA, P_Value)
    
    AddElement(GetDesktopEntry(DesktopA))
    UpdateEntry(GetDesktopEntry(DesktopA), "Exec", P_Value)
    
  EndMacro
  
  Macro AddDesktopEntryName(DesktopA, P_Value)
    
    AddElement(GetDesktopEntry(DesktopA))
    UpdateEntry(GetDesktopEntry(DesktopA), "Name", P_Value)
    
  EndMacro
  
  Macro AddDesktopEntryComment(DesktopA, P_Value)
    
    AddElement(GetDesktopEntry(DesktopA))
    UpdateEntry(GetDesktopEntry(DesktopA), "Comment", P_Value)
    
  EndMacro
  
  Macro AddDesktopEntryNoDisplay(DesktopA, P_Value)
    
    AddElement(GetDesktopEntry(DesktopA))
    UpdateEntry(GetDesktopEntry(DesktopA), "NoDisplay", P_Value)
    
  EndMacro
  
  Macro AddDesktopEntryIcon(DesktopA, P_Value)
    
    AddElement(GetDesktopEntry(DesktopA))
    UpdateEntry(GetDesktopEntry(DesktopA), "Icon", P_Value)
    
  EndMacro
  
  Macro AddDesktopEntryCategories(DesktopA, P_Value)
    
    AddElement(GetDesktopEntry(DesktopA))
    UpdateEntry(GetDesktopEntry(DesktopA), "Categories", P_Value)
    
  EndMacro
  
  Macro AddDesktopEntryStartupNotify(DesktopA, P_Value)
    
    AddElement(GetDesktopEntry(DesktopA))
    UpdateEntry(GetDesktopEntry(DesktopA), "StartupNotify", P_Value)
    
  EndMacro
  
  Macro AddDesktopEntryVersion(DesktopA, P_Value)
    
    AddElement(GetDesktopEntry(DesktopA))
    UpdateEntry(GetDesktopEntry(DesktopA), "Version", P_Value)
    
  EndMacro
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< L'opérateur Initialize <<<<<
  
  Procedure InitializeDesktop(*DesktopA.Desktop, P_Path.s, P_FileName.s)
    
    If P_Path = ""
      SetDesktopPath(*DesktopA, GetHomeDirectory() + ".local/share/applications/")
    Else 
      SetDesktopPath(*DesktopA, P_Path)
    EndIf 
    
    SetDesktopFileName(*DesktopA, P_FileName)
    
  EndProcedure
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; <<<<< L'opérateur CreateDesktopFile <<<<<
  
  Procedure CreateDesktopFile(*DesktopA.Desktop)
    
    If FileSize(GetDesktopPath(*DesktopA) + GetDesktopFileName(*DesktopA)) = -1
      
      If CreateFile(0, GetDesktopPath(*DesktopA) + GetDesktopFileName(*DesktopA))
        
        WriteStringN(0, "")
        WriteStringN(0, "[Desktop Entry]")
        
        ForEach GetDesktopEntry(*DesktopA)
          WriteEntry(0, GetDesktopEntry(*DesktopA))
        Next
        
        ResetDesktop(*DesktopA)
        CloseFile(0)
        
      EndIf 
      
    EndIf
    
  EndProcedure
  
CompilerEndIf

; <<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< FIN DU FICHIER <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<
; IDE Options = PureBasic 4.60 RC 1 (Linux - x64)
; CursorPosition = 171
; FirstLine = 158
; Folding = ------
; EnableXP