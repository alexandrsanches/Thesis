************************************************************************
*******CODE FOR FRBSF ACYCLICAL/CYCLICAL CORE PCE INFLATION 
					 ****WRITTEN BY ADAM SHAPIRO********* 
					 ****Citation: Shapiro, Adam Hale. "A Simple Framework to Monitor Inflation." Federal Reserve Bank of San Francisco, 2020.
************************************************************************
/*
SETTINGS
local level  2 
local foodenergy 0 
local thresh 2.326 
local gap ugap
local min_date 1985
local max_date 2007 
*/

clear all
set more off
cap log close
capture set haverdir M:\Haver\DLX\DATA
//capture set haverdir \\l1werp20\haver\haver\dlx\data\

*Level of Aggregation
local level 2
*Include Food and Energy?
local foodenergy 0 /* 1 for yes, 0 for no*/
*t-stat threshold
local thresh 2.326 //1.282  1.645, 1.960, 2.326
*Measuring the cycle as output gap or ugap
local gap ugap /*ugap or ygap*/
*Regression sample
local min_date 1985
local max_date 2007 

if `level' == 0 {
if `foodenergy' == 0 { 
import haver /*
       */ (CM CXFEM JCM JCXFEM)@USNA  (CSENT LR YPLTPMH)@USECON (IP CUT)@IP /*
	   Motor vehiccles */ CDVM@USNA /*
	   Furnishings */ CDFDM@USNA /*
	   Recreational Goods */ CDRGM@USNA /*
	   Other durable goods */ CDOM@USNA /*
	   Clothing & Footwear */ CNLM@USNA /*
	   Other nondurables */ CNOOM@USNA /*
	   Housing */ CSRM@USNA /*
	   water  */ CSLSM@USNA /*
	   Healthcare */ CSDM@USNA /*
	   Transportation */ CSTM@USNA /*
	   Recreational Services */ CSREM@USNA /*
	   Food services & acc */ CSFCM@USNA /*
	   Financial services */ CSNM@USNA /*
	   Other services */ CSOM@USNA /*
	   NPISH */ NPCFM@USNA /*
	 
	   Motor vehiccles */ JCDVM@USNA /*
	   Furnishings */ JCDFDM@USNA /*
	   Recreational Goods */ JCDRGM@USNA /*
	   Other durable goods */ JCDOM@USNA /*
	   Clothing & Footwear */ JCNLM@USNA /*
	   Other nondurables */ JCNOOM@USNA /*
	   Housing */ JCSRM@USNA /*
	   water */ JCSLSM@USNA /* 
	   Healthcare */ JCSDM@USNA /*
	   Transportation */ JCSTM@USNA /*
	   Recreational Services */ JCSREM@USNA /*
	   Food services & acc */ JCSFCM@USNA /*
	   Financial services */ JCSNM@USNA /*
	   Other services */ JCSOM@USNA /*
	   NPISH */ JNPCFM@USNA, tvar(time_month)
	   }
if `foodenergy' == 1 { 
import haver /*
       */ (CM CXFEM JCM JCXFEM)@USNA  (CSENT LR YPLTPMH)@USECON (IP CUT)@IP /*
	   Motor vehiccles */ CDVM@USNA /*
	   Food */ CNFOM@USNA /*
	   energy */ CNEM@USNA /*
	   Furnishings */ CDFDM@USNA /*
	   Recreational Goods */ CDRGM@USNA /*
	   Other durable goods */ CDOM@USNA /*
	   Clothing & Footwear */ CNLM@USNA /*
	   Other nondurables */ CNOOM@USNA /*
	   Housing */ CSRUM@USNA /*
	   Healthcare */ CSDM@USNA /*
	   Transportation */ CSTM@USNA /*
	   Recreational Services */ CSREM@USNA /*
	   Food services & acc */ CSFCM@USNA /*
	   Financial services */ CSNM@USNA /*
	   Other services */ CSOM@USNA /*
	   NPISH */ NPCFM@USNA /*
	   
	   Motor vehiccles */ JCDVM@USNA /*
	   Food */ JCNFOM@USNA /*
	   energy */ JCNEM@USNA /*
	   Furnishings */ JCDFDM@USNA /*
	   Recreational Goods */ JCDRGM@USNA /*
	   Other durable goods */ JCDOM@USNA /*
	   Clothing & Footwear */ JCNLM@USNA /*
	   Other nondurables */ JCNOOM@USNA /*
	   Housing */ JCSRUM@USNA /*
	   Healthcare */ JCSDM@USNA /*
	   Transportation */ JCSTM@USNA /*
	   Recreational Services */ JCSREM@USNA /*
	   Food services & acc */ JCSFCM@USNA /*
	   Financial services */ JCSNM@USNA /*
	   Other services */ JCSOM@USNA /*
	   NPISH */ JNPCFM@USNA, tvar(time_month)
	   }	   
}	   	   
if `level' == 1 {
if `foodenergy' == 1 { 
*1st level disaggregation 
import haver /*
       */ (CM CXFEM JCM JCXFEM)@USNA  (CSENT LR YPLTPMH)@USECON (IP CUT)@IP /*
	    Consumption Expenditures */ /* 
		Motor vehicles */ CDMVNM@USNA CDMVUM@USNA CDMTM@USNA /*
		Furnishings*/ CDFFM@USNA CDFKM@USNA CDFGM@USNA CDFOSM@USNA /*
		Recreational goods */ CDRGTM@USNA CDRSM@USNA CDRSVM@USNA CDRBM@USNA CDFTIM@USNA /*
		Other durable goods */ CDOJM@USNA CDOOM@USNA CDEBM@USNA CDOLM@USNA CDOTM@USNA /*
		Clothing and footwear */ CNLFM@USNA CNLOM@USNA /*	
		Other nondurable */ CNODM@USNA CNRM@USNA CNOLM@USNA CNOPM@USNA CNOTM@USNA CNMOM@USNA CNOVEM@USNA /*
		Housing and utilities */ CSRM@USNA CSUM@USNA /*
		Health care */ CSDOM@USNA CSMNM@USNA /*
		Transportation services */ CSTUM@USNA CSTBM@USNA /*
		Recreation services */ CSRECM@USNA CSREPM@USNA CSREGM@USNA CSRERM@USNA /*
		Food services & accommodations*/ CSFVM@USNA CSCM@USNA /*
		Financial services and insurance */ CSNFM@USNA CSNIM@USNA /*
		Other services */ CSLTPM@USNA CSOEM@USNA CSOPFM@USNA CSPCM@USNA CSSRM@USNA CSLRM@USNA CSOTM@USNA /*
		Nonprofit */ NPCFM@USNA /*
	Indeces */ /*
		Motor vehicles */ JCDMVNM@USNA JCDMVUM@USNA JCDMTM@USNA /*
		Furnishings */ JCDFFM@USNA JCDFKM@USNA JCDFGM@USNA JCDFOSM@USNA /*
		Recreational goods */ JCDRGTM@USNA JCDRSM@USNA JCDRSVM@USNA JCDRBM@USNA JCDFTIM@USNA /*
		Other durable goods */ JCDOJM@USNA JCDOOM@USNA JCDEBM@USNA JCDOLM@USNA JCDOTM@USNA /*
		Clothing */ JCNLFM@USNA JCNLOM@USNA /*
		Other nondurable */ JCNODM@USNA JCNRM@USNA JCNOLM@USNA JCNOPM@USNA JCNOTM@USNA JCNMOM@USNA JCNOVUM@USNA JCNOVRM@USNA /*
		Housing and utilities */ JCSRM@USNA JCSUM@USNA /*
		Health care */ JCSDOM@USNA JCSMNM@USNA /*
		Transportation services */ JCSTUM@USNA JCSTBM@USNA /*
		Recreation services */ JCSRECM@USNA JCSREPM@USNA JCSREGM@USNA JCSRERM@USNA /*
		Food services and accommodations */ JCSFVM@USNA JCSCM@USNA /*
		Financial services and insurance */ JCSNFM@USNA JCSNIM@USNA /*
		Other services */ JCSLTPM@USNA JCSOEM@USNA JCSOPFM@USNA JCSPCM@USNA JCSSRM@USNA JCSLRM@USNA JCSVTM@USNA JCSVXM@USNA /*
		Nonprofit */ JNPCFM@USNA /*
	Food and Energy */ /*
        Gasoline and other energy */ CNGM@USNA CNOFM@USNA /*
	    Gasoline and other energy */ JCNGM@USNA JCNOFM@USNA /*
	    Food and beverages */ CNFOBM@USNA CNFOLM@USNA CNFEFM@USNA /*
	    Food and beverages */ JCNFOBM@USNA JCNFOLM@USNA JCNFEFM@USNA, tvar(time_month)
}
else if `foodenergy' == 0 {
import haver /*
       */ (CM CXFEM JCM JCXFEM)@USNA  (CSENT LR YPLTPMH)@USECON (IP CUT)@IP /*
	    Consumption Expenditures */ /* 
		Motor vehicles */ CDMVNM@USNA CDMVUM@USNA CDMTM@USNA /*
		Furnishings*/ CDFFM@USNA CDFKM@USNA CDFGM@USNA CDFOSM@USNA /*
		Recreational goods */ CDRGTM@USNA CDRSM@USNA CDRSVM@USNA CDRBM@USNA CDFTIM@USNA /*
		Other durable goods */ CDOJM@USNA CDOOM@USNA CDEBM@USNA CDOLM@USNA CDOTM@USNA /*
		Clothing and footwear */ CNLFM@USNA CNLOM@USNA /*	
		Other nondurable */ CNODM@USNA CNRM@USNA CNOLM@USNA CNOPM@USNA CNOTM@USNA CNMOM@USNA CNOVEM@USNA /*
		Housing and utilities */ CSRM@USNA     /*
		Health care */ CSDOM@USNA CSMNM@USNA /*
		Transportation services */ CSTUM@USNA CSTBM@USNA /*
		Recreation services */ CSRECM@USNA CSREPM@USNA CSREGM@USNA CSRERM@USNA /*
		Food services & accommodations*/ CSFVM@USNA CSCM@USNA /*
		Financial services and insurance */ CSNFM@USNA CSNIM@USNA /*
		Other services */ CSLTPM@USNA CSOEM@USNA CSOPFM@USNA CSPCM@USNA CSSRM@USNA CSLRM@USNA CSOTM@USNA /*
		Nonprofit */ NPCFM@USNA /*
	Indeces */ /*
		Motor vehicles */ JCDMVNM@USNA JCDMVUM@USNA JCDMTM@USNA /*
		Furnishings */ JCDFFM@USNA JCDFKM@USNA JCDFGM@USNA JCDFOSM@USNA /*
		Recreational goods */ JCDRGTM@USNA JCDRSM@USNA JCDRSVM@USNA JCDRBM@USNA JCDFTIM@USNA /*
		Other durable goods */ JCDOJM@USNA JCDOOM@USNA JCDEBM@USNA JCDOLM@USNA JCDOTM@USNA /*
		Clothing */ JCNLFM@USNA JCNLOM@USNA /*
		Other nondurable */ JCNODM@USNA JCNRM@USNA JCNOLM@USNA JCNOPM@USNA JCNOTM@USNA JCNMOM@USNA JCNOVUM@USNA JCNOVRM@USNA /*
		Housing and utilities */ JCSRM@USNA     /*
		Health care */ JCSDOM@USNA JCSMNM@USNA /*
		Transportation services */ JCSTUM@USNA JCSTBM@USNA /*
		Recreation services */ JCSRECM@USNA JCSREPM@USNA JCSREGM@USNA JCSRERM@USNA /*
		Food services and accommodations */ JCSFVM@USNA JCSCM@USNA /*
		Financial services and insurance */ JCSNFM@USNA JCSNIM@USNA /*
		Other services */ JCSLTPM@USNA JCSOEM@USNA JCSOPFM@USNA JCSPCM@USNA JCSSRM@USNA JCSLRM@USNA JCSVTM@USNA JCSVXM@USNA /*
		Nonprofit */ JNPCFM@USNA, tvar(time_month)
}
}

else if `level' == 2 {	
if `foodenergy' == 1 { 	
*2nd level disaggregation
import haver /*
       */ (CM CXFEM CGXFEM CSXEM JCM JCXFEM JCGXFEM JCSXEM)@USNA  (CSENT LR YPLTPMH)@USECON (IP CUT)@IP /*
	   Consumption Expenditures */ /* 
		New motor vehicles */ CDMNM@USNA CDMTNM@USNA /*
		Net purchases of used motor vehicles */ CDMUM@USNA CDMTUM@USNA /*
		Motor vehicle parts and accessories */ CDMTTM@USNA CDMTVM@USNA /*
		Furniture and furnishings */ CDFUM@USNA CDFOLM@USNA CDFOFM@USNA CDFOTM@USNA /*
		Household appliances */ CDFKKM@USNA CDFKSM@USNA /*
		Glassware, tableware, and houeshold utensils */ CDFGDM@USNA CDFGKM@USNA /*
		Tools and equipment for house and garden */ CDFSTM@USNA CDFSLM@USNA /*
		Video, audio, photographic, and information processing equipment and media */ CDRGDM@USNA CDOWPM@USNA CDRGIM@USNA /*
		Sporting equipment, supplies, guns, and ammunition */ CDRSM@USNA /*
		Sports and recreational vehicles */ CDOWLM@USNA CDOWBM@USNA CDBBM@USNA /*
		Recreational books */ CDRBM@USNA /*
		Musical instruments */ CDFTIM@USNA /*
		Jewelry and watches */ CDOJJM@USNA CDOJWM@USNA /*
		Therapeutic appliances and equipment */ CDOOTM@USNA CDOOEM@USNA /*
		Educational books */ CDEBM@USNA /*
		Luggage and similar personal items */ CDOLM@USNA /*
		Telephone and facsimile equipment */ CDOTM@USNA /*
		Garments */ CNLFFM@USNA CNLMFM@USNA CNLFIM@USNA /*
		Other clothing materials and footwear */ CNLOLM@USNA CNLXIM@USNA CNLSM@USNA /*
		Pharmaceutical and other products */ CNODRM@USNA CNODOM@USNA /*
		Recreational items */ CNOGTM@USNA CNRPM@USNA CNGARM@USNA CNOGFM@USNA /*
		Household supplies */ CNOLPM@USNA CNOLFM@USNA CNOLNM@USNA CNOLSM@USNA CNOLOM@USNA /*
		Personal care products */ CNOPPM@USNA CNOPCM@USNA CNOPEM@USNA /*
		Tobacco */ CNOTM@USNA /*
		Magazines, newspapers, and stationery */ CNMGM@USNA CNONM@USNA /*
		Net expenditures abroad by U.S. residents */ CNOVUM@USNA CNOVRM@USNA /*
		Housing */ CSHTM@USNA CSRDM@USNA CSHRM@USNA CSHOM@USNA /*
		Household utilities */ CSLSM@USNA CSEM@USNA /*
		Outpatient services */ CSMPM@USNA CSMDM@USNA CSMOM@USNA /*
		Hospital and nursing home services */ CSMHPM@USNA CSMHNM@USNA /*
		Motor vehicle services */ CSTURM@USNA CSTRLM@USNA /*
		Public transportation */ CSTIGM@USNA CSTIPM@USNA CSTIWM@USNA /*
		Membership clubs, sports centers, parks, theaters and museums */ CSRCCM@USNA CSRCPM@USNA CSRSM@USNA CSOSLM@USNA /*
		Audio-video, phographic, and information processing servicse */ CSROTM@USNA CSRODM@USNA CSROUM@USNA CSREEM@USNA CSROYM@USNA /*
		Gambling */ CSROGM@USNA CSROLM@USNA CSROBM@USNA /*
		Other recreational services */ CSROVM@USNA CSRKM@USNA CSREVM@USNA /*
		Food services */ CSFPM@USNA CSFEEM@USNA /*
		Accommodations */ CSHOTM@USNA CSHSM@USNA /*
		Financial services */ CSOBSM@USNA CSNFCM@USNA /*
		Insurance */ CSOBIM@USNA CSLIM@USNA CSMIM@USNA CSVIM@USNA /*
		Communication */ CSLTNM@USNA CSLPM@USNA CSRJIM@USNA /*
		Education services */ CSOEUM@USNA CSOEEM@USNA CSEOVM@USNA /*
		Professional and other services */ CSOBLM@USNA CSBOM@USNA CSBOUM@USNA CSBOPM@USNA CSOBFM@USNA /*
		Personal care and clothing services */ CSPPM@USNA CSOPLM@USNA /*
		Social services and religious activities */ CSSSCM@USNA CSSSWM@USNA CSSSVM@USNA CSSSRM@USNA CSSSFM@USNA /*
		Household maintenance */ CSLDM@USNA CSLOSM@USNA CSLORM@USNA CSLOPM@USNA CSLOOM@USNA /*
		Net foreign travel */ CSVTM@USNA CSVXM@USNA /*
		Nonprofit */ NPCFM@USNA /*
	Indeces */ /*
		New motor vehicles */ JCDMNM@USNA JCDMTNM@USNA /*
		Net purchases of used motor vehicles */ JCDMUM@USNA JCDMTUM@USNA /*
		Motor vehicle parts and accessories */ JCDMTTM@USNA JCDMTVM@USNA /*
		Furniture and furnishings */ JCDFUM@USNA JCDFOLM@USNA JCDFOFM@USNA JCDFOTM@USNA /*
		Household appliances */ JCDFKKM@USNA JCDFKSM@USNA /*
		Glassware, tableware, and houeshold utensils */ JCDFGDM@USNA JCDFGKM@USNA /*
		Tools and equipment for house and garden */ JCDFSTM@USNA JCDFSLM@USNA /*
		Video, audio, photographic, and information processing equipment and media */ JCDRGDM@USNA JCDOWPM@USNA JCDRGIM@USNA /*
		Sporting equipment, supplies, guns, and ammunition */ JCDRSM@USNA /*
		Sports and recreational vehicles */ JCDOWLM@USNA JCDOWBM@USNA JCDBBM@USNA /*
		Recreational books */ JCDRBM@USNA /*
		Musical instruments */ JCDFTIM@USNA /*
		Jewelry and watches */ JCDOJJM@USNA JCDOJWM@USNA /*
		Therapeutic appliances and equipment */ JCDOOTM@USNA JCDOOEM@USNA /*
		Educational books */ JCDEBM@USNA /*
		Luggage and similar personal items */ JCDOLM@USNA /*
		Telephone and facsimile equipment */ JCDOTM@USNA /*
		Garments */ JCNLFFM@USNA JCNLMFM@USNA JCNLFIM@USNA /*
		Other clothing materials and footwear */ JCNLOLM@USNA JCNLXIM@USNA JCNLSM@USNA /*
		Pharmaceutical and other products */ JCNODRM@USNA JCNODOM@USNA /*
		Recreational items */ JCNOGTM@USNA JCNRPM@USNA JCNGARM@USNA JCNOGFM@USNA /*
		Household supplies */ JCNOLPM@USNA JCNOLFM@USNA JCNOLNM@USNA JCNOLSM@USNA JCNOLOM@USNA /*
		Personal care products */ JCNOPPM@USNA JCNOPCM@USNA JCNOPEM@USNA /*
		Tobacco */ JCNOTM@USNA /*
		Magazines, newspapers, and stationery */ JCNMGM@USNA JCNONM@USNA /*
		Net expenditures abroad by U.S. residents */ JCNOVUM@USNA JCNOVRM@USNA /*
		Housing */ JCSHTM@USNA JCSRDM@USNA JCSHRM@USNA JCSHOM@USNA /*
		Household utilities */ JCSLSM@USNA JCSEM@USNA /*
		Outpatient services */ JCSMPM@USNA JCSMDM@USNA JCSMOM@USNA /*
		Hospital and nursing home services */ JCSMHPM@USNA JCSMHNM@USNA /*
		Motor vehicle services */ JCSTURM@USNA JCSTRLM@USNA /*
		Public transportation */ JCSTIGM@USNA JCSTIPM@USNA JCSTIWM@USNA /*
		Membership clubs, sports centers, parks, theaters and museums */ JCSRCCM@USNA JCSRCPM@USNA JCSRSM@USNA JCSOSLM@USNA /*
		Audio-video, phographic, and information processing servicse */ JCSROTM@USNA JCSRODM@USNA JCSROUM@USNA JCSREEM@USNA JCSROYM@USNA /*
		Gambling */ JCSROGM@USNA JCSROLM@USNA JCSROBM@USNA /*
		Other recreational services */ JCSROVM@USNA JCSRKM@USNA JCSREVM@USNA /*
		Food services */ JCSFPM@USNA JCSFEEM@USNA /*
		Accommodations */ JCSHOTM@USNA JCSHSM@USNA /*
		Financial services */ JCSOBSM@USNA JCSNFCM@USNA /*
		Insurance */ JCSOBIM@USNA JCSLIM@USNA JCSMIM@USNA JCSVIM@USNA /*
		Communication */ JCSLTNM@USNA JCSLPM@USNA JCSRJIM@USNA /*
		Education services */ JCSOEUM@USNA JCSOEEM@USNA JCSEOVM@USNA /*
		Professional and other services */ JCSOBLM@USNA JCSBOM@USNA JCSBOUM@USNA JCSBOPM@USNA JCSOBFM@USNA /*
		Personal care and clothing services */ JCSPPM@USNA JCSOPLM@USNA /*
		Social services and religious activities */ JCSSSCM@USNA JCSSSWM@USNA JCSSSVM@USNA JCSSSRM@USNA JCSSSFM@USNA /*
		Household maintenance */ JCSLDM@USNA JCSLOSM@USNA JCSLORM@USNA JCSLOPM@USNA JCSLOOM@USNA /*
		Net foreign travel */ JCSVTM@USNA JCSVXM@USNA /*
	    Nonprofit */ JNPCFM@USNA /*
	   Food and Energy */  /*
		Motor vehicle fuels, lubricants, and fluids */ CNLGOM@USNA CNLGLM@USNA /*
		Motor vehicle fuels, lubricants, and fluids */ JCNLGOM@USNA JCNLGLM@USNA  /*
		Fuel oil and other fuels */ JCNOFUM@USNA JCNOFLM@USNA  /*
		Fuel oil and other fuels */ CNOFUM@USNA CNOFLM@USNA  /*
		Food and nonalcoholic beverages */ JCNFOFM@USNA JCNFONM@USNA  /*
		Alcoholic beverages */ JCNFOLDM@USNA JCNFOLEM@USNA JCNFOLBM@USNA  /*
		Food produced and consumed on farms */ JCNFEFM@USNA  /*
	   	Food and nonalcoholic beverages */ CNFOFM@USNA CNFONM@USNA  /*
		Alcoholic beverages */ CNFOLDM@USNA CNFOLEM@USNA CNFOLBM@USNA  /*
		Food produced and consumed on farms */ CNFEFM@USNA , tvar(time_month)
}
else if `foodenergy' == 0 { 
import haver /*
      */  (CM CXFEM CGXFEM CSXEM JCM JCXFEM JCGXFEM JCSXEM)@USNA  (CSENT LR YPLTPMH)@USECON (IP CUT)@IP /*
	   Consumption Expenditures */ /* 
		New motor vehicles */ CDMNM@USNA CDMTNM@USNA /*
		Net purchases of used motor vehicles */ CDMUM@USNA CDMTUM@USNA /*
		Motor vehicle parts and accessories */ CDMTTM@USNA CDMTVM@USNA /*
		Furniture and furnishings */ CDFUM@USNA CDFOLM@USNA CDFOFM@USNA CDFOTM@USNA /*
		Household appliances */ CDFKKM@USNA CDFKSM@USNA /*
		Glassware, tableware, and houeshold utensils */ CDFGDM@USNA CDFGKM@USNA /*
		Tools and equipment for house and garden */ CDFSTM@USNA CDFSLM@USNA /*
		Video, audio, photographic, and information processing equipment and media */ CDRGDM@USNA CDOWPM@USNA CDRGIM@USNA /*
		Sporting equipment, supplies, guns, and ammunition */ CDRSM@USNA /*
		Sports and recreational vehicles */ CDOWLM@USNA CDOWBM@USNA CDBBM@USNA /*
		Recreational books */ CDRBM@USNA /*
		Musical instruments */ CDFTIM@USNA /*
		Jewelry and watches */ CDOJJM@USNA CDOJWM@USNA /*
		Therapeutic appliances and equipment */ CDOOTM@USNA CDOOEM@USNA /*
		Educational books */ CDEBM@USNA /*
		Luggage and similar personal items */ CDOLM@USNA /*
		Telephone and facsimile equipment */ CDOTM@USNA /*
		Garments */ CNLFFM@USNA CNLMFM@USNA CNLFIM@USNA /*
		Other clothing materials and footwear */ CNLOLM@USNA CNLXIM@USNA CNLSM@USNA /*
		Pharmaceutical and other products */ CNODRM@USNA CNODOM@USNA /*
		Recreational items */ CNOGTM@USNA CNRPM@USNA CNGARM@USNA CNOGFM@USNA /*
		Household supplies */ CNOLPM@USNA CNOLFM@USNA CNOLNM@USNA CNOLSM@USNA CNOLOM@USNA /*
		Personal care products */ CNOPPM@USNA CNOPCM@USNA CNOPEM@USNA /*
		Tobacco */ CNOTM@USNA /*
		Magazines, newspapers, and stationery */ CNMGM@USNA CNONM@USNA /*
		Net expenditures abroad by U.S. residents */ CNOVUM@USNA CNOVRM@USNA /*
		Housing */ CSHTM@USNA CSRDM@USNA CSHRM@USNA CSHOM@USNA /*
		Household utilities */  CSLWSM@USNA  CSLWRM@USNA /*
		Outpatient services */ CSMPM@USNA CSMDM@USNA CSMOM@USNA /*
		Hospital and nursing home services */ CSMHPM@USNA CSMHNM@USNA /*
		Motor vehicle services */ CSTURM@USNA CSTRLM@USNA /*
		Public transportation */ CSTIGM@USNA CSTIPM@USNA CSTIWM@USNA /*
		Membership clubs, sports centers, parks, theaters and museums */ CSRCCM@USNA CSRCPM@USNA CSRSM@USNA CSOSLM@USNA /*
		Audio-video, phographic, and information processing servicse */ CSROTM@USNA CSRODM@USNA CSROUM@USNA CSREEM@USNA CSROYM@USNA /*
		Gambling */ CSROGM@USNA CSROLM@USNA CSROBM@USNA /*
		Other recreational services */ CSROVM@USNA CSRKM@USNA CSREVM@USNA /*
		Food services */ CSFPM@USNA CSFEEM@USNA /*
		Accommodations */ CSHOTM@USNA CSHSM@USNA /*
		Financial services */ CSOBSM@USNA CSNFCM@USNA /*
		Insurance */ CSOBIM@USNA CSLIM@USNA CSMIM@USNA CSVIM@USNA /*
		Communication */ CSLTNM@USNA CSLPM@USNA CSRJIM@USNA /*
		Education services */ CSOEUM@USNA CSOEEM@USNA CSEOVM@USNA /*
		Professional and other services */ CSOBLM@USNA CSBOM@USNA CSBOUM@USNA CSBOPM@USNA CSOBFM@USNA /*
		Personal care and clothing services */ CSPPM@USNA CSOPLM@USNA /*
		Social services and religious activities */ CSSSCM@USNA CSSSWM@USNA CSSSVM@USNA CSSSRM@USNA CSSSFM@USNA /*
		Household maintenance */ CSLDM@USNA CSLOSM@USNA CSLORM@USNA CSLOPM@USNA CSLOOM@USNA /*
		Net foreign travel */ CSVTM@USNA CSVXM@USNA /*
		Nonprofit */ NPCFM@USNA /*
	Indeces */ /*
		New motor vehicles */ JCDMNM@USNA JCDMTNM@USNA /*
		Net purchases of used motor vehicles */ JCDMUM@USNA JCDMTUM@USNA /*
		Motor vehicle parts and accessories */ JCDMTTM@USNA JCDMTVM@USNA /*
		Furniture and furnishings */ JCDFUM@USNA JCDFOLM@USNA JCDFOFM@USNA JCDFOTM@USNA /*
		Household appliances */ JCDFKKM@USNA JCDFKSM@USNA /*
		Glassware, tableware, and houeshold utensils */ JCDFGDM@USNA JCDFGKM@USNA /*
		Tools and equipment for house and garden */ JCDFSTM@USNA JCDFSLM@USNA /*
		Video, audio, photographic, and information processing equipment and media */ JCDRGDM@USNA JCDOWPM@USNA JCDRGIM@USNA /*
		Sporting equipment, supplies, guns, and ammunition */ JCDRSM@USNA /*
		Sports and recreational vehicles */ JCDOWLM@USNA JCDOWBM@USNA JCDBBM@USNA /*
		Recreational books */ JCDRBM@USNA /*
		Musical instruments */ JCDFTIM@USNA /*
		Jewelry and watches */ JCDOJJM@USNA JCDOJWM@USNA /*
		Therapeutic appliances and equipment */ JCDOOTM@USNA JCDOOEM@USNA /*
		Educational books */ JCDEBM@USNA /*
		Luggage and similar personal items */ JCDOLM@USNA /*
		Telephone and facsimile equipment */ JCDOTM@USNA /*
		Garments */ JCNLFFM@USNA JCNLMFM@USNA JCNLFIM@USNA /*
		Other clothing materials and footwear */ JCNLOLM@USNA JCNLXIM@USNA JCNLSM@USNA /*
		Pharmaceutical and other products */ JCNODRM@USNA JCNODOM@USNA /*
		Recreational items */ JCNOGTM@USNA JCNRPM@USNA JCNGARM@USNA JCNOGFM@USNA /*
		Household supplies */ JCNOLPM@USNA JCNOLFM@USNA JCNOLNM@USNA JCNOLSM@USNA JCNOLOM@USNA /*
		Personal care products */ JCNOPPM@USNA JCNOPCM@USNA JCNOPEM@USNA /*
		Tobacco */ JCNOTM@USNA /*
		Magazines, newspapers, and stationery */ JCNMGM@USNA JCNONM@USNA /*
		Net expenditures abroad by U.S. residents */ JCNOVUM@USNA JCNOVRM@USNA /*
		Housing */ JCSHTM@USNA JCSRDM@USNA JCSHRM@USNA JCSHOM@USNA /*
		Household utilities  */ JCSLWSM@USNA JCSLWRM@USNA /*
		Outpatient services */ JCSMPM@USNA JCSMDM@USNA JCSMOM@USNA /*
		Hospital and nursing home services */ JCSMHPM@USNA JCSMHNM@USNA /*
		Motor vehicle services */ JCSTURM@USNA JCSTRLM@USNA /*
		Public transportation */ JCSTIGM@USNA JCSTIPM@USNA JCSTIWM@USNA /*
		Membership clubs, sports centers, parks, theaters and museums */ JCSRCCM@USNA JCSRCPM@USNA JCSRSM@USNA JCSOSLM@USNA /*
		Audio-video, phographic, and information processing servicse */ JCSROTM@USNA JCSRODM@USNA JCSROUM@USNA JCSREEM@USNA JCSROYM@USNA /*
		Gambling */ JCSROGM@USNA JCSROLM@USNA JCSROBM@USNA /*
		Other recreational services */ JCSROVM@USNA JCSRKM@USNA JCSREVM@USNA /*
		Food services */ JCSFPM@USNA JCSFEEM@USNA /*
		Accommodations */ JCSHOTM@USNA JCSHSM@USNA /*
		Financial services */ JCSOBSM@USNA JCSNFCM@USNA /*
		Insurance */ JCSOBIM@USNA JCSLIM@USNA JCSMIM@USNA JCSVIM@USNA /*
		Communication */ JCSLTNM@USNA JCSLPM@USNA JCSRJIM@USNA /*
		Education services */ JCSOEUM@USNA JCSOEEM@USNA JCSEOVM@USNA /*
		Professional and other services */ JCSOBLM@USNA JCSBOM@USNA JCSBOUM@USNA JCSBOPM@USNA JCSOBFM@USNA /*
		Personal care and clothing services */ JCSPPM@USNA JCSOPLM@USNA /*
		Social services and religious activities */ JCSSSCM@USNA JCSSSWM@USNA JCSSSVM@USNA JCSSSRM@USNA JCSSSFM@USNA /*
		Household maintenance */ JCSLDM@USNA JCSLOSM@USNA JCSLORM@USNA JCSLOPM@USNA JCSLOOM@USNA /*
		Net foreign travel */ JCSVTM@USNA JCSVXM@USNA /*
        Nonprofit */ JNPCFM@USNA, tvar(time_month) 
		}
}	

else if `level' == 3 {
if `foodenergy' == 1 { 	
*3rd level disaggregation
import haver /* 
     */(CM CXFEM JCM JCXFEM)@USNA  (CSENT LR YPLTPMH)@USECON (IP CUT)@IP /*
	  Consumption Expenditures */ /*
		New autos */ CDMNDM@USNA CDMNFM@USNA /*
		New light trucks */ CDMTNM@USNA /*
		Used autos */ CDMUNM@USNA CDMUGM@USNA CDMURM@USNA /*
		Used light trucks */ CDMTUNM@USNA CDMTUGM@USNA /*
		Motor vehicle parts and accessories */ CDMTTM@USNA CDMTVM@USNA /*
		Furniture and furnishings */ CDFUM@USNA CDFOLM@USNA CDFOFM@USNA CDFOTM@USNA /*
		Household appliances */ CDFKKM@USNA CDFKSM@USNA /*
		Glassware, tableware, and houeshold utensils */ CDFGDM@USNA CDFGKM@USNA /*
		Tools and equipment for house and garden */ CDFSTM@USNA CDFSLM@USNA /*
		Video and qudio equipment */ CDFTVM@USNA CDFTOM@USNA CDFTUM@USNA CDFTRM@USNA /*
		Photographic equipment */ CDOWPM@USNA /*
		Information processing equipment */ CDFCPM@USNA CDFCSM@USNA CDFCOM@USNA /*
		Sporting equipment, supplies, guns, and ammunition */ CDRSM@USNA /*
		Motorcycles */ CDOWLM@USNA /*
		Bicycles and accessories */ CDOWBM@USNA /*
		Pleasure boats, aircraft, and other recreational vehicles */ CDBBBM@USNA CDBBPM@USNA CDBBOM@USNA /*
		Recreational books */ CDRBM@USNA /*
		Musical instruments */ CDFTIM@USNA /*
		Jewelry and watches */ CDOJJM@USNA CDOJWM@USNA /*
		Therapeutic appliances and equipment */ CDOOTM@USNA CDOOEM@USNA /*
		Educational books */ CDEBM@USNA /*
		Luggage and similar personal items */ CDOLM@USNA /*
		Telephone and facsimile equipment */ CDOTM@USNA /*
		Garments */ CNLFFM@USNA CNLMFM@USNA CNLFIM@USNA /*
		Other clothing materials and footwear */ CNLOLM@USNA CNLXIM@USNA CNLSM@USNA /*
		Pharmaceutical products */ CNODPM@USNA CNODNM@USNA /*
		Other medical products */ CNODOM@USNA /*
		Recreational items */ CNOGTM@USNA CNRPM@USNA CNGARM@USNA CNOGFM@USNA /*
		Household supplies */ CNOLPM@USNA CNOLFM@USNA CNOLNM@USNA CNOLSM@USNA CNOLOM@USNA /*
		Personal care products */ CNOPPM@USNA CNOPCM@USNA CNOPEM@USNA /*
		Tobacco */ CNOTM@USNA /*
		Magazines, newspapers, and stationery */ CNMGM@USNA CNONM@USNA /*
		Expenditures abroad by U.S. residents */ CNOVGM@USNA CNOVNM@USNA /*
		Less: Personal remittances in kind to nonresidents */ CNOVRM@USNA /*
		Rental of tenant-occupied nonfarm housing */ CSHTBM@USNA CSHTSM@USNA CSHTDM@USNA /*
		Imputed rental of owner-occupied nonfarm housing */ CSHRBM@USNA CSHRSM@USNA /*
		Rental value of farm dwellings */ CSHRM@USNA  /*
		Group housing */ CSHOM@USNA /*
		Water supply and sanitation */ CSLWSM@USNA CSLWRM@USNA /*
		Physician services */ CSMPM@USNA /*
		Dental services */ CSMDM@USNA /*
		Paramedical services */ CSMOAM@USNA CSMOLM@USNA CSMOOM@USNA /*
		Hospitals */ CSMPNM@USNA CSMPPM@USNA CSMPGM@USNA /*
		Nursing homes */ CSMNNM@USNA CSMNPM@USNA /*
		Motor vehicle maintenance and repair */ CSTURM@USNA /*
		Other motor vehicle services */ CSTVLM@USNA CSTVRM@USNA CSTUTM@USNA /*
		Ground transportation */ CSTIRM@USNA CSTIDM@USNA /*
		Air transportation */ CSTIPM@USNA /*
		Water transportation */ CSTIWM@USNA /*
		Membership clubs and participant sports centers */ CSRCCM@USNA /*
		Amusement parks, campgrounds, and related recreational services */ CSRCPM@USNA /*
		Admissions to specified spectator amusements */ CSRSPM@USNA CSRSTM@USNA CSRSSM@USNA /*
		Museums and libraries */ CSOSLM@USNA /*
		Audio-video, phographic, and information processing servicse */ CSROTM@USNA CSRODM@USNA CSROUM@USNA CSREEM@USNA CSROYM@USNA /*
		Gambling */ CSROGM@USNA CSROLM@USNA CSROBM@USNA /*
		Other recreational services */ CSROVM@USNA CSRKM@USNA CSREVM@USNA /*
		Purchased meals and beverages */ CSPFM@USNA CSFPBM@USNA /*
		Food furnished to employees */ CSFEVM@USNA CSFEAM@USNA /*
		Hotels and motels */ CSHOTM@USNA /*
		Housing at schools */ CSHSM@USNA /*
		Financial services furnished without payment */ CSBSCM@USNA CSOBDM@USNA CSOBPM@USNA /*
		Financial service charges, fees, and commissions */ CSNFVM@USNA CSNFSM@USNA CSNFPM@USNA CSNFTM@USNA /*
		Life insurance */ CSOBIM@USNA /*
		Net household insurance */ CSLOHM@USNA CSLOBM@USNA /*
		Net health insurance */ CSMHIM@USNA CSMIIM@USNA CSMISM@USNA /*
		Net motor vehicle and other transportation insurance */ CSVIM@USNA /*
		Telecommunication services */ CSLTLM@USNA CSLTDM@USNA CSLTCM@USNA /*
		Postal and delivery services */ CSLPFM@USNA CSLPOM@USNA /*
		Internet access */ CSRJIM@USNA /*
		Higher education */ CSOEUPM@USNA CSOEUNM@USNA /*
		Nursery, elementary, and secondary schools */ CSEESM@USNA CSEENM@USNA /*
		Commercial and vocational schools */ CSEOVM@USNA /*
		Legal services */ CSOBLM@USNA /*
		Accounting and other business services */ CSBOTM@USNA CSBOEM@USNA CSBOOM@USNA /*
		Labor organization dues */ CSBOUM@USNA /*
		Professional association dues */ CSBOPM@USNA /*
		Funeral and burial services */ CSOBFM@USNA /*
		Personal care services */ CSOPBM@USNA CSOPOM@USNA /* 
		Clothing and footwear services */ CSOPDM@USNA CSOPRM@USNA CSOPSM@USNA /*
		Child care */ CSSSCM@USNA /*
		Social assistance */ CSSWEM@USNA CSSWRM@USNA CSSWIM@USNA CSSWVM@USNA CSSWCM@USNA CSSWOM@USNA /*
		Social advocacy */ CSSSVM@USNA /*
		Religious organizations' services to households */ CSSSRM@USNA /*
		Foundations and grantmaking */ CSSSFM@USNA /*
		Household maintenance */ CSLDM@USNA CSLOSM@USNA CSLORM@USNA CSLOPM@USNA CSLOOM@USNA /*
		Net foreign travel */ CSVTM@USNA CSVXM@USNA /*
		Nonprofit */ NPCFM@USNA /*

	Indeces */ /*
		New autos */ JCDMNDM@USNA JCDMNFM@USNA /*
		New light trucks */ JCDMTNM@USNA /*
		Used autos */ JCDMUNM@USNA JCDMUGM@USNA JCDMURM@USNA /*
		Used light trucks */ JCDMTUNM@USNA JCDMTUGM@USNA /*
		Motor vehicle parts and accessories */ JCDMTTM@USNA JCDMTVM@USNA /*
		Furniture and furnishings */ JCDFUM@USNA JCDFOLM@USNA JCDFOFM@USNA JCDFOTM@USNA /*
		Household appliances */ JCDFKKM@USNA JCDFKSM@USNA /*
		Glassware, tableware, and houeshold utensils */ JCDFGDM@USNA JCDFGKM@USNA /*
		Tools and equipment for house and garden */ JCDFSTM@USNA JCDFSLM@USNA /*
		Video and qudio equipment */ JCDFTVM@USNA JCDFTOM@USNA JCDFTUM@USNA JCDFTRM@USNA /*
		Photographic equipment */ JCDOWPM@USNA /*
		Information processing equipment */ JCDFCPM@USNA JCDFCSM@USNA CDFCOM@USNA /*
		Sporting equipment, supplies, guns, and ammunition */ JCDRSM@USNA /*
		Motorcycles */ JCDOWLM@USNA /*
		Bicycles and accessories */ JCDOWBM@USNA /*
		Pleasure boats, aircraft, and other recreational vehicles */ JCDBBBM@USNA JCDBBPM@USNA JCDBBOM@USNA /*
		Recreational books */ JCDRBM@USNA /*
		Musical instruments */ JCDFTIM@USNA /*
		Jewelry and watches */ JCDOJJM@USNA JCDOJWM@USNA /*
		Therapeutic appliances and equipment */ JCDOOTM@USNA JCDOOEM@USNA /*
		Educational books */ JCDEBM@USNA /*
		Luggage and similar personal items */ JCDOLM@USNA /*
		Telephone and facsimile equipment */ JCDOTM@USNA /*
		Garments */ JCNLFFM@USNA JCNLMFM@USNA JCNLFIM@USNA /*
		Other clothing materials and footwear */ JCNLOLM@USNA JCNLXIM@USNA JCNLSM@USNA /*
		Pharmaceutical products */ JCNODPM@USNA JCNODNM@USNA /*
		Other medical products */ JCNODOM@USNA /*
		Recreational items */ JCNOGTM@USNA JCNRPM@USNA JCNGARM@USNA JCNOGFM@USNA /*
		Household supplies */ JCNOLPM@USNA JCNOLFM@USNA JCNOLNM@USNA JCNOLSM@USNA JCNOLOM@USNA /*
		Personal care products */ JCNOPPM@USNA JCNOPCM@USNA JCNOPEM@USNA /*
		Tobacco */ JCNOTM@USNA /*
		Magazines, newspapers, and stationery */ JCNMGM@USNA JCNONM@USNA /*
		Expenditures abroad by U.S. residents */ JCNOVGM@USNA JCNOVNM@USNA /*
		Less: Personal remittances in kind to nonresidents */ JCNOVRM@USNA /*
		Rental of tenant-occupied nonfarm housing */ JCSHTBM@USNA JCSHTSM@USNA JCSHTDM@USNA /*
		Imputed rental of owner-occupied nonfarm housing */ JCSHRBM@USNA JCSHRSM@USNA /*
		Rental value of farm dwellings */ JCSHRM@USNA  /*
		Group housing */ JCSHOM@USNA /*
		Water supply and sanitation */ JCSLWSM@USNA JCSLWRM@USNA /*
	
		Physician services */ JCSMPM@USNA /*
		Dental services */ JCSMDM@USNA /*
		Paramedical services */ JCSMOAM@USNA JCSMOLM@USNA JCSMOOM@USNA /*
		Hospitals */ JCSMPNM@USNA JCSMPPM@USNA JCSMPGM@USNA /*
		Nursing homes */ JCSMNNM@USNA JCSMNPM@USNA /*
		Motor vehicle maintenance and repair */ JCSTURM@USNA /*
		Other motor vehicle services */ JCSTVLM@USNA JCSTVRM@USNA JCSTUTM@USNA /*
		Ground transportation */ JCSTIRM@USNA JCSTIDM@USNA /*
		Air transportation */ JCSTIPM@USNA /*
		Water transportation */ JCSTIWM@USNA /*
		Membership clubs and participant sports centers */ JCSRCCM@USNA /*
		Amusement parks, campgrounds, and related recreational services */ JCSRCPM@USNA /*
		Admissions to specified spectator amusements */ JCSRSPM@USNA JCSRSTM@USNA JCSRSSM@USNA /*
		Museums and libraries */ JCSOSLM@USNA /*
		Audio-video, phographic, and information processing servicse */ JCSROTM@USNA JCSRODM@USNA JCSROUM@USNA JCSREEM@USNA JCSROYM@USNA /*
		Gambling */ JCSROGM@USNA JCSROLM@USNA JCSROBM@USNA /*
		Other recreational services */ JCSROVM@USNA JCSRKM@USNA JCSREVM@USNA /*
		Purchased meals and beverages */ JCSPFM@USNA JCSFPBM@USNA /*
		Food furnished to employees */ JCSFEVM@USNA JCSFEAM@USNA /*
		Hotels and motels */ JCSHOTM@USNA /*
		Housing at schools */ JCSHSM@USNA /*
		Financial services furnished without payment */ JCSBSCM@USNA JCSOBDM@USNA JCSOBPM@USNA /*
		Financial service charges, fees, and commissions */ JCSNFVM@USNA JCSNFSM@USNA JCSNFPM@USNA JCSNFTM@USNA /*
		Life insurance */ JCSOBIM@USNA /*
		Net household insurance */ JCSLOHM@USNA JCSLOBM@USNA /*
		Net health insurance */ JCSMHIM@USNA JCSMIIM@USNA JCSMISM@USNA /*
		Net motor vehicle and other transportation insurance */ JCSVIM@USNA /*
		Telecommunication services */ JCSLTLM@USNA JCSLTDM@USNA JCSLTCM@USNA /*
		Postal and delivery services */ JCSLPFM@USNA JCSLPOM@USNA /*
		Internet access */ JCSRJIM@USNA /*
		Higher education */ JCSOEUPM@USNA JCSOEUNM@USNA /*
		Nursery, elementary, and secondary schools */ JCSEESM@USNA JCSEENM@USNA /*
		Commercial and vocational schools */ JCSEOVM@USNA /*
		Legal services */ JCSOBLM@USNA /*
		Accounting and other business services */ JCSBOTM@USNA JCSBOEM@USNA JCSBOOM@USNA /*
		Labor organization dues */ JCSBOUM@USNA /*
		Professional association dues */ JCSBOPM@USNA /*
		Funeral and burial services */ JCSOBFM@USNA /*
		Personal care services */ JCSOPBM@USNA JCSOPOM@USNA /* 
		Clothing and footwear services */ JCSOPDM@USNA JCSOPRM@USNA JCSOPSM@USNA /*
		Child care */ JCSSSCM@USNA /*
		Social assistance */ JCSSWEM@USNA JCSSWRM@USNA JCSSWIM@USNA JCSSWVM@USNA JCSSWCM@USNA JCSSWOM@USNA /*
		Social advocacy */ JCSSSVM@USNA /*
		Religious organizations' services to households */ JCSSSRM@USNA /*
		Foundations and grantmaking */ JCSSSFM@USNA /*
		Household maintenance */ JCSLDM@USNA JCSLOSM@USNA JCSLORM@USNA JCSLOPM@USNA JCSLOOM@USNA /*
	    Net foreign travel */ CSVTM@USNA CSVXM@USNA /*
		Nonprofit */ JNPCFM@USNA /*
	 Food and Energy*//*
	 	Electricity and gas */ CSLEM@USNA CSLGM@USNA /*
		Electricity and gas */ JCSLEM@USNA JCSLGM@USNA /*
		Motor vehicle fuels, lubricants, and fluids */ CNLGOM@USNA CNLGLM@USNA /*
		Fuel oil and other fuels */ CNOFUM@USNA CNOFLM@USNA /*
		Motor vehicle fuels, lubricants, and fluids */ JCNLGOM@USNA JCNLGLM@USNA /*
		Fuel oil and other fuels */ JCNOFUM@USNA JCNOFLM@USNA /*
		Food purchased for off-premises consumption */ CNFOCM@USNA CNFOPM@USNA CNFOFLM@USNA CNFODM@USNA CNFOFWM@USNA CNFOVM@USNA CNFOFTM@USNA CNFOFSM@USNA CNFOFOM@USNA /*
		Nonalcoholic beverages purchased for off-premises consumption */ CNFOFCM@USNA CNFOFNM@USNA /*
		Alcoholic beverages */ CNFOLDM@USNA CNFOLEM@USNA CNFOLBM@USNA /*
		Food produced and consumed on farms */ CNFEFM@USNA   /*
		Food purchased for off-premises consumption */ JCNFOCM@USNA JCNFOPM@USNA JCNFOFLM@USNA JCNFODM@USNA JCNFOFWM@USNA JCNFOVM@USNA JCNFOFTM@USNA JCNFOFSM@USNA JCNFOFOM@USNA /*
		Nonalcoholic beverages purchased for off-premises consumption */ JCNFOFCM@USNA JCNFOFNM@USNA /*
		Alcoholic beverages */ JCNFOLDM@USNA JCNFOLEM@USNA JCNFOLBM@USNA /*
		Food produced and consumed on farms */ JCNFEFM@USNA, tvar(time_month)
		}	
else if `foodenergy' == 0 { 
import haver /* 
     */(CM CXFEM JCM JCXFEM)@USNA  (CSENT LR YPLTPMH)@USECON (IP CUT)@IP /*
	 Consumption Expenditures */ /*
		New autos */ CDMNDM@USNA CDMNFM@USNA /*
		New light trucks */ CDMTNM@USNA /*
		Used autos */ CDMUNM@USNA CDMUGM@USNA CDMURM@USNA /*
		Used light trucks */ CDMTUNM@USNA CDMTUGM@USNA /*
		Motor vehicle parts and accessories */ CDMTTM@USNA CDMTVM@USNA /*
		Furniture and furnishings */ CDFUM@USNA CDFOLM@USNA CDFOFM@USNA CDFOTM@USNA /*
		Household appliances */ CDFKKM@USNA CDFKSM@USNA /*
		Glassware, tableware, and houeshold utensils */ CDFGDM@USNA CDFGKM@USNA /*
		Tools and equipment for house and garden */ CDFSTM@USNA CDFSLM@USNA /*
		Video and qudio equipment */ CDFTVM@USNA CDFTOM@USNA CDFTUM@USNA CDFTRM@USNA /*
		Photographic equipment */ CDOWPM@USNA /*
		Information processing equipment */ CDFCPM@USNA CDFCSM@USNA CDFCOM@USNA /*
		Sporting equipment, supplies, guns, and ammunition */ CDRSM@USNA /*
		Motorcycles */ CDOWLM@USNA /*
		Bicycles and accessories */ CDOWBM@USNA /*
		Pleasure boats, aircraft, and other recreational vehicles */ CDBBBM@USNA CDBBPM@USNA CDBBOM@USNA /*
		Recreational books */ CDRBM@USNA /*
		Musical instruments */ CDFTIM@USNA /*
		Jewelry and watches */ CDOJJM@USNA CDOJWM@USNA /*
		Therapeutic appliances and equipment */ CDOOTM@USNA CDOOEM@USNA /*
		Educational books */ CDEBM@USNA /*
		Luggage and similar personal items */ CDOLM@USNA /*
		Telephone and facsimile equipment */ CDOTM@USNA /*
		Garments */ CNLFFM@USNA CNLMFM@USNA CNLFIM@USNA /*
		Other clothing materials and footwear */ CNLOLM@USNA CNLXIM@USNA CNLSM@USNA /*
		Pharmaceutical products */ CNODPM@USNA CNODNM@USNA /*
		Other medical products */ CNODOM@USNA /*
		Recreational items */ CNOGTM@USNA CNRPM@USNA CNGARM@USNA CNOGFM@USNA /*
		Household supplies */ CNOLPM@USNA CNOLFM@USNA CNOLNM@USNA CNOLSM@USNA CNOLOM@USNA /*
		Personal care products */ CNOPPM@USNA CNOPCM@USNA CNOPEM@USNA /*
		Tobacco */ CNOTM@USNA /*
		Magazines, newspapers, and stationery */ CNMGM@USNA CNONM@USNA /*
		Expenditures abroad by U.S. residents */ CNOVGM@USNA CNOVNM@USNA /*
		Less: Personal remittances in kind to nonresidents */ CNOVRM@USNA /*
		Rental of tenant-occupied nonfarm housing */ CSHTBM@USNA CSHTSM@USNA CSHTDM@USNA /*
		Imputed rental of owner-occupied nonfarm housing */ CSHRBM@USNA CSHRSM@USNA /*
		Rental value of farm dwellings */ CSHRM@USNA  /*
		Group housing */ CSHOM@USNA /*
		Water supply and sanitation */ CSLWSM@USNA CSLWRM@USNA /*
		Physician services */ CSMPM@USNA /*
		Dental services */ CSMDM@USNA /*
		Paramedical services */ CSMOAM@USNA CSMOLM@USNA CSMOOM@USNA /*
		Hospitals */ CSMPNM@USNA CSMPPM@USNA CSMPGM@USNA /*
		Nursing homes */ CSMNNM@USNA CSMNPM@USNA /*
		Motor vehicle maintenance and repair */ CSTURM@USNA /*
		Other motor vehicle services */ CSTVLM@USNA CSTVRM@USNA CSTUTM@USNA /*
		Ground transportation */ CSTIRM@USNA CSTIDM@USNA /*
		Air transportation */ CSTIPM@USNA /*
		Water transportation */ CSTIWM@USNA /*
		Membership clubs and participant sports centers */ CSRCCM@USNA /*
		Amusement parks, campgrounds, and related recreational services */ CSRCPM@USNA /*
		Admissions to specified spectator amusements */ CSRSPM@USNA CSRSTM@USNA CSRSSM@USNA /*
		Museums and libraries */ CSOSLM@USNA /*
		Audio-video, phographic, and information processing servicse */ CSROTM@USNA CSRODM@USNA CSROUM@USNA CSREEM@USNA CSROYM@USNA /*
		Gambling */ CSROGM@USNA CSROLM@USNA CSROBM@USNA /*
		Other recreational services */ CSROVM@USNA CSRKM@USNA CSREVM@USNA /*
		Purchased meals and beverages */ CSPFM@USNA CSFPBM@USNA /*
		Food furnished to employees */ CSFEVM@USNA CSFEAM@USNA /*
		Hotels and motels */ CSHOTM@USNA /*
		Housing at schools */ CSHSM@USNA /*
		Financial services furnished without payment */ CSBSCM@USNA CSOBDM@USNA CSOBPM@USNA /*
		Financial service charges, fees, and commissions */ CSNFVM@USNA CSNFSM@USNA CSNFPM@USNA CSNFTM@USNA /*
		Life insurance */ CSOBIM@USNA /*
		Net household insurance */ CSLOHM@USNA CSLOBM@USNA /*
		Net health insurance */ CSMHIM@USNA CSMIIM@USNA CSMISM@USNA /*
		Net motor vehicle and other transportation insurance */ CSVIM@USNA /*
		Telecommunication services */ CSLTLM@USNA CSLTDM@USNA CSLTCM@USNA /*
		Postal and delivery services */ CSLPFM@USNA CSLPOM@USNA /*
		Internet access */ CSRJIM@USNA /*
		Higher education */ CSOEUPM@USNA CSOEUNM@USNA /*
		Nursery, elementary, and secondary schools */ CSEESM@USNA CSEENM@USNA /*
		Commercial and vocational schools */ CSEOVM@USNA /*
		Legal services */ CSOBLM@USNA /*
		Accounting and other business services */ CSBOTM@USNA CSBOEM@USNA CSBOOM@USNA /*
		Labor organization dues */ CSBOUM@USNA /*
		Professional association dues */ CSBOPM@USNA /*
		Funeral and burial services */ CSOBFM@USNA /*
		Personal care services */ CSOPBM@USNA CSOPOM@USNA /* 
		Clothing and footwear services */ CSOPDM@USNA CSOPRM@USNA CSOPSM@USNA /*
		Child care */ CSSSCM@USNA /*
		Social assistance */ CSSWEM@USNA CSSWRM@USNA CSSWIM@USNA CSSWVM@USNA CSSWCM@USNA CSSWOM@USNA /*
		Social advocacy */ CSSSVM@USNA /*
		Religious organizations' services to households */ CSSSRM@USNA /*
		Foundations and grantmaking */ CSSSFM@USNA /*
		Household maintenance */ CSLDM@USNA CSLOSM@USNA CSLORM@USNA CSLOPM@USNA CSLOOM@USNA /*
		Foreign travel by U.S. residents */ CSFTPM@USNA CSFTOM@USNA CSFTSM@USNA /*
		Less: Expenditures in the United States by nonresidents */ CSDTFM@USNA CSDTEM@USNA CSDTSM@USNA /*
		Nonprofit */ NPCFM@USNA /*
	Indeces */ /*
		New autos */ JCDMNDM@USNA JCDMNFM@USNA /*
		New light trucks */ JCDMTNM@USNA /*
		Used autos */ JCDMUNM@USNA JCDMUGM@USNA JCDMURM@USNA /*
		Used light trucks */ JCDMTUNM@USNA JCDMTUGM@USNA /*
		Motor vehicle parts and accessories */ JCDMTTM@USNA JCDMTVM@USNA /*
		Furniture and furnishings */ JCDFUM@USNA JCDFOLM@USNA JCDFOFM@USNA JCDFOTM@USNA /*
		Household appliances */ JCDFKKM@USNA JCDFKSM@USNA /*
		Glassware, tableware, and houeshold utensils */ JCDFGDM@USNA JCDFGKM@USNA /*
		Tools and equipment for house and garden */ JCDFSTM@USNA JCDFSLM@USNA /*
		Video and qudio equipment */ JCDFTVM@USNA JCDFTOM@USNA JCDFTUM@USNA JCDFTRM@USNA /*
		Photographic equipment */ JCDOWPM@USNA /*
		Information processing equipment */ JCDFCPM@USNA JCDFCSM@USNA CDFCOM@USNA /*
		Sporting equipment, supplies, guns, and ammunition */ JCDRSM@USNA /*
		Motorcycles */ JCDOWLM@USNA /*
		Bicycles and accessories */ JCDOWBM@USNA /*
		Pleasure boats, aircraft, and other recreational vehicles */ JCDBBBM@USNA JCDBBPM@USNA JCDBBOM@USNA /*
		Recreational books */ JCDRBM@USNA /*
		Musical instruments */ JCDFTIM@USNA /*
		Jewelry and watches */ JCDOJJM@USNA JCDOJWM@USNA /*
		Therapeutic appliances and equipment */ JCDOOTM@USNA JCDOOEM@USNA /*
		Educational books */ JCDEBM@USNA /*
		Luggage and similar personal items */ JCDOLM@USNA /*
		Telephone and facsimile equipment */ JCDOTM@USNA /*
		Garments */ JCNLFFM@USNA JCNLMFM@USNA JCNLFIM@USNA /*
		Other clothing materials and footwear */ JCNLOLM@USNA JCNLXIM@USNA JCNLSM@USNA /*
		Pharmaceutical products */ JCNODPM@USNA JCNODNM@USNA /*
		Other medical products */ JCNODOM@USNA /*
		Recreational items */ JCNOGTM@USNA JCNRPM@USNA JCNGARM@USNA JCNOGFM@USNA /*
		Household supplies */ JCNOLPM@USNA JCNOLFM@USNA JCNOLNM@USNA JCNOLSM@USNA JCNOLOM@USNA /*
		Personal care products */ JCNOPPM@USNA JCNOPCM@USNA JCNOPEM@USNA /*
		Tobacco */ JCNOTM@USNA /*
		Magazines, newspapers, and stationery */ JCNMGM@USNA JCNONM@USNA /*
		Expenditures abroad by U.S. residents */ JCNOVGM@USNA JCNOVNM@USNA /*
		Less: Personal remittances in kind to nonresidents */ JCNOVRM@USNA /*
		Rental of tenant-occupied nonfarm housing */ JCSHTBM@USNA JCSHTSM@USNA JCSHTDM@USNA /*
		Imputed rental of owner-occupied nonfarm housing */ JCSHRBM@USNA JCSHRSM@USNA /*
		Rental value of farm dwellings */ JCSHRM@USNA  /*
		Group housing */ JCSHOM@USNA /*
		Water supply and sanitation  */ JCSLWSM@USNA JCSLWRM@USNA /*
		Physician services */ JCSMPM@USNA /*
		Dental services */ JCSMDM@USNA /*
		Paramedical services */ JCSMOAM@USNA JCSMOLM@USNA JCSMOOM@USNA /*
		Hospitals */ JCSMPNM@USNA JCSMPPM@USNA JCSMPGM@USNA /*
		Nursing homes */ JCSMNNM@USNA JCSMNPM@USNA /*
		Motor vehicle maintenance and repair */ JCSTURM@USNA /*
		Other motor vehicle services */ JCSTVLM@USNA JCSTVRM@USNA JCSTUTM@USNA /*
		Ground transportation */ JCSTIRM@USNA JCSTIDM@USNA /*
		Air transportation */ JCSTIPM@USNA /*
		Water transportation */ JCSTIWM@USNA /*
		Membership clubs and participant sports centers */ JCSRCCM@USNA /*
		Amusement parks, campgrounds, and related recreational services */ JCSRCPM@USNA /*
		Admissions to specified spectator amusements */ JCSRSPM@USNA JCSRSTM@USNA JCSRSSM@USNA /*
		Museums and libraries */ JCSOSLM@USNA /*
		Audio-video, phographic, and information processing servicse */ JCSROTM@USNA JCSRODM@USNA JCSROUM@USNA JCSREEM@USNA JCSROYM@USNA /*
		Gambling */ JCSROGM@USNA JCSROLM@USNA JCSROBM@USNA /*
		Other recreational services */ JCSROVM@USNA JCSRKM@USNA JCSREVM@USNA /*
		Purchased meals and beverages */ JCSPFM@USNA JCSFPBM@USNA /*
		Food furnished to employees */ JCSFEVM@USNA JCSFEAM@USNA /*
		Hotels and motels */ JCSHOTM@USNA /*
		Housing at schools */ JCSHSM@USNA /*
		Financial services furnished without payment */ JCSBSCM@USNA JCSOBDM@USNA JCSOBPM@USNA /*
		Financial service charges, fees, and commissions */ JCSNFVM@USNA JCSNFSM@USNA JCSNFPM@USNA JCSNFTM@USNA /*
		Life insurance */ JCSOBIM@USNA /*
		Net household insurance */ JCSLOHM@USNA JCSLOBM@USNA /*
		Net health insurance */ JCSMHIM@USNA JCSMIIM@USNA JCSMISM@USNA /*
		Net motor vehicle and other transportation insurance */ JCSVIM@USNA /*
		Telecommunication services */ JCSLTLM@USNA JCSLTDM@USNA JCSLTCM@USNA /*
		Postal and delivery services */ JCSLPFM@USNA JCSLPOM@USNA /*
		Internet access */ JCSRJIM@USNA /*
		Higher education */ JCSOEUPM@USNA JCSOEUNM@USNA /*
		Nursery, elementary, and secondary schools */ JCSEESM@USNA JCSEENM@USNA /*
		Commercial and vocational schools */ JCSEOVM@USNA /*
		Legal services */ JCSOBLM@USNA /*
		Accounting and other business services */ JCSBOTM@USNA JCSBOEM@USNA JCSBOOM@USNA /*
		Labor organization dues */ JCSBOUM@USNA /*
		Professional association dues */ JCSBOPM@USNA /*
		Funeral and burial services */ JCSOBFM@USNA /*
		Personal care services */ JCSOPBM@USNA JCSOPOM@USNA /* 
		Clothing and footwear services */ JCSOPDM@USNA JCSOPRM@USNA JCSOPSM@USNA /*
		Child care */ JCSSSCM@USNA /*
		Social assistance */ JCSSWEM@USNA JCSSWRM@USNA JCSSWIM@USNA JCSSWVM@USNA JCSSWCM@USNA JCSSWOM@USNA /*
		Social advocacy */ JCSSSVM@USNA /*
		Religious organizations' services to households */ JCSSSRM@USNA /*
		Foundations and grantmaking */ JCSSSFM@USNA /*
		Household maintenance */ JCSLDM@USNA JCSLOSM@USNA JCSLORM@USNA JCSLOPM@USNA JCSLOOM@USNA /*
		Foreign travel by U.S. residents */ JCSFTPM@USNA JCSFTOM@USNA JCSFTSM@USNA /*
		Less: Expenditures in the United States by nonresidents */ JCSDTFM@USNA JCSDTEM@USNA JCSDTSM@USNA /*
	    Nonprofit */ JNPCFM@USNA, tvar(time_month) 
		}	
		
}
	
