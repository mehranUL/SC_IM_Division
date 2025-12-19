Latch


.protect
.hdl iMTJOrg.va

.include '14nfetlstp.pm'
.include '14pfetlstp.pm'
.include '14nfet.pm'
.include '14pfet.pm'
.unprotect


.global Vdd
*.global clk
*.global clkb

***************************************************
*CIRCUIT TOPOLOGY
***************************************************



****************************************************************************
*Write Circuit**************************************************************
****************************************************************************
.subckt	PIM	inA	inAb inB inBb AND NAND OR NOR clk clkb

*MTJ1 Write Circuit******************************************************

mWrite1 inA  clk  MTJ1L   vdd  pfet   NFIN='NFIN_Write'  

mWrite2 inAb clkb MTJ1R   0	   nfet	  NFIN='NFIN_Write'	

Xmtj1	ReadUp	MTJ1L	MTJ1R		mzmtj1		model	PAP=0


*MTJ2 Write Circuit******************************************************

mWrite3 inB  clk  MTJ2L  vdd    pfet   NFIN='NFIN_Write'  

mWrite4 inBb clkb netM   0		nfet   NFIN='NFIN_Write'	

Xmtj2	MTJ1R	MTJ2L	netM		mzmtj2		model	PAP=0



****************************************************************************
*Read CIRCUIT and MTJs**********************************************************************
****************************************************************************

mRead1 ReadUp clkb  vdd vdd     pfet	NFIN='NFIN_Read'  

mRead2 ReadDn clk   0   0		nfet	NFIN='NFIN_Read'	

mRead3 vdd  clkb  MTJ5L Vdd     pfet	NFIN='NFIN_Read'  

mRead4 ReadDn  clk  0   0		nfet	NFIN='NFIN_Read'	


Xmtj5	netM	MTJ5L	    ReadDn		mzmtj5		model	PAP=0

*Rtest ReadDn ReadDn1 1  **baraye didan jarian khandan
*.probe I(Rtest)


*********************************************************************************************
*Curent comparitor********************************************************************************
*********************************************************************************************

EsaN1 AND  0 netM refN max=0.9 min=0 -200
EsaN2 NAND 0 netM refN max=0.9 min=0 +200

vrefN refN 0 0.4700

*******************************

EsaP1 OR  0 netM refP max=0.9 min=0 -200
EsaP2 NOR 0 netM refP max=0.9 min=0 +200

vrefP refP 0 0.5500



.ends


XPIM1  Z	Zb    X2b   X2     AND1 AND1b OR1 OR1b clk  clkb PIM
XPIM2  X1	X1b   X2    X2b    AND2 AND2b OR2 OR2b clk  clkb PIM
XPIM3  AND1	AND1b AND2  AND2b  AND3 AND3b z   zb   clkb clk  PIM




*********************************************************************************************
*Voltages************************************************************************************
*********************************************************************************************
.param NFIN_Write=3
.param NFIN_Read=1


.param Vdd=0.9 
.param vdd12='vdd/2'
.param vdd14='vdd/4'
.param vdd34='3*(vdd/4)'
.param t=10n
.param r=1p



vdd VDD 0 DC VDD
Vclk	clk	 0	pulse	(vdd	0	0	r	r	5n   	10n)
Vclkb	clkb 0	pulse	(0	    vdd	0	r	r	5n	    10n)

VX1   X1  0  PWL (0       vdd    't'   vdd    't+r'   0     '3*t'  0     '3*t+r'  vdd   '4*t'   vdd
+                 '4*t+r' 0      '5*t' 0      '5*t+r' vdd   '6*t'  vdd   '6*t+r'  0     '16.5*t'  0)


VX1b  X1b 0  PWL (0       0      't'   0      't+r'   vdd   '3*t'  vdd   '3*t+r'  0     '4*t' 0
+                 '4*t+r' vdd    '5*t' vdd    '5*t+r' 0     '6*t'  0     '6*t+r'  vdd   '16.5*t' vdd)




VX2   X2  0  PWL (0       vdd    't'    vdd    't+r'    0       '3*t'   0       '3*t+r'   vdd    '6*t' vdd
+                 '6*t+r' 0      '11*t' 0      '11*t+r' vdd     '12*t'  vdd     '12*t+r'  0      '16.5*t' 0)


VX2b  X2b 0  PWL (0       0     't'    0      't+r'    vdd     '3*t'   vdd     '3*t+r'   0      '6*t'  0
+                 '6*t+r' vdd   '11*t' vdd    '11*t+r' 0       '12*t'  0       '12*t+r'  vdd    '16.5*t' vdd)



*VZ    Z   0  PWL (0        vdd   '4*t'    vdd    '4*t+r'    0       '5*t'   0       '5*t+r'   vdd    '11*t' vdd
*+                 '11*t+r' 0     '16*t'   0)
*
*VZb   Zb  0  PWL (0        0     '4*t'    0    '4*t+r'    vdd       '5*t'   vdd       '5*t+r'   0    '11*t' 0
*+                 '11*t+r' vdd   '16*t'   vdd)


*********************************************************************************************
*MEASURMEN***********************************************************************************
*********************************************************************************************

.TRAN 0.1n '16.5*t'


.MEASURE TRAN tpW1   TRIG V(clk) td=09n   VAL='Vdd/2'  cross=1   TARG V(mzmtj1) td=09n   VAL='+0.8' cross=1
.MEASURE TRAN tpW2   TRIG V(clk) td=29n   VAL='Vdd/2'  cross=1   TARG V(mzmtj2) td=29n   VAL='-0.8' cross=1
.MEASURE TRAN tpW3   TRIG V(clk) td=39n   VAL='Vdd/2'  cross=1   TARG V(mzmtj2) td=39n   VAL='+0.8' cross=1
.MEASURE TRAN tpW4   TRIG V(clk) td=49n   VAL='Vdd/2'  cross=1   TARG V(mzmtj2) td=49n   VAL='-0.8' cross=1
.MEASURE TRAN tpW5   TRIG V(clk) td=59n   VAL='Vdd/2'  cross=1   TARG V(mzmtj1) td=59n   VAL='+0.8' cross=1


.MEASURE TRAN tpNOR1  TRIG V(clk) td=49n     VAL='Vdd/2'   cross=1 TARG V(z)  td=49n    VAL='Vdd/2'     CROSS=1
.MEASURE TRAN tpNOR2  TRIG V(clk) td=119n    VAL='Vdd/2'   cross=1 TARG V(z)  td=119n   VAL='vdd/2'     CROSS=1
.MEASURE TRAN tpNOR3  TRIG V(clk) td=129n    VAL='Vdd/2'   cross=1 TARG V(z)  td=129n   VAL='Vdd/2'     CROSS=1
.MEASURE TRAN tpNOR4  TRIG V(clk) td=139n    VAL='Vdd/2'   cross=1 TARG V(z)  td=139n   VAL='Vdd/2'     CROSS=1
.MEASURE TRAN tpNOR4  TRIG V(clk) td=149n    VAL='Vdd/2'   cross=1 TARG V(z)  td=149n   VAL='Vdd/2'     CROSS=1
.MEASURE TRAN tpNOR4  TRIG V(clk) td=159n    VAL='Vdd/2'   cross=1 TARG V(z)  td=159n   VAL='Vdd/2'     CROSS=1

.measure tran p_vdd avg p(vdd)

.END
