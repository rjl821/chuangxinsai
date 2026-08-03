.model  n12ll  nmos
+level = 54
**************************************************************
*               MODEL FLAG PARAMETERS 
**************************************************************
+lmin    = 6e-008          lmax    = 0.0001          wmin    = 1.2e-007      
+wmax    = 0.0001          version = 4.5             binunit = 2             
+paramchk= 1               mobmod  = 0               capmod  = 2             
+igcmod  = 1               igbmod  = 1               geomod  = 0             
+diomod  = 1               rdsmod  = 0               rbodymod= 0             
+rgatemod= 0               permod  = 1               acnqsmod= 0             
+trnqsmod= 0               tempmod = 0               wpemod  = 1 
**************************************************************
*               GENERAL MODEL PARAMETERS 
**************************************************************
+tnom    = 25              toxe    = 2.00e-009       toxp    = 2.00e-009     
+toxm    = 2.35e-009       dtox    = 0               epsrox  = 3.9           
+wint    = 1.1e-008        lint    = -2.8e-008       ll      = 3.1454e-014   
+wl      = 0               lln     = 0.75345         wln     = 1             
+lw      = 0               ww      = -7.8284e-015    lwn     = 1             
+wwn     = 0.93014         lwl     = 0               wwl     = 1e-022        
+llc     = 0               wlc     = 0               lwc     = 0             
+wwc     = 0               lwlc    = 0               wwlc    = 0             
+xl      = -1.2e-008       xw      = -1.2e-008       dlc     = 7e-009      
+dwc     = 0               xpart   = 1               toxref  = 2.35e-009     
+dlcig   = 1e-009     
**************************************************************
*               DC PARAMETERS 
**************************************************************
***** Vth Related  Parameter ***
+vth0 = 0.7                    lvth0 = 0                     wvth0 = 0                     
+pvth0 = 0                     k1 = 0.53                     k2 = -0.0186                  
+lk2 = 0                       wk2 = 0                       pk2 = 0                       
+k3 = 80                       k3b = 0                       w0 = 2.5E-6                   
+lpe0 = 1.74E-7                plpe0 = 0                     lpeb = 0                      
+vbm = -3                      dvtp0 = 0                     dvtp1 = 0                     
+dvt0 = 2.2                    dvt1 = 0.53                   dvt2 = -0.032                 
+dvt0w = 0                     dvt1w = 5.3E6                 dvt2w = -0.032                
***** Mobility Related Parameter ***
+u0 = 0.067                    lu0 = 0                       wu0 = 0                       
+pu0 = 0                       ua = 1E-9                     lua = 0                       
+pua = 0                       ub = 1E-19                    lub = 0                       
+wub = 0                       pub = 0                       uc = -4.65E-11                
+luc = 0                       wuc = 0                       puc = 0                       
+eu = 1.67                     vsat = 8E4                    lvsat = 0                     
+pvsat = 0                     a0 = 1                        la0 = 0                       
+wa0 = 0                       ags = 0                       pags = 0                      
+b0 = 0                        b1 = 0                        keta = -0.047                 
+lketa = 0                     wketa = 0                     pketa = 0                     
+a1 = 0                        a2 = 1                        rdsw = 0                      
+rdswmin = 0                   rdw = 100                     rdwmin = 0                    
+rsw = 100                     rswmin = 0                    prwb = 0                      
+prwg = 0                      wr = 1                        
+alpha0  = 1e-008          alpha1  = 0.8           
+beta0   = 12.6            lbeta0  = -8.6e-008       agidl   = 1.8e-011      
+bgidl   = 9.5e+008        cgidl   = 10              egidl   = 0.35          
+aigbacc = 0.038           bigbacc = 0.054           cigbacc = 0.075         
+nigbacc = 1               aigbinv = 0.35            bigbinv = 0.03          
+cigbinv = 0.006           eigbinv = 1.1             nigbinv = 3             
+aigc    = 0.01355         bigc    = 0.0021          cigc    = 0.015         
+aigsd   = 0.01            bigsd   = 0.0002          cigsd   = 0.18          
+nigc    = 2               poxedge = 1               pigcd   = 4.4           
+ntox    = 1               xrcrg1  = 12              xrcrg2  = 1 
+kvth0we = 0.0017          k2we    = 0.0005          web     = -250
+wec     = 25              ku0we   = 0.0005          
**************************************************************
*               CAPACITANCE PARAMETERS 
**************************************************************
+cgso    = 7e-011          cgdo    = 7e-011          cgbo    = 0             
+cgdl    = 1e-010          cgsl    = 1e-010          cf      = 8.29e-011    
+acde    = 0.3             moin    = 5.8             noff    = 1.8           
+voffcv  = 0             
**************************************************************
*               TEMPERATURE PARAMETERS 
**************************************************************
+tvoff   = 0.005           ptvoff  = -1e-017         kt1     = -0.185        
+lkt1    = 6.5e-009        wkt1    = 7.5e-010        pkt1    = -5.85e-016    
+kt2     = -0.03           lkt2    = 2e-009          wkt2    = 6.4e-010      
+pkt2    = -3.5e-016       ute     = -0.7            lute    = 1.024e-007    
+wute    = 1.092e-008      pute    = -2.3e-015       ua1     = 2.18e-009     
+lua1    = 1.41e-017       ub1     = -1.55e-018      lub1    = 5.26e-026     
+uc1     = 4.4e-012        luc1    = 1.5e-017        wuc1    = -1.66e-018    
+puc1    = -1e-024         prt     = 0               at      = 10000         
+lat     = 0.00042         pat     = 1.7e-010      
**************************************************************
*               NOISE PARAMETERS 
**************************************************************
+fnoimod = 1               tnoimod = 0               em      = 7e+006        
+ef      = 0.97            noia    = 1.2e+042        noib    = 1.9e+025      
+noic    = 1.2e+008        ntnoi   = 1               lintnoi = 0             
**************************************************************
*               DIODE PARAMETERS 
**************************************************************
+jss     = 1.08e-007       jsws    = 2.78e-014       jswgs   = 2.17e-014     
+njs     = 0.993           ijthsfwd= 0.1             ijthsrev= 0.1           
+bvs     = 10.4            xjbvs   = 1               jtss    = 0             
+jtsd    = 0               jtssws  = 0               jtsswd  = 0             
+jtsswgs = 5e-008          jtsswgd = 5e-008          njts    = 20            
+njtssw  = 20              njtsswg = 20              xtss    = 0.02          
+xtsd    = 0.02            xtssws  = 0.02            xtsswd  = 0.02          
+xtsswgs = 0.02            xtsswgd = 0.02            tnjts   = 0             
+tnjtssw = 0               tnjtsswg= 0               pbs     = 1.04          
+cjs     = 0.00154         mjs     = 0.578           pbsws   = 0.185         
+cjsws   = 2.9e-011        mjsws   = 0.194           pbswgs  = 1.19891       
+cjswgs  = 2.6616e-010     mjswgs  = 0.9             tpb     = 0.0012        
+tcj     = 0.000852        tpbsw   = 0.0001          tcjsw   = 0.0001        
+tpbswg  = 0.001653        tcjswg  = 0.0011109       xtis    = 3                    
**************************************************************
*               LAYOUT RELATED PARAMETERS 
**************************************************************
+dmcg    = 6.4e-008        dmdg    = 0               dmcgt   = 0             
+dwj     = 0               xgw     = 0               xgl     = 0             
**************************************************************
*               RF PARAMETERS 
**************************************************************
**************************************************************
*               STRESS PARAMETERS 
**************************************************************
+saref   = 1.75e-007       sbref   = 1.75e-007       wlod    = 0             
+kvth0   = 1.5e-008        lkvth0  = 2e-007          wkvth0  = -5e-008       
+pkvth0  = 2e-014          llodvth = 1               wlodvth = 1             
+stk2    = 0               lodk2   = 1               lodeta0 = 1             
+ku0     = -9e-008         lku0    = 5e-007          wku0    = 1e-006        
+pku0    = 0               llodku0 = 1               wlodku0 = 1             
+kvsat   = 1               steta0  = 0               tku0    = 0           