else if `level' == 4 {
if `foodenergy' == 1 { 
*4th level disaggregation
import haver /* 
        */ (CM CXFEM JCM JCXFEM)@USNA  (CSENT LR YPLTPMH)@USECON (IP CUT)@IP /*
	Consumption Expenditures */ /*
		New autos */ CDMNDM@USNA CDMNFM@USNA /*
		New light trucks */ CDMTNM@USNA /*
		Used autos */ CDMUNM@USNA CDMUGM@USNA CDMURM@USNA /*
		Used light trucks */ CDMTUNM@USNA CDMTUGM@USNA /*
		Motor vehicle parts and accessories */ CDMTTM@USNA CDMTVM@USNA /*
		Furniture and furnishings */ CDFUM@USNA CDFOLM@USNA CDFOFM@USNA CDFOTM@USNA /*
		Household appliances */ CDFKKM@USNA CDFKSM@USNA /*
		Glassware, tableware, and houeshold utensils */ CDFGDM@USNA CDFGKM@USNA /*
		Tools and equipment for house and garden */ CDFSTM@USNA CDFSLM@USNA /*
		Video and qudio equipment */ CDFTVM@USNA CDFTOM@USNA CDFTUM@USNA /*
		Recording media */ CDFTPM@USNA CDFTCM@USNA /*
		Photographic equipment */ CDOWPM@USNA /*
		Information processing equipment */ CDFCPM@USNA CDFCSM@USNA CDFCOM@USNA /*
		Sporting equipment, supplies, guns, and ammunition */ CDRSM@USNA /*
		Motorcycles */ CDOWLM@USNA /*
		Bicycles and accessories */ CDOWBM@USNA /*
		Pleasure boats, aircraft, and other recreational vehicles */ CDBBBM@USNA CDBBPM@USNA CDBBOM@USNA /*
		Recreational books */ CDRBM@USNA /*
		Musical instruments */ CDFTIM@USNA /*
		Jewelry and watches */ CDOJJM@USNA CDOJWM@USNA /*
		Therapeutic appliances and equipment */ CDOOTM@USNA CDOOEM@USNA /*
		Educational books */ CDEBM@USNA /*
		Luggage and similar personal items */ CDOLM@USNA /*
		Telephone and facsimile equipment */ CDOTM@USNA /*
		Cereals and bakery products */ CNFOFGM@USNA CNFOFKM@USNA /*
		Meats and poultry */ CNFOFBM@USNA CNFOFPM@USNA CNFOFRM@USNA CNFOFJM@USNA /*
		Fish and seafood */ CNFOFLM@USNA /*
		Milk, dairy products, and eggs */ CNFOFIM@USNA CNFOFDM@USNA CNFOFEM@USNA /*
		Fats and oils */ CNFOFWM@USNA /*
		Fresh fruits and vegetables */ CNFOFFM@USNA CNFOFVM@USNA /*
		Processed fruits and vegetables */ CNFOFTM@USNA /*
		Sugar and sweets */ CNFOFSM@USNA /*
		Food products, not elsewhere classified */ CNFOFOM@USNA /*
		Nonalcoholic beverages purchased for off-premises consumption */ CNFOFCM@USNA CNFOFNM@USNA /*
		Alcoholic beverages */ CNFOLDM@USNA CNFOLEM@USNA CNFOLBM@USNA /*
		Food produced and consumed on farms */ CNFEFM@USNA /*
		Garments */ CNLFFM@USNA CNLMFM@USNA CNLFIM@USNA /*
		Other clothing materials and footwear */ CNLOLM@USNA CNLXIM@USNA CNLSM@USNA /*
		Motor vehicle fuels, lubricants, and fluids */ CNLGOM@USNA CNLGLM@USNA /*
		Fuel oil and other fuels */ CNOFUM@USNA CNOFLM@USNA /*
		Pharmaceutical products */ CNODPM@USNA CNODNM@USNA /*
		Other medical products */ CNODOM@USNA /*
		Recreational items */ CNOGTM@USNA CNRPM@USNA CNGARM@USNA CNOGFM@USNA /*
		Household supplies */ CNOLPM@USNA CNOLFM@USNA CNOLNM@USNA CNOLSM@USNA CNOLOM@USNA /*
		Personal care products */ CNOPPM@USNA CNOPCM@USNA CNOPEM@USNA /*
		Tobacco */ CNOTM@USNA /*
		Magazines, newspapers, and stationery */ CNMGM@USNA CNONM@USNA /*
		Expenditures abroad by U.S. residents */ CNOVGM@USNA CNOVNM@USNA /*
		Less: Personal remittances in kind to nonresidents */ CNOVRM@USNA /*
		Rental of tenant-occupied nonfarm housing */ CSHTBM@USNA CSHTSM@USNA CSHTDM@USNA /*
		Imputed rental of owner-occupied nonfarm housing */ CSHRBM@USNA CSHRSM@USNA /*
		Rental value of farm dwellings */ CSHRM@USNA  /*
		Group housing */ CSHOM@USNA /*
		Water supply and sanitation */ CSLWSM@USNA CSLWRM@USNA /*
		Electricity and gas */ CSLEM@USNA CSLGM@USNA /*
		Physician services */ CSMPM@USNA /*
		Dental services */ CSMDM@USNA /*
		Paramedical services */ CSMOAM@USNA CSMOLM@USNA /*
			Other professional medical services */ CSMOSM@USNA CSMORM@USNA /*
		Hospitals */ CSMPNM@USNA CSMPPM@USNA CSMPGM@USNA /*
		Nursing homes */ CSMNNM@USNA CSMNPM@USNA /*
		Motor vehicle maintenance and repair */ CSTURM@USNA /*
		Other motor vehicle services */ CSTVRM@USNA CSTUTM@USNA /*
			Motor vehicle leasing */ CSTALM@USNA CSTTLM@USNA /*
		Railway transportation */ CSTIRM@USNA /*
		Road transportation */ CSTIBM@USNA CSTLBM@USNA CSTLTM@USNA CSTIOM@USNA /*
		Air transportation */ CSTIPM@USNA /*
		Water transportation */ CSTIWM@USNA /*
		Membership clubs and participant sports centers */ CSRCCM@USNA /*
		Amusement parks, campgrounds, and related recreational services */ CSRCPM@USNA /*
		Admissions to specified spectator amusements */ CSRSPM@USNA CSRSTM@USNA CSRSSM@USNA /*
		Museums and libraries */ CSOSLM@USNA /*
		Audio-video, phographic, and information processing servicse */ CSROTM@USNA CSRODM@USNA CSROUM@USNA CSREEM@USNA CSROYM@USNA /*
		Gambling */ CSROGM@USNA CSROLM@USNA CSROBM@USNA /*
		Other recreational services */ CSROVM@USNA CSRKM@USNA CSREVM@USNA /*
		Meals and nonalcoholic beverages */ CSFPSM@USNA CSFPOM@USNA /*
		Alcohol in purchased meals */ CSFPBM@USNA /*
		Food furnished to employees */ CSFEVM@USNA CSFEAM@USNA /*
		Hotels and motels */ CSHOTM@USNA /*
		Housing at schools */ CSHSM@USNA /*
		Financial services furnished without payment */ CSBSCM@USNA CSOBDM@USNA CSOBPM@USNA /*
		Financial service charges, fees, and commissions */ CSNFVM@USNA CSNFPM@USNA CSNFTM@USNA /*
			Securities commissions */ CSNFSDM@USNA CSNFIM@USNA /*
		Life insurance */ CSOBIM@USNA /*
		Net household insurance */ CSLOHM@USNA CSLOBM@USNA /*
		Net health insurance */ CSMHIM@USNA CSMIIM@USNA CSMISM@USNA /*
		Net motor vehicle and other transportation insurance */ CSVIM@USNA /*
		Telecommunication services */ CSLTLM@USNA CSLTDM@USNA CSLTCM@USNA /*
		Postal and delivery services */ CSLPFM@USNA CSLPOM@USNA /*
		Internet access */ CSRJIM@USNA /*
		Higher education */ CSOEUPM@USNA CSOEUNM@USNA /*
		Nursery, elementary, and secondary schools */ CSEESM@USNA CSEENM@USNA /*
		Commercial and vocational schools */ CSEOVM@USNA /*
		Legal services */ CSOBLM@USNA /*
		Accounting and other business services */ CSBOTM@USNA CSBOEM@USNA CSBOOM@USNA /*
		Labor organization dues */ CSBOUM@USNA /*
		Professional association dues */ CSBOPM@USNA /*
		Funeral and burial services */ CSOBFM@USNA /*
		Personal care services */ CSOPBM@USNA CSOPOM@USNA /* 
		Clothing and footwear services */ CSOPDM@USNA CSOPRM@USNA CSOPSM@USNA /*
		Child care */ CSSSCM@USNA /*
		Social assistance */ CSSWEM@USNA CSSWRM@USNA CSSWIM@USNA CSSWVM@USNA CSSWCM@USNA CSSWOM@USNA /*
		Social advocacy */ CSSSVM@USNA /*
		Religious organizations' services to households */ CSSSRM@USNA /*
		Foundations and grantmaking */ CSSSFM@USNA /*
		Household maintenance */ CSLDM@USNA CSLOSM@USNA CSLORM@USNA CSLOPM@USNA CSLOOM@USNA /*
		Foreign travel by U.S. residents */ CSFTPM@USNA CSFTOM@USNA CSFTSM@USNA /*
		Less: Expenditures in the United States by nonresidents */ CSDTFM@USNA CSDTEM@USNA CSDTSM@USNA /*
        Nonprofit */ NPCFM@USNA /*
	 Indeces */ /*
		New autos */ JCDMNDM@USNA JCDMNFM@USNA /*
		New light trucks */ JCDMTNM@USNA /*
		Used autos */ JCDMUNM@USNA JCDMUGM@USNA JCDMURM@USNA /*
		Used light trucks */ JCDMTUNM@USNA JCDMTUGM@USNA /*
		Motor vehicle parts and accessories */ JCDMTTM@USNA JCDMTVM@USNA /*
		Furniture and furnishings */ JCDFUM@USNA JCDFOLM@USNA JCDFOFM@USNA JCDFOTM@USNA /*
		Household appliances */ JCDFKKM@USNA JCDFKSM@USNA /*
		Glassware, tableware, and houeshold utensils */ JCDFGDM@USNA JCDFGKM@USNA /*
		Tools and equipment for house and garden */ JCDFSTM@USNA JCDFSLM@USNA /*
		Video and qudio equipment */ JCDFTVM@USNA JCDFTOM@USNA JCDFTUM@USNA /*
			Recording media */ JCDFTPM@USNA JCDFTCM@USNA /*
		Photographic equipment */ JCDOWPM@USNA /*
		Information processing equipment */ JCDFCPM@USNA JCDFCSM@USNA JCDFCOM@USNA /*
		Sporting equipment, supplies, guns, and ammunition */ JCDRSM@USNA /*
		Motorcycles */ JCDOWLM@USNA /*
		Bicycles and accessories */ JCDOWBM@USNA /*
		Pleasure boats, aircraft, and other recreational vehicles */ JCDBBBM@USNA JCDBBPM@USNA JCDBBOM@USNA /*
		Recreational books */ JCDRBM@USNA /*
		Musical instruments */ JCDFTIM@USNA /*
		Jewelry and watches */ JCDOJJM@USNA JCDOJWM@USNA /*
		Therapeutic appliances and equipment */ JCDOOTM@USNA JCDOOEM@USNA /*
		Educational books */ JCDEBM@USNA /*
		Luggage and similar personal items */ JCDOLM@USNA /*
		Telephone and facsimile equipment */ JCDOTM@USNA /*
		Cereals and bakery products */ JCNFOFGM@USNA JCNFOFKM@USNA /*
		Meats and poultry */ JCNFOFBM@USNA JCNFOFPM@USNA JCNFOFRM@USNA JCNFOFJM@USNA /*
		Fish and seafood */ JCNFOFLM@USNA /*
		Milk, dairy products, and eggs */ JCNFOFIM@USNA JCNFOFDM@USNA JCNFOFEM@USNA /*
		Fats and oils */ JCNFOFWM@USNA /*
		Fresh fruits and vegetables */ JCNFOFFM@USNA JCNFOFVM@USNA /*
		Processed fruits and vegetables */ JCNFOFTM@USNA /*
		Sugar and sweets */ JCNFOFSM@USNA /*
		Food products, not elsewhere classified */ JCNFOFOM@USNA /*
		Nonalcoholic beverages purchased for off-premises consumption */ JCNFOFCM@USNA JCNFOFNM@USNA /*
		Alcoholic beverages */ JCNFOLDM@USNA JCNFOLEM@USNA JCNFOLBM@USNA /*
		Food produced and consumed on farms */ JCNFEFM@USNA /*
		Garments */ JCNLFFM@USNA JCNLMFM@USNA JCNLFIM@USNA /*
		Other clothing materials and footwear */ JCNLOLM@USNA JCNLXIM@USNA JCNLSM@USNA /*
		Motor vehicle fuels, lubricants, and fluids */ JCNLGOM@USNA JCNLGLM@USNA /*
		Fuel oil and other fuels */ JCNOFUM@USNA JCNOFLM@USNA /*
		Pharmaceutical products */ JCNODPM@USNA JCNODNM@USNA /*
		Other medical products */ JCNODOM@USNA /*
		Recreational items */ JCNOGTM@USNA JCNRPM@USNA JCNGARM@USNA JCNOGFM@USNA /*
		Household supplies */ JCNOLPM@USNA JCNOLFM@USNA JCNOLNM@USNA JCNOLSM@USNA JCNOLOM@USNA /*
		Personal care products */ JCNOPPM@USNA JCNOPCM@USNA JCNOPEM@USNA /*
		Tobacco */ JCNOTM@USNA /*
		Magazines, newspapers, and stationery */ JCNMGM@USNA JCNONM@USNA /*
		Expenditures abroad by U.S. residents */ JCNOVGM@USNA JCNOVNM@USNA /*
		Less: Personal remittances in kind to nonresidents */ JCNOVRM@USNA /*
		Rental of tenant-occupied nonfarm housing */ JCSHTBM@USNA JCSHTSM@USNA JCSHTDM@USNA /*
		Imputed rental of owner-occupied nonfarm housing */ JCSHRBM@USNA JCSHRSM@USNA /*
		Rental value of farm dwellings */ JCSHRM@USNA  /*
		Group housing */ JCSHOM@USNA /*
		Water supply and sanitation */ JCSLWSM@USNA JCSLWRM@USNA /*
		Electricity and gas */ JCSLEM@USNA JCSLGM@USNA /*
		Physician services */ JCSMPM@USNA /*
		Dental services */ JCSMDM@USNA /*
		Paramedical services */ JCSMOAM@USNA JCSMOLM@USNA /*
			Other professional medical services */ JCSMOSM@USNA JCSMORM@USNA /*
		Hospitals */ JCSMPNM@USNA JCSMPPM@USNA JCSMPGM@USNA /*
		Nursing homes */ JCSMNNM@USNA JCSMNPM@USNA /*
		Motor vehicle maintenance and repair */ JCSTURM@USNA /*
		Other motor vehicle services */ JCSTVRM@USNA JCSTUTM@USNA /*
			Motor vehicle leasing */ JCSTALM@USNA JCSTTLM@USNA /*
		Railway transportation */ JCSTIRM@USNA /*
		Road transportation */ JCSTIBM@USNA JCSTLBM@USNA JCSTLTM@USNA JCSTIOM@USNA /*
		Air transportation */ JCSTIPM@USNA /*
		Water transportation */ JCSTIWM@USNA /*
		Membership clubs and participant sports centers */ JCSRCCM@USNA /*
		Amusement parks, campgrounds, and related recreational services */ JCSRCPM@USNA /*
		Admissions to specified spectator amusements */ JCSRSPM@USNA JCSRSTM@USNA JCSRSSM@USNA /*
		Museums and libraries */ JCSOSLM@USNA /*
		Audio-video, phographic, and information processing servicse */ JCSROTM@USNA JCSRODM@USNA JCSROUM@USNA JCSREEM@USNA JCSROYM@USNA /*
		Gambling */ JCSROGM@USNA JCSROLM@USNA JCSROBM@USNA /*
		Other recreational services */ JCSROVM@USNA JCSRKM@USNA JCSREVM@USNA /*
		Meals and nonalcoholic beverages */ JCSFPSM@USNA JCSFPOM@USNA /*
		Alcohol in purchased meals */ JCSFPBM@USNA /*
		Food furnished to employees */ JCSFEVM@USNA JCSFEAM@USNA /*
		Hotels and motels */ JCSHOTM@USNA /*
		Housing at schools */ JCSHSM@USNA /*
		Financial services furnished without payment */ JCSBSCM@USNA JCSOBDM@USNA JCSOBPM@USNA /*
		Financial service charges, fees, and commissions */ JCSNFVM@USNA JCSNFPM@USNA JCSNFTM@USNA /*
			Securities commissions */ JCSNFSDM@USNA JCSNFIM@USNA /*
		Life insurance */ JCSOBIM@USNA /*
		Net household insurance */ JCSLOHM@USNA JCSLOBM@USNA /*
		Net health insurance */ JCSMHIM@USNA JCSMIIM@USNA JCSMISM@USNA /*
		Net motor vehicle and other transportation insurance */ JCSVIM@USNA /*
		Telecommunication services */ JCSLTLM@USNA JCSLTDM@USNA JCSLTCM@USNA /*
		Postal and delivery services */ JCSLPFM@USNA JCSLPOM@USNA /*
		Internet access */ JCSRJIM@USNA /*
		Higher education */ JCSOEUPM@USNA JCSOEUNM@USNA /*
		Nursery, elementary, and secondary schools */ JCSEESM@USNA JCSEENM@USNA /*
		Commercial and vocational schools */ JCSEOVM@USNA /*
		Legal services */ JCSOBLM@USNA /*
		Accounting and other business services */ JCSBOTM@USNA JCSBOEM@USNA JCSBOOM@USNA /*
		Labor organization dues */ JCSBOUM@USNA /*
		Professional association dues */ JCSBOPM@USNA /*
		Funeral and burial services */ JCSOBFM@USNA /*
		Personal care services */ JCSOPBM@USNA JCSOPOM@USNA /* 
		Clothing and footwear services */ JCSOPDM@USNA JCSOPRM@USNA JCSOPSM@USNA /*
		Child care */ JCSSSCM@USNA /*
		Social assistance */ JCSSWEM@USNA JCSSWRM@USNA JCSSWIM@USNA JCSSWVM@USNA JCSSWCM@USNA JCSSWOM@USNA /*
		Social advocacy */ JCSSSVM@USNA /*
		Religious organizations' services to households */ JCSSSRM@USNA /*
		Foundations and grantmaking */ JCSSSFM@USNA /*
		Household maintenance */ JCSLDM@USNA JCSLOSM@USNA JCSLORM@USNA JCSLOPM@USNA JCSLOOM@USNA /*
		Foreign travel by U.S. residents */ JCSFTPM@USNA JCSFTOM@USNA JCSFTSM@USNA /*
		Less: Expenditures in the United States by nonresidents */ JCSDTFM@USNA JCSDTEM@USNA JCSDTSM@USNA /*
		Nonprofit */ JNPCFM@USNA, tvar(time_month)
		}				
