; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7154&highlight=
; Author: Flype
; Date: 07. August 2003
; OS: Windows
; Demo: Yes

; change following path to your own path with images included....
dir.s = "C:\DEV\PureBasic\Examples\Sources - Advanced\Waponez II\Data\" 

CreateImage( 0, 6 * 50, 36 ) 
ImageOutput( 0) 

For i=1 To 6 
  LoadImage( i, dir+"Ennemy_3_" + Str( i )+ ".bmp" ) 
  StartDrawing( ImageOutput( 0 ) ) 
    DrawImage( ImageID( i ), (i-1) * 50, 0 ) 
  StopDrawing() 
Next 

;OpenWindow(0,200,200,300,200,0,"") 
;StartDrawing( WindowOutput() ) 
;  DrawImage( UseImage( 0 ), 0, 0 ) 
;StopDrawing() 
;Delay( 5000 ) 

file.s = SaveFileRequester( "Save Images...", "WaponezSprites.bmp", "Bitmap|*.bmp", 0 ) 
If file <> "" 
  SaveImage( 0, file, #PB_ImagePlugin_BMP ) 
  MessageRequester( "Report", "Sprites Saved !", 0 ) 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
