; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8864&highlight=
; Author: jack (updated for PB4.00 by blbltheworm)
; Date: 29. December 2003
; OS: Windows
; Demo: Yes


;this is a translation of an example that was included with "Precision Basic" by Epdel Systems 
;Precision Basic was a basic interpreter for the CP/M operating system. 
;there were no copyrights on the examples, so hopefully it's OK to post. 
;this program computes the taylor coefficients of the function you enter. 

;i changed all gosub's to goto's, so if someone wants to re-write this as a procedure, 
;there should be no problems. 
;i was motivated to post this because of the request of localmotion34, who needed 
;a way to compute derivatives. 
;BTW, if you enter 0 for the number of coefficients, it will evaluate 
;the function you enter, so if someone can untangle this code, 
;it could be used as an eval function. 

;enjoy the SPAGETTY!!! 

    OpenConsole() 
    
    #m=60 

    Global Dim c.f(100) 
    Global Dim e.l(200) 
    Global Dim k.l(200) 
    Global Dim o.l(#m) 
    Global Dim v.l(#m) 
    Global Dim go_sub.l(200) 
    Global Dim s.f(#m,100) 
    Define.f ss,x,y,z,z1,z2,z3,z4 
    Define.l i,oo,o1,o2,j,vv,kk,k1,k2,k3,k4,l,m1,n,n1,ee,e3,e9,vc,go_sub_stack 
    Global Dim a.s(26) 
    aa.s 

    go_sub_stack=0 
    j = 0 
    a(2) = "x": a(3) = "(": a(4) = "acos(": a(5) = "asin(" 
    a(6) = "atan(": a(7) = "cos(": a(8) = "cosh(": a(9) = "exp(" 
    a(10) = "log(": a(11) = "sin(": a(12) = "sinh(": a(13) = "sqrt(" 
    a(14) = "Tan(": a(15) = "Tanh(": a(16) = "-": a(17) = "+" 
    a(21) = "+": a(22) = "-": a(23) = "*": a(24) = "/": a(25) = "^": a(26) = ")" 
    ClearConsole() 
    PrintN("") 
    PrintN("          Program to expand f(x) into a Taylor series") 
    PrintN("") 
1:  Print("Enter by number the highest term to be calculated ") 
    aa=Input() 
    n=Val(aa) 
    If n < 0: Goto 1:EndIf 
    If n > 99 
      PrintN("99 is maximum") 
      Goto 1 
    EndIf 
    PrintN("") 
    PrintN("specify f(x) by entering successive elements of f(x) by code below") 
    PrintN("(entering a zero will delete the last f(x) element)") 
    PrintN("") 
    PrintN("C denotes any constant") 
    j = 1: kk = 1: e9 = 0: e3 = 17 
    PrintN("") 
    Goto 3 
2:  PrintN("") 
    ClearConsole() 
3:  Print("f(x)=") 
    If j = 1: Goto 6:EndIf 
    For i = 1 To j - 1 
       ee = e(i) 
       If ee <> 1: Goto 4:EndIf 
       k1 = k(i) 
       Print(StrF(c(k1))) 
       Goto 5 
4:     Print(a(ee)) 
5:   Next 
6:  PrintN(""): PrintN("") 
    If e3 = 6: Goto 8:EndIf 
    Print("C X ( acos asin atan cos cosh exp  log sin sinh sqr  tan tanh") 
    If e3 = 17 
      PrintN("  -   +") 
      Goto 7 
    EndIf 
    PrintN("") 
7:  Print("1 2 3   4    5    6   7    8   9    10  11   12  13   14  15") 
    If e3 = 17 
      PrintN("   16  17") 
      Goto 10 
    EndIf 
    PrintN("") 
    Goto 10 
8:  Print("+  -  *  /  ^  ") 
    If e9 > 0 
      PrintN(")") 
      Goto 9 
    EndIf 
    PrintN("end of f(x)") 
9:  Print("1  2  3  4  5") 
    If e9 > 0 
      PrintN("  6") 
      Goto 10 
    EndIf 
    PrintN("           6") 
10: Print("Enter code integer ") 
    aa=Input() 
    ee=Val(aa) 
    If (ee < 0) Or (ee > e3): Goto 2:EndIf 
    If ee > 0: Goto 13:EndIf 
    If j = 1: Goto 2:EndIf 
    j = j - 1 
    ee = e(j) 
    If ee < 21: Goto 11:EndIf 
    e3 = 6 
    If ee = 26: e9 = e9 + 1:EndIf 
    Goto 2 
11: If ee < 16: Goto 12:EndIf 
    e3 = 17 
    Goto 2 
12: e3 = 17 
    If (e(j - 1) = 16) Or (e(j - 1) = 17): e3 = 15:EndIf 
    If ee = 1: kk = kk - 1:EndIf 
    If ee >= 3: e9 = e9 - 1:EndIf 
    Goto 2 
13: If e3 = 6: Goto 17:EndIf 
    If e3 = 15: Goto 14:EndIf 
    If ee <= 15: Goto 14:EndIf 
    e3 = 15 
    Goto 19 
14: If ee <> 1: Goto 15:EndIf 
    Print("Enter constant ") 
    aa=Input() 
    c(kk)=ValF(aa) 
    k(j) = kk: kk = kk + 1 
    e3 = 6 
    Goto 19 
15: If ee <> 2: Goto 16:EndIf 
    e3 = 6 
    Goto 19 
16: e9 = e9 + 1 
    e3 = 17 
    Goto 19 
17: ee = ee + 20 
    If ee <> 26: Goto 18:EndIf 
    If e9 = 0: Goto 20:EndIf 
    e9 = e9 - 1 
    Goto 19 
18: e3 = 17 
19: e(j) = ee 
    j = j + 1 
    Goto 2 
20: e(j) = 27 
    n1 = n + 1 
    s(0, 1) = 1 
    If n < 2: Goto 21:EndIf 
    For l = 2 To n 
      s(0, l) = 0 
    Next 
21: For l = 1 To #m 
      s(l, n1) = 0 
    Next 
22: PrintN("") 
    For l = 1 To #m 
      If s(l, n1) <> 0: Goto 84:EndIf 
    Next 
    Print("Enter x value at which series is to be expanded ") 
    aa=Input() 
    If aa = "": Goto 84:EndIf 
    z=ValF(aa) 
    c(0) = z 
    ClearConsole() 
    s(0, 0) = c(0): oo = 0: vv = 0: ss = 0: j = 0: o(0) = 0: e3 = 17 
23: j = j + 1: ee = e(j) 
    If e3 = 6: Goto 30:EndIf 
    If e3 = 15: Goto 24:EndIf 
    If ee < 16: Goto 24:EndIf 
    e3 = 15 
    If ee = 17: Goto 23:EndIf 
    oo = oo + 1 
    o(oo) = 30 
    Goto 23 
24: If ee = 1: Goto 27:EndIf 
    If ee = 2: Goto 26:EndIf 
    If ee = 3: Goto 25:EndIf 
    oo = oo + 1 
    o(oo) = ee + 30 
25: oo = oo + 1 
    o(oo) = 10 
    e3 = 17 
    Goto 23 
26: v(vv) = 0 
    vv = vv + 1 
    e3 = 6 
    Goto 23 
27: For i = 1 To #m 
      If s(i, n1) = 0: Goto 28:EndIf 
    Next 
    PrintN("Stack filled") 
    Goto 84 
28: v(vv) = i 
    vv = vv + 1 
    kk = k(j) 
    s(i, 0) = c(kk) 
    If n < 1: Goto 29:EndIf 
    For kk = 1 To n 
      s(i, kk) = 0 
    Next 
29: s(i, n1) = 1 
    e3 = 6 
    Goto 23 
30: If ee > 24: Goto 31:EndIf 
    o2 = 20 
    If ee > 22: o2 = 22:EndIf 
    Goto 32 
31: o2 = 30 
    If ee > 25: o2 = 20:EndIf 
32: If o(oo) <= o2: Goto 33:EndIf 
    go_sub(go_sub_stack)=78 
    go_sub_stack=go_sub_stack+1 
    Goto 37 
78: Goto 32 
33: If ee = 27: Goto 35:EndIf 
    If ee = 26: Goto 34:EndIf 
    oo = oo + 1 
    o(oo) = ee 
    e3 = 17 
    Goto 23 
34: If o(oo) <> 10: Goto 84:EndIf 
    oo = oo - 1 
    Goto 23 
35: If (o(oo) <> 0) Or (vv <> 1): Goto 84:EndIf 
    i = v(0) 
    s(i, n1) = 0 
    PrintN("") 
    Print("function       = ") 
    PrintN(StrF(s(i, 0))) 
    If n < 1: Goto 36:EndIf 
    For kk = 1 To n 
      Print("a"+RSet(Str(kk),2)) 
      Print("            = ") 
      PrintN(StrF(s(i, kk))) 
      If (kk % 20) = 0: aa=Input():EndIf 
    Next 
36: Goto 22 
37: o1 = o(oo): oo = oo - 1 
38: For kk = 1 To #m 
      If s(kk, n1) = 0: Goto 39:EndIf 
    Next 
    Goto 84 
39: s(kk, n1) = 1 
    z = vv - 1 
    k2 = v(Int(z)) 
    s(k2, n1) = 0 
    If o1 >= 30: Goto 54:EndIf 
    vv = Int(z) 
    z = z - 1 
    k1 = v(Int(z)) 
    v(Int(z)) = kk 
    s(k1, n1) = 0 
    If o1 = 21: Goto 40:EndIf 
    If o1 = 22: Goto 41:EndIf 
    If o1 = 23: Goto 42:EndIf 
    If o1 = 24: Goto 43:EndIf 
    Goto 45 
40: For l = 0 To n 
      s(kk, l) = s(k1, l) + s(k2, l) 
    Next 
    go_sub_stack=go_sub_stack-1 
    vc=go_sub(go_sub_stack) 
    If vc=78: Goto 78:EndIf 
    If vc=79: Goto 79:EndIf 
    If vc=80: Goto 80:EndIf 
    If vc=81: Goto 81:EndIf 
    If vc=82: Goto 82:EndIf 
    If vc=83: Goto 83:EndIf 
41: For l = 0 To n 
      s(kk, l) = s(k1, l) - s(k2, l) 
    Next 
    go_sub_stack=go_sub_stack-1 
    vc=go_sub(go_sub_stack) 
    If vc=78: Goto 78:EndIf 
    If vc=79: Goto 79:EndIf 
    If vc=80: Goto 80:EndIf 
    If vc=81: Goto 81:EndIf 
    If vc=82: Goto 82:EndIf 
    If vc=83: Goto 83:EndIf 
42: For l = 0 To n 
      z = 0 
      For m1 = 0 To l 
        z = z + s(k1, m1) * s(k2, l - m1) 
      Next 
      s(kk, l) = z 
    Next 
    go_sub_stack=go_sub_stack-1 
    vc=go_sub(go_sub_stack) 
    If vc=78: Goto 78:EndIf 
    If vc=79: Goto 79:EndIf 
    If vc=80: Goto 80:EndIf 
    If vc=81: Goto 81:EndIf 
    If vc=82: Goto 82:EndIf 
    If vc=83: Goto 83:EndIf 
43: z1 = s(k2, 0) 
    For l = 0 To n 
      z = s(k1, l) 
      If l = 0: Goto 44:EndIf 
      For m1 = 1 To l 
        z = z - s(k2, m1) * s(kk, l - m1) 
      Next 
44:   s(kk, l) = z / z1 
    Next 
    go_sub_stack=go_sub_stack-1 
    vc=go_sub(go_sub_stack) 
    If vc=78: Goto 78:EndIf 
    If vc=79: Goto 79:EndIf 
    If vc=80: Goto 80:EndIf 
    If vc=81: Goto 81:EndIf 
    If vc=82: Goto 82:EndIf 
    If vc=83: Goto 83:EndIf 
45: If n < 1: Goto 46:EndIf 
    For l = 1 To n 
      z = s(k2, l) 
      If z <> 0: Goto 53:EndIf 
    Next 
46: z1 = s(k1, 0) 
    z = s(k2, 0) 
    z2 = z + 1 
    If z1 = 0: If (Int(z) = z) And (z > 0): Goto 49:EndIf:EndIf 
    s(kk, 0) = Pow(z1,z);exp(ln(z1)*z) 
47: If n < 1: Goto 48:EndIf 
    For l = 1 To n 
      z = 0: z3 = 0 
      For m1 = 1 To l 
        z4 = s(kk, l - m1) * s(k1, m1) 
        z3 = z3 + z4 
        z = z + m1 * z4 
      Next 
      s(kk, l) = (z * z2 / l - z3) / z1 
    Next 
48: go_sub_stack=go_sub_stack-1 
    vc=go_sub(go_sub_stack) 
    If vc=78: Goto 78:EndIf 
    If vc=79: Goto 79:EndIf 
    If vc=80: Goto 80:EndIf 
    If vc=81: Goto 81:EndIf 
    If vc=82: Goto 82:EndIf 
    If vc=83: Goto 83:EndIf 
49: For k3 = 1 To #m 
      If s(k3, n1) = 0: If k3 <> k2: Goto 50:EndIf:EndIf 
    Next 
    Goto 84 
50: s(kk, n1) = 0 
    z2 = z 
    For l = 0 To n 
      s(kk, l) = 0 
      s(k3, l) = s(k1, l) 
    Next 
    s(kk, 0) = 1 
    k4 = kk 
51: z = Int(z2 / 2) 
    z1 = z2 - z - z 
    z2 = z 
    If z1 = 0: Goto 52:EndIf 
    k1 = k3: z = k2: k2 = k4: kk = Int(z): k4 = Int(z) 
    go_sub(go_sub_stack)=79 
    go_sub_stack=go_sub_stack+1 
    Goto 42 
79: If z2 > 0: Goto 52:EndIf 
    s(kk, n1) = 1 
    v(vv - 1) = kk 
    go_sub_stack=go_sub_stack-1 
    vc=go_sub(go_sub_stack) 
    If vc=78: Goto 78:EndIf 
    If vc=79: Goto 79:EndIf 
    If vc=80: Goto 80:EndIf 
    If vc=81: Goto 81:EndIf 
    If vc=82: Goto 82:EndIf 
    If vc=83: Goto 83:EndIf 
52: k1 = k3: z = k2: k2 = k3: kk = Int(z): k3 = Int(z) 
    go_sub(go_sub_stack)=80 
    go_sub_stack=go_sub_stack+1 
    Goto 42 
80: Goto 51 
53: v(vv) = k2 
    s(k2, n1) = 1 
    vv = vv + 1: k2 = k1 
    go_sub(go_sub_stack)=81 
    go_sub_stack=go_sub_stack+1 
    Goto 58 
81: o1 = 23 
    go_sub(go_sub_stack)=82 
    go_sub_stack=go_sub_stack+1 
    Goto 38 
82: o1 = 39 
    go_sub(go_sub_stack)=83 
    go_sub_stack=go_sub_stack+1 
    Goto 38 
83: go_sub_stack=go_sub_stack-1 
    vc=go_sub(go_sub_stack) 
    If vc=78: Goto 78:EndIf 
    If vc=79: Goto 79:EndIf 
    If vc=80: Goto 80:EndIf 
    If vc=81: Goto 81:EndIf 
    If vc=82: Goto 82:EndIf 
    If vc=83: Goto 83:EndIf 
54: v(Int(z)) = kk 
    If o1 <> 30: Goto 55:EndIf 
    For l = 0 To n 
      s(kk, l) = -s(k2, l) 
    Next 
    go_sub_stack=go_sub_stack-1 
    vc=go_sub(go_sub_stack) 
    If vc=78: Goto 78:EndIf 
    If vc=79: Goto 79:EndIf 
    If vc=80: Goto 80:EndIf 
    If vc=81: Goto 81:EndIf 
    If vc=82: Goto 82:EndIf 
    If vc=83: Goto 83:EndIf 
55: If o1 <> 39: Goto 57:EndIf 
    s(kk, 0) = Pow(2.71828,s(k2, 0));exp(s(k2, 0)) 
    If n < 1: Goto 56:EndIf 
    For l = 1 To n 
      z = 0 
      For m1 = 1 To l 
        z = z + m1 * s(kk, l - m1) * s(k2, m1) 
      Next 
      s(kk, l) = z / l 
    Next 
56: go_sub_stack=go_sub_stack-1 
    vc=go_sub(go_sub_stack) 
    If vc=78: Goto 78:EndIf 
    If vc=79: Goto 79:EndIf 
    If vc=80: Goto 80:EndIf 
    If vc=81: Goto 81:EndIf 
    If vc=82: Goto 82:EndIf 
    If vc=83: Goto 83:EndIf 
57: If o1 <> 40: Goto 61:EndIf 
58: z2 = s(k2, 0) 
    s(kk, 0) = Log(z2);ln(z2) 
    If n < 1: Goto 60:EndIf 
    For l = 1 To n 
      z = 0 
      If l = 1: Goto 59:EndIf 
      For m1 = 1 To l - 1 
        z = z + m1 * s(k2, l - m1) * s(kk, m1) 
      Next 
59:   s(kk, l) = (s(k2, l) - z / l) / z2 
    Next 
60: go_sub_stack=go_sub_stack-1 
    vc=go_sub(go_sub_stack) 
    If vc=78: Goto 78:EndIf 
    If vc=79: Goto 79:EndIf 
    If vc=80: Goto 80:EndIf 
    If vc=81: Goto 81:EndIf 
    If vc=82: Goto 82:EndIf 
    If vc=83: Goto 83:EndIf 
61: If (o1=37) Or (o1=38) Or (o1=41) Or (o1=42) Or (o1=44) Or (o1=45): Goto 62:EndIf 
    Goto 68 
62: For k3 = 1 To #m 
      If s(k3, n1) = 0: If k3 <> k2: Goto 63:EndIf:EndIf 
    Next 
    Goto 84 
63: If ((o1 = 37) Or (o1 = 38))=0: Goto 64:EndIf 
    z = kk: kk = k3: k3 = Int(z) 
64: z = s(k2, 0) 
    If (o1 = 38) Or (o1 = 42) Or (o1 = 45): Goto 65:EndIf 
    s(kk, 0) = Sin(z) 
    s(k3, 0) = Cos(z) 
    z1 = -1 
    Goto 66 
65: s(kk, 0) = Pow(2.71828,z);exp(z) 
    s(kk, 0) = 0.5 * (s(kk, 0) - 1 / s(kk, 0)) 
    s(k3, 0) = Pow(2.71828,z);exp(z) 
    s(k3, 0) = 0.5 * (s(k3, 0) + 1 / s(k3, 0)) 
    z1 = 1 
66: If n < 1: Goto 67:EndIf 
    For l = 1 To n 
      z = 0: z2 = 0 
      For m1 = 1 To l 
        z3 = m1 * s(k2, m1) 
        z = z + s(k3, l - m1) * z3 
        z2 = z2 + s(kk, l - m1) * z3 
      Next 
      s(kk, l) = z / l 
      s(k3, l) = z2 * z1 / l 
    Next 
67: If ((o1 = 44) Or (o1 = 45))=0 
      go_sub_stack=go_sub_stack-1 
      vc=go_sub(go_sub_stack) 
      If vc=78: Goto 78:EndIf 
      If vc=79: Goto 79:EndIf 
      If vc=80: Goto 80:EndIf 
      If vc=81: Goto 81:EndIf 
      If vc=82: Goto 82:EndIf 
      If vc=83: Goto 83:EndIf 
    EndIf 
    s(k3, n1) = 1 
    v(vv) = k3 
    vv = vv + 1 
    o1 = 24 
    Goto 38 
68: If o1 <> 43: Goto 69:EndIf 
    z1 = s(k2, 0) 
    z2 = 1.5 
    s(kk, 0) = Sqr(z1) 
    k1 = k2 
    Goto 47 
69: For k3 = 1 To #m 
      If s(k3, n1) = 0: If k3 <> k2: Goto 70:EndIf:EndIf 
    Next 
    Goto 84 
70: z1 = -1 
    If o1 = 36: z1 = 1:EndIf 
    s(k3, 0) = 1 + z1 * s(k2, 0) * s(k2, 0) 
    If n < 1: Goto 71:EndIf 
    For l = 1 To n 
      z = 0 
      For m1 = 0 To l 
        z = z + s(k2, m1) * s(k2, l - m1) 
      Next 
      s(k3, l) = z * z1 
    Next 
71: If o1 <> 36: Goto 74:EndIf 
    s(kk, 0) = ATan(s(k2, 0)) 
    z1 = s(k3, 0) 
    If n < 1: Goto 73:EndIf 
    For l = 1 To n 
      z = 0 
      If l = 1: Goto 72:EndIf 
      For m1 = 1 To l - 1 
        z = z + m1 * s(k3, l - m1) * s(kk, m1) 
      Next 
72:   s(kk, l) = (s(k2, l) - z / l) / z1 
    Next 
73: go_sub_stack=go_sub_stack-1 
    vc=go_sub(go_sub_stack) 
    If vc=78: Goto 78:EndIf 
    If vc=79: Goto 79:EndIf 
    If vc=80: Goto 80:EndIf 
    If vc=81: Goto 81:EndIf 
    If vc=82: Goto 82:EndIf 
    If vc=83: Goto 83:EndIf 
74: s(k3, n1) = 1 
    s(kk, n1) = 0 
    v(vv - 1) = k3 
    z1 = s(k3, 0) 
    s(kk, 0) = Sqr(z1) 
    z2 = 1.5 
    If n < 1: Goto 75:EndIf 
    For l = 1 To n 
      z = 0 
      z3 = 0 
      For m1 = 1 To l 
        z4 = s(kk, l - m1) * s(k3, m1) 
        z3 = z3 + z4 
        z = z + z4 * m1 
      Next 
      s(kk, l) = (z * z2 / l - z3) / z1 
    Next 
75: z1 = s(kk, 0) 
    s(k3, 0) = ASin(s(k2, 0)) 
    If n < 1: Goto 77:EndIf 
    For l = 1 To n 
      z = 0 
      If l = 1: Goto 76:EndIf 
      For m1 = 1 To l - 1 
        z = z + m1 * s(kk, l - m1) * s(k3, m1) 
      Next 
76:   s(k3, l) = (s(k2, l) - z / l) / z1 
    Next 
77: If o1 = 35 
      go_sub_stack=go_sub_stack-1 
      vc=go_sub(go_sub_stack) 
      If vc=78: Goto 78:EndIf 
      If vc=79: Goto 79:EndIf 
      If vc=80: Goto 80:EndIf 
      If vc=81: Goto 81:EndIf 
      If vc=82: Goto 82:EndIf 
      If vc=83: Goto 83:EndIf 
    EndIf 
    s(k3, 0) = s(k3, 0) - 0.5 * #PI 
    o1 = 30 
    Goto 38 
84: 
CloseConsole() 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
