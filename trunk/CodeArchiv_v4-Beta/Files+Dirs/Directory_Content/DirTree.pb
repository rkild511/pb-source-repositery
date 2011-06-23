; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8359&highlight=
; Author: blueznl (updated for PB4.00 by blbltheworm)
; Date: 15. November 2003
; OS: Windows
; Demo: Yes


; List all the contents of "C:\", sorted !
  ; 
  path.s = "c:\" 
  ; 
  If list_limit.l = 0 
    list_limit = 20000                              ; arbitrary limit 
  EndIf 
  ; 
  If Right(path.s,1)<>"\" 
    path = path + "\" 
  EndIf 
  ; 
  Global Dim x_dir_list.s(list_limit) 
  folder_n = 1 
  x_dir_list(list_limit-folder_n) = path            ; store paths back to front 
  file_n = 0 
  ; 
  While folder_n > 0 
    folder.s = x_dir_list(list_limit-folder_n) 
    x_dir_list(list_limit-folder_n)=""              ; << comment out when done debugging 
    folder_n = folder_n-1 
    If ExamineDirectory(nr,folder,"*.*")  
      file_added = 0      
      folder_added = 0 
      ; 
      ; add files (bottom up) and folders (top down) 
      ; 
      Repeat 
        type.l = NextDirectoryEntry(nr) 
        If Left(DirectoryEntryName(nr),1)="." 
        ElseIf type = 1 
          file_added = file_added+1 
          x_dir_list(file_n+file_added) = folder+DirectoryEntryName(nr) 
        ElseIf type = 2 
          folder_added = folder_added+1 
          x_dir_list(list_limit-folder_n-folder_added) = folder+DirectoryEntryName(nr)+"\" 
        Else 
        EndIf 
        If (folder_n+file_n+folder_added+file_added) >= list_limit-4    ; too many entries for the list 
          limit_reached = #True 
        EndIf 
      Until type = 0 Or limit_reached = #True 
      ; 
      ; if there are any new entries, sort them 
      ; 
      If file_added > 0 
        SortArray(x_dir_list(),2,file_n+1,file_n+file_added) 
        file_n = file_n+file_added 
      EndIf 
      If folder_added > 0 
        SortArray(x_dir_list(),2,list_limit-folder_n-folder_added,list_limit-folder_n-1) 
        folder_n = folder_n+folder_added 
      EndIf 
      ; 
    EndIf 
  Wend 
  ; 
  For n = 1 To file_n 
    Debug " "+x_dir_list(n) 
  Next n 
  Debug limit_reached 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
