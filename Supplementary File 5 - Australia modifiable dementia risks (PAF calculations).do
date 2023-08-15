	
	
	
	*==================================================================================*
	*	DEMENTIA POPULATION ATTRIBUTABLE FRACTIONS - VALIDATION OF PUBLISHED RESULTS   *
	*==================================================================================*
	
	/*	This .do file is deisgned to: 
			1. Crosscheck existing Dementia PAF analyses.
			2. Calculate dementia PAF for Australia overall, by ethnicity, and for First Nations Australians.
			
		*Author: Fintan Thompson (fintan.thompson@jcu.edu.au)
		*Date: 2022	*/
	
		
		*===========================================================================*
		*					STEP 1 - IMPORT AND PREPARE RAW DATA 					*
		*===========================================================================*	
		
			
			*-------------------------------------------*
			*	RELATIVE RISKS - LANCET 2017 & 2020 	*
			*-------------------------------------------*
				
				*These data are relative risks from the text and tables of the Lancet papers.
				
					*Lancet 2017: https://doi.org/10.1016/S0140-6736(17)31363-6 	(Table 1)
					*Lancet 2020: https://doi.org/10.1016/S0140-6736(20)30367-6 	(Table 1)
				
					
					*Relative Risks with TWO decimal places (note, these are different from the Lancet tables, which only have one decimal place)
					*These data also include the 'order' in which certain publications report findings (e.g., n2017).
					*The order allows for later sorting and ease of comparison of derived PAF here with published PAF estimates.
					
						tempfile LancetRR
								
							clear
							input double n2017 double n2020 double nAustralia str15 Risk double RR
							
								1 	1 	4	"Education"			1.59
								4 	2 	6	"Hearing"			1.94
								.	3 	.	"TBI"				1.84
								2 	4 	8	"Hypertension"		1.6
								.	5 	9	"Alcohol"			1.18
								3 	6 	1	"Obesity"			1.6
								5	7 	3	"Smoking"			1.6
								6	8 	7	"Depression"		1.9
								8	9 	10	"Social"			1.57
								7	10 	2	"Physical"			1.38
								9	11 	5	"Diabetes"			1.5
								.	12 	11	"Pollution"			1.1

								end
								
								format %-15s Risk
								format %-10.3g n* RR								
								
								save `LancetRR'			
							
							
				/*	*Relative Risks with ONE decimal place. 
					*These alternative RRs can be used to demonstrate that re-calculating published PAF results with abbreivated RRs can produce slightly different results.
						
						tempfile LancetRR
								
							clear
							input double n2017 double n2020 double nAustralia str15 Risk double RR
							
								1 	1 	4	"Education"			1.6
								4 	2 	6	"Hearing"			1.9
								.	3 	.	"TBI"				1.8
								2 	4 	8	"Hypertension"		1.6
								.	5 	9	"Alcohol"			1.2
								3 	6 	1	"Obesity"			1.6
								5	7 	3	"Smoking"			1.6
								6	8 	7	"Depression"		1.9
								8	9 	10	"Social"			1.6
								7	10 	2	"Physical"			1.4
								9	11 	5	"Diabetes"			1.5
								.	12 	11	"Pollution"			1.1								
								
								end
								
								format %-15s Risk
								format %-10.3g n* RR								
								
								save `LancetRR'						*/							
														
							
			*-----------------------------------------------*
			*	LANCET 2017 - PREVALENCE/COMMUNALITY/PAF 	*
			*-----------------------------------------------*		
			
				clear
				input str15 Risk double Prev double Comm double PAFn_pub double wPAFn_pub wPAF_pub

					Education		0.400	0.646	0.191		0.075	0.350
					Hypertension	0.089	0.573	0.051		0.020	0.350
					Obesity			0.034	0.604	0.020		0.008	0.350
					Hearing			0.317	0.461	0.230		0.091	0.350
					Smoking			0.274	0.511	0.139		0.055	0.350
					Depression		0.132	0.586	0.101		0.040	0.350
					Physical		0.177	0.266	0.065		0.026	0.350
					Social			0.11	0.459	0.059		0.023	0.350
					Diabetes		0.064	0.703	0.032		0.012	0.350
					
				end
				
				*Format varaibles
					format %-15s Risk
					format %-10.3g Prev-wPAF_pub		
				
				*Identify source data
					gen Source = "Lancet2017"
						order Source
				
				*Save as temporary file
					tempfile Lancet2017
					save `Lancet2017'		
				
				
				
				
			*-----------------------------------------------*
			*	LANCET 2020 - PREVALENCE/COMMUNALITY/PAF 	*
			*-----------------------------------------------*
				
				*These data are the prevalance of risk factors, communality, and unweighted PAF and weighted aPAF.
				*The RRs, prevalence and communality are used to derive PAF and aPAF, to compare with the published studies.
			
					clear
					input str15 Risk double Prev double Comm double PAFn_pub double wPAFn_pub wPAF_pub		
					
						Education		0.400	0.612	0.194	0.071	0.400
						Hearing			0.317	0.456	0.222	0.082	0.400
						TBI				0.121	0.552	0.092	0.034	0.400
						Hypertension	0.089	0.683	0.051	0.019	0.400
						Alcohol			0.118	0.733	0.021	0.008	0.400
						Obesity			0.034	0.585	0.02	0.007	0.400
						Smoking			0.274	0.623	0.141	0.052	0.400
						Depression		0.132	0.698	0.106	0.039	0.400
						Social			0.11	0.281	0.042	0.035	0.400
						Physical		0.177	0.552	0.096	0.016	0.400
						Diabetes		0.064	0.714	0.031	0.011	0.400
						Pollution		0.75	0.133	0.063	0.023	0.400
						
					end
					
					*Format varaibles
						format %-15s Risk
						format %-10.3g Prev-wPAF_pub		
					
					*Identify source data
						gen Source = "Lancet2020"
							order Source
					
					*Save as temporary file
						tempfile Lancet2020
						save `Lancet2020'			

						
			*-------------------------------------------*
			*			PREVALENCE - NZ 2021 			*
			*-------------------------------------------*				
					
					clear
					input str15 Risk double Prev double Comm double PAFn_pub double wPAFn_pub wPAF_pub	

						Education		0.310	0.49	0.157	0.046	0.477
						Hypertension	0.335	0.61	0.167	0.049	0.477
						Obesity			0.384	0.70	0.187	0.055	0.477
						Alcohol			0.098	0.74	0.019	0.006	0.477
						TBI				0.182	0.63	0.127	0.037	0.477
						Hearing			0.399	0.63	0.264	0.078	0.477
						Smoking			0.135	0.65	0.075	0.022	0.477
						Depression		0.191	0.65	0.147	0.043	0.477
						Physical		0.536	0.44	0.176	0.052	0.477
						Social			0.373	0.67	0.183	0.054	0.477
						Diabetes		0.116	0.59	0.055	0.016	0.477
						Pollution		0.717	0.81	0.067	0.019	0.477
						
						
					end
					
					*Format varaibles
						format %-15s Risk
						format %-10.3g Prev-wPAF_pub		
					
					*Identify source data
						gen Source = "NZ2021"
							order Source
					
					*Save as temporary file
						tempfile NZ2021
						save `NZ2021'									
						

			*-------------------------------------------------------*
			*	AUSTRALIA AGE GROUPS - PREVALENCE/COMMUNALITY/PAF 	*
			*-------------------------------------------------------*					
								
				*PAF - ALL OF AUSTRALIA (AGE GROUP SPECIFIC PREVALENCE ESTIMATES)
					clear
					input str15 Risk double Prev double Comm double PAFn_pub double wPAFn_pub wPAF_pub	
						
					Education		0.0998	0.6971	0.0556	0.0195	0.3820
					Hypertension	0.1719	0.5220	0.0935	0.0328	0.3820
					Obesity			0.3880	0.6769	0.1888	0.0662	0.3820
					Hearing			0.2656	0.5272	0.1998	0.0700	0.3820
					Smoking			0.0671	0.6988	0.0387	0.0136	0.3820
					Depression		0.1155	0.4240	0.0942	0.0330	0.3820
					Physical		0.8198	0.5800	0.2375	0.0832	0.3820
					Social			0.0522	0.5817	0.0289	0.0101	0.3820
					Diabetes		0.1679	0.5220	0.0775	0.0271	0.3820
					Alcohol			0.0821	0.6247	0.0146	0.0051	0.3820
					Pollution		0.6552	0.5445	0.0615	0.0215	0.3820

					end	
				
							*Format varaibles
								format %-15s Risk
								format %-10.3g Prev-wPAF_pub		
							
							*Identify source data
								gen Source = "Australia"
									order Source
							
							*Save as temporary file
								tempfile Australia
								save `Australia'		
							
							
				*PAF - EUROPEAN (AGE GROUP SPECIFIC PREVALENCE ESTIMATES)
					clear
					input str15 Risk double Prev double Comm double PAFn_pub double wPAFn_pub wPAF_pub	

					Education		0.1160	0.6971	0.0641	0.0223	0.3644
					Hypertension	0.1570	0.5220	0.0861	0.0299	0.3644
					Obesity			0.3810	0.6769	0.1861	0.0647	0.3644
					Hearing			0.2650	0.5272	0.1994	0.0693	0.3644
					Smoking			0.0805	0.6988	0.0461	0.0160	0.3644
					Depression		0.0660	0.4240	0.0561	0.0195	0.3644
					Physical		0.7950	0.5800	0.2320	0.0807	0.3644
					Social			0.0618	0.5817	0.0341	0.0118	0.3644
					Diabetes		0.1420	0.5220	0.0663	0.0231	0.3644
					Alcohol			0.0880	0.6247	0.0156	0.0054	0.3644
					Pollution		0.6660	0.5445	0.0624	0.0217	0.3644
						
					end	
				
							*Format varaibles
								format %-15s Risk
								format %-10.3g Prev-wPAF_pub		
							
							*Identify source data
								gen Source = "European"
									order Source
							
							*Save as temporary file
								tempfile European
								save `European'		
								
							
				*PAF - ASIAN (AGE GROUP SPECIFIC PREVALENCE ESTIMATES)
					clear
					input str15 Risk double Prev double Comm double PAFn_pub double wPAFn_pub wPAF_pub	

					Education		0.0880	0.6971	0.0494	0.0179	0.3364
					Hypertension	0.1670	0.5220	0.0911	0.0330	0.3364
					Obesity			0.1900	0.6769	0.1023	0.0371	0.3364
					Hearing			0.1947	0.5272	0.1547	0.0561	0.3364
					Smoking			0.0650	0.6988	0.0375	0.0136	0.3364
					Depression		0.0410	0.4240	0.0356	0.0129	0.3364
					Physical		0.8590	0.5800	0.2461	0.0892	0.3364
					Social			0.0453	0.5817	0.0252	0.0091	0.3364
					Diabetes		0.2410	0.5220	0.1075	0.0390	0.3364
					Alcohol			0.0160	0.6247	0.0029	0.0010	0.3364
					Pollution		0.8240	0.5445	0.0761	0.0276	0.3364

					end	
				
							*Format varaibles
								format %-15s Risk
								format %-10.3g Prev-wPAF_pub		
							
							*Identify source data
								gen Source = "Asian"
									order Source
							
							*Save as temporary file
								tempfile Asian
								save `Asian'								
													
							
				*PAF - FIRST NATIONS (AGE GROUP SPECIFIC PREVALENCE ESTIMATES)
					clear
					input str15 Risk double Prev double Comm double PAFn_pub double wPAFn_pub wPAF_pub						

					Education		0.2261	0.5989	0.1177	0.0378	0.4490
					Hypertension	0.2760	0.5144	0.1421	0.0457	0.4490
					Obesity			0.5157	0.6440	0.2363	0.0760	0.4490
					Hearing			0.2920	0.6010	0.2154	0.0693	0.4490
					Smoking			0.1955	0.7271	0.1050	0.0338	0.4490
					Depression		0.1173	0.6635	0.0955	0.0307	0.4490
					Physical		0.8552	0.5132	0.2453	0.0789	0.4490
					Social			0.0433	0.5740	0.0241	0.0077	0.4490
					Diabetes		0.3771	0.5878	0.1586	0.0510	0.4490
					Alcohol			0.1289	0.4485	0.0227	0.0073	0.4490
					Pollution		0.3487	0.4413	0.0337	0.0108	0.4490

					end	
				
							*Format varaibles
								format %-15s Risk
								format %-10.3g Prev-wPAF_pub		
							
							*Identify source data
								gen Source = "FirstNations"
									order Source
							
							*Save as temporary file
								tempfile FirstNations
								save `FirstNations'		
																			
		
		*===========================================================================*
		*					STEP 2 - DEMENTIA PAF CALCULATIONS	 					*
		*===========================================================================*			

			*-----------------------------------------------------------*
			*	LOAD EACH DATASET AND MERGE WITH THE LANCET 2020 RRs 	*
			*-----------------------------------------------------------*		
					
				*A loop will run through these temporary datasets
					local source Lancet2017 Lancet2020 NZ2021 Australia FirstNations European Asian
						
					foreach x of local source {
						clear
						*Load data	
							use ``x''
						
						*Merge in Lancet Relative Risk estimates, from both 2017 and 2020 publications.
							merge 1:1 Risk using `LancetRR'
							drop if _merge !=3
							drop _merge
						
							order n* Source Risk RR			
							format Prev Comm PAFn_pub wPAFn_pub %10.3f						//Format to 3 decimal places

			*-----------------------------------------------------------------------------------*
			*	CALCULATE: 1) INDIVIDUAL PAF, 2) TOTAL WEIGHTED PAF, 3) INDIVIDUAL WEIGHTED PAF	*
			*-----------------------------------------------------------------------------------*												  
						
				/*The supplementary file of the 2020 Lancet report details the formulas and methods for these calculations.
					2020 Report: 				https://www.thelancet.com/article/S0140-6736(20)30367-6/fulltext
					Supplementary material: 	https://www.thelancet.com/cms/10.1016/S0140-6736(20)30367-6/attachment/cee43a30-904b-4a45-a4e5-afe48804398d/mmc1.pdf
						
					*------------------------------------------------------------------------------------------------*
					*	Box 1. Standard method for calculation of population attributable fraction and communality3	 *
					*------------------------------------------------------------------------------------------------*
						
						1)	INDIVIDUAL PAF
							
							Formula for individual Population Attributable Fraction (PAF)
								PAF = Pe (RRe-1) / [1 + Pe (RRe-1)]
								Pe = prevalence of the exposure
								RRe = relative risk of disease due to that exposure

							Calculation of overall Population Attributable Fraction (PAF)			
							We then calculated overall PAF: PAF = 1-[(1-PAF1)(1-PAF2)(1-PAF3)…] 						
							
							### Stata author's note: This calculation is not published or included in weighted analyses, so is not included in this .do file ###.
							
						2) TOTAL WEIGHTED PAF
						
							Each individual risk factor’s PAF was weighted according to its communality using the formula:
								Weight (w) = 1-communality
							
							Weighting was included in the calculation of overall PAF using the formula:
								PAF = 1-[(1-w*PAF1)(1-w*PAF2)(1-w*PAF3)...]							
						
						
						3) INDIVIDUAL WEIGHTED PAF
						
							To get individual weighted PAF from the overall PAF, we used the formula below:
							Individual weighted PAF = Individual PAF/Σ(Individual PAF)* Overall PAF. 		*/
					
					*------------------------------------------------------------------------------------------------*					
					
					
						*1) INDIVIDUAL PAF
							gen PAFn = (Prev*(RR-1))/(1+Prev*(RR-1))						//Individual (n) PAF based on Levin's formula [PAF = Pe (RRe-1) / [1 + Pe (RRe-1)]
							format PAFn %10.3f												//Format to 3 decimal places				
							order PAFn, a(Comm)												//Order after Communality
						
						
						*2) TOTAL WEIGHTED PAF												///PAF = 1-[(1-w*PAF1)(1-w*PAF2)(1-w*PAF3)
						
							gen w = 1-Comm													//Each individual risk factor’s PAF was weighted according to its communality using the formula:
																							//Weight (w) = 1-communality
							
							gen wPAFn =w*PAFn												//This is the first part of the formula above (w*PAF1)
								drop w
							
							order wPAFn, a(PAFn)											//Order after derived unweighted individual PAF
		
							gen wPAFn_m1 = 1-wPAFn 											//This is the second part of the formual above (1-wPAF1)
																							//Otherwise said, all Weighted PAFs substracted from one (i.e., 1-PAF)
							
							*Sequentially multiply the individual Weighted PAFs 			[(1-w*PAF1)(1-w*PAF2)(1-w*PAF3)]
							gen double wPAF = wPAFn_m1[1] 									//Set base for total weighted PAF
							replace wPAF = wPAF[_n-1] * wPAFn_m1 if _n > 1					//Progressive multiplication of values (as per the formula above)
							
							replace wPAF = (1-wPAF[_N])										//Set total weighted PAF as 1-last value (indicated here by _N)
								drop wPAFn_m1 wPAFn 										//Drop the base PAF and earlier individual weighted PAF.
						
						*3) INDIVIDUAL WEIGHTED PAF
						
							*“Individual weighted PAF = Individual PAF/Σ(Individual PAF)* Overall PAF.”
								
							*Sum individual PAFs	
								egen sPAF=sum(PAFn)											//Sum individual
								
								gen wPAFn = (PAFn/sPAF)*wPAF								//Individual PAF, divided by sum of individual PAFs, multiply by total weighted PAF
								format wPAFn %10.3f									
						
								drop sPAF													//drop the sum of individual PAFs
						
								*Multiply all variables by 100 for comparison with publications
									foreach var of varlist Prev-wPAFn	{
										replace `var' = `var'*100
										format `var' %4.1f 
								
										}

										order wPAFn wPAF, a(PAFn)
				
		*===========================================================================*
		*						STEP 3 - VARIABLE ORGANSING	 						*
		*===========================================================================*						
		

				*Rename variables for legibility
					rename Prev Prevalence
					rename Comm Communality
					rename PAFn PAF_Unweighted
					rename wPAFn PAF_Weighted
					rename wPAF PAF_TotalWeighted
					rename PAFn_pub PAF_Unweighted_Pub
					rename wPAFn_pub PAF_Weighted_Pub
					rename wPAF_pub PAF_Total_Pub

				*Label vars
					label var Risk "Risk factor"
					label var RR "Relative Risk"
					label var Prevalence "Prevalence (%)"
					label var Communality "Communality (%)"
					label var PAF_Unweighted "Individual PAF - Unweighted"
					label var PAF_Weighted "Individual PAF - Weighted"
					label var PAF_TotalWeighted "Total PAF - Weighted"
					label var PAF_Unweighted_Pub "Individual PAF - Unweighted Published"
					label var PAF_Weighted_Pub "Individual PAF - Weighted Published"
					label var PAF_Total_Pub "Total PAF - Weighted Published"
					 
					if Source == "Lancet2017" {
						sort n2017 
						}				
					else if Source == "Lancet2020"  {
					   sort n2020 
					   }
					else if Source == "NZ2021"  {
					   sort n2020 
					   }
					else if Source == "Australia"  {
						sort nAustralia
					   }
					else if Source == "European"  {
						sort nAustralia
					   }					   
					else if Source == "Asian"  {
						sort nAustralia
					   }					   
					else if Source == "FirstNations"  {
						sort nAustralia
					   }					   
					drop n*						
						
						tempfile `x'_Table
						save ``x'_Table'
					}
				macro list
				
		*===========================================================================*
		*				STEP 4 - PRESENT FINAL VALIDTAED TABLES	 					*
		*===========================================================================*					
					
					foreach x in Lancet2017_Table Lancet2020_Table NZ2021_Table Australia_Table European_Table Asian_Table FirstNations_Table {
						clear
						use ``x''
						
						dis ""
						dis "`x' - Comparison of derived and published PAF results"
						list, noobs ab(15) sep(20) 
						
						}
									
				@@@ LE FIN @@@
						
			
		*===================================================================*
		*				PRESENTATION OF RESULTS AND COMMENTS	 			*
		*===================================================================*				
			
			
			*-----------------------------------------------------------*
			*			RELATIVE RISKS - TWO DECIMAL PLACES 			*
			*-----------------------------------------------------------*	
			
						
			/*		Lancet2017_Table - Comparison of derived and published PAF results

					  +-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
					  |     Source   Risk           RR     Prevalence   Communality   PAF_Unweighted   PAF_Weighted   PAF_TotalWeig~d   PAF_Unweighte~b   PAF_Weighted_~b   PAF_Total_Pub |
					  |-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
					  | Lancet2017   Education      1.59         40.0          64.6             19.1            7.6              35.4              19.1               7.5            35.0 |
					  | Lancet2017   Hypertension   1.6           8.9          57.3              5.1            2.0              35.4               5.1               2.0            35.0 |
					  | Lancet2017   Obesity        1.6           3.4          60.4              2.0            0.8              35.4               2.0               0.8            35.0 |
					  | Lancet2017   Hearing        1.94         31.7          46.1             23.0            9.1              35.4              23.0               9.1            35.0 |
					  | Lancet2017   Smoking        1.6          27.4          51.1             14.1            5.6              35.4              13.9               5.5            35.0 |
					  | Lancet2017   Depression     1.9          13.2          58.6             10.6            4.2              35.4              10.1               4.0            35.0 |
					  | Lancet2017   Physical       1.38         17.7          26.6              6.3            2.5              35.4               6.5               2.6            35.0 |
					  | Lancet2017   Social         1.57         11.0          45.9              5.9            2.3              35.4               5.9               2.3            35.0 |
					  | Lancet2017   Diabetes       1.5           6.4          70.3              3.1            1.2              35.4               3.2               1.2            35.0 |
					  +-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
						
						*Author comment: There are very minor differences between derived and published PAF. Differences likely due to rounding.
						
					Lancet2020_Table - Comparison of derived and published PAF results

					  +-------------------------------------------------------------------------------------------------------------------------------------------------------------------+
					  |     Source   Risk           RR     Prevalence   Communality   PAF_Unweighted   PAF_Weighted   PAF_TotalWeig~d   PAF_Unweighte~b   PAF_Weighted_~b   PAF_Total_Pub |
					  |-------------------------------------------------------------------------------------------------------------------------------------------------------------------|
					  | Lancet2020   Education      1.59         40.0          61.2             19.1            7.1              40.1              19.4               7.1            40.0 |
					  | Lancet2020   Hearing        1.94         31.7          45.6             23.0            8.6              40.1              22.2               8.2            40.0 |
					  | Lancet2020   TBI            1.84         12.1          55.2              9.2            3.4              40.1               9.2               3.4            40.0 |
					  | Lancet2020   Hypertension   1.6           8.9          68.3              5.1            1.9              40.1               5.1               1.9            40.0 |
					  | Lancet2020   Alcohol        1.18         11.8          73.3              2.1            0.8              40.1               2.1               0.8            40.0 |
					  | Lancet2020   Obesity        1.6           3.4          58.5              2.0            0.7              40.1               2.0               0.7            40.0 |
					  | Lancet2020   Smoking        1.6          27.4          62.3             14.1            5.3              40.1              14.1               5.2            40.0 |
					  | Lancet2020   Depression     1.9          13.2          69.8             10.6            4.0              40.1              10.6               3.9            40.0 |
					  | Lancet2020   Social         1.57         11.0          28.1              5.9            2.2              40.1               4.2               3.5            40.0 |
					  | Lancet2020   Physical       1.38         17.7          55.2              6.3            2.4              40.1               9.6               1.6            40.0 |
					  | Lancet2020   Diabetes       1.5           6.4          71.4              3.1            1.2              40.1               3.1               1.1            40.0 |
					  | Lancet2020   Pollution      1.1          75.0          13.3              7.0            2.6              40.1               6.3               2.3            40.0 |
					  +-------------------------------------------------------------------------------------------------------------------------------------------------------------------+

						*Author comment: There are a few notable differences between derived and published PAF (e.g., social isolation & physical activity).
						*It's unclear why these differences exisit and could be due to single and double digit RRs being used inconsistently.
						*However, the total weighted PAFs are almost identical (i.e., 40.1 and 40.0).
					  
					NZ2021_Table - Comparison of derived and published PAF results

					  +---------------------------------------------------------------------------------------------------------------------------------------------------------------+
					  | Source   Risk           RR     Prevalence   Communality   PAF_Unweighted   PAF_Weighted   PAF_TotalWeig~d   PAF_Unweighte~b   PAF_Weighted_~b   PAF_Total_Pub |
					  |---------------------------------------------------------------------------------------------------------------------------------------------------------------|
					  | NZ2021   Education      1.59         31.0          49.0             15.5            4.5              47.4              15.7               4.6            47.7 |
					  | NZ2021   Hearing        1.94         39.9          63.0             27.3            8.0              47.4              26.4               7.8            47.7 |
					  | NZ2021   TBI            1.84         18.2          63.0             13.3            3.9              47.4              12.7               3.7            47.7 |
					  | NZ2021   Hypertension   1.6          33.5          61.0             16.7            4.9              47.4              16.7               4.9            47.7 |
					  | NZ2021   Alcohol        1.18          9.8          74.0              1.7            0.5              47.4               1.9               0.6            47.7 |
					  | NZ2021   Obesity        1.6          38.4          70.0             18.7            5.5              47.4              18.7               5.5            47.7 |
					  | NZ2021   Smoking        1.6          13.5          65.0              7.5            2.2              47.4               7.5               2.2            47.7 |
					  | NZ2021   Depression     1.9          19.1          65.0             14.7            4.3              47.4              14.7               4.3            47.7 |
					  | NZ2021   Social         1.57         37.3          67.0             17.5            5.1              47.4              18.3               5.4            47.7 |
					  | NZ2021   Physical       1.38         53.6          44.0             16.9            5.0              47.4              17.6               5.2            47.7 |
					  | NZ2021   Diabetes       1.5          11.6          59.0              5.5            1.6              47.4               5.5               1.6            47.7 |
					  | NZ2021   Pollution      1.1          71.7          81.0              6.7            2.0              47.4               6.7               1.9            47.7 |
					  +---------------------------------------------------------------------------------------------------------------------------------------------------------------+
		
						*Author comment: There are a few minor differences, likely due to rounding. When single digit RRs are used (see end of .do file), there are almost no differences.
						
						
			*-----------------------------------------------------------*
			*		RELATIVE RISKS - ONE DECIMAL PLACE	(NZ ONLY)		*
			*-----------------------------------------------------------*					
		
								
					*NZ2021_Table - Comparison of derived and published PAF results			

					  +--------------------------------------------------------------------------------------------------------------------------------------------------------------+
					  | Source   Risk           RR    Prevalence   Communality   PAF_Unweighted   PAF_Weighted   PAF_TotalWeig~d   PAF_Unweighte~b   PAF_Weighted_~b   PAF_Total_Pub |
					  |--------------------------------------------------------------------------------------------------------------------------------------------------------------|
					  | NZ2021   Education      1.6         31.0          49.0             15.7            4.6              47.6              15.7               4.6            47.7 |
					  | NZ2021   Hearing        1.9         39.9          63.0             26.4            7.7              47.6              26.4               7.8            47.7 |
					  | NZ2021   TBI            1.8         18.2          63.0             12.7            3.7              47.6              12.7               3.7            47.7 |
					  | NZ2021   Hypertension   1.6         33.5          61.0             16.7            4.9              47.6              16.7               4.9            47.7 |
					  | NZ2021   Alcohol        1.2          9.8          74.0              1.9            0.6              47.6               1.9               0.6            47.7 |
					  | NZ2021   Obesity        1.6         38.4          70.0             18.7            5.5              47.6              18.7               5.5            47.7 |
					  | NZ2021   Smoking        1.6         13.5          65.0              7.5            2.2              47.6               7.5               2.2            47.7 |
					  | NZ2021   Depression     1.9         19.1          65.0             14.7            4.3              47.6              14.7               4.3            47.7 |
					  | NZ2021   Social         1.6         37.3          67.0             18.3            5.4              47.6              18.3               5.4            47.7 |
					  | NZ2021   Physical       1.4         53.6          44.0             17.7            5.2              47.6              17.6               5.2            47.7 |
					  | NZ2021   Diabetes       1.5         11.6          59.0              5.5            1.6              47.6               5.5               1.6            47.7 |
					  | NZ2021   Pollution      1.1         71.7          81.0              6.7            2.0              47.6               6.7               1.9            47.7 |
					  +--------------------------------------------------------------------------------------------------------------------------------------------------------------+
								
						*Author comment: When single decimal RRs are used, the derived and published results are almost identical.							
						
						
			*-----------------------------------------------------------*
			*	CURRENT STUDY - COMPARISON WITH EXCEL FILE RESULTS		*
			*-----------------------------------------------------------*							
									
				Australia_Table - Comparison of derived and published PAF results

				  +------------------------------------------------------------------------------------------------------------------------------------------------------------------+
				  |    Source   Risk           RR     Prevalence   Communality   PAF_Unweighted   PAF_Weighted   PAF_TotalWeig~d   PAF_Unweighte~b   PAF_Weighted_~b   PAF_Total_Pub |
				  |------------------------------------------------------------------------------------------------------------------------------------------------------------------|
				  | Australia   Obesity        1.6          38.8          67.7             18.9            6.6              38.2              18.9               6.6            38.2 |
				  | Australia   Physical       1.38         82.0          58.0             23.8            8.3              38.2              23.8               8.3            38.2 |
				  | Australia   Smoking        1.6           6.7          69.9              3.9            1.4              38.2               3.9               1.4            38.2 |
				  | Australia   Education      1.59         10.0          69.7              5.6            1.9              38.2               5.6               1.9            38.2 |
				  | Australia   Diabetes       1.5          16.8          52.2              7.7            2.7              38.2               7.8               2.7            38.2 |
				  | Australia   Hearing        1.94         26.6          52.7             20.0            7.0              38.2              20.0               7.0            38.2 |
				  | Australia   Depression     1.9          11.6          42.4              9.4            3.3              38.2               9.4               3.3            38.2 |
				  | Australia   Hypertension   1.6          17.2          52.2              9.3            3.3              38.2               9.3               3.3            38.2 |
				  | Australia   Alcohol        1.18          8.2          62.5              1.5            0.5              38.2               1.5               0.5            38.2 |
				  | Australia   Social         1.57          5.2          58.2              2.9            1.0              38.2               2.9               1.0            38.2 |
				  | Australia   Pollution      1.1          65.5          54.4              6.1            2.2              38.2               6.2               2.1            38.2 |
				  +------------------------------------------------------------------------------------------------------------------------------------------------------------------+

				European_Table - Comparison of derived and published PAF results

				  +-----------------------------------------------------------------------------------------------------------------------------------------------------------------+
				  |   Source   Risk           RR     Prevalence   Communality   PAF_Unweighted   PAF_Weighted   PAF_TotalWeig~d   PAF_Unweighte~b   PAF_Weighted_~b   PAF_Total_Pub |
				  |-----------------------------------------------------------------------------------------------------------------------------------------------------------------|
				  | European   Obesity        1.6          38.1          67.7             18.6            6.5              36.4              18.6               6.5            36.4 |
				  | European   Physical       1.38         79.5          58.0             23.2            8.1              36.4              23.2               8.1            36.4 |
				  | European   Smoking        1.6           8.1          69.9              4.6            1.6              36.4               4.6               1.6            36.4 |
				  | European   Education      1.59         11.6          69.7              6.4            2.2              36.4               6.4               2.2            36.4 |
				  | European   Diabetes       1.5          14.2          52.2              6.6            2.3              36.4               6.6               2.3            36.4 |
				  | European   Hearing        1.94         26.5          52.7             19.9            6.9              36.4              19.9               6.9            36.4 |
				  | European   Depression     1.9           6.6          42.4              5.6            1.9              36.4               5.6               1.9            36.4 |
				  | European   Hypertension   1.6          15.7          52.2              8.6            3.0              36.4               8.6               3.0            36.4 |
				  | European   Alcohol        1.18          8.8          62.5              1.6            0.5              36.4               1.6               0.5            36.4 |
				  | European   Social         1.57          6.2          58.2              3.4            1.2              36.4               3.4               1.2            36.4 |
				  | European   Pollution      1.1          66.6          54.4              6.2            2.2              36.4               6.2               2.2            36.4 |
				  +-----------------------------------------------------------------------------------------------------------------------------------------------------------------+

				Asian_Table - Comparison of derived and published PAF results

				  +---------------------------------------------------------------------------------------------------------------------------------------------------------------+
				  | Source   Risk           RR     Prevalence   Communality   PAF_Unweighted   PAF_Weighted   PAF_TotalWeig~d   PAF_Unweighte~b   PAF_Weighted_~b   PAF_Total_Pub |
				  |---------------------------------------------------------------------------------------------------------------------------------------------------------------|
				  |  Asian   Obesity        1.6          19.0          67.7             10.2            3.7              33.6              10.2               3.7            33.6 |
				  |  Asian   Physical       1.38         85.9          58.0             24.6            8.9              33.6              24.6               8.9            33.6 |
				  |  Asian   Smoking        1.6           6.5          69.9              3.8            1.4              33.6               3.8               1.4            33.6 |
				  |  Asian   Education      1.59          8.8          69.7              4.9            1.8              33.6               4.9               1.8            33.6 |
				  |  Asian   Diabetes       1.5          24.1          52.2             10.8            3.9              33.6              10.8               3.9            33.6 |
				  |  Asian   Hearing        1.94         19.5          52.7             15.5            5.6              33.6              15.5               5.6            33.6 |
				  |  Asian   Depression     1.9           4.1          42.4              3.6            1.3              33.6               3.6               1.3            33.6 |
				  |  Asian   Hypertension   1.6          16.7          52.2              9.1            3.3              33.6               9.1               3.3            33.6 |
				  |  Asian   Alcohol        1.18          1.6          62.5              0.3            0.1              33.6               0.3               0.1            33.6 |
				  |  Asian   Social         1.57          4.5          58.2              2.5            0.9              33.6               2.5               0.9            33.6 |
				  |  Asian   Pollution      1.1          82.4          54.4              7.6            2.8              33.6               7.6               2.8            33.6 |
				  +---------------------------------------------------------------------------------------------------------------------------------------------------------------+

				FirstNations_Table - Comparison of derived and published PAF results

				  +---------------------------------------------------------------------------------------------------------------------------------------------------------------------+
				  |       Source   Risk           RR     Prevalence   Communality   PAF_Unweighted   PAF_Weighted   PAF_TotalWeig~d   PAF_Unweighte~b   PAF_Weighted_~b   PAF_Total_Pub |
				  |---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
				  | FirstNations   Obesity        1.6          51.6          64.4             23.6            7.6              44.9              23.6               7.6            44.9 |
				  | FirstNations   Physical       1.38         85.5          51.3             24.5            7.9              44.9              24.5               7.9            44.9 |
				  | FirstNations   Smoking        1.6          19.6          72.7             10.5            3.4              44.9              10.5               3.4            44.9 |
				  | FirstNations   Education      1.59         22.6          59.9             11.8            3.8              44.9              11.8               3.8            44.9 |
				  | FirstNations   Diabetes       1.5          37.7          58.8             15.9            5.1              44.9              15.9               5.1            44.9 |
				  | FirstNations   Hearing        1.94         29.2          60.1             21.5            6.9              44.9              21.5               6.9            44.9 |
				  | FirstNations   Depression     1.9          11.7          66.3              9.5            3.1              44.9               9.6               3.1            44.9 |
				  | FirstNations   Hypertension   1.6          27.6          51.4             14.2            4.6              44.9              14.2               4.6            44.9 |
				  | FirstNations   Alcohol        1.18         12.9          44.9              2.3            0.7              44.9               2.3               0.7            44.9 |
				  | FirstNations   Social         1.57          4.3          57.4              2.4            0.8              44.9               2.4               0.8            44.9 |
				  | FirstNations   Pollution      1.1          34.9          44.1              3.4            1.1              44.9               3.4               1.1            44.9 |
				  +---------------------------------------------------------------------------------------------------------------------------------------------------------------------+
									
					*/
				