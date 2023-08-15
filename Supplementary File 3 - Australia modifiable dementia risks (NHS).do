

*===============================================================================*
*		Dementia Populationa Attributable Fraction (PAF) - Australia			*
*						Preparation of Indicators								*
*							All Australians										*
*===============================================================================*

	*	Date commenced: 11/03/2022
	*	Dates updated: ##/##/2022,

		
		*-------------------------------*
		*	Examine avaialble datasets	*
		*-------------------------------*
			cd "R:\nhs17d-g\NHS17D_G"			
			dir
				
			*National Survey	
															
			/*		2255.6k  11/30/20 19:46  nhs17a14.dta     - Alcohol (totpal - total alcohol in last week) - Relevant
					1634.4k  11/30/20 19:46  nhs17al3.dta     - Not relevant
					7325.2k  11/30/20 19:46  nhs17con.dta     - ??? Conditions level - relevant            
					  21.9M  11/30/20 19:46  nhs17hhd.dta     - ??? Household level data - Relevant         
					6170.4k  11/30/20 19:46  nhs17hls.dta     - ???	         
					3665.6k  11/30/20 19:46  nhs17med.dta     - ??? Medication level data - not relevant      
					  63.8M  11/30/20 19:46  nhs17sps.dta     - Individual level NHS variables - Relevant				*/
														
		
		*-------------------------------*
		*	Risk factors of interest	*
		*-------------------------------*
													
		/*		R1 - Obesity				[Individual level file - nhs17sps.dta]
				R2 - Physical Inactivity
				R3 - Smoker
				R4 - Low Education
				R5 - Diabetes
				R6 - Hypertension
				R7 - Depression
				R8 - Hearing impairment
				R9 - Alcohol use
				R10 - Social contact						
				R12 - Air pollution	*/
				
			
		*=======================================*
		*	OPEN INDIVIDUAL LEVEL NATSIHS DATA	*
		*=======================================*

			use "nhs17sps.dta", clear
			codebook abspid //# unique values
				
			*-------------------------------*
			*		Age Groups & Labels		*
			*-------------------------------*
			
				label define yn 0 "No" 1"Yes",replace
				
				*Age groups
				tab age99,m //0-94 years (n=# missing)

				*<45, 45-65, >65
					gen age_45 = 0
						replace age_45 = 1 if age99<45 //(# real changes made)
						replace age_45 = 2 if age99>=45 & age99<=65 //(# real changes made)
						replace age_45 = 3 if age99>65 //(# real changes made)
						
						label define age_45 1 "<45" 2 "45-65" 3 ">65",replace
						label values age_45 age_45 
						
						label var age_45 "Age Group45 (1=<45, 2=45-65, 3>65)"
						
						tab age99 age_45,m
						tab age_45,m

						/*	    Age Group45 |
									(1=<45, |
								   2=45-65, |
									  3>65) |      Freq.     Percent        Cum.
								------------+-----------------------------------
										<45 |     #
									  45-65 |     #
										>65 |      #
								------------+-----------------------------------
									  Total |     #      100.00			  */
							
					
					
			*-------------------------------*
			*			Ethnic Group		*
			*-------------------------------*					
					
					*Father's country of birth
						*tab cobfcddl,m

						merge m:1 cobfcddl using "P:\2_Data\0_NHS_Ancestry.dta"						

						/*		Result                           # of obs.
								-----------------------------------------
								not matched                            #
									from master                         #  (_merge==1)	- All of the master files merged.
									from using                         #  (_merge==2)

								matched                            #  (_merge==3)
								-----------------------------------------	*/

						
						rename cob_d cob_f
						rename European european_f
						rename Asian asian_f
						
						drop if _merge == 2	//(# observations deleted)
						drop _merge
						order cob_f european_f asian_f, a(cobfcddl)
						
					*Mother's country of birth	
						*tab cobmcddl,m
						
						merge m:1 cobmcddl using "P:\2_Data\0_NHS_Ancestry.dta"						

						/*		Result                           # of obs.
								-----------------------------------------
								not matched                            #
									from master                         #  (_merge==1)	- All of the master files merged.
									from using                         #  (_merge==2)

								matched                            #  (_merge==3)
								-----------------------------------------		*/

					
						rename cob_d cob_m
						rename European european_m
						rename Asian asian_m
						
						drop if _merge == 2 //(# observations deleted)
						drop _merge
						order cob_m european_m asian_m, a(cobmcddl)
												
							
						*Compare COBs of parents
						tab cob_f cob_m,m

						/*						  |                                                     cob_m
											cob_f |         0   Oceanian  North Wes  Southern   North Afr  Sout East  North Eas  Southern    Americas     Africa |     Total
							----------------------+--------------------------------------------------------------------------------------------------------------+----------
												0 |        # 
										 Oceanian |         # 
							  North West European |         # 
							Southern and Eastern  |        # 
							North African and Mid |         # 
								  Sout East Asian |         #
								 North East Asian |         #
							Southern and Central  |         #
										 Americas |         # 
										   Africa |        # 
							----------------------+--------------------------------------------------------------------------------------------------------------+----------
											Total |        # 	*/
						
						*Note: Parents have different COBs, indicating different merging.
						
						
						
						*Generate European flag (from either parent)
							tab european_f european_m,m

							/*			   |      european_m
								european_f |         0          1 |     Total
								-----------+----------------------+----------
										 0 |    # 
										 1 |     # 
								-----------+----------------------+----------
									 Total |    # */
							
							dis #+#+# //#
							
							gen european = 0
								replace european = 1 if european_f == 1
								replace european = 1 if european_m == 1 
								tab european,m

								/*	   european |      Freq.     Percent        Cum.
									------------+-----------------------------------
											  0 |     #
											  1 |      #							#% european
									------------+-----------------------------------
										  Total |     #      100.00			*/
									
									
									
						*Generate Asian flag (from either parent)
							tab asian_f asian_m,m

								/*			   |        asian_m
									   asian_f |         0          1 |     Total
									-----------+----------------------+----------
											 0 |    # 
											 1 |       # 
									-----------+----------------------+----------
										 Total |    # 	*/
							
							dis #+#+# //#
							
							gen asian = 0
								replace asian = 1 if asian_f == 1
								replace asian = 1 if asian_m == 1 
								tab asian,m

								/*		  asian |      Freq.     Percent        Cum.
									------------+-----------------------------------
											  0 |     #
											  1 |     #									#% asian (matches the above)
									------------+-----------------------------------
										  Total |     #      100.00				*/

						
			*-------------------------------*
			*	R1 - Obesity 				*
			*-------------------------------*
				
				tab bmicathy,m
				
				/*		Body mass index - measured |
						   - categories (Half year |
						   scale for children, 18+ |
											 for a |      Freq.     Percent        Cum.
						---------------------------+-----------------------------------
									Not applicable |        #
							   Underweight Class 3 |         #
							   Underweight Class 2 |         #
							   Underweight Class 1 |        #
									  Normal range |      #
						 Normal range (Adult only) |      #
										Overweight |      #
									 Obese Class 1 |      #
						Obese Class 2 (Adult only) |      #
						Obese Class 3 (Adult only) |        #
						---------------------------+-----------------------------------
											 Total |     #      100.00			*/

				gen R1_Obesity = .
					replace R1_Obesity = 0 if bmicathy != 0 //(# real changes made)
					replace R1_Obesity = 1 if (bmicathy>6 & bmicathy<=9) //(# real changes made)
					label values R1_Obesity yn
					label var R1_Obesity "Risk 1 - Obese (0=No,1=Yes)"
					
					tab bmicathy R1_Obesity,m //looks good (11.03.2022)
					
					*Check TableBuilder results
					tab age_45 R1_Obesity,m row nokey

					/*		   Age |
						   Group45 |
						   (1=<45, |
						  2=45-65, |   Risk 1 - Obese (0=No,1=Yes)
							 3>65) |        No        Yes          . |     Total
						-----------+---------------------------------+----------
							   <45 |    # 
								   |     # 
						-----------+---------------------------------+----------
							 45-65 |     # 
								   |     # 
						-----------+---------------------------------+----------
							   >65 |     # 
								   |     # 
						-----------+---------------------------------+----------
							 Total |    # 
								   |     #	*/
						
						/*45-65
							Table Builder:		#%
							DatabLab:			#%
							Conclusion:			Minor Difference - Indicator ok	(11.03.2022)			*/						
						
					tab R1_Obesity if age99 >=45,m 						

					/*		   Risk 1 - |
								  Obese |
							(0=No,1=Yes |
									  ) |      Freq.     Percent        Cum.
							------------+-----------------------------------
									 No |      #
									Yes |      #
							------------+-----------------------------------
								  Total |     #				*/
												
						/*>=45
							Table Builder: 		##.#%
							DatabLab:			#%
							Conclusion:										*/								   
	
	
			*-------------------------------*
			*	R2 - Physical Inactivity	*
			*-------------------------------*
				
				codebook pag65ov
				tab pag65ov,m

				/*		Physical Activity Guidelines 2014 - age |
												group 65+ years |      Freq.     Percent        Cum.
						----------------------------------------+-----------------------------------
												 Not applicable |     #
						Met 2014 physical activity guidelines f |        #
						Did not meet 2014 physical activity gui |      #
						Not known if met 2014 physical activity |        #0
						----------------------------------------+-----------------------------------
														  Total |     #      100.00			*/
				
				codebook pag18t64
				tab pag18t64,m
					
				/*		Physical Activity Guidelines 2014 - age |
											  group 18-64 years |      Freq.     Percent        Cum.
						----------------------------------------+-----------------------------------
												 Not applicable |      #
						Met 2014 physical activity guidelines f |      #
						Did not meet 2014 physical activity gui |     #
						Not known if met 2014 physical activity |         #
						----------------------------------------+-----------------------------------
														  Total |     #				*/
					
					
					*Check TableBuilder results
					tab pag65ov age_45 if pag65ov !=0,m col nokey										  
							
					/*			Physical Activity |  Age Group45 (1=<45,
							Guidelines 2014 - age |    2=45-65, 3>65)
								  group 65+ years |     45-65        >65 |     Total
							----------------------+----------------------+----------
							Met 2014 physical act |       # 
												  |     # 
							----------------------+----------------------+----------
							Did not meet 2014 phy |       # 
												  |     #
							----------------------+----------------------+----------
							Not known if met 2014 |         # 
												  |      #
							----------------------+----------------------+----------
											Total |       # 
												  |    100.00     100.00 |    100.00 	*/
												  
						/*>65
							Table Builder:		#%
							DatabLab:			#%
							Conclusion:			Looks good : ) (11.03.2022)	*/								
					
					*Check TableBuilder results
					tab pag18t64 age_45 if pag18t64 !=0 & age99!=65,m col nokey				
						
					/*			Physical Activity |  Age Group45 (1=<45,
							Guidelines 2014 - age |    2=45-65, 3>65)
								group 18-64 years |       <45      45-65 |     Total
							----------------------+----------------------+----------
							Met 2014 physical act |     # 
												  |     # 
							----------------------+----------------------+----------
							Did not meet 2014 phy |     # 
												  |     # 
							----------------------+----------------------+----------
							Not known if met 2014 |         #
												  |      # 
							----------------------+----------------------+----------
											Total |     # 
												  |    100.00     100.00 |    100.00 	*/
						
					gen R2_PhysInac = .							
						replace R2_PhysInac = 0 if age99 >=18 //(# real changes made)
						replace R2_PhysInac = . if pag18t64 == 0 & (age99 >=18 & age99<=64) //(# real changes made, # to missing)
							*Change to missing, people in the age group who had "not applicable"
						replace R2_PhysInac = . if pag65ov == 0 & (age99 >=65) //((# real changes made, # to missing) (as above)							
						
						tab age99 R2_PhysInac,m //# <=17 eyears are missing, and # people >=18 years
						
						replace R2_PhysInac = 1 if pag18t64 == 1 & R2_PhysInac == 0 //(# real changes made) (# Matches above)
						replace R2_PhysInac = 1 if pag65ov == 1 & (age99>=65) //(# real changes made) (# matches above)
							replace R2_PhysInac = 0 if (pag18t64 == 8 | pag65ov == 8) //Zero changes
						
						recode R2_PhysInac (0=1) (1=0)
						
						label values R2_PhysInac yn
						label var R2_PhysInac "Risk 2 - Phsyically Inactive (0=No, 1=Yes)"
						
						tab age99 R2_PhysInac if (age99>65),m //Looks good for >=65 (11.03.2022)
						tab R2_PhysInac if (age99>65)
						
						/*>65
							Table Builder:		#%
							DatabLab:			#%
							Conclusion:			Looks good : ) (11.03.2022) */	
							
						tab R2_PhysInac if (age99>=45)
						
						/*>=45
							Table Builder:		##.#%
							DatabLab:			#%
							Conclusion:			# */	
							
						
						tab R2_PhysInac if (age99>65),m //n=# missing
						tab R2_PhysInac if (age99>=45),m //n=# missing
						tab R2_PhysInac if (age99>=18),m //n=# missing
						*Conclusion - # ages 18+ have info about phsyical activity.
						
			*-------------------------------*
			*	R3 - Smoker					*
			*-------------------------------*						
				
				codebook smkstat
				tab smkstat,m		
				
					gen R3_Smoker = 0 if smkstat != 0 //(# missing values generated) as per codebook above
					replace R3_Smoker = 1 if smkstat == 1 //(# real changes made) as per codebook above
					
					label values R3_Smoker yn
					label var R3_Smoker "Risk 3 - Daily Smoker (0=No, 1=Yes)"
					
					tab R3_Smoker if age99 >=18 //DataLab=#%, TableBuilder=#% [Good! (11.03.2022)]
					tab R3_Smoker if age99 >65 //DataLab=#%, TableBuilder#% [Good! (11.03.2022)]	
					tab R3_Smoker if age99 >=45 //DataLab=#%, TableBuilder=##.#% Good
					
					
			*-------------------------------*
			*	R4 - Low Education			*
			*-------------------------------*							
			
				codebook highlvl
				tab highlvl
				tab highlvl,nolab

				/*		Level of highest educational attainment |      Freq.     Percent        Cum.
						----------------------------------------+-----------------------------------
												 Not Applicable |      #						[0]
											Postgraduate Degree |     #							[1]
						  Graduate Diploma/Graduate Certificate |        #						[2]
												Bachelor Degree |      #						[3]
									   Advanced Diploma/Diploma |      #						[4]
											Certificates III/IV |      #						[5]
														Year 12 |     #							[6]
														Year 11 |        #						[7]
														Year 10 |      #						[8]
											  Certificates I/II |         #						[9]
											   Year 9 and below |      #						[10]
								Certificate not further defined |         #						[11]
										   Level not determined |        #						[12]
						Never attended school and no non-school |         #						[13]
						----------------------------------------+-----------------------------------
														  Total |     #      100.00				*/
				
				
				*Did not complete Year 12 or equivalent
				gen R4_LowEduc_G12 = 0 if highlvl != 0 & highlvl ! = 12 /*& highlvl ! = 13*/ //(# missing values generated) (not applicable)
					replace R4_LowEduc_G12 = 1 if (highlvl >=7 & highlvl ! = 12) | highlvl == 13 //(# real changes made)
					label var R4_LowEduc_G12 "Risk 4 - Low Education (High School not complete 0=No, 1=Yes)"
					label values R4_LowEduc_G12 yn
					tab highlvl R4_LowEduc_G12,m 
					
					tab R4_LowEduc_G12 if (age99>=20 & age99<=44) //DataLab=#%, TableBuilder=#% [Some difference! (11.03.2022)] 
					tab R4_LowEduc_G12 if (age99>=45) //DataLab=#%, TableBuilder=###% [????] 
					tab R4_LowEduc_G12 if (age99>=45),m //n=# missing
						tab highlvl if R4_LowEduc_G12  == . & age99>=45,m //Level not determined
					
					
				*Year 9 an below
				tab edattaq1,m
				tab edattaq1,m nolab //Year 9 and below = value 5+
								
				gen R4_LowEduc_G8 = 0 if edattaq1 != 0 //(# missing values generated)
					replace R4_LowEduc_G8 = 1 if edattaq1 >=5 //(# real changes made)
					label var R4_LowEduc_G8 "Risk 4 - Low Education (Year 8 only 0=No, 1=Yes)"
					label values R4_LowEduc_G8 yn
										
					tab edattaq1 R4_LowEduc_G8,m

					/*						  |  Risk 4 - Low Education (Year 8
							  Highest year of |        only 0=No, 1=Yes)
							 school completed |        No        Yes          . |     Total
						----------------------+---------------------------------+----------
							   Not applicable |         # 
						Year 12 or equivalent |    # 
						Year 11 or equivalent |     # 
						Year 10 or equivalent |     #
						 Year 9 or equivalent |     # 
							  Year 8 or below |        #
						Never attended school |        # 
						----------------------+---------------------------------+----------
										Total |   # 	*/
				
					tab R4_LowEduc_G8 if age99 >=20 & age99<=40,m //DataLab=#%, TableBuilder=#% [close!] (11.03.2022) 
					tab age99 R4_LowEduc_G8 if age99 >=45,m
					tab R4_LowEduc_G8 if age99 >=45,m
											
					/*	   Risk 4 - |
								Low |
						  Education |
							(Year 8 |
						 only 0=No, |
							 1=Yes) |      Freq.     Percent        Cum.
						------------+-----------------------------------
								 No |      #
								Yes |      #
						------------+-----------------------------------
							  Total |      #			*/
						
						/*>=45
							Table Builder:		##.#%
							DatabLab:			#%
							Conclusion:			#? */						
					
			*---------------------------------------------------*
			*		Save variables of interest for merging		*
			*---------------------------------------------------*
			
				gen uniqueID = abshidd+abspid
				
				keep uniqueID abshidd age99 age_45 R1_Obesity R2_PhysInac R3_Smoker R4_LowEduc_G12 R4_LowEduc_G8 european asian /*Parental country of birth added April 2022*/

				save "P:\2_Data\_temp\nhs17sps_temp.dta",replace

		*=======================================*
		*		OPEN CONDITION LEVEL NHS DATA	*
		*=======================================*				
			
			use "nhs17con.dta",clear				
				gen uniqueID = abshidd+abspid
				codebook uniqueID //unique values:  #                   missing "":  #
					*Unique values - multiple lines (i.e., repeat information)
				
			*String version of all conditions
				decode evercddl, gen(evercddl_string)
				
			*Status of conditions
				codebook condstat
																  
				/*		tabulation:  Freq.   Numeric  Label
									 #         0  Not applicable
									#         1  Ever told has condition, still			THIS ONE
													  current and long-term
									 #         2  Ever told has condition, still
													  current but not long-term
									 #         3  Ever told has condition, not
													  current
									#         4  Not known or not ever told, but			THIS ONE
													  condition current and long-term
									 #         5  Never told, not current or
													  long-term
									 #         6  Condition current, but not known
													  or not ever told, and not long
													  term							*/
					  
			*-------------------------------*
			*	R5 - Diabetes				*
			*-------------------------------*	
			
				
			/*	codebook diabcurr
				tab diabcurr,m

				/*			Whether diabetes reported as |
												 current |      Freq.     Percent        Cum.
						---------------------------------+-----------------------------------
										  Not applicable |     #
							Diabetes reported as current |      #
						Diabetes reported as not current |         #
						---------------------------------+-----------------------------------
												   Total |     #      100.00			*/
				
				tab evercddl if strpos(evercddl_string,"Diab")

				/*						  Type of condition |      Freq.     Percent        Cum.
					----------------------------------------+-----------------------------------
								   Type A Diabetes mellitus |       #
								   Type B Diabetes mellitus |        #
							 Type unknown Diabetes mellitus |         #
					----------------------------------------+-----------------------------------
													  Total |      #      100.00			*/
				
				tab evercddl if strpos(evercddl_string,"Diab"),nolab //#
				
				gen diabcheck = 1 if (evercddl >=27 & evercddl<=29) & (condstat == 1 | condstat == 4) //curent and long term		
				tab diabcurr diabcheck,m
				tab condstat diabcurr,m	
				
				gen R5_Diabetes = 0
					replace R5_Diabetes = 1 if (evercddl >=27 & evercddl<=29) & (condstat == 1 | condstat == 4) //(# real changes made)
										
					tab R5_Diabetes,m	//Diaebtes flag, current and long term
					
					/*		R5_Diabetes |      Freq.     Percent        Cum.
							------------+-----------------------------------
									  0 |     #
									  1 |      #
							------------+-----------------------------------
								  Total |     #      100.00			*/		*/
								  
				gen R5_Diabetes = 0 if diabcurr != 0
					replace R5_Diabetes = 1 if (diabcurr == 1) //(# real changes made)								  
					tab R5_Diabetes,m
					tab R5_Diabetes
											
					/*	R5_Diabetes |      Freq.     Percent        Cum.
						------------+-----------------------------------
								  0 |        #
								  1 |      #
						------------+-----------------------------------
							  Total |      #      100.00			*/
										
			*-------------------------------*
			*	R6 - Hypertension			*
			*-------------------------------*		
							
				tab evercddl,m
				
				tab evercddl_string if strpos(evercddl_string,"Hyp") //This one for Hypertension
				tab evercddl if strpos(evercddl_string,"Hyp"), nolab //Number 88 is Hypertension				
				gen R6_Hypertension = 0 
					replace R6_Hypertension = 1 if (evercddl ==88) & (condstat == 1 | condstat == 4) //(# real changes made)
					
					tab R6_Hypertension,m
					
					/*		R6_Hyperten |
								   sion |      Freq.     Percent        Cum.
							------------+-----------------------------------
									  0 |     #
									  1 |      #
							------------+-----------------------------------
								  Total |     #      100.00				*/

							  
			*-------------------------------*
			*	R7 - Depression				*
			*-------------------------------*	
			
				tab evercddl_string if strpos(evercddl_string,"Dep") //This one for Depression
					tab evercddl if strpos(evercddl_string,"Dep"),nolab //Number 40
				tab evercddl_string if strpos(evercddl_string,"dep") //This one for Depression 
					tab evercddl if strpos(evercddl_string,"dep"),nolab //Number 35
			
				gen R7_Depression = 0 
					replace R7_Depression = 1 if (evercddl ==40 | evercddl == 35) & (condstat == 1 | condstat == 4) //(# real changes made)
					
					tab R7_Depression,m					

					/*	R7_Depressi |
								 on |      Freq.     Percent        Cum.
						------------+-----------------------------------
								  0 |     #
								  1 |      #
						------------+-----------------------------------
							  Total |     #      100.00			*/


					
			*-------------------------------*
			*	R8 - Hearing				*
			*-------------------------------*		
			
				tab evercddl_string if strpos(evercddl_string,"Hear") //None
				tab evercddl_string if strpos(evercddl_string,"hear")

				/*						  Type of condition |      Freq.     Percent        Cum.
					----------------------------------------+-----------------------------------
								 Abnormalities of heartbeat |          #
							 Other Ischaemic heart diseases |         #
									   Other heart diseases |         #
						Partial deafness & hearing loss nec |      #						- Use this one
					----------------------------------------+-----------------------------------
													  Total |      #      100.00			*/

					tab evercddl if strpos(evercddl_string,"hear"),nolab //Number 82						
	
				gen R8_Hearing_ICD = 0 
					replace R8_Hearing_ICD = 1 if (evercddl ==82) & (condstat == 1 | condstat == 4) //(# real changes made)
										
					tab R8_Hearing_ICD,m				

					/*		R8_Hearing_ |
									ICD |      Freq.     Percent        Cum.
							------------+-----------------------------------
									  0 |     #
									  1 |      #
							------------+-----------------------------------
								  Total |     #     100.00			*/
			
					
			*---------------------------------------------------*
			*			Final preparation for merging			*
			*---------------------------------------------------*
			
			keep uniqueID R5_Diabetes R6_Hypertension R7_Depression R8_Hearing_ICD
				collapse (sum) R5_Diabetes R6_Hypertension R7_Depression R8_Hearing_ICD, by(uniqueID)
				
				tab R5_Diabetes,m //n=# people had two types of diabetes
					replace R5_Diabetes = 1 if R5_Diabetes == 2 //(# real changes made)
						label var R5_Diabetes "Risk 5 - Diabetes (ICD) (0=No, 1=Yes)"
						label values R5_Diabetes yn
					
					tab R6_Hypertension,m //n=# person had two types of hypertension
						replace R6_Hypertension = 1 if R6_Hypertension == 2 //(# real change made)
						label var R6_Hypertension "Risk 6 - Hypertension (ICD) (0=No, 1=Yes)"
						label values R6_Hypertension yn
						
					tab R7_Depression,m //n=# people had multiple forms of depresison
						replace R7_Depression = 1 if R7_Depression == 2 //(# real changes made))
						label var R7_Depression "Risk 7 - Depression (ICD) (0=No, 1=Yes)"		
						label values R7_Depression yn
						
					tab R8_Hearing_ICD,m //n=# person had two types of hearing impairment
						replace R8_Hearing_ICD = 1 if R8_Hearing_ICD == 2 //(# real change made)
						label var R8_Hearing_ICD "Risk 8 - Hearing Impairment (ICD) (0=No, 1=Yes)"	
						label values R8_Hearing_ICD yn
						
				codebook uniqueID //unique values:  #                   missing "":  0/#
					*Ready for merging
					

				save "P:\2_Data\_temp\nhs17con_temp.dta",replace
				
					
					
		*=======================================*
		*	R9 - 	OPEN ALCOHOL DATA			*
		*=======================================*

			use "nhs17a14.dta",clear
			count //#
				
				gen uniqueID = abshidd+abspid
				codebook uniqueID //unique values:  #                   missing "":  #		
			
			tab totpal,m //Volume in last week, with numbers indicating none
				tab totpal, nolab //9995 =#, 9996 = #
				*drop if totpal == 9995 //(# observations deleted) //Did not consume alcohol in the last wee
					replace totpal = 0 if totpal == 9995 //(# real changes made) ZERO alcohol in the last week
					
				*drop if totpal == 9996 //(# observations deleted) //Have never consumed alcohol
					replace totpal = 0 if totpal == 9996 //(# real changes made) ZERO alcohol in the last week
					
				codebook uniqueID //unique values:  #                  missing "":  #				
							
			collapse (sum) totpal, by(uniqueID)
			codebook uniqueID //unique values:  #                   missing "":  # 
			codebook totpal //n=#  missing
			tabstat totpal, s(sum mean) //#
				
				
			gen R9_Alcohol = 0	
				replace R9_Alcohol = 1 if totpal >213 //(# real changes made)
				label var R9_Alcohol "Risk 9 - More than 213mls pure alcohol in past week (0=No, 1=Yes)"
				label values R9_Alcohol yn
				
				tabstat totpal, s(n min max sum) by(R9_Alcohol)
					
				/*	R9_Alcohol |         N       min       max       sum
					-----------+----------------------------------------
							 0 |     #
							 1 |      #
					-----------+----------------------------------------
						 Total |     #
					----------------------------------------------------		*/
				
			*---------------------------------------------------*
			*			Final preparation for merging			*
			*---------------------------------------------------*
				
				keep uniqueID R9_Alcohol
											
					codebook uniqueID //unique values:  #                    missing "":  #
						*Ready for merging
						
				save "P:\2_Data\_temp\nhs17a14_temp.dta",replace						
					
					
		*=======================================*
		*	R10 - 	SOCIAL ISOLATION			*
		*=======================================*				
				
				*Different Survey - can't use for communality calculations (leave as is)
					*use "R:\iss14e\ISS14E\STATA files\iss14ep.dta",clear
					*tab FACCONTD FREQCOFF,m
			
					
		*=======================================*
		*	R12 - 	AIR POLLUTION				*
		*=======================================*			
		
			use "nhs17hhd.dta", clear
			count //# lines of data (household level)
				
				gen uniqueID = abshidd+abspid
				codebook uniqueID //unique values:  #                   missing "":  #				
			
			
			codebook aria16
			tab aria16,m

			/*	  Remoteness area (ARIA) - ASGS |
										   2016 |      Freq.     Percent        Cum.
				--------------------------------+-----------------------------------
					  Major Cities of Australia |     #	-							 Use Major cities only (i.e. 0)
					   Inner Regional Australia |      #
					   Outer Regional Australia |      #
							   Remote Australia |        #
				--------------------------------+-----------------------------------
										  Total |     #			*/
														
								
			gen R12_Pollution = 0
				replace R12_Pollution = 1 if aria16 == 0 //(# real changes made)
				label var R12_Pollution "Risk 12 - Pollution exposure (0=No, 1=Yes)"
				label values R12_Pollution yn
			
				tab aria16 R12_Pollution,m //looks good
				tab R12_Pollution,m
				
				/*		  Risk 12 - |
						  Pollution |
						   exposure |
							 (0=No, |
							 1=Yes) |      Freq.     Percent        Cum.
						------------+-----------------------------------
								  0 |      #
								  1 |     #
						------------+-----------------------------------
							  Total |     #      100.00			*/

							  
				keep abshidd R12_Pollution
				save "P:\2_Data\_temp\nhs17hhd_temp.dta",replace						
								
			
		*=======================================*
		*			Merge Datasets				*
		*=======================================*	
		
			cd "P:\2_Data\_temp\"
				dir
				
				/*	 171.4k   3/11/22 15:09  nhs17a14_temp.dta 
					 982.5k   3/11/22 14:58  nhs17con_temp.dta 
					 290.2k   3/11/22 15:12  nhs17hhd_temp.dta 
					  64.8M   3/11/22 14:38  nhs17sps_temp.dta 	*/
		
			*Personal Identifiers (Risks 1-4)
				use "P:\2_Data\_temp\nhs17sps_temp.dta",clear
				codebook uniqueID //unique values: #                   missing "":  #
				
			*Condition levels (Risks 5-8)
				merge 1:1 uniqueID using "P:\2_Data\_temp\nhs17con_temp.dta"
			

				/*		Result                           # of obs.
						-----------------------------------------
						not matched                             #
						matched                            #  (_merge==3)
						-----------------------------------------	*/

					*All matched
						drop _merge
											
			*Alcohol Consumption
				merge 1:1 uniqueID using "P:\2_Data\_temp\nhs17a14_temp.dta"		

				/*		Result                           # of obs.
						-----------------------------------------
						not matched                         #
							from master                     #  (_merge==1)
							from using                          #  (_merge==2)

						matched                            #  (_merge==3)
						-----------------------------------------	*/
						
				*All valid responses merged (i.e., _merge ==2 from using merged)
					drop _merge
						
			*Air Pollution	
				merge m:1 abshidd using "P:\2_Data\_temp\nhs17hhd_temp.dta"					

			/*			Result                           # of obs.
						-----------------------------------------
						not matched                             #
						matched                            #  (_merge==3)
						-----------------------------------------	*/

					*All matched
						drop _merge
				
				order uniqueID abshidd age99 age_45 
		
			
			save "P:\2_Data\1_NHS_Risks.dta",replace

		
		capture log close
		log using "P:\3_Outputs\2_NHS\1_NHS_Proportions_MissingData.log",replace
		
		*=======================================*
		*	Compare Results with TableBuilder	*
		*=======================================*	
			
			use "P:\2_Data\1_NHS_Risks.dta",clear
			count //n=#
								
					*Obesity*
						qui tab R1_Obesity if age99>=45,m //DataLab=# TableBuilder=##.#% # 
						
					*Physical Inactivity
						qui tab R2_PhysInac if age99>=45 //DataLab=#%, TableBuilder=##.#%  
						
					*Smoker
						qui tab R3_Smoker if age99>=45 //DataLab=#, TableBuilder=##.#%   
											
					*Education
						qui tab R4_LowEduc_G12 if age99>=45  //DataLab=#%, TableBuilder=##.#%   						
					
					*Diabetes*
						qui tab R5_Diabetes if age99>=45,m  //DataLab=#%, TableBuilder=##.#%  
					
					*Hypertension
						qui tab R6_Hypertension if age99>=45,m  //DataLab=#%, TableBuilder=##.#%   					
					
					*Depression
						qui tab R7_Depression if age99>=45,m  //DataLab=#%, TableBuilder=##.#%  										
					
					*Hearing
						qui tab R8_Hearing_ICD if age99>=55,m  //DataLab=#%, TableBuilder=#%  	
			
					*Alcohol	
						qui tab R9_Alcohol if age99 >= 45  //DataLab=#%, TableBuilder#
						
						
		*=======================================*
		*			CHECK MISSING DATA			*
		*=======================================*				
				
				count //#
				misstable summ
				/*																	   Obs<.
																		+------------------------------
									   |                                | Unique
							  Variable |     Obs=.     Obs>.     Obs<.  | values        Min         Max
						  -------------+--------------------------------+------------------------------
							R1_Obesity |       #
						   R2_PhysInac |    #															- Due to younger age
							 R3_Smoker |    #
						  R4_LowEdu~12 |     #
						  R4_LowEduc~8 |     #
							R9_Alcohol |   	 #
						  -----------------------------------------------------------------------------	*/
				
				count if age99 >=18 //#
				misstable summ if age99 >=18

				/*					   |                                | Unique
							  Variable |     Obs=.     Obs>.     Obs<.  | values        Min         Max
						  -------------+--------------------------------+------------------------------
						  R4_LowEdu~12 |       #														- Level of education not determined.
						  -----------------------------------------------------------------------------	*/

				
				count if age99 >=45 //#
				misstable summ if age99 >=45
				
				/*																	   Obs<.
																		+------------------------------
									   |                                | Unique
							  Variable |     Obs=.     Obs>.     Obs<.  | values        Min         Max
						  -------------+--------------------------------+------------------------------
						  R4_LowEdu~12 |       #															- Level of education not determined.
						  -----------------------------------------------------------------------------	*/

			count //#
			save "P:\2_Data\2_NHS_Risks_Validated.dta",replace		
			capture log close
	
				
			capture log close
			log using "P:\3_Outputs\2_NHS\4.1_NHS_EuroAsian.log",replace			
		
	*===========================================================================*	
	*			EUROPEAN AND ASIAN ANCESTRY PREVALENCE - OUTPUT REQUEST			*
	*===========================================================================*	

				*=======================================*
				*		EUROPEAN ANCESTRY PREVALENCE	*
				*=======================================*	
					qui log off
					
					use "P:\2_Data\1_NHS_Risks.dta",clear
					count //#			
					
						qui keep if european == 1
							count //#
					
					qui log on										
							*tab R1_Obesity if age99>=45,m 		//E #%
							*tab R2_PhysInac if age99>=45,m		//E #%
							*tab R3_Smoker if age99>=45,m		//E #%
							*tab R4_LowEduc_G8 if age99>=45,m	//E #%
							*tab R5_Diabetes if age99>=45,m		//E #%
							*tab R6_Hypertension if age99>=45,m	//E #%
							*tab R7_Depression if age99>=45,m	//E #%
							*tab R8_Hearing_ICD if age99>=55,m	//E #%
							*tab R9_Alcohol if age99>=45,m		//E #%
							*tab R12_Pollution if age99>=45,m	//E #%
						
				*=======================================*
				*		ASIAN ANCESTRY PREVALENCE		*
				*=======================================*	
					qui log off	
				
					use "P:\2_Data\1_NHS_Risks.dta",clear
					count //#			
						
						qui keep if asian == 1
							count //#

					qui log on								
							*tab R1_Obesity if age99>=45,m 		//A #%
							*tab R2_PhysInac if age99>=45,m		//A #%
							*tab R3_Smoker if age99>=45,m		//A #%
							*tab R4_LowEduc_G8 if age99>=45,m	//A #%
							*tab R5_Diabetes if age99>=45,m		//A #%
							*tab R6_Hypertension if age99>=45,m	//A #%
							*tab R7_Depression if age99>=45,m	//A #%
							*tab R8_Hearing_ICD if age99>=55,m	//A #%
							*tab R9_Alcohol /*if age99>=45*/	//A #%
							*tab R12_Pollution if age99>=45,m	//A #%
			
					capture log close
					
					
			capture log close
			log using "P:\3_Outputs\2_NHS\4.2_NHS_EuroAsian (BackingData).log",replace			
							
	*===========================================================================*	
	*			EUROPEAN AND ASIAN ANCESTRY PREVALENCE - BACKING DATA			*
	*===========================================================================*					


	 *=======================================*
	 *               EUROPEAN ANCESTRY PREVALENCE    *
	 *=======================================*       
			 qui log off

					 *Early Life & All (>=45)
							 *tab R4_LowEduc_G8 if age99>=45,m                     //E 11.6%
							 *tab R8_Hearing_ICD if age99>=55,m                    //E 26.5%
							 
					 *Midlife (45-65)
							*tab R1_Obesity if (age99>=45 & age99<=65),m           //E 38.1%
							 *tab R6_Hypertension if (age99>=45 & age99<=65),m      //E 15.7%
							 *tab R9_Alcohol if (age99>=45 & age99<=65),m           //E 8.8%
					 
					*Late life (>65)
							 *tab R2_PhysInac if age99>=65,m                        //E 79.5%
							 *tab R3_Smoker if age99>=65,m                          //E 8.05%       
							*tab R5_Diabetes if age99>=65,m                         //E 14.2%       
							 *tab R7_Depression if age99>=65,m                      //E 6.6%        
							 *tab R12_Pollution if age99>=65,m                      //E 66.6%       
					 
	 *=======================================*
	 *               ASIAN ANCESTRY PREVALENCE               *
	 *=======================================*       
			 qui log off     

					 *Early Life & All (>=45)
							 *tab R4_LowEduc_G8 if age99>=45,m                       //A 8.8%
							 *tab R8_Hearing_ICD if age99>=55,m                      //A 19.47%
							 
					 *Midlife (45-65)
							 *tab R1_Obesity if (age99>=45 & age99<=65),m            //A 19.0%
							 *tab R6_Hypertension if (age99>=45 & age99<=65),m       //A 16.7%
							 *tab R9_Alcohol /*if age99>=45 & age99<=65)*/           //A 1.6%        NOTE
					 
					 *Late life (>65)
							 *tab R2_PhysInac if age99>=65,m                        //A 85.9%
							 *tab R3_Smoker if age99>=65,m                           //A 6.5%
							 *tab R5_Diabetes if age99>=65,m                        //A 24.1%
							 *tab R7_Depression if age99>=45,m                       //A 4.1%        NOTE
							 *tab R12_Pollution if age99>=65,m                         //A 82.4%

                                         capture log close

							
		*=======================================*
		*			DEFINE MODELS				*
		*=======================================*	
			use "P:\2_Data\2_NHS_Risks_Validated.dta",clear
			count //#
			*Model 2: Excluding LowEduc Grade12 and Hearing ICD
				global M2 R1_Obesity R2_PhysInac R3_Smoker /*R4_LowEduc_G12*/ R4_LowEduc_G8 R5_Diabetes R6_Hypertension R7_Depression R8_Hearing_ICD /*R8_Hearing_test*/ R9_Alcohol R12_Pollution

			
		*-------------------------------------------------------------------*
		*	FLAG COMPLETE RECORDS - STEP 1: COUNT NUMBER OF COMPLETE OBS	*
		*-------------------------------------------------------------------*
			
			foreach x of global M2 {
					tab `x' if age99 >=18,m	//No missing - it was only G12 after age 18, and I have removed G12 above.
					tab `x' if age99 >=40,m //""
					tab `x' if age99 >=45,m //""
			}
			
			foreach y in /*1*/ 2 /*3 4*/ {
					gen M`y'_temp = 0
				}
				
				/*			foreach y in 1 {					
								foreach x in $M1{
											tab `x',m
											replace M`y'_temp = M`y'_temp+1 if `x' !=.
								}
							}
				*/			
							foreach y in 2 {					
								foreach x in $M2 {
											tab `x',m
											replace M`y'_temp = M`y'_temp+1 if `x' !=.
								}
							}						
				/*		
							foreach y in 3 {					
								foreach x in $M3 {
											tab `x',m
											replace M`y'_temp = M`y'_temp+1 if `x' !=.
								}
							}							
						
							foreach y in 4 {					
								foreach x in $M4 {
											tab `x',m
											replace M`y'_temp = M`y'_temp+1 if `x' !=.
								}
							}													
					*/
					foreach x in /*M1_temp*/ M2_temp /*M3_temp M4_temp*/ {
							tab `x',m
					} 	

				/*		M2_temp |      Freq.     Percent        Cum.
					------------+-----------------------------------
							  5 |       #
							  6 |      #
							  9 |        #
							 10 |    #
					------------+-----------------------------------
						  Total |     #      100.00			*/
					
		*-------------------------------------------------------------------*
		*	FLAG COMPLETE RECORDS - STEP 2: CREATE SINGLE FLAG VARIABLE		*
		*-------------------------------------------------------------------*			
					
					
					foreach y in /*1*/ 2 /*3 4*/ {

						/*	gen M`y'_All = 0
								replace M`y'_All = 1 if M`y'_temp == 10
								tab M`y'_temp M`y'_All,m
								label var M`y'_All "Model `y': Complete records - All ages (0=Incomplete, 1=Complete)"
								label values M`y'_All yn	*/
								
							gen M`y'_18up = 0 if age99 >=18
								replace M`y'_18up = 1 if (M`y'_temp == 10 & age99 >=18)
								tab M`y'_temp M`y'_18up if age99 >=18,m	
								label var M`y'_18up "Model `y': Complete records - 18+ (0=Incomplete, 1=Complete)"
								label values M`y'_18up yn
								
							gen M`y'_40up = 0 if age99 >=40
								replace M`y'_40up = 1 if (M`y'_temp == 10 & age99 >=40)
								tab M`y'_temp M`y'_40up if age99 >=40,m	
								label var M`y'_40up "Model `y': Complete records - 40+ (0=Incomplete, 1=Complete)"
								label values M`y'_40 yn														
							
							gen M`y'_45up = 0 if age99 >=45
								replace M`y'_45up = 1 if (M`y'_temp == 10 & age99 >=45)
								tab M`y'_temp M`y'_45up if age99 >=45,m
								label var M`y'_45up "Model `y': Complete records - 45+ (0=Incomplete, 1=Complete)"
								label values M`y'_45up yn
							}
					
						
						*tab M2_18up,m //# records
						*tab M2_40up,m //# records
						tab M2_45up if age99 >=45,m //# records
						
						drop /*M1_temp*/ M2_temp /*M3_temp M4_temp*/

		capture log close
		log using "P:\3_Outputs\2_NHS\2_NHS_Observations_Matrices.log",replace						
						
		*===================================================*
		*	COUNT OF OBSERVATIONS FOR CORRELATION MATRICES	*
		*===================================================*				
					
				count //# observations (number of obs in the ALL models)
				count if age99>=18 //# observations (number of obs in the 18up models)
				count if age99>=40 //# observations (number of obs in the 18up models)
				count if age99>=45 //# observations (number of obs in the 45up models)
				
				foreach y in /*1*/ 2 /*3 4*/ {
					*tab M`y'_All
					tab M`y'_18up
					tab M`y'_40up
					tab M`y'_45up
					}
					
					
			capture log close
			
			save "P:\2_Data\_temp\NHS_AllAges.dta",replace
			
			
			
		*===================================================================*
		*	EXAMINE CROSSTABS OF UNDERLYING VARIABLES - TO CHECK RULE OF 10	*
		*===================================================================*				
								
			use "P:\2_Data\_temp\NHS_AllAges.dta",clear
			
				*Count of all the observations in 12 datasets (i.e., 3 age groups and 4 models in each group)
				
					foreach a in /*1*/ 2 /*3 4*/ 					{
						foreach b in /*All*/ 18up 40up 45up	{
						
							qui count if M`a'_`b' == 1
						
							dis "M`a'_`b': n=`r(N)'"
								}
							}			
			
			
				*This are the total number of participants in each model
				
							/*		M2_18up: n=#
									M2_40up: n=#
									M2_45up: n=#	*/

					
				*Create 3 log files to examine underlying crosstabs
				
					cd "P:\3_Outputs\2_NHS"
					
						foreach a in /*1*/ 2 /*3 4*/ 				{
							foreach b in /*All*/ 18up 40up 45up		{
									
									capture log close					
									
									log using "3.0_NHS_Crosstabs (`b'_M`a').log",replace	
										
										dis ""
										dis "===== This is a log file for `b' Ages - Correlation Matrix (Model) `a' ====="									
										dis ""
										
									qui log close
								
											}
										}
				
				*Populate these 12 log files with crosstab information
				
						foreach a in /*1*/ 2 /*3 4*/ 				{
							foreach b in /*All*/ 18up 40up 45up		{
								
								foreach x of global M`a'	{
								foreach y of global M`a'	{						
								
								qui log using "3.0_NHS_Crosstabs (`b'_M`a').log",append
								
									tab `x' `y' if M`a'_`b' == 1
								
									qui log close
								
											}
										}
									}			
								}	
							
						capture log close	
							
							
			
		*===================================================================*
		*	DO THE SAME IN AN EASIER TO READ WAY - USING COLLAPSE			*
		*===================================================================*								

			*This Look Covers Everything!
			foreach AGE in /*All*/ 18up 40up 45up {
			
				*-----------------------------------------------*
				*		INDIVIDUAL CROSSTABS - COLLAPSED		*
				*-----------------------------------------------*				
						
						cd "P:\2_Data\_temp\_crosstabs"
						use "P:\2_Data\_temp\NHS_AllAges.dta",clear

						foreach a in /*1*/ 2 /*3 4*/		{				
						
							foreach x of global M`a'	{
							foreach y of global M`a'	{	
						
							use "P:\2_Data\_temp\NHS_AllAges.dta",clear
						
							tab `x' `y' if M`a'_`AGE'==1, matcell(R)
							
								matrix list R	
								clear
								svmat double R, names(col)
								
								gen var = "`x'"

							gen order = _n					
								gen val = ""
								replace val = "No" if order==1
								replace val = "Yes" if order==2					
									drop order
							
							rename c1 `y'_No
							rename c2 `y'_Yes
							
							order var val
						
							list, noobs
							
							save `x'`y'_M`a'.dta,replace
							
								}
							}
						}
				
				*-----------------------------------------------*
				*			BASELINE FILES FOR MERGING			*
				*-----------------------------------------------*					
			
						foreach a in /*1*/ 2 /*3 4*/	{				
						
							foreach x of global M`a'	{				
						
								clear
								set obs 2				
								
								gen var = "`x'"
								
									gen order = _n					
										gen val = ""
										replace val = "No" if order==1
										replace val = "Yes" if order==2					
											drop order
											
											list,noobs
								
								save R0_`x'_M`a'.dta,replace
								
								}
							}
							
					
				*-----------------------------------------------*
				*					MERGE FILES					*
				*-----------------------------------------------*							
					
						clear
							
							foreach a in /*1*/ 2 /*3 4*/ {				
						
								foreach x of global M`a'	{	
									
									use "R0_`x'_M`a'.dta",clear

									list,noobs
			
										foreach y of global M`a'	{								
									
									merge 1:1 var val using "`x'`y'_M`a'.dta"
									drop _merge
									
									list,noobs
									
									save "`x'_M`a'_merged.dta",replace
									
									}
								}
							
							}
					
					
				*-----------------------------------------------*
				*					APPEND FILES				*
				*-----------------------------------------------*	

							foreach a in /*1*/ 2 /*3 4*/ {				
								
								clear
								set obs 1														
						
								foreach x of global M`a'	{	
									
									append using "`x'_M`a'_merged.dta"
									
									*Change redundant values to missing
										replace `x'_No = . if `x'_No[_n+1]==0 & val == "No"
											replace `x'_No = . if `x'_No == 0
										replace `x'_Yes = . if `x'_Yes[_n-1]==0 & val == "Yes"
											replace `x'_Yes = . if `x'_Yes == 0									
									
									*replace var = "`AGE'Ages_M`a'" if var == ""
									
									save "P:\3_Outputs\2_NHS\3.0_NHS_Crosstabs (`AGE'_M`a').dta",replace
								}
								
							}
							
			
						
				*-----------------------------------------------*
				*					CLEAN UP FILES				*
				*-----------------------------------------------*					

					*Individual files
						foreach a in /*1*/ 2 /*3 4*/		{				
						
							foreach x of global M`a'	{
							foreach y of global M`a'	{	
											
							rm "`x'`y'_M`a'.dta"
							
											}
										}
								}
						
						
					*Base files		
						foreach a in /*1*/ 2 /*3 4*/	{				
						
							foreach x of global M`a'	{
											
							rm "R0_`x'_M`a'.dta"
							rm "`x'_M`a'_merged.dta"
											}
										}
							
							
							}

			
		*===============================================*
		*	CORRELATION MATRICES  -	CASEWISE DELETION	*
		*===============================================*				
			
			use "P:\2_Data\_temp\NHS_AllAges.dta",clear
			count //#

		/*	capture log close
			log using "P:\3_Outputs\3.1_NHS_Correlations (All Ages).log",replace					
			*---------------------------------------------------*
			*						ALL AGES					*
			*---------------------------------------------------*	
			
				foreach x in /*M1*/ M2 /*M3 M4*/ {		
					
					dis ""
					dis "Model `x': All ages"
					dis "$`x'"
					qui tetrachoric $`x' 
						*dis "n="`r(N)'
						matrix define C=r(Rho)											
						pcamat C, n(#) forcepsd mineigen(1)
					}
																	*/
			capture log close
			log using "P:\3_Outputs\2_NHS\3.1_NHS_Correlations (18up).log",replace					
			*---------------------------------------------------*
			*						ADULTS (18+)				*
			*---------------------------------------------------*	
												
				keep if age99 >=18		
				count //#			
				
					foreach x in /*M1*/ M2 /*M3 M4*/ {		
						
						dis ""
						dis "Model `x': Adults 18+"
						dis "$`x'"
						qui tetrachoric $`x' 
							dis "n="`r(N)'						
							matrix define C=r(Rho)
							pcamat C, n(`r(N)') forcepsd mineigen(1)
							estat loadings, cnorm(eigen)				//Updated 29.03.2023							
					}
			
			capture log close
			log using "P:\3_Outputs\2_NHS\3.2_NHS_Correlations (40up).log",replace				

			*---------------------------------------------------*
			*					MIDDLEAGE (40+)					*
			*---------------------------------------------------*	
			
					keep if age99>=40 //(#observations deleted)
					count //#
					
				foreach x in /*M1*/ M2 /*M3 M4*/ {		
					
					dis ""
					dis "Model `x': Middle Age (40+)"
					dis "$`x'"
					qui tetrachoric $`x'
						dis "n="`r(N)'	
						matrix define C=r(Rho)
						pcamat C, n(`r(N)') forcepsd mineigen(1)
						estat loadings, cnorm(eigen)				//Updated 29.03.2023						
				}				
			
			
			capture log close
			log using "P:\3_Outputs\2_NHS\3.3_NHS_Correlations (45up).log",replace					
			
			*---------------------------------------------------*
			*					OLDER ADULTS (45+)				*
			*---------------------------------------------------*	
			
					keep if age99>=45 //(# observations deleted)
					count //#	
					
				foreach x in /*M1*/ M2 /*M3 M4*/ {		
					
					dis ""
					dis "Model `x': Older Adults (45+)"
					dis "$`x'"
					qui tetrachoric $`x'
						dis "n="`r(N)'	
						matrix define C=r(Rho)
						pcamat C, n(`r(N)') forcepsd mineigen(1)
						estat loadings, cnorm(eigen)				//Updated 29.03.2023						
				}						
						
				
				capture log close
				
				
				@@@ LE FIN @@@
				



	