
*===============================================================================*
*		Dementia Populationa Attributable Fraction (PAF) - Australia			*
*						Preparation of Indicators								*
*							All Australians										*
*===============================================================================*

		
		*-------------------------------*
		*	Examine avaialble datasets	*
		*-------------------------------*
			cd "R:\nhs17d-g\NHS17D_G"			
			dir

		*=======================================*
		*	OPEN INDIVIDUAL LEVEL NHS DATA		*
		*=======================================*

			use "nhs17sps.dta", clear
			codebook abspid //# unique values
				
			*Use codes from both Father and Mother COB to create master list	
				preserve
					keep cobfcddl 
					rename cobfcddl cob
					
					tempfile cob
					save `cob'
				restore	
					
					keep cobmcddl
					rename cobmcddl cob
					append using `cob'
					
					contract cob
					drop _freq

				
				*tab cobfcddl,m sort
				*label list cobfcddl //Compare to ABS data source - Australiand Standard Classification of Cultural and Ethnic Groups
				
				gen cob_d = floor(cob/1000) //Take first 2 digit only
				*tab cob_d ,m
		
					/*		  cob_d |      Freq.     Percent        Cum.
						------------+-----------------------------------
								  0 |         #
								 11 |     #								OCEANIAN
								 12 |        #
								 13 |         #
								 15 |        #
								 21 |      #							NORTH WEST EUROPEAN
								 22 |        #
								 23 |        #
								 24 |         #
								 31 |        #							SOUTHERN AND EASTERN EUROPEAN
								 32 |        #
								 33 |        #
								 41 |        #							NORTH AFRICAN AND MIDDLE EASTERN
								 42 |        #
								 51 |       #							SEA
								 52 |        #
								 61 |        #							NEA
								 62 |        #
								 71 |        #							S&CA
								 72 |         #		
								 81 |        #							AMERICAS
								 82 |        #
								 83 |         #
								 84 |          #
								 91 |         #							AFRICA
								 92 |        #
						------------+-----------------------------------
							  Total |    #      100.00			
							  
							  Approximately #% European, #% Asian, #% Pacific, so not an appropriate category. 
							  
							  */
							  
					tab cob_d ,m		  

					/*		  cob_d |      Freq.     Percent        Cum.
						------------+-----------------------------------
								  0 |         #
								  1 |        #									OCEANIAN
								  2 |        #									NORTH WEST EUROPEAN
								  3 |         #									SOUTHERN AND EASTERN EUROPEAN
								  4 |         #									NORTH AFRICAN AND MIDDLE EASTERN
								  5 |        #									SEA
								  6 |         #									NEA
								  7 |         #									S&CA
								  8 |         #									AMERICAS
								  9 |         #									AFRICA
						------------+-----------------------------------
							  Total |        170      100.00					*/
													
							
						
						label define cob 1 "Oceanian" 2 "North West European" 3 "Southern and Eastern European" 4 "North African and Middle Eastern" ///
							5 "Sout East Asian" 6 "North East Asian" 7 "Southern and Central Asian" 8 "Americas" 9 "Africa",replace
							
						label values cob_d cob
						tab cob_d,m

						/*							   cob_d |      Freq.     Percent        Cum.
							---------------------------------+-----------------------------------
														   0 |          #
													Oceanian |         #
										 North West European |         #
							   Southern and Eastern European |        #
							North African and Middle Eastern |        #
											 Sout East Asian |         #
											North East Asian |         #
								  Southern and Central Asian |         #
													Americas |         #
													  Africa |         #
							---------------------------------+-----------------------------------
													   Total |        #      100.00			*/
						
						
						*European Flag
						gen European = 0
							replace European = 1 if cob_d == 2 | cob_d == 3
						
		
						*Asian Flag
						gen Asian = 0
							replace Asian = 1 if cob_d == 5 | cob_d == 6 | cob_d == 7
		
		
						bys cob_d: tab cob,m
						
						tab cob if European == 1,m //looks good
						
						tab cob if Asian == 1,m //looks good
		
		
						*Create father and mother's place of birth
							gen cobmcddl = cob
							gen cobfcddl = cob 
		
						*Save file for merging
							save "P:\2_Data\0_NHS_Ancestry.dta",replace
		
		
							@@@ LE FIN @@@
				
				
							
				
				