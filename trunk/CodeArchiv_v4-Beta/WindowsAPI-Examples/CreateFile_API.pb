; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2129&highlight=
; Author: traumatic
; Date: 19. February 2005
; OS: Windows
; Demo: No


; Datei erstellen (Lese- und Schreibrecht) 
hFile = CreateFile_("testing.txt", #GENERIC_READ | #GENERIC_WRITE, #FILE_SHARE_READ, #Null, #OPEN_ALWAYS, #FILE_ATTRIBUTE_NORMAL, #Null) 

If hFile <> #INVALID_HANDLE_VALUE 

   ; String in die Datei schreiben 
   myString.s = "Testing, testing, 1,2, 1,2" 
    
   WriteFile_(hFile, myString, Len(myString), @actBytes.l, #Null) 

   ; wieder an den Anfang zurückgehen... 
   SetFilePointer_(hFile, 0, 0, #FILE_BEGIN) 

   ; ... den geschriebenen String wieder auslesen... 
   myString2.s = Space(Len(myString)) 
    
   ReadFile_(hFile, @myString2, Len(myString), @actBytes, #Null) 

   ; ... und anzeigen 
   Debug myString2 

   ; Datei schließen. 
   CloseHandle_(hFile) 
EndIf 
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -