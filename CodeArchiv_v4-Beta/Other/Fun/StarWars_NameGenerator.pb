; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7016&highlight=
; Author: Kale (updated for PB 4.00 by Andre)
; Date: 25. July 2003
; OS: Windows
; Demo: Yes


;=========================================================================== 
; CONSTANTS 
;=========================================================================== 

#ROOT_WINDOW = 1 
#MENU_ITEM_QUIT = 1 
#MENU_ITEM_ABOUT = 2 
#GENERATE_BUTTON = 1 
#CLOSE_BUTTON = 2 
#FIRST_NAME_FIELD = 3 
#LAST_NAME_FIELD = 4 
#MOTHERS_MAIDEN_NAME_FIELD = 5 
#PLACE_OF_BIRTH_FIELD = 6 
#PETS_NAME_FIELD = 7 
#DRUG_NAME_FIELD = 8 
#CAR_NAME_FIELD = 9 
#STARWARS_NAME_FIELD = 10 
#W1Text1 = 11 
#W1Text2 = 12 
#W1Text3 = 13 
#W1Text4 = 14 
#W1Text5 = 15 
#W1Text6 = 16 
#W1Text7 = 17 
#W1Text8 = 18 
#W1Text9 = 19 
#PROGRESS_BAR = 20 
#STATUS_BAR = 1 
#PREFS_FILE=1 

;=========================================================================== 
; FUNCTIONS 
;=========================================================================== 

