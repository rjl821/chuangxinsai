.MODEL nmos nmos
****************************************************************
*                        Flag Parameter
****************************************************************
+LEVEL   = 72.0            BULKMOD = 1.0             ASYMMOD = 0              
+COREMOD = 0               GEOMOD  = 2.0             RDSMOD  = 0              
+IGCMOD  = 0               IGBMOD  = 0               GIDLMOD = 0              
+IIMOD   = 0               NQSMOD  = 0               SHMOD   = 0              
+RGATEMOD= 0               RGEOMOD = 0               CGEOMOD = 0              
+CAPMOD  = 1.0             VERSION = 107.0           CGEO1SW = 0              

****************************************************************
*                   Geometry Range Parameter
****************************************************************
+LINT    = 5.14907e-10     LL      = -4.9E-17        LLN     = 1.0266         
+DLC     = 4.53632E-9      DLBIN   = 0               LLC     = 0              
+DLCACC  = 0              

****************************************************************
*                       Process Parameter
****************************************************************
+EOT     = 1.1E-9          TOXP    = 1.2E-9          EOTBOX  = 1.4E-7         
+HFIN    = 1.5E-8          FECH    = 1.0             DELTAW  = 0              
+FECHCV  = 1.0             DELTAWCV= 0               NBODY   = 1.0E21         
+NBODYN1 = 0               NBODYN2 = 100000          NSD     = 2.0E26         
+PHIG    = 4.61            EPSROX  = 3.9             PHIGL   = 0              
+PHIGN1  = -0.08           PHIGN2  = 42.135          EPSRSUB = 11.9           
+EASUB   = 4.05            NI0SUB  = 1.1E16          BG0SUB  = 1.12           
+NC0SUB  = 2.86E25         NGATE   = 0               Imin    = 1.0E-15        

****************************************************************
*                     Short Channel Effects
****************************************************************
+CIT     = 0               CDSC    = 0.218904        CDSCD   = 0.007          
+CDSCN1  = 1.0             CDSCN2  = 40.0            CDSCDN1 = 1.0            
+CDSCDN2 = 40.0            CDSCDRN1= 0               CDSCDRN2= 100000         
+DVT1SS  = 0.597188        ETA0N1  = 0               ETA0N2  = 100000         
+TETA0   = 0               TETA0R  = 0               DVTP0   = 0.005          
+DVTP1   = 0               CDSCDR  = 0.007           DVT0    = 0              
+DVT1    = 0.6             PHIN    = 0.05            ETA0    = 0.6            
+ETA0R   = 0.6             DSUB    = 0.3415          K1RSCE  = -0.0558        
+LPE0    = 9.86572E-7      DVTSHIFT= 0              

****************************************************************
*      Lateral Non-uniform Doping Effect (IV-CV Vth Shift)
****************************************************************
+K0      = 0               K01     = 0               K0SI    = 1.0            
+K0SI1   = 0               K1SI    = 1.0             K1SI1   = 0              

****************************************************************
*Body Effect for MG Devices on Bulk Substrate (ex: FinFETs on BULK)
****************************************************************
+PHIBE   = 0.7             K1      = 0               K11     = 0              
+K1SAT   = 0               K1SAT1  = 0              

****************************************************************
*                   Quantum Mechanical Effect
****************************************************************
+QMFACTOR= 0               QMTCENIV= 0               QMTCENCV= 0.478459       
+QMTCENCVA= 0              AQMTCEN = 0               BQMTCEN = 1.2E-8         
+ETAQM   = 0.54            QM0     = 0.247132        PQM     = 0.66           
+QM0ACC  = 0.001           PQMACC  = 0.66           

****************************************************************
*                   Velocity Saturation Model
****************************************************************
+VSAT    = 85000.0         AVSAT   = -18121.2        BVSAT   = 0.0282274      
+VSATN1  = 93.5749         VSATN2  = 40.0            VSAT1N1 = 0              
+VSAT1N2 = 100000          VSAT1RN1= 0               VSAT1RN2= 100000         
+VSAT1   = 85000.0         AVSAT1  = 0               VSAT1R  = 85000.0        
+BVSAT1  = 1.0E-7          DELTAVSAT= 1.0            KSATIV  = 1.0            
+MEXP    = 8.79236         AMEXP   = -29.8353        BMEXP   = 1.0            
+MEXPR   = 4.0             AMEXPR  = 0               BMEXPR  = 1.0            
+PTWG    = 0.4             APTWG   = -15.8453        BPTWG   = 0.35628        
+AT      = -0.00156        TMEXP   = 0               TMEXPR  = 0              
+PTWGT   = 0.004           PTWGR   = 0               PSAT    = 2.0            
+APSAT   = 0               BPSAT   = 1.0             VSATCV  = 85000.0        
+AVSATCV = 0               BVSATCV = 1.0E-7          DELTAVSATCV= 1.0         
+PSATCV  = 2.0             APSATCV = 0               BPSATCV = 1.0            

