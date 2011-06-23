; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6465&highlight=
; Author: Denis (updated for PB4.00 by blbltheworm)
; Date: 12. June 2003
; OS: Windows
; Demo: Yes

; Here are 2 procedures to pack and unpack files with their filenames without Path. 
; It's an example i was sending on french forum last month, so it's french commented. 

; The pack will be like this:
; 1st file name, file1, 2nd file name, file2 and so one. 


#MB_ICONERROR  = 16 
#FicherCourant = 1 


;;================================================================================================================== 
;;================================================================================================================== 

Procedure.l Compresse(NomFichier$) 

Resultat = 1 
If CreatePack(NomFichier$);crée le le fichier qui va être compressé 

   ;tu peux choisir un ou plusieur fichiers à compresser 
   packers$ = OpenFileRequester("Choisissez le(s) fichiers a compresser","tout","*.*",0, #PB_Requester_MultiSelection) 

   If packers$                                      ; teste si la chaine existe 
      Repeat 
         Fichier$ = GetFilePart(packers$)           ; récupère seulement le nom de fichier 
         AddPackMemory(@Fichier$,Len(Fichier$)+1)   ; ajoute le nom de fichier, la zone mémoire étant la chaine Fichier$ 
                                                    ; on ajoute 1 à len(Fichier$) pour écrire le 0 qui est le caractète de fin 
                                                    ; de chaine 
         AddPackFile(packers$ ,9)                   ; rajoute la selection et niveau de compression 9 
         packers$ = NextSelectedFileName()          ; ajoute le fichier compressé 
      Until packers$ = ""                          ; on reboucle tant qu'il y a des fichiers compressés 
      ClosePack()                                   ;ferme le pack 
   Else 
    MessageRequester("Information", "Aucun fichier n'a été sélectionné", #MB_ICONERROR) 
    Resultat = 0 
   EndIf 
Else 
    Resultat = 0 
EndIf 

ProcedureReturn Resultat 

EndProcedure 


;;================================================================================================================== 
;;================================================================================================================== 

Procedure Decompresse(FichierCompresser$) 

If OpenPack(FichierCompresser$) 

;   MessageRequester("Ok","OpenPack a réussi",16)  ; on affiche que l'ouverture du fichier compressé a réussie 
   Repertoire.s = PathRequester("Ou décompresser les fichiers ?","") 
   NomFichier.s = Space(256)  ; crée la variable chaine qui récupèrera le nom de fichier courant 

   AdresseMemoire = NextPackFile()                ; On récupère le premier élément compressé, c'est-à-dire le nom du fichier 

   While AdresseMemoire                          ; on débute la boucle 
;       Debug("AdresseMemoire")                   ; la variable utilisée AdresseMemoire est partagé, tu doit utiliser 
;       Debug(AdresseMemoire )                    ; la même pour récupérer le nom de fichier et le fichier lui-même 
;       Debug("") 
      
      NomFichier = PeekS(AdresseMemoire)          ; récupère le nom de fichier en situé en mémoire 
;      Debug(NomFichier) 
  
      AdresseMemoire = NextPackFile()             ; récupère l'adresse du fichier à décompresser 

      Taille = PackFileSize()                     ; récupère la taille du fichier à décompresser 

      CreateFile(#FicherCourant,Repertoire + NomFichier)        ; on crée le fichier sur le disque avec le répertoire sélectionné 
      WriteData(#FicherCourant,AdresseMemoire ,Taille )           ; on écrit le contenu du fichier 
      CloseFile(#FicherCourant)                    ; on ferme le fichier 

      AdresseMemoire = NextPackFile()              ; on continue l'opération tant que adresseMemoire est différent de 0 
   Wend 
   ClosePack()                                     ;ferme le pack 

Else 
   MessageRequester("Erreur","OpenPack a échoué",16) 
EndIf 

EndProcedure 


;;================================================================================================================== 
;;================================================================================================================== 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
