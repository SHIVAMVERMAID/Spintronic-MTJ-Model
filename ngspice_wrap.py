## Monte carlo using python
## steps:-
## generate random parameter values using "gauss" function
## in a for loop open a file modify .param and run the netlist
## reports are saved in ./run_all.txt 
import os
import numpy as np
import re 
#sgauss = np.random.normal(0, 1, 1)  #similar to sgauss(0) in ngspice

def gauss(nom,var,sigma):
    #sgauss = np.random.normal(0, var, 1) ## generate random gauss variation with mean=0 deviation = 1 
    sgauss = np.random.normal(nom, var, 1)  
    return(sgauss) ## returns variation plus nominal 
#print(gauss(65e-9,0.4,3))    
run = 1
mc_runs = 1000 ## total monte carlo runs


for i in range(1,mc_runs+1):
    #lx = gauss(65e-9,0.4,3)[0] 
    lx = gauss(65e-9,4e-8,3)[0]
    #ly = gauss(65e-9,0.4,3)[0]
    ly = gauss(65e-9,4e-8,3)[0]
    #lz = gauss(1.48e-9,0.04,3)[0]
    lz = gauss(1.48e-9,4e-10,3)[0]
    #P0 = gauss(0.85,0.27,3)[0]
    P0 = gauss(0.85,0.4,3)[0]
    print("value of lx is "+str(lx))
    print("value of ly is "+str(ly))
    print("value of lz is "+str(lz))
    print("value of P0 is "+str(P0)+"\n")
    #assign parameter values to ngspice netlist using regex
    ng_file = open("/home/shivam/Desktop/Ravneet_work/STT_MTJ_Final_Model/Jagadish_work/MonteCarlo/pcsa_montecarlo_she/pcsa_monte_read.txt","r")
    netlist = ng_file.read()
    netlist = re.sub(".param lx = .*",".param lx = "+str(lx),netlist)
    netlist = re.sub(".param ly = .*",".param ly = "+str(ly),netlist)
    netlist = re.sub(".param lz = .*",".param lz = "+str(lz),netlist)
    netlist = re.sub(".param P0 = .*",".param P0 = "+str(P0),netlist)
    ng_file.close()
    open("/home/shivam/Desktop/Ravneet_work/STT_MTJ_Final_Model/Jagadish_work/MonteCarlo/pcsa_montecarlo_she/pcsa_monte_read.txt","w").close() #clears file contents
    ng_file_mod = open("/home/shivam/Desktop/Ravneet_work/STT_MTJ_Final_Model/Jagadish_work/MonteCarlo/pcsa_montecarlo_she/pcsa_monte_read.txt","a")
    ng_file_mod.write(netlist)
    ng_file_mod.close()
    
    #print(netlist)
    
    cmd = 'ngspice -b -o pcsa_monte.log pcsa_monte_read.txt'
    os.system(cmd)
    print("completed " + str(run) +" runs\n")
    run  = run + 1

print("Finished!!\n")