if `foodenergy' == 0 { 
import haver /* 
        */ (CM CXFEM JCM JCXFEM)@USNA  (CSENT LR YPLTPMH)@USECON (IP CUT)@IP /*
	Consumption Expenditures */ /*
		New autos */ CDMNDM@USNA CDMNFM@USNA /*
		New light trucks */ CDMTNM@USNA /*
		Used autos */ CDMUNM@USNA CDMUGM@USNA CDMURM@USNA /*
		Used light trucks */ CDMTUNM@USNA CDMTUGM@USNA /*
		Motor vehicle parts and accessories */ CDMTTM@USNA CDMTVM@USNA /*
		Furniture and furnishings */ CDFUM@USNA CDFOLM@USNA CDFOFM@USNA CDFOTM@USNA /*
		Household appliances */ CDFKKM@USNA CDFKSM@USNA /*
		Glassware, tableware, and houeshold utensils */ CDFGDM@USNA CDFGKM@USNA /*
		Tools and equipment for house and garden */ CDFSTM@USNA CDFSLM@USNA /*
		Video and qudio equipment */ CDFTVM@USNA CDFTOM@USNA CDFTUM@USNA /*
		Recording media */ CDFTPM@USNA CDFTCM@USNA /*
		Photographic equipment */ CDOWPM@USNA /*
		Information processing equipment */ CDFCPM@USNA CDFCSM@USNA CDFCOM@USNA /*
		Sporting equipment, supplies, guns, and ammunition */ CDRSM@USNA /*
		Motorcycles */ CDOWLM@USNA /*
		Bicycles and accessories */ CDOWBM@USNA /*
		Pleasure boats, aircraft, and other recreational vehicles */ CDBBBM@USNA CDBBPM@USNA CDBBOM@USNA /*
		Recreational books */ CDRBM@USNA /*
		Musical instruments */ CDFTIM@USNA /*
		Jewelry and watches */ CDOJJM@USNA CDOJWM@USNA /*
		Therapeutic appliances and equipment */ CDOOTM@USNA CDOOEM@USNA /*
		Educational books */ CDEBM@USNA /*
		Luggage and similar personal items */ CDOLM@USNA /*
		Telephone and facsimile equipment */ CDOTM@USNA /*
		Garments */ CNLFFM@USNA CNLMFM@USNA CNLFIM@USNA /*
		Other clothing materials and footwear */ CNLOLM@USNA CNLXIM@USNA CNLSM@USNA /*
		Pharmaceutical products */ CNODPM@USNA CNODNM@USNA /*
		Other medical products */ CNODOM@USNA /*
		Recreational items */ CNOGTM@USNA CNRPM@USNA CNGARM@USNA CNOGFM@USNA /*
		Household supplies */ CNOLPM@USNA CNOLFM@USNA CNOLNM@USNA CNOLSM@USNA CNOLOM@USNA /*
		Personal care products */ CNOPPM@USNA CNOPCM@USNA CNOPEM@USNA /*
		Tobacco */ CNOTM@USNA /*
		Magazines, newspapers, and stationery */ CNMGM@USNA CNONM@USNA /*
		Expenditures abroad by U.S. residents */ CNOVGM@USNA CNOVNM@USNA /*
		Less: Personal remittances in kind to nonresidents */ CNOVRM@USNA /*
		Rental of tenant-occupied nonfarm housing */ CSHTBM@USNA CSHTSM@USNA CSHTDM@USNA /*
		Imputed rental of owner-occupied nonfarm housing */ CSHRBM@USNA CSHRSM@USNA /*
		Rental value of farm dwellings */ CSHRM@USNA  /*
		Group housing */ CSHOM@USNA /*
		Water supply and sanitation */ CSLWSM@USNA CSLWRM@USNA /*
		Physician services */ CSMPM@USNA /*
		Dental services */ CSMDM@USNA /*
		Paramedical services */ CSMOAM@USNA CSMOLM@USNA /*
		Other professional medical services */ CSMOSM@USNA CSMORM@USNA /*
		Hospitals */ CSMPNM@USNA CSMPPM@USNA CSMPGM@USNA /*
		Nursing homes */ CSMNNM@USNA CSMNPM@USNA /*
		Motor vehicle maintenance and repair */ CSTURM@USNA /*
		Other motor vehicle services */ CSTVRM@USNA CSTUTM@USNA /*
		Motor vehicle leasing */ CSTALM@USNA CSTTLM@USNA /*
		Railway transportation */ CSTIRM@USNA /*
		Road transportation */ CSTIBM@USNA CSTLBM@USNA CSTLTM@USNA CSTIOM@USNA /*
		Air transportation */ CSTIPM@USNA /*
		Water transportation */ CSTIWM@USNA /*
		Membership clubs and participant sports centers */ CSRCCM@USNA /*
		Amusement parks, campgrounds, and related recreational services */ CSRCPM@USNA /*
		Admissions to specified spectator amusements */ CSRSPM@USNA CSRSTM@USNA CSRSSM@USNA /*
		Museums and libraries */ CSOSLM@USNA /*
		Audio-video, phographic, and information processing servicse */ CSROTM@USNA CSRODM@USNA CSROUM@USNA CSREEM@USNA CSROYM@USNA /*
		Gambling */ CSROGM@USNA CSROLM@USNA CSROBM@USNA /*
		Other recreational services */ CSROVM@USNA CSRKM@USNA CSREVM@USNA /*
		Meals and nonalcoholic beverages */ CSFPSM@USNA CSFPOM@USNA /*
		Alcohol in purchased meals */ CSFPBM@USNA /*
		Food furnished to employees */ CSFEVM@USNA CSFEAM@USNA /*
		Hotels and motels */ CSHOTM@USNA /*
		Housing at schools */ CSHSM@USNA /*
		Financial services furnished without payment */ CSBSCM@USNA CSOBDM@USNA CSOBPM@USNA /*
		Financial service charges, fees, and commissions */ CSNFVM@USNA CSNFPM@USNA CSNFTM@USNA /*
		Securities commissions */ CSNFSDM@USNA CSNFIM@USNA /*
		Life insurance */ CSOBIM@USNA /*
		Net household insurance */ CSLOHM@USNA CSLOBM@USNA /*
		Net health insurance */ CSMHIM@USNA CSMIIM@USNA CSMISM@USNA /*
		Net motor vehicle and other transportation insurance */ CSVIM@USNA /*
		Telecommunication services */ CSLTLM@USNA CSLTDM@USNA CSLTCM@USNA /*
		Postal and delivery services */ CSLPFM@USNA CSLPOM@USNA /*
		Internet access */ CSRJIM@USNA /*
		Higher education */ CSOEUPM@USNA CSOEUNM@USNA /*
		Nursery, elementary, and secondary schools */ CSEESM@USNA CSEENM@USNA /*
		Commercial and vocational schools */ CSEOVM@USNA /*
		Legal services */ CSOBLM@USNA /*
		Accounting and other business services */ CSBOTM@USNA CSBOEM@USNA CSBOOM@USNA /*
		Labor organization dues */ CSBOUM@USNA /*
		Professional association dues */ CSBOPM@USNA /*
		Funeral and burial services */ CSOBFM@USNA /*
		Personal care services */ CSOPBM@USNA CSOPOM@USNA /* 
		Clothing and footwear services */ CSOPDM@USNA CSOPRM@USNA CSOPSM@USNA /*
		Child care */ CSSSCM@USNA /*
		Social assistance */ CSSWEM@USNA CSSWRM@USNA CSSWIM@USNA CSSWVM@USNA CSSWCM@USNA CSSWOM@USNA /*
		Social advocacy */ CSSSVM@USNA /*
		Religious organizations' services to households */ CSSSRM@USNA /*
		Foundations and grantmaking */ CSSSFM@USNA /*
		Household maintenance */ CSLDM@USNA CSLOSM@USNA CSLORM@USNA CSLOPM@USNA CSLOOM@USNA /*
		Foreign travel by U.S. residents */ CSFTPM@USNA CSFTOM@USNA CSFTSM@USNA /*
		Less: Expenditures in the United States by nonresidents */ CSDTFM@USNA CSDTEM@USNA CSDTSM@USNA /*
        Nonprofit */ NPCFM@USNA /*
	 Indeces */ /*
		New autos */ JCDMNDM@USNA JCDMNFM@USNA /*
		New light trucks */ JCDMTNM@USNA /*
		Used autos */ JCDMUNM@USNA JCDMUGM@USNA JCDMURM@USNA /*
		Used light trucks */ JCDMTUNM@USNA JCDMTUGM@USNA /*
		Motor vehicle parts and accessories */ JCDMTTM@USNA JCDMTVM@USNA /*
		Furniture and furnishings */ JCDFUM@USNA JCDFOLM@USNA JCDFOFM@USNA JCDFOTM@USNA /*
		Household appliances */ JCDFKKM@USNA JCDFKSM@USNA /*
		Glassware, tableware, and houeshold utensils */ JCDFGDM@USNA JCDFGKM@USNA /*
		Tools and equipment for house and garden */ JCDFSTM@USNA JCDFSLM@USNA /*
		Video and qudio equipment */ JCDFTVM@USNA JCDFTOM@USNA JCDFTUM@USNA /*
		Recording media */ JCDFTPM@USNA JCDFTCM@USNA /*
		Photographic equipment */ JCDOWPM@USNA /*
		Information processing equipment */ JCDFCPM@USNA JCDFCSM@USNA JCDFCOM@USNA /*
		Sporting equipment, supplies, guns, and ammunition */ JCDRSM@USNA /*
		Motorcycles */ JCDOWLM@USNA /*
		Bicycles and accessories */ JCDOWBM@USNA /*
		Pleasure boats, aircraft, and other recreational vehicles */ JCDBBBM@USNA JCDBBPM@USNA JCDBBOM@USNA /*
		Recreational books */ JCDRBM@USNA /*
		Musical instruments */ JCDFTIM@USNA /*
		Jewelry and watches */ JCDOJJM@USNA JCDOJWM@USNA /*
		Therapeutic appliances and equipment */ JCDOOTM@USNA JCDOOEM@USNA /*
		Educational books */ JCDEBM@USNA /*
		Luggage and similar personal items */ JCDOLM@USNA /*
		Telephone and facsimile equipment */ JCDOTM@USNA /*
		Garments */ JCNLFFM@USNA JCNLMFM@USNA JCNLFIM@USNA /*
		Other clothing materials and footwear */ JCNLOLM@USNA JCNLXIM@USNA JCNLSM@USNA /*
		Pharmaceutical products */ JCNODPM@USNA JCNODNM@USNA /*
		Other medical products */ JCNODOM@USNA /*
		Recreational items */ JCNOGTM@USNA JCNRPM@USNA JCNGARM@USNA JCNOGFM@USNA /*
		Household supplies */ JCNOLPM@USNA JCNOLFM@USNA JCNOLNM@USNA JCNOLSM@USNA JCNOLOM@USNA /*
		Personal care products */ JCNOPPM@USNA JCNOPCM@USNA JCNOPEM@USNA /*
		Tobacco */ JCNOTM@USNA /*
		Magazines, newspapers, and stationery */ JCNMGM@USNA JCNONM@USNA /*
		Expenditures abroad by U.S. residents */ JCNOVGM@USNA JCNOVNM@USNA /*
		Less: Personal remittances in kind to nonresidents */ JCNOVRM@USNA /*
		Rental of tenant-occupied nonfarm housing */ JCSHTBM@USNA JCSHTSM@USNA JCSHTDM@USNA /*
		Imputed rental of owner-occupied nonfarm housing */ JCSHRBM@USNA JCSHRSM@USNA /*
		Rental value of farm dwellings */ JCSHRM@USNA  /*
		Group housing */ JCSHOM@USNA /*
		Water supply and sanitation */ JCSLWSM@USNA JCSLWRM@USNA /*
		Physician services */ JCSMPM@USNA /*
		Dental services */ JCSMDM@USNA /*
		Paramedical services */ JCSMOAM@USNA JCSMOLM@USNA /*
			Other professional medical services */ JCSMOSM@USNA JCSMORM@USNA /*
		Hospitals */ JCSMPNM@USNA JCSMPPM@USNA JCSMPGM@USNA /*
		Nursing homes */ JCSMNNM@USNA JCSMNPM@USNA /*
		Motor vehicle maintenance and repair */ JCSTURM@USNA /*
		Other motor vehicle services */ JCSTVRM@USNA JCSTUTM@USNA /*
			Motor vehicle leasing */ JCSTALM@USNA JCSTTLM@USNA /*
		Railway transportation */ JCSTIRM@USNA /*
		Road transportation */ JCSTIBM@USNA JCSTLBM@USNA JCSTLTM@USNA JCSTIOM@USNA /*
		Air transportation */ JCSTIPM@USNA /*
		Water transportation */ JCSTIWM@USNA /*
		Membership clubs and participant sports centers */ JCSRCCM@USNA /*
		Amusement parks, campgrounds, and related recreational services */ JCSRCPM@USNA /*
		Admissions to specified spectator amusements */ JCSRSPM@USNA JCSRSTM@USNA JCSRSSM@USNA /*
		Museums and libraries */ JCSOSLM@USNA /*
		Audio-video, phographic, and information processing servicse */ JCSROTM@USNA JCSRODM@USNA JCSROUM@USNA JCSREEM@USNA JCSROYM@USNA /*
		Gambling */ JCSROGM@USNA JCSROLM@USNA JCSROBM@USNA /*
		Other recreational services */ JCSROVM@USNA JCSRKM@USNA JCSREVM@USNA /*
		Meals and nonalcoholic beverages */ JCSFPSM@USNA JCSFPOM@USNA /*
		Alcohol in purchased meals */ JCSFPBM@USNA /*
		Food furnished to employees */ JCSFEVM@USNA JCSFEAM@USNA /*
		Hotels and motels */ JCSHOTM@USNA /*
		Housing at schools */ JCSHSM@USNA /*
		Financial services furnished without payment */ JCSBSCM@USNA JCSOBDM@USNA JCSOBPM@USNA /*
		Financial service charges, fees, and commissions */ JCSNFVM@USNA JCSNFPM@USNA JCSNFTM@USNA /*
			Securities commissions */ JCSNFSDM@USNA JCSNFIM@USNA /*
		Life insurance */ JCSOBIM@USNA /*
		Net household insurance */ JCSLOHM@USNA JCSLOBM@USNA /*
		Net health insurance */ JCSMHIM@USNA JCSMIIM@USNA JCSMISM@USNA /*
		Net motor vehicle and other transportation insurance */ JCSVIM@USNA /*
		Telecommunication services */ JCSLTLM@USNA JCSLTDM@USNA JCSLTCM@USNA /*
		Postal and delivery services */ JCSLPFM@USNA JCSLPOM@USNA /*
		Internet access */ JCSRJIM@USNA /*
		Higher education */ JCSOEUPM@USNA JCSOEUNM@USNA /*
		Nursery, elementary, and secondary schools */ JCSEESM@USNA JCSEENM@USNA /*
		Commercial and vocational schools */ JCSEOVM@USNA /*
		Legal services */ JCSOBLM@USNA /*
		Accounting and other business services */ JCSBOTM@USNA JCSBOEM@USNA JCSBOOM@USNA /*
		Labor organization dues */ JCSBOUM@USNA /*
		Professional association dues */ JCSBOPM@USNA /*
		Funeral and burial services */ JCSOBFM@USNA /*
		Personal care services */ JCSOPBM@USNA JCSOPOM@USNA /* 
		Clothing and footwear services */ JCSOPDM@USNA JCSOPRM@USNA JCSOPSM@USNA /*
		Child care */ JCSSSCM@USNA /*
		Social assistance */ JCSSWEM@USNA JCSSWRM@USNA JCSSWIM@USNA JCSSWVM@USNA JCSSWCM@USNA JCSSWOM@USNA /*
		Social advocacy */ JCSSSVM@USNA /*
		Religious organizations' services to households */ JCSSSRM@USNA /*
		Foundations and grantmaking */ JCSSSFM@USNA /*
		Household maintenance */ JCSLDM@USNA JCSLOSM@USNA JCSLORM@USNA JCSLOPM@USNA JCSLOOM@USNA /*
		Foreign travel by U.S. residents */ JCSFTPM@USNA JCSFTOM@USNA JCSFTSM@USNA /*
		Less: Expenditures in the United States by nonresidents */ JCSDTFM@USNA JCSDTEM@USNA JCSDTSM@USNA /*
		Nonprofit */ JNPCFM@USNA, tvar(time_month)
		}	
}
	
gen year        = year(dofm(time_month))
gen month       = month(dofm(time_month))
gen quarter     = quarter(dofm(time_month))
rename ypltpmh_usecon  realincome
rename cut_ip          util
rename ip_ip           IP
rename lr_usecon       UR
rename cm_usna         pce_spend
rename jcm_usna        pce
rename jcxfem_usna     core
rename cxfem_usna      core_spend
rename cgxfem_usna     coregoods_spend
rename jcgxfem_usna    coregoods
rename csxem_usna      coreserv_spend
rename jcsxem_usna     coreserv
rename jc*_usna *
rename c*_usna *_spend
rename jnpcfm_usna  pcfm
rename npcfm_usna   pcfm_spend


cap replace svxm_spend = -svxm_spend
cap replace novrm_spend = -novrm_spend 
order time_month pce core* pce_spend UR IP pcfm_spend
gen util_level = util
gen IP_level = IP
gen lnrinc = ln(realincome)
sort year quarter
save "S:\Adam\cyclical inflation paper\pce.dta", replace

capture set haverdir M:\Haver\DLX\DATA
import haver (NAIRUQ OGAPQ GDPH)@USECON, tvar(time_quarter) clear
gen year = year(dofq(time_quarter))
gen quarter = quarter(dofq(time_quarter))
sort year quarter
rename nairuq_usecon nairu
rename ogapq_usecon  ygap
tsset time_quarter 
qui gen rgdp_q     = ((gdph_usecon - l.gdph_usecon)/l.gdph_usecon + 1)^4 - 1
drop gdph_usecon  
sort year quarter
save "S:\Adam\cyclical inflation paper\temp1.dta", replace


**Import PTR Data Series, available from FRB/US Model https://www.federalreserve.gov/econres/us-models-about.htm***
import excel "S:\Adam\ShelterHealthcare\PTR.xlsx", sheet("Sheet1") firstrow clear
gen year = substr(date, 1,4)
gen quarter = substr(date, -1,.)
destring year, replace
destring quarter, replace
replace PTR = PTR/100
drop date
sort year quarter
save "S:\Adam\cyclical inflation paper\temp2.dta", replace


use "S:\Adam\cyclical inflation paper\pce.dta", clear
merge year quarter using "S:\Adam\cyclical inflation paper\temp1.dta"
drop _merge
sort year quarter 
merge year quarter using "S:\Adam\cyclical inflation paper\temp2.dta"
drop _merge

drop if year < 1960
drop if year > 2021

*FILL IN QUARTERLY NUMBERS
sort time_month
replace nairu = nairu[_n-1] if missing(nairu) 
replace ygap  = ygap[_n-1]  if missing(ygap)

gen       ugap = nairu - UR
replace   ugap = ugap/100 
tsset time_month


*Annualized monthly
if `level' == 0 {
local start dfdm
}
if `level' == 1 {
local start debm
}
else if `level' == 2 {
local start dbbm
}
else if `level' == 3 {
local start dbbbm
}
else if `level' == 4 {
local start dbbbm
}
foreach i of varlist util IP core coregoods coreserv pce `start'-pcfm { 
qui gen `i'_y     = (`i' - l12.`i')/l12.`i'
qui gen `i'_m     = ((`i' - l.`i')/l.`i' + 1)^12 - 1
replace `i' = `i'_m
drop `i'_m
}



*Run Phillips Curve for Each Sector, Mark the Significant Sectors
foreach i of varlist `start'-pcfm { 
qui gen `i'_diff      = `i' - l.`i'
qui gen `i'_star_diff = PTR - l.`i'
qui newey 	 `i'_diff l.`gap'	 `i'_star_diff  if year >= `min_date'  & year <= `max_date' , lag(12)
local beta_`i' = _b[l.`gap']
local se_`i' = _se[l.`gap']
local upper_`i' = _b[l.`gap'] + 1.96*_se[l.`gap']
local lower_`i' = _b[l.`gap'] - 1.96*_se[l.`gap']
local cycdum_`i'  = (_b[l.`gap']/_se[l.`gap']) >  `thresh' 
local acycdum_`i' = (_b[l.`gap']/_se[l.`gap']) <= `thresh' 
qui drop `i'_diff `i'_star_diff
}


