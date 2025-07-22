************************************************************************************
************************************************************************************
** Title:  MTJ_write_SOT.sp
** Author: Ibrahim Ahmed, VLSI Research Lab @ UMN
** Email:  ahmed589@umn.edu
************************************************************************************
** This run file simulates the dynamic motion of  MTJ.
** # Instruction for simulation
** 1. Set the MTJ dimensions and material parameters.
** 2. Select anisotropy(IMA/PMA) and initial state of free layer(P/AP).
** 3. Adjust bias voltage for Read/Write operation.
** ex. APtoP switching: positive voltage @ ini='1'
**     PtoAP switching: negative voltage @ ini='0'  
************************************************************************************
** # Description of parameters
** lx,ly,lz: width, length, and thickness of free layer
** tox: MgO thickness
** Ms0:saturation magnetizaion at 0K
** P0: polarization factor at 0K 
** alpha: damping factor
** temp: temperature
** MA: magnetic anisotropy (MA=0:In-plane,MA=1:Perpendicular)
**     also sets magnetization in pinned layer, MA=0:[0,1,0],MA=1:[0,0,1]
** ini: initial state of free layer (ini=0:Parallel,ini=1:Anti-parallel)
**  This model can be used for 4 different switching mechanism: 1) STT Only, 2) SHE Only + Ext. field, 3) STT + SHE, 4) STT + SHE + Ext. field
** External field is defined in 'H_app' in Oe
** UI = 1 for user defined initial angle, 'InA', UI = 0 for avg. initial angle
** 'x_ad' is the additional field like torque. It  is defined as a fraction of damping like torque. 
** So, x_ad = 0.5 means the field like torque has a magnitude half of the damping like torque


** The following code is the switching mechanism type 2)SHE only switching with external field
************************************************************************************

.include 'mtj_sbckt_she_a.txt'
.include 'mosistsmc180.sp'
*** Options ************************************************************************
.option post
.save
.option seed=random
.param RAp=5
.param t = 5e-9

.param istt = '100n' 
.param ISHM = '400n' 
.param tshm  = '800p'

.param damping = 0.02
*I1 1 0 PULSE (0 ISTT 1.5n 50p 50p 40n 80n)
*I2 3 0 PULSE (0 ISHM 1.5n 50p 50p 40n 80n)   

*I1 1 0 PULSE (0 ISTT  1.5n 100p 100p 50n 80n)   
*I2 3 0 PULSE (0 ISHM 1.5n 100p 100p tshm 80n) 
 V_2 2 0
 
XMTJ1 1 2 3 MTJ lx='45n' ly='45n' lz='2.5n' Ms0='1185' P0='0.73' alpha='0.02' Tmp0='300' RA0='RAp' lxshm ='60n' lyshm='45n' lzshm='t' Ku='621600' UI='1' InA ='3.14' H_app = '400'
XMTJ2 4 5 2 MTJ lx='45n' ly='45n' lz='2.5n' Ms0='1185' P0='0.73' alpha='0.02' Tmp0='300' RA0='RAp' lxshm ='60n' lyshm='45n' lzshm='t' Ku='621600' UI='1' InA='0.02436' H_app='-400'

**XMTJ1 1 2 3 MTJ_SOT lx='45n' ly='45n' lz='2.5n' tox='1.5n' Ms0='1185'  P0='0.73' alpha='0.02' Tmp0='300' RA0='RAp' MA='0' ini='0' Kp='9e6'  lxshm ='60n' lyshm= '45n' lzshm= 't' SHA='0.4' **H_app = ' 000 ' UI = '0' InA = ' 0.02436'  x_ad ='0'
**XMTJ2 4 2 5 MTJ_SOT lx='45n' ly='45n' lz='2.5n' tox='1.5n' Ms0='1185'  P0='0.73' alpha='0.02' Tmp0='300' RA0='RAp' MA='0' ini='0' Kp='9e6'  lxshm ='60n' lyshm= '45n' lzshm= 't' SHA='0.4' **H_app = ' 000 ' UI = '0' InA ='0.02436'  x_ad ='0'

MN1 3 wwl wbl wbl NMOS w=8.14u l=0.18u
MN2 1 rwl1 rbl rbl NMOS w= 8.14u l=0.18u
MN3 4 rwl2 rbl rbl NMOS w= 8.14u l=0.18u
 
**** Voltage sources ****

Vwwl wwl 0 pwl(5n 0 5.1n 1.8V 20.1n 1.8V 20.2n 0 35.2n 0 35.3n 1.8V 50.3n 1.8V 50.4n 0) 
Vwbl wbl 0 pwl(5n 0 5.1n 1.8V 20.1n 1.8V 20.2n 0 )
Vsl 5 0 pwl(35.2n 0 35.3n 1.8V 50.3n 1.8V 50.4n 0) 
Vrbl rbl 0 pwl(65.4n 0 65.5n 1.8V 80.5n 1.8V 80.6n 0 )
Vrwl1 rwl1 0 pwl(65.4n 0 65.5n 1.8V 80.5n 1.8V 80.6n 0)
Vrwl2 rwl2 0 pwl(65.4n 0 65.5n 1.8V 80.5n 1.8V 80.6n 0)

**** Transient analysis ****
.control
run 
tran 10n 60n UIC
plot v(wwl) v(wbl)+2 v(5)+4 v(rbl)+6 v(rwl1)+8 v(rwl2)+10
plot v(xmtj1.mz) v(xmtj2.mz) 
plot v(xmtj2.isz) v(xmtj1.isz)
plot v(xmtj2.isx) v(xmtj1.isx)
plot v(xmtj2.isy) v(xmtj1.isy)

.endc

.end

