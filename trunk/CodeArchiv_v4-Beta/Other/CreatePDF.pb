; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7863&highlight=
; Author: clipper
; Date: 13. October 2003
; OS: Windows
; Demo: No

; ------------------------------------------------------------
;
;   Example for creating PDF-Files with iSEDQuickPDF
;   http://www.sedtech.com/isedquickpdf/
;   DLL edition
;   Author Thomas Ott
; ------------------------------------------------------------

; Remember you have to insert your Licence key in "iSEDUnlockKey" (Demo-Key available)

#PDFLIB=1
Structure VBdouble
  Hi.f
  Lo.f
EndStructure
Procedure MakeDouble( LONG.f, ADDRESS.l )
  !FLD  dword [ Esp ]
  !MOV   dword Eax, [ Esp + 4 ]
  !FSTP  qword [ Eax ]
EndProcedure

Procedure PDFInit()
  If OpenLibrary(#PDFLIB,"iSEDQuickPDF.dll")
    CallFunction(#PDFLIB,"iSEDUnlockKey","Your key here")
    CallFunction(#PDFLIB,"iSEDSetMeasurementUnits",1)
    CallFunction(#PDFLIB,"iSEDSetOrigin",1)
    CallFunction(#PDFLIB,"iSEDSetInformation",5,"PureBasic PDF-Generation")
  Else
    MessageRequester("Error", "Error loading PDF-Library", #MB_ICONERROR | #MB_OK)
    End
  EndIf
EndProcedure

Procedure PDFDrawText(left.f,top.f,text.s)
  x.VBdouble
  y.VBdouble
  MakeDouble( left.f, @x )
  MakeDouble( top.f, @y )
  ProcedureReturn CallFunction(#PDFLIB,"iSEDDrawText",x\Hi,x\Lo,y\Hi,y\Lo ,text)
EndProcedure

Procedure PDFSetInformation(Info.l,text.s)
  CallFunction(#PDFLIB,"iSEDSetInformation",Info,text)
EndProcedure

Procedure PDFSetPageDimensions(width.f,height.f)
  x.VBdouble
  y.VBdouble
  MakeDouble( width.f, @x )
  MakeDouble( height.f, @y )
  ProcedureReturn CallFunction(#PDFLIB,"iSEDSetPageDimensions",x\Hi,x\Lo,y\Hi,y\Lo)
EndProcedure

Procedure PDFSave(filename.s)
  ProcedureReturn CallFunction(#PDFLIB,"iSEDSaveToFile",filename)
EndProcedure

Procedure PDFShutDown()
  CloseLibrary(#PDFLIB)
EndProcedure

PDFInit()
PDFSetPageDimensions(210,297)
PDFSetInformation(1,"From me")
PDFDrawText(100,100,"Hello world")
PDFSave("c:\helloworld.pdf")
PDFShutDown()

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