;handle quiting nicely, saving '#PREFS_FILE' etc... 
Global quit.b 
quit = 0 
Procedure QuitNicely() 
    DeleteFile("names.ini") 
    If OpenFile(#PREFS_FILE, "names.ini") 
        WriteStringN(#PREFS_FILE,GetGadgetText(#FIRST_NAME_FIELD)) 
        WriteStringN(#PREFS_FILE,GetGadgetText(#LAST_NAME_FIELD)) 
        WriteStringN(#PREFS_FILE,GetGadgetText(#MOTHERS_MAIDEN_NAME_FIELD)) 
        WriteStringN(#PREFS_FILE,GetGadgetText(#PLACE_OF_BIRTH_FIELD)) 
        WriteStringN(#PREFS_FILE,GetGadgetText(#PETS_NAME_FIELD)) 
        WriteStringN(#PREFS_FILE,GetGadgetText(#DRUG_NAME_FIELD)) 
        WriteString(#PREFS_FILE,GetGadgetText(#CAR_NAME_FIELD)) 
        CloseFile(#PREFS_FILE) 
    EndIf 
    quit = 1 
EndProcedure 

;draw progress for show only  :) 
Procedure DrawProgressBar(delay.b) 
    For x=0 To 30 
        SetGadgetState(#PROGRESS_BAR, x) 
    Delay(delay) 
    Next 
    SetGadgetState(#PROGRESS_BAR, 0) 
EndProcedure 

;generate name using the seeds 
Procedure generateName() 
    DrawProgressBar(5) 
    Dim names.s(7) 
    For x.b=#FIRST_NAME_FIELD To #CAR_NAME_FIELD 
        names(x-3)=GetGadgetText(x) 
    Next 
    rawStarWarsName.s = "" 
    For x.b=0 To 3 
        rawStarWarsName= rawStarWarsName+LCase(Left(names(Random(6)),3)) 
    Next 
    firstName.s = Left(rawStarWarsName,6) 
    firstNameCap.s = UCase(Left(firstName,1)) 
    secondName.s = Right(rawStarWarsName,6) 
    secondNameCap.s = UCase(Left(secondName,1)) 
    formattedName.s = firstNameCap+Right(firstName,5)+" "+secondNameCap+Right(secondName,5) 
    SetGadgetText(#STARWARS_NAME_FIELD, formattedName) 
EndProcedure 

;=========================================================================== 
; GEOMETRY 
;=========================================================================== 

#Window1Flags = #PB_Window_MinimizeGadget | #PB_Window_SystemMenu | #PB_Window_ScreenCentered 

If OpenWindow( #ROOT_WINDOW, 0,0,430,350, "StarWars Name Generator v1.0", #Window1Flags) 

    If CreateMenu(0, WindowID(#ROOT_WINDOW)) 
        MenuTitle("File") 
            MenuItem( 1, "Quit") 
        MenuTitle("Help") 
            MenuItem( 2, "About...") 
    EndIf 

    If CreateGadgetList(WindowID(1)) 
        Frame3DGadget(1, 10, 10, 410, 220, "Seed Information", 0) 
        ButtonGadget(#GENERATE_BUTTON,330,276 ,89,25,"Generate >>>") 
        ButtonGadget(#CLOSE_BUTTON,230,276 ,89,25,"Close") 
        StringGadget(#FIRST_NAME_FIELD,20,50 ,190,21,"") 
        StringGadget(#LAST_NAME_FIELD,220,50 ,190,21,"") 
        StringGadget(#MOTHERS_MAIDEN_NAME_FIELD,20,100 ,190,21,"") 
        StringGadget(#PLACE_OF_BIRTH_FIELD,220,100 ,190,21,"") 
        StringGadget(#PETS_NAME_FIELD,20,150 ,190,21,"") 
        StringGadget(#DRUG_NAME_FIELD,221,150 ,190,21,"") 
        StringGadget(#CAR_NAME_FIELD,20,200 ,190,20,"") 
        StringGadget(#STARWARS_NAME_FIELD,10,280 ,210,21,"") 
        TextGadget(#W1Text1,20,30 ,161,17,"First Name") 
        TextGadget(#W1Text2,220,30 ,161,17,"Last Name") 
        TextGadget(#W1Text3,20,80 ,161,17,"Mother's Maiden Name") 
        TextGadget(#W1Text4,220,80 ,161,17,"Birth Place (Town/City)") 
        TextGadget(#W1Text5,20,130 ,161,17,"Pet's Name") 
        TextGadget(#W1Text6,220,130 ,161,17,"Name of a Drug") 
        TextGadget(#W1Text7,20,180 ,161,17,"Car Name") 
        TextGadget(#W1Text8,10,260 ,161,17,"StarWars Name") 
        TextGadget(#W1Text9,255,200 ,121,17,"All Fields must be filled in.") 
        ProgressBarGadget(#PROGRESS_BAR,10,241 ,410,10,0,30,#PB_ProgressBar_Smooth) 
    EndIf 
    GadgetToolTip(1,"Click here to generate a new name.") 
    CreateStatusBar(#STATUS_BAR, WindowID(#ROOT_WINDOW)) 

;=========================================================================== 
; READ PREFERENCES 
;=========================================================================== 

If ReadFile(#PREFS_FILE, "names.ini") 
    For x.b=#FIRST_NAME_FIELD To #CAR_NAME_FIELD 
        If Eof(#PREFS_FILE) = 0 
            SetGadgetText(x, ReadString(#PREFS_FILE)) 
        EndIf 
    Next 
    CloseFile(#PREFS_FILE) 
EndIf 

;=========================================================================== 
; MAIN 
;=========================================================================== 

Repeat 

EventID.l = WaitWindowEvent() 

Select EventID 
    Case #PB_Event_Menu 
        Select EventMenu() 
            Case #MENU_ITEM_QUIT 
                quit = 1 
            Case #MENU_ITEM_ABOUT 
                message.s="StarWars Name Generator v1.0"+Chr(10)+Chr(10)+"Use this program to reveal your true StarWars name." 
                MessageRequester("About...", message, #MB_ICONINFORMATION) 
        EndSelect 
    Case #PB_Event_Gadget 
        Select EventGadget() 
            Case #GENERATE_BUTTON 
                generateName() 
            Case #CLOSE_BUTTON 
                QuitNicely() 
        EndSelect 
    Case #PB_Event_CloseWindow 
        QuitNicely() 
    Case #WM_CLOSE 
        QuitNicely() 
EndSelect 

Until quit = 1 

EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
