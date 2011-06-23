; English forum: http://www.purebasic.fr/english/viewtopic.php?t=5313
; Author: Denis  (updated for PB3.92+ by Andre, updated for PB4.00 by blbltheworm)
; Date: 18. April 2003
; OS: Windows
; Demo: No


; *** Example for using Icons in a combobox ***

;;/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
;                  Windows structures
;;/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\

; Structure COMBOBOXEXITEM
;   mask.l
;   iItem.l
;   pszText.l
;   cchTextMax.l
;   iImage.l
;   iSelectedImage.l
;   iOverlay.l
;   iIndent.l
;   lParam.l
; EndStructure
; 
;;/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
;                   structure
;;/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\

Structure DriveInfos
   DriveLetter.s
   DriveType.l
   DriveTypeString.s
   NameOfVolume.s
EndStructure

;;/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
;                  Some windows constants
;;/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\

#ICC_USEREX_CLASSES  = $200
#WS_CHILD            = $40000000
#WS_VISIBLE          = $10000000
#CBS_DROPDOWN        = 2
#CBS_AUTOHSCROLL     = $40
#WS_VSCROLL          = $200000
#SHGFI_SYSICONINDEX  = $4000
#SHGFI_SMALLICON     = 1
#CLR_NONE            = $FFFFFFFF
#CBEM_SETIMAGELIST   = $00000402
#CBEM_INSERTITEM     = $00000401
#CBEIF_TEXT          = $00000001
#CBEIF_IMAGE         = $00000002
#CBEIF_SELECTEDIMAGE = $00000004
#CB_SETCURSEL        = $14E

#DRIVE_REMOVABLE     = 2
#DRIVE_FIXED         = 3
#DRIVE_REMOTE        = 4
#DRIVE_CDROM         = 5
#DRIVE_RAMDISK       = 6


;;/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
;                  COMBOBOX Style
;;/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\

#EDITCOMBOBOX = #WS_CHILD| #WS_VISIBLE |#CBS_DROPDOWN | #CBS_AUTOHSCROLL | #WS_VSCROLL

;;/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
;                  some Global vars
;;/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\

Global MainWindowID.l, Hinstance.l,HwndComboBox.l

;;/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\

