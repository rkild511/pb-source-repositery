; German forum: http://www.purebasic.fr/german/viewtopic.php?t=9894&start=20
; Author: remi_meier (1st changes by 'pphjs', final GUI improvements and speed-up by 'PureLust')
; Date: 25. February 2007
; OS: Windows
; Demo: No


; Program: Fluid Dynamics

; Author: (the great) remi_meier (1st changes by 'pphjs', final GUI improvements and speed-up by 'PureLust')
; Date: 25. February 2007
; OS: Windows (should work on other OS as well)

EnableExplicit
DisableDebugger

#N = 100                     ; Anzahl der Gitterpunkte, die berechnet werden
#DSTEP = 5                   ; Pixel per Gitterpunkt in der Darstellung
#SIZE = (#N + 2) * (#N + 2)

Define YPos=278, LH=19, LS=9  ; Variablen für Gadget Anordnung
Global pause
Global plot.l = 0           ; 0 - zeichnet Dichtefeld, sonst Geschwindigkeitsfeld
Global dense.f=0.18, grav.f=9.81     ;dense - Diche des Anfangsfeldes und am Rand, grav - Gravitationskonstante
Global visc.f = 0.0001, dt.f = 0.01, diff.f = 0.00018   ; visc - (turbulente) Vikosität
Global xdense.f = 1/dense                                 ; dt   - Zeitschritt
Global Viscosity = 8         ; (Originalwert = 19)      ; diff - (turbulente) Diffusionskonstante
Global DensityChange.f = 1.5                                             

Structure FArray                                     
  f.f[0]
EndStructure


Macro IX(i, j)
  (i) + (n + 2) * (j)
EndMacro

Declare set_bnd(n.l, b.l, *x.FArray)
Declare project(n.l, *u.FArray, *v.FArray, *p.FArray, *div.FArray)

Procedure add_source_gravity(n.l, *x.FArray, *s.FArray, *d.FArray, dt.f)
  Define.l i, j
 
    For i = 0 To n+1
      For j = 0 To n+1
        *x\f[IX(i, j)] + dt* (*s\f[IX(i, j)] - grav * (dense-*d\f[IX(i, j)])*xdense)
      Next
    Next
 EndProcedure

Procedure add_source(n.l, *x.FArray, *s.FArray, dt.f)
  Define.l i, Size = (n + 2) * (n + 2)
 
  For i = 0 To Size - 1
    *x\f[i] + dt * *s\f[i]
  Next
EndProcedure


Procedure diffuse(n.l, b.l, *x.FArray, *x0.FArray, diff.f, dt.f)
  Define.l i, j, k
  Define.f a,xa
  a = dt * diff * n * n
  xa = 1 / (1.0 + 4.0 * a)
 
  For k = 0 To Viscosity
    For i = 1 To n
      For j = 1 To n
        *x\f[IX(i, j)] = (*x0\f[IX(i, j)] + a * (*x\f[IX(i-1, j)] + *x\f[IX(i+1, j)] + *x\f[IX(i, j-1)] + *x\f[IX(i, j+1)])) * xa
;        *x\f[IX(i, j)] = (*x0\f[IX(i, j)] + a * (*x\f[IX(i-1, j)] + *x\f[IX(i+1, j)] + *x\f[IX(i, j-1)] + *x\f[IX(i, j+1)])) / (1.0 + 4.0 * a)
;        *x\f[IX(i, j)] = *x0\f[IX(i, j)] + a * (*x0\f[IX(i-1, j)] + *x0\f[IX(i+1, j)] + *x0\f[IX(i, j-1)] + *x0\f[IX(i, j+1)] - 4 * *x0\f[IX(i, j)])
      Next
    Next
    set_bnd(n, b, *x)
  Next
EndProcedure



