; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; CODE GÉNÉRÉ AUTOMATIQUEMENT, NE PAS MODIFIER À
; MOINS D'AVOIR UNE RAISON TRÈS TRÈS VALABLE !!!
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Code généré par : Dev-Type V3.44.166
; Nom du projet : Le nom du projet ici
; Nom du fichier : Nom du fichier
; Version du fichier : 0.0.0
; Programmation : À vérifier
; Programmé par : Guillaume Saumure
; Alias : Guimauve
; Courriel : gsaumure79@videotron.ca
; Date : 02-10-2011
; Mise à jour : 02-10-2011
; Codé pour PureBasic V4.60
; Plateforme : Windows, Linux, MacOS X
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Constantes de dimensionnement <<<<<

Enumeration
  
  #Txt_ProgramName
  
  #Txt_Author_00
  #Txt_Author_01
  #Txt_Author_02
  #Txt_Author_03
  #Txt_Author_04
  
  #Txt_Thanks_00
  #Txt_Thanks_01
  #Txt_Thanks_02
  
  #CREDIT_INFORMATIONS_MAX
  
EndEnumeration

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Déclaration de la Structure <<<<<

Structure Credit

  Window.Window
  Informations.s[#CREDIT_INFORMATIONS_MAX]

EndStructure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Les observateurs <<<<<

Macro GetCreditWindow(CreditA)

  CreditA\Window

EndMacro

Macro GetCreditInformations(CreditA, InformationsID)

  CreditA\Informations[InformationsID]

EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Les mutateurs <<<<<

Macro SetCreditWindow(CreditA, P_Window)

  GetCreditWindow(CreditA) = P_Window

EndMacro

Macro SetCreditInformations(CreditA, InformationsID, P_Informations)

  GetCreditInformations(CreditA, InformationsID) = P_Informations

EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< L'opérateur Reset <<<<<

Macro ResetCredit(CreditA)
  
  ResetWindow(GetCreditWindow(CreditA))
  
  For InformationsID = 0 To #CREDIT_INFORMATIONS_MAX - 1
    SetCreditInformations(CreditA, InformationsID, "")
  Next

EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Code généré en : 00.005 secondes (15600.00 lignes/seconde) <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< L'opérateur Initialize <<<<<

Procedure InitializeCredit(*CreditA.Credit)

  
  ClearStructure(*CreditA, Credit)
  InitializeStructure(*CreditA, Credit)
  
  UpdateWindow(GetCreditWindow(*CreditA), 0, 0, 400, 340)

  SetCreditInformations(*CreditA, #Txt_ProgramName, #Program_Name + " V" + #Program_Version + Str(#PB_Editor_BuildCount) + " (" + #Operating_System_Name + ")")
  SetCreditInformations(*CreditA, #Txt_Author_00, "LANGUAGE MESSAGE : AUTHORS")
  SetCreditInformations(*CreditA, #Txt_Author_01, "Jean-Yves LERICQUE/ GallyHC")
  SetCreditInformations(*CreditA, #Txt_Author_02, "Jesahel BENOIST / Djes")
  SetCreditInformations(*CreditA, #Txt_Author_03, "Yann LEBRUN / Thyphoon")
  SetCreditInformations(*CreditA, #Txt_Author_04, "Guillaume SAUMURE / Guimauve")
  SetCreditInformations(*CreditA, #Txt_Thanks_00, "LANGUAGE MESSAGE : SPECIAL THANKS")
  SetCreditInformations(*CreditA, #Txt_Thanks_01, "srod : GoScintilla")
  SetCreditInformations(*CreditA, #Txt_Thanks_02, "Fred Laboureur : Purebasic")


EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Code généré en : 00.012 secondes (16250.00 lignes/seconde) <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< L'opérateur Initialize <<<<<

Procedure OpenCreditWindow(*CreditA.Credit, *LanguageA.Language)
  
  If CreateWindowEx(#CreditWin, GetCreditWindow(*CreditA), "", #PB_Window_ScreenCentered, #MainWin)
    
    ImageGadget(#Image_Credit_Logo, (WindowWidth(#CreditWin) - #GadgetSpacing - ImageWidth(#Image_Logo)) >> 1, #GadgetSpacing, ImageWidth(#Image_Logo), ImageHeight(#Image_Logo), ImageID(#Image_Logo))
    
    ScrollAreaWidth = WindowWidth(#CreditWin) - 7 * #GadgetSpacing
    
    ScrollAreaGadget(#ScrollArea_Credit_Informations, #GadgetSpacing, GadgetDown(#Image_Credit_Logo) + 3 * #GadgetSpacing, WindowWidth(#CreditWin) - 2 * #GadgetSpacing, WindowHeight(#CreditWin) - ImageHeight(#Image_Logo) - 56, ScrollAreaWidth, (#CREDIT_INFORMATIONS_MAX + 2) * (#GadgetHeight + #GadgetSpacing), #PB_ScrollArea_Raised) 
      
      SetGadgetColor(#ScrollArea_Credit_Informations, #PB_Gadget_BackColor, RGB(255, 255, 255))
  
      PosY = #GadgetSpacing
      
      For InformationsID = 0 To #CREDIT_INFORMATIONS_MAX - 1
        
        If InformationsID = #Txt_Author_00
          PosY + #GadgetHeight
          TextGadget(#PB_Any, #GadgetSpacing, PosY, ScrollAreaWidth - 2 * #GadgetSpacing, #GadgetHeight, CreditMessage(*LanguageA, 0), #PB_Text_Center)
          
        ElseIf InformationsID = #Txt_Thanks_00
          PosY + #GadgetHeight
          TextGadget(#PB_Any, #GadgetSpacing, PosY, ScrollAreaWidth - 2 * #GadgetSpacing, #GadgetHeight, CreditMessage(*LanguageA, 1), #PB_Text_Center)
          
        Else
          TextGadget(#PB_Any, #GadgetSpacing, PosY, ScrollAreaWidth - 2 * #GadgetSpacing, #GadgetHeight, GetCreditInformations(*CreditA, InformationsID), #PB_Text_Center)
        EndIf
        
        PosY + #GadgetHeight
        
      Next
      
    CloseGadgetList()
    
    ButtonGadget(#Btn_Credit_Close, (WindowWidth(#CreditWin) - 120 - #GadgetSpacing) >> 1, WindowHeight(#CreditWin) - #GadgetHeight - #GadgetSpacing, 120, #GadgetHeight, "")
    
    Language_To_CreditWindow(*LanguageA)
    
    Repeat
      
      EventID = WaitWindowEvent()
      
      Select EventID
          
        Case #PB_Event_Menu
          
          Select EventMenu()
              
          EndSelect
          
        Case #PB_Event_Gadget
          
          Select EventGadget()
              
            Case #Btn_Credit_Close
              EventID = #PB_Event_CloseWindow
              
          EndSelect
          
      EndSelect
      
    Until EventID = #PB_Event_CloseWindow
    
    CloseWindow(#CreditWin)
    
  EndIf
  
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< FIN DU FICHIER <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<
; IDE Options = PureBasic 4.60 RC 1 (Linux - x64)
; CursorPosition = 161
; FirstLine = 124
; Folding = --
; EnableXP