; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8918&highlight=
; Author: localmotion34 (updated for PB 4.00 by Andre)
; Date: 29. December 2003
; OS: Windows
; Demo: Yes


; I have a rather complex program to store data and images for my PHD dissertation,
; And wanted to have a single file for the data. So I worked up a way to save images
; and text into a modified JPEG file.

; Basically, with a jpeg you can write text to the file provided it in in the INI format
; where brackets surround the headings. I think the OS just overlooks these because you
; can open the file in either any image editor or open it up in notepad and read the INI
; part too. It works amazingly for me. I have about 60 270x180 pictires that I write to
; a big JPEG in a grid layout, and then write all my text to the same file in an INI
; format. Then when I open the file, I grab the loaded image (270x180) and set an image
; gadget state with it. Sorry if this isnt the best format, but i really wanted to share!!!!!

Enumeration
  #Image_9
  #Image_10
  #Image_19
  #Image_20
  #Image_29
  #Image_30
  #Image_39
  #Image_40
  #Image_49
  #Image_50
  #Image_59
  #Image_60
  #Image_69
  #Image_70
  #Image_79
  #Image_80
  #Image_89
  #Image_90
  #Image_98
EndEnumeration

Procedure writeINI(dummy1$,dummy2$,dummy3$,dummy4$)
  ; dummy procedure, just to make the example code work....
EndProcedure

Procedure savehybridfile()
  Filename$=SaveFileRequester("Please choose file to save","","Database|*.dr2",0)
  If Not filename$
    ProcedureReturn
  EndIf
  
  files$=GetExtensionPart(Filename$)
  If files$="dr2"
    mainfile$=Filename$
  Else
    mainfile$=Filename$ + ".dr2"
  EndIf
  If mainfile$=""
    MessageRequester("Error","File Name Is Needed Or User Canceled", #PB_MessageRequester_Ok)
  EndIf
  width=10*270
  height=6*300
  CreateImage(0,width,height)
  StartDrawing(ImageOutput(0))
  ;Here we get all the images of the program in different image gadgets
  For d=#Image_9 To #Image_98
    ;These are my image gadget constants,whose image# is the same as
    ;the gadget constant
    If d=#Image_9
      xloc=0
      yloc=0
      hght=180
    ElseIf d=#Image_10
      xloc=271
      yloc=0
    ElseIf d=#Image_19
      xloc=0
      yloc=181
    ElseIf d=#Image_20
      xloc=271
      yloc=181
    ElseIf d=#Image_29
      xloc=0
      yloc=391
    ElseIf d=#Image_30
      xloc=271
      yloc=391
    ElseIf d=#Image_39
      xloc=0
      yloc=601
    ElseIf d=#Image_40
      xloc=271
      yloc=601
    ElseIf d=#Image_49
      xloc=0
      yloc=811
    ElseIf d=#Image_50
      xloc=271
      hght=180
    ElseIf d=#Image_59
      xloc=0
      yloc=1021
    ElseIf d=#Image_60
      xloc=271
      yloc=1021
    ElseIf d=#Image_69
      xloc=0
      yloc=1231
    ElseIf d=#Image_70
      xloc=271
      yloc=1231
    ElseIf d=#Image_79
      xloc=0
      yloc=1411
    ElseIf d=#Image_80
      xloc=271
      yloc=1411
    ElseIf d=#Image_89
      xloc=0
      yloc=1591
    ElseIf d=#Image_90
      xloc=271
      yloc=1591
    EndIf
    DrawImage(ImageID(d),xloc,yloc,270,180)
    xloc=xloc+270
  Next
  StopDrawing()
  SaveImage(0, mainfile$,#PB_ImagePlugin_JPEG,10)
  ;Now we write gadget states and text to the same JPEG file
  Repeat
    gad=gad+1
    If GetGadgetState(gad)=1  ;GADGET STATES,is it checked or no?
      writeINI(tabname$,Str(gad),"yes","[b]"+mainfile$+"[/b]")
    ElseIf GetGadgetState(gad)=0
      writeINI(tabname$,Str(gad),"no",mainfile$)
    EndIf
  Until gad=43
  Repeat
    gad=gad+1
    Text$=GetGadgetText(gad) ;GADGET TEXT
    writeINI(tabname$,Str(gad),Text$,"[b]"+mainfile$+"[/b]")
  Until gad=55
EndProcedure

savehybridfile()
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