****************************************************************
*                  Mobility Related Parameter
****************************************************************
+U0      = 0.03            ETAMOB  = 0.05            UP      = -9.54E-4       
+U0N1    = -0.08           U0N2    = 7538.0          LPA     = 0.742881       
+UA      = 0.3             AUA     = -4.22023        BUA     = 0.35           
+EU      = 2.5             UC      = 0               AEU     = 0              
+BEU     = 1.0E-7          UD      = 54.3787         AUD     = -67.8901       
+BUD     = 8.9E-8          UCS     = 5.47114         UTE     = 0              
+UTL     = -0.0015         EMOBT   = 0               UA1     = 0.001032       
+UD1     = 0               UC1     = 5.6E-11         UCSTE   = -0.004775      
+CHARGEWF= 0              

****************************************************************
*                    Access Resistance Model
****************************************************************
+RDSWMIN = 0               RDSW    = 100.0           ARDSW   = -14.9648       
+BRDSW   = 0.166954        RSWMIN  = 0               RSW     = 50.0           
+ARSW    = 0               BRSW    = 1.0E-7          RDWMIN  = 0              
+RDW     = 50.0            ARDW    = 0               BRDW    = 1.0E-7         
+WR      = 1.0             PRT     = 0.0011          RSDR    = 0              
+RSDRR   = 0               RDDR    = 0               RDDRR   = 0              
+PRSDR   = 1.0             PRDDR   = 1.0             PRWGS   = 0              
+PRWGD   = 0               TRSDR   = 0               TRDDR   = 0              

****************************************************************
*                          DIBL Model
****************************************************************
+PDIBL1  = 1.3             PDIBL2  = 0               PDIBL1R = 1.3            
+DROUT   = 0.483466        PVAG    = 1.25677        

****************************************************************
*               Channel Length Modulation Effect
****************************************************************
+PCLM    = 0.0227808       APCLM   = -3.3101         BPCLM   = 1.0E-7         
+PCLMG   = 7.88812         PCLMCV  = 0.013          

****************************************************************
*                     Non-saturation Effect
****************************************************************
+A1      = 0               A11     = 0               A2      = 0              
+A21     = 0              

****************************************************************
*                   Gate Electrode Resistance
****************************************************************
+RGEXT   = 0               RGFIN   = 0.001           RSHS    = 0              
+RSHD    = 0               HEPI    = 1.0E-8          TSILI   = 1.0E-8         
+RHOC    = 1.0E-12         RHORSD  = 1.0             CRATIO  = 0.5            
+DELTAPRSD= 0              SDTERM  = 0               LSP     = 6.0E-9         
+EPSRSP  = 3.9             TGATE   = 3.0E-8          TMASK   = 3.0E-8         
+ASILIEND= 0               ARSDEND = 0               PRSDEND = 0              
+NSDE    = 2.0E25          RGEOA   = 1.0             RGEOB   = 0              
+RGEOC   = 0               RGEOD   = 0               RGEOE   = 0              
+CGEOA   = 1.0             CGEOB   = 0               CGEOC   = 0              
+CGEOD   = 0               CGEOE   = 1.0            

****************************************************************
*                         Gate Current
****************************************************************
+AIGBINV = 1.0             BIGBINV = 9.49E-4         CIGBINV = 0.006          
+EIGBINV = 1.1             NIGBINV = 3.0             AIGBACC = 0.0136         
+BIGBACC = 0.00171         CIGBACC = 0.075           NIGBACC = 1.0            
+AIGC    = 0.0136          BIGC    = 0.00171         CIGC    = 0.075          
+DLCIGS  = 0               AIGS    = 0.0136          BIGS    = 0.00171        
+CIGS    = 0.075           DLCIGD  = 0               AIGD    = 0.0136         
+BIGD    = 0.00171         CIGD    = 0.075           POXEDGE = 1.0            
+AGIDL   = 6.055E-12       BGIDL   = 3.0E8           CGIDL   = 0.5            
+EGIDL   = 0.2             PGIDL   = 1.0             AGISL   = 6.055E-12      
+BGISL   = 3.0E8           CGISL   = 0.5             EGISL   = 0.2            
+PIGCD   = 1.0             AIGBINV1= 0               AIGBACC1= 0              
+AIGC1   = 0               AIGS1   = 0               AIGD1   = 0              
+TOXREF  = 1.2E-9          TOXG    = 1.2E-9          NTOX    = 1.0            

****************************************************************
*                   Impact Ionization Current
****************************************************************
+ALPHA0  = 0               ALPHA1  = 0               BETA0   = 0              
+BETAII0 = 0               BETAII1 = 0               BETAII2 = 0.1            
+ESATII  = 1.0E7           LII     = 5.0E-10         SII0    = 0.5            
+SII1    = 0.1             SII2    = 0               SIID    = 0              
+ALPHA01 = 0               ALPHA11 = 0               ALPHAII0= 0              
+ALPHAII01= 0              ALPHAII1= 0               ALPHAII11= 0             

