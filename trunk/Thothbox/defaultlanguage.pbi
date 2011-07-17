;DataSection
  
  ; Here the default language is specified. It is a list of Group, Name pairs,
  ; with some special keywords for the Group:
  ;
  ; "_GROUP_" will indicate a new group in the datasection, the second value is the group name
  ; "_END_" will indicate the end of the language list (as there is no fixed number)
  ;
  ; Note: The identifier strings are case insensitive to make live easier :)

  Language:
  
  ; ===================================================
  Data$ "_GROUP_", "Menu"
  ; ===================================================
  Data$ "About",	"About"
  Data$ "Preferences",	"Preferences"

  ; ===================================================
  Data$ "_GROUP_", "searchWindow"
  ; ===================================================
  Data$ "Version",	"Version"
  Data$ "search",	"Search"
  Data$ "name",	"Name"
  Data$ "category",	"Category"
  Data$ "Platform","Platform"
  ; ===================================================
  Data$ "_GROUP_", "viewWindow"
  ; ===================================================
  
  Data$ "Search",	"Search"
  Data$ "Name",	"Name"
  Data$ "NewDbRequestTitle", "Create a New ThyKey Database"
  Data$ "DeleteGroup", "Delete Group"
  Data$ "DeleteGroupAnswer", "Do you want to delete this Group ? All Entry will move to the first Group"
  Data$ "DeleteEntry", "Delete Entry"
  Data$ "DeleteEntryAnswer", "Do you want to delete this Entry ?"
  ; ===================================================
  Data$ "_GROUP_", "prefsWindow"
  ; ===================================================
  Data$ "File", "File"
  Data$ "New", "New"
  Data$ "Load", "&Load..."
  Data$ "SaveAs", "Save As..."
  Data$ "Close", "Close"
  Data$ "Property", "Database Property"
  Data$ "Quit", "Quit"
  
  Data$ "Edit", "Edit"
  Data$ "NewEntry", "New Entry"
  
  Data$ "Option", "Option"
  Data$ "StickyWindow", "StickyWindow"
  Data$ "Preferences", "Preferences"
  
  Data$ "?", "?"
  Data$ "About", "About"
  
  ; ===================================================
  Data$ "_END_", ""
  ; ===================================================
  
;EndDataSection
; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 23
; EnableXP