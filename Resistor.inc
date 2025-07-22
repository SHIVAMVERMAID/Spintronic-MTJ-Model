** Title:  Resistance.inc
** Author: jagadish iit(bhu),varanasi
** Email:  jagadishstudent.rs.ece19@itbhu.ac.in

************************************************************************************
******* Resistance depends on relative angle, temperature and bias voltage.*********
************************************************************************************

.subckt RA n_plus n_minus res isz Tmp th phi lx='45n' ly='45n' P0='0.73' RA0='5'

******************Spherical coordinate *********************************************
.param s1(x)='sin(x)'
.param c1(x)='cos(x)'
.param c2(x)='cos(x)*cos(x)'
.param th_hard='0'
.param phi_hard='0'

E_mdp mdp 0 vol='(s1(v(th))*c1(v(phi))*s1(th_hard)*c1(phi_hard)) + (s1(v(th))*s1(v(phi))*s1(th_hard)*s1(phi_hard)) + (c1(v(th))*c1(th_hard))'

********************************* Temp. dependent parameters *******************
.param asp='2e-5'

********************************* Rp *******************************************
.param RA='RA0*1e-12'   $ [ohm*m2]
.param Rp='RA/(3.14*lx*ly)'

********************************* TMR ******************************************
.param v0='0.65'
E_TMR0 TMR0 0 vol='2*P0^2*(1-asp*v(Tmp)^1.5)^2/(1-P0^2*(1-asp*v(Tmp)^1.5)^2)*100'
E_TMR TMR 0 vol='v(TMR0)/(1+((v(n_plus)-v(n_minus))/v0)^2)'
E_Rap Rap 0 vol='(v(TMR)/100+1)*Rp'

**** R(V,Tmp,th) *****************************************************************
**** Defining resistance of the MTJ in voltage form ******************************

R_MTJ n_plus n_minus '(((1+v(mdp))*(Rp-v(Rap))/2+v(Rap))+(1000*lxshm/(lyshm*lzshm)*1n))' 
E_rmtj res 0 vol='(((1+v(mdp))*(Rp-v(Rap))/2+v(Rap))+(1000*lxshm/(lyshm*lzshm)*1n))'
E_isz isz 0 vol='(v(n_plus)-v(n_minus))/((((1+v(mdp))*(Rp-v(Rap))/2+v(Rap))+(1000*lxshm/(lyshm*lzshm)*1n)))'

.ends
