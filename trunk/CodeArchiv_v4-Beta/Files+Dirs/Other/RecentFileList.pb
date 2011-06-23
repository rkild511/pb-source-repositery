; English forum:
; Author: Rings (updated for PB3.92+ by Lars, updated for PB4.00 by blbltheworm)
; Date: 02. February 2003
; OS: Windows
; Demo: Yes

; Shows last loaded files in menu
; Zeigt die zuletzt geladenen Dateien im Menü


;Recent-List
;
;by Siegfried Rings (CodeGuru)
;
Global Recentfilename.s

#winMain=0

Recentfilename="MyRecentFiles.RFN" ;This holds the filename for the recentlist
Global NewList Files.s();Linked List to hold RecentFiles
#FP=99;Filepointer
#MenuRecentFiles=100;Start where Entrys are beginning in Menu

Procedure Recent(NewFilename.s)
If FileSize(Recentfilename)>0 
 If OpenFile(#FP,Recentfilename)<>0
   ClearList(Files())
   If NewFilename<>""
    AddElement(Files())
    Files()=NewFilename;Set as first element
   EndIf
   While Eof(#FP)=0
    sDummy.s=ReadString(#FP)
    If sDummy<>NewFilename ;is already here ?
     If CountList(Files())<10 ; we allow only 10 Files in the Recentlist
      If sDummy<>"" ;No NULL-STRING
       AddElement(Files())
       Files()=sDummy
      EndIf
     EndIf
    EndIf
   Wend
  CloseFile(#FP)
  ResetList(Files())
  If OpenFile(#FP,Recentfilename)<>0
   While NextElement(Files())       ; Process all the elements...
     WriteStringN(#FP,Files())
   Wend
   CloseFile(#FP)
  EndIf
 EndIf
Else
 ;New one
 If NewFilename<>""
  If CreateFile(#FP,Recentfilename)>0
   WriteStringN(#FP,NewFilename)
   CloseFile(#FP)
  EndIf
  AddElement(Files())
  Files()=NewFilename
 EndIf
EndIf 
EndProcedure

Procedure Makemenu()
 If CreateMenu(0, WindowID(#winMain))
   MenuTitle("File")
    MenuItem( 1, "&Load...")
    MenuItem( 2, "Save")
    MenuItem( 3, "Save As...")

    MenuBar()

    ResetList(Files())
    While NextElement(Files())       ; Process all the elements...
     MenuItem( #MenuRecentFiles+ListIndex(Files()) , Files())
    Wend

    MenuBar()
    MenuItem( 7, "&Quit")

    MenuTitle("Edition")
      MenuItem( 8, "Cut")
      MenuItem( 9, "Copy")
      MenuItem(10, "Paste")
      
    MenuTitle("?")
     MenuItem(11, "About")

  EndIf

EndProcedure

If OpenWindow(#winMain, 100, 150, 195, 260, "PureBasic - Menu", #PB_Window_SystemMenu)

  Recent("");Init the RecentFiles-list
  Makemenu()  ;And generate a menu for it
  Repeat

    Select WaitWindowEvent()

      Case #PB_Event_Menu
        MenuID=EventMenu()  
        If MenuID>#MenuRecentFiles And MenuID<#MenuRecentFiles+11
         SelectElement(Files(), MenuID-#MenuRecentFiles-1) 
         MessageRequester("About",Files(),0)
        Else
         Select   MenuID; To see which menu has been selected
          Case 1
           NewFilename.s=OpenFileRequester("Choose file", "", " All Files (*.*=)|*.*", 1) 
           If NewFilename.s<>""
            Recent(NewFilename.s) ;Add To our list
            Makemenu()  ;Update the menu
           EndIf 
          Case 11 ; About
            MessageRequester("About", "Cool Menu example", 0)
          Case 7
           Quit=1              
          Default
            MessageRequester("Info", "MenuItem: "+Str(EventMenu()), 0)
        EndSelect
       EndIf
      Case #WM_CLOSE ; #PB_EventCloseWindow
        Quit = 1
    EndSelect
  Until Quit = 1
EndIf
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger