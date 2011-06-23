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
If CreatePack(NomFichier$);cr�e le le fichier qui va �tre compress� 

   ;tu peux choisir un ou plusieur fichiers � compresser 
   packers$ = OpenFileRequester("Choisissez le(s) fichiers a compresser","tout","*.*",0, #PB_Requester_MultiSelection) 

   If packers$                                      ; teste si la chaine existe 
      Repeat 
         Fichier$ = GetFilePart(packers$)           ; r�cup�re seulement le nom de fichier 
         AddPackMemory(@Fichier$,Len(Fichier$)+1)   ; ajoute le nom de fichier, la zone m�moire �tant la chaine Fichier$ 
                                                    ; on ajoute 1 � len(Fichier$) pour �crire le 0 qui est le caract�te de fin 
                                                    ; de chaine 
         AddPackFile(packers$ ,9)                   ; rajoute la selection et niveau de compression 9 
         packers$ = NextSelectedFileName()          ; ajoute le fichier compress� 
      Until packers$ = ""                          ; on reboucle tant qu'il y a des fichiers compress�s 
      ClosePack()                                   ;ferme le pack 
   Else 
    MessageRequester("Information", "Aucun fichier n'a �t� s�lectionn�", #MB_ICONERROR) 
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

;   MessageRequester("Ok","OpenPack a r�ussi",16)  ; on affiche que l'ouverture du fichier compress� a r�ussie 
   Repertoire.s = PathRequester("Ou d�compresser les fichiers ?","") 
   NomFichier.s = Space(256)  ; cr�e la variable chaine qui r�cup�rera le nom de fichier courant 

   AdresseMemoire = NextPackFile()                ; On r�cup�re le premier �l�ment compress�, c'est-�-dire le nom du fichier 

   While AdresseMemoire                          ; on d�bute la boucle 
;       Debug("AdresseMemoire")                   ; la variable utilis�e AdresseMemoire est partag�, tu doit utiliser 
;       Debug(AdresseMemoire )                    ; la m�me pour r�cup�rer le nom de fichier et le fichier lui-m�me 
;       Debug("") 
      
      NomFichier = PeekS(AdresseMemoire)          ; r�cup�re le nom de fichier en situ� en m�moire 
;      Debug(NomFichier) 
  
      AdresseMemoire = NextPackFile()             ; r�cup�re l'adresse du fichier � d�compresser 

      Taille = PackFileSize()                     ; r�cup�re la taille du fichier � d�compresser 

      CreateFile(#FicherCourant,Repertoire + NomFichier)        ; on cr�e le fichier sur le disque avec le r�pertoire s�lectionn� 
      WriteData(#FicherCourant,AdresseMemoire ,Taille )           ; on �crit le contenu du fichier 
      CloseFile(#FicherCourant)                    ; on ferme le fichier 

      AdresseMemoire = NextPackFile()              ; on continue l'op�ration tant que adresseMemoire est diff�rent de 0 
   Wend 
   ClosePack()                                     ;ferme le pack 

Else 
   MessageRequester("Erreur","OpenPack a �chou�",16) 
EndIf 

EndProcedure 


;;================================================================================================================== 
;;================================================================================================================== 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