preserve
gen varname   = ""
gen cyclical = .
gen beta = .
gen SE = .
gen upper = .
gen lower = .
gen category = ""
local k = 1
foreach i of varlist `start'-pcfm { 
local label: var label `i'
replace varname = "`label'" if _n == `k'
replace varname =  subinstr(varname, "Price Index (SA, 2012=100)", "", .) if _n == `k'
replace varname =  subinstr(varname, "Price Index(SA, 2012=100)", "", .) if _n == `k'
replace varname =  subinstr(varname, "Price Idx(SA, 2012=100)", "", .) if _n == `k'
replace varname =  subinstr(varname, "Price Idx (SA, 2012=100)", "", .) if _n == `k'
replace varname =  subinstr(varname, "Price Idx(SA,2012=100)", "", .) if _n == `k'
replace varname =  subinstr(varname, "Household Consumption Expenditures:", "", .) if _n == `k'
replace varname =  subinstr(varname, "HH Consumption Expenditure:", "", .) if _n == `k'
replace varname =  subinstr(varname, "HH Consumption Expenditures:", "", .) if _n == `k'
replace varname =  subinstr(varname, "HH Consumption Exp:", "", .) if _n == `k'
replace varname =  subinstr(varname, "HH Cons Exp:", "", .) if _n == `k'
replace varname =  subinstr(varname, "PCE:", "", .) if _n == `k'
replace varname =  subinstr(varname, "Personal Consumption Expenditures:", "", .) if _n == `k'
replace varname = trim(varname)
replace varname = "Recreational Goods" if varname == "Recreational Gds & Vehicles"
replace varname = "Nonprofit Institutions" if varname == "Final Consumptn Exps of Nonprofit Instns Serving HH"
replace varname = "Other Nondurable Goods" if varname == "Other Nondurables"
replace varname = "Transportation" if varname == "Transportation Services"
replace varname = "Food Services & Accomodations" if varname == "Food Svcs & Accommodations"
replace varname = "Financial Services" if varname == "Financial Svcs & Insurance"
replace varname = "Other Durable Goods" if varname == "Other Durable Gds"
replace varname =  subinstr(varname, "&", "\&", .) if _n == `k'

if `level' == 2 {
replace category = "Motor Vehicles & Parts" if (`i' == dmnm | `i' == dmtnm | `i' == dmum | `i' == dmtum | `i' == dmttm | `i' == dmtvm) &  _n == `k'
replace category = "Furnishings & Durable Household Equip" if (`i' == dfum | `i' == dfolm | `i' == dfofm | `i' == dfotm | `i' == dfkkm | `i' == dfksm | `i' == dfgdm | `i' == dfgkm | `i' == dfstm | `i' == dfslm) &  _n == `k'
replace category = "Recreational Goods" if (`i' == drgdm | `i' == dowpm | `i' == drgim | `i' == drsm | `i' == dowlm | `i' == dowbm | `i' == dbbm | `i' == drbm | `i' == dftim) &  _n == `k' 
replace category = "Other Durable Goods" if (`i' == dojjm | `i' == dojwm | `i' == dootm | `i' == dooem | `i' == debm | `i' == dolm | `i' == dotm) &  _n == `k'
replace category = "Clothing & Footwear" if (`i' == nlffm | `i' == nlmfm | `i' == nlolm | `i' == nlxim | `i' == nlsm) &  _n == `k'
replace category = "Other Nondurable Goods" if (`i' == nodrm | `i' == nodom | `i' == nogtm | `i' == nrpm | `i' == ngarm | `i' == nogfm | `i' == nolpm ///
                                             | `i' == nolfm | `i' == nolnm | `i' == nolsm | `i' == nolom | `i' == noppm | `i' == nopcm | `i' == nopem ///
											 | `i' == notm | `i' == nmgm | `i' == nonm | `i' == novum | `i' == novrm) &  _n == `k'
replace category = "Housing" if  (`i' == shtm | `i' == srdm | `i' == shom) &  _n == `k' 
replace category = "Health Care"    if (`i'  == smpm | `i' == smdm | `i' == smom | `i' == smhpm | `i' == smhnm) &  _n == `k'
replace category = "Transportation" if (`i' == sturm | `i' == strlm | `i' == stigm | `i' == stipm | `i' == stiwm) &  _n == `k' 
replace category = "Recreation Services" if (`i' == srccm | `i' == srcpm | `i' == srsm | `i' == soslm | `i' == srotm | `i' == srodm | `i' == sroum | `i' == sreem | `i' == sroym ///
                                                | `i' == srogm | `i' == srolm | `i' == srobm | `i' == srovm | `i' == srkm | `i' == srevm) &  _n == `k'   
replace category = "Food Services & Accomodations" if (`i' == sfpm | `i' == sfeem | `i' == shotm | `i' == shsm) &  _n == `k'
replace category = "Financial Services" if (`i' == sobsm | `i' == snfcm | `i' == sobim | `i' == slim | `i' == smim | `i' == svim) &  _n == `k'	
replace category = "Nonprofit Institutions" if 	`i' == pcfm & _n == `k' 									
replace category = "Other Services" if missing(category) &  _n == `k'
}
replace beta = `beta_`i''  if _n == `k'
replace upper = `upper_`i''  if _n == `k' 
replace lower = `lower_`i''  if _n == `k' 									
replace cyclical = `cycdum_`i'' if _n == `k'
replace SE = `se_`i''  if _n == `k'
local k = `k' + 1
}
keep varname cyclical beta SE
drop if missing(varname)
sort cyclical
save "C:\Dividing Inflation\Paper\category_list_cyc.dta", replace
gsort  -beta
dataout, save("C:\Dividing Inflation\Paper\category_list_cyc.tex") tex replace
restore

*Construct Procyclical and Acyclical Contributions
gen pro_exp = 0
gen acy_exp = 0
foreach i of varlist `start'-pcfm { 
replace pro_exp = pro_exp + `cycdum_`i''*`i'_spend
replace acy_exp = acy_exp + `acycdum_`i''*`i'_spend
}

foreach i of varlist `start'-pcfm {
gen weight_cyc`i'  = 1
gen weight_acyc`i' = 1
gen weight_contr`i'  = 1
forval k = 0/11 {
local m = `k' + 1 
qui replace weight_cyc`i'    =  weight_cyc`i'*((((l`k'.`i'_spend*`cycdum_`i'')/l`k'.pro_exp + 1)*((l`m'.`i'_spend*`cycdum_`i'')/l`m'.pro_exp + 1))^.5)
qui replace weight_acyc`i'   =  weight_acyc`i'*((((l`k'.`i'_spend*`acycdum_`i'')/l`k'.acy_exp + 1)*((l`m'.`i'_spend*`acycdum_`i'')/l`m'.acy_exp + 1))^.5)
qui replace weight_contr`i'  =  weight_contr`i'*((((l`k'.`i'_spend/l`k'.core_spend) + 1)*((l`m'.`i'_spend/l`m'.core_spend) + 1))^.5)
}
gen procontr_`i'y  =  (weight_cyc`i'^(1/12)- 1)*`i'_y*100
gen acyccontr_`i'y =  (weight_acyc`i'^(1/12) - 1)*`i'_y*100
gen procontr_`i'm  = ((l0.`i'_spend*`cycdum_`i'')/l0.pro_exp)*`i'*100
gen acyccontr_`i'm = ((l0.`i'_spend*`acycdum_`i'')/l0.acy_exp)*`i'*100
gen contr_`i'y    =  (weight_contr`i'^(1/12) - 1)*`i'_y*100
gen contr_`i'm = (l0.`i'_spend/l0.core_spend)*`i'*100
}


***Generate services and goods contributions
foreach i of varlist coregoods coreserv {
gen weight_contr`i'  = 1
forval k = 0/11 {
local m = `k' + 1 
qui replace weight_contr`i'  =  weight_contr`i'*((((l`k'.`i'_spend/l`k'.core_spend) + 1)*((l`m'.`i'_spend/l`m'.core_spend) + 1))^.5)
}
gen contr_`i'y    =  (weight_contr`i'^(1/12) - 1)*`i'_y*100
}

*Construct Procyclical and Acyclical Inflation Rates
gen pro_inf_y = 0
gen acy_inf_y = 0
gen pro_inf_m = 0
gen acy_inf_m = 0
foreach i of varlist `start'-pcfm { 
replace pro_inf_y = pro_inf_y + procontr_`i'y
replace acy_inf_y = acy_inf_y + acyccontr_`i'y
replace pro_inf_m = pro_inf_m + procontr_`i'm
replace acy_inf_m = acy_inf_m + acyccontr_`i'm
}

*Construct Procyclical and Acyclical Contributions
gen pro_contr_y = 0
gen acy_contr_y = 0
gen pro_contr_m = 0
gen acy_contr_m = 0
foreach i of varlist `start'-pcfm {
replace pro_contr_y = pro_contr_y + contr_`i'y*`cycdum_`i''
replace acy_contr_y = acy_contr_y + contr_`i'y*`acycdum_`i''
replace pro_contr_m = pro_contr_m + contr_`i'm*`cycdum_`i''
replace acy_contr_m = acy_contr_m + contr_`i'm*`acycdum_`i''
}