Procedure advect (n.l, b.l, *d.FArray, *d0.FArray, *u.FArray, *v.FArray, dt.f)
  Define.l i, j, i0, j0, i1, j1
  Define.f x, y, s0, t0, s1, t1, dt0
  dt0 = dt * n
 
  For i = 1 To n
    For j = 1 To n
      x = i - dt0 * *u\f[IX(i, j)]
      y = j - dt0 * *v\f[IX(i, j)]
     
      If (x < 0.5)
        x = 0.5
      ElseIf (x > n + 0.5)
        x = n + 0.5
      EndIf
      i0 = Int(x)
      i1 = i0 + 1
     
      If (y < 0.5)
        y = 0.5 
      ElseIf (y > n + 0.5)
        y = n + 0.5
      EndIf
      j0 = Int(y)
      j1 = j0 + 1
     
      s1 = x - i0 : s0 = 1 - s1 : t1 = y - j0 : t0 = 1 - t1
      *d\f[IX(i, j)] = s0 * (t0 * *d0\f[IX(i0, j0)] + t1 * *d0\f[IX(i0, j1)]) + s1 * (t0 * *d0\f[IX(i1, j0)] + t1 * *d0\f[IX(i1, j1)])
     
    Next
  Next
  set_bnd(n, b, *d)
EndProcedure

Procedure dens_step(n.l, *x.FArray, *x0.FArray, *u.FArray, *v.FArray, diff.f, dt.f)
  add_source(n, *x, *x0, dt)
  diffuse(n, 0, *x0, *x, diff, dt )
  advect(n, 0, *x, *x0, *u, *v, dt )
EndProcedure

Procedure vel_step(n.l, *u.FArray, *v.FArray, *u0.FArray, *v0.FArray, *d.FArray, visc.f, dt.f)
  add_source(n, *u, *u0, dt) : add_source_gravity(n, *v, *v0, *d, dt); add_source(n, *v, *v0, dt)
  diffuse(n, 1, *u0, *u, visc, dt)
  diffuse(n, 2, *v0, *v, visc, dt)
  project(n, *u0, *v0, *u, *v)
 
  advect(n, 1, *u, *u0, *u0, *v0, dt) : advect(n, 2, *v, *v0, *u0, *v0, dt)
  project(n, *u, *v, *u0, *v0)
EndProcedure


Procedure project(n.l, *u.FArray, *v.FArray, *p.FArray, *div.FArray)
  Define.l i, j, k
  Define.f h = 1.0 / n
  Define.f xh = 1/h
  Define.f hh = -0.5 * h
 
  For i = 1 To n
    For j = 1 To n
      *div\f[IX(i, j)] = hh * (*u\f[IX(i+1, j)] - *u\f[IX(i-1, j)] + *v\f[IX(i, j+1)] - *v\f[IX(i, j-1)])
      *p\f[IX(i, j)] = 0
    Next
  Next
  set_bnd(n, 3, *div) : set_bnd(n, 3, *p)
 
  For k = 0 To Viscosity
    For i = 1 To n
      For j = 1 To n
        *p\f[IX(i, j)] = (*div\f[IX(i, j)] + *p\f[IX(i-1, j)] + *p\f[IX(i+1, j)] + *p\f[IX(i, j-1)] + *p\f[IX(i, j+1)]) * 0.25
      Next
    Next
    set_bnd(n, 3, *p)
  Next
 
  For i = 1 To n
    For j = 1 To n
      *u\f[IX(i, j)] - (0.5 * (*p\f[IX(i+1, j)] - *p\f[IX(i-1, j)]) * xh)
      *v\f[IX(i, j)] - (0.5 * (*p\f[IX(i, j+1)] - *p\f[IX(i, j-1)]) * xh)
    Next
  Next
  set_bnd(n, 1, *u) : set_bnd(n, 2, *v)
EndProcedure


Procedure set_bnd(n.l, b.l, *x.FArray)
  Define.l i
 
   Select b
   
   Case 0      ; Dichte Rand
      For i = 0 To n+1
         *x\f[IX(0,   i)] = dense
         *x\f[IX(n+1, i)] = dense
         *x\f[IX(i,   0)] = dense
         *x\f[IX(i, n+1)] = dense
      Next     
     
   Case 1      ; Ost- bzw. Westrand, fester Rand u=0
      For i = 0 To n+1
         *x\f[IX(0,   i)] = 0.0
         *x\f[IX(n+1, i)] = 0.0
      Next     
   
   Case 2      ; Nord- bzw. Suedrand, fester Rand v=0
      For i = 0 To n+1
         *x\f[IX(i,   0)] = 0.0
         *x\f[IX(i, n+1)] = 0.0
      Next     
   
   Case 3      ; Raender fuer die Naeherungsverfahren
      For i = 0 To n+1
         *x\f[IX(0,   i)] = 0
         *x\f[IX(n+1, i)] = 0
         *x\f[IX(i,   0)] = 0
         *x\f[IX(i, n+1)] = 0
      Next
 
 EndSelect