****************************************************************
*              Accumulation Capacitance (CAPMOD=1)
****************************************************************
+EOTACC  = 1.24245e-10     DELVFBACC= -0.317005     

****************************************************************
*                      Fringe Capacitance
****************************************************************
+CFS     = 8.162E-11       CFD     = 8.162E-11      

****************************************************************
*             Overlap Capacitance (CGEOMOD=0 and 2)
****************************************************************
+CGSO    = 0               CGDO    = 0               CGSL    = 1.07875e-10    
+CGDL    = 1.07875e-10     CKAPPAS = 0.6             CKAPPAD = 0.6            
+CGBO    = 0               CGBL    = 0               CKAPPAB = 0.6            
+CGBN    = 0              

****************************************************************
*        Source/Drain to Substrate Sidewall Capacitance
****************************************************************
+CSDESW  = 0.6            

****************************************************************
*               Junction Current and Capacitance
****************************************************************
+CJS     = 5.0E-4          CJD     = 5.0E-4          CJSWS   = 5.0E-10        
+CJSWD   = 5.0E-10         CJSWGS  = 0               CJSWGD  = 0              
+PBS     = 1.0             PBD     = 1.0             PBSWS   = 1.0            
+PBSWD   = 1.0             PBSWGS  = 1.0             PBSWGD  = 1.0            
+MJS     = 0.5             MJD     = 0.5             MJSWS   = 0.33           
+MJSWD   = 0.33            MJSWGS  = 0.33            MJSWGD  = 0.33           
+SJS     = 0               SJD     = 0               SJSWS   = 0              
+SJSWD   = 0               SJSWGS  = 0               SJSWGD  = 0              
+MJS2    = 0.125           MJD2    = 0.125           MJSWS2  = 0.083          
+MJSWD2  = 0.083           MJSWGS2 = 0.083           MJSWGD2 = 0.083          
+JSS     = 1.0E-4          JSD     = 1.0E-4          JSWS    = 0              
+JSWD    = 0               JSWGS   = 0               JSWGD   = 0              
+NJS     = 1.0             NJD     = 1.0             IJTHSFWD= 0.1            
+IJTHDFWD= 0.1             IJTHSREV= 0.1             IJTHDREV= 0.1            
+BVS     = 10.0            BVD     = 10.0            XJBVS   = 1.0            
+XJBVD   = 1.0            

****************************************************************
*            Tunneling Component of Junction Current
****************************************************************
+JTSS    = 0               JTSD    = 0               JTSSWS  = 0              
+JTSSWD  = 0               JTSSWGS = 2.0E-5          JTSSWGD = 2.0E-5         
+JTWEFF  = 0               NJTS    = 20.0            NJTSD   = 20.0           
+NJTSSW  = 20.0            NJTSSWD = 20.0            NJTSSWG = 20.0           
+NJTSSWGD= 20.0            VTSS    = 10.0            VTSD    = 10.0           
+VTSSWS  = 10.0            VTSSWD  = 10.0            VTSSWGS = 10.0           
+VTSSWGD = 10.0            LINTIGEN= 1.0E-10         NTGEN   = 1.0            
+AIGEN   = 0               BIGEN   = 0              

****************************************************************
*     NQS Gate Resistance Model & NQS Charge Deficit Model
****************************************************************
+XRCRG1  = 12.0            XRCRG2  = 1.0            

****************************************************************
*                NQS Charge Segementation Model
****************************************************************
+NSEG    = 4.0            

****************************************************************
*                         Flicker Noise
****************************************************************
+EF      = 1.0             EM      = 4.1E7           NOIA    = 6.25E39        
+NOIB    = 3.125E24        NOIC    = 8.75E7         

****************************************************************
*                         Thermal Noise
****************************************************************
+NTNOI   = 1.0            

****************************************************************
*                      Temperature Effects
****************************************************************
+TNOM    = 27.0            TBGASUB = 7.02E-4         TBGBSUB = 1108.0         
+KT1     = 0               KT1L    = 0               IIT     = -0.5           
+TII     = 0               TGIDL   = -0.003          IGT     = 2.5            
+TCJ     = 0               TCJSW   = 0               TCJSWG  = 0              
+TPB     = 0               TPBSW   = 0               TPBSWG  = 0              
+XTIS    = 3.0             XTID    = 3.0             XTSS    = 0.02           
+XTSD    = 0.02            XTSSWS  = 0.02            XTSSWD  = 0.02           
+XTSSWGS = 0.02            XTSSWGD = 0.02            TNJTS   = 0              
+TNJTSD  = 0               TNJTSSW = 0               TNJTSSWD= 0              
+TNJTSSWG= 0               TNJTSSWGD= 0              TSS     = 0              

****************************************************************
*                         Self Heating
****************************************************************
+RTH0    = 0.01            CTH0    = 1.0E-5          WTH0    = 0              

****************************************************************
*                            Others
****************************************************************
+TFIN    = 1.0E-8          NFIN    = 1.0             xl      = 0              
+tfin    = 1.0E-8         