local healthlist smpm smdm smom smhpm smhnm
gen contr_sdmy = 0
gen contr_sdmm = 0
foreach i of local healthlist {
replace contr_sdmy = contr_sdmy + `acycdum_`i''*contr_`i'y 
replace contr_sdmm = contr_sdmm + `acycdum_`i''*contr_`i'm 

}
gen nhacy_contr_y =  acy_contr_y - contr_sdmy
gen nhacy_contr_m =  acy_contr_m - contr_sdmm





if `foodenergy' == 0 {
gen share_pro = pro_exp/core_spend
}
else if `foodenergy' == 1 {
gen share_pro = pro_exp/pce_spend
}

replace core_y = 100*core_y


foreach i in acy_inf_y pro_inf_y acy_contr_y pro_contr_y contr_sdmy nhacy_contr_y {
gen `i'st = ""
replace  `i'st    =  substr(string(`i'),1,4) if `i' >= 1
replace  `i'st    =  substr(string(`i'),1,5) if `i' < 1
destring(`i'st), gen(`i'dst)
drop `i'
gen double `i' = round(`i'dst,.01)
drop `i'dst `i'st
}

drop if missing(pro_inf_y)

label variable acy_inf_y "Acyclical core PCE inflation"
label variable pro_inf_y "Cyclical core PCE inflation"
label variable acy_contr_y "Ayclical core PCE contribution"
label variable pro_contr_y "Cyclical core PCE contribution"
label variable contr_sdmy "Health-care services portion of acyclical contribution"
label variable nhacy_contr_y "Non-health-care portion of acyclical contribution"



gen zero = 0
tostring(month), gen(month_st)
tostring(year), gen(year_st)
gen time = year_st + "m" + month_st 
gen time1 = year_st
replace time1 = "." if month~=1


labmask time_month, values(time1) /*need to ssc install labutil*/

															
graph bar pro_contr_y acy_contr_y zero if year >=1988, over(time_month,  label(angle(50) labsize(vsmall)))    ///
                                                         bar(1, color(navy)) bar(2, color(teal))    ///
													     stack graphregion(col(white) fcolor(white))   legend( order( 1 2) label(1 "Cyclical Component") label(2 "Acyclical Component") label(3 "")  ///
													     region(color(white)) size(small))  ytitle(Core PCE inflation (y/y))	name(cyc_acyc, replace) 
qui graph export "C:\Dividing Inflation\Paper\figures\cyc_acyc.pdf", as(pdf) replace
qui graph export "C:\Dividing Inflation\Paper\figures\cyc_acyc.png", as(png) replace																		

gen ugap_neg = -ugap
 twoway (scatter  pro_contr_m ugap_neg if year <= 2007, mcolor(blue*.7) msymbol(circle_hollow) ) ///
        (scatter  pro_contr_m ugap_neg if year > 2007, mcolor(ltblue*1.3) msymbol(circle_hollow) legend(region(lcolor(white)) order(1 "In Sample" 2 "Out of Sample"))) ///
		(lfit  pro_contr_m ugap_neg if year > 2007, lcolor(gs10))  ///
		(lfit  pro_contr_m ugap_neg if year <= 2007, lcolor(black)), ///
		  nodraw name(cyclical, replace) graphregion(color(white)) title("Cyclical Contribution") xtitle("Unemployment Gap") ytitle("Cyclical inflation (m/m)") 
		
 twoway (scatter  acy_contr_m ugap_neg if year <= 2007 & acy_contr_m < 4, mcolor(blue*.7) msymbol(circle_hollow) ) ///
        (scatter  acy_contr_m ugap_neg if year > 2007, mcolor(ltblue*1.3) msymbol(circle_hollow) legend(region(lcolor(white)) order(1 "In Sample" 2 "Out of Sample"))) ///
		(lfit  acy_contr_m ugap_neg if year > 2007 & acy_contr_m < 4, lcolor(gs10))  ///
		(lfit  acy_contr_m ugap_neg if year <= 2007 & acy_contr_m < 4, lcolor(black)), ///
		 nodraw name(acyclical, replace) title("Acyclical Contribution")  graphregion(color(white)) xtitle("Unemployment Gap") ytitle("Acyclical inflation (m/m)") 
		
grc1leg cyclical acyclical, legendfrom(cyclical) rows(1)  iscale(.5)   fxsize(200)  fysize(80) scheme(s1color) name(cyc_fit, replace)
graph export "C:\Dividing Inflation\Paper\figures\cyc_fit.pdf", as(pdf) replace
graph export "C:\Dividing Inflation\Paper\figures\cyc_fit.png", as(png) replace