;;/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*
;;/*/*/*/*/*/*/*/            Procedures           /*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*
;;/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*
Procedure.l CreateComboBoxGadget()
  ; return 0 if Combobox failed  Otherwise return Handle of combobox

  Hinstance = GetModuleHandle_(0)

; ComboBoxEx control must be initialized by calling the InitCommonControlsEx before calling CreateWindowEx API
; dwICC member of INITCOMMONCONTROLSEX structure must have #ICC_USEREX_CLASSES value
; CreateWindowEx class name must be ComboBoxEx32

  Var.INITCOMMONCONTROLSEX
  Var\dwSize = SizeOf(INITCOMMONCONTROLSEX)
  Var\dwICC  = #ICC_USEREX_CLASSES

  If InitCommonControlsEx_(@Var)
; CreateWindowEx parameters to create Combobox with Icons :
; CreateWindowEx_(#WS_EX_WINDOWEDGE,  --> extended combobox window style
;                 "ComboBoxEx32",     --> class name
;                 0,                  --> window name; put 0 when no name
;                 #EDITCOMBOBOX,      --> combobox window style
;                 40,                 --> horizontal position combobox 
;                 10,                 --> vertical position of combobox 
;                 300,                --> combobox width
;                 150,                --> combobox drop-down list height, not combobox height
;                 MainWindowID,       --> handle to parent or owner window, here main window
;                 0,                  --> handle to menu, or child-window identifier, put 0 when not exist
;                 Hinstance,          --> handle to application instance, --> Hinstance = GetmoduleHandle_(0)
;                 0)                  --> pointer to window-creation data, 0 here (see MS doc)

     HwndComboBox  = CreateWindowEx_(2, "ComboBoxEx32", 0, #EDITCOMBOBOX, 40, 10, 300,150, MainWindowID , 0, Hinstance, 0)
; get image list
     Path.s=Space(255)
     GetCurrentDirectory_(255,@Path)  ; Path = Current Directory string
     hImageList.l = SHGetFileInfo_(Path, 0, @InfosFile.SHFILEINFO, SizeOf(SHFILEINFO), #SHGFI_SYSICONINDEX |#SHGFI_SMALLICON)
     ImageList_SetBkColor_(hImageListS,#CLR_NONE)
; assign image list to Combobox
    SendMessage_(HwndComboBox, #CBEM_SETIMAGELIST, 0, hImageList)
  Else 
     HwndComboBox = 0
  EndIf

  ProcedureReturn HwndComboBox
  
EndProcedure

;;/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*
;;/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*

Procedure GetAllDrives()

; create linked list to store drive name  
 Global NewList Drive.DriveInfos()

   ; Get all drives letter
   AllDrivesNames.s = Space(255)  ; AllDrivesNames receive string from GetLogicalDriveStrings API
   *AllDrivesNames.l = @AllDrivesNames 
   DrivesExist.l = GetLogicalDriveStrings_(255,*AllDrivesNames)
   NbOfDrives.b = 0
   If DrivesExist
      NbOfDrives = DrivesExist/4
      lpFileSystemNameBuffer.s = Space(255)

      For i.b = 1 To NbOfDrives
         AddElement(Drive())
         ;;-------- Drive letter
         ;; Drive()\Name have 3 chars : first the drive letter
         ;; second ":"
         ;; third  "\"                    

         Drive()\DriveLetter = UCase(PeekS(*AllDrivesNames,3))
         *AllDrivesNames + 4
         ;;-------- Volume name
         Drive()\NameOfVolume = ""

         GetVolumeInformation_(Drive()\DriveLetter,Drive()\NameOfVolume,255,0,0,0,lpFileSystemNameBuffer,255)
         If Len(Drive()\NameOfVolume)
             Drive()\NameOfVolume = UCase(Left(Drive()\NameOfVolume ,1)) + LCase(Mid(Drive()\NameOfVolume ,2,Len(Drive()\NameOfVolume)-1))
         Else
             Drive()\NameOfVolume = ""
         EndIf

; determine type of drive 
         Drive()\DriveType = GetDriveType_(@Drive()\DriveLetter)
         Select Drive()\DriveType

            Case 0  ; drive not determined
                 Drive()\DriveTypeString = "Indetermined Type"

            Case 1  ; 1	The root directory does not exist
                 Drive()\DriveTypeString = "Root directory does not exist"
      
            Case #DRIVE_REMOVABLE  ;The drive can be removed from the drive.
                 Drive()\DriveTypeString = "Floppy disk"

            Case #DRIVE_FIXED      ; The disk cannot be removed from the drive.
                 Drive()\DriveTypeString = "Not removed disk"

            Case #DRIVE_REMOTE     ; The drive is a remote (network) drive.
                 Drive()\DriveTypeString = "Remote (network) drive"

            Case #DRIVE_CDROM      ; The drive is a CD-ROM drive.
                 Drive()\DriveTypeString = "CD-ROM"

            Case #DRIVE_RAMDISK    ; The drive is a RAM disk.
                 Drive()\DriveTypeString = "RAM disk"
                 
            Default 
                 Drive()\DriveTypeString = "Indetermined Type"

         EndSelect
      Next i 
    EndIf

EndProcedure 

;;/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*
;;/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*
;;                                 Main Prog
;;/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*
;;/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*

MainWindowID = OpenWindow(0,0,0,400,150," List of your computer Drives",#PB_Window_ScreenCentered |#PB_Window_SystemMenu)
If MainWindowID And CreateGadgetList(WindowID(0)) And CreateComboBoxGadget()
         GetAllDrives()
         ResetList(Drive())
         Combo.COMBOBOXEXITEM
         Combo\mask = #CBEIF_TEXT | #CBEIF_IMAGE| #CBEIF_SELECTEDIMAGE
         InfosFile.SHFILEINFO

         ResetList(Drive())
         driveToDisplay.s= Space(255)
         While NextElement(Drive())

;  fill combobox with items, get image index of current drive, insert current item to the list
;  and  display second item

;  create strings to fill combobox with
            If Len(Drive()\NameOfVolume)
               driveToDisplay= Drive()\NameOfVolume  + " (" + Drive()\DriveTypeString + " "+ Left(Drive()\DriveLetter,2) + ")"
            Else
               driveToDisplay = Drive()\DriveTypeString + " (" + Left(Drive()\DriveLetter,2) + ")"
            EndIf

;  get image index of current drive
            SHGetFileInfo_(Drive()\DriveLetter, 0, @InfosFile, SizeOf(SHFILEINFO), #SHGFI_SYSICONINDEX |#SHGFI_SMALLICON )
            Combo\iItem          = -1                  ; -1 --> insert current item at the end of list
            Combo\pszText        = @driveToDisplay
            Combo\cchTextMax     = Len(driveToDisplay)
            Combo\iImage         = InfosFile\iIcon     ; image index of current image
            Combo\iSelectedImage = InfosFile\iIcon     ; image index of selected (displayed) item
            Combo\iIndent        = 1

;  insert current item to the list
            SendMessage_(HwndComboBox , #CBEM_INSERTITEM, 0, @Combo)
         Wend 

;  display second item in combobox
         secondItemIndex = 1  ; index of first item is 0
         SendMessage_(HwndComboBox , #CB_SETCURSEL, secondItemIndex , 0)
Else
   MessageRequester("Error", "Can't create ComboBox",16)
   End
EndIf

; events loop
  Repeat
     Select WaitWindowEvent()

        Case #PB_Event_CloseWindow
          Quit = 1

     EndSelect

  Until Quit

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
