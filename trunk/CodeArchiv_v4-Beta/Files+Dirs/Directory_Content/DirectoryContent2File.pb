; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8998&highlight=
; Author: Kale (updated for PB4.00 by blbltheworm)
; Date: 03. January 2004
; OS: Windows
; Demo: Yes

;Declare some variables 
IncludeDirectoriesInListings.l = #False 
DirectoryName.s 
FileType.l 

;Create a new LinkedList that will hold the results of our directory 'scan' 
Global NewList Listings.s() 

;Choose a directory 
DirectoryName = PathRequester("Please choose a folder...", "") 

;Examine that directory 
If ExamineDirectory(1, DirectoryName, "") ; If directory can be read... 
    Repeat 
        FileType = NextDirectoryEntry(1) 
        If FileType = 1 ; 1 = File 
            ;Add the file name to the listings 
            AddElement(Listings()) 
            Listings() = DirectoryEntryName(1) 
        EndIf 
        If IncludeDirectoriesInListings = #True ; only include folder names within the choosen directory if 'IncludeDirectoriesInListings = #TRUE' 
            If FileType = 2 ; 2 = Folder 
                ;Add the folder name to the listings 
                AddElement(Listings()) 
                Listings() = DirectoryEntryName(1) 
            EndIf 
        EndIf 
    Until FileType = 0 
EndIf 

;write the listings to a file 
If OpenFile(1, "Listings.txt") ; If file can be created... 
    ForEach Listings() 
        WriteStringN(1,Listings()) 
    Next 
    CloseFile(1) 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