EndProcedure

;- End Simulation

Procedure.l color_gr( f1.d,f2.d)
   Protected r.l, g.l, b.l,v.f
   v=$500*Sqr(f1*f1+f2*f2) 
   g=$FF
   b=$80
   r = $FF -v
   If r < 0 : g + r : r=0   
    If g < 0 :    r - g  : g=0
         If g <  $80 : b + g            : EndIf   
         If g >= $80 : b +$FF-g         : EndIf
         If r <  $80 : b + r            : EndIf   
     If r >= $80
       If r < $17F 
          b =$17F-r : r = $80
       Else
         r-$FF : b=0 
         If r>=$1FF:r=$FF:g=$FF:b=$FF   :EndIf
         If r>$FF :g=r-$FF:b=r-$FF:r=$FF:EndIf
       EndIf
     EndIf   
   EndIf
  EndIf
  ProcedureReturn = RGB(r, g, b)
EndProcedure


Procedure draw_(n.l, *u.FArray, *v.FArray, im.l, jm.l)
   Define.l i, j , xi, xj, xn=(n-1)*#DSTEP
   Define.f um, vm
   Define.s info
   ; Draw Density- / Velosity-Field
   StartSpecialFX()
   xi = 0
   For i = 0 To xn Step #DSTEP
      xi + 1
      xj = 0
      For j = 0 To xn Step #DSTEP
         xj + 1
         DisplaySolidSprite(0,i,j,color_gr(*u\f[IX(xi, xj)],*v\f[IX(xi, xj)]))
      Next
   Next
   StopSpecialFX()
   
   ;display cross-hair at Mouse position
   StartDrawing(ScreenOutput())
   Line(im*#DSTEP-#DSTEP/2,jm*#DSTEP-2*#DSTEP,0,3.5*#DSTEP,RGB(255,255,255))
   Line(im*#DSTEP-2*#DSTEP,jm*#DSTEP-#DSTEP/2,3.5*#DSTEP,0,RGB(255,255,255))
   StopDrawing()
   FlipBuffers(0)
   
   If plot = 0
      SetGadgetText(1,"Akt.Density : "+StrF(*u\f[IX(im, jm)],3)+" kg/m³")
   Else
      um=*u\f[IX(im, jm)]
      vm=*v\f[IX(im, jm)]
      SetGadgetText(2,"u = "+StrF(um,3)+" m/s")
      SetGadgetText(3,"v = "+StrF(vm,3)+" m/s")
      SetGadgetText(4,"Sqrt(u²+v²) = "+StrF(Sqr(um*um+vm*vm),3)+" m/s")
   EndIf
   SetGadgetText(5,"RGB Color Value = $"+HexQ(color_gr(*u\f[IX(im, jm)],*v\f[IX(im, jm)])))
EndProcedure

Procedure set_dens (n.l, *d.FArray)
  Define.l i, Size = (n + 2) * (n + 2)
 
  For i = 0 To Size - 1
    *d\f[i]= dense
  Next
EndProcedure

Procedure set_datas(n.l,  *dens0.FArray, *u0.FArray, *v0.FArray, im.l, jm.l)
   Define.l z, Size = (n + 2) * (n + 2)
   
   fillmemory_(*dens0, (n + 2) * (n + 2) * SizeOf(Float), 0)
   If MouseButton(1)
      SetGadgetColor(10,#PB_Gadget_FrontColor,$ff)
      If KeyboardPushed(#PB_Key_LeftShift) Or KeyboardPushed(#PB_Key_RightShift)
          *dens0\f[IX(im+z, jm)] = - DensityChange / dt ;Dichteaenderung pro Zeitschritt
      Else
         *dens0\f[IX(im+z, jm)] = DensityChange / dt ;Dichteaenderung pro Zeitschritt
      EndIf
   Else
      SetGadgetColor(10,#PB_Gadget_FrontColor,$00)
   EndIf
   If MouseButton(2)
      SetGadgetColor(11,#PB_Gadget_FrontColor,$ff)
      If KeyboardPushed(#PB_Key_LeftShift) Or KeyboardPushed(#PB_Key_RightShift)
         *u0\f[IX(im+z, jm)] = -10/dt  ;Geschwindigkeitsaenderung pro Zeitschritt
         *v0\f[IX(im+z, jm)] = -8 /dt  ;Geschwindigkeitsaenderung pro Zeitschritt
      Else
         *u0\f[IX(im+z, jm)] = 10/dt  ;Geschwindigkeitsaenderung pro Zeitschritt
         *v0\f[IX(im+z, jm)] = 8 /dt  ;Geschwindigkeitsaenderung pro Zeitschritt
      EndIf
   Else
      SetGadgetColor(11,#PB_Gadget_FrontColor,$00)
   EndIf
   If KeyboardPushed(#PB_Key_LeftShift) Or KeyboardPushed(#PB_Key_RightShift)
      SetGadgetColor(12,#PB_Gadget_FrontColor,$ff0000)
   Else
      SetGadgetColor(12,#PB_Gadget_FrontColor,$00)
   EndIf
   *u0\f[IX(90, 90)] = -2.0 /dt ; hier ist ein Quirl eingebaut, rausnehmen
   *v0\f[IX(90, 90)] = -2.0 /dt
EndProcedure


Procedure main()
   Define *u.FArray = AllocateMemory(#SIZE * SizeOf(Float))
   Define *v.FArray = AllocateMemory(#SIZE * SizeOf(Float))
   Define *u_prev.FArray = AllocateMemory(#SIZE * SizeOf(Float))
   Define *v_prev.FArray = AllocateMemory(#SIZE * SizeOf(Float))
   Define *dens.FArray = AllocateMemory(#SIZE * SizeOf(Float))
   Define *dens_prev.FArray = AllocateMemory(#SIZE * SizeOf(Float))
   Static im.l, jm.l, Quit.l
   Define Drawstart.l, FrameCounter.l, KeyPressed.l
   
   set_dens(#N, *dens) ; Dichtefeld fuer den Anfang belegen
   
   Repeat
      If FrameCounter = 10 : Drawstart = ElapsedMilliseconds() : FrameCounter = 0 : EndIf
      FrameCounter + 1
      ExamineMouse()
      im = im+MouseDeltaX()
      jm = jm+MouseDeltaY()
      If im > #N : im = #N : EndIf
      If im < 1 :  im = 1  : EndIf ; 0 ist Randpunkt, darf nicht gesetzt werden
      If jm > #N : jm = #N : EndIf
      If jm < 1  : jm = 1  : EndIf
      
      If Not pause Or MouseButton(1) | MouseButton(2)
         set_datas(#N,  *dens_prev, *u_prev, *v_prev, im, jm)
         If Not pause
            vel_step(#N, *u, *v, *u_prev, *v_prev, *dens, visc, dt)
            dens_step(#N, *dens, *dens_prev, *u, *v, diff, dt)
         Else
            vel_step(#N, *u, *v, *u_prev, *v_prev, *dens, visc/10, dt/10)
            dens_step(#N, *dens, *dens_prev, *u, *v, diff*10, dt/10)
         EndIf
      EndIf      
      If plot = 0 
         draw_(#N, *dens,*dens, im, jm)
      Else
         draw_(#N, *u,*v, im, jm)
      EndIf
      If FrameCounter = 10 : SetWindowTitle(0,"Fluid Dynamics  ("+StrF(10000/(ElapsedMilliseconds()-Drawstart),1)+"fps)") : EndIf
      ExamineKeyboard()
      If KeyPressed < ElapsedMilliseconds()
         If KeyboardPushed(#PB_Key_Add)
            If Viscosity < 30 : Viscosity +1 : EndIf
            SetGadgetText(6,"Viscositylevel : "+Str(Viscosity))
            KeyPressed = ElapsedMilliseconds()+150
         ElseIf KeyboardPushed(#PB_Key_Subtract)
            If Viscosity > 1 : Viscosity -1 : EndIf
            SetGadgetText(6,"Viscositylevel : "+Str(Viscosity))
            KeyPressed = ElapsedMilliseconds()+150
         ElseIf KeyboardPushed(#PB_Key_Down)
            If DensityChange < 4.9 : DensityChange + 0.1 : EndIf
            SetGadgetText(7,"Change Density to : "+StrF(DensityChange,1)+" kg/m³")
            KeyPressed = ElapsedMilliseconds()+60
         ElseIf KeyboardPushed(#PB_Key_Up)
            If DensityChange > - 4.9 : DensityChange - 0.1 : EndIf
            SetGadgetText(7,"Change Density to : "+StrF(DensityChange,1)+" kg/m³")
            KeyPressed = ElapsedMilliseconds()+60
         ElseIf KeyboardPushed(#PB_Key_D)
            plot = 1-plot
            DisableGadget(1,plot)
            DisableGadget(2,1-plot)
            DisableGadget(3,1-plot)
            DisableGadget(4,1-plot)
            If plot = 0
               SetGadgetText(8,"Display : Density Field")
            Else
               SetGadgetText(8,"Display : Flow Velocity")
            EndIf
            KeyPressed = ElapsedMilliseconds()+150
         ElseIf KeyboardPushed(#PB_Key_Space)
            pause = 1-pause
            KeyPressed = ElapsedMilliseconds()+150
         ElseIf KeyboardPushed(#PB_Key_Escape)
            Quit = 1
         EndIf
      ElseIf Not KeyboardPushed(#PB_Key_All)
         KeyPressed = 0
      EndIf
      While WindowEvent() : Wend
   Until Quit
EndProcedure


InitSprite()
InitMouse()
InitKeyboard()

OpenWindow(0, 100, 100, #N * #DSTEP+200, #N * #DSTEP, "Fluid Dynamics")
CreateGadgetList(WindowID(0))
Frame3DGadget(0,#N * #DSTEP+10,10,180,254,"Actual Values")
TextGadget(1,#N * #DSTEP+20,38,160,18,"Dichte : 0.000 kg/m³")
TextGadget(2,#N * #DSTEP+20,66,160,18,"u = 0.000 m/s")
TextGadget(3,#N * #DSTEP+20,94,160,18,"v = 0.000 m/s")
TextGadget(4,#N * #DSTEP+20,122,160,18,"Sqrt(u²+v²) = 0.000 m/s")
TextGadget(5,#N * #DSTEP+20,150,160,18,"")
TextGadget(6,#N * #DSTEP+20,178,160,18,"Viscositylevel : "+Str(Viscosity))
TextGadget(7,#N * #DSTEP+20,206,160,18,"Change Density to : "+StrF(DensityChange,1)+" kg/m³")
TextGadget(8,#N * #DSTEP+20,234,160,18,"Display : Density Field")
DisableGadget(2,1)
DisableGadget(3,1)
DisableGadget(4,1)
YPos = 278
TextGadget(10,#N * #DSTEP+20,YPos+0*LH+0*LS,180,18,"Left-MB    =  Modify Density")
TextGadget(11,#N * #DSTEP+20,YPos+1*LH+0*LS,180,18,"Right-MB  =  Add Twirl")
TextGadget(12,#N * #DSTEP+20,YPos+2*LH+0*LS,180,18,"+ <Shift>  =  Invert above Values")
TextGadget(13,#N * #DSTEP+20,YPos+3*LH+1*LS,180,18,"<+> = increase Viscosity")
TextGadget(14,#N * #DSTEP+20,YPos+4*LH+1*LS,180,18,"<-> = decrease Viscosity")
TextGadget(15,#N * #DSTEP+20,YPos+5*LH+2*LS,180,18,"<Csr Up> = decrease Density")
TextGadget(16,#N * #DSTEP+20,YPos+6*LH+2*LS,180,18,"<Csr Dn> = increase Density")
TextGadget(17,#N * #DSTEP+20,YPos+7*LH+3*LS,180,18,"<D> = Change Display type")
TextGadget(18,#N * #DSTEP+20,YPos+8*LH+4*LS,180,18,"<ESC> = Exit Program")

OpenWindowedScreen(WindowID(0), 0, 0, #N * #DSTEP+000, #N * #DSTEP, 0, 0, 0)
If Not CatchSprite(0,?5Pixel_Sprite,#PB_Sprite_Alpha) : End : EndIf
main()
FreeSprite(0)
CloseScreen()
CloseWindow(0)
End

;{
DataSection
  5Pixel_Sprite:
  Data.l 73289026,0,70647808,2621440,327680,327680,65536,8,2621440,0
  Data.l 0,0,0,0,0,-2147483520,-2147483648,8388736,8388608,-2139094912
  Data.l -1061158912,-591396672,-890240832,536871078,536870976,536871008,536871040,536871072,536871104,1073742048
  Data.l 1073741824,1073741856,1073741888,1073741920,1073741952,1073741984,1073742016,1610612960,1610612736,1610612768
  Data.l 1610612800,1610612832,1610612864,1610612896,1610612928,-2147483424,-2147483648,-2147483616,-2147483584,-2147483552
  Data.l -2147483520,-2147483488,-2147483456,-1610612512,-1610612736,-1610612704,-1610612672,-1610612640,-1610612608,-1610612576
  Data.l -1610612544,-1073741600,-1073741824,-1073741792,-1073741760,-1073741728,-1073741696,-1073741664,-1073741632,-536870688
  Data.l -536870912,-536870880,-536870848,-536870816,-536870784,-536870752,-536870720,4194528,4194304,4194336
  Data.l 4194368,4194400,4194432,4194464,4194496,541065440,541065216,541065248,541065280,541065312
  Data.l 541065344,541065376,541065408,1077936352,1077936128,1077936160,1077936192,1077936224,1077936256,1077936288
  Data.l 1077936320,1614807264,1614807040,1614807072,1614807104,1614807136,1614807168,1614807200,1614807232,-2143289120
  Data.l -2143289344,-2143289312,-2143289280,-2143289248,-2143289216,-2143289184,-2143289152,-1606418208,-1606418432,-1606418400
  Data.l -1606418368,-1606418336,-1606418304,-1606418272,-1606418240,-1069547296,-1069547520,-1069547488,-1069547456,-1069547424
  Data.l -1069547392,-1069547360,-1069547328,-532676384,-532676608,-532676576,-532676544,-532676512,-532676480,-532676448
  Data.l -532676416,8388832,8388608,8388640,8388672,8388704,8388736,8388768,8388800,545259744
  Data.l 545259520,545259552,545259584,545259616,545259648,545259680,545259712,1082130656,1082130432,1082130464
  Data.l 1082130496,1082130528,1082130560,1082130592,1082130624,1619001568,1619001344,1619001376,1619001408,1619001440
  Data.l 1619001472,1619001504,1619001536,-2139094816,-2139095040,-2139095008,-2139094976,-2139094944,-2139094912,-2139094880
  Data.l -2139094848,-1602223904,-1602224128,-1602224096,-1602224064,-1602224032,-1602224000,-1602223968,-1602223936,-1065352992
  Data.l -1065353216,-1065353184,-1065353152,-1065353120,-1065353088,-1065353056,-1065353024,-528482080,-528482304,-528482272
  Data.l -528482240,-528482208,-528482176,-528482144,-528482112,12583136,12582912,12582944,12582976,12583008
  Data.l 12583040,12583072,12583104,549454048,549453824,549453856,549453888,549453920,549453952,549453984
  Data.l 549454016,1086324960,1086324736,1086324768,1086324800,1086324832,1086324864,1086324896,1086324928,1623195872
  Data.l 1623195648,1623195680,1623195712,1623195744,1623195776,1623195808,1623195840,-2134900512,-2134900736,-2134900704
  Data.l -2134900672,-2134900640,-2134900608,-2134900576,-2134900544,-1598029600,-1598029824,-1598029792,-1598029760,-1598029728
  Data.l -1598029696,-1598029664,-1598029632,-1061158688,-1061158912,-1061158880,-1061158848,-1061158816,-1061158784,-68157280
  Data.l -1599864577,-2139094880,128,-16776961,-16777216,16711935,16711680,-65281,-65536,-65281
  Data.l 16777215,-65536,16777215,-65536,16777215,-65536,16777215,-65536,16777215
  Data.b 0,0
EndDataSection
;}

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ---
; EnableXP