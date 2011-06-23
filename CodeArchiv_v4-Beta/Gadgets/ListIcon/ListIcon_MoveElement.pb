; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7174&highlight=
; Author: Flype (updated for PB4.00 by blbltheworm)
; Date: 09. August 2003
; OS: Windows
; Demo: Yes

; Move up or down the elements of a linked list and then display them in a listicongadget.
; Note: Simple PureBasic code example! Could be improved with the use of pointers as you
;       can see in this example:
;
;   Structure ListHeader
;     *NextElement.ListHeader
;     *PreviousElement.ListHeader
;   EndStructure
;
;   *MyElement = @list()-SizeOf(ListHeader)
;
;   ; And you can play with the pointers :)
;
; Works also for structured linked lists, like here:
;   Structure StringList
;     String.s
;     Long.l
;   EndStructure
;   NewList StringListExample.StringList
; 


;/-------------------------------

#NONE   = -1
#BOTTOM = -1
#GT_LIST = 1
#GT_UP   = 2
#GT_DOWN = 3

;/-------------------------------

Global NewList mylist.s()

For i=0 To 20
  AddElement( mylist() ) : mylist() = "test line n°"+Str(i)
Next

;/-------------------------------

Procedure LIST_Fill()
  ClearGadgetItemList( #GT_LIST )
  ResetList( mylist() )
  While NextElement( mylist() )
    AddGadgetItem( #GT_LIST, #BOTTOM, mylist(), 0 )
  Wend
EndProcedure

Procedure LIST_Up()
  position = GetGadgetState( #GT_LIST )
  If position <> #NONE
    SelectElement( mylist(), position )
    element.s = mylist()
    DeleteElement( mylist() )
    InsertElement( mylist() )
    mylist() = element
    LIST_Fill() : SetGadgetItemState( #GT_LIST, position-1, #True )
  EndIf
EndProcedure

Procedure LIST_Down()
  position = GetGadgetState( #GT_LIST )
  If position <> #NONE
    SelectElement( mylist(), position )
    element.s = mylist()
    DeleteElement( mylist() )
    SelectElement( mylist(), position+1 )
    InsertElement( mylist() )
    mylist() = element
    LIST_Fill() : SetGadgetItemState( #GT_LIST, position+1, #True )
  EndIf
EndProcedure

;/-------------------------------

OpenWindow( 0, 200, 200, 500, 400, "Nettie Prefs" , #PB_Window_SystemMenu)
CreateGadgetList( WindowID( 0) )
ListIconGadget( #GT_LIST, 60,5,WindowWidth( 0)-65,WindowHeight( 0)-10, "Item", 110, #PB_ListIcon_AlwaysShowSelection )
ButtonGadget( #GT_UP,   5,   5, 50, 24, "Up"   )
ButtonGadget( #GT_DOWN, 5,  30, 50, 24, "Down" )
LIST_Fill()

;/-------------------------------

Repeat
  Select WaitWindowEvent()
  Case #WM_CLOSE : quit=#True
  Case #PB_Event_Gadget
    Select EventGadget()
    Case #GT_UP   : LIST_Up()
    Case #GT_DOWN : LIST_Down()
    EndSelect
  EndSelect
Until quit=#True

;/-------------------------------

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
