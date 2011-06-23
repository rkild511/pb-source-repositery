; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7108
; Author: Hi-Toro (updated for PB 4.00 by Andre)
; Date: 22. January 2004
; OS: Windows
; Demo: Yes


; Monitor a directory for changes -- files created, deleted, etc.
; Überwachen eines Verzeichnisses auf Veränderungen, neue Dateien, gelöschte Dateien, etc.

; Although you can determine which files have been added using some NT-specific APIs,
; there's no way to determine what's new on 9x without comparing the before-and-after
; state as far as I'm aware (so that's what this program does)...
;
; Finding out which program owns a file is pretty advanced, low-level stuff I've never
; figured out (have a look at www.sysinternals.com for their 'handle' or 'Process Explorer'
; programs, which can do this, though they don't explain how)...


;- Window Constants
;
#Window_0 = 0

;- Gadget Constants
;
#Gadget_1 = 0
#Gadget_0 = 1
#Gadget_2 = 2
#Gadget_3 = 3
#Gadget_4 = 4
#Gadget_5 = 5
#Gadget_6 = 6


Procedure Open_Window_0()
  If OpenWindow(#Window_0, 0, 0, 440, 410, "New File Monitor - Hi-Toro 2003 (Public Domain: spread freely!)", #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered)
    If CreateGadgetList(WindowID(#Window_0))
      ListIconGadget(#Gadget_1, 20, 30, 400, 130, "Choose drives to monitor", 400 - (GetSystemMetrics_ (#SM_CXEDGE) * 2), #PB_ListIcon_CheckBoxes)
      Frame3DGadget(#Gadget_0, 10, 10, 420, 160, "Drives to monitor")
      Frame3DGadget(#Gadget_2, 10, 180, 420, 160, "Files added to selected drives during monitoring")
      ListViewGadget(#Gadget_3, 20, 200, 400, 130)
      ButtonGadget(#Gadget_4, 10, 350, 160, 30, "Monitor selected drives")
      ButtonGadget(#Gadget_5, 180, 350, 160, 30, "Save list of files added...")
      ButtonGadget(#Gadget_6, 350, 350, 80, 30, "Reset")
      CreateStatusBar (0, WindowID (#Window_0))
    EndIf
  EndIf
EndProcedure

Open_Window_0()

DisableGadget (#Gadget_5, 1)

Procedure GetDriveList ()

  Structure Drives
    name.s
  EndStructure

  Global NewList disk.Drives ()

  ResetList (disk ())

  ; Stupid, stupid Windows...

  *mem = AllocateMemory (255)
  result = GetLogicalDriveStrings_ (255, *mem)
  If result > 255
    ReAllocateMemory (*mem, result)
    GetLogicalDriveStrings_ (result, *mem)
  EndIf

  If result

    For a = 0 To result - 1
      byte = PeekB (*mem + a)
      If byte
        drive$ = drive$ + Chr (byte)
      Else
        AddElement (disk ())
        disk ()\name = drive$
        drive$ = ""
      EndIf
    Next

    FreeMemory (0)
    ProcedureReturn #True

  Else

    FreeMemory (0)
    ProcedureReturn #False

  EndIf

EndProcedure

If GetDriveList ()

  ResetList (disk ())
  While NextElement (disk ())
    AddGadgetItem (#Gadget_1, -1, disk ()\name)
  Wend

EndIf

Structure FileList
  entry.s
  drive.s
EndStructure

Global NewList files.FileList ()

Procedure CountFiles (dir$, recursecount, drive$)

  If Right (dir$, 1) <> "\"
    dir$ = dir$ + "\"
  EndIf

  If ExamineDirectory (recursecount, dir$, "*.*")

    Repeat

      entry = NextDirectoryEntry (recursecount)
      file$ = dir$ + DirectoryEntryName (recursecount)

      ; File...

      If entry = 1
        AddElement (files ())
        files ()\entry = file$
        files ()\drive = drive$
      Else

        ; Folder...

        If entry = 2
          folder$ = DirectoryEntryName (recursecount)
          If folder$ <> "." And folder$ <> ".."
            If Right (folder$, 1) <> "\"
              folder$ = folder$ + "\"
            EndIf
            folder$ = dir$ + folder$
            AddElement (files ())
            files ()\entry = folder$
            files ()\drive = drive$
            CountFiles (folder$, recursecount + 1, drive$)

          EndIf
        EndIf
      EndIf

    Until entry = 0

  EndIf

EndProcedure

Global NewList files2.FileList ()

Global NewList diffs.FileList ()

Procedure CountFiles2 (dir$, recursecount, drive$)

  If Right (dir$, 1) <> "\"
    dir$ = dir$ + "\"
  EndIf

  If ExamineDirectory (recursecount, dir$, "*.*")

    Repeat

      entry = NextDirectoryEntry (recursecount)
      file$ = dir$ + DirectoryEntryName (recursecount)

      ; File...

      If entry = 1
        AddElement (files2 ())
        files2 ()\entry = file$
        files2 ()\drive = drive$
      Else

        ; Folder...

        If entry = 2
          folder$ = DirectoryEntryName (recursecount)
          If folder$ <> "." And folder$ <> ".."
            If Right (folder$, 1) <> "\"
              folder$ = folder$ + "\"
            EndIf
            folder$ = dir$ + folder$
            AddElement (files2 ())
            files2 ()\entry = folder$
            files2 ()\drive = drive$
            CountFiles2 (folder$, recursecount + 1, drive$)

          EndIf
        EndIf
      EndIf

    Until entry = 0

  EndIf

EndProcedure

Structure SelectedDisk
  name.s
EndStructure

NewList selected.SelectedDisk ()

#WAIT_FAILED = $FFFFFFFF
#WAIT_OBJECT_0  = $0
#WAIT_ABANDONED = $80
#WAIT_TIMEOUT = $102

Repeat

  e = WaitWindowEvent ()

  Select e

    Case #PB_Event_CloseWindow
      End

    Case #PB_Event_Gadget

      Select EventGadget ()

        Case #Gadget_4

          ClearList (selected ())

          seld = 0

          For check = 0 To CountGadgetItems (#Gadget_1) - 1
            If GetGadgetItemState (#Gadget_1, check) & #PB_ListIcon_Checked
              AddElement (selected ())
              selected ()\name = GetGadgetItemText (#Gadget_1, check, 0)
              seld = seld + 1
            EndIf
          Next

          If seld

            ClearGadgetItemList (#Gadget_3)

            DisableGadget (#Gadget_4, #True)
            StatusBarText (0, 0, "Compiling file list -- please wait...")

            Dim Handles (seld)

            ResetList (selected ())
            hcount = 0
            While NextElement (selected ())
              Handles (hcount) = FindFirstChangeNotification_ (selected ()\name, #True, #FILE_NOTIFY_CHANGE_FILE_NAME | #FILE_NOTIFY_CHANGE_DIR_NAME)

              ClearList (files ())
              CountFiles (selected ()\name, 0, selected ()\name)

              hcount = hcount + 1
            Wend

            DisableGadget (#Gadget_4, #False)
            StatusBarText (0, 0, "")

            ;ResetList (files ())
            ;While NextElement (files ())
            ;    Debug files ()\drive + " -- " + files ()\entry
            ;Wend

            ResetList (selected ())
            While NextElement (selected ())
              selected ()\name
            Wend

            If hcount

              SetGadgetText (#Gadget_4, "Stop monitoring selected drives")

              DisableGadget (#Gadget_1, #True)
              DisableGadget (#Gadget_3, #True)
              DisableGadget (#Gadget_6, #True)

              changes = 0

              Repeat

                e = WindowEvent ()

                result = WaitForMultipleObjects_ (hcount, @Handles (), #False, 10)

                ; Valid result! See WaitForMultipleObjects docs to explain bounds check!

                If result => #WAIT_OBJECT_0 And result <= #WAIT_OBJECT_0 + hcount - 1

                  ;Debug "Change in monitored folders/sub-folders!"

                  changes = changes + 1

                  ; Reset the handle that caused the notification (again, see docs)...

                  FindNextChangeNotification_ (Handles (result - #WAIT_OBJECT_0))

                Else

                  ;                                    ; Result failed!
                  ;
                  If result = #WAIT_FAILED

                    MessageRequester ("New file monitor", "One or more selected drives unavailable!", #MB_ICONWARNING)

                    For check = 0 To CountGadgetItems (#Gadget_1) - 1
                      SetGadgetItemState (#Gadget_1, check, 0)
                    Next

                    ClearGadgetItemList (#Gadget_1)
                    ClearGadgetItemList (#Gadget_3)

                    ClearList (disk ())

                    If GetDriveList ()
                      ResetList (disk ())
                      While NextElement (disk ())
                        AddGadgetItem (#Gadget_1, -1, disk ()\name)
                      Wend
                    EndIf

                  EndIf

                EndIf

              Until e = #PB_Event_Gadget Or result = #WAIT_FAILED

              For a = 0 To seld - 1
                FindCloseChangeNotification_ (Handles (a))
              Next

              DisableGadget (#Gadget_1, #False)
              DisableGadget (#Gadget_3, #False)
              DisableGadget (#Gadget_6, #False)

              SetGadgetText (#Gadget_4, "Monitor selected drives")

              If changes

                ResetList (selected ())
                While NextElement (selected ())
                  ClearList (files2 ())
                  CountFiles2 (selected ()\name, 0, selected ()\name)
                Wend

                ClearList (diffs ())
                ResetList (files ())

                While NextElement (files ())
                  ResetList (files2 ())
                  While NextElement (files2 ())
                    If files ()\entry = files2 ()\entry
                      DeleteElement (files2 ())
                      LastElement (files2 ())
                    EndIf
                  Wend
                Wend

                ResetList (files2 ())
                While NextElement (files2 ())
                  If FileSize (files2 ()\entry) <> -1
                    AddGadgetItem (#Gadget_3, -1, files2 ()\entry)
                    ;                                        Debug files2 ()\drive + " -- " + files2 ()\entry
                  EndIf
                Wend

              EndIf

            EndIf

          EndIf

        Case #Gadget_6

          For check = 0 To CountGadgetItems (#Gadget_1) - 1
            SetGadgetItemState (#Gadget_1, check, 0)
          Next

          ClearGadgetItemList (#Gadget_1)
          ClearGadgetItemList (#Gadget_3)

          ClearList (disk ())

          If GetDriveList ()
            ResetList (disk ())
            While NextElement (disk ())
              AddGadgetItem (#Gadget_1, -1, disk ()\name)
            Wend
          EndIf

      EndSelect

  EndSelect

ForEver

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger