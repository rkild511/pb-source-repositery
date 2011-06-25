;*******************************************************************************
;*
;* Name   : PIXEL REFRESH TIMING visual test.
;* Author : Psychophanta
;* Date   : 2009/06/28
;* Notes  : WIN32 Entry for the PurePunch Contest #2
;*          Visual test for your display (aka monitor) pixel refresh timing.
;*          Pixel refresh timing is higher as you see your display blinks
;*          on black.
;*          Only a display with an acceptable almost "null" time
;*          will show no black blinking to your eyes.
;*******************************************************************************
R=ColorRequester():H=800:V=600
InitSprite():InitKeyboard():OpenScreen(H,V,32,"fs"):Macro s(a,b,c,d,e,f)
ClearScreen(0):StartDrawing(ScreenOutput()):For t=e To d Step 2
Line(a,b,c,f,R):Next:StopDrawing():EndMacro:Macro f(a,b,c,d,f)
s(a,b,c,d,0,f):FlipBuffers(0):s(a,b,c,d,1,f):EndMacro:f(0,t,H,V,0):Repeat
ExamineKeyboard():If KeyboardReleased(#PB_Key_Space):If a:f(0,t,H,V,0):Else
f(t,0,0,H,V):EndIf:a!1:EndIf:FlipBuffers():Delay(100)
Until KeyboardPushed(1)
; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 19
; Folding = -
; DisableDebugger